Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40381 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2GCROi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 10/20] ath9k: read spur frequency information from eeprom for AR9550
Date: Tue,  3 Jul 2012 19:13:24 +0200
Message-Id: <1341335614-15419-11-git-send-email-juhosg@openwrt.org> (sfid-20120703_192129_062265_605D440F)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 898ee14..70ada2e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -180,7 +180,8 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	 * is out-of-band and can be ignored.
 	 */
 
-	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah)) {
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
+	    AR_SREV_9550(ah)) {
 		if (spur_fbin_ptr[0] == 0) /* No spur */
 			return;
 		max_spur_cnts = 5;
@@ -205,7 +206,8 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 		if (AR_SREV_9462(ah) && (i == 0 || i == 3))
 			continue;
 		negative = 0;
-		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
+		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
+		    AR_SREV_9550(ah))
 			cur_bb_spur = ath9k_hw_fbin2freq(spur_fbin_ptr[i],
 							 IS_CHAN_2GHZ(chan));
 		else
-- 
1.7.2.1

