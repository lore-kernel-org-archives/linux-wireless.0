Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57131 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbYHCAhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 20:37:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 17:37:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/12] ath9k: Use standard error codes
Date: Sat, 2 Aug 2008 17:37:32 -0700
Message-ID: <1217723852-26442-1-git-send-email-lrodriguez@atheros.com> (sfid-20080803_023739_889996_F1D331E7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   49 +++-------
 drivers/net/wireless/ath9k/core.c  |   17 ++--
 drivers/net/wireless/ath9k/hw.c    |  167 ++++++++++++++++++------------------
 drivers/net/wireless/ath9k/phy.c   |    8 +-
 drivers/net/wireless/ath9k/phy.h   |    2 +-
 drivers/net/wireless/ath9k/recv.c  |    6 +-
 drivers/net/wireless/ath9k/xmit.c  |    6 +-
 7 files changed, 116 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 265d9a5..b7712d7 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -658,25 +658,6 @@ struct ath9k_country_entry {
 		(((const u_int8_t *)(p))[2] << 16) | \
 			(((const u_int8_t *)(p))[3] << 24)))
 
-enum hal_status {
-	HAL_OK = 0,
-	HAL_ENXIO,
-	HAL_ENOMEM,
-	HAL_EIO,
-	HAL_EEMAGIC,
-	HAL_EEVERSION,
-	HAL_EELOCKED,
-	HAL_EEBADSUM,
-	HAL_EEREAD,
-	HAL_EEBADMAC,
-	HAL_EESIZE,
-	HAL_EEWRITE,
-	HAL_EINVAL,
-	HAL_ENOTSUPP,
-	HAL_ESELFTEST,
-	HAL_EINPROGRESS
-};
-
 enum ath9k_power_mode {
 	ATH9K_PM_AWAKE = 0,
 	ATH9K_PM_FULL_SLEEP,
@@ -911,17 +892,17 @@ struct chan_centers {
 	u_int16_t ext_center;
 };
 
-enum hal_status ath_hal_getcapability(struct ath_hal *ah,
-				      enum hal_capability_type type,
-				      u_int32_t capability,
-				      u_int32_t *result);
+int ath_hal_getcapability(struct ath_hal *ah,
+			  enum hal_capability_type type,
+			  u_int32_t capability,
+			  u_int32_t *result);
 const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
-						   u_int mode);
+						     u_int mode);
 void ath9k_hw_detach(struct ath_hal *ah);
 struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 				struct ath_softc *sc,
 				void __iomem *mem,
-				enum hal_status *error);
+				int *error);
 bool ath9k_regd_init_channels(struct ath_hal *ah,
 			      u_int maxchans, u_int *nchans,
 			      u_int8_t *regclassids,
@@ -938,7 +919,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		    u_int8_t txchainmask, u_int8_t rxchainmask,
 		    enum ath9k_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
-		    enum hal_status *status);
+		    int *status);
 bool ath9k_hw_phy_disable(struct ath_hal *ah);
 void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 			     bool *isCalDone);
@@ -988,7 +969,7 @@ bool ath9k_hw_setcapability(struct ath_hal *ah,
 			    enum hal_capability_type type,
 			    u_int32_t capability,
 			    u_int32_t setting,
-			    enum hal_status *status);
+			    int *status);
 u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
 void ath9k_hw_getmac(struct ath_hal *ah, u_int8_t *mac);
 void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask);
@@ -1007,8 +988,8 @@ bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			       u_int8_t *rx_chainmask,
 			       u_int8_t *antenna_cfgd);
 void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna);
-enum hal_status ath9k_hw_select_antconfig(struct ath_hal *ah,
-					  u_int32_t cfg);
+int ath9k_hw_select_antconfig(struct ath_hal *ah,
+			      u_int32_t cfg);
 bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
 		       u_int32_t txdp);
 bool ath9k_hw_txstart(struct ath_hal *ah, u_int q);
