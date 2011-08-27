Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44641 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1H0IZi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 04:25:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, rmanohar@qca.qualcomm.com
Subject: [PATCH] ath9k: fix regression in sending aggregated packets
Date: Sat, 27 Aug 2011 10:25:27 +0200
Message-Id: <1314433527-71007-1-git-send-email-nbd@openwrt.org> (sfid-20110827_102547_970791_56B4120B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent commit "ath9k: Send legacy rated frames as unaggregated"
introduced a check to ensure that packets with non-MCS rates set in
the rate series will not be aggregated. However, it failed to check
if the rate series is valid before testing the flags, thus breaking
aggregation for normal MCS-only packets if the last series is unset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5e29829..ac393a6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -582,7 +582,10 @@ static bool ath_lookup_legacy(struct ath_buf *bf)
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
 
-	for (i = 3; i >= 0; i--) {
+	for (i = 0; i < 4; i++) {
+		if (!rates[i].count || rates[i].idx < 0)
+			break;
+
 		if (!(rates[i].flags & IEEE80211_TX_RC_MCS))
 			return true;
 	}
-- 
1.7.3.2

