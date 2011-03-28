Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1C1Lg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:36:59 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3686803wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:36:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/13] rt2x00: Indention cleanup in rt2800lib
Date: Mon, 28 Mar 2011 13:32:32 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281331.31575.IvDoorn@gmail.com> <201103281332.01948.IvDoorn@gmail.com>
In-Reply-To: <201103281332.01948.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281332.34565.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Fix the indention in rt2800_compesate_txpower and also fix a typo in
the function name rt2800_compesate_txpower -> rt2800_compensate_txpower.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 26ac892..0265133 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1857,12 +1857,9 @@ static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
 	return comp_value;
 }
 
-static u8 rt2800_compesate_txpower(struct rt2x00_dev *rt2x00dev,
-				     int is_rate_b,
-				     enum ieee80211_band band,
-				     int power_level,
-				     u8 txpower,
-				     int delta)
+static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
+				   enum ieee80211_band band, int power_level,
+				   u8 txpower, int delta)
 {
 	u32 reg;
 	u16 eeprom;
@@ -1951,7 +1948,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE0);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE0, txpower);
 
@@ -1962,7 +1959,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE1);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE1, txpower);
 
@@ -1973,7 +1970,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE2);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE2, txpower);
 
@@ -1984,7 +1981,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE3);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE3, txpower);
 
@@ -2000,7 +1997,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE0);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE4, txpower);
 
@@ -2011,7 +2008,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE1);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE5, txpower);
 
@@ -2022,7 +2019,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE2);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE6, txpower);
 
@@ -2033,7 +2030,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		 */
 		txpower = rt2x00_get_field16(eeprom,
 					     EEPROM_TXPOWER_BYRATE_RATE3);
-		txpower = rt2800_compesate_txpower(rt2x00dev, is_rate_b, band,
+		txpower = rt2800_compensate_txpower(rt2x00dev, is_rate_b, band,
 					     power_level, txpower, delta);
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE7, txpower);
 
-- 
1.7.2.3

