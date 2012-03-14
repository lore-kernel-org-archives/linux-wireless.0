Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55437 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 04/14] ath9k_hw: remove ath9k_hw_getdefantenna
Date: Wed, 14 Mar 2012 16:40:24 +0100
Message-Id: <1331739634-22318-4-git-send-email-nbd@openwrt.org> (sfid-20120314_164055_805308_3074EF00)
In-Reply-To: <1331739634-22318-3-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default antenna (as programmed by the INI file) is always 0 anyway.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    6 ------
 drivers/net/wireless/ath/ath9k/hw.h   |    1 -
 drivers/net/wireless/ath/ath9k/init.c |    2 --
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5bd872f..6d9f43f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2527,12 +2527,6 @@ void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
 }
 EXPORT_SYMBOL(ath9k_hw_set_gpio);
 
-u32 ath9k_hw_getdefantenna(struct ath_hw *ah)
-{
-	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
-}
-EXPORT_SYMBOL(ath9k_hw_getdefantenna);
-
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
 {
 	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a703423..1aaf6d1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -934,7 +934,6 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio);
 void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
-u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
 
 /* General Operation */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 944e9b5..2d3ad0c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -493,8 +493,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
-
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
-- 
1.7.3.2

