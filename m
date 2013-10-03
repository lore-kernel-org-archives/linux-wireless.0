Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44142 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3JCMHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 08:07:08 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Paul Menzel <paulepanter@users.sourceforge.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 2/2] rt2x00: rt2800lib: remove TXPOWER_DELTA entry from extended EEPROM map
Date: Thu,  3 Oct 2013 14:07:02 +0200
Message-Id: <1380802022-28646-2-git-send-email-juhosg@openwrt.org> (sfid-20131003_140715_348226_5BFE05DD)
In-Reply-To: <1380802022-28646-1-git-send-email-juhosg@openwrt.org>
References: <1380802022-28646-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TXPOWER_DELTA field of the regular EEPROM
stores the TX power compensation value for HT40.
The extended EEPROM has no such field, it stores
separate TX power values for HT20 and for HT40.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
Changes since v1:
  - add Paul's Acked-by tag
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c979bb7..315f4af 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -278,7 +278,6 @@ static const unsigned int rt2800_eeprom_map_ext[EEPROM_WORD_COUNT] = {
 	[EEPROM_LNA]			= 0x0026,
 	[EEPROM_EXT_LNA2]		= 0x0027,
 	[EEPROM_RSSI_BG]		= 0x0028,
-	[EEPROM_TXPOWER_DELTA]		= 0x0028, /* Overlaps with RSSI_BG */
 	[EEPROM_RSSI_BG2]		= 0x0029,
 	[EEPROM_RSSI_A]			= 0x002a,
 	[EEPROM_RSSI_A2]		= 0x002b,
-- 
1.7.10
