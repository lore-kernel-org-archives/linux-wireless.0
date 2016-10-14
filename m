Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754107AbcJNKUm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 06:20:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9EAK4at021712
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2016 03:20:41 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2615bubgeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2016 03:20:41 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: add power save parameters in hs_cfg cmd
Date: Fri, 14 Oct 2016 15:50:09 +0530
Message-ID: <1476440409-7227-1-git-send-email-akarwar@marvell.com> (sfid-20161014_122046_642252_7B995AC6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

This patch adds power save parameters(hs_wake_interval and
hs_inactivity_timeout) in host sleep cfg cmd.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h      | 10 +++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 29 ++++++++++++++++++++------
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 4b1894b..9b3ccea 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -181,6 +181,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_REPEAT_COUNT       (PROPRIETARY_TLV_BASE_ID + 176)
+#define TLV_TYPE_PS_PARAMS_IN_HS    (PROPRIETARY_TLV_BASE_ID + 181)
 #define TLV_TYPE_MULTI_CHAN_INFO    (PROPRIETARY_TLV_BASE_ID + 183)
 #define TLV_TYPE_MC_GROUP_INFO      (PROPRIETARY_TLV_BASE_ID + 184)
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
@@ -986,6 +987,15 @@ struct mwifiex_ps_param {
 	__le16 delay_to_ps;
 };
 
+#define HS_DEF_WAKE_INTERVAL          100
+#define HS_DEF_INACTIVITY_TIMEOUT      50
+
+struct mwifiex_ps_param_in_hs {
+	struct mwifiex_ie_types_header header;
+	__le32 hs_wake_int;
+	__le32 hs_inact_timeout;
+};
+
 #define BITMAP_AUTO_DS         0x01
 #define BITMAP_STA_PS          0x10
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index f2a7a13..b697b61 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -368,7 +368,10 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg = &cmd->params.opt_hs_cfg;
+	u8 *tlv = (u8 *)hs_cfg + sizeof(struct host_cmd_ds_802_11_hs_cfg_enh);
+	struct mwifiex_ps_param_in_hs *psparam_tlv = NULL;
 	bool hs_activate = false;
+	u16 size;
 
 	if (!hscfg_param)
 		/* New Activate command */
@@ -385,13 +388,14 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		memcpy(((u8 *) hs_cfg) +
 		       sizeof(struct host_cmd_ds_802_11_hs_cfg_enh),
 		       adapter->arp_filter, adapter->arp_filter_size);
-		cmd->size = cpu_to_le16
-				(adapter->arp_filter_size +
-				 sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
-				+ S_DS_GEN);
+		size = adapter->arp_filter_size +
+			sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
+			+ S_DS_GEN;
+		tlv = (u8 *)hs_cfg
+			+ sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
+			+ adapter->arp_filter_size;
 	} else {
-		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(struct
-						host_cmd_ds_802_11_hs_cfg_enh));
+		size = S_DS_GEN + sizeof(struct host_cmd_ds_802_11_hs_cfg_enh);
 	}
 	if (hs_activate) {
 		hs_cfg->action = cpu_to_le16(HS_ACTIVATE);
@@ -401,12 +405,25 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		hs_cfg->params.hs_config.conditions = hscfg_param->conditions;
 		hs_cfg->params.hs_config.gpio = hscfg_param->gpio;
 		hs_cfg->params.hs_config.gap = hscfg_param->gap;
+
+		size += sizeof(struct mwifiex_ps_param_in_hs);
+		psparam_tlv = (struct mwifiex_ps_param_in_hs *)tlv;
+		psparam_tlv->header.type =
+			cpu_to_le16(TLV_TYPE_PS_PARAMS_IN_HS);
+		psparam_tlv->header.len =
+			cpu_to_le16(sizeof(struct mwifiex_ps_param_in_hs)
+				- sizeof(struct mwifiex_ie_types_header));
+		psparam_tlv->hs_wake_int = cpu_to_le32(HS_DEF_WAKE_INTERVAL);
+		psparam_tlv->hs_inact_timeout =
+			cpu_to_le32(HS_DEF_INACTIVITY_TIMEOUT);
+
 		mwifiex_dbg(adapter, CMD,
 			    "cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
 			    hs_cfg->params.hs_config.conditions,
 			    hs_cfg->params.hs_config.gpio,
 			    hs_cfg->params.hs_config.gap);
 	}
+	cmd->size = cpu_to_le16(size);
 
 	return 0;
 }
-- 
1.9.1
