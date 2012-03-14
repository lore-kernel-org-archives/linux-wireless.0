Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55431 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 09/14] ath9k_hw: fold ar9002_hw_cck_chan14_spread into mode regs initialization
Date: Wed, 14 Mar 2012 16:40:29 +0100
Message-Id: <1331739634-22318-9-git-send-email-nbd@openwrt.org> (sfid-20120314_164111_139502_6710B9A6)
In-Reply-To: <1331739634-22318-8-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
 <1331739634-22318-7-git-send-email-nbd@openwrt.org>
 <1331739634-22318-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    5 -----
 drivers/net/wireless/ath/ath9k/hw.c        |    3 ---
 drivers/net/wireless/ath/ath9k/hw.h        |    1 -
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 2829c8c..1d06dab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -154,11 +154,6 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			INI_RA(addac, 31,1) = 0;
 		}
 	}
-}
-
-/* Support for Japan ch.14 (2484) spread */
-void ar9002_hw_cck_chan14_spread(struct ath_hw *ah)
-{
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniCckfirNormal,
 		       ar9287Common_normal_cck_fir_coeff_9287_1_1,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c55157a..189bea3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -620,9 +620,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (!ah->is_pciexpress)
 		ath9k_hw_disablepcie(ah);
 
-	if (!AR_SREV_9300_20_OR_LATER(ah))
-		ar9002_hw_cck_chan14_spread(ah);
-
 	r = ath9k_hw_post_init(ah);
 	if (r)
 		return r;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5b9f05b..7efb06d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -994,7 +994,6 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan);
  * Code Specific to AR5008, AR9001 or AR9002,
  * we stuff these here to avoid callbacks for AR9003.
  */
-void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
 int ar9002_hw_rf_claim(struct ath_hw *ah);
 void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
 
-- 
1.7.3.2

