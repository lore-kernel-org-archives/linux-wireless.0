Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62589 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaLRJGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:06 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp4so2334415obc.6
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:05 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 09/16] rtlwifi: rtl8188ee: Switch to use common rate-mapping routine
Date: Thu, 18 Dec 2014 03:05:33 -0600
Message-Id: <1418893540-19944-10-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100631_434774_83F3C759)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver duplicates a routine found in the core.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c | 162 +--------------------------
 1 file changed, 2 insertions(+), 160 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index df549c9..d430884 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -47,164 +47,6 @@ static u8 _rtl88ee_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
-/* mac80211's rate_idx is like this:
- *
- * 2.4G band:rx_status->band == IEEE80211_BAND_2GHZ
- *
- * B/G rate:
- * (rx_status->flag & RX_FLAG_HT) = 0,
- * DESC92C_RATE1M-->DESC92C_RATE54M ==> idx is 0-->11,
- *
- * N rate:
- * (rx_status->flag & RX_FLAG_HT) = 1,
- * DESC92C_RATEMCS0-->DESC92C_RATEMCS15 ==> idx is 0-->15
- *
- * 5G band:rx_status->band == IEEE80211_BAND_5GHZ
- * A rate:
- * (rx_status->flag & RX_FLAG_HT) = 0,
- * DESC92C_RATE6M-->DESC92C_RATE54M ==> idx is 0-->7,
- *
- * N rate:
- * (rx_status->flag & RX_FLAG_HT) = 1,
- * DESC92C_RATEMCS0-->DESC92C_RATEMCS15 ==> idx is 0-->15
- */
-static int _rtl88ee_rate_mapping(struct ieee80211_hw *hw,
-				 bool isht, u8 desc_rate)
-{
-	int rate_idx;
-
-	if (!isht) {
-		if (IEEE80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
-			switch (desc_rate) {
-			case DESC92C_RATE1M:
-				rate_idx = 0;
-				break;
-			case DESC92C_RATE2M:
-				rate_idx = 1;
-				break;
-			case DESC92C_RATE5_5M:
-				rate_idx = 2;
-				break;
-			case DESC92C_RATE11M:
-				rate_idx = 3;
-				break;
-			case DESC92C_RATE6M:
-				rate_idx = 4;
-				break;
-			case DESC92C_RATE9M:
-				rate_idx = 5;
-				break;
-			case DESC92C_RATE12M:
-				rate_idx = 6;
-				break;
-			case DESC92C_RATE18M:
-				rate_idx = 7;
-				break;
-			case DESC92C_RATE24M:
-				rate_idx = 8;
-				break;
-			case DESC92C_RATE36M:
-				rate_idx = 9;
-				break;
-			case DESC92C_RATE48M:
-				rate_idx = 10;
-				break;
-			case DESC92C_RATE54M:
-				rate_idx = 11;
-				break;
-			default:
-				rate_idx = 0;
-				break;
-			}
-		} else {
-			switch (desc_rate) {
-			case DESC92C_RATE6M:
-				rate_idx = 0;
-				break;
-			case DESC92C_RATE9M:
-				rate_idx = 1;
-				break;
-			case DESC92C_RATE12M:
-				rate_idx = 2;
-				break;
-			case DESC92C_RATE18M:
-				rate_idx = 3;
-				break;
-			case DESC92C_RATE24M:
-				rate_idx = 4;
-				break;
-			case DESC92C_RATE36M:
-				rate_idx = 5;
-				break;
-			case DESC92C_RATE48M:
-				rate_idx = 6;
-				break;
-			case DESC92C_RATE54M:
-				rate_idx = 7;
-				break;
-			default:
-				rate_idx = 0;
-				break;
-			}
-		}
-	} else {
-		switch (desc_rate) {
-		case DESC92C_RATEMCS0:
-			rate_idx = 0;
-			break;
-		case DESC92C_RATEMCS1:
-			rate_idx = 1;
-			break;
-		case DESC92C_RATEMCS2:
-			rate_idx = 2;
-			break;
-		case DESC92C_RATEMCS3:
-			rate_idx = 3;
-			break;
-		case DESC92C_RATEMCS4:
-			rate_idx = 4;
-			break;
-		case DESC92C_RATEMCS5:
-			rate_idx = 5;
-			break;
-		case DESC92C_RATEMCS6:
-			rate_idx = 6;
-			break;
-		case DESC92C_RATEMCS7:
-			rate_idx = 7;
-			break;
-		case DESC92C_RATEMCS8:
-			rate_idx = 8;
-			break;
-		case DESC92C_RATEMCS9:
-			rate_idx = 9;
-			break;
-		case DESC92C_RATEMCS10:
-			rate_idx = 10;
-			break;
-		case DESC92C_RATEMCS11:
-			rate_idx = 11;
-			break;
-		case DESC92C_RATEMCS12:
-			rate_idx = 12;
-			break;
-		case DESC92C_RATEMCS13:
-			rate_idx = 13;
-			break;
-		case DESC92C_RATEMCS14:
-			rate_idx = 14;
-			break;
-		case DESC92C_RATEMCS15:
-			rate_idx = 15;
-			break;
-		default:
-			rate_idx = 0;
-			break;
-		}
-	}
-	return rate_idx;
-}
-
 static void _rtl88ee_query_rxphystatus(struct ieee80211_hw *hw,
 			struct rtl_stats *pstatus, u8 *pdesc,
 			struct rx_fwinfo_88e *p_drvinfo,
@@ -630,8 +472,8 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 	 * are use (RX_FLAG_HT)
 	 * Notice: this is diff with windows define
 	 */
-	rx_status->rate_idx = _rtl88ee_rate_mapping(hw,
-				status->is_ht, status->rate);
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, status->is_ht,
+						   status->rate);
 
 	rx_status->mactime = status->timestamp_low;
 	if (phystatus == true) {
-- 
2.1.2

