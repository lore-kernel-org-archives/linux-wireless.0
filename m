Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52444 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/7] ath9k: add support for overriding the MAC address through platform data
Date: Sat, 19 Mar 2011 13:55:39 +0100
Message-Id: <1300539343-75509-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300539343-75509-2-git-send-email-nbd@openwrt.org>
References: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
 <1300539343-75509-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some devices the correct MAC address is not in the EEPROM data, but
stored somewhere else.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c |    7 ++++++-
 include/linux/ath9k_platform.h        |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 79aec98..e22e821 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/ath9k_platform.h>
 
 #include "ath9k.h"
 
@@ -537,6 +538,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 			    const struct ath_bus_ops *bus_ops)
 {
+	struct ath9k_platform_data *pdata = sc->dev->platform_data;
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
 	int ret = 0, i;
@@ -551,7 +553,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
-	if (!sc->dev->platform_data)
+	if (!pdata)
 		ah->ah_flags |= AH_USE_EEPROM;
 
 	common = ath9k_hw_common(ah);
@@ -587,6 +589,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	if (ret)
 		goto err_hw;
 
+	if (pdata && pdata->macaddr)
+		memcpy(common->macaddr, pdata->macaddr, ETH_ALEN);
+
 	ret = ath9k_init_queues(sc);
 	if (ret)
 		goto err_queues;
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index b847fc7..b5f0658 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -23,6 +23,7 @@
 
 struct ath9k_platform_data {
 	u16 eeprom_data[ATH9K_PLAT_EEP_MAX_WORDS];
+	u8 *macaddr;
 };
 
 #endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.7.3.2

