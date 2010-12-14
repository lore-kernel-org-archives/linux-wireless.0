Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61662 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0LNCna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 21:43:30 -0500
Received: by pzk6 with SMTP id 6so25098pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 18:43:29 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19718.55706.982211.137208@gargle.gargle.HOWL>
Date: Tue, 14 Dec 2010 08:12:34 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_htc: Remove PCI specific configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

There is no need to configure PCI related registers for
USB devices.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ----
 drivers/net/wireless/ath/ath9k/hw.c           |    8 +++++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 20ea75a..dd17909 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1170,9 +1170,6 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	/* setup initial channel */
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
-	/* Reset SERDES registers */
-	ath9k_hw_configpcipowersave(ah, 0, 0);
-
 	ath9k_hw_htc_resetinit(ah);
 	ret = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (ret) {
@@ -1258,7 +1255,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_disable(ah);
-	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_htc_ps_restore(priv);
 	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0f373be..2662553 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -568,10 +568,12 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
 			 AR_WA_ASPM_TIMER_BASED_DISABLE);
 
-	if (ah->is_pciexpress)
+	if (ah->is_pciexpress) {
 		ath9k_hw_configpcipowersave(ah, 0, 0);
-	else
-		ath9k_hw_disablepcie(ah);
+	} else {
+		if (common->bus_ops->ath_bus_type != ATH_USB)
+			ath9k_hw_disablepcie(ah);
+	}
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ar9002_hw_cck_chan14_spread(ah);
-- 
1.7.3.3

