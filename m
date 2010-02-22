Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22543 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0BVGla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:30 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/22] wl1271: Clean up TX security sequence number handling
Date: Mon, 22 Feb 2010 08:38:40 +0200
Message-Id: <1266820722-20202-21-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of managing the TX security sequence number as two variables, use
one 64 bit variable. This greatly simplifies the handling of the number.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    6 ++++--
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    3 +--
 drivers/net/wireless/wl12xx/wl1271_main.c |   11 +++++------
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   10 ++--------
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 41de47c..0deb4fd 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -110,6 +110,9 @@ enum {
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
+#define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
+#define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
+
 /* NVS data structure */
 #define WL1271_NVS_SECTION_SIZE                  468
 
@@ -419,8 +422,7 @@ struct wl1271 {
 
 	/* Security sequence number counters */
 	u8 tx_security_last_seq;
-	u16 tx_security_seq_16;
-	u32 tx_security_seq_32;
+	s64 tx_security_seq;
 
 	/* FW Rx counter */
 	u32 rx_counter;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index e029bf0..d59b383 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -318,8 +318,7 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 
 	/* reset TX security counters */
 	wl->tx_security_last_seq = 0;
-	wl->tx_security_seq_16 = 0;
-	wl->tx_security_seq_32 = 0;
+	wl->tx_security_seq = 0;
 
 	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join), 0);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4c4d22a..f10ba84 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1020,8 +1020,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->tx_security_last_seq = 0;
-	wl->tx_security_seq_16 = 0;
-	wl->tx_security_seq_32 = 0;
+	wl->tx_security_seq = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -1428,15 +1427,15 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key_type = KEY_TKIP;
 
 		key_conf->hw_key_idx = key_conf->keyidx;
-		tx_seq_32 = wl->tx_security_seq_32;
-		tx_seq_16 = wl->tx_security_seq_16;
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
 		break;
 	case ALG_CCMP:
 		key_type = KEY_AES;
 
 		key_conf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		tx_seq_32 = wl->tx_security_seq_32;
-		tx_seq_16 = wl->tx_security_seq_16;
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
 		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->alg);
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index d3ed63e..1b11e2c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -303,7 +303,6 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 {
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
-	u16 seq;
 	int id = result->id;
 
 	/* check for id legality */
@@ -331,15 +330,10 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	wl->stats.retry_count += result->ack_failures;
 
 	/* update security sequence number */
-	seq = wl->tx_security_seq_16 +
-		(result->lsb_security_sequence_number -
-		 wl->tx_security_last_seq);
+	wl->tx_security_seq += (result->lsb_security_sequence_number -
+				wl->tx_security_last_seq);
 	wl->tx_security_last_seq = result->lsb_security_sequence_number;
 
-	if (seq < wl->tx_security_seq_16)
-		wl->tx_security_seq_32++;
-	wl->tx_security_seq_16 = seq;
-
 	/* remove private header from packet */
 	skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
 
-- 
1.6.3.3

