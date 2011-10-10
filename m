Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JJIMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:53 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so8786663wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/29] wl12xx: move tx_security_seq into wlvif
Date: Mon, 10 Oct 2011 10:12:58 +0200
Message-Id: <1318234397-21081-11-git-send-email-eliad@wizery.com> (sfid-20111010_101255_396042_0413E544)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last security seq num has to be saved across reconfigs.
Add a new "persistent" struct into wlvif, which won't get
deleted on wl12xx_init_vif_data()

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    1 -
 drivers/net/wireless/wl12xx/main.c    |   32 +++++++++++++++++---------------
 drivers/net/wireless/wl12xx/tx.c      |   12 +++++++++---
 drivers/net/wireless/wl12xx/wl12xx.h  |   30 +++++++++++++++++++-----------
 4 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index bbc8004..669b081 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -346,7 +346,6 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(tx_results_count);
 	DRIVER_STATE_PRINT_LHEX(flags);
 	DRIVER_STATE_PRINT_INT(tx_blocks_freed);
-	DRIVER_STATE_PRINT_INT(tx_security_last_seq_lsb);
 	DRIVER_STATE_PRINT_INT(rx_counter);
 	DRIVER_STATE_PRINT_INT(state);
 	DRIVER_STATE_PRINT_INT(channel);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0623f5d..055e70a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1206,6 +1206,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 {
 	struct wl1271 *wl =
 		container_of(work, struct wl1271, recovery_work);
+	struct wl12xx_vif *wlvif;
 
 	mutex_lock(&wl->mutex);
 
@@ -1227,9 +1228,12 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 * in the firmware during recovery. This doens't hurt if the network is
 	 * not encrypted.
 	 */
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
-	    test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
-		wl->tx_security_seq += WL1271_TX_SQN_POST_RECOVERY_PADDING;
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+		    test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+			wlvif->tx_security_seq +=
+				WL1271_TX_SQN_POST_RECOVERY_PADDING;
+	}
 
 	/* Prevent spurious TX during FW restart */
 	ieee80211_stop_queues(wl->hw);
@@ -1910,8 +1914,8 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 
-	/* make sure wlvif is zeroed */
-	memset(wlvif, 0, sizeof(*wlvif));
+	/* clear everything but the persistent data */
+	memset(wlvif, 0, offsetof(struct wl12xx_vif, persistent));
 
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2287,8 +2291,8 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out;
 
 	/* reset TX security counters on a clean disconnect */
-	wl->tx_security_last_seq_lsb = 0;
-	wl->tx_security_seq = 0;
+	wlvif->tx_security_last_seq_lsb = 0;
+	wlvif->tx_security_seq = 0;
 
 out:
 	return ret;
@@ -2860,20 +2864,20 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key_type = KEY_TKIP;
 
 		key_conf->hw_key_idx = key_conf->keyidx;
-		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
-		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = KEY_AES;
 
 		key_conf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
-		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
 	case WL1271_CIPHER_SUITE_GEM:
 		key_type = KEY_GEM;
-		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
-		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(wlvif->tx_security_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(wlvif->tx_security_seq);
 		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
@@ -4913,8 +4917,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
-	wl->tx_security_seq = 0;
-	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index c7be151..0a5fef5 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -755,6 +755,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 				      struct wl1271_tx_hw_res_descr *result)
 {
 	struct ieee80211_tx_info *info;
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
 	struct sk_buff *skb;
 	int id = result->id;
 	int rate = -1;
@@ -774,6 +776,10 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 		return;
 	}
 
+	/* info->control is valid as long as we don't update info->status */
+	vif = info->control.vif;
+	wlvif = wl12xx_vif_to_data(vif);
+
 	/* update the TX status info */
 	if (result->status == TX_SUCCESS) {
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -801,14 +807,14 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	     info->control.hw_key->cipher == WLAN_CIPHER_SUITE_CCMP ||
 	     info->control.hw_key->cipher == WL1271_CIPHER_SUITE_GEM)) {
 		u8 fw_lsb = result->tx_security_sequence_number_lsb;
-		u8 cur_lsb = wl->tx_security_last_seq_lsb;
+		u8 cur_lsb = wlvif->tx_security_last_seq_lsb;
 
 		/*
 		 * update security sequence number, taking care of potential
 		 * wrap-around
 		 */
-		wl->tx_security_seq += (fw_lsb - cur_lsb + 256) % 256;
-		wl->tx_security_last_seq_lsb = fw_lsb;
+		wlvif->tx_security_seq += (fw_lsb - cur_lsb + 256) % 256;
+		wlvif->tx_security_last_seq_lsb = fw_lsb;
 	}
 
 	/* remove private header from packet */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b13f13e..f12b394 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -435,17 +435,6 @@ struct wl1271 {
 	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
 	int tx_frames_cnt;
 
-	/*
-	 * Security sequence number
-	 *     bits 0-15: lower 16 bits part of sequence number
-	 *     bits 16-47: higher 32 bits part of sequence number
-	 *     bits 48-63: not in use
-	 */
-	u64 tx_security_seq;
-
-	/* 8 bits of the last sequence number in use */
-	u8 tx_security_last_seq_lsb;
-
 	/* FW Rx counter */
 	u32 rx_counter;
 
@@ -643,6 +632,25 @@ struct wl12xx_vif {
 	/* RX BA constraint value */
 	bool ba_support;
 	bool ba_allowed;
+
+	/*
+	 * This struct must be last!
+	 * data that has to be saved acrossed reconfigs (e.g. recovery)
+	 * should be declared in this struct.
+	 */
+	struct {
+		u8 persistent[0];
+		/*
+		 * Security sequence number
+		 *     bits 0-15: lower 16 bits part of sequence number
+		 *     bits 16-47: higher 32 bits part of sequence number
+		 *     bits 48-63: not in use
+		 */
+		u64 tx_security_seq;
+
+		/* 8 bits of the last sequence number in use */
+		u8 tx_security_last_seq_lsb;
+	};
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

