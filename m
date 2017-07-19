Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34919 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752847AbdGSGgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 02:36:33 -0400
Received: by mail-pg0-f66.google.com with SMTP id d193so5736515pgc.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 23:36:33 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: add tdls uapsd support module parameter
Date: Wed, 19 Jul 2017 06:36:27 +0000
Message-Id: <1500446187-8034-1-git-send-email-huxinming820@gmail.com> (sfid-20170719_083637_434280_206D3740)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Add module parameter to control tdls uapsd support, which is
default disabled.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/init.c    | 5 +++++
 drivers/net/wireless/marvell/mwifiex/main.h    | 1 +
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 8 +++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 3ecb59f..2cc8e54 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -25,6 +25,10 @@
 #include "wmm.h"
 #include "11n.h"
 
+static bool tdls_uapsd;
+module_param(tdls_uapsd, bool, 0000);
+MODULE_PARM_DESC(tdls_uapsd, "tdls uapsd support enable:1, disable:0");
+
 /*
  * This function adds a BSS priority table to the table list.
  *
@@ -154,6 +158,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->del_list_idx = 0;
 	priv->hs2_enabled = false;
 	priv->check_tdls_tx = false;
+	priv->tdls_uapsd_support = tdls_uapsd;
 	memcpy(priv->tos_to_tid_inv, tos_to_tid_inv, MAX_NUM_TID);
 
 	mwifiex_init_11h_params(priv);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f8cf307..ef5eac72 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -660,6 +660,7 @@ struct mwifiex_private {
 	u8 check_tdls_tx;
 	struct timer_list auto_tdls_timer;
 	bool auto_tdls_timer_active;
+	u8 tdls_uapsd_support;
 	struct idr ack_status_frames;
 	/* spin lock for ack status */
 	spinlock_t ack_status_lock;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 534d94a..d5da565 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1789,9 +1789,11 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 		put_unaligned_le16(params->capability, pos);
 		config_len += sizeof(params->capability);
 
-		qos_info = params->uapsd_queues | (params->max_sp << 5);
-		wmm_qos_info = (struct mwifiex_ie_types_qos_info *)(pos +
-								    config_len);
+		if (priv->tdls_uapsd_support)
+			qos_info = params->uapsd_queues | (params->max_sp << 5);
+		else
+			qos_info = 0;
+		wmm_qos_info = (void *)(pos + config_len);
 		wmm_qos_info->header.type = cpu_to_le16(WLAN_EID_QOS_CAPA);
 		wmm_qos_info->header.len = cpu_to_le16(sizeof(qos_info));
 		wmm_qos_info->qos_info = qos_info;
-- 
1.9.1
