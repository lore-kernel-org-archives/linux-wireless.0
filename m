Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35350 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLRJGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:12 -0500
Received: by mail-ob0-f174.google.com with SMTP id nt9so2616640obb.5
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:12 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 16/16] rtlwifi: rtl8821ae: Switch to use common rate control routine
Date: Thu, 18 Dec 2014 03:05:40 -0600
Message-Id: <1418893540-19944-17-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100712_700847_E66A7F2F)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this change, all of the drivers now use the common routine. As this
driver has VHT capability, an additional parameter is needed, thus all the
drivers had to be modified.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c          |  76 ++++++++-
 drivers/net/wireless/rtlwifi/base.h          |   4 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c |   2 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c | 232 +--------------------------
 11 files changed, 88 insertions(+), 242 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 23fc51e..1d46774 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -881,12 +881,84 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw,
  * N rate:
  * (rx_status->flag & RX_FLAG_HT) = 1,
  * DESC_RATEMCS0-->DESC_RATEMCS15 ==> idx is 0-->15
+ *
+ * VHT rates:
+ * DESC_RATEVHT1SS_MCS0-->DESC_RATEVHT1SS_MCS9 ==> idx is 0-->9
+ * DESC_RATEVHT2SS_MCS0-->DESC_RATEVHT2SS_MCS9 ==> idx is 0-->9
  */
-int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
-			 bool isht, u8 desc_rate)
+int rtlwifi_rate_mapping(struct ieee80211_hw *hw, bool isht, bool isvht,
+			 u8 desc_rate)
 {
 	int rate_idx;
 
+	if (isvht) {
+		switch (desc_rate) {
+		case DESC_RATEVHT1SS_MCS0:
+			rate_idx = 0;
+			break;
+		case DESC_RATEVHT1SS_MCS1:
+			rate_idx = 1;
+			break;
+		case DESC_RATEVHT1SS_MCS2:
+			rate_idx = 2;
+			break;
+		case DESC_RATEVHT1SS_MCS3:
+			rate_idx = 3;
+			break;
+		case DESC_RATEVHT1SS_MCS4:
+			rate_idx = 4;
+			break;
+		case DESC_RATEVHT1SS_MCS5:
+			rate_idx = 5;
+			break;
+		case DESC_RATEVHT1SS_MCS6:
+			rate_idx = 6;
+			break;
+		case DESC_RATEVHT1SS_MCS7:
+			rate_idx = 7;
+			break;
+		case DESC_RATEVHT1SS_MCS8:
+			rate_idx = 8;
+			break;
+		case DESC_RATEVHT1SS_MCS9:
+			rate_idx = 9;
+			break;
+		case DESC_RATEVHT2SS_MCS0:
+			rate_idx = 0;
+			break;
+		case DESC_RATEVHT2SS_MCS1:
+			rate_idx = 1;
+			break;
+		case DESC_RATEVHT2SS_MCS2:
+			rate_idx = 2;
+			break;
+		case DESC_RATEVHT2SS_MCS3:
+			rate_idx = 3;
+			break;
+		case DESC_RATEVHT2SS_MCS4:
+			rate_idx = 4;
+			break;
+		case DESC_RATEVHT2SS_MCS5:
+			rate_idx = 5;
+			break;
+		case DESC_RATEVHT2SS_MCS6:
+			rate_idx = 6;
+			break;
+		case DESC_RATEVHT2SS_MCS7:
+			rate_idx = 7;
+			break;
+		case DESC_RATEVHT2SS_MCS8:
+			rate_idx = 8;
+			break;
+		case DESC_RATEVHT2SS_MCS9:
+			rate_idx = 9;
+			break;
+		default:
+			rate_idx = 0;
+			break;
+		}
+		return rate_idx;
+	}
 	if (false == isht) {
 		if (IEEE80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
 			switch (desc_rate) {
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 936c2bb..c6cb49c 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -123,8 +123,8 @@ void rtl_watch_dog_timer_callback(unsigned long data);
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw);
 
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
-int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
-			 bool isht, u8 desc_rate);
+int rtlwifi_rate_mapping(struct ieee80211_hw *hw, bool isht,
+			 bool isvht, u8 desc_rate);
 bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index d430884..791efbe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -473,7 +473,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 	 * Notice: this is diff with windows define
 	 */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, status->is_ht,
-						   status->rate);
+						   false, status->rate);
 
 	rx_status->mactime = status->timestamp_low;
 	if (phystatus == true) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 685faea..84ddd4d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -401,7 +401,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	 * Notice: this is diff with windows define
 	 */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
