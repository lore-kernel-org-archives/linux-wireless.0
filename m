Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53698 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388144AbeGWRFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:13 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 6/9] ath9k: report tx status on EOSP
Date: Mon, 23 Jul 2018 18:02:57 +0200
Message-Id: <20180723160300.58024-6-nbd@nbd.name> (sfid-20180723_180323_771028_AE9A9FAD)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes missed indications of end of U-APSD service period to mac80211

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 56a0d1b7527a..d366170f01cf 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -86,7 +86,8 @@ static void ath_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = info->status.status_driver_data[0];
 
-	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+	if (info->flags & (IEEE80211_TX_CTL_REQ_TX_STATUS |
+			   IEEE80211_TX_STATUS_EOSP)) {
 		ieee80211_tx_status(hw, skb);
 		return;
 	}
-- 
2.17.0
