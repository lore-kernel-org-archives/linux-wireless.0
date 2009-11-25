Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbZKYWXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 17:23:23 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	jirislaby@gmail.com, akpm@linux-foundation.org, rjw@sisk.pl,
	me@bobcopeland.com, david.quan@atheros.com
Subject: [PATCH] ath5k: enable EEPROM checksum check
Date: Wed, 25 Nov 2009 17:23:26 -0500
Message-Id: <1259187806-29253-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this we have no gaurantee of the integrity of the
EEPROM and are likely to encounter a lot of bogus bug reports
due to actual issues on the EEPROM. With the EEPROM checksum
check in place we can easily rule those issues out.

If you run patch during a revert *you* have a card with a busted
EEPROM and only older kernel will support that concoction. This
patch is a trade off between not accepitng bogus EEPROMs and
avoiding bogus bug reports allowing developers to focus instead
on real concrete issues.

If stable keeps bogus bug reports because of a possibly busted EEPROM
feel free to apply this there too.

Tested on an AR5414

Cc: stable@kernel.org
Cc: jirislaby@gmail.com
Cc: akpm@linux-foundation.org
Cc: rjw@sisk.pl
Cc: me@bobcopeland.com
Cc: david.quan@atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 644962a..7918852 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -97,6 +97,7 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	int ret;
 	u16 val;
+	u32 cksum, offset;
 
 	/*
 	 * Read values from EEPROM and store them in the capability structure
@@ -111,7 +112,6 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
 		return 0;
 
-#ifdef notyet
 	/*
 	 * Validate the checksum of the EEPROM date. There are some
 	 * devices with invalid EEPROMs.
@@ -124,7 +124,6 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
 		return -EIO;
 	}
-#endif
 
 	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
 	    ee_ant_gain);
-- 
1.6.5.2.155.gbb47

