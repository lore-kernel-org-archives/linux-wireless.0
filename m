Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44863 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbZIRJh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:37:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:37:30 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21725.565202.139974@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:07:33 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 8/9] ath9k: Advertise midband for AR5416 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

This has to be done if the EEPROM supports FCC Midband
capability.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c     |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 8463ba0..3349274 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -639,6 +639,7 @@ struct ar9287_eeprom {
 } __packed;
 
 enum reg_ext_bitmap {
+	REG_EXT_FCC_MIDBAND = 0,
 	REG_EXT_JAPAN_MIDBAND = 1,
 	REG_EXT_FCC_DFS_HT40 = 2,
 	REG_EXT_JAPAN_NONDFS_HT40 = 3,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 99c0dac..f74604d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3660,7 +3660,10 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN;
 	}
 
-	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
+	/* Advertise midband for AR5416 with FCC midband set in eeprom */
+	if (regulatory->current_rd_ext & (1 << REG_EXT_FCC_MIDBAND) &&
+	    AR_SREV_5416(ah))
+		pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
 
 	pCap->num_antcfg_5ghz =
 		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
-- 
1.6.4.4

