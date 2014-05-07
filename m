Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:54294 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaEGH17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 03:27:59 -0400
Received: by mail-qg0-f51.google.com with SMTP id q107so614670qgd.24
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 00:27:58 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] ath9k: Allow platform override without EEPROM override
Date: Wed,  7 May 2014 09:28:31 +0200
Message-Id: <1399447711-12441-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20140507_092804_027270_7BBD7F76)
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
 drivers/net/wireless/ath/ath9k/init.c | 2 +-
 include/linux/ath9k_platform.h        | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

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

