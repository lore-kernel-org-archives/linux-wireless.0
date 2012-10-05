Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:45:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/7] rt2800: use eeprom OFDM 6M TX power as criterion
Date: Fri,  5 Oct 2012 13:44:12 +0200
Message-Id: <1349437455-18754-4-git-send-email-sgruszka@redhat.com> (sfid-20121005_134602_592197_4C032BDC)
In-Reply-To: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don use TX_PWR_CFG_0 register value of OFDM 6M tx power as criterion
since it can be changed. The same do vendor driver (see
AsicAdjustSingleSkuTxPower and AsicGetTxPowerOffset functions from
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO).

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 57ffbca..e0e641d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2524,7 +2524,6 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 				   enum ieee80211_band band, int power_level,
 				   u8 txpower, int delta)
 {
-	u32 reg;
 	u16 eeprom;
 	u8 criterion;
 	u8 eirp_txpower;
@@ -2539,11 +2538,13 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 		 * .11b data rate need add additional 4dbm
 		 * when calculating eirp txpower.
 		 */
-		rt2800_register_read(rt2x00dev, TX_PWR_CFG_0, &reg);
-		criterion = rt2x00_get_field32(reg, TX_PWR_CFG_0_6MBS);
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + 1,
+				   &eeprom);
+		criterion = rt2x00_get_field16(eeprom,
+					       EEPROM_TXPOWER_BYRATE_RATE0);
 
-		rt2x00_eeprom_read(rt2x00dev,
-				   EEPROM_EIRP_MAX_TX_POWER, &eeprom);
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER,
+				   &eeprom);
 
 		if (band == IEEE80211_BAND_2GHZ)
 			eirp_txpower_criterion = rt2x00_get_field16(eeprom,
-- 
1.7.1

