Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55433 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 03/14] ath9k_hw: remove ath9k_hw_htc_resetinit
Date: Wed, 14 Mar 2012 16:40:23 +0100
Message-Id: <1331739634-22318-3-git-send-email-nbd@openwrt.org> (sfid-20120314_164110_562868_A56857F3)
In-Reply-To: <1331739634-22318-2-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Automatically set the ah->htc_reset_init on init and after PHY disable.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.c           |    8 ++------
 drivers/net/wireless/ath/ath9k/hw.h           |    3 ---
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2a29a7c..2b8f61c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -919,7 +919,6 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	/* setup initial channel */
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
-	ath9k_hw_htc_resetinit(ah);
 	ret = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (ret) {
 		ath_err(common,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 02cc1ce..5bd872f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -449,6 +449,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->slottime = ATH9K_SLOT_TIME_9;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
+	ah->htc_reset_init = true;
 }
 
 static int ath9k_hw_init_macaddr(struct ath_hw *ah)
@@ -2589,6 +2590,7 @@ bool ath9k_hw_phy_disable(struct ath_hw *ah)
 		return false;
 
 	ath9k_hw_init_pll(ah, NULL);
+	ah->htc_reset_init = true;
 	return true;
 }
 EXPORT_SYMBOL(ath9k_hw_phy_disable);
@@ -2949,12 +2951,6 @@ EXPORT_SYMBOL(ath_gen_timer_isr);
 /* HTC  */
 /********/
 
-void ath9k_hw_htc_resetinit(struct ath_hw *ah)
-{
-	ah->htc_reset_init = true;
-}
-EXPORT_SYMBOL(ath9k_hw_htc_resetinit);
-
 static struct {
 	u32 version;
 	const char * name;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1707137..a703423 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -988,9 +988,6 @@ void ath_gen_timer_isr(struct ath_hw *hw);
 
 void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
 
-/* HTC */
-void ath9k_hw_htc_resetinit(struct ath_hw *ah);
-
 /* PHY */
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
-- 
1.7.3.2

