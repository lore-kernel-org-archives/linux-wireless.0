Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:53855 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0LOCZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 21:25:36 -0500
Received: by gwb20 with SMTP id 20so1097031gwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 18:25:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19720.9523.300591.171534@gargle.gargle.HOWL>
Date: Wed, 15 Dec 2010 07:47:23 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_htc: Remove PCI specific configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This is not required for USB devices.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

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
 
-- 
1.7.3.3

