Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:35656 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdAMVaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:30:06 -0500
Date: Fri, 13 Jan 2017 22:29:57 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 28/40] rt2x00: rt2800lib: fix LNA gain configuration for
 RT3883
Message-ID: <20170113212952.GA3584@makrotopia.org> (sfid-20170113_223009_200277_9AE0A873)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index bde8177c30c4..da430e304d1f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1994,7 +1994,8 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 		rt2800_eeprom_read(rt2x00dev, EEPROM_LNA, &eeprom);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_LNA_A0);
 	} else if (libconf->rf.channel <= 128) {
-		if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883)) {
 			rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2, &eeprom);
 			lna_gain = rt2x00_get_field16(eeprom,
 						      EEPROM_EXT_LNA2_A1);
@@ -2004,7 +2005,8 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 						      EEPROM_RSSI_BG2_LNA_A1);
 		}
 	} else {
-		if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_rt(rt2x00dev, RT3593) ||
+		    rt2x00_rt(rt2x00dev, RT3883)) {
 			rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2, &eeprom);
 			lna_gain = rt2x00_get_field16(eeprom,
 						      EEPROM_EXT_LNA2_A2);
-- 
2.11.0
