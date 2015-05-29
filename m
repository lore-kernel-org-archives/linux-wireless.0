Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44603 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbbE2L1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:27:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4TBP2Sf008119
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 04:27:45 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5un9k-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 04:27:45 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv3 04/16] mwifiex: enable 11d after bss reset
Date: Fri, 29 May 2015 22:26:25 +0530
Message-ID: <1432918598-27769-5-git-send-email-patila@marvell.com> (sfid-20150529_132748_272893_CC398BBB)
In-Reply-To: <1432918598-27769-1-git-send-email-patila@marvell.com>
References: <1432918598-27769-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BSS reset would reset all state information in FW.
Issue 11d config command after reset to enabled 11d in FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 0a3297e..56a4768 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -806,6 +806,8 @@ void mwifiex_uap_set_channel(struct mwifiex_uap_bss_param *bss_cfg,
 int mwifiex_config_start_uap(struct mwifiex_private *priv,
 			     struct mwifiex_uap_bss_param *bss_cfg)
 {
+	enum state_11d_t state_11d;
+
 	if (mwifiex_del_mgmt_ies(priv))
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "Failed to delete mgmt IEs!\n");
@@ -830,6 +832,16 @@ int mwifiex_config_start_uap(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	/* Send cmd to FW to enable 11D function */
+	state_11d = ENABLE_11D;
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			     HostCmd_ACT_GEN_SET, DOT11D_I,
+			     &state_11d, true)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "11D: failed to enable 11D\n");
+		return -1;
+	}
+
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
 			     HostCmd_ACT_GEN_SET, 0, NULL, false)) {
 		mwifiex_dbg(priv->adapter, ERROR,
-- 
1.8.1.4

