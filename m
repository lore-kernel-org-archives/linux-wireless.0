Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40569 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332Ab2GCRO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:59 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 14/20] ath9k: fix RF channel frequency configuration for AR9550
Date: Tue,  3 Jul 2012 19:13:28 +0200
Message-Id: <1341335614-15419-15-git-send-email-juhosg@openwrt.org> (sfid-20120703_192128_688591_EE21C8FD)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 70ada2e..d2346db 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -99,7 +99,7 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = (freq * 4) / 120;
 			chan_frac = (((freq * 4) % 120) * 0x20000) / 120;
 			channelSel = (channelSel << 17) | chan_frac;
-		} else if (AR_SREV_9340(ah)) {
+		} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
 			if (ah->is_clk_25mhz) {
 				u32 chan_frac;
 
@@ -113,7 +113,8 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
-		if (AR_SREV_9340(ah) && ah->is_clk_25mhz) {
+		if ((AR_SREV_9340(ah) || AR_SREV_9550(ah)) &&
+		    ah->is_clk_25mhz) {
 			u32 chan_frac;
 
 			channelSel = (freq * 2) / 75;
-- 
1.7.2.1

