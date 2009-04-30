Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1044 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZD3T4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Nick Kossifidis <mick@madwifi-project.org>
Subject: [PATCH 2/9] ath5k: Read Spur channels from EEPROM
Date: Thu, 30 Apr 2009 15:55:45 -0400
Message-Id: <1241121352-6064-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
References: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nick Kossifidis <mick@madwifi-project.org>

* Read Spur channel information from EEPROM and use default channels
 for RF5413 compatible chips that don't have this info on EEPROM.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
 Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |   37 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath5k/eeprom.h |   20 ++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index c85429d..587c5b8 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1694,9 +1694,40 @@ ath5k_eeprom_read_ctl_info(struct ath5k_hw *ah)
 	return 0;
 }
 
+static int
+ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
+{
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+	u32 offset;
+	u16 val;
+	int ret = 0, i;
+
+	offset = AR5K_EEPROM_CTL(ee->ee_version) +
+				AR5K_EEPROM_N_CTLS(ee->ee_version);
+
+	if (ee->ee_version < AR5K_EEPROM_VERSION_5_3) {
+		/* No spur info for 5GHz */
+		ee->ee_spur_chans[0][0] = AR5K_EEPROM_NO_SPUR;
+		/* 2 channels for 2GHz (2464/2420) */
+		ee->ee_spur_chans[0][1] = AR5K_EEPROM_5413_SPUR_CHAN_1;
+		ee->ee_spur_chans[1][1] = AR5K_EEPROM_5413_SPUR_CHAN_2;
+		ee->ee_spur_chans[2][1] = AR5K_EEPROM_NO_SPUR;
+	} else if (ee->ee_version >= AR5K_EEPROM_VERSION_5_3) {
+		for (i = 0; i < AR5K_EEPROM_N_SPUR_CHANS; i++) {
+			AR5K_EEPROM_READ(offset, val);
+			ee->ee_spur_chans[i][0] = val;
+			AR5K_EEPROM_READ(offset + AR5K_EEPROM_N_SPUR_CHANS,
+									val);
+			ee->ee_spur_chans[i][1] = val;
+			offset++;
+		}
+	}
+
+	return ret;
+}
 
 /*
- * Initialize eeprom power tables
+ * Initialize eeprom data structure
  */
 int
 ath5k_eeprom_init(struct ath5k_hw *ah)
@@ -1719,6 +1750,10 @@ ath5k_eeprom_init(struct ath5k_hw *ah)
 	if (err < 0)
 		return err;
 
+	err = ath5k_eeprom_read_spur_chans(ah);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index b0c0606..df9ffa0 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -211,6 +211,23 @@
 #define AR5K_EEPROM_I_GAIN		10
 #define AR5K_EEPROM_CCK_OFDM_DELTA	15
 #define AR5K_EEPROM_N_IQ_CAL		2
+/* 5GHz/2GHz */
+enum ath5k_eeprom_freq_bands{
+	AR5K_EEPROM_BAND_5GHZ = 0,
+	AR5K_EEPROM_BAND_2GHZ = 1,
+	AR5K_EEPROM_N_FREQ_BANDS,
+};
+/* Spur chans per freq band */
+#define	AR5K_EEPROM_N_SPUR_CHANS	5
+/* fbin value for chan 2464 x2 */
+#define	AR5K_EEPROM_5413_SPUR_CHAN_1	1640
+/* fbin value for chan 2420 x2 */
+#define	AR5K_EEPROM_5413_SPUR_CHAN_2	1200
+#define	AR5K_EEPROM_SPUR_CHAN_MASK	0x3FFF
+#define	AR5K_EEPROM_NO_SPUR		0x8000
+#define	AR5K_SPUR_CHAN_WIDTH			87
+#define	AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz	3125
+#define	AR5K_SPUR_SYMBOL_WIDTH_TURBO_100Hz	6250
 
 #define AR5K_EEPROM_READ(_o, _v) do {			\
 	ret = ath5k_hw_eeprom_read(ah, (_o), &(_v));	\
@@ -436,6 +453,9 @@ struct ath5k_eeprom_info {
 	s8	ee_pga_desired_size_turbo[AR5K_EEPROM_N_MODES];
 	s8	ee_pd_gain_overlap;
 
+	/* Spur mitigation data (fbin values for spur channels) */
+	u16	ee_spur_chans[AR5K_EEPROM_N_SPUR_CHANS][AR5K_EEPROM_N_FREQ_BANDS];
+
 	u32	ee_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
 };
 
-- 
1.6.0.6