@@ -1067,12 +1048,12 @@ u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah);
 void ath9k_hw_startpcureceive(struct ath_hal *ah);
 void ath9k_hw_stoppcurecv(struct ath_hal *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
-enum hal_status ath9k_hw_rxprocdesc(struct ath_hal *ah,
-				    struct ath_desc *ds, u_int32_t pa,
-				    struct ath_desc *nds, u_int64_t tsf);
+int ath9k_hw_rxprocdesc(struct ath_hal *ah,
+			struct ath_desc *ds, u_int32_t pa,
+			struct ath_desc *nds, u_int64_t tsf);
 u_int32_t ath9k_hw_gettxbuf(struct ath_hal *ah, u_int q);
-enum hal_status ath9k_hw_txprocdesc(struct ath_hal *ah,
-				    struct ath_desc *ds);
+int ath9k_hw_txprocdesc(struct ath_hal *ah,
+			struct ath_desc *ds);
 void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
 				 u_int numDelims);
 void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index e524678..df86dd3 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -426,7 +426,7 @@ int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (hchan->channel != sc->sc_curchan.channel ||
 	    hchan->channelFlags != sc->sc_curchan.channelFlags ||
 	    sc->sc_update_chainmask || sc->sc_full_reset) {
-		enum hal_status status;
+		int status;
 		/*
 		 * This is only performed if the channel settings have
 		 * actually changed.
@@ -765,7 +765,7 @@ int ath_vap_config(struct ath_softc *sc,
 int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	enum hal_status status;
+	int status;
 	int error = 0;
 	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
@@ -924,7 +924,7 @@ static int ath_reset_end(struct ath_softc *sc, u_int32_t flag)
 int ath_reset(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	enum hal_status status;
+	int status;
 	int error = 0;
 	enum ath9k_ht_macmode ht_macmode = ath_cwm_macmode(sc);
 
@@ -1127,7 +1127,7 @@ static void ath9k_tasklet(unsigned long data)
 int ath_init(u_int16_t devid, struct ath_softc *sc)
 {
 	struct ath_hal *ah = NULL;
-	enum hal_status status;
+	int status;
 	int error = 0, i;
 	int csz = 0;
 	u_int32_t rd;
@@ -1308,8 +1308,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 		sc->sc_splitmic = 1;
 
 	/* turn on mcast key search if possible */
-	if (ath9k_hw_getcapability(ah, HAL_CAP_MCAST_KEYSRCH, 0, NULL)
-					== HAL_OK)
+	if (!ath9k_hw_getcapability(ah, HAL_CAP_MCAST_KEYSRCH, 0, NULL))
 		(void)ath9k_hw_setcapability(ah, HAL_CAP_MCAST_KEYSRCH, 1,
 					     1, NULL);
 
@@ -1669,7 +1668,7 @@ void ath_slow_ant_div(struct ath_antdiv *antdiv,
 			if (curcfg == antdiv->antdiv_num_antcfg)
 				curcfg = 0;
 
-			if (HAL_OK == ath9k_hw_select_antconfig(ah, curcfg)) {
+			if (!ath9k_hw_select_antconfig(ah, curcfg)) {
 				antdiv->antdiv_bestcfg = antdiv->antdiv_curcfg;
 				antdiv->antdiv_curcfg = curcfg;
 				antdiv->antdiv_laststatetsf = curtsf;
@@ -1690,14 +1689,14 @@ void ath_slow_ant_div(struct ath_antdiv *antdiv,
 		if (curcfg == antdiv->antdiv_bestcfg) {
 			ath_find_max_val(antdiv->antdiv_lastbrssi,
 				   antdiv->antdiv_num_antcfg, &bestcfg);
-			if (HAL_OK == ath9k_hw_select_antconfig(ah, bestcfg)) {
+			if (!ath9k_hw_select_antconfig(ah, bestcfg)) {
 				antdiv->antdiv_bestcfg = bestcfg;
 				antdiv->antdiv_curcfg = bestcfg;
 				antdiv->antdiv_laststatetsf = curtsf;
 				antdiv->antdiv_state = ATH_ANT_DIV_IDLE;
 			}
 		} else {
-			if (HAL_OK == ath9k_hw_select_antconfig(ah, curcfg)) {
+			if (!ath9k_hw_select_antconfig(ah, curcfg)) {
 				antdiv->antdiv_curcfg = curcfg;
 				antdiv->antdiv_laststatetsf = curtsf;
 				antdiv->antdiv_state = ATH_ANT_DIV_SCAN;
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index b43cda8..4e249a4 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -267,7 +267,7 @@ static bool ath9k_hw_eeprom_read(struct ath_hal *ah, u_int off,
 	return true;
 }
 
-static enum hal_status ath9k_hw_flash_map(struct ath_hal *ah)
+static int ath9k_hw_flash_map(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -276,10 +276,10 @@ static enum hal_status ath9k_hw_flash_map(struct ath_hal *ah)
 	if (!ahp->ah_cal_mem) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: cannot remap eeprom region \n", __func__);
-		return HAL_EIO;
+		return -EIO;
 	}
 
-	return HAL_OK;
+	return 0;
 }
 
 static bool ath9k_hw_flash_read(struct ath_hal *ah, u_int off,
@@ -481,7 +481,7 @@ static u_int8_t ath9k_hw_get_num_ant_config(struct ath_hal_5416 *ahp,
 	return num_ant_config;
 }
 
-static enum hal_status
+static int
 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
 				struct ath9k_channel *chan,
 				u_int8_t index,
@@ -495,13 +495,13 @@ ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
 	switch (index) {
 	case 0:
 		*config = pModal->antCtrlCommon & 0xFFFF;
-		return HAL_OK;
+		return 0;
 	case 1:
 		if (pBase->version >= 0x0E0D) {
 			if (pModal->useAnt1) {
 				*config =
 				((pModal->antCtrlCommon & 0xFFFF0000) >> 16);
-				return HAL_OK;
+				return 0;
 			}
 		}
 		break;
@@ -509,7 +509,7 @@ ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
 		break;
 	}
 
-	return HAL_EINVAL;
+	return -EINVAL;
 }
 
 static inline bool ath9k_hw_nvram_read(struct ath_hal *ah,
@@ -789,7 +789,7 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 	return true;
 }
 
-static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
+static inline int ath9k_hw_check_eeprom(struct ath_hal *ah)
 {
 	u_int32_t sum = 0, el;
 	u_int16_t *eepdata;
@@ -840,7 +840,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 				DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 					 "Invalid EEPROM Magic. "
 					"endianness missmatch.\n");
-				return HAL_EEBADSUM;
+				return -EINVAL;
 			}
 		}
 	}
@@ -916,10 +916,10 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
 			 sum, ar5416_get_eep_ver(ahp));
-		return HAL_EEBADSUM;
+		return -EINVAL;
 	}
 
-	return HAL_OK;
+	return 0;
 }
 
 static bool ath9k_hw_chip_test(struct ath_hal *ah)
@@ -1003,7 +1003,7 @@ bool ath9k_hw_setcapability(struct ath_hal *ah,
 			    enum hal_capability_type type,
 			    u_int32_t capability,
 			    u_int32_t setting,
-			    enum hal_status *status)
+			    int *status)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t v;
@@ -1177,7 +1177,7 @@ static void ath9k_hw_mark_phy_inactive(struct ath_hal *ah)
 static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
 					      struct ath_softc *sc,
 					      void __iomem *mem,
-					      enum hal_status *status)
+					      int *status)
 {
 	static const u_int8_t defbssidmask[ETH_ALEN] =
 		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
@@ -1189,7 +1189,7 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
 		DPRINTF(sc, ATH_DBG_FATAL,
 			 "%s: cannot allocate memory for state block\n",
 			 __func__);
-		*status = HAL_ENOMEM;
+		*status = -ENOMEM;
 		return NULL;
 	}
 
