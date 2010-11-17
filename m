Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47507 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab0KQDT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 22:19:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/2] ath9k: add support for reading eeprom from platform data on PCI devices
Date: Wed, 17 Nov 2010 04:19:46 +0100
Message-Id: <1289963987-28583-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some embedded boards store platform data for connected PCIe AR92xx
chips in the system flash instead of a separate EEPROM chip.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    4 ----
 drivers/net/wireless/ath/ath9k/init.c |    3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 986c779..1dbe53b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -419,10 +419,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->hw_version.subvendorid = 0;
 
-	ah->ah_flags = 0;
-	if (!AR_SREV_9100(ah))
-		ah->ah_flags = AH_USE_EEPROM;
-
 	ah->atim_window = 0;
 	ah->sta_id1_defaults =
 		AR_STA_ID1_CRPT_MIC_ENABLE |
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5c26818d..7eef1fa 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -533,6 +533,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
+	if (!sc->dev->platform_data)
+		ah->ah_flags |= AH_USE_EEPROM;
+
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
 	common->bus_ops = bus_ops;
-- 
1.7.3.2

