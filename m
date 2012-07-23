Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:54083 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238Ab2GWQBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 12:01:22 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, thomas@net.t-labs.tu-berlin.de,
	nbd@nbd.name
Subject: [PATCH 1/2] ath5k: fix wrong per rate target power eeprom reads for AR5K_EEPROM_MODE_11A
Date: Mon, 23 Jul 2012 18:01:14 +0200
Message-Id: <1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120723_180127_132415_010FD643)
In-Reply-To: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reduces the per rate target power eeprom reads for
AR5K_EEPROM_MODE_11A from 10 to 8, as there are only 8 valid
power curve entries on the eeprom. The former 10 reads lead to
wrong per rate power limits where rates above 24MBit could be
amplified with to high distortion leading to bad performance.
This was fix validated against the madwifi codebase and a new
AR5K_EEPROM_N_5GHZ_RATE_CHAN 8 is defined.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
madwifi cross validation check. Thx to Felix Fiethkau
---
 drivers/net/wireless/ath/ath5k/eeprom.c | 2 +-
 drivers/net/wireless/ath/ath5k/eeprom.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 4026c90..b7e0258 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1482,7 +1482,7 @@ ath5k_eeprom_read_target_rate_pwr_info(struct ath5k_hw *ah, unsigned int mode)
 	case AR5K_EEPROM_MODE_11A:
 		offset += AR5K_EEPROM_TARGET_PWR_OFF_11A(ee->ee_version);
 		rate_pcal_info = ee->ee_rate_tpwr_a;
-		ee->ee_rate_target_pwr_num[mode] = AR5K_EEPROM_N_5GHZ_CHAN;
+		ee->ee_rate_target_pwr_num[mode] = AR5K_EEPROM_N_5GHZ_RATE_CHAN;
 		break;
 	case AR5K_EEPROM_MODE_11B:
 		offset += AR5K_EEPROM_TARGET_PWR_OFF_11B(ee->ee_version);
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index dc2bcfe..94a9bbe 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -182,6 +182,7 @@
 #define AR5K_EEPROM_EEP_DELTA		10
 #define AR5K_EEPROM_N_MODES		3
 #define AR5K_EEPROM_N_5GHZ_CHAN		10
+#define AR5K_EEPROM_N_5GHZ_RATE_CHAN	8
 #define AR5K_EEPROM_N_2GHZ_CHAN		3
 #define AR5K_EEPROM_N_2GHZ_CHAN_2413	4
 #define	AR5K_EEPROM_N_2GHZ_CHAN_MAX	4
-- 
1.7.11.1

