Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:50319 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdAMVa5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:30:57 -0500
Date: Fri, 13 Jan 2017 22:30:49 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 30/40] rt2x00: rt2800lib: fix EEPROM LNA validation for RT3883
Message-ID: <20170113213044.GA3610@makrotopia.org> (sfid-20170113_223059_269038_4DF2E24C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e79714b898b9..81368cee6e38 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7648,7 +7648,8 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
-	if (!rt2x00_rt(rt2x00dev, RT3593)) {
+	if (!rt2x00_rt(rt2x00dev, RT3593) &&
+	    !rt2x00_rt(rt2x00dev, RT3883)) {
 		if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
 		    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
 			rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
@@ -7668,7 +7669,8 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
-	if (!rt2x00_rt(rt2x00dev, RT3593)) {
+	if (!rt2x00_rt(rt2x00dev, RT3593) &&
+	    !rt2x00_rt(rt2x00dev, RT3883)) {
 		if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
 		    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
 			rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
@@ -7676,7 +7678,8 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
-	if (rt2x00_rt(rt2x00dev, RT3593)) {
+	if (rt2x00_rt(rt2x00dev, RT3593) ||
+	    rt2x00_rt(rt2x00dev, RT3883)) {
 		rt2800_eeprom_read(rt2x00dev, EEPROM_EXT_LNA2, &word);
 		if (rt2x00_get_field16(word, EEPROM_EXT_LNA2_A1) == 0x00 ||
 		    rt2x00_get_field16(word, EEPROM_EXT_LNA2_A1) == 0xff)
-- 
2.11.0
