Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:44894 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaEHLsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 07:48:05 -0400
Received: by mail-qg0-f48.google.com with SMTP id i50so2629592qgf.35
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 04:48:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] ath9k: Allow platform override without EEPROM override
Date: Thu,  8 May 2014 13:48:38 +0200
Message-Id: <1399549718-19848-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20140508_134904_477773_8413E101)
In-Reply-To: <1399447711-12441-1-git-send-email-helmut.schaa@googlemail.com>
References: <1399447711-12441-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new platform data flag "use_eeprom" that indicates that the eeprom
found on the card itself should be used instead of the one present in
the platform data.

This allows to override the MAC address of a PCI card while preserving
the eeprom data from the card itself.

The default behavior is preserved.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Changes in V2: Don't try to load eeprom from platform data on pci if use_eeprom is set.

 drivers/net/wireless/ath/ath9k/init.c | 2 +-
 drivers/net/wireless/ath/ath9k/pci.c  | 2 +-
 include/linux/ath9k_platform.h        | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c99e50f..1af7708 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -508,7 +508,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->tx99_power = MAX_RATE_POWER + 1;
 	init_waitqueue_head(&sc->tx_wait);
 
-	if (!pdata) {
+	if (!pdata || pdata->use_eeprom) {
 		ah->ah_flags |= AH_USE_EEPROM;
 		sc->sc_ah->led_pin = -1;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 914dbc6..c1e82f7 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -686,7 +686,7 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct ath9k_platform_data *pdata = sc->dev->platform_data;
 
-	if (pdata) {
+	if (pdata && !pdata->use_eeprom) {
 		if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
 			ath_err(common,
 				"%s: eeprom read failed, offset %08x is out of range\n",
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 8598f8e..a495a95 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -36,6 +36,8 @@ struct ath9k_platform_data {
 
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
+
+	bool use_eeprom;
 };
 
 #endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.8.4.5

