Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58992 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab3JBTnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 15:43:12 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] rt2x00: rt2800lib: remove TXMIXER_GAIN entries from the extended EEPROM map
Date: Wed,  2 Oct 2013 21:41:53 +0200
Message-Id: <1380742914-22486-1-git-send-email-juhosg@openwrt.org> (sfid-20131002_214315_398914_7E26C68C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comments are indicating the TXMIXER_GAIN_BG and
the TXMIXED_GAIN_A entries are overlapping with the
RSSI_BG2 and RSSI_A2 entries in the extended EEPROM
map. This is not correct, becuase the upper byte of
the RSSI_BG2 and RSSI_A2 entries are reserved. There
are no TX mixer gain values are stored at all in the
extended EEPROM.

Remove the initialization of these entries from the
extended EEPROM map to reflect this.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c706ddc..c979bb7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -280,10 +280,8 @@ static const unsigned int rt2800_eeprom_map_ext[EEPROM_WORD_COUNT] = {
 	[EEPROM_RSSI_BG]		= 0x0028,
 	[EEPROM_TXPOWER_DELTA]		= 0x0028, /* Overlaps with RSSI_BG */
 	[EEPROM_RSSI_BG2]		= 0x0029,
-	[EEPROM_TXMIXER_GAIN_BG]	= 0x0029, /* Overlaps with RSSI_BG2 */
 	[EEPROM_RSSI_A]			= 0x002a,
 	[EEPROM_RSSI_A2]		= 0x002b,
-	[EEPROM_TXMIXER_GAIN_A]		= 0x002b, /* Overlaps with RSSI_A2 */
 	[EEPROM_TXPOWER_BG1]		= 0x0030,
 	[EEPROM_TXPOWER_BG2]		= 0x0037,
 	[EEPROM_EXT_TXPOWER_BG3]	= 0x003e,
-- 
1.7.10