@@ -1231,15 +1231,15 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u_int16_t devid,
 	return ahp;
 }
 
-static enum hal_status ath9k_hw_eeprom_attach(struct ath_hal *ah)
+static int ath9k_hw_eeprom_attach(struct ath_hal *ah)
 {
-	enum hal_status status;
+	int status;
 
 	if (ath9k_hw_use_flash(ah))
 		ath9k_hw_flash_map(ah);
 
 	if (!ath9k_hw_fill_eeprom(ah))
-		return HAL_EIO;
+		return -EIO;
 
 	status = ath9k_hw_check_eeprom(ah);
 
@@ -1306,7 +1306,7 @@ static inline int ath9k_hw_get_radiorev(struct ath_hal *ah)
 	return ath9k_hw_reverse_bits(val, 8);
 }
 
-static inline enum hal_status ath9k_hw_init_macaddr(struct ath_hal *ah)
+static inline int ath9k_hw_init_macaddr(struct ath_hal *ah)
 {
 	u_int32_t sum;
 	int i;
@@ -1325,10 +1325,10 @@ static inline enum hal_status ath9k_hw_init_macaddr(struct ath_hal *ah)
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: mac address read failed: %s\n", __func__,
 			 print_mac(mac, ahp->ah_macaddr));
-		return HAL_EEBADMAC;
+		return -EADDRNOTAVAIL;
 	}
 
