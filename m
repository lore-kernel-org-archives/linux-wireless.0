Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49300 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099AbbA3Ncm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:42 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgf-004FiR-B0
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 01/17] ath9k: Remove ATH9K_HW_WOW_DEVICE_CAPABLE
Date: Fri, 30 Jan 2015 19:05:21 +0530
Message-Id: <1422624937-4810-2-git-send-email-sujith@msujith.org> (sfid-20150130_143245_946617_45AB50B7)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Enabling WOW based on the chip is incorrect since
it needs to be done for specific sub-devices which
have proper platform support.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 3 ---
 drivers/net/wireless/ath/ath9k/hw.h  | 2 --
 drivers/net/wireless/ath/ath9k/wow.c | 4 +---
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 82d8f32..8c2f9e2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2544,9 +2544,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_CAP_RTT;
 	}
 
-	if (AR_SREV_9462(ah))
-		pCap->hw_caps |= ATH9K_HW_WOW_DEVICE_CAPABLE;
-
 	if (AR_SREV_9300_20_OR_LATER(ah) &&
 	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 450704e..dabc94e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -248,12 +248,10 @@ enum ath9k_hw_caps {
 #ifdef CONFIG_ATH9K_PCOEM
 	ATH9K_HW_CAP_RTT			= BIT(14),
 	ATH9K_HW_CAP_MCI			= BIT(15),
-	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(16),
 	ATH9K_HW_CAP_BT_ANT_DIV			= BIT(17),
 #else
 	ATH9K_HW_CAP_RTT			= 0,
 	ATH9K_HW_CAP_MCI			= 0,
-	ATH9K_HW_WOW_DEVICE_CAPABLE		= 0,
 	ATH9K_HW_CAP_BT_ANT_DIV			= 0,
 #endif
 	ATH9K_HW_CAP_DFS			= BIT(18),
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 5f30e58..4ffaadd 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -352,9 +352,7 @@ void ath9k_init_wow(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
-	    (sc->driver_data & ATH9K_PCI_WOW) &&
-	    device_can_wakeup(sc->dev))
+	if ((sc->driver_data & ATH9K_PCI_WOW) && device_can_wakeup(sc->dev))
 		hw->wiphy->wowlan = &ath9k_wowlan_support;
 
 	atomic_set(&sc->wow_sleep_proc_intr, -1);
-- 
2.2.2

