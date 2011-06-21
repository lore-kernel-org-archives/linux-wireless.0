Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41726 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 31/32] ath9k: add external_reset callback to ath9k_platfom_data for AR9330
Date: Tue, 21 Jun 2011 11:23:51 +0200
Message-Id: <1308648232-9906-32-git-send-email-juhosg@openwrt.org> (sfid-20110621_112531_540040_E02811EE)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds a callback to ath9k_platform_data. If the
callback is provided by the platform code, then it can be
used to hard reset the WMAC device.

The callback is required for doing a hard reset of the AR9330
chips to get them working again after a hang.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   35 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 include/linux/ath9k_platform.h        |    1 +
 4 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4da5284..839ba64 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1161,6 +1161,41 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 			rst_flags |= AR_RTC_RC_MAC_COLD;
 	}
 
+	if (AR_SREV_9330(ah)) {
+		int npend = 0;
+		int i;
+
+		/* AR9330 WAR:
+		 * call external reset function to reset WMAC if:
+		 * - doing a cold reset
+		 * - we have pending frames in the TX queues
+		 */
+
+		for (i = 0; i < AR_NUM_QCU; i++) {
+			npend = ath9k_hw_numtxpending(ah, i);
+			if (npend)
+				break;
+		}
+
+		if (ah->external_reset &&
+		    (npend || type == ATH9K_RESET_COLD)) {
+			int reset_err = 0;
+
+			ath_dbg(ath9k_hw_common(ah), ATH_DBG_RESET,
+				"reset MAC via external reset\n");
+
+			reset_err = ah->external_reset();
+			if (reset_err) {
+				ath_err(ath9k_hw_common(ah),
+					"External reset failed, err=%d\n",
+					reset_err);
+				return false;
+			}
+
+			REG_WRITE(ah, AR_RTC_RESET, 1);
+		}
+	}
+
 	REG_WRITE(ah, AR_RTC_RC, rst_flags);
 
 	REGWRITE_BUFFER_FLUSH(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0749fa8..818acdd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -863,6 +863,7 @@ struct ath_hw {
 
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
+	int (*external_reset)(void);
 };
 
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1851c22..50103b2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -575,6 +575,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 		sc->sc_ah->led_pin = pdata->led_pin;
 		ah->is_clk_25mhz = pdata->is_clk_25mhz;
 		ah->get_mac_revision = pdata->get_mac_revision;
+		ah->external_reset = pdata->external_reset;
 	}
 
 	common = ath9k_hw_common(ah);
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index c207607..6e3f54f 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -31,6 +31,7 @@ struct ath9k_platform_data {
 
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
+	int (*external_reset)(void);
 };
 
 #endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.7.2.1