-	return HAL_OK;
+	return 0;
 }
 
 static inline int16_t ath9k_hw_interpolate(u_int16_t target,
@@ -1388,10 +1388,10 @@ static u_int16_t ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 	return spur_val;
 }
 
-static inline enum hal_status ath9k_hw_rfattach(struct ath_hal *ah)
+static inline int ath9k_hw_rfattach(struct ath_hal *ah)
 {
 	bool rfStatus = false;
-	enum hal_status ecode = HAL_OK;
+	int ecode = 0;
 
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
 	if (!rfStatus) {
@@ -1401,10 +1401,10 @@ static inline enum hal_status ath9k_hw_rfattach(struct ath_hal *ah)
 		return ecode;
 	}
 
-	return HAL_OK;
+	return 0;
 }
 
-static enum hal_status ath9k_hw_rf_claim(struct ath_hal *ah)
+static int ath9k_hw_rf_claim(struct ath_hal *ah)
 {
 	u_int32_t val;
 
@@ -1425,12 +1425,12 @@ static enum hal_status ath9k_hw_rf_claim(struct ath_hal *ah)
 			 "%s: 5G Radio Chip Rev 0x%02X is not "
 			"supported by this driver\n",
 			 __func__, ah->ah_analog5GhzRev);
-		return HAL_ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	ah->ah_analog5GhzRev = val;
 
-	return HAL_OK;
+	return 0;
 }
 
 static inline void ath9k_hw_init_pll(struct ath_hal *ah,
@@ -2882,32 +2882,32 @@ static u_int32_t ath9k_hw_gpio_get(struct ath_hal *ah, u_int32_t gpio)
 	}
 }
 
