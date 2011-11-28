Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:20089 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1K1QSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:18:11 -0500
Date: Mon, 28 Nov 2011 17:13:42 +0100
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: Daniel Golle <dgolle@allnet.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v1 3/3] support for antenna configuration profiles
Message-ID: <20111128161342.GA25498@localhost> (sfid-20111128_171815_110043_BBBB0748)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This adds support for controlling AR_PHY_SWITCH_COM of the AR9285 by using
antenna configuration profiles to ath9k.

Signed-off-by: Daniel Golle <dgolle@allnet.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c    |   13 ++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |   29 +++++++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    8 ++-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    8 ++-
 drivers/net/wireless/ath/ath9k/hw.h            |   28 +++++++
 drivers/net/wireless/ath/ath9k/init.c          |   93 ++++++++++++++++++++=
++++
 drivers/net/wireless/ath/ath9k/main.c          |   36 +++++++++
 include/linux/ath9k_platform.h                 |    6 ++
 10 files changed, 225 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wire=
less/ath/ath9k/ar9002_phy.c
index 3cbbb03..babf8b0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -556,6 +556,16 @@ static void ar9002_hw_antdiv_comb_conf_set(struct ath_=
hw *ah,
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
=20
+static void ar9002_hw_extant_switchcom_set(struct ath_hw *ah, u32 switch_c=
om_value)
+{
+	REG_WRITE(ah, AR_PHY_SWITCH_COM, switch_com_value);
+}
+
+static u32 ar9002_hw_extant_switchcom_get(struct ath_hw *ah)
+{
+	return REG_READ(ah, AR_PHY_SWITCH_COM);
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops =3D ath9k_hw_private_ops(ah);
@@ -573,5 +583,8 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	ops->antdiv_comb_conf_get =3D ar9002_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set =3D ar9002_hw_antdiv_comb_conf_set;
=20
+	ops->extant_switchcom_set =3D ar9002_hw_extant_switchcom_set;
+	ops->extant_switchcom_get =3D ar9002_hw_extant_switchcom_get;
+
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/w=
ireless/ath/ath9k/ar9003_eeprom.c
index a93bd63..85196de 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5140,6 +5140,11 @@ unsigned int ar9003_get_paprd_scale_factor(struct at=
h_hw *ah,
 	}
 }
=20
+static u32 ath9k_hw_ar9300_get_switch_com(struct ath_hw *ah)
+{
+	return 0;
+}
+
 const struct eeprom_ops eep_ar9300_ops =3D {
 	.check_eeprom =3D ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom =3D ath9k_hw_ar9300_get_eeprom,
@@ -5150,5 +5155,6 @@ const struct eeprom_ops eep_ar9300_ops =3D {
 	.set_board_values =3D ath9k_hw_ar9300_set_board_values,
 	.set_addac =3D ath9k_hw_ar9300_set_addac,
 	.set_txpower =3D ath9k_hw_ar9300_set_txpower,
-	.get_spur_channel =3D ath9k_hw_ar9300_get_spur_channel
+	.get_spur_channel =3D ath9k_hw_ar9300_get_spur_channel,
+	.get_switch_com =3D ath9k_hw_ar9300_get_switch_com
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless=
/ath/ath9k/eeprom.h
index 5ff7ab9..98da6c5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -656,6 +656,7 @@ struct eeprom_ops {
 			   u16 cfgCtl, u8 twiceAntennaReduction,
 			   u8 powerLimit, bool test);
 	u16 (*get_spur_channel)(struct ath_hw *ah, u16 i, bool is2GHz);
+	u32 (*get_switch_com)(struct ath_hw *ah);
 };
=20
 void ath9k_hw_analog_shift_regwrite(struct ath_hw *ah, u32 reg, u32 val);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wirel=
ess/ath/ath9k/eeprom_4k.c
index 9a7520f..b295ac0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -815,6 +815,30 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 }
=20
 /*
+ * Get common antenna configuration bits
+ */
+static u32 ath9k_hw_4k_get_switch_com(struct ath_hw *ah)
+{
+	struct ath_hw_switch_com_profile *easp;
+	struct ar5416_eeprom_4k *eep =3D &ah->eeprom.map4k;
+	struct modal_eep_4k_header *pModal =3D &eep->modalHeader;
+
+	/* return value from eeprom if there are no profiles */
+	if (!ah->switch_com_profiles)
+		return pModal->antCtrlCommon;
+
+	/* find matching value for profile id */
+	for(easp =3D ah->switch_com_profiles;easp->id >=3D 0; easp++) {
+		if ( easp->id =3D=3D ah->selected_extant_profile )
+			return easp->switch_com_value;
+	}
+
+	/* invalid profile selected, return an error */
+	return 1;
+}
+
+
+/*
  * Read EEPROM header info and program the device for correct operation
  * given the channel value.
  */
@@ -833,7 +857,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw =
*ah,
 	pModal =3D &eep->modalHeader;
 	txRxAttenLocal =3D 23;
=20
-	REG_WRITE(ah, AR_PHY_SWITCH_COM, pModal->antCtrlCommon);
+	REG_WRITE(ah, AR_PHY_SWITCH_COM, ath9k_hw_4k_get_switch_com(ah));
=20
 	/* Single chain for 4K EEPROM*/
 	ath9k_hw_4k_set_gain(ah, pModal, eep, txRxAttenLocal);
@@ -1112,5 +1136,6 @@ const struct eeprom_ops eep_4k_ops =3D {
 	.get_eeprom_rev		=3D ath9k_hw_4k_get_eeprom_rev,
 	.set_board_values	=3D ath9k_hw_4k_set_board_values,
 	.set_txpower		=3D ath9k_hw_4k_set_txpower,
-	.get_spur_channel	=3D ath9k_hw_4k_get_spur_channel
+	.get_spur_channel	=3D ath9k_hw_4k_get_spur_channel,
+	.get_switch_com		=3D ath9k_hw_4k_get_switch_com
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wir=
eless/ath/ath9k/eeprom_9287.c
index 4f5c50a..cf634a7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1062,6 +1062,11 @@ static u16 ath9k_hw_ar9287_get_spur_channel(struct a=
th_hw *ah,
 #undef EEP_MAP9287_SPURCHAN
 }
=20
+static u32 ath9k_hw_ar9287_get_switch_com(struct ath_hw *ah)
+{
+	return 0;
+}
+
 const struct eeprom_ops eep_ar9287_ops =3D {
 	.check_eeprom		=3D ath9k_hw_ar9287_check_eeprom,
 	.get_eeprom		=3D ath9k_hw_ar9287_get_eeprom,
@@ -1071,5 +1076,6 @@ const struct eeprom_ops eep_ar9287_ops =3D {
 	.get_eeprom_rev		=3D ath9k_hw_ar9287_get_eeprom_rev,
 	.set_board_values	=3D ath9k_hw_ar9287_set_board_values,
 	.set_txpower		=3D ath9k_hw_ar9287_set_txpower,
-	.get_spur_channel	=3D ath9k_hw_ar9287_get_spur_channel
+	.get_spur_channel	=3D ath9k_hw_ar9287_get_spur_channel,
+	.get_switch_com		=3D ath9k_hw_ar9287_get_switch_com
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wire=
less/ath/ath9k/eeprom_def.c
index 81e6296..37f60d3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1420,6 +1420,11 @@ static u16 ath9k_hw_def_get_spur_channel(struct ath_=
hw *ah, u16 i, bool is2GHz)
 #undef EEP_DEF_SPURCHAN
 }
=20
+static u32 ath9k_hw_def_get_switch_com(struct ath_hw *ah)
+{
+	return 0;
+}
+
 const struct eeprom_ops eep_def_ops =3D {
 	.check_eeprom		=3D ath9k_hw_def_check_eeprom,
 	.get_eeprom		=3D ath9k_hw_def_get_eeprom,
@@ -1430,5 +1435,6 @@ const struct eeprom_ops eep_def_ops =3D {
 	.set_board_values	=3D ath9k_hw_def_set_board_values,
 	.set_addac		=3D ath9k_hw_def_set_addac,
 	.set_txpower		=3D ath9k_hw_def_set_txpower,
-	.get_spur_channel	=3D ath9k_hw_def_get_spur_channel
+	.get_spur_channel	=3D ath9k_hw_def_get_spur_channel,
+	.get_switch_com		=3D ath9k_hw_def_get_switch_com
 };
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath=
/ath9k/hw.h
index 3cb878c..a33e355 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -545,6 +545,25 @@ struct ath_hw_radar_conf {
 	bool ext_channel;
 };
=20
+
+/**
+ * struct ath_hw_switch_com_profile - external antenna switch settings
+ *
+ * This structure holds a platform_data-supplied alternative value
+ * of AR_PHY_SWITCH_COM.
+ *
+ * @id: unique identifier
+ * @switch_com_value: bit-field to be set in register AR_PHY_SWITCH_COM
+ * @name: profile name
+ * @desc: profile description
+ */
+struct ath_hw_switch_com_profile {
+	int id;
+	u32 switch_com_value;
+	char *name;
+	char *desc;
+};
+
 /**
  * struct ath_hw_private_ops - callbacks used internally by hardware code
  *
@@ -643,6 +662,9 @@ struct ath_hw_ops {
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
=20
+	u32 (*extant_switchcom_get)(struct ath_hw *ah);
+	void (*extant_switchcom_set)(struct ath_hw *ah,
+			u32 switch_com_value);
 };
=20
 struct ath_nf_limits {
@@ -882,6 +904,12 @@ struct ath_hw {
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
+
+	/*
+	 * External antenna switch configuration profiles
+	 */
+	struct ath_hw_switch_com_profile *switch_com_profiles;
+	u32 selected_extant_profile;
 };
=20
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/a=
th/ath9k/init.c
index e046de9..6420b00 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -522,6 +522,43 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->ant_comb.count =3D ATH_ANT_DIV_COMB_INIT_COUNT;
 }
=20
+static int ath9k_init_switch_com_profiles(struct ath_softc *sc, struct ath=
_hw *ah)
+{
+	struct ath9k_platform_data *pdata =3D sc->dev->platform_data;
+	int i,j;
+
+	/* count valid profiles in platform data */
+	j=3D0;
+	for(i=3D0;i<ATH9K_PLAT_MAX_SWITCH_COM_PROFILES;i++) {
+		if ( pdata->switch_com_profiles[i].name )
+			j++;
+	}
+	/*
+	 * allocate space for the j profiles found + 1 for termination
+	 */
+	if ( j>0 && ! ah->switch_com_profiles ) {
+		ah->switch_com_profiles =3D kcalloc(j + 1,
+			sizeof(struct ath_hw_switch_com_profile),
+			GFP_KERNEL);
+		if ( ! ah->switch_com_profiles )
+			return -ENOMEM;
+	}
+	/* populate the space from platform_data */
+	j=3D0;
+	for(i=3D0;i<ATH9K_PLAT_MAX_SWITCH_COM_PROFILES;i++) {
+		if ( pdata->switch_com_profiles[i].name ) {
+			ah->switch_com_profiles[j].id =3D j;
+			ah->switch_com_profiles[j].switch_com_value =3D pdata->switch_com_profi=
les[i].val;
+			ah->switch_com_profiles[j].name =3D pdata->switch_com_profiles[i].name;
+			ah->switch_com_profiles[j].desc =3D pdata->switch_com_profiles[i].desc;
+			j++;
+		}
+	}
+	if ( j>0 )
+		ah->switch_com_profiles[j].id =3D -1;
+	return 0;
+}
+
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
@@ -605,11 +642,15 @@ static int ath9k_init_softc(u16 devid, struct ath_sof=
tc *sc,
 	if (ret)
 		goto err_btcoex;
=20
+	ret =3D ath9k_init_switch_com_profiles(sc, ah);
+	if (ret)
+		goto err_easp;
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
=20
 	return 0;
=20
+err_easp:
 err_btcoex:
 	for (i =3D 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
@@ -618,6 +659,8 @@ err_queues:
 	ath9k_hw_deinit(ah);
 err_hw:
=20
+	if ( ah->switch_com_profiles )
+		kfree(ah->switch_com_profiles);
 	kfree(ah);
 	sc->sc_ah =3D NULL;
=20
@@ -733,6 +776,48 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct i=
eee80211_hw *hw)
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
=20
+int ath9k_set_extant_profiles(struct ath_hw *ah, struct ieee80211_hw *hw)
+{
+	struct ath_common *common =3D ath9k_hw_common(ah);
+	int i;
+	/* nothing to do if there are no profiles */
+	if (! ah->switch_com_profiles)
+		return 0;
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Device got extant support.\n");
+	hw->wiphy->flags |=3D WIPHY_FLAG_HAS_EXTANT_SWITCH;
+
+	/* allocate profile structure in wiphy for all available profiles + 1 */
+	for (i=3D0; ah->switch_com_profiles[i].id >=3D 0; i++);
+	hw->wiphy->extant =3D kcalloc(i+1, sizeof(struct wiphy_extant_profile), G=
FP_KERNEL);
+	if ( ! hw->wiphy->extant )
+		return -ENOMEM;
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Detected %d antenna configuration profiles:\n", i);
+	/* populate wiphy->exant structure */
+	for (i=3D0; ah->switch_com_profiles[i].id >=3D 0; i++) {
+		hw->wiphy->extant[i].id =3D ah->switch_com_profiles[i].id;
+		hw->wiphy->extant[i].name =3D ah->switch_com_profiles[i].name;
+		hw->wiphy->extant[i].desc =3D ah->switch_com_profiles[i].desc;
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"\t%d \"%s\" (%s)\n",=20
+		hw->wiphy->extant[i].id,
+		hw->wiphy->extant[i].name,
+		hw->wiphy->extant[i].desc);
+	}
+	/* terminate with dummy */
+	hw->wiphy->extant[i].id =3D -1;
+	return 0;
+}
+
+void ath9k_free_extant_profiles(struct ieee80211_hw *hw)
+{
+	if (hw->wiphy->extant)
+		kfree(hw->wiphy->extant);
+}
+
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops)
 {
@@ -751,6 +836,11 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 	common =3D ath9k_hw_common(ah);
 	ath9k_set_hw_capab(sc, hw);
=20
+	/* Initialize extant profiles */
+	error =3D ath9k_set_extant_profiles(ah, hw);
+	if (error !=3D 0)
+		goto error_extant;
+
 	/* Initialize regulatory */
 	error =3D ath_regd_init(&common->regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
@@ -816,6 +906,8 @@ error_rx:
 error_tx:
 	/* Nothing */
 error_regd:
+	ath9k_free_extant_profiles(hw);
+error_extant:
 	ath9k_deinit_softc(sc);
 error_init:
 	return error;
@@ -863,6 +955,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
+	ath9k_free_extant_profiles(hw);
 	ath9k_deinit_softc(sc);
 }
=20
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/a=
th/ath9k/main.c
index e43c41c..8f03642 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2484,6 +2484,40 @@ static int ath9k_get_antenna(struct ieee80211_hw *hw=
, u32 *tx_ant, u32 *rx_ant)
 	return 0;
 }
=20
+static int ath9k_set_extant(struct ieee80211_hw *hw, u32 extant)
+{
+	struct ath_softc *sc =3D hw->priv;
+	struct ath_hw *ah =3D sc->sc_ah;
+	struct ath_common *common =3D ath9k_hw_common(ah);
+	u32 backup_extant =3D ah->selected_extant_profile;
+	u32 switch_com_value =3D 0;
+
+	ath_dbg(common, ATH_DBG_CONFIG, "entering set_extant(%d)\n", extant);
+
+	ah->selected_extant_profile =3D extant;
+	switch_com_value =3D ah->eep_ops->get_switch_com(ah);
+	if (switch_com_value & 0xf)
+		goto invalid_profile;
+
+	ath_dbg(common, ATH_DBG_CONFIG, "switch_com: %08x\n", switch_com_value);
+	return 0;
+
+invalid_profile:
+	ath_dbg(common, ATH_DBG_CONFIG, "invalid profile (%08x)\n", switch_com_va=
lue);
+	ah->selected_extant_profile =3D backup_extant;
+	return -EINVAL;
+}
+
+static int ath9k_get_extant(struct ieee80211_hw *hw, u32 *extant)
+{
+	struct ath_softc *sc =3D hw->priv;
+	struct ath_hw *ah =3D sc->sc_ah;
+	if (!ah->switch_com_profiles)
+		return -EINVAL;
+	*extant =3D ah->selected_extant_profile;
+	return 0;
+}
+
 struct ieee80211_ops ath9k_ops =3D {
 	.tx 		    =3D ath9k_tx,
 	.start 		    =3D ath9k_start,
@@ -2512,4 +2546,6 @@ struct ieee80211_ops ath9k_ops =3D {
 	.get_stats	    =3D ath9k_get_stats,
 	.set_antenna	    =3D ath9k_set_antenna,
 	.get_antenna	    =3D ath9k_get_antenna,
+	.set_extant	    =3D ath9k_set_extant,
+	.get_extant	    =3D ath9k_get_extant,
 };
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 6e3f54f..1bfe926 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -20,6 +20,7 @@
 #define _LINUX_ATH9K_PLATFORM_H
=20
 #define ATH9K_PLAT_EEP_MAX_WORDS	2048
+#define ATH9K_PLAT_MAX_SWITCH_COM_PROFILES	4
=20
 struct ath9k_platform_data {
 	u16 eeprom_data[ATH9K_PLAT_EEP_MAX_WORDS];
@@ -32,6 +33,11 @@ struct ath9k_platform_data {
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
+	struct {
+		u32 val;
+		char *name;
+		char *desc;
+	} switch_com_profiles[ATH9K_PLAT_MAX_SWITCH_COM_PROFILES];
 };
=20
 #endif /* _LINUX_ATH9K_PLATFORM_H */
--=20
1.7.4.1


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO07M2AAoJEDy9cKN/1Et0ydkP/As0QFztXs8O5Oa1q2PBfk0j
uDSsv6jkcsZEI6rgbGuMO1NlkQ8gtSWYtYLCk2ruGp3yluyAS14mn/15FiYbXmBs
6sDiE7zvPEEvy5LI+ZG6ZOSAoDK+okXp7ijcoqXsuAQ69lAeZWoBiXR+QLoKTnxg
WjhypKWnxVnRZiBkTJWBQs2ytAt7vDWcFOrayKPc5mmYhnIrHesoYsj4mxho31kS
13a3a3DkCThjx1Fb43HFjKiTI3uamAnrQfTV2evTkGcF/QksFTiLllpxF0jVXdow
S+wMTFDWGCmUpRloTuV7+3fZvJuMyw/BihzCaaOX7GLhfyMr+VJctC2y70POQpGh
c7BPGrSVZQ58OWqOY4GUCsFWNGFKCQ8HMBkp1YZiuK52+mWXjpXoINqeUmqUpaMl
i8AmWrnt6/cOnZRbbGK/G17aZPZSBfFC+ZaCGFzT1jXLzJIYY9u6xNgB339u+mkQ
hgxmbtuCQVCSEfOYOZRrr+o6dtqGxAdZ1HaSInpmF1miRMjA+VXpEHzxlYoThPCH
QObNcttjom9tH8nk0WoSgEulfoMroy4Vq8u3f1LEopW3s/PvFwpLwY/U3l6e4Huu
Qr9CVVVWeu+ryZSchf2hGjI5e7ewMvL3Fy5iOwDg3XNN/UpXZoHy/kygZ3LK/qT9
cv7/eEKSWDo/ltjWFnZ+
=gtCX
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
