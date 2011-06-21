Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41662 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1FUJYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:55 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 03/32] ath9k: add MAC revision detection for AR9330
Date: Tue, 21 Jun 2011 11:23:23 +0200
Message-Id: <1308648232-9906-4-git-send-email-juhosg@openwrt.org> (sfid-20110621_112509_116889_4E0451E1)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR9330 1.0 and 1.1 are using the same revision,
thus it is not possible to distinguish the two chips.
The platform setup code can distinguish the chips based
on the SoC revision.

Add a callback function to ath9k_platform_data in order
to allow getting the revision number from the platform code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    9 +++++++++
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 include/linux/ath9k_platform.h        |    1 +
 4 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a3881b6..9840e00 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -251,6 +251,15 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 	case AR5416_AR9100_DEVID:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 		break;
+	case AR9300_DEVID_AR9330:
+		ah->hw_version.macVersion = AR_SREV_VERSION_9330;
+		if (ah->get_mac_revision) {
+			ah->hw_version.macRev = ah->get_mac_revision();
+		} else {
+			val = REG_READ(ah, AR_SREV);
+			ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
+		}
+		return;
 	case AR9300_DEVID_AR9340:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9340;
 		val = REG_READ(ah, AR_SREV);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 14c5857..0749fa8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -862,6 +862,7 @@ struct ath_hw {
 	u32 ent_mode;
 
 	bool is_clk_25mhz;
+	int (*get_mac_revision)(void);
 };
 
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d4b166c..6612112 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -574,6 +574,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 		sc->sc_ah->gpio_val = pdata->gpio_val;
 		sc->sc_ah->led_pin = pdata->led_pin;
 		ah->is_clk_25mhz = pdata->is_clk_25mhz;
+		ah->get_mac_revision = pdata->get_mac_revision;
 	}
 
 	common = ath9k_hw_common(ah);
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 60a7c49..c207607 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -30,6 +30,7 @@ struct ath9k_platform_data {
 	u32 gpio_val;
 
 	bool is_clk_25mhz;
+	int (*get_mac_revision)(void);
 };
 
 #endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.7.2.1