-static inline enum hal_status ath9k_hw_post_attach(struct ath_hal *ah)
+static inline int ath9k_hw_post_attach(struct ath_hal *ah)
 {
-	enum hal_status ecode;
+	int ecode;
 
 	if (!ath9k_hw_chip_test(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			 "%s: hardware self-test failed\n", __func__);
-		return HAL_ESELFTEST;
+		return -ENODEV;
 	}
 
 	ecode = ath9k_hw_rf_claim(ah);
-	if (ecode != HAL_OK)
+	if (ecode != 0)
 		return ecode;
 
 	ecode = ath9k_hw_eeprom_attach(ah);
-	if (ecode != HAL_OK)
+	if (ecode != 0)
 		return ecode;
 	ecode = ath9k_hw_rfattach(ah);
-	if (ecode != HAL_OK)
+	if (ecode != 0)
 		return ecode;
 
 	if (!AR_SREV_9100(ah)) {
 		ath9k_hw_ani_setup(ah);
 		ath9k_hw_ani_attach(ah);
 	}
-	return HAL_OK;
+	return 0;
 }
 
 static u_int32_t ath9k_hw_ini_fixup(struct ath_hal *ah,
@@ -3243,11 +3243,11 @@ bool ath9k_hw_setpower(struct ath_hal *ah,
 static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 					  struct ath_softc *sc,
 					  void __iomem *mem,
-					  enum hal_status *status)
+					  int *status)
 {
 	struct ath_hal_5416 *ahp;
 	struct ath_hal *ah;
-	enum hal_status ecode;
+	int ecode;
 #ifndef CONFIG_SLOW_ANT_DIV
 	u_int32_t i;
 	u_int32_t j;
@@ -3267,14 +3267,14 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't reset chip\n",
 			 __func__);
-		ecode = HAL_EIO;
+		ecode = -EIO;
 		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: couldn't wakeup chip\n",
 			 __func__);
-		ecode = HAL_EIO;
+		ecode = -EIO;
 		goto bad;
 	}
 
@@ -3299,7 +3299,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 			 "%s: Mac Chip Rev 0x%02x.%x is not supported by "
 			 "this driver\n", __func__,
 			 ah->ah_macVersion, ah->ah_macRev);
-		ecode = HAL_ENOTSUPP;
+		ecode = -EOPNOTSUPP;
 		goto bad;
 	}
 
@@ -3459,7 +3459,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 		ar5416DisablePciePhy(ah);
 
 	ecode = ath9k_hw_post_attach(ah);
-	if (ecode != HAL_OK)
+	if (ecode != 0)
 		goto bad;
 
 #ifndef CONFIG_SLOW_ANT_DIV
@@ -3481,12 +3481,12 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 	if (!ath9k_hw_fill_cap_info(ah)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s:failed ath9k_hw_fill_cap_info\n", __func__);
-		ecode = HAL_EEREAD;
+		ecode = -EINVAL;
 		goto bad;
 	}
 
 	ecode = ath9k_hw_init_macaddr(ah);
-	if (ecode != HAL_OK) {
+	if (ecode != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET,
 			 "%s: failed initializing mac address\n",
 			 __func__);
@@ -4455,7 +4455,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 	return true;
 }
 
-static enum hal_status
+static int
 ath9k_hw_set_txpower(struct ath_hal *ah,
 		     struct ar5416_eeprom *pEepData,
 		     struct ath9k_channel *chan,
@@ -4487,14 +4487,14 @@ ath9k_hw_set_txpower(struct ath_hal *ah,
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"ath9k_hw_set_txpower: unable to set "
 			"tx power per rate table\n");
-		return HAL_EIO;
+		return -EIO;
 	}
 
 	if (!ath9k_hw_set_power_cal_table
 	    (ah, pEepData, chan, &txPowerIndexOffset)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "ath9k_hw_set_txpower: unable to set power table\n");
-		return HAL_EIO;
+		return -EIO;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
@@ -4597,7 +4597,7 @@ ath9k_hw_set_txpower(struct ath_hal *ah,
 	else
 		ah->ah_maxPowerLevel = ratesArray[i];
 
-	return HAL_OK;
+	return 0;
 }
 
 static inline void ath9k_hw_get_delta_slope_vals(struct ath_hal *ah,
@@ -5322,7 +5322,7 @@ static inline void ath9k_hw_init_user_settings(struct ath_hal *ah)
 		ath9k_hw_set_global_txtimeout(ah, ahp->ah_globaltxtimeout);
 }
 
