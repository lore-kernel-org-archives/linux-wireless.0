Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49155 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZJVShI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:08 -0400
Date: Thu, 22 Oct 2009 20:20:29 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 11/28] mwl8k: report rate and other information for received frames
Message-ID: <20091022182029.GM1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving a frame, report the antenna info, long/short preamble
status, 20/40 MHz flag, long/short guard interval status, MCS/legacy
rate status, and MCS/legacy rate index to the stack.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8931be9..7462fca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -168,7 +168,7 @@ struct mwl8k_priv {
 	/* PHY parameters */
 	struct ieee80211_supported_band band;
 	struct ieee80211_channel channels[14];
-	struct ieee80211_rate rates[12];
+	struct ieee80211_rate rates[13];
 
 	bool radio_on;
 	bool radio_short_preamble;
@@ -207,7 +207,7 @@ struct mwl8k_vif {
 	 * Subset of supported legacy rates.
 	 * Intersection of AP and STA supported rates.
 	 */
-	struct ieee80211_rate legacy_rates[12];
+	struct ieee80211_rate legacy_rates[13];
 
 	/* number of supported legacy rates */
 	u8	legacy_nrates;
@@ -239,9 +239,10 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 	{ .bitrate = 10, .hw_value = 2, },
 	{ .bitrate = 20, .hw_value = 4, },
 	{ .bitrate = 55, .hw_value = 11, },
+	{ .bitrate = 110, .hw_value = 22, },
+	{ .bitrate = 220, .hw_value = 44, },
 	{ .bitrate = 60, .hw_value = 12, },
 	{ .bitrate = 90, .hw_value = 18, },
-	{ .bitrate = 110, .hw_value = 22, },
 	{ .bitrate = 120, .hw_value = 24, },
 	{ .bitrate = 180, .hw_value = 36, },
 	{ .bitrate = 240, .hw_value = 48, },
@@ -600,7 +601,7 @@ struct ewc_ht_info {
 /* Peer Entry flags - used to define the type of the peer node */
 #define MWL8K_PEER_TYPE_ACCESSPOINT	2
 
-#define MWL8K_IEEE_LEGACY_DATA_RATES	12
+#define MWL8K_IEEE_LEGACY_DATA_RATES	13
 #define MWL8K_MCS_BITMAP_SIZE		16
 
 struct peer_capability_info {
@@ -750,6 +751,13 @@ struct mwl8k_rx_desc {
 #define MWL8K_RX_DESCS		256
 #define MWL8K_RX_MAXSZ		3800
 
+#define RATE_INFO_SHORTPRE		0x8000
+#define RATE_INFO_ANTSELECT(x)		(((x) >> 11) & 0x3)
+#define RATE_INFO_RATEID(x)		(((x) >> 3) & 0x3f)
+#define RATE_INFO_40MHZ			0x0004
+#define RATE_INFO_SHORTGI		0x0002
+#define RATE_INFO_MCS_FORMAT		0x0001
+
 static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -906,6 +914,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		struct ieee80211_rx_status status;
 		unsigned long addr;
 		struct ieee80211_hdr *wh;
+		u16 rate_info;
 
 		rx_desc = rxq->rx_desc_area + rxq->rx_head;
 		if (!(rx_desc->rx_ctrl & MWL8K_RX_CTRL_OWNED_BY_HOST))
@@ -937,14 +946,24 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		if (mwl8k_capture_bssid(priv, wh))
 			mwl8k_save_beacon(hw, skb);
 
+		rate_info = le16_to_cpu(rx_desc->rate_info);
+
 		memset(&status, 0, sizeof(status));
 		status.mactime = 0;
 		status.signal = -rx_desc->rssi;
 		status.noise = -rx_desc->noise_level;
 		status.qual = rx_desc->link_quality;
-		status.antenna = 1;
-		status.rate_idx = 1;
+		status.antenna = RATE_INFO_ANTSELECT(rate_info);
+		status.rate_idx = RATE_INFO_RATEID(rate_info);
 		status.flag = 0;
+		if (rate_info & RATE_INFO_SHORTPRE)
+			status.flag |= RX_FLAG_SHORTPRE;
+		if (rate_info & RATE_INFO_40MHZ)
+			status.flag |= RX_FLAG_40MHZ;
+		if (rate_info & RATE_INFO_SHORTGI)
+			status.flag |= RX_FLAG_SHORT_GI;
+		if (rate_info & RATE_INFO_MCS_FORMAT)
+			status.flag |= RX_FLAG_HT;
 		status.band = IEEE80211_BAND_2GHZ;
 		status.freq = ieee80211_channel_to_frequency(rx_desc->channel);
 		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
-- 
1.5.6.4
