Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62696 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab1FSGFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 02:05:03 -0400
Received: by wyb38 with SMTP id 38so1034760wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 23:05:01 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Oz Krakowski <ozk@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/3] wl12xx: fix Tx security sequence number handling
Date: Sun, 19 Jun 2011 09:04:54 +0300
Message-Id: <1308463496-15522-1-git-send-email-arik@wizery.com> (sfid-20110619_080517_848541_3AC4ACED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oz Krakowski <ozk@ti.com>

Do not reset the security sequence number when issuing a join command or
interface is removed. Instead, reset the counter only during the unjoin
command.

Added the notion of counter wrap-around to the LSB number in
wl1271_tx_complete_packet.

Added post recovery padding to adjust for potential security number
progress during the recovery process by the firmware and avoid
potential interop issues in encrypted networks.

Signed-off-by: Oz Krakowski <ozk@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c     |    4 ----
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |   18 ++++++++++++++++--
 drivers/net/wireless/wl12xx/tx.c      |   22 ++++++++++++++++++----
 drivers/net/wireless/wl12xx/tx.h      |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   14 +++++++++++---
 6 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b3a4f58..0a9079e 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -395,10 +395,6 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 
 	join->ctrl |= wl->session_counter << WL1271_JOIN_CMD_TX_SESSION_OFFSET;
 
-	/* reset TX security counters */
-	wl->tx_security_last_seq = 0;
-	wl->tx_security_seq = 0;
-
 	wl1271_debug(DEBUG_CMD, "cmd join: basic_rate_set=0x%x, rate_set=0x%x",
 		join->basic_rate_set, join->supported_rate_set);
 
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index c3f19463..c52e61c 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -349,7 +349,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_INT(tx_blocks_freed[1]);
 	DRIVER_STATE_PRINT_INT(tx_blocks_freed[2]);
 	DRIVER_STATE_PRINT_INT(tx_blocks_freed[3]);
-	DRIVER_STATE_PRINT_INT(tx_security_last_seq);
+	DRIVER_STATE_PRINT_INT(tx_security_last_seq_lsb);
 	DRIVER_STATE_PRINT_INT(rx_counter);
 	DRIVER_STATE_PRINT_INT(session_counter);
 	DRIVER_STATE_PRINT_INT(state);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..547e5d9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1099,6 +1099,15 @@ static void wl1271_recovery_work(struct work_struct *work)
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
 		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
 
+	/*
+	 * Advance security sequence number to overcome potential progress
+	 * in the firmware during recovery. This doens't hurt if the network is
+	 * not encrypted.
+	 */
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+	    test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+		wl->tx_security_seq += WL1271_TX_SQN_POST_RECOVERY_PADDING;
+
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		ieee80211_connection_loss(wl->vif);
 
@@ -1834,8 +1843,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->tx_allocated_blocks = 0;
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
-	wl->tx_security_last_seq = 0;
-	wl->tx_security_seq = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -2008,6 +2015,10 @@ static int wl1271_unjoin(struct wl1271 *wl)
 	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
 	memset(wl->bssid, 0, ETH_ALEN);
 
+	/* reset TX security counters on a clean disconnect */
+	wl->tx_security_last_seq_lsb = 0;
+	wl->tx_security_seq = 0;
+
 	/* stop filtering packets based on bssid */
 	wl1271_configure_filters(wl, FIF_OTHER_BSS);
 
@@ -4106,6 +4117,9 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
+	wl->tx_security_seq = 0;
+	wl->tx_security_last_seq_lsb = 0;
+
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6603e60..6dab9c9 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -704,10 +704,24 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 
 	wl->stats.retry_count += result->ack_failures;
 
-	/* update security sequence number */
-	wl->tx_security_seq += (result->lsb_security_sequence_number -
-				wl->tx_security_last_seq);
-	wl->tx_security_last_seq = result->lsb_security_sequence_number;
+	/*
+	 * update sequence number only when relevant, i.e. only in
+	 * sessions of TKIP, AES and GEM (not in open or WEP sessions)
+	 */
+	if (info->control.hw_key &&
+	    (info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     info->control.hw_key->cipher == WLAN_CIPHER_SUITE_CCMP ||
+	     info->control.hw_key->cipher == WL1271_CIPHER_SUITE_GEM)) {
+		u8 fw_lsb = result->tx_security_sequence_number_lsb;
+		u8 cur_lsb = wl->tx_security_last_seq_lsb;
+
+		/*
+		 * update security sequence number, taking care of potential
+		 * wrap-around
+		 */
+		wl->tx_security_seq += (fw_lsb - cur_lsb + 0xFF) % 0xFF;
+		wl->tx_security_last_seq_lsb = fw_lsb;
+	}
 
 	/* remove private header from packet */
 	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 832f925..7ed3c01 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -150,7 +150,7 @@ struct wl1271_tx_hw_res_descr {
 	   (from 1st EDCA AIFS counter until TX Complete). */
 	__le32 medium_delay;
 	/* LS-byte of last TKIP seq-num (saved per AC for recovery). */
-	u8 lsb_security_sequence_number;
+	u8 tx_security_sequence_number_lsb;
 	/* Retry count - number of transmissions without successful ACK.*/
 	u8 ack_failures;
 	/* The rate that succeeded getting ACK
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1cafb08..daf6964 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -144,6 +144,7 @@ extern u32 wl12xx_debug_level;
 
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
+#define WL1271_TX_SQN_POST_RECOVERY_PADDING 0xff
 
 #define WL1271_CIPHER_SUITE_GEM 0x00147201
 
@@ -451,9 +452,16 @@ struct wl1271 {
 	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
 	int tx_frames_cnt;
 
-	/* Security sequence number counters */
-	u8 tx_security_last_seq;
-	s64 tx_security_seq;
+	/*
+	 * Security sequence number
+	 *     bits 0-15: lower 16 bits part of sequence number
+	 *     bits 16-47: higher 32 bits part of sequence number
+	 *     bits 48-63: not in use
+	 */
+	u64 tx_security_seq;
+
+	/* 8 bits of the last sequence number in use */
+	u8 tx_security_last_seq_lsb;
 
 	/* FW Rx counter */
 	u32 rx_counter;
-- 
1.7.4.1