-static inline enum hal_status
+static inline int
 ath9k_hw_process_ini(struct ath_hal *ah,
 		     struct ath9k_channel *chan,
 		     enum ath9k_ht_macmode macmode)
@@ -5330,7 +5330,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 	int i, regWrites = 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int modesIndex, freqIndex;
-	enum hal_status status;
+	int status;
 
 	switch (chan->chanmode) {
 	case CHANNEL_A:
@@ -5356,7 +5356,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 		break;
 
 	default:
-		return HAL_EINVAL;
+		return -EINVAL;
 	}
 
 	REG_WRITE(ah, AR_PHY(0), 0x00000007);
@@ -5438,19 +5438,19 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 				      chan->maxRegTxPower * 2,
 				      min((u_int32_t) MAX_RATE_POWER,
 					  (u_int32_t) ah->ah_powerLimit));
-	if (status != HAL_OK) {
+	if (status != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			 "%s: error init'ing transmit power\n", __func__);
-		return HAL_EIO;
+		return -EIO;
 	}
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REG_IO,
 			 "%s: ar5416SetRfRegs failed\n", __func__);
-		return HAL_EIO;
+		return -EIO;
 	}
 
-	return HAL_OK;
+	return 0;
 }
 
 static inline void ath9k_hw_setup_calibration(struct ath_hal *ah,
@@ -5645,8 +5645,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 				 ath9k_regd_get_antenna_allowed(ah, chan),
 				 chan->maxRegTxPower * 2,
 				 min((u_int32_t) MAX_RATE_POWER,
-				     (u_int32_t) ah->ah_powerLimit))
-	    != HAL_OK) {
+				     (u_int32_t) ah->ah_powerLimit)) != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error init'ing transmit power\n", __func__);
 		return false;
@@ -5845,7 +5844,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		    u_int8_t txchainmask, u_int8_t rxchainmask,
 		    enum ath9k_ht_extprotspacing extprotspacing,
 		    bool bChannelChange,
-		    enum hal_status *status)
+		    int *status)
 {
 #define FAIL(_code)     do { ecode = _code; goto bad; } while (0)
 	u_int32_t saveLedState;
@@ -5853,7 +5852,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	struct ath9k_channel *curchan = ah->ah_curchan;
 	u_int32_t saveDefAntenna;
 	u_int32_t macStaId1;
-	enum hal_status ecode;
+	int ecode;
 	int i, rx_chainmask;
 
 	ahp->ah_extprotspacing = extprotspacing;
@@ -5869,7 +5868,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
-		FAIL(HAL_EINVAL);
+		FAIL(-EINVAL);
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
@@ -5910,7 +5909,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	if (!ath9k_hw_chip_reset(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: chip reset failed\n",
 			 __func__);
-		FAIL(HAL_EIO);
+		FAIL(-EIO);
 	}
 
 	if (AR_SREV_9280(ah)) {
@@ -5927,7 +5926,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	}
 
 	ecode = ath9k_hw_process_ini(ah, chan, macmode);
-	if (ecode != HAL_OK)
+	if (ecode != 0)
 		goto bad;
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
@@ -5941,7 +5940,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error setting board options\n", __func__);
-		FAIL(HAL_EIO);
+		FAIL(-EIO);
 	}
 
 	ath9k_hw_decrease_chain_power(ah, chan);
@@ -5970,10 +5969,10 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		if (!(ath9k_hw_ar9280_set_channel(ah, chan)))
-			FAIL(HAL_EIO);
+			FAIL(-EIO);
 	} else {
 		if (!(ath9k_hw_set_channel(ah, chan)))
-			FAIL(HAL_EIO);
+			FAIL(-EIO);
 	}
 
 	for (i = 0; i < AR_NUM_DCU; i++)
@@ -6006,7 +6005,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 	ath9k_hw_init_bb(ah, chan);
 
 	if (!ath9k_hw_init_cal(ah, chan))
