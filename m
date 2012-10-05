Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:46:07 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 7/7] rt2800: comment tx power settings
Date: Fri,  5 Oct 2012 13:44:15 +0200
Message-Id: <1349437455-18754-7-git-send-email-sgruszka@redhat.com> (sfid-20121005_134611_504763_024915E9)
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3f62204..1cf7b94 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2586,6 +2586,15 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 	return min_t(u8, txpower, 0xc);
 }
 
+/*
+ * We configure transmit power using MAC TX_PWR_CFG_{0,...,N} registers and
+ * BBP R1 register. TX_PWR_CFG_X allow to configure per rate TX power values,
+ * 4 bits for each rate (tune from 0 to 15 dBm). BBP_R1 controls transmit power
+ * for all rates, but allow to set only 4 discrete values: -12, -6, 0 and 6 dBm.
+ * Reference per rate transmit power values are located in the EEPROM at
+ * EEPROM_TXPOWER_BYRATE offset. We adjust them and BBP R1 settings according to
+ * current conditions (i.e. band, bandwidth, temperature, user settings).
+ */
 static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 				  struct ieee80211_channel *chan,
 				  int power_level)
@@ -2597,17 +2606,24 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 	enum ieee80211_band band = chan->band;
 
 	/*
-	 * Calculate HT40 compensation delta
+	 * Calculate HT40 compensation. For 40MHz we need to add or subtract
+	 * value read from EEPROM (different for 2GHz and for 5GHz).
 	 */
 	delta = rt2800_get_txpower_bw_comp(rt2x00dev, band);
 
 	/*
-	 * calculate temperature compensation delta
+	 * Calculate temperature compensation. Depends on measurement of current
+	 * TSSI (Transmitter Signal Strength Indication) we know TX power (due
+	 * to temperature or maybe other factors) is smaller or bigger than
+	 * expected. We adjust it, based on TSSI reference and boundaries values
+	 * provided in EEPROM.
 	 */
 	delta += rt2800_get_gain_calibration_delta(rt2x00dev);
 
 	/*
-	 * Apply regulatory delta.
+	 * Decrease power according to user settings, on devices with unknown
+	 * maximum tx power. For other devices we take user power_level into
+	 * consideration on rt2800_compensate_txpower().
 	 */
 	delta += rt2800_get_txpower_reg_delta(rt2x00dev, power_level,
 					      chan->max_power);
-- 
1.7.1