-						   stats->rate);
+						   false, stats->rate);
 
 	rx_status->mactime = stats->timestamp_low;
 	if (phystatus) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 5eccaba..cbead00 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -340,7 +340,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
-						   stats->rate);
+						   false, stats->rate);
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
@@ -407,7 +407,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 		rx_status->flag |= RX_FLAG_HT;
 	/* Data rate */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats.is_ht,
-						   stats.rate);
+						   false, stats.rate);
 	/*  There is a phy status after this rx descriptor. */
 	if (GET_RX_DESC_PHY_STATUS(rxdesc)) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(rxdesc + RTL_RX_DESC_SIZE);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 547c6d0..1feaa62 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -514,7 +514,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
-						   stats->rate);
+						   false, stats->rate);
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92d *)(skb->data +
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
index 3ea7367..51806ac 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
@@ -419,7 +419,7 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 	 * Notice: this is diff with windows define
 	 */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, status->is_ht,
-						   status->rate);
+						   false, status->rate);
 
 	rx_status->mactime = status->timestamp_low;
 	if (phystatus) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 95eebff..125b29b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -319,7 +319,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	}
 
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
-						   stats->rate);
+						   false, stats->rate);
 
 	rx_status->mactime = stats->timestamp_low;
 	if (phystatus) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index 662a094..2f7c144 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -346,7 +346,7 @@ bool rtl8723e_rx_query_desc(struct ieee80211_hw *hw,
 	 * Notice: this is diff with windows define
 	 */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, status->is_ht,
-						   status->rate);
+						   false, status->rate);
 
 	rx_status->mactime = status->timestamp_low;
 	if (phystatus == true) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
index cb23bed..338ec9a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
@@ -401,7 +401,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 	 * are use (RX_FLAG_HT)
 	 */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw, status->is_ht,
-						      status->rate);
+						   false, status->rate);
 
 	rx_status->mactime = status->timestamp_low;
 	if (phystatus) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
