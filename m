Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 27/97] ath9k_hw: add common channel select helpers for ar900[23]
Date: Wed, 14 Apr 2010 23:29:41 -0400
Message-Id: <1271302251-9075-28-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    4 ++--
 drivers/net/wireless/ath/ath9k/phy.h        |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 87541a8..1f8ac0a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -83,7 +83,7 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		bMode = 1;
 		fracMode = 1;
 		aModeRefSel = 0;
-		channelSel = (freq * 0x10000) / 15;
+		channelSel = CHANSEL_2G(freq);
 
 		if (AR_SREV_9287_11_OR_LATER(ah)) {
 			if (freq == 2484) {
@@ -126,7 +126,7 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			 */
 			fracMode = 1;
 			refDivA = 1;
-			channelSel = (freq * 0x8000) / 15;
+			channelSel = CHANSEL_5G(freq);
 
 			/* RefDivA setting */
 			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index b908152..7d397fd 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -17,6 +17,10 @@
 #ifndef PHY_H
 #define PHY_H
 
+#define CHANSEL_DIV		15
+#define CHANSEL_2G(_freq)	(((_freq) * 0x10000) / CHANSEL_DIV)
+#define CHANSEL_5G(_freq)	(((_freq) * 0x8000) / CHANSEL_DIV)
+
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
 
-- 
1.6.3.3

