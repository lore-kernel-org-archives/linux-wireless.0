Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47112 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1AKILT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 03:11:19 -0500
Date: Tue, 11 Jan 2011 09:00:31 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	nbd@openwrt.org
Message-ID: <3623254.7.1294732830591.JavaMail.wlan@CHBU500181>
In-Reply-To: <14218728.3.1294732508485.JavaMail.wlan@CHBU500181>
Subject: [PATCH] ath5k: Fix return codes for eeprom read functions.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eeprom read functions are of bool type and not int.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/ahb.c    |    7 ++++---
 drivers/net/wireless/ath/ath5k/eeprom.c |   24 ++++++++----------------
 drivers/net/wireless/ath/ath5k/eeprom.h |    5 ++---
 drivers/net/wireless/ath/ath5k/pci.c    |    9 +++++----
 4 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 707cde1..ae84b86 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -31,7 +31,8 @@ static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
 	*csz = L1_CACHE_BYTES >> 2;
 }
 
-bool ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
+static bool
+ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath5k_softc *sc = common->priv;
 	struct platform_device *pdev = to_platform_device(sc->dev);
@@ -46,10 +47,10 @@ bool ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 
 	eeprom += off;
 	if (eeprom > eeprom_end)
-		return -EINVAL;
+		return false;
 
 	*data = *eeprom;
-	return 0;
+	return true;
 }
 
 int ath5k_hw_read_srev(struct ath5k_hw *ah)
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 80e6256..b6561f7 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -72,7 +72,6 @@ static int
 ath5k_eeprom_init_header(struct ath5k_hw *ah)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	int ret;
 	u16 val;
 	u32 cksum, offset, eep_max = AR5K_EEPROM_INFO_MAX;
 
@@ -192,7 +191,7 @@ static int ath5k_eeprom_read_ants(struct ath5k_hw *ah, u32 *offset,
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 o = *offset;
 	u16 val;
-	int ret, i = 0;
+	int i = 0;
 
 	AR5K_EEPROM_READ(o++, val);
 	ee->ee_switch_settling[mode]	= (val >> 8) & 0x7f;
@@ -252,7 +251,6 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 o = *offset;
 	u16 val;
-	int ret;
 
 	ee->ee_n_piers[mode] = 0;
 	AR5K_EEPROM_READ(o++, val);
@@ -515,7 +513,6 @@ ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
 	int o = *offset;
 	int i = 0;
 	u8 freq1, freq2;
-	int ret;
 	u16 val;
 
 	ee->ee_n_piers[mode] = 0;
@@ -551,7 +548,7 @@ ath5k_eeprom_init_11a_pcal_freq(struct ath5k_hw *ah, int offset)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	struct ath5k_chan_pcal_info *pcal = ee->ee_pwr_cal_a;
-	int i, ret;
+	int i;
 	u16 val;
 	u8 mask;
 
@@ -970,7 +967,6 @@ ath5k_eeprom_read_pcal_info_5112(struct ath5k_hw *ah, int mode)
 	u32 offset;
 	u8 i, c;
 	u16 val;
-	int ret;
 	u8 pd_gains = 0;
 
 	/* Count how many curves we have and
@@ -1228,7 +1224,7 @@ ath5k_eeprom_read_pcal_info_2413(struct ath5k_hw *ah, int mode)
 	struct ath5k_chan_pcal_info *chinfo;
 	u8 *pdgain_idx = ee->ee_pdc_to_idx[mode];
 	u32 offset;
-	int idx, i, ret;
+	int idx, i;
 	u16 val;
 	u8 pd_gains = 0;
 
@@ -1419,7 +1415,7 @@ ath5k_eeprom_read_target_rate_pwr_info(struct ath5k_hw *ah, unsigned int mode)
 	u8 *rate_target_pwr_num;
 	u32 offset;
 	u16 val;
-	int ret, i;
+	int i;
 
 	offset = AR5K_EEPROM_TARGET_PWRSTART(ee->ee_misc1);
 	rate_target_pwr_num = &ee->ee_rate_target_pwr_num[mode];
@@ -1593,7 +1589,7 @@ ath5k_eeprom_read_ctl_info(struct ath5k_hw *ah)
 	struct ath5k_edge_power *rep;
 	unsigned int fmask, pmask;
 	unsigned int ctl_mode;
-	int ret, i, j;
+	int i, j;
 	u32 offset;
 	u16 val;
 
@@ -1733,16 +1729,12 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 	u8 mac_d[ETH_ALEN] = {};
 	u32 total, offset;
 	u16 data;
-	int octet, ret;
+	int octet;
 
-	ret = ath5k_hw_nvram_read(ah, 0x20, &data);
-	if (ret)
-		return ret;
+	AR5K_EEPROM_READ(0x20, data);
 
 	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
-		ret = ath5k_hw_nvram_read(ah, offset, &data);
-		if (ret)
-			return ret;
+		AR5K_EEPROM_READ(offset, data);
 
 		total += data;
 		mac_d[octet + 1] = data & 0xff;
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 7c09e15..d46f105 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -241,9 +241,8 @@ enum ath5k_eeprom_freq_bands{
 #define	AR5K_SPUR_SYMBOL_WIDTH_TURBO_100Hz	6250
 
 #define AR5K_EEPROM_READ(_o, _v) do {			\
-	ret = ath5k_hw_nvram_read(ah, (_o), &(_v));	\
-	if (ret)					\
-		return ret;				\
+	if (!ath5k_hw_nvram_read(ah, (_o), &(_v)))	\
+		return -EIO;				\
 } while (0)
 
 #define AR5K_EEPROM_READ_HDR(_o, _v)					\
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 7f8c5b0..66598a0 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -69,7 +69,8 @@ static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)
 /*
  * Read from eeprom
  */
-bool ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
+static bool
+ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
 {
 	struct ath5k_hw *ah = (struct ath5k_hw *) common->ah;
 	u32 status, timeout;
@@ -90,15 +91,15 @@ bool ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
 		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
 		if (status & AR5K_EEPROM_STAT_RDDONE) {
 			if (status & AR5K_EEPROM_STAT_RDERR)
-				return -EIO;
+				return false;
 			*data = (u16)(ath5k_hw_reg_read(ah, AR5K_EEPROM_DATA) &
 					0xffff);
-			return 0;
+			return true;
 		}
 		udelay(15);
 	}
 
-	return -ETIMEDOUT;
+	return false;
 }
 
 int ath5k_hw_read_srev(struct ath5k_hw *ah)
-- 
1.7.1

