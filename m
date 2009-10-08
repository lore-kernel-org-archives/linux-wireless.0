Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23066 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbZJHS6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:32 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/20] wl1271: Corrections to TX path
Date: Thu,  8 Oct 2009 21:56:26 +0300
Message-Id: <1255028196-6565-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Corrections to the TX path - use correct number of maximum descriptors
(32 instead of 16) and correct checking and setting of excessive retries
on completion.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    4 +++-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    1 -
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +---
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    8 +++-----
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 05eb29c..0b4744d 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -123,6 +123,8 @@ enum {
 #define WL1271_DEFAULT_BEACON_INT  100
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
+#define ACX_TX_DESCRIPTORS    32
+
 enum wl1271_state {
 	WL1271_STATE_OFF,
 	WL1271_STATE_ON,
@@ -346,7 +348,7 @@ struct wl1271 {
 	struct work_struct filter_work;
 
 	/* Pending TX frames */
-	struct sk_buff *tx_frames[16];
+	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
 
 	/* Security sequence number counters */
 	u8 tx_security_last_seq;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 55850eb..c177345 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -170,7 +170,6 @@ enum {
 #define  DP_RX_PACKET_RING_CHUNK_NUM 2
 #define  DP_TX_PACKET_RING_CHUNK_NUM 2
 #define  DP_TX_COMPLETE_TIME_OUT 20
-#define  FW_TX_CMPLT_BLOCK_SIZE 16
 
 #define TX_MSDU_LIFETIME_MIN       0
 #define TX_MSDU_LIFETIME_MAX       3000
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6e35fcf..0a0f2ea 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1293,9 +1293,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 	wl->band = IEEE80211_BAND_2GHZ;
 
-	/* We use the default power on sleep time until we know which chip
-	 * we're using */
-	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
 
 	spin_lock_init(&wl->wl_lock);
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 1ad1bc3..5d3aa4b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -33,8 +33,7 @@
 static int wl1271_tx_id(struct wl1271 *wl, struct sk_buff *skb)
 {
 	int i;
-
-	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] == NULL) {
 			wl->tx_frames[i] = skb;
 			return i;
@@ -262,14 +261,13 @@ out:
 static void wl1271_tx_complete_packet(struct wl1271 *wl,
 				      struct wl1271_tx_hw_res_descr *result)
 {
-
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 	u16 seq;
 	int id = result->id;
 
 	/* check for id legality */
-	if (id >= TX_HW_RESULT_QUEUE_LEN || wl->tx_frames[id] == NULL) {
+	if (id >= ACX_TX_DESCRIPTORS || wl->tx_frames[id] == NULL) {
 		wl1271_warning("TX result illegal id: %d", id);
 		return;
 	}
@@ -382,7 +380,7 @@ void wl1271_tx_flush(struct wl1271 *wl)
 		ieee80211_tx_status(wl->hw, skb);
 	}
 
-	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] != NULL) {
 			skb = wl->tx_frames[i];
 			info = IEEE80211_SKB_CB(skb);
-- 
1.5.6.5