index 383b86b..72af4b9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
@@ -48,232 +48,6 @@ static u8 _rtl8821ae_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
-/* mac80211's rate_idx is like this:
- *
- * 2.4G band:rx_status->band == IEEE80211_BAND_2GHZ
- *
- * B/G rate:
- * (rx_status->flag & RX_FLAG_HT) = 0,
- * DESC_RATE1M-->DESC_RATE54M ==> idx is 0-->11,
- *
- * N rate:
- * (rx_status->flag & RX_FLAG_HT) = 1,
- * DESC_RATEMCS0-->DESC_RATEMCS15 ==> idx is 0-->15
- *
- * 5G band:rx_status->band == IEEE80211_BAND_5GHZ
- * A rate:
- * (rx_status->flag & RX_FLAG_HT) = 0,
- * DESC_RATE6M-->DESC_RATE54M ==> idx is 0-->7,
- *
- * N rate:
- * (rx_status->flag & RX_FLAG_HT) = 1,
- * DESC_RATEMCS0-->DESC_RATEMCS15 ==> idx is 0-->15
- */
-static int _rtl8821ae_rate_mapping(struct ieee80211_hw *hw,
-				   bool isht, bool isvht, u8 desc_rate)
-{
-	int rate_idx;
-
-	if (!isht) {
-		if (IEEE80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
-			switch (desc_rate) {
-			case DESC_RATE1M:
-				rate_idx = 0;
-				break;
-			case DESC_RATE2M:
-				rate_idx = 1;
-				break;
-			case DESC_RATE5_5M:
-				rate_idx = 2;
-				break;
-			case DESC_RATE11M:
-				rate_idx = 3;
-				break;
-			case DESC_RATE6M:
-				rate_idx = 4;
-				break;
-			case DESC_RATE9M:
-				rate_idx = 5;
-				break;
-			case DESC_RATE12M:
-				rate_idx = 6;
-				break;
-			case DESC_RATE18M:
-				rate_idx = 7;
-				break;
-			case DESC_RATE24M:
-				rate_idx = 8;
-				break;
-			case DESC_RATE36M:
-				rate_idx = 9;
-				break;
-			case DESC_RATE48M:
-				rate_idx = 10;
-				break;
-			case DESC_RATE54M:
-				rate_idx = 11;
-				break;
-			default:
-				rate_idx = 0;
-				break;
-			}
-		} else {
-			switch (desc_rate) {
-			case DESC_RATE6M:
-				rate_idx = 0;
-				break;
-			case DESC_RATE9M:
-				rate_idx = 1;
-				break;
-			case DESC_RATE12M:
-				rate_idx = 2;
-				break;
-			case DESC_RATE18M:
-				rate_idx = 3;
-				break;
-			case DESC_RATE24M:
-				rate_idx = 4;
-				break;
-			case DESC_RATE36M:
-				rate_idx = 5;
-				break;
-			case DESC_RATE48M:
-				rate_idx = 6;
-				break;
-			case DESC_RATE54M:
-				rate_idx = 7;
-				break;
-			default:
-				rate_idx = 0;
-				break;
-			}
-		}
-	} else {
-		switch (desc_rate) {
-		case DESC_RATEMCS0:
-			rate_idx = 0;
-			break;
-		case DESC_RATEMCS1:
-			rate_idx = 1;
-			break;
-		case DESC_RATEMCS2:
-			rate_idx = 2;
-			break;
-		case DESC_RATEMCS3:
-			rate_idx = 3;
-			break;
-		case DESC_RATEMCS4:
-			rate_idx = 4;
-			break;
-		case DESC_RATEMCS5:
-			rate_idx = 5;
-			break;
-		case DESC_RATEMCS6:
-			rate_idx = 6;
-			break;
-		case DESC_RATEMCS7:
-			rate_idx = 7;
-			break;
-		case DESC_RATEMCS8:
-			rate_idx = 8;
-			break;
-		case DESC_RATEMCS9:
-			rate_idx = 9;
-			break;
-		case DESC_RATEMCS10:
-			rate_idx = 10;
-			break;
-		case DESC_RATEMCS11:
-			rate_idx = 11;
-			break;
-		case DESC_RATEMCS12:
-			rate_idx = 12;
-			break;
-		case DESC_RATEMCS13:
-			rate_idx = 13;
-			break;
-		case DESC_RATEMCS14:
-			rate_idx = 14;
-			break;
-		case DESC_RATEMCS15:
-			rate_idx = 15;
-			break;
-		default:
-			rate_idx = 0;
-			break;
-		}
-	}
-
-	if (isvht) {
-		switch (desc_rate) {
-		case DESC_RATEVHT1SS_MCS0:
-			rate_idx = 0;
-			break;
-		case DESC_RATEVHT1SS_MCS1:
-			rate_idx = 1;
-			break;
-		case DESC_RATEVHT1SS_MCS2:
-			rate_idx = 2;
-			break;
-		case DESC_RATEVHT1SS_MCS3:
-			rate_idx = 3;
-			break;
-		case DESC_RATEVHT1SS_MCS4:
-			rate_idx = 4;
-			break;
-		case DESC_RATEVHT1SS_MCS5:
-			rate_idx = 5;
-			break;
-		case DESC_RATEVHT1SS_MCS6:
-			rate_idx = 6;
-			break;
-		case DESC_RATEVHT1SS_MCS7:
-			rate_idx = 7;
-			break;
-		case DESC_RATEVHT1SS_MCS8:
-			rate_idx = 8;
-			break;
-		case DESC_RATEVHT1SS_MCS9:
-			rate_idx = 9;
-			break;
-		case DESC_RATEVHT2SS_MCS0:
-			rate_idx = 0;
-			break;
-		case DESC_RATEVHT2SS_MCS1:
-			rate_idx = 1;
-			break;
-		case DESC_RATEVHT2SS_MCS2:
-			rate_idx = 2;
-			break;
-		case DESC_RATEVHT2SS_MCS3:
-			rate_idx = 3;
-			break;
-		case DESC_RATEVHT2SS_MCS4:
-			rate_idx = 4;
-			break;
-		case DESC_RATEVHT2SS_MCS5:
-			rate_idx = 5;
-			break;
-		case DESC_RATEVHT2SS_MCS6:
-			rate_idx = 6;
-			break;
-		case DESC_RATEVHT2SS_MCS7:
-			rate_idx = 7;
-			break;
-		case DESC_RATEVHT2SS_MCS8:
-			rate_idx = 8;
-			break;
-		case DESC_RATEVHT2SS_MCS9:
-			rate_idx = 9;
-			break;
-		default:
-			rate_idx = 0;
-			break;
-		}
-	}
-	return rate_idx;
-}
-
 static u16 odm_cfo(char value)
 {
 	int ret_val;
@@ -766,9 +540,9 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 	 * supported rates or MCS index if HT rates
 	 * are use (RX_FLAG_HT)
 	 */
-	rx_status->rate_idx =
-	  _rtl8821ae_rate_mapping(hw, status->is_ht,
-				  status->is_vht, status->rate);
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, status->is_ht,
+						   status->is_vht,
+						   status->rate);
 
 	rx_status->mactime = status->timestamp_low;
 	if (phystatus) {
-- 
2.1.2