-		FAIL(HAL_ESELFTEST);
+		FAIL(-ENODEV);
 
 	rx_chainmask = ahp->ah_rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
@@ -6391,8 +6390,7 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
 								chan),
 				 chan->maxRegTxPower * 2,
 				 min((u_int32_t) MAX_RATE_POWER,
-				     (u_int32_t) ah->ah_powerLimit))
-	    != HAL_OK)
+				     (u_int32_t) ah->ah_powerLimit)) != 0)
 		return false;
 
 	return true;
@@ -6680,9 +6678,9 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 		return (ahp->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
 	case HAL_CAP_WME_TKIPMIC:
-		return HAL_OK;
+		return 0;
 	case HAL_CAP_PHYCOUNTERS:
-		return ahp->ah_hasHwPhyCounters ? HAL_OK : HAL_ENXIO;
+		return ahp->ah_hasHwPhyCounters ? 0 : -ENXIO;
 	case HAL_CAP_DIVERSITY:
 		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
 			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
@@ -6718,16 +6716,16 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 	case HAL_CAP_TXPOW:
 		switch (capability) {
 		case 0:
-			return HAL_OK;
+			return 0;
 		case 1:
 			*result = ah->ah_powerLimit;
-			return HAL_OK;
+			return 0;
 		case 2:
 			*result = ah->ah_maxPowerLevel;
-			return HAL_OK;
+			return 0;
 		case 3:
 			*result = ah->ah_tpScale;
-			return HAL_OK;
+			return 0;
 		}
 		return false;
 	default:
@@ -6735,7 +6733,7 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 	}
 }
 
-enum hal_status
+int
 ath9k_hw_select_antconfig(struct ath_hal *ah, u_int32_t cfg)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -6749,15 +6747,14 @@ ath9k_hw_select_antconfig(struct ath_hal *ah, u_int32_t cfg)
 		halNumAntCfg5GHz;
 
 	if (cfg < halNumAntConfig) {
-		if (HAL_OK ==
-		    ath9k_hw_get_eeprom_antenna_cfg(ahp, chan, cfg,
-						    &ant_config)) {
+		if (!ath9k_hw_get_eeprom_antenna_cfg(ahp, chan,
+						     cfg, &ant_config)) {
 			REG_WRITE(ah, AR_PHY_SWITCH_COM, ant_config);
-			return HAL_OK;
+			return 0;
 		}
 	}
 
-	return HAL_EINVAL;
+	return -EINVAL;
 }
 
 bool ath9k_hw_intrpend(struct ath_hal *ah)
@@ -7842,13 +7839,13 @@ void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds)
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
 
-enum hal_status
+int
 ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
 	if ((ads->ds_txstatus9 & AR_TxDone) == 0)
-		return HAL_EINPROGRESS;
+		return -EINPROGRESS;
 
 	ds->ds_txstat.ts_seqnum = MS(ads->ds_txstatus9, AR_SeqNum);
 	ds->ds_txstat.ts_tstamp = ads->AR_SendTimestamp;
@@ -7913,7 +7910,7 @@ ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 	ds->ds_txstat.ts_virtcol = MS(ads->ds_txstatus1, AR_VirtRetryCnt);
 	ds->ds_txstat.ts_antenna = 1;
 
-	return HAL_OK;
+	return 0;
 }
 
 void
@@ -8143,7 +8140,7 @@ ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 	return true;
 }
 
-enum hal_status
+int
 ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 		    u_int32_t pa, struct ath_desc *nds, u_int64_t tsf)
 {
@@ -8151,7 +8148,7 @@ ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 	struct ar5416_desc *adsp = AR5416DESC(ds);
 
 	if ((adsp->ds_rxstatus8 & AR_RxDone) == 0)
-		return HAL_EINPROGRESS;
+		return -EINPROGRESS;
 
 	ads.u.rx = adsp->u.rx;
 
@@ -8208,7 +8205,7 @@ ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 			ds->ds_rxstat.rs_status |= ATH9K_RXERR_MIC;
 	}
 
