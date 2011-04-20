Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1DTJA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 05:00:58 -0400
Received: by pzk9 with SMTP id 9so284555pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 02:00:57 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19886.41312.953407.161944@gargle.gargle.HOWL>
Date: Wed, 20 Apr 2011 14:33:28 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 2/5] ath9k_htc: Fix AMPDU subframe handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

* Register the driver's maximum ampdu subframe limit to mac80211.
* Cleanup the target capabilities structure and fix an endian issue.
* Fix BTCOEX by sending a command to the target when the BT priority
  changes.
* Bump the required firmware version to 1.1

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
v2: Add more strict version checks.

 drivers/net/wireless/ath/ath9k/hif_usb.h      |    3 +++
 drivers/net/wireless/ath/ath9k/htc.h          |   14 +++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    6 ++----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   15 ++++++---------
 5 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index f59df48..9a52ccc 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -17,6 +17,9 @@
 #ifndef HTC_USB_H
 #define HTC_USB_H
 
+#define MAJOR_VERSION_REQ 1
+#define MINOR_VERSION_REQ 1
+
 #define IS_AR7010_DEVICE(_v) (((_v) == AR9280_USB) || ((_v) == AR9287_USB))
 
 #define AR9271_FIRMWARE       0x501000
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 48a8855..af90829 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -106,15 +106,14 @@ struct tx_beacon_header {
 	u16 rev;
 } __packed;
 
+#define MAX_TX_AMPDU_SUBFRAMES_9271 17
+#define MAX_TX_AMPDU_SUBFRAMES_7010 22
+
 struct ath9k_htc_cap_target {
-	u32 flags;
-	u32 flags_ext;
-	u32 ampdu_limit;
+	__be32 ampdu_limit;
 	u8 ampdu_subframes;
+	u8 enable_coex;
 	u8 tx_chainmask;
-	u8 tx_chainmask_legacy;
-	u8 rtscts_ratecode;
-	u8 protmode;
 	u8 pad;
 } __packed;
 
@@ -551,7 +550,8 @@ void ath9k_htc_txep(void *priv, struct sk_buff *skb, enum htc_endpoint_id ep_id,
 void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 			enum htc_endpoint_id ep_id, bool txok);
 
-int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv);
+int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv,
+				u8 enable_coex);
 void ath9k_htc_station_work(struct work_struct *work);
 void ath9k_htc_aggr_work(struct work_struct *work);
 void ath9k_htc_ani_work(struct work_struct *work);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 138f8e1..d051a42 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -65,15 +65,13 @@ static void ath_btcoex_period_work(struct work_struct *work)
 	u32 timer_period;
 	bool is_btscan;
 	int ret;
-	u8 cmd_rsp, aggr;
 
 	ath_detect_bt_priority(priv);
 
 	is_btscan = !!(priv->op_flags & OP_BT_SCAN);
 
-	aggr = priv->op_flags & OP_BT_PRIORITY_DETECTED;
-
-	WMI_CMD_BUF(WMI_AGGR_LIMIT_CMD, &aggr);
+	ret = ath9k_htc_update_cap_target(priv,
+				  !!(priv->op_flags & OP_BT_PRIORITY_DETECTED));
 	if (ret) {
 		ath_err(common, "Unable to set BTCOEX parameters\n");
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 06e043b..dbf5f95 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -753,6 +753,12 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	hw->queues = 4;
 	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 10;
+
+	if (AR_SREV_9271(priv->ah))
+		hw->max_tx_aggregation_subframes = MAX_TX_AMPDU_SUBFRAMES_9271;
+	else
+		hw->max_tx_aggregation_subframes = MAX_TX_AMPDU_SUBFRAMES_7010;
+
 	hw->vif_data_size = sizeof(struct ath9k_htc_vif);
 	hw->sta_data_size = sizeof(struct ath9k_htc_sta);
 
@@ -802,6 +808,17 @@ static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
 		 priv->fw_version_major,
 		 priv->fw_version_minor);
 
+	/*
+	 * Check if the available FW matches the driver's
+	 * required version.
+	 */
+	if (priv->fw_version_major != MAJOR_VERSION_REQ ||
+	    priv->fw_version_minor != MINOR_VERSION_REQ) {
+		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
+			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7cff554..a640268 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -563,7 +563,8 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 	return 0;
 }
 
-int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
+int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv,
+				u8 enable_coex)
 {
 	struct ath9k_htc_cap_target tcap;
 	int ret;
@@ -571,13 +572,9 @@ int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
 
 	memset(&tcap, 0, sizeof(struct ath9k_htc_cap_target));
 
-	/* FIXME: Values are hardcoded */
-	tcap.flags = 0x240c40;
-	tcap.flags_ext = 0x80601000;
-	tcap.ampdu_limit = 0xffff0000;
-	tcap.ampdu_subframes = 20;
-	tcap.tx_chainmask_legacy = priv->ah->caps.tx_chainmask;
-	tcap.protmode = 1;
+	tcap.ampdu_limit = cpu_to_be32(0xffff);
+	tcap.ampdu_subframes = priv->hw->max_tx_aggregation_subframes;
+	tcap.enable_coex = enable_coex;
 	tcap.tx_chainmask = priv->ah->caps.tx_chainmask;
 
 	WMI_CMD_BUF(WMI_TARGET_IC_UPDATE_CMDID, &tcap);
@@ -936,7 +933,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ath9k_host_rx_init(priv);
 
-	ret = ath9k_htc_update_cap_target(priv);
+	ret = ath9k_htc_update_cap_target(priv, 0);
 	if (ret)
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Failed to update capability in target\n");
-- 
1.7.4.4