-	return HAL_OK;
+	return 0;
 }
 
 static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
@@ -8297,7 +8294,7 @@ const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid)
 struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 				struct ath_softc *sc,
 				void __iomem *mem,
-				enum hal_status *error)
+				int *error)
 {
 	struct ath_hal *ah = NULL;
 
@@ -8313,7 +8310,7 @@ struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 			 "devid=0x%x not supported.\n", devid);
 		ah = NULL;
-		*error = HAL_ENXIO;
+		*error = -ENXIO;
 		break;
 	}
 	if (ah != NULL) {
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 29af88d..2e0b093 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -312,7 +312,7 @@ ath9k_hw_rfdetach(struct ath_hal *ah)
 	}
 }
 
-bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
+bool ath9k_hw_init_rf(struct ath_hal *ah, int *status)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -350,7 +350,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				 "%s: cannot allocate RF banks\n",
 				 __func__);
-			*status = HAL_ENOMEM;
+			*status = -ENOMEM;
 			return false;
 		}
 
@@ -362,7 +362,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				 "%s: cannot allocate ah_addac5416_21\n",
 				 __func__);
-			*status = HAL_ENOMEM;
+			*status = -ENOMEM;
 			return false;
 		}
 
@@ -373,7 +373,7 @@ bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 			DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 				 "%s: cannot allocate ah_bank6Temp\n",
 				 __func__);
-			*status = HAL_ENOMEM;
+			*status = -ENOMEM;
 			return false;
 		}
 	}
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 6505e8f..5fb1e1f 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -30,7 +30,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
 void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
 				   struct ath9k_channel *chan);
 bool ath9k_hw_init_rf(struct ath_hal *ah,
-			       enum hal_status *status);
+			       int *status);
 
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index fe20e46..05dbfe1 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -745,7 +745,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	int type, rx_processed = 0;
 	u_int phyerr;
 	u_int8_t chainreset = 0;
-	enum hal_status retval;
+	int retval;
 	__le16 fc;
 
 	do {
@@ -812,7 +812,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 					     bf->bf_daddr,
 					     PA2DESC(sc, ds->ds_link),
 					     0);
-		if (HAL_EINPROGRESS == retval) {
+		if (retval == -EINPROGRESS) {
 			struct ath_buf *tbf;
 			struct ath_desc *tds;
 
@@ -838,7 +838,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			retval = ath9k_hw_rxprocdesc(ah,
 				tds, tbf->bf_daddr,
 				PA2DESC(sc, tds->ds_link), 0);
-			if (HAL_EINPROGRESS == retval) {
+			if (retval == -EINPROGRESS) {
 				spin_unlock_bh(&sc->sc_rxbuflock);
 				break;
 			}
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3937362..c136517 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1258,7 +1258,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	struct ieee80211_tx_info *tx_info;
 	struct ath_tx_info_priv *tx_info_priv;
 	int nacked, txok, nbad = 0, isrifs = 0;
-	enum hal_status status;
+	int status;
 
 	DPRINTF(sc, ATH_DBG_QUEUE,
 		"%s: tx queue %d (%x), link %p\n", __func__,
@@ -1307,7 +1307,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		ds = lastbf->bf_desc;    /* NB: last decriptor */
 
 		status = ath9k_hw_txprocdesc(ah, ds);
-		if (status == HAL_EINPROGRESS) {
+		if (status == -EINPROGRESS) {
 			spin_unlock_bh(&txq->axq_lock);
 			break;
 		}
@@ -1446,7 +1446,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 	}
 
 	if (npend) {
-		enum hal_status status;
+		int status;
 
 		/* TxDMA not stopped, reset the hal */
 		DPRINTF(sc, ATH_DBG_XMIT,
-- 
1.5.6.rc2.15.g457bb.dirty

