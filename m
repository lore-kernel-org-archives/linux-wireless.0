Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41583 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2IQDnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 23:43:50 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20566.39994.158419.108234@gargle.gargle.HOWL> (sfid-20120917_054359_058935_31517DE0)
Date: Mon, 17 Sep 2012 09:12:50 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 2/3] compat-drivers: Add new cherry picked patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 ...ize-power-level-initialization-for-CTL_-2.patch |   36 +
 ...ndentation-in-ar9003_hw_set_power_per_rat.patch |  169 +++
 ...-ath9k-Simplify-rate-table-initialization.patch |  140 ++
 .../0005-ath9k-Cleanup-RC-init-API.patch           |  240 ++++
 .../0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch |   76 ++
 ...007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch |   47 +
 ...08-ath9k-Cleanup-index-retrieval-routines.patch |  137 ++
 .../0009-ath9k-Change-rateset-calculation.patch    |   87 ++
 ...10-ath9k-Remove-ath_rc_set_valid_rate_idx.patch |   54 +
 ...h9k-Unify-valid-rate-calculation-routines.patch |  124 ++
 ...ot-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch |   24 +
 .../0013-ath9k-Fix-RTS-CTS-rate-selection.patch    |   78 ++
 ...out-properly-before-calculating-rate-inde.patch |   55 +
 .../0015-ath9k-Cleanup-TX-status-API.patch         |  164 +++
 .../0016-ath9k-Remove-MIMO-PS-specific-code.patch  |   29 +
 .../0017-ath9k-Trim-rate-table.patch               |  600 +++++++++
 ...tune-rc_stats-to-display-only-valid-rates.patch |   34 +
 ...-not-enable-the-MIB-interrupt-in-the-inte.patch |   28 +
 ...h9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch |   61 +
 .../0030-ath9k_hw-small-optimization.patch         |   53 +
 .../0031-ath9k-Fix-TX-filter-usage.patch           |   42 +
 ...-Fix-invalid-MCI-GPM-index-access-caching.patch |   41 +
 ...k-Fix-BTCOEX-timer-triggering-comparision.patch |   46 +
 ...35-ath9k-Make-use-of-ath_stop_ani-wrapper.patch |   25 +
 ...9k-Cleanup-add-change_interface-callbacks.patch |  144 ++
 ...ad-and-apply-thermometer-settings-from-EE.patch |   78 ++
 ...w-Read-and-configure-thermocal-for-AR9462.patch |   65 +
 ...eneric-hardware-timer-interrupt-in-debugf.patch |   54 +
 ...hw-Add-version-revision-macros-for-AR9565.patch |   94 ++
 .../0046-ath9k_hw-Add-AR9565-initvals.patch        | 1405 ++++++++++++++++++++
 .../0047-ath9k_hw-Add-AR9565-HW-support.patch      |  269 ++++
 ...-ath9k-Set-correct-max-streams-for-AR9565.patch |   39 +
 ...9-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch |  165 +++
 ...k_hw-Program-correct-PLL-value-for-AR9565.patch |   23 +
 .../0051-ath9k-Add-PCI-ID-for-AR9565.patch         |   23 +
 ...-ath9k_hw-Wait-BT-calibration-to-complete.patch |   72 +
 ...0053-ath9k_hw-use-peak-detection-for-5GHz.patch |   22 +
 ...54-ath9k_hw-add-8-points-for-5G-temp-slop.patch |  112 ++
 ...k_hw-Handle-gentimer-termination-properly.patch |   30 +
 ...-ath9k_hw-Rename-antenna-diversity-macros.patch |  173 +++
 ...7-ath9k-Choose-correct-LED-pin-for-AR9565.patch |   22 +
 41 files changed, 5180 insertions(+)
 create mode 100644 linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
 create mode 100644 linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
 create mode 100644 linux-next-cherry-picks/0004-ath9k-Simplify-rate-table-initialization.patch
 create mode 100644 linux-next-cherry-picks/0005-ath9k-Cleanup-RC-init-API.patch
 create mode 100644 linux-next-cherry-picks/0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch
 create mode 100644 linux-next-cherry-picks/0007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
 create mode 100644 linux-next-cherry-picks/0008-ath9k-Cleanup-index-retrieval-routines.patch
 create mode 100644 linux-next-cherry-picks/0009-ath9k-Change-rateset-calculation.patch
 create mode 100644 linux-next-cherry-picks/0010-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
 create mode 100644 linux-next-cherry-picks/0011-ath9k-Unify-valid-rate-calculation-routines.patch
 create mode 100644 linux-next-cherry-picks/0012-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
 create mode 100644 linux-next-cherry-picks/0013-ath9k-Fix-RTS-CTS-rate-selection.patch
 create mode 100644 linux-next-cherry-picks/0014-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
 create mode 100644 linux-next-cherry-picks/0015-ath9k-Cleanup-TX-status-API.patch
 create mode 100644 linux-next-cherry-picks/0016-ath9k-Remove-MIMO-PS-specific-code.patch
 create mode 100644 linux-next-cherry-picks/0017-ath9k-Trim-rate-table.patch
 create mode 100644 linux-next-cherry-picks/0018-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
 create mode 100644 linux-next-cherry-picks/0022-ath9k_hw-do-not-enable-the-MIB-interrupt-in-the-inte.patch
 create mode 100644 linux-next-cherry-picks/0028-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
 create mode 100644 linux-next-cherry-picks/0030-ath9k_hw-small-optimization.patch
 create mode 100644 linux-next-cherry-picks/0031-ath9k-Fix-TX-filter-usage.patch
 create mode 100644 linux-next-cherry-picks/0033-ath9k_hw-Fix-invalid-MCI-GPM-index-access-caching.patch
 create mode 100644 linux-next-cherry-picks/0034-ath9k-Fix-BTCOEX-timer-triggering-comparision.patch
 create mode 100644 linux-next-cherry-picks/0035-ath9k-Make-use-of-ath_stop_ani-wrapper.patch
 create mode 100644 linux-next-cherry-picks/0037-ath9k-Cleanup-add-change_interface-callbacks.patch
 create mode 100644 linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
 create mode 100644 linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
 create mode 100644 linux-next-cherry-picks/0043-ath9k-Add-Generic-hardware-timer-interrupt-in-debugf.patch
 create mode 100644 linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0046-ath9k_hw-Add-AR9565-initvals.patch
 create mode 100644 linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
 create mode 100644 linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0049-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0051-ath9k-Add-PCI-ID-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0052-ath9k_hw-Wait-BT-calibration-to-complete.patch
 create mode 100644 linux-next-cherry-picks/0053-ath9k_hw-use-peak-detection-for-5GHz.patch
 create mode 100644 linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
 create mode 100644 linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
 create mode 100644 linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
 create mode 100644 linux-next-cherry-picks/0057-ath9k-Choose-correct-LED-pin-for-AR9565.patch

diff --git a/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch b/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
new file mode 100644
index 0000000..61fc1ad
--- /dev/null
+++ b/linux-next-cherry-picks/0002-ath9k-optimize-power-level-initialization-for-CTL_-2.patch
@@ -0,0 +1,36 @@
+From 5fc512439f7a235e6b0ae05e42fa7d875fff3849 Mon Sep 17 00:00:00 2001
+From: Gabor Juhos <juhosg@openwrt.org>
+Date: Thu, 2 Aug 2012 16:00:51 +0200
+Subject: [PATCH] ath9k: optimize power level initialization for CTL_[25]GHT20
+
+The first part of the power array is initialized in a loop
+and the last two values are initialized separately. Extend
+the loop to cover the last two items, and remove the separate
+initialization.
+
+Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 8 +-------
+ 1 file changed, 1 insertion(+), 7 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -4963,16 +4963,10 @@ static void ar9003_hw_set_power_per_rate
+ 			case CTL_5GHT20:
+ 			case CTL_2GHT20:
+ 				for (i = ALL_TARGET_HT20_0_8_16;
+-				     i <= ALL_TARGET_HT20_21; i++)
++				     i <= ALL_TARGET_HT20_23; i++)
+ 					pPwrArray[i] =
+ 					  (u8)min((u16)pPwrArray[i],
+ 						  minCtlPower);
+-				pPwrArray[ALL_TARGET_HT20_22] =
+-				  (u8)min((u16)pPwrArray[ALL_TARGET_HT20_22],
+-					  minCtlPower);
+-				pPwrArray[ALL_TARGET_HT20_23] =
+-				  (u8)min((u16)pPwrArray[ALL_TARGET_HT20_23],
+-					   minCtlPower);
+ 				break;
+ 			case CTL_5GHT40:
+ 			case CTL_2GHT40:
diff --git a/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch b/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
new file mode 100644
index 0000000..d7c6fc8
--- /dev/null
+++ b/linux-next-cherry-picks/0003-ath9k-fix-indentation-in-ar9003_hw_set_power_per_rat.patch
@@ -0,0 +1,169 @@
+From 2a0b50c7703930a1f5d1d32ae116d988e9612cb6 Mon Sep 17 00:00:00 2001
+From: Gabor Juhos <juhosg@openwrt.org>
+Date: Thu, 2 Aug 2012 16:00:52 +0200
+Subject: [PATCH] ath9k: fix indentation in ar9003_hw_set_power_per_rate_table
+
+The current indentation is off by one tab.
+
+Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 143 ++++++++++++-------------
+ 1 file changed, 69 insertions(+), 74 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -4901,84 +4901,79 @@ static void ar9003_hw_set_power_per_rate
+ 				i, cfgCtl, pCtlMode[ctlMode], ctlIndex[i],
+ 				chan->channel);
+ 
+-				/*
+-				 * compare test group from regulatory
+-				 * channel list with test mode from pCtlMode
+-				 * list
+-				 */
+-				if ((((cfgCtl & ~CTL_MODE_M) |
+-				       (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+-					ctlIndex[i]) ||
+-				    (((cfgCtl & ~CTL_MODE_M) |
+-				       (pCtlMode[ctlMode] & CTL_MODE_M)) ==
+-				     ((ctlIndex[i] & CTL_MODE_M) |
+-				       SD_NO_CTL))) {
+-					twiceMinEdgePower =
+-					  ar9003_hw_get_max_edge_power(pEepData,
+-								       freq, i,
+-								       is2ghz);
+-
+-					if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL)
+-						/*
+-						 * Find the minimum of all CTL
+-						 * edge powers that apply to
+-						 * this channel
+-						 */
+-						twiceMaxEdgePower =
+-							min(twiceMaxEdgePower,
+-							    twiceMinEdgePower);
+-						else {
+-							/* specific */
+-							twiceMaxEdgePower =
+-							  twiceMinEdgePower;
+-							break;
+-						}
++			/*
++			 * compare test group from regulatory
++			 * channel list with test mode from pCtlMode
++			 * list
++			 */
++			if ((((cfgCtl & ~CTL_MODE_M) |
++			       (pCtlMode[ctlMode] & CTL_MODE_M)) ==
++				ctlIndex[i]) ||
++			    (((cfgCtl & ~CTL_MODE_M) |
++			       (pCtlMode[ctlMode] & CTL_MODE_M)) ==
++			     ((ctlIndex[i] & CTL_MODE_M) |
++			       SD_NO_CTL))) {
++				twiceMinEdgePower =
++				  ar9003_hw_get_max_edge_power(pEepData,
++							       freq, i,
++							       is2ghz);
++
++				if ((cfgCtl & ~CTL_MODE_M) == SD_NO_CTL)
++					/*
++					 * Find the minimum of all CTL
++					 * edge powers that apply to
++					 * this channel
++					 */
++					twiceMaxEdgePower =
++						min(twiceMaxEdgePower,
++						    twiceMinEdgePower);
++				else {
++					/* specific */
++					twiceMaxEdgePower = twiceMinEdgePower;
++					break;
+ 				}
+ 			}
++		}
+ 
+-			minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
++		minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
+ 
+-			ath_dbg(common, REGULATORY,
+-				"SEL-Min ctlMode %d pCtlMode %d 2xMaxEdge %d sP %d minCtlPwr %d\n",
+-				ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
+-				scaledPower, minCtlPower);
+-
+-			/* Apply ctl mode to correct target power set */
+-			switch (pCtlMode[ctlMode]) {
+-			case CTL_11B:
+-				for (i = ALL_TARGET_LEGACY_1L_5L;
+-				     i <= ALL_TARGET_LEGACY_11S; i++)
+-					pPwrArray[i] =
+-					  (u8)min((u16)pPwrArray[i],
+-						  minCtlPower);
+-				break;
+-			case CTL_11A:
+-			case CTL_11G:
+-				for (i = ALL_TARGET_LEGACY_6_24;
+-				     i <= ALL_TARGET_LEGACY_54; i++)
+-					pPwrArray[i] =
+-					  (u8)min((u16)pPwrArray[i],
+-						  minCtlPower);
+-				break;
+-			case CTL_5GHT20:
+-			case CTL_2GHT20:
+-				for (i = ALL_TARGET_HT20_0_8_16;
+-				     i <= ALL_TARGET_HT20_23; i++)
+-					pPwrArray[i] =
+-					  (u8)min((u16)pPwrArray[i],
+-						  minCtlPower);
+-				break;
+-			case CTL_5GHT40:
+-			case CTL_2GHT40:
+-				for (i = ALL_TARGET_HT40_0_8_16;
+-				     i <= ALL_TARGET_HT40_23; i++)
+-					pPwrArray[i] =
+-					  (u8)min((u16)pPwrArray[i],
+-						  minCtlPower);
+-				break;
+-			default:
+-			    break;
+-			}
++		ath_dbg(common, REGULATORY,
++			"SEL-Min ctlMode %d pCtlMode %d 2xMaxEdge %d sP %d minCtlPwr %d\n",
++			ctlMode, pCtlMode[ctlMode], twiceMaxEdgePower,
++			scaledPower, minCtlPower);
++
++		/* Apply ctl mode to correct target power set */
++		switch (pCtlMode[ctlMode]) {
++		case CTL_11B:
++			for (i = ALL_TARGET_LEGACY_1L_5L;
++			     i <= ALL_TARGET_LEGACY_11S; i++)
++				pPwrArray[i] = (u8)min((u16)pPwrArray[i],
++						       minCtlPower);
++			break;
++		case CTL_11A:
++		case CTL_11G:
++			for (i = ALL_TARGET_LEGACY_6_24;
++			     i <= ALL_TARGET_LEGACY_54; i++)
++				pPwrArray[i] = (u8)min((u16)pPwrArray[i],
++						       minCtlPower);
++			break;
++		case CTL_5GHT20:
++		case CTL_2GHT20:
++			for (i = ALL_TARGET_HT20_0_8_16;
++			     i <= ALL_TARGET_HT20_23; i++)
++				pPwrArray[i] = (u8)min((u16)pPwrArray[i],
++						       minCtlPower);
++			break;
++		case CTL_5GHT40:
++		case CTL_2GHT40:
++			for (i = ALL_TARGET_HT40_0_8_16;
++			     i <= ALL_TARGET_HT40_23; i++)
++				pPwrArray[i] = (u8)min((u16)pPwrArray[i],
++						       minCtlPower);
++			break;
++		default:
++			break;
++		}
+ 	} /* end ctl mode checking */
+ }
+ 
diff --git a/linux-next-cherry-picks/0004-ath9k-Simplify-rate-table-initialization.patch b/linux-next-cherry-picks/0004-ath9k-Simplify-rate-table-initialization.patch
new file mode 100644
index 0000000..9876b83
--- /dev/null
+++ b/linux-next-cherry-picks/0004-ath9k-Simplify-rate-table-initialization.patch
@@ -0,0 +1,140 @@
+From 62a291869bac318d5e6760e45979bcd047dcd503 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:45:52 +0530
+Subject: [PATCH] ath9k: Simplify rate table initialization
+
+Remove various local variables that duplicate information
+already stored in mac80211.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 65 ++++++++++---------------------------
+ 1 file changed, 17 insertions(+), 48 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1185,8 +1185,6 @@ struct ath_rate_table *ath_choose_rate_t
+ 					     enum ieee80211_band band,
+ 					     bool is_ht)
+ {
+-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-
+ 	switch(band) {
+ 	case IEEE80211_BAND_2GHZ:
+ 		if (is_ht)
+@@ -1197,7 +1195,6 @@ struct ath_rate_table *ath_choose_rate_t
+ 			return &ar5416_11na_ratetable;
+ 		return &ar5416_11a_ratetable;
+ 	default:
+-		ath_dbg(common, CONFIG, "Invalid band\n");
+ 		return NULL;
+ 	}
+ }
+@@ -1278,8 +1275,7 @@ static void ath_rc_init(struct ath_softc
+ 		ath_rc_priv->ht_cap);
+ }
+ 
+-static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
+-			       bool is_cw40, bool is_sgi)
++static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta)
+ {
+ 	u8 caps = 0;
+ 
+@@ -1289,9 +1285,10 @@ static u8 ath_rc_build_ht_caps(struct at
+ 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
+ 		else if (sta->ht_cap.mcs.rx_mask[1])
+ 			caps |= WLAN_RC_DS_FLAG;
+-		if (is_cw40)
++		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+ 			caps |= WLAN_RC_40_FLAG;
+-		if (is_sgi)
++		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40 ||
++		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
+ 			caps |= WLAN_RC_SGI_FLAG;
+ 	}
+ 
+@@ -1393,9 +1390,9 @@ static void ath_rate_init(void *priv, st
+                           struct ieee80211_sta *sta, void *priv_sta)
+ {
+ 	struct ath_softc *sc = priv;
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	const struct ath_rate_table *rate_table;
+-	bool is_cw40, is_sgi = false;
+ 	int i, j = 0;
+ 
+ 	for (i = 0; i < sband->n_bitrates; i++) {
+@@ -1417,19 +1414,14 @@ static void ath_rate_init(void *priv, st
+ 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
+ 	}
+ 
+-	is_cw40 = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+-
+-	if (is_cw40)
+-		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40);
+-	else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
+-		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20);
+-
+-	/* Choose rate table first */
+-
+ 	rate_table = ath_choose_rate_table(sc, sband->band,
+-	                      sta->ht_cap.ht_supported);
++					   sta->ht_cap.ht_supported);
++	if (!rate_table) {
++		ath_err(common, "No rate table chosen\n");
++		return;
++	}
+ 
+-	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi);
++	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+ 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+ }
+ 
+@@ -1440,39 +1432,16 @@ static void ath_rate_update(void *priv,
+ 	struct ath_softc *sc = priv;
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	const struct ath_rate_table *rate_table = NULL;
+-	bool oper_cw40 = false, oper_sgi;
+-	bool local_cw40 = !!(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG);
+-	bool local_sgi = !!(ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG);
+-
+-	/* FIXME: Handle AP mode later when we support CWM */
+ 
+ 	if (changed & IEEE80211_RC_BW_CHANGED) {
+-		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+-			return;
+-
+-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+-			oper_cw40 = true;
+-
+-		if (oper_cw40)
+-			oper_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+-				   true : false;
+-		else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
+-			oper_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+-				   true : false;
+-		else
+-			oper_sgi = false;
+-
+-		if ((local_cw40 != oper_cw40) || (local_sgi != oper_sgi)) {
+-			rate_table = ath_choose_rate_table(sc, sband->band,
++		rate_table = ath_choose_rate_table(sc, sband->band,
+ 						   sta->ht_cap.ht_supported);
+-			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta,
+-						   oper_cw40, oper_sgi);
+-			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+-
+-			ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
+-				"Operating HT Bandwidth changed to: %d\n",
+-				sc->hw->conf.channel_type);
+-		}
++		ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
++		ath_rc_init(sc, priv_sta, sband, sta, rate_table);
++
++		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
++			"Operating HT Bandwidth changed to: %d\n",
++			sc->hw->conf.channel_type);
+ 	}
+ }
+ 
diff --git a/linux-next-cherry-picks/0005-ath9k-Cleanup-RC-init-API.patch b/linux-next-cherry-picks/0005-ath9k-Cleanup-RC-init-API.patch
new file mode 100644
index 0000000..0f08b63
--- /dev/null
+++ b/linux-next-cherry-picks/0005-ath9k-Cleanup-RC-init-API.patch
@@ -0,0 +1,240 @@
+From ea2771f642315847cdc0d392602fa3039af41743 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:04 +0530
+Subject: [PATCH] ath9k: Cleanup RC init API
+
+A reference to the rate table is stored inside the
+private structure, so there is no need to pass "rate_table"
+around.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 99 +++++++++++++------------------------
+ 1 file changed, 35 insertions(+), 64 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -405,9 +405,9 @@ static int ath_rc_get_rateindex(const st
+ 	return rix;
+ }
+ 
+-static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
+-				   struct ath_rate_priv *ath_rc_priv)
++static void ath_rc_sort_validrates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u8 i, j, idx, idx_next;
+ 
+ 	for (i = ath_rc_priv->max_valid_rate - 1; i > 0; i--) {
+@@ -424,14 +424,6 @@ static void ath_rc_sort_validrates(const
+ 	}
+ }
+ 
+-static void ath_rc_init_valid_rate_idx(struct ath_rate_priv *ath_rc_priv)
+-{
+-	u8 i;
+-
+-	for (i = 0; i < ath_rc_priv->rate_table_size; i++)
+-		ath_rc_priv->valid_rate_index[i] = 0;
+-}
+-
+ static inline void ath_rc_set_valid_rate_idx(struct ath_rate_priv *ath_rc_priv,
+ 					   u8 index, int valid_tx_rate)
+ {
+@@ -495,10 +487,9 @@ ath_rc_get_lower_rix(const struct ath_ra
+ 	return 0;
+ }
+ 
+-static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
+-				 const struct ath_rate_table *rate_table,
+-				 u32 capflag)
++static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u8 i, hi = 0;
+ 
+ 	for (i = 0; i < rate_table->rate_cnt; i++) {
+@@ -506,7 +497,7 @@ static u8 ath_rc_init_validrates(struct
+ 			u32 phy = rate_table->info[i].phy;
+ 			u8 valid_rate_count = 0;
+ 
+-			if (!ath_rc_valid_phyrate(phy, capflag, 0))
++			if (!ath_rc_valid_phyrate(phy, ath_rc_priv->ht_cap, 0))
+ 				continue;
+ 
+ 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+@@ -521,14 +512,13 @@ static u8 ath_rc_init_validrates(struct
+ 	return hi;
+ }
+ 
+-static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
+-				const struct ath_rate_table *rate_table,
+-				struct ath_rateset *rateset,
+-				u32 capflag)
++static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
++	u32 capflag = ath_rc_priv->ht_cap;
+ 	u8 i, j, hi = 0;
+ 
+-	/* Use intersection of working rates and valid rates */
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+ 			u32 phy = rate_table->info[j].phy;
+@@ -565,13 +555,13 @@ static u8 ath_rc_setvalid_rates(struct a
+ 	return hi;
+ }
+ 
+-static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
+-				  const struct ath_rate_table *rate_table,
+-				  struct ath_rateset *rateset, u32 capflag)
++static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
++	u32 capflag = ath_rc_priv->ht_cap;
+ 	u8 i, j, hi = 0;
+ 
+-	/* Use intersection of working rates and valid rates */
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+ 			u32 phy = rate_table->info[j].phy;
+@@ -1200,28 +1190,20 @@ struct ath_rate_table *ath_choose_rate_t
+ }
+ 
+ static void ath_rc_init(struct ath_softc *sc,
+-			struct ath_rate_priv *ath_rc_priv,
+-			struct ieee80211_supported_band *sband,
+-			struct ieee80211_sta *sta,
+-			const struct ath_rate_table *rate_table)
++			struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	struct ath_rateset *ht_mcs = &ath_rc_priv->neg_ht_rates;
+ 	u8 i, j, k, hi = 0, hthi = 0;
+ 
+-	/* Initial rate table size. Will change depending
+-	 * on the working rate set */
+ 	ath_rc_priv->rate_table_size = RATE_TABLE_SIZE;
+ 
+-	/* Initialize thresholds according to the global rate table */
+ 	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
+ 		ath_rc_priv->per[i] = 0;
++		ath_rc_priv->valid_rate_index[i] = 0;
+ 	}
+ 
+-	/* Determine the valid rates */
+-	ath_rc_init_valid_rate_idx(ath_rc_priv);
+-
+ 	for (i = 0; i < WLAN_RC_PHY_MAX; i++) {
+ 		for (j = 0; j < RATE_TABLE_SIZE; j++)
+ 			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
+@@ -1229,25 +1211,19 @@ static void ath_rc_init(struct ath_softc
+ 	}
+ 
+ 	if (!rateset->rs_nrates) {
+-		/* No working rate, just initialize valid rates */
+-		hi = ath_rc_init_validrates(ath_rc_priv, rate_table,
+-					    ath_rc_priv->ht_cap);
++		hi = ath_rc_init_validrates(ath_rc_priv);
+ 	} else {
+-		/* Use intersection of working rates and valid rates */
+-		hi = ath_rc_setvalid_rates(ath_rc_priv, rate_table,
+-					   rateset, ath_rc_priv->ht_cap);
+-		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG) {
+-			hthi = ath_rc_setvalid_htrates(ath_rc_priv,
+-						       rate_table,
+-						       ht_mcs,
+-						       ath_rc_priv->ht_cap);
+-		}
++		hi = ath_rc_setvalid_rates(ath_rc_priv);
++
++		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG)
++			hthi = ath_rc_setvalid_htrates(ath_rc_priv);
++
+ 		hi = max(hi, hthi);
+ 	}
+ 
+ 	ath_rc_priv->rate_table_size = hi + 1;
+ 	ath_rc_priv->rate_max_phy = 0;
+-	BUG_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
++	WARN_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
+ 
+ 	for (i = 0, k = 0; i < WLAN_RC_PHY_MAX; i++) {
+ 		for (j = 0; j < ath_rc_priv->valid_phy_ratecnt[i]; j++) {
+@@ -1255,21 +1231,20 @@ static void ath_rc_init(struct ath_softc
+ 				ath_rc_priv->valid_phy_rateidx[i][j];
+ 		}
+ 
+-		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, 1)
+-		    || !ath_rc_priv->valid_phy_ratecnt[i])
++		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, 1) ||
++		    !ath_rc_priv->valid_phy_ratecnt[i])
+ 			continue;
+ 
+ 		ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
+ 	}
+-	BUG_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
+-	BUG_ON(k > RATE_TABLE_SIZE);
++	WARN_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
++	WARN_ON(k > RATE_TABLE_SIZE);
+ 
+ 	ath_rc_priv->max_valid_rate = k;
+-	ath_rc_sort_validrates(rate_table, ath_rc_priv);
++	ath_rc_sort_validrates(ath_rc_priv);
+ 	ath_rc_priv->rate_max_phy = (k > 4) ?
+-					ath_rc_priv->valid_rate_index[k-4] :
+-					ath_rc_priv->valid_rate_index[k-1];
+-	ath_rc_priv->rate_table = rate_table;
++		ath_rc_priv->valid_rate_index[k-4] :
++		ath_rc_priv->valid_rate_index[k-1];
+ 
+ 	ath_dbg(common, CONFIG, "RC Initialized with capabilities: 0x%x\n",
+ 		ath_rc_priv->ht_cap);
+@@ -1392,7 +1367,6 @@ static void ath_rate_init(void *priv, st
+ 	struct ath_softc *sc = priv;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+-	const struct ath_rate_table *rate_table;
+ 	int i, j = 0;
+ 
+ 	for (i = 0; i < sband->n_bitrates; i++) {
+@@ -1414,15 +1388,15 @@ static void ath_rate_init(void *priv, st
+ 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
+ 	}
+ 
+-	rate_table = ath_choose_rate_table(sc, sband->band,
+-					   sta->ht_cap.ht_supported);
+-	if (!rate_table) {
++	ath_rc_priv->rate_table = ath_choose_rate_table(sc, sband->band,
++							sta->ht_cap.ht_supported);
++	if (!ath_rc_priv->rate_table) {
+ 		ath_err(common, "No rate table chosen\n");
+ 		return;
+ 	}
+ 
+ 	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+-	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
++	ath_rc_init(sc, priv_sta);
+ }
+ 
+ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
+@@ -1431,13 +1405,10 @@ static void ath_rate_update(void *priv,
+ {
+ 	struct ath_softc *sc = priv;
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+-	const struct ath_rate_table *rate_table = NULL;
+ 
+ 	if (changed & IEEE80211_RC_BW_CHANGED) {
+-		rate_table = ath_choose_rate_table(sc, sband->band,
+-						   sta->ht_cap.ht_supported);
+ 		ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+-		ath_rc_init(sc, priv_sta, sband, sta, rate_table);
++		ath_rc_init(sc, priv_sta);
+ 
+ 		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
+ 			"Operating HT Bandwidth changed to: %d\n",
diff --git a/linux-next-cherry-picks/0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch b/linux-next-cherry-picks/0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch
new file mode 100644
index 0000000..5301ffd
--- /dev/null
+++ b/linux-next-cherry-picks/0006-ath9k-Cleanup-ath_rc_setvalid_rates.patch
@@ -0,0 +1,76 @@
+From c05ea151770f6508e611b789f84c8bf57fa267cd Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:11 +0530
+Subject: [PATCH] ath9k: Cleanup ath_rc_setvalid_rates
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 49 ++++++++++++++++---------------------
+ 1 file changed, 21 insertions(+), 28 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -516,39 +516,32 @@ static u8 ath_rc_setvalid_rates(struct a
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+-	u32 capflag = ath_rc_priv->ht_cap;
+-	u8 i, j, hi = 0;
++	u32 phy, capflag = ath_rc_priv->ht_cap;
++	u16 rate_flags;
++	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+ 
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+-			u32 phy = rate_table->info[j].phy;
+-			u16 rate_flags = rate_table->info[j].rate_flags;
+-			u8 rate = rateset->rs_rates[i];
+-			u8 dot11rate = rate_table->info[j].dot11rate;
+-
+-			/* We allow a rate only if its valid and the
+-			 * capflag matches one of the validity
+-			 * (VALID/VALID_20/VALID_40) flags */
+-
+-			if ((rate == dot11rate) &&
+-			    (rate_flags & WLAN_RC_CAP_MODE(capflag)) ==
+-			    WLAN_RC_CAP_MODE(capflag) &&
+-			    (rate_flags & WLAN_RC_CAP_STREAM(capflag)) &&
+-			    !WLAN_RC_PHY_HT(phy)) {
+-				u8 valid_rate_count = 0;
+-
+-				if (!ath_rc_valid_phyrate(phy, capflag, 0))
+-					continue;
+-
+-				valid_rate_count =
+-					ath_rc_priv->valid_phy_ratecnt[phy];
+-
+-				ath_rc_priv->valid_phy_rateidx[phy]
+-					[valid_rate_count] = j;
+-				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-				ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+-				hi = max(hi, j);
+-			}
++			phy = rate_table->info[j].phy;
++			rate_flags = rate_table->info[j].rate_flags;
++			rate = rateset->rs_rates[i];
++			dot11rate = rate_table->info[j].dot11rate;
++
++			if (rate != dot11rate
++			    || ((rate_flags & WLAN_RC_CAP_MODE(capflag)) !=
++				WLAN_RC_CAP_MODE(capflag))
++			    || !(rate_flags & WLAN_RC_CAP_STREAM(capflag))
++			    || WLAN_RC_PHY_HT(phy))
++				continue;
++
++			if (!ath_rc_valid_phyrate(phy, capflag, 0))
++				continue;
++
++			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
++			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
++			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
++			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
++			hi = max(hi, j);
+ 		}
+ 	}
+ 
diff --git a/linux-next-cherry-picks/0007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch b/linux-next-cherry-picks/0007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
new file mode 100644
index 0000000..72d0a01
--- /dev/null
+++ b/linux-next-cherry-picks/0007-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
@@ -0,0 +1,47 @@
+From dacde3570865202fedcfa7c642d6c2ffde0dd0af Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:18 +0530
+Subject: [PATCH] ath9k: Cleanup ath_rc_setvalid_htrates
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 17 +++++++++--------
+ 1 file changed, 9 insertions(+), 8 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -552,15 +552,16 @@ static u8 ath_rc_setvalid_htrates(struct
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
+-	u32 capflag = ath_rc_priv->ht_cap;
+-	u8 i, j, hi = 0;
++	u32 phy, capflag = ath_rc_priv->ht_cap;
++	u16 rate_flags;
++	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+ 
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+-			u32 phy = rate_table->info[j].phy;
+-			u16 rate_flags = rate_table->info[j].rate_flags;
+-			u8 rate = rateset->rs_rates[i];
+-			u8 dot11rate = rate_table->info[j].dot11rate;
++			phy = rate_table->info[j].phy;
++			rate_flags = rate_table->info[j].rate_flags;
++			rate = rateset->rs_rates[i];
++			dot11rate = rate_table->info[j].dot11rate;
+ 
+ 			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
+ 			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
+@@ -570,8 +571,8 @@ static u8 ath_rc_setvalid_htrates(struct
+ 			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+ 				continue;
+ 
+-			ath_rc_priv->valid_phy_rateidx[phy]
+-				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
++			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
++			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+ 			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+ 			hi = max(hi, j);
diff --git a/linux-next-cherry-picks/0008-ath9k-Cleanup-index-retrieval-routines.patch b/linux-next-cherry-picks/0008-ath9k-Cleanup-index-retrieval-routines.patch
new file mode 100644
index 0000000..c3d49d0
--- /dev/null
+++ b/linux-next-cherry-picks/0008-ath9k-Cleanup-index-retrieval-routines.patch
@@ -0,0 +1,137 @@
+From fc8d023834f6462e1675a28a15da251b3cb28b9a Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:24 +0530
+Subject: [PATCH] ath9k: Cleanup index retrieval routines
+
+Trim API and remove unused variables.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 56 ++++++++++++++++++-------------------
+ 1 file changed, 27 insertions(+), 29 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -471,8 +471,7 @@ static int ath_rc_valid_phyrate(u32 phy,
+ }
+ 
+ static inline int
+-ath_rc_get_lower_rix(const struct ath_rate_table *rate_table,
+-		     struct ath_rate_priv *ath_rc_priv,
++ath_rc_get_lower_rix(struct ath_rate_priv *ath_rc_priv,
+ 		     u8 cur_valid_txrate, u8 *next_idx)
+ {
+ 	int8_t i;
+@@ -582,13 +581,11 @@ static u8 ath_rc_setvalid_htrates(struct
+ 	return hi;
+ }
+ 
+-/* Finds the highest rate index we can use */
+-static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
+-			         struct ath_rate_priv *ath_rc_priv,
+-				 const struct ath_rate_table *rate_table,
++static u8 ath_rc_get_highest_rix(struct ath_rate_priv *ath_rc_priv,
+ 				 int *is_probing,
+ 				 bool legacy)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u32 best_thruput, this_thruput, now_msec;
+ 	u8 rate, next_rate, best_rate, maxindex, minindex;
+ 	int8_t index = 0;
+@@ -773,14 +770,8 @@ static void ath_get_rate(void *priv, str
+ 	try_per_rate = 4;
+ 
+ 	rate_table = ath_rc_priv->rate_table;
+-	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
+-				     &is_probe, false);
++	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, false);
+ 
+-	/*
+-	 * If we're in HT mode and both us and our peer supports LDPC.
+-	 * We don't need to check our own device's capabilities as our own
+-	 * ht capabilities would have already been intersected with our peer's.
+-	 */
+ 	if (conf_is_ht(&sc->hw->conf) &&
+ 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
+ 		tx_info->flags |= IEEE80211_TX_CTL_LDPC;
+@@ -790,35 +781,42 @@ static void ath_get_rate(void *priv, str
+ 		tx_info->flags |= (1 << IEEE80211_TX_CTL_STBC_SHIFT);
+ 
+ 	if (is_probe) {
+-		/* set one try for probe rates. For the
+-		 * probes don't enable rts */
++		/*
++		 * Set one try for probe rates. For the
++		 * probes don't enable RTS.
++		 */
+ 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
+ 				       1, rix, 0);
+-
+-		/* Get the next tried/allowed rate. No RTS for the next series
+-		 * after the probe rate
++		/*
++		 * Get the next tried/allowed rate.
++		 * No RTS for the next series after the probe rate.
+ 		 */
+-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
++		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+ 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
+ 				       try_per_rate, rix, 0);
+ 
+ 		tx_info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+ 	} else {
+-		/* Set the chosen rate. No RTS for first series entry. */
++		/*
++		 * Set the chosen rate. No RTS for first series entry.
++		 */
+ 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
+ 				       try_per_rate, rix, 0);
+ 	}
+ 
+-	/* Fill in the other rates for multirate retry */
+ 	for ( ; i < 3; i++) {
++		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+ 
+-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
+-		/* All other rates in the series have RTS enabled */
++		/*
++		 * All other rates in the series have RTS enabled.
++		 */
+ 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
+ 				       try_per_rate, rix, 1);
+ 	}
+ 
+-	/* Use twice the number of tries for the last MRR segment. */
++	/*
++	 * Use twice the number of tries for the last MRR segment.
++	 */
+ 	try_per_rate = 8;
+ 
+ 	/*
+@@ -827,11 +825,11 @@ static void ath_get_rate(void *priv, str
+ 	 * as last retry to ensure that the frame is tried in both
+ 	 * MCS and legacy rate.
+ 	 */
+-	ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
++	ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
++
+ 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy) &&
+ 	    (ath_rc_priv->per[rix] > 45))
+-		rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
+-				&is_probe, true);
++		rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, true);
+ 
+ 	/* All other rates in the series have RTS enabled */
+ 	ath_rc_rate_set_series(rate_table, &rates[i], txrc,
+@@ -1061,8 +1059,8 @@ static void ath_rc_update_ht(struct ath_
+ 	if (ath_rc_priv->per[tx_rate] >= 55 && tx_rate > 0 &&
+ 	    rate_table->info[tx_rate].ratekbps <=
+ 	    rate_table->info[ath_rc_priv->rate_max_phy].ratekbps) {
+-		ath_rc_get_lower_rix(rate_table, ath_rc_priv,
+-				     (u8)tx_rate, &ath_rc_priv->rate_max_phy);
++		ath_rc_get_lower_rix(ath_rc_priv, (u8)tx_rate,
++				     &ath_rc_priv->rate_max_phy);
+ 
+ 		/* Don't probe for a little while. */
+ 		ath_rc_priv->probe_time = now_msec;
diff --git a/linux-next-cherry-picks/0009-ath9k-Change-rateset-calculation.patch b/linux-next-cherry-picks/0009-ath9k-Change-rateset-calculation.patch
new file mode 100644
index 0000000..36beed4
--- /dev/null
+++ b/linux-next-cherry-picks/0009-ath9k-Change-rateset-calculation.patch
@@ -0,0 +1,87 @@
+From 6e1e3743227119e66162f701d73314d0a26dfafe Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:31 +0530
+Subject: [PATCH] ath9k: Change rateset calculation
+
+Commit "ath9k: Change rate control to use legacy rate as last MRR"
+resulted in the mixing of HT/legacy rates in a single rateset,
+which is undesirable. Revert this behavior.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 35 +++++++++--------------------------
+ 1 file changed, 9 insertions(+), 26 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -582,8 +582,7 @@ static u8 ath_rc_setvalid_htrates(struct
+ }
+ 
+ static u8 ath_rc_get_highest_rix(struct ath_rate_priv *ath_rc_priv,
+-				 int *is_probing,
+-				 bool legacy)
++				 int *is_probing)
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u32 best_thruput, this_thruput, now_msec;
+@@ -605,8 +604,6 @@ static u8 ath_rc_get_highest_rix(struct
+ 		u8 per_thres;
+ 
+ 		rate = ath_rc_priv->valid_rate_index[index];
+-		if (legacy && !(rate_table->info[rate].rate_flags & RC_LEGACY))
+-			continue;
+ 		if (rate > ath_rc_priv->rate_max_phy)
+ 			continue;
+ 
+@@ -770,7 +767,7 @@ static void ath_get_rate(void *priv, str
+ 	try_per_rate = 4;
+ 
+ 	rate_table = ath_rc_priv->rate_table;
+-	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, false);
++	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe);
+ 
+ 	if (conf_is_ht(&sc->hw->conf) &&
+ 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
+@@ -804,7 +801,13 @@ static void ath_get_rate(void *priv, str
+ 				       try_per_rate, rix, 0);
+ 	}
+ 
+-	for ( ; i < 3; i++) {
++	for ( ; i < 4; i++) {
++		/*
++		 * Use twice the number of tries for the last MRR segment.
++		 */
++		if (i + 1 == 4)
++			try_per_rate = 8;
++
+ 		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+ 
+ 		/*
+@@ -815,26 +818,6 @@ static void ath_get_rate(void *priv, str
+ 	}
+ 
+ 	/*
+-	 * Use twice the number of tries for the last MRR segment.
+-	 */
+-	try_per_rate = 8;
+-
+-	/*
+-	 * If the last rate in the rate series is MCS and has
+-	 * more than 80% of per thresh, then use a legacy rate
+-	 * as last retry to ensure that the frame is tried in both
+-	 * MCS and legacy rate.
+-	 */
+-	ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+-
+-	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy) &&
+-	    (ath_rc_priv->per[rix] > 45))
+-		rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, true);
+-
+-	/* All other rates in the series have RTS enabled */
+-	ath_rc_rate_set_series(rate_table, &rates[i], txrc,
+-			       try_per_rate, rix, 1);
+-	/*
+ 	 * NB:Change rate series to enable aggregation when operating
+ 	 * at lower MCS rates. When first rate in series is MCS2
+ 	 * in HT40 @ 2.4GHz, series should look like:
diff --git a/linux-next-cherry-picks/0010-ath9k-Remove-ath_rc_set_valid_rate_idx.patch b/linux-next-cherry-picks/0010-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
new file mode 100644
index 0000000..d230a06
--- /dev/null
+++ b/linux-next-cherry-picks/0010-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
@@ -0,0 +1,54 @@
+From f5c9a804935029a70f14c0336ac054af9b1953a5 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:37 +0530
+Subject: [PATCH] ath9k: Remove ath_rc_set_valid_rate_idx
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 13 +++----------
+ 1 file changed, 3 insertions(+), 10 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -424,13 +424,6 @@ static void ath_rc_sort_validrates(struc
+ 	}
+ }
+ 
+-static inline void ath_rc_set_valid_rate_idx(struct ath_rate_priv *ath_rc_priv,
+-					   u8 index, int valid_tx_rate)
+-{
+-	BUG_ON(index > ath_rc_priv->rate_table_size);
+-	ath_rc_priv->valid_rate_index[index] = !!valid_tx_rate;
+-}
+-
+ static inline
+ int ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
+ 				struct ath_rate_priv *ath_rc_priv,
+@@ -503,7 +496,7 @@ static u8 ath_rc_init_validrates(struct
+ 
+ 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = i;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_set_valid_rate_idx(ath_rc_priv, i, 1);
++			ath_rc_priv->valid_rate_index[i] = true;
+ 			hi = i;
+ 		}
+ 	}
+@@ -539,7 +532,7 @@ static u8 ath_rc_setvalid_rates(struct a
+ 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+ 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
++			ath_rc_priv->valid_rate_index[j] = true;
+ 			hi = max(hi, j);
+ 		}
+ 	}
+@@ -573,7 +566,7 @@ static u8 ath_rc_setvalid_htrates(struct
+ 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+ 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
++			ath_rc_priv->valid_rate_index[j] = true;
+ 			hi = max(hi, j);
+ 		}
+ 	}
diff --git a/linux-next-cherry-picks/0011-ath9k-Unify-valid-rate-calculation-routines.patch b/linux-next-cherry-picks/0011-ath9k-Unify-valid-rate-calculation-routines.patch
new file mode 100644
index 0000000..a6b14da
--- /dev/null
+++ b/linux-next-cherry-picks/0011-ath9k-Unify-valid-rate-calculation-routines.patch
@@ -0,0 +1,124 @@
+From 3d2776f62140369619b0e6c13ea19b814eed03b4 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:44 +0530
+Subject: [PATCH] ath9k: Unify valid rate calculation routines
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 74 +++++++++++++++++++------------------
+ 1 file changed, 39 insertions(+), 35 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -504,50 +504,49 @@ static u8 ath_rc_init_validrates(struct
+ 	return hi;
+ }
+ 
+-static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
++static inline bool ath_rc_check_legacy(u8 rate, u8 dot11rate, u16 rate_flags,
++				       u32 phy, u32 capflag)
+ {
+-	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+-	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+-	u32 phy, capflag = ath_rc_priv->ht_cap;
+-	u16 rate_flags;
+-	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
++	if (rate != dot11rate || WLAN_RC_PHY_HT(phy))
++		return false;
+ 
+-	for (i = 0; i < rateset->rs_nrates; i++) {
+-		for (j = 0; j < rate_table->rate_cnt; j++) {
+-			phy = rate_table->info[j].phy;
+-			rate_flags = rate_table->info[j].rate_flags;
+-			rate = rateset->rs_rates[i];
+-			dot11rate = rate_table->info[j].dot11rate;
++	if ((rate_flags & WLAN_RC_CAP_MODE(capflag)) != WLAN_RC_CAP_MODE(capflag))
++		return false;
+ 
+-			if (rate != dot11rate
+-			    || ((rate_flags & WLAN_RC_CAP_MODE(capflag)) !=
+-				WLAN_RC_CAP_MODE(capflag))
+-			    || !(rate_flags & WLAN_RC_CAP_STREAM(capflag))
+-			    || WLAN_RC_PHY_HT(phy))
+-				continue;
++	if (!(rate_flags & WLAN_RC_CAP_STREAM(capflag)))
++		return false;
+ 
+-			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+-				continue;
++	return true;
++}
+ 
+-			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+-			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+-			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_priv->valid_rate_index[j] = true;
+-			hi = max(hi, j);
+-		}
+-	}
++static inline bool ath_rc_check_ht(u8 rate, u8 dot11rate, u16 rate_flags,
++				   u32 phy, u32 capflag)
++{
++	if (rate != dot11rate || !WLAN_RC_PHY_HT(phy))
++		return false;
+ 
+-	return hi;
++	if (!WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
++		return false;
++
++	if (!(rate_flags & WLAN_RC_CAP_STREAM(capflag)))
++		return false;
++
++	return true;
+ }
+ 
+-static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
++static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv, bool legacy)
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+-	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
++	struct ath_rateset *rateset;
+ 	u32 phy, capflag = ath_rc_priv->ht_cap;
+ 	u16 rate_flags;
+ 	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+ 
++	if (legacy)
++		rateset = &ath_rc_priv->neg_rates;
++	else
++		rateset = &ath_rc_priv->neg_ht_rates;
++
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+ 			phy = rate_table->info[j].phy;
+@@ -555,9 +554,14 @@ static u8 ath_rc_setvalid_htrates(struct
+ 			rate = rateset->rs_rates[i];
+ 			dot11rate = rate_table->info[j].dot11rate;
+ 
+-			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
+-			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
+-			    !WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
++			if (legacy &&
++			    !ath_rc_check_legacy(rate, dot11rate,
++						 rate_flags, phy, capflag))
++				continue;
++
++			if (!legacy &&
++			    !ath_rc_check_ht(rate, dot11rate,
++					     rate_flags, phy, capflag))
+ 				continue;
+ 
+ 			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+@@ -1181,10 +1185,10 @@ static void ath_rc_init(struct ath_softc
+ 	if (!rateset->rs_nrates) {
+ 		hi = ath_rc_init_validrates(ath_rc_priv);
+ 	} else {
+-		hi = ath_rc_setvalid_rates(ath_rc_priv);
++		hi = ath_rc_setvalid_rates(ath_rc_priv, true);
+ 
+ 		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG)
+-			hthi = ath_rc_setvalid_htrates(ath_rc_priv);
++			hthi = ath_rc_setvalid_rates(ath_rc_priv, false);
+ 
+ 		hi = max(hi, hthi);
+ 	}
diff --git a/linux-next-cherry-picks/0012-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch b/linux-next-cherry-picks/0012-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
new file mode 100644
index 0000000..ff23e0a
--- /dev/null
+++ b/linux-next-cherry-picks/0012-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
@@ -0,0 +1,24 @@
+From 97f7e8a785b9877098d7f255654b25bf85ae9d6a Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:50 +0530
+Subject: [PATCH] ath9k: Do not set IEEE80211_TX_RC_USE_SHORT_PREAMBLE
+
+mac80211 does it for us.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 2 --
+ 1 file changed, 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -682,8 +682,6 @@ static void ath_rc_rate_set_series(const
+ 	rate->count = tries;
+ 	rate->idx = rate_table->info[rix].ratecode;
+ 
+-	if (txrc->short_preamble)
+-		rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+ 	if (txrc->rts || rtsctsenable)
+ 		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+ 
diff --git a/linux-next-cherry-picks/0013-ath9k-Fix-RTS-CTS-rate-selection.patch b/linux-next-cherry-picks/0013-ath9k-Fix-RTS-CTS-rate-selection.patch
new file mode 100644
index 0000000..fd8ef84
--- /dev/null
+++ b/linux-next-cherry-picks/0013-ath9k-Fix-RTS-CTS-rate-selection.patch
@@ -0,0 +1,78 @@
+From 2e546755b947c08cdc1c4f2bdba70130c6ed0736 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:57 +0530
+Subject: [PATCH] ath9k: Fix RTS/CTS rate selection
+
+The current method of assigning the RTS/CTS rate is completely
+broken for HT mode and breaks P2P operation. Fix this by using
+the basic_rates provided to the driver by mac80211. For now,
+choose the lowest supported basic rate for HT frames.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 41 +++++++++++++------------------------
+ 1 file changed, 14 insertions(+), 27 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -699,37 +699,25 @@ static void ath_rc_rate_set_rtscts(struc
+ 				   const struct ath_rate_table *rate_table,
+ 				   struct ieee80211_tx_info *tx_info)
+ {
+-	struct ieee80211_tx_rate *rates = tx_info->control.rates;
+-	int i = 0, rix = 0, cix, enable_g_protection = 0;
++	struct ieee80211_bss_conf *bss_conf;
+ 
+-	/* get the cix for the lowest valid rix */
+-	for (i = 3; i >= 0; i--) {
+-		if (rates[i].count && (rates[i].idx >= 0)) {
+-			rix = ath_rc_get_rateindex(rate_table, &rates[i]);
+-			break;
+-		}
+-	}
+-	cix = rate_table->info[rix].ctrl_rate;
++	if (!tx_info->control.vif)
++		return;
++	/*
++	 * For legacy frames, mac80211 takes care of CTS protection.
++	 */
++	if (!(tx_info->control.rates[0].flags & IEEE80211_TX_RC_MCS))
++		return;
++
++	bss_conf = &tx_info->control.vif->bss_conf;
+ 
+-	/* All protection frames are transmited at 2Mb/s for 802.11g,
+-	 * otherwise we transmit them at 1Mb/s */
+-	if (sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
+-	    !conf_is_ht(&sc->hw->conf))
+-		enable_g_protection = 1;
++	if (!bss_conf->basic_rates)
++		return;
+ 
+ 	/*
+-	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
+-	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
++	 * For now, use the lowest allowed basic rate for HT frames.
+ 	 */
+-	if ((tx_info->control.vif &&
+-	     tx_info->control.vif->bss_conf.use_cts_prot) &&
+-	    (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
+-	     WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
+-		rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
+-		cix = rate_table->info[enable_g_protection].ctrl_rate;
+-	}
+-
+-	tx_info->control.rts_cts_rate_idx = cix;
++	tx_info->control.rts_cts_rate_idx = __ffs(bss_conf->basic_rates);
+ }
+ 
+ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
+@@ -853,7 +841,6 @@ static void ath_get_rate(void *priv, str
+ 		rates[0].count = ATH_TXMAXTRY;
+ 	}
+ 
+-	/* Setup RTS/CTS */
+ 	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
+ }
+ 
diff --git a/linux-next-cherry-picks/0014-ath9k-Bail-out-properly-before-calculating-rate-inde.patch b/linux-next-cherry-picks/0014-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
new file mode 100644
index 0000000..1621ff4
--- /dev/null
+++ b/linux-next-cherry-picks/0014-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
@@ -0,0 +1,55 @@
+From c1610117f81ae70b49aaf51ccb9040f2ce5bd358 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:03 +0530
+Subject: [PATCH] ath9k: Bail out properly before calculating rate index
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 24 +++++++++++-------------
+ 1 file changed, 11 insertions(+), 13 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1264,23 +1264,12 @@ static void ath_tx_status(void *priv, st
+ 	struct ath_softc *sc = priv;
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+-	struct ieee80211_hdr *hdr;
++	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+ 	int final_ts_idx = 0, tx_status = 0;
+ 	int long_retry = 0;
+-	__le16 fc;
++	__le16 fc = hdr->frame_control;
+ 	int i;
+ 
+-	hdr = (struct ieee80211_hdr *)skb->data;
+-	fc = hdr->frame_control;
+-	for (i = 0; i < sc->hw->max_rates; i++) {
+-		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
+-		if (rate->idx < 0 || !rate->count)
+-			break;
+-
+-		final_ts_idx = i;
+-		long_retry = rate->count - 1;
+-	}
+-
+ 	if (!priv_sta || !ieee80211_is_data(fc))
+ 		return;
+ 
+@@ -1292,6 +1281,15 @@ static void ath_tx_status(void *priv, st
+ 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
+ 		return;
+ 
++	for (i = 0; i < sc->hw->max_rates; i++) {
++		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
++		if (rate->idx < 0 || !rate->count)
++			break;
++
++		final_ts_idx = i;
++		long_retry = rate->count - 1;
++	}
++
+ 	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
+ 		tx_status = 1;
+ 
diff --git a/linux-next-cherry-picks/0015-ath9k-Cleanup-TX-status-API.patch b/linux-next-cherry-picks/0015-ath9k-Cleanup-TX-status-API.patch
new file mode 100644
index 0000000..bc5e1ed
--- /dev/null
+++ b/linux-next-cherry-picks/0015-ath9k-Cleanup-TX-status-API.patch
@@ -0,0 +1,164 @@
+From 88dcc2dd717b292d1ef7311a6487c610f709bd10 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:09 +0530
+Subject: [PATCH] ath9k: Cleanup TX status API
+
+Calculate the final rate index inside ath_rc_tx_status().
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 71 +++++++++++++++----------------------
+ 1 file changed, 29 insertions(+), 42 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -993,9 +993,6 @@ static void ath_debug_stat_retries(struc
+ 	stats->per = per;
+ }
+ 
+-/* Update PER, RSSI and whatever else that the code thinks it is doing.
+-   If you can make sense of all this, you really need to go out more. */
+-
+ static void ath_rc_update_ht(struct ath_softc *sc,
+ 			     struct ath_rate_priv *ath_rc_priv,
+ 			     struct ieee80211_tx_info *tx_info,
+@@ -1069,25 +1066,43 @@ static void ath_rc_update_ht(struct ath_
+ 
+ }
+ 
++static void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
++{
++	struct ath_rc_stats *stats;
++
++	stats = &rc->rcstats[final_rate];
++	stats->success++;
++}
+ 
+ static void ath_rc_tx_status(struct ath_softc *sc,
+ 			     struct ath_rate_priv *ath_rc_priv,
+-			     struct ieee80211_tx_info *tx_info,
+-			     int final_ts_idx, int xretries, int long_retry)
++			     struct sk_buff *skb)
+ {
+-	const struct ath_rate_table *rate_table;
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+ 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
++	struct ieee80211_tx_rate *rate;
++	int final_ts_idx = 0, xretries = 0, long_retry = 0;
+ 	u8 flags;
+ 	u32 i = 0, rix;
+ 
+-	rate_table = ath_rc_priv->rate_table;
++	for (i = 0; i < sc->hw->max_rates; i++) {
++		rate = &tx_info->status.rates[i];
++		if (rate->idx < 0 || !rate->count)
++			break;
++
++		final_ts_idx = i;
++		long_retry = rate->count - 1;
++	}
++
++	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
++		xretries = 1;
+ 
+ 	/*
+ 	 * If the first rate is not the final index, there
+ 	 * are intermediate rate failures to be processed.
+ 	 */
+ 	if (final_ts_idx != 0) {
+-		/* Process intermediate rates that failed.*/
+ 		for (i = 0; i < final_ts_idx ; i++) {
+ 			if (rates[i].count != 0 && (rates[i].idx >= 0)) {
+ 				flags = rates[i].flags;
+@@ -1101,8 +1116,8 @@ static void ath_rc_tx_status(struct ath_
+ 
+ 				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
+ 				ath_rc_update_ht(sc, ath_rc_priv, tx_info,
+-						rix, xretries ? 1 : 2,
+-						rates[i].count);
++						 rix, xretries ? 1 : 2,
++						 rates[i].count);
+ 			}
+ 		}
+ 	} else {
+@@ -1116,15 +1131,16 @@ static void ath_rc_tx_status(struct ath_
+ 			xretries = 2;
+ 	}
+ 
+-	flags = rates[i].flags;
++	flags = rates[final_ts_idx].flags;
+ 
+ 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
+ 	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+ 	    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
+ 		return;
+ 
+-	rix = ath_rc_get_rateindex(rate_table, &rates[i]);
++	rix = ath_rc_get_rateindex(rate_table, &rates[final_ts_idx]);
+ 	ath_rc_update_ht(sc, ath_rc_priv, tx_info, rix, xretries, long_retry);
++	ath_debug_stat_rc(ath_rc_priv, rix);
+ }
+ 
+ static const
+@@ -1248,15 +1264,6 @@ static bool ath_tx_aggr_check(struct ath
+ /* mac80211 Rate Control callbacks */
+ /***********************************/
+ 
+-static void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
+-{
+-	struct ath_rc_stats *stats;
+-
+-	stats = &rc->rcstats[final_rate];
+-	stats->success++;
+-}
+-
+-
+ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
+ 			  struct ieee80211_sta *sta, void *priv_sta,
+ 			  struct sk_buff *skb)
+@@ -1265,10 +1272,7 @@ static void ath_tx_status(void *priv, st
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+ 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+-	int final_ts_idx = 0, tx_status = 0;
+-	int long_retry = 0;
+ 	__le16 fc = hdr->frame_control;
+-	int i;
+ 
+ 	if (!priv_sta || !ieee80211_is_data(fc))
+ 		return;
+@@ -1281,20 +1285,7 @@ static void ath_tx_status(void *priv, st
+ 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
+ 		return;
+ 
+-	for (i = 0; i < sc->hw->max_rates; i++) {
+-		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
+-		if (rate->idx < 0 || !rate->count)
+-			break;
+-
+-		final_ts_idx = i;
+-		long_retry = rate->count - 1;
+-	}
+-
+-	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
+-		tx_status = 1;
+-
+-	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
+-			 long_retry);
++	ath_rc_tx_status(sc, ath_rc_priv, skb);
+ 
+ 	/* Check if aggregation has to be enabled for this tid */
+ 	if (conf_is_ht(&sc->hw->conf) &&
+@@ -1310,10 +1301,6 @@ static void ath_tx_status(void *priv, st
+ 				ieee80211_start_tx_ba_session(sta, tid, 0);
+ 		}
+ 	}
+-
+-	ath_debug_stat_rc(ath_rc_priv,
+-		ath_rc_get_rateindex(ath_rc_priv->rate_table,
+-			&tx_info->status.rates[final_ts_idx]));
+ }
+ 
+ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
diff --git a/linux-next-cherry-picks/0016-ath9k-Remove-MIMO-PS-specific-code.patch b/linux-next-cherry-picks/0016-ath9k-Remove-MIMO-PS-specific-code.patch
new file mode 100644
index 0000000..93b7d07
--- /dev/null
+++ b/linux-next-cherry-picks/0016-ath9k-Remove-MIMO-PS-specific-code.patch
@@ -0,0 +1,29 @@
+From f8a87017f4a9f1638df54dd79d0f5ad1bae51c1d Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:16 +0530
+Subject: [PATCH] ath9k: Remove MIMO-PS specific code
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 9 ---------
+ 1 file changed, 9 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1120,15 +1120,6 @@ static void ath_rc_tx_status(struct ath_
+ 						 rates[i].count);
+ 			}
+ 		}
+-	} else {
+-		/*
+-		 * Handle the special case of MIMO PS burst, where the second
+-		 * aggregate is sent out with only one rate and one try.
+-		 * Treating it as an excessive retry penalizes the rate
+-		 * inordinately.
+-		 */
+-		if (rates[0].count == 1 && xretries == 1)
+-			xretries = 2;
+ 	}
+ 
+ 	flags = rates[final_ts_idx].flags;
diff --git a/linux-next-cherry-picks/0017-ath9k-Trim-rate-table.patch b/linux-next-cherry-picks/0017-ath9k-Trim-rate-table.patch
new file mode 100644
index 0000000..3086605
--- /dev/null
+++ b/linux-next-cherry-picks/0017-ath9k-Trim-rate-table.patch
@@ -0,0 +1,600 @@
+From 23d9939459362c555d2ad18f9c036f55594e7fee Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:23 +0530
+Subject: [PATCH] ath9k: Trim rate table
+
+Remove ctrl_rate, cw40index, sgi_index, ht_index and calculate
+the rate index for TX status from the valid_rate_index that
+is populated at initialization time.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 350 ++++++++++++++++++------------------
+ drivers/net/wireless/ath/ath9k/rc.h |   4 -
+ 2 files changed, 174 insertions(+), 180 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -25,141 +25,141 @@ static const struct ath_rate_table ar541
+ 	8, /* MCS start */
+ 	{
+ 		[0] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 6000,
+-			5400, 0, 12, 0, 0, 0, 0 }, /* 6 Mb */
++			5400, 0, 12 }, /* 6 Mb */
+ 		[1] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 9000,
+-			7800,  1, 18, 0, 1, 1, 1 }, /* 9 Mb */
++			7800,  1, 18 }, /* 9 Mb */
+ 		[2] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+-			10000, 2, 24, 2, 2, 2, 2 }, /* 12 Mb */
++			10000, 2, 24 }, /* 12 Mb */
+ 		[3] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+-			13900, 3, 36, 2, 3, 3, 3 }, /* 18 Mb */
++			13900, 3, 36 }, /* 18 Mb */
+ 		[4] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+-			17300, 4, 48, 4, 4, 4, 4 }, /* 24 Mb */
++			17300, 4, 48 }, /* 24 Mb */
+ 		[5] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+-			23000, 5, 72, 4, 5, 5, 5 }, /* 36 Mb */
++			23000, 5, 72 }, /* 36 Mb */
+ 		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+-			27400, 6, 96, 4, 6, 6, 6 }, /* 48 Mb */
++			27400, 6, 96 }, /* 48 Mb */
+ 		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+-			29300, 7, 108, 4, 7, 7, 7 }, /* 54 Mb */
++			29300, 7, 108 }, /* 54 Mb */
+ 		[8] = { RC_HT_SDT_2040, WLAN_RC_PHY_HT_20_SS, 6500,
+-			6400, 0, 0, 0, 38, 8, 38 }, /* 6.5 Mb */
++			6400, 0, 0 }, /* 6.5 Mb */
+ 		[9] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+-			12700, 1, 1, 2, 39, 9, 39 }, /* 13 Mb */
++			12700, 1, 1 }, /* 13 Mb */
+ 		[10] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+-			18800, 2, 2, 2, 40, 10, 40 }, /* 19.5 Mb */
++			18800, 2, 2 }, /* 19.5 Mb */
+ 		[11] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+-			25000, 3, 3, 4, 41, 11, 41 }, /* 26 Mb */
++			25000, 3, 3 }, /* 26 Mb */
+ 		[12] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+-			36700, 4, 4, 4, 42, 12, 42 }, /* 39 Mb */
++			36700, 4, 4 }, /* 39 Mb */
+ 		[13] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+-			48100, 5, 5, 4, 43, 13, 43 }, /* 52 Mb */
++			48100, 5, 5 }, /* 52 Mb */
+ 		[14] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+-			53500, 6, 6, 4, 44, 14, 44 }, /* 58.5 Mb */
++			53500, 6, 6 }, /* 58.5 Mb */
+ 		[15] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+-			59000, 7, 7, 4, 45, 16, 46 }, /* 65 Mb */
++			59000, 7, 7 }, /* 65 Mb */
+ 		[16] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+-			65400, 7, 7, 4, 45, 16, 46 }, /* 75 Mb */
++			65400, 7, 7 }, /* 75 Mb */
+ 		[17] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+-			12700, 8, 8, 0, 47, 17, 47 }, /* 13 Mb */
++			12700, 8, 8 }, /* 13 Mb */
+ 		[18] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+-			24800, 9, 9, 2, 48, 18, 48 }, /* 26 Mb */
++			24800, 9, 9 }, /* 26 Mb */
+ 		[19] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+-			36600, 10, 10, 2, 49, 19, 49 }, /* 39 Mb */
++			36600, 10, 10 }, /* 39 Mb */
+ 		[20] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+-			48100, 11, 11, 4, 50, 20, 50 }, /* 52 Mb */
++			48100, 11, 11 }, /* 52 Mb */
+ 		[21] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+-			69500, 12, 12, 4, 51, 21, 51 }, /* 78 Mb */
++			69500, 12, 12 }, /* 78 Mb */
+ 		[22] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+-			89500, 13, 13, 4, 52, 22, 52 }, /* 104 Mb */
++			89500, 13, 13 }, /* 104 Mb */
+ 		[23] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+-			98900, 14, 14, 4, 53, 23, 53 }, /* 117 Mb */
++			98900, 14, 14 }, /* 117 Mb */
+ 		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+-			108300, 15, 15, 4, 54, 25, 55 }, /* 130 Mb */
++			108300, 15, 15 }, /* 130 Mb */
+ 		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+-			120000, 15, 15, 4, 54, 25, 55 }, /* 144.4 Mb */
++			120000, 15, 15 }, /* 144.4 Mb */
+ 		[26] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+-			17400, 16, 16, 0, 56, 26, 56 }, /* 19.5 Mb */
++			17400, 16, 16 }, /* 19.5 Mb */
+ 		[27] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+-			35100, 17, 17, 2, 57, 27, 57 }, /* 39 Mb */
++			35100, 17, 17 }, /* 39 Mb */
+ 		[28] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+-			52600, 18, 18, 2, 58, 28, 58 }, /* 58.5 Mb */
++			52600, 18, 18 }, /* 58.5 Mb */
+ 		[29] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+-			70400, 19, 19, 4, 59, 29, 59 }, /* 78 Mb */
++			70400, 19, 19 }, /* 78 Mb */
+ 		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+-			104900, 20, 20, 4, 60, 31, 61 }, /* 117 Mb */
++			104900, 20, 20 }, /* 117 Mb */
+ 		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+-			115800, 20, 20, 4, 60, 31, 61 }, /* 130 Mb*/
++			115800, 20, 20 }, /* 130 Mb*/
+ 		[32] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+-			137200, 21, 21, 4, 62, 33, 63 }, /* 156 Mb */
++			137200, 21, 21 }, /* 156 Mb */
+ 		[33] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+-			151100, 21, 21, 4, 62, 33, 63 }, /* 173.3 Mb */
++			151100, 21, 21 }, /* 173.3 Mb */
+ 		[34] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+-			152800, 22, 22, 4, 64, 35, 65 }, /* 175.5 Mb */
++			152800, 22, 22 }, /* 175.5 Mb */
+ 		[35] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+-			168400, 22, 22, 4, 64, 35, 65 }, /* 195 Mb*/
++			168400, 22, 22 }, /* 195 Mb*/
+ 		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+-			168400, 23, 23, 4, 66, 37, 67 }, /* 195 Mb */
++			168400, 23, 23 }, /* 195 Mb */
+ 		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+-			185000, 23, 23, 4, 66, 37, 67 }, /* 216.7 Mb */
++			185000, 23, 23 }, /* 216.7 Mb */
+ 		[38] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+-			13200, 0, 0, 0, 38, 38, 38 }, /* 13.5 Mb*/
++			13200, 0, 0 }, /* 13.5 Mb*/
+ 		[39] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+-			25900, 1, 1, 2, 39, 39, 39 }, /* 27.0 Mb*/
++			25900, 1, 1 }, /* 27.0 Mb*/
+ 		[40] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+-			38600, 2, 2, 2, 40, 40, 40 }, /* 40.5 Mb*/
++			38600, 2, 2 }, /* 40.5 Mb*/
+ 		[41] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+-			49800, 3, 3, 4, 41, 41, 41 }, /* 54 Mb */
++			49800, 3, 3 }, /* 54 Mb */
+ 		[42] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+-			72200, 4, 4, 4, 42, 42, 42 }, /* 81 Mb */
++			72200, 4, 4 }, /* 81 Mb */
+ 		[43] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 108000,
+-			92900, 5, 5, 4, 43, 43, 43 }, /* 108 Mb */
++			92900, 5, 5 }, /* 108 Mb */
+ 		[44] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+-			102700, 6, 6, 4, 44, 44, 44 }, /* 121.5 Mb*/
++			102700, 6, 6 }, /* 121.5 Mb*/
+ 		[45] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+-			112000, 7, 7, 4, 45, 46, 46 }, /* 135 Mb */
++			112000, 7, 7 }, /* 135 Mb */
+ 		[46] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+-			122000, 7, 7, 4, 45, 46, 46 }, /* 150 Mb */
++			122000, 7, 7 }, /* 150 Mb */
+ 		[47] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+-			25800, 8, 8, 0, 47, 47, 47 }, /* 27 Mb */
++			25800, 8, 8 }, /* 27 Mb */
+ 		[48] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+-			49800, 9, 9, 2, 48, 48, 48 }, /* 54 Mb */
++			49800, 9, 9 }, /* 54 Mb */
+ 		[49] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+-			71900, 10, 10, 2, 49, 49, 49 }, /* 81 Mb */
++			71900, 10, 10 }, /* 81 Mb */
+ 		[50] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+-			92500, 11, 11, 4, 50, 50, 50 }, /* 108 Mb */
++			92500, 11, 11 }, /* 108 Mb */
+ 		[51] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+-			130300, 12, 12, 4, 51, 51, 51 }, /* 162 Mb */
++			130300, 12, 12 }, /* 162 Mb */
+ 		[52] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+-			162800, 13, 13, 4, 52, 52, 52 }, /* 216 Mb */
++			162800, 13, 13 }, /* 216 Mb */
+ 		[53] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+-			178200, 14, 14, 4, 53, 53, 53 }, /* 243 Mb */
++			178200, 14, 14 }, /* 243 Mb */
+ 		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+-			192100, 15, 15, 4, 54, 55, 55 }, /* 270 Mb */
++			192100, 15, 15 }, /* 270 Mb */
+ 		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+-			207000, 15, 15, 4, 54, 55, 55 }, /* 300 Mb */
++			207000, 15, 15 }, /* 300 Mb */
+ 		[56] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+-			36100, 16, 16, 0, 56, 56, 56 }, /* 40.5 Mb */
++			36100, 16, 16 }, /* 40.5 Mb */
+ 		[57] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+-			72900, 17, 17, 2, 57, 57, 57 }, /* 81 Mb */
++			72900, 17, 17 }, /* 81 Mb */
+ 		[58] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+-			108300, 18, 18, 2, 58, 58, 58 }, /* 121.5 Mb */
++			108300, 18, 18 }, /* 121.5 Mb */
+ 		[59] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+-			142000, 19, 19, 4, 59, 59, 59 }, /*  162 Mb */
++			142000, 19, 19 }, /*  162 Mb */
+ 		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+-			205100, 20, 20, 4, 60, 61, 61 }, /*  243 Mb */
++			205100, 20, 20 }, /*  243 Mb */
+ 		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+-			224700, 20, 20, 4, 60, 61, 61 }, /*  270 Mb */
++			224700, 20, 20 }, /*  270 Mb */
+ 		[62] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+-			263100, 21, 21, 4, 62, 63, 63 }, /*  324 Mb */
++			263100, 21, 21 }, /*  324 Mb */
+ 		[63] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+-			288000, 21, 21, 4, 62, 63, 63 }, /*  360 Mb */
++			288000, 21, 21 }, /*  360 Mb */
+ 		[64] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+-			290700, 22, 22, 4, 64, 65, 65 }, /* 364.5 Mb */
++			290700, 22, 22 }, /* 364.5 Mb */
+ 		[65] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+-			317200, 22, 22, 4, 64, 65, 65 }, /* 405 Mb */
++			317200, 22, 22 }, /* 405 Mb */
+ 		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+-			317200, 23, 23, 4, 66, 67, 67 }, /* 405 Mb */
++			317200, 23, 23 }, /* 405 Mb */
+ 		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+-			346400, 23, 23, 4, 66, 67, 67 }, /* 450 Mb */
++			346400, 23, 23 }, /* 450 Mb */
+ 	},
+ 	50,  /* probe interval */
+ 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
+@@ -173,149 +173,149 @@ static const struct ath_rate_table ar541
+ 	12, /* MCS start */
+ 	{
+ 		[0] = { RC_ALL, WLAN_RC_PHY_CCK, 1000,
+-			900, 0, 2, 0, 0, 0, 0 }, /* 1 Mb */
++			900, 0, 2 }, /* 1 Mb */
+ 		[1] = { RC_ALL, WLAN_RC_PHY_CCK, 2000,
+-			1900, 1, 4, 1, 1, 1, 1 }, /* 2 Mb */
++			1900, 1, 4 }, /* 2 Mb */
+ 		[2] = { RC_ALL, WLAN_RC_PHY_CCK, 5500,
+-			4900, 2, 11, 2, 2, 2, 2 }, /* 5.5 Mb */
++			4900, 2, 11 }, /* 5.5 Mb */
+ 		[3] = { RC_ALL, WLAN_RC_PHY_CCK, 11000,
+-			8100, 3, 22, 3, 3, 3, 3 }, /* 11 Mb */
++			8100, 3, 22 }, /* 11 Mb */
+ 		[4] = { RC_INVALID, WLAN_RC_PHY_OFDM, 6000,
+-			5400, 4, 12, 4, 4, 4, 4 }, /* 6 Mb */
++			5400, 4, 12 }, /* 6 Mb */
+ 		[5] = { RC_INVALID, WLAN_RC_PHY_OFDM, 9000,
+-			7800, 5, 18, 4, 5, 5, 5 }, /* 9 Mb */
++			7800, 5, 18 }, /* 9 Mb */
+ 		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+-			10100, 6, 24, 6, 6, 6, 6 }, /* 12 Mb */
++			10100, 6, 24 }, /* 12 Mb */
+ 		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+-			14100, 7, 36, 6, 7, 7, 7 }, /* 18 Mb */
++			14100, 7, 36 }, /* 18 Mb */
+ 		[8] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+-			17700, 8, 48, 8, 8, 8, 8 }, /* 24 Mb */
++			17700, 8, 48 }, /* 24 Mb */
+ 		[9] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+-			23700, 9, 72, 8, 9, 9, 9 }, /* 36 Mb */
++			23700, 9, 72 }, /* 36 Mb */
+ 		[10] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+-			27400, 10, 96, 8, 10, 10, 10 }, /* 48 Mb */
++			27400, 10, 96 }, /* 48 Mb */
+ 		[11] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+-			30900, 11, 108, 8, 11, 11, 11 }, /* 54 Mb */
++			30900, 11, 108 }, /* 54 Mb */
+ 		[12] = { RC_INVALID, WLAN_RC_PHY_HT_20_SS, 6500,
+-			6400, 0, 0, 4, 42, 12, 42 }, /* 6.5 Mb */
++			6400, 0, 0 }, /* 6.5 Mb */
+ 		[13] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+-			12700, 1, 1, 6, 43, 13, 43 }, /* 13 Mb */
++			12700, 1, 1 }, /* 13 Mb */
+ 		[14] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+-			18800, 2, 2, 6, 44, 14, 44 }, /* 19.5 Mb*/
++			18800, 2, 2 }, /* 19.5 Mb*/
+ 		[15] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+-			25000, 3, 3, 8, 45, 15, 45 }, /* 26 Mb */
++			25000, 3, 3 }, /* 26 Mb */
+ 		[16] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+-			36700, 4, 4, 8, 46, 16, 46 }, /* 39 Mb */
++			36700, 4, 4 }, /* 39 Mb */
+ 		[17] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+-			48100, 5, 5, 8, 47, 17, 47 }, /* 52 Mb */
++			48100, 5, 5 }, /* 52 Mb */
+ 		[18] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+-			53500, 6, 6, 8, 48, 18, 48 }, /* 58.5 Mb */
++			53500, 6, 6 }, /* 58.5 Mb */
+ 		[19] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+-			59000, 7, 7, 8, 49, 20, 50 }, /* 65 Mb */
++			59000, 7, 7 }, /* 65 Mb */
+ 		[20] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+-			65400, 7, 7, 8, 49, 20, 50 }, /* 65 Mb*/
++			65400, 7, 7 }, /* 65 Mb*/
+ 		[21] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+-			12700, 8, 8, 4, 51, 21, 51 }, /* 13 Mb */
++			12700, 8, 8 }, /* 13 Mb */
+ 		[22] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+-			24800, 9, 9, 6, 52, 22, 52 }, /* 26 Mb */
++			24800, 9, 9 }, /* 26 Mb */
+ 		[23] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+-			36600, 10, 10, 6, 53, 23, 53 }, /* 39 Mb */
++			36600, 10, 10 }, /* 39 Mb */
+ 		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+-			48100, 11, 11, 8, 54, 24, 54 }, /* 52 Mb */
++			48100, 11, 11 }, /* 52 Mb */
+ 		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+-			69500, 12, 12, 8, 55, 25, 55 }, /* 78 Mb */
++			69500, 12, 12 }, /* 78 Mb */
+ 		[26] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+-			89500, 13, 13, 8, 56, 26, 56 }, /* 104 Mb */
++			89500, 13, 13 }, /* 104 Mb */
+ 		[27] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+-			98900, 14, 14, 8, 57, 27, 57 }, /* 117 Mb */
++			98900, 14, 14 }, /* 117 Mb */
+ 		[28] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+-			108300, 15, 15, 8, 58, 29, 59 }, /* 130 Mb */
++			108300, 15, 15 }, /* 130 Mb */
+ 		[29] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+-			120000, 15, 15, 8, 58, 29, 59 }, /* 144.4 Mb */
++			120000, 15, 15 }, /* 144.4 Mb */
+ 		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+-			17400, 16, 16, 4, 60, 30, 60 }, /* 19.5 Mb */
++			17400, 16, 16 }, /* 19.5 Mb */
+ 		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+-			35100, 17, 17, 6, 61, 31, 61 }, /* 39 Mb */
++			35100, 17, 17 }, /* 39 Mb */
+ 		[32] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+-			52600, 18, 18, 6, 62, 32, 62 }, /* 58.5 Mb */
++			52600, 18, 18 }, /* 58.5 Mb */
+ 		[33] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+-			70400, 19, 19, 8, 63, 33, 63 }, /* 78 Mb */
++			70400, 19, 19 }, /* 78 Mb */
+ 		[34] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+-			104900, 20, 20, 8, 64, 35, 65 }, /* 117 Mb */
++			104900, 20, 20 }, /* 117 Mb */
+ 		[35] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+-			115800, 20, 20, 8, 64, 35, 65 }, /* 130 Mb */
++			115800, 20, 20 }, /* 130 Mb */
+ 		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+-			137200, 21, 21, 8, 66, 37, 67 }, /* 156 Mb */
++			137200, 21, 21 }, /* 156 Mb */
+ 		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+-			151100, 21, 21, 8, 66, 37, 67 }, /* 173.3 Mb */
++			151100, 21, 21 }, /* 173.3 Mb */
+ 		[38] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+-			152800, 22, 22, 8, 68, 39, 69 }, /* 175.5 Mb */
++			152800, 22, 22 }, /* 175.5 Mb */
+ 		[39] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+-			168400, 22, 22, 8, 68, 39, 69 }, /* 195 Mb */
++			168400, 22, 22 }, /* 195 Mb */
+ 		[40] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+-			168400, 23, 23, 8, 70, 41, 71 }, /* 195 Mb */
++			168400, 23, 23 }, /* 195 Mb */
+ 		[41] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+-			185000, 23, 23, 8, 70, 41, 71 }, /* 216.7 Mb */
++			185000, 23, 23 }, /* 216.7 Mb */
+ 		[42] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+-			13200, 0, 0, 8, 42, 42, 42 }, /* 13.5 Mb */
++			13200, 0, 0 }, /* 13.5 Mb */
+ 		[43] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+-			25900, 1, 1, 8, 43, 43, 43 }, /* 27.0 Mb */
++			25900, 1, 1 }, /* 27.0 Mb */
+ 		[44] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+-			38600, 2, 2, 8, 44, 44, 44 }, /* 40.5 Mb */
++			38600, 2, 2 }, /* 40.5 Mb */
+ 		[45] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+-			49800, 3, 3, 8, 45, 45, 45 }, /* 54 Mb */
++			49800, 3, 3 }, /* 54 Mb */
+ 		[46] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+-			72200, 4, 4, 8, 46, 46, 46 }, /* 81 Mb */
++			72200, 4, 4 }, /* 81 Mb */
+ 		[47] = { RC_HT_S_40 , WLAN_RC_PHY_HT_40_SS, 108000,
+-			92900, 5, 5, 8, 47, 47, 47 }, /* 108 Mb */
++			92900, 5, 5 }, /* 108 Mb */
+ 		[48] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+-			102700, 6, 6, 8, 48, 48, 48 }, /* 121.5 Mb */
++			102700, 6, 6 }, /* 121.5 Mb */
+ 		[49] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+-			112000, 7, 7, 8, 49, 50, 50 }, /* 135 Mb */
++			112000, 7, 7 }, /* 135 Mb */
+ 		[50] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+-			122000, 7, 7, 8, 49, 50, 50 }, /* 150 Mb */
++			122000, 7, 7 }, /* 150 Mb */
+ 		[51] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+-			25800, 8, 8, 8, 51, 51, 51 }, /* 27 Mb */
++			25800, 8, 8 }, /* 27 Mb */
+ 		[52] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+-			49800, 9, 9, 8, 52, 52, 52 }, /* 54 Mb */
++			49800, 9, 9 }, /* 54 Mb */
+ 		[53] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+-			71900, 10, 10, 8, 53, 53, 53 }, /* 81 Mb */
++			71900, 10, 10 }, /* 81 Mb */
+ 		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+-			92500, 11, 11, 8, 54, 54, 54 }, /* 108 Mb */
++			92500, 11, 11 }, /* 108 Mb */
+ 		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+-			130300, 12, 12, 8, 55, 55, 55 }, /* 162 Mb */
++			130300, 12, 12 }, /* 162 Mb */
+ 		[56] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+-			162800, 13, 13, 8, 56, 56, 56 }, /* 216 Mb */
++			162800, 13, 13 }, /* 216 Mb */
+ 		[57] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+-			178200, 14, 14, 8, 57, 57, 57 }, /* 243 Mb */
++			178200, 14, 14 }, /* 243 Mb */
+ 		[58] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+-			192100, 15, 15, 8, 58, 59, 59 }, /* 270 Mb */
++			192100, 15, 15 }, /* 270 Mb */
+ 		[59] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+-			207000, 15, 15, 8, 58, 59, 59 }, /* 300 Mb */
++			207000, 15, 15 }, /* 300 Mb */
+ 		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+-			36100, 16, 16, 8, 60, 60, 60 }, /* 40.5 Mb */
++			36100, 16, 16 }, /* 40.5 Mb */
+ 		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+-			72900, 17, 17, 8, 61, 61, 61 }, /* 81 Mb */
++			72900, 17, 17 }, /* 81 Mb */
+ 		[62] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+-			108300, 18, 18, 8, 62, 62, 62 }, /* 121.5 Mb */
++			108300, 18, 18 }, /* 121.5 Mb */
+ 		[63] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+-			142000, 19, 19, 8, 63, 63, 63 }, /* 162 Mb */
++			142000, 19, 19 }, /* 162 Mb */
+ 		[64] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+-			205100, 20, 20, 8, 64, 65, 65 }, /* 243 Mb */
++			205100, 20, 20 }, /* 243 Mb */
+ 		[65] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+-			224700, 20, 20, 8, 64, 65, 65 }, /* 270 Mb */
++			224700, 20, 20 }, /* 270 Mb */
+ 		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+-			263100, 21, 21, 8, 66, 67, 67 }, /* 324 Mb */
++			263100, 21, 21 }, /* 324 Mb */
+ 		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+-			288000, 21, 21, 8, 66, 67, 67 }, /* 360 Mb */
++			288000, 21, 21 }, /* 360 Mb */
+ 		[68] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+-			290700, 22, 22, 8, 68, 69, 69 }, /* 364.5 Mb */
++			290700, 22, 22 }, /* 364.5 Mb */
+ 		[69] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+-			317200, 22, 22, 8, 68, 69, 69 }, /* 405 Mb */
++			317200, 22, 22 }, /* 405 Mb */
+ 		[70] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+-			317200, 23, 23, 8, 70, 71, 71 }, /* 405 Mb */
++			317200, 23, 23 }, /* 405 Mb */
+ 		[71] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+-			346400, 23, 23, 8, 70, 71, 71 }, /* 450 Mb */
++			346400, 23, 23 }, /* 450 Mb */
+ 	},
+ 	50,  /* probe interval */
+ 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
+@@ -326,21 +326,21 @@ static const struct ath_rate_table ar541
+ 	0,
+ 	{
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+-			5400, 0, 12, 0},
++			5400, 0, 12},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+-			7800,  1, 18, 0},
++			7800,  1, 18},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+-			10000, 2, 24, 2},
++			10000, 2, 24},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+-			13900, 3, 36, 2},
++			13900, 3, 36},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+-			17300, 4, 48, 4},
++			17300, 4, 48},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+-			23000, 5, 72, 4},
++			23000, 5, 72},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+-			27400, 6, 96, 4},
++			27400, 6, 96},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+-			29300, 7, 108, 4},
++			29300, 7, 108},
+ 	},
+ 	50,  /* probe interval */
+ 	0,   /* Phy rates allowed initially */
+@@ -351,56 +351,55 @@ static const struct ath_rate_table ar541
+ 	0,
+ 	{
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
+-			900, 0, 2, 0},
++			900, 0, 2},
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
+-			1900, 1, 4, 1},
++			1900, 1, 4},
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
+-			4900, 2, 11, 2},
++			4900, 2, 11},
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
+-			8100, 3, 22, 3},
++			8100, 3, 22},
+ 		{ RC_INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+-			5400, 4, 12, 4},
++			5400, 4, 12},
+ 		{ RC_INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+-			7800, 5, 18, 4},
++			7800, 5, 18},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+-			10000, 6, 24, 6},
++			10000, 6, 24},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+-			13900, 7, 36, 6},
++			13900, 7, 36},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+-			17300, 8, 48, 8},
++			17300, 8, 48},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+-			23000, 9, 72, 8},
++			23000, 9, 72},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+-			27400, 10, 96, 8},
++			27400, 10, 96},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+-			29300, 11, 108, 8},
++			29300, 11, 108},
+ 	},
+ 	50,  /* probe interval */
+ 	0,   /* Phy rates allowed initially */
+ };
+ 
+-static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
++static int ath_rc_get_rateindex(struct ath_rate_priv *ath_rc_priv,
+ 				struct ieee80211_tx_rate *rate)
+ {
+-	int rix = 0, i = 0;
+-	static const int mcs_rix_off[] = { 7, 15, 20, 21, 22, 23 };
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	int rix, i, idx = 0;
+ 
+ 	if (!(rate->flags & IEEE80211_TX_RC_MCS))
+ 		return rate->idx;
+ 
+-	while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
+-		rix++; i++;
++	for (i = 0; i < ath_rc_priv->max_valid_rate; i++) {
++		idx = ath_rc_priv->valid_rate_index[i];
++
++		if (WLAN_RC_PHY_HT(rate_table->info[idx].phy) &&
++		    rate_table->info[idx].ratecode == rate->idx)
++			break;
+ 	}
+ 
+-	rix += rate->idx + rate_table->mcs_start;
++	rix = idx;
+ 
+-	if ((rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+-	    (rate->flags & IEEE80211_TX_RC_SHORT_GI))
+-		rix = rate_table->info[rix].ht_index;
+-	else if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+-		rix = rate_table->info[rix].sgi_index;
+-	else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+-		rix = rate_table->info[rix].cw40index;
++	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
++		rix++;
+ 
+ 	return rix;
+ }
+@@ -1078,7 +1077,6 @@ static void ath_rc_tx_status(struct ath_
+ 			     struct ath_rate_priv *ath_rc_priv,
+ 			     struct sk_buff *skb)
+ {
+-	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+ 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
+ 	struct ieee80211_tx_rate *rate;
+@@ -1114,7 +1112,7 @@ static void ath_rc_tx_status(struct ath_
+ 				    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
+ 					return;
+ 
+-				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
++				rix = ath_rc_get_rateindex(ath_rc_priv, &rates[i]);
+ 				ath_rc_update_ht(sc, ath_rc_priv, tx_info,
+ 						 rix, xretries ? 1 : 2,
+ 						 rates[i].count);
+@@ -1129,7 +1127,7 @@ static void ath_rc_tx_status(struct ath_
+ 	    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
+ 		return;
+ 
+-	rix = ath_rc_get_rateindex(rate_table, &rates[final_ts_idx]);
++	rix = ath_rc_get_rateindex(ath_rc_priv, &rates[final_ts_idx]);
+ 	ath_rc_update_ht(sc, ath_rc_priv, tx_info, rix, xretries, long_retry);
+ 	ath_debug_stat_rc(ath_rc_priv, rix);
+ }
+--- a/drivers/net/wireless/ath/ath9k/rc.h
++++ b/drivers/net/wireless/ath/ath9k/rc.h
+@@ -160,10 +160,6 @@ struct ath_rate_table {
+ 		u32 user_ratekbps;
+ 		u8 ratecode;
+ 		u8 dot11rate;
+-		u8 ctrl_rate;
+-		u8 cw40index;
+-		u8 sgi_index;
+-		u8 ht_index;
+ 	} info[RATE_TABLE_SIZE];
+ 	u32 probe_interval;
+ 	u8 initial_ratemax;
diff --git a/linux-next-cherry-picks/0018-ath9k-tune-rc_stats-to-display-only-valid-rates.patch b/linux-next-cherry-picks/0018-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
new file mode 100644
index 0000000..7dd812a
--- /dev/null
+++ b/linux-next-cherry-picks/0018-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
@@ -0,0 +1,34 @@
+From c771b518199eb329c3a38e479b36b36553e25b2d Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:30 +0530
+Subject: [PATCH] ath9k: tune rc_stats to display only valid rates
+
+This could make rc_stats more simpler and ease the debugging.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 5 +++--
+ 1 file changed, 3 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1355,7 +1355,7 @@ static ssize_t read_file_rcstat(struct f
+ 	struct ath_rate_priv *rc = file->private_data;
+ 	char *buf;
+ 	unsigned int len = 0, max;
+-	int i = 0;
++	int rix;
+ 	ssize_t retval;
+ 
+ 	if (rc->rate_table == NULL)
+@@ -1371,7 +1371,8 @@ static ssize_t read_file_rcstat(struct f
+ 		       "HT", "MCS", "Rate",
+ 		       "Success", "Retries", "XRetries", "PER");
+ 
+-	for (i = 0; i < rc->rate_table_size; i++) {
++	for (rix = 0; rix < rc->max_valid_rate; rix++) {
++		u8 i = rc->valid_rate_index[rix];
+ 		u32 ratekbps = rc->rate_table->info[i].ratekbps;
+ 		struct ath_rc_stats *stats = &rc->rcstats[i];
+ 		char mcs[5];
diff --git a/linux-next-cherry-picks/0022-ath9k_hw-do-not-enable-the-MIB-interrupt-in-the-inte.patch b/linux-next-cherry-picks/0022-ath9k_hw-do-not-enable-the-MIB-interrupt-in-the-inte.patch
new file mode 100644
index 0000000..7be83db
--- /dev/null
+++ b/linux-next-cherry-picks/0022-ath9k_hw-do-not-enable-the-MIB-interrupt-in-the-inte.patch
@@ -0,0 +1,28 @@
+From 280b9a9de19b0819dcf1ab38c88e37bb82dbea0c Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Mon, 27 Aug 2012 17:00:03 +0200
+Subject: [PATCH] ath9k_hw: do not enable the MIB interrupt in the interrupt
+ mask register
+
+The interrupt is no longer handling it. While it shouldn't fire (wraparound
+is highly unlikely), the consequences would be fatal (interrupt storm).
+Disable the interrupt to prevent that from happening.
+
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 3 ---
+ 1 file changed, 3 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -978,9 +978,6 @@ static void ath9k_hw_init_interrupt_mask
+ 	else
+ 		imr_reg |= AR_IMR_TXOK;
+ 
+-	if (opmode == NL80211_IFTYPE_AP)
+-		imr_reg |= AR_IMR_MIB;
+-
+ 	ENABLE_REGWRITE_BUFFER(ah);
+ 
+ 	REG_WRITE(ah, AR_IMR, imr_reg);
diff --git a/linux-next-cherry-picks/0028-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch b/linux-next-cherry-picks/0028-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
new file mode 100644
index 0000000..5a5486b
--- /dev/null
+++ b/linux-next-cherry-picks/0028-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
@@ -0,0 +1,61 @@
+From 5d9b6f263995d7f43202d76cf2e23d43f9240a90 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Tue, 28 Aug 2012 12:14:48 +0530
+Subject: [PATCH] ath9k: Fix a crash in 2 WIRE btcoex chipsets
+
+Generic timers for BTCOEX functionality is applicable
+only for 3 WIRE BTCOEX (and MCI) chipsets.
+Hence btcoex->no_stomp_timer is allocated only 3 WIRE
+btcoex chipsets and in all the other cases its NULL.
+Make sure we stop the generic timer only if
+'btcoex->hw_timer_enabled' is true(only if its up and
+running)
+
+Fixes the following crash
+
+	[68757.020454] BUG: unable to handle kernel NULL pointer dereference at 0000000c
+	[68757.020916] IP: [<f9b055c3>] ath9k_hw_gen_timer_stop+0x13/0x80 [ath9k_hw]
+	[68757.021251] *pde = 00000000
+	[68757.024384] EIP: 0060:[<f9b055c3>] EFLAGS: 00010082 CPU: 0
+	[68757.024384] EIP is at ath9k_hw_gen_timer_stop+0x13/0x80 [ath9k_hw]
+	[68757.024384] EAX: d32d0000 EBX: d32d0000 ECX: 00000000 EDX: 00000000
+	[68757.024384] ESI: e67c24c0 EDI: 00000296 EBP: e137be2c ESP: e137be20
+	[68757.024384]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
+	[68757.024384] CR0: 8005003b CR2: 0000000c CR3: 00b99000 CR4: 000407d0
+	[68757.024384] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
+	[68757.024384] DR6: ffff0ff0 DR7: 00000400
+	[68757.024384] Process kworker/u:2 (pid: 8917, ti=e137a000 task=ea7a6860 task.ti=e137a000)
+	[68757.024384] Stack:
+	[68757.024384]  c06c4676 d32d0000 e67c24c0 e137be38 f81c9590 e67c1ca0 e137be40 f81c95d9
+	[68757.024384]  e137be64 f81cd1c5 00000246 00000002 d32d0000 e67c05e0 e67c1ca0 e67c05e0
+	[68757.024384]  00000000 e137beac f81cdfa0 e137be84 00000246 00000246 e67c1ca0 e67c1ca0
+	[68757.024384] Call Trace:
+	[68757.024384]  [<c06c4676>] ? _raw_spin_lock_irqsave+0x86/0xa0
+	[68757.024384]  [<f81c9590>] ath9k_gen_timer_stop+0x10/0x40 [ath9k]
+	[68757.024384]  [<f81c95d9>] ath9k_btcoex_stop_gen_timer+0x19/0x20 [ath9k]
+	[68757.024384]  [<f81cd1c5>] ath9k_ps_restore+0x85/0x110 [ath9k]
+	[68757.024384]  [<f81cdfa0>] ath9k_config+0x220/0x520 [ath9k]
+	[68757.024384]  [<f81cd47d>] ? ath9k_flush+0x15d/0x1b0 [ath9k]
+	[68757.024384]  [<f85c7ca5>] ieee80211_hw_config+0x135/0x2c0 [mac80211]
+	[68757.024384]  [<f860e3c8>] ieee80211_dynamic_ps_enable_work+0x198/0x5f0 [mac80211]
+
+Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Cc: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c | 3 ++-
+ 1 file changed, 2 insertions(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -341,7 +341,8 @@ void ath9k_btcoex_stop_gen_timer(struct
+ {
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+ 
+-	ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
++	if (btcoex->hw_timer_enabled)
++		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+ }
+ 
+ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
diff --git a/linux-next-cherry-picks/0030-ath9k_hw-small-optimization.patch b/linux-next-cherry-picks/0030-ath9k_hw-small-optimization.patch
new file mode 100644
index 0000000..46d74c9
--- /dev/null
+++ b/linux-next-cherry-picks/0030-ath9k_hw-small-optimization.patch
@@ -0,0 +1,53 @@
+From 4653356f695900de170779fc522e2fc41d710897 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Fri, 24 Aug 2012 16:27:06 +0530
+Subject: [PATCH] ath9k_hw: small optimization
+
+Assign the MCI BT state locally, rather than unnecessarily calling
+ar9003_mci_state and updating it.
+
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c | 6 ------
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h | 2 --
+ drivers/net/wireless/ath/ath9k/mci.c        | 2 +-
+ 3 files changed, 1 insertion(+), 9 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1201,12 +1201,6 @@ u32 ar9003_mci_state(struct ath_hw *ah,
+ 
+ 		ar9003_mci_2g5g_switch(ah, false);
+ 		break;
+-	case MCI_STATE_SET_BT_CAL_START:
+-		mci->bt_state = MCI_BT_CAL_START;
+-		break;
+-	case MCI_STATE_SET_BT_CAL:
+-		mci->bt_state = MCI_BT_CAL;
+-		break;
+ 	case MCI_STATE_RESET_REQ_WAKE:
+ 		ar9003_mci_reset_req_wakeup(ah);
+ 		mci->update_2g5g = true;
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -190,8 +190,6 @@ enum mci_bt_state {
+ enum mci_state_type {
+ 	MCI_STATE_ENABLE,
+ 	MCI_STATE_SET_BT_AWAKE,
+-	MCI_STATE_SET_BT_CAL_START,
+-	MCI_STATE_SET_BT_CAL,
+ 	MCI_STATE_LAST_SCHD_MSG_OFFSET,
+ 	MCI_STATE_REMOTE_SLEEP,
+ 	MCI_STATE_RESET_REQ_WAKE,
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -201,7 +201,7 @@ static void ath_mci_cal_msg(struct ath_s
+ 	switch (opcode) {
+ 	case MCI_GPM_BT_CAL_REQ:
+ 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
+-			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START);
++			mci_hw->bt_state = MCI_BT_CAL_START;
+ 			ath9k_queue_reset(sc, RESET_TYPE_MCI);
+ 		}
+ 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
diff --git a/linux-next-cherry-picks/0031-ath9k-Fix-TX-filter-usage.patch b/linux-next-cherry-picks/0031-ath9k-Fix-TX-filter-usage.patch
new file mode 100644
index 0000000..33d4e79
--- /dev/null
+++ b/linux-next-cherry-picks/0031-ath9k-Fix-TX-filter-usage.patch
@@ -0,0 +1,42 @@
+From adfbda62248258a402253744e4eed6b87fb43169 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Wed, 29 Aug 2012 09:20:42 +0530
+Subject: [PATCH] ath9k: Fix TX filter usage
+
+The TX filter bit for a station would be set by the HW
+when a frame is not acked. A frame would be completed with
+ATH9K_TXERR_FILT status only when the corresponding filter bit
+for the destination station is already set.
+
+Currently, un-acknowledged  packets are added to the pending queue
+and retried, but the "clear_dest_mask" bit in the descriptor is
+set only when the TX status has been ATH9K_TXERR_FILT. This results
+in packet loss and the log shows:
+
+wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746071
+wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746076
+wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746377
+...
+...
+
+This issue can be resolved by making sure that the destination
+mask is cleared when the packet is being retried and the earlier
+TX status is ATH9K_TXERR_XRETRY.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -568,7 +568,7 @@ static void ath_tx_complete_aggr(struct
+ 		if (!an->sleeping) {
+ 			ath_tx_queue_tid(txq, tid);
+ 
+-			if (ts->ts_status & ATH9K_TXERR_FILT)
++			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
+ 				tid->ac->clear_ps_filter = true;
+ 		}
+ 	}
diff --git a/linux-next-cherry-picks/0033-ath9k_hw-Fix-invalid-MCI-GPM-index-access-caching.patch b/linux-next-cherry-picks/0033-ath9k_hw-Fix-invalid-MCI-GPM-index-access-caching.patch
new file mode 100644
index 0000000..cd35b1a
--- /dev/null
+++ b/linux-next-cherry-picks/0033-ath9k_hw-Fix-invalid-MCI-GPM-index-access-caching.patch
@@ -0,0 +1,41 @@
+From 90be994cd0d70fbe4a97b144806db6cfa497392c Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Tue, 4 Sep 2012 19:33:32 +0530
+Subject: [PATCH] ath9k_hw: Fix invalid MCI GPM index access/caching
+
+There is a possibility that AR_MCI_GPM_1 register can
+return 0xdeadbeef and this results in caching of invalid
+GPM index in ar9003_mci_is_gpm_valid. Ensure we
+have appropriate checks to avoid this.
+
+Cc: xijin luo <xijin@qca.qualcomm.com>
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c | 8 ++++++++
+ 1 file changed, 8 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1321,6 +1321,10 @@ u32 ar9003_mci_get_next_gpm_offset(struc
+ 
+ 	if (first) {
+ 		gpm_ptr = MS(REG_READ(ah, AR_MCI_GPM_1), AR_MCI_GPM_WRITE_PTR);
++
++		if (gpm_ptr >= mci->gpm_len)
++			gpm_ptr = 0;
++
+ 		mci->gpm_idx = gpm_ptr;
+ 		return gpm_ptr;
+ 	}
+@@ -1365,6 +1369,10 @@ u32 ar9003_mci_get_next_gpm_offset(struc
+ 			more_gpm = MCI_GPM_NOMORE;
+ 
+ 		temp_index = mci->gpm_idx;
++
++		if (temp_index >= mci->gpm_len)
++			temp_index = 0;
++
+ 		mci->gpm_idx++;
+ 
+ 		if (mci->gpm_idx >= mci->gpm_len)
diff --git a/linux-next-cherry-picks/0034-ath9k-Fix-BTCOEX-timer-triggering-comparision.patch b/linux-next-cherry-picks/0034-ath9k-Fix-BTCOEX-timer-triggering-comparision.patch
new file mode 100644
index 0000000..b567c98
--- /dev/null
+++ b/linux-next-cherry-picks/0034-ath9k-Fix-BTCOEX-timer-triggering-comparision.patch
@@ -0,0 +1,46 @@
+From 94ae77ea4600801233663e64025529ba43075643 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Tue, 4 Sep 2012 19:33:33 +0530
+Subject: [PATCH] ath9k: Fix BTCOEX timer triggering comparision
+
+Its more correct to convert btcoex_period to 'us' while
+comparing with btcoex_no_stomp which is in 'us'.
+Did not find any functionality issues being fixed,
+as the generic hardware timer triggers are usually
+refreshed with the newer duty cycle.
+
+Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
+ drivers/net/wireless/ath/ath9k/gpio.c  | 7 ++++++-
+ 2 files changed, 7 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -472,7 +472,7 @@ struct ath_btcoex {
+ 	unsigned long op_flags;
+ 	int bt_stomp_type; /* Types of BT stomping */
+ 	u32 btcoex_no_stomp; /* in usec */
+-	u32 btcoex_period; /* in usec */
++	u32 btcoex_period; /* in msec */
+ 	u32 btscan_no_stomp; /* in usec */
+ 	u32 duty_cycle;
+ 	u32 bt_wait_time;
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -228,7 +228,12 @@ static void ath_btcoex_period_timer(unsi
+ 	ath9k_hw_btcoex_enable(ah);
+ 	spin_unlock_bh(&btcoex->btcoex_lock);
+ 
+-	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
++	/*
++	 * btcoex_period is in msec while (btocex/btscan_)no_stomp are in usec,
++	 * ensure that we properly convert btcoex_period to usec
++	 * for any comparision with (btcoex/btscan_)no_stomp.
++	 */
++	if (btcoex->btcoex_period * 1000 != btcoex->btcoex_no_stomp) {
+ 		if (btcoex->hw_timer_enabled)
+ 			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
+ 
diff --git a/linux-next-cherry-picks/0035-ath9k-Make-use-of-ath_stop_ani-wrapper.patch b/linux-next-cherry-picks/0035-ath9k-Make-use-of-ath_stop_ani-wrapper.patch
new file mode 100644
index 0000000..ba5a9f1
--- /dev/null
+++ b/linux-next-cherry-picks/0035-ath9k-Make-use-of-ath_stop_ani-wrapper.patch
@@ -0,0 +1,25 @@
+From 5686cac5bc6c41161cdf879998e16001c92e7bf8 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Tue, 4 Sep 2012 19:33:34 +0530
+Subject: [PATCH] ath9k: Make use of ath_stop_ani wrapper
+
+Additionally it has a neat debug message informing us
+that we are stopping the ANI algorithm.
+
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/main.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -2257,7 +2257,7 @@ static int ath9k_suspend(struct ieee8021
+ 	mutex_lock(&sc->mutex);
+ 
+ 	ath_cancel_work(sc);
+-	del_timer_sync(&common->ani.timer);
++	ath_stop_ani(sc);
+ 	del_timer_sync(&sc->rx_poll_timer);
+ 
+ 	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
diff --git a/linux-next-cherry-picks/0037-ath9k-Cleanup-add-change_interface-callbacks.patch b/linux-next-cherry-picks/0037-ath9k-Cleanup-add-change_interface-callbacks.patch
new file mode 100644
index 0000000..a3a5ca2
--- /dev/null
+++ b/linux-next-cherry-picks/0037-ath9k-Cleanup-add-change_interface-callbacks.patch
@@ -0,0 +1,144 @@
+From 327967cba4492c36ef498a786016295102521c55 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Tue, 4 Sep 2012 19:33:36 +0530
+Subject: [PATCH] ath9k: Cleanup add/change_interface callbacks
+
+*Remove all the checks that will be handled by cfg80211
+based on the interface combination advertised. For instance,
+driver supports at the maximum 8 beaconing interface, while
+we advertise maximum 8 beaconing interface in the interface
+combination support.
+
+*cfg80211 will take care of not allowing
+us to add an interface that is not supported by the
+driver, further if the change_interface changes the
+old interface to a beaconing interface while we had
+reached the max limit of 8 beaconing interface, again
+cfg80211 takes care of this stuff!
+So remove all these checks.
+
+*Beautify placing PS wrappers in the appropriate
+position.
+
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/main.c | 57 ++++++-----------------------------
+ 1 file changed, 10 insertions(+), 47 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -983,47 +983,21 @@ static int ath9k_add_interface(struct ie
+ 	struct ath_softc *sc = hw->priv;
+ 	struct ath_hw *ah = sc->sc_ah;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+-	int ret = 0;
+ 
+-	ath9k_ps_wakeup(sc);
+ 	mutex_lock(&sc->mutex);
+ 
+-	switch (vif->type) {
+-	case NL80211_IFTYPE_STATION:
+-	case NL80211_IFTYPE_WDS:
+-	case NL80211_IFTYPE_ADHOC:
+-	case NL80211_IFTYPE_AP:
+-	case NL80211_IFTYPE_MESH_POINT:
+-		break;
+-	default:
+-		ath_err(common, "Interface type %d not yet supported\n",
+-			vif->type);
+-		ret = -EOPNOTSUPP;
+-		goto out;
+-	}
+-
+-	if (ath9k_uses_beacons(vif->type)) {
+-		if (sc->nbcnvifs >= ATH_BCBUF) {
+-			ath_err(common, "Not enough beacon buffers when adding"
+-				" new interface of type: %i\n",
+-				vif->type);
+-			ret = -ENOBUFS;
+-			goto out;
+-		}
+-	}
+-
+ 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
+-
+ 	sc->nvifs++;
+ 
++	ath9k_ps_wakeup(sc);
+ 	ath9k_calculate_summary_state(hw, vif);
++	ath9k_ps_restore(sc);
++
+ 	if (ath9k_uses_beacons(vif->type))
+ 		ath9k_beacon_assign_slot(sc, vif);
+ 
+-out:
+ 	mutex_unlock(&sc->mutex);
+-	ath9k_ps_restore(sc);
+-	return ret;
++	return 0;
+ }
+ 
+ static int ath9k_change_interface(struct ieee80211_hw *hw,
+@@ -1033,21 +1007,9 @@ static int ath9k_change_interface(struct
+ {
+ 	struct ath_softc *sc = hw->priv;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	int ret = 0;
+ 
+ 	ath_dbg(common, CONFIG, "Change Interface\n");
+-
+ 	mutex_lock(&sc->mutex);
+-	ath9k_ps_wakeup(sc);
+-
+-	if (ath9k_uses_beacons(new_type) &&
+-	    !ath9k_uses_beacons(vif->type)) {
+-		if (sc->nbcnvifs >= ATH_BCBUF) {
+-			ath_err(common, "No beacon slot available\n");
+-			ret = -ENOBUFS;
+-			goto out;
+-		}
+-	}
+ 
+ 	if (ath9k_uses_beacons(vif->type))
+ 		ath9k_beacon_remove_slot(sc, vif);
+@@ -1055,14 +1017,15 @@ static int ath9k_change_interface(struct
+ 	vif->type = new_type;
+ 	vif->p2p = p2p;
+ 
++	ath9k_ps_wakeup(sc);
+ 	ath9k_calculate_summary_state(hw, vif);
++	ath9k_ps_restore(sc);
++
+ 	if (ath9k_uses_beacons(vif->type))
+ 		ath9k_beacon_assign_slot(sc, vif);
+ 
+-out:
+-	ath9k_ps_restore(sc);
+ 	mutex_unlock(&sc->mutex);
+-	return ret;
++	return 0;
+ }
+ 
+ static void ath9k_remove_interface(struct ieee80211_hw *hw,
+@@ -1073,7 +1036,6 @@ static void ath9k_remove_interface(struc
+ 
+ 	ath_dbg(common, CONFIG, "Detach Interface\n");
+ 
+-	ath9k_ps_wakeup(sc);
+ 	mutex_lock(&sc->mutex);
+ 
+ 	sc->nvifs--;
+@@ -1081,10 +1043,11 @@ static void ath9k_remove_interface(struc
+ 	if (ath9k_uses_beacons(vif->type))
+ 		ath9k_beacon_remove_slot(sc, vif);
+ 
++	ath9k_ps_wakeup(sc);
+ 	ath9k_calculate_summary_state(hw, NULL);
++	ath9k_ps_restore(sc);
+ 
+ 	mutex_unlock(&sc->mutex);
+-	ath9k_ps_restore(sc);
+ }
+ 
+ static void ath9k_enable_ps(struct ath_softc *sc)
diff --git a/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch b/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
new file mode 100644
index 0000000..1a4d965
--- /dev/null
+++ b/linux-next-cherry-picks/0041-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
@@ -0,0 +1,78 @@
+From 02eba421980d5b7ff8b5e7fd50327b00e5adb430 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 7 Sep 2012 12:15:15 +0530
+Subject: [PATCH] ath9k_hw: Read and apply thermometer settings from EEPROM
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 39 ++++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  2 ++
+ 2 files changed, 41 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3977,6 +3977,44 @@ static void ar9003_hw_xlna_bias_strength
+ 		      bias & 0x3);
+ }
+ 
++static int ar9003_hw_get_thermometer(struct ath_hw *ah)
++{
++	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
++	struct ar9300_base_eep_hdr *pBase = &eep->baseEepHeader;
++	int thermometer =  (pBase->miscConfiguration >> 1) & 0x3;
++
++	return --thermometer;
++}
++
++static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
++{
++	int thermometer = ar9003_hw_get_thermometer(ah);
++	u8 therm_on = (thermometer < 0) ? 0 : 1;
++
++	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
++		      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
++	if (ah->caps.tx_chainmask & BIT(1))
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
++	if (ah->caps.tx_chainmask & BIT(2))
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
++
++	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
++	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
++		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
++	if (ah->caps.tx_chainmask & BIT(1)) {
++		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
++	}
++	if (ah->caps.tx_chainmask & BIT(2)) {
++		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
++	}
++}
++
+ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
+ 					     struct ath9k_channel *chan)
+ {
+@@ -3992,6 +4030,7 @@ static void ath9k_hw_ar9300_set_board_va
+ 		ar9003_hw_internal_regulator_apply(ah);
+ 	ar9003_hw_apply_tuning_caps(ah);
+ 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
++	ar9003_hw_thermometer_apply(ah);
+ }
+ 
+ static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -877,6 +877,8 @@
+ 
+ #define AR_PHY_65NM_CH0_RXTX4_THERM_ON          0x10000000
+ #define AR_PHY_65NM_CH0_RXTX4_THERM_ON_S        28
++#define AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR      0x20000000
++#define AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR_S    29
+ 
+ #define AR_PHY_65NM_RXTX4_XLNA_BIAS		0xC0000000
+ #define AR_PHY_65NM_RXTX4_XLNA_BIAS_S		30
diff --git a/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch b/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
new file mode 100644
index 0000000..44dca4f
--- /dev/null
+++ b/linux-next-cherry-picks/0042-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
@@ -0,0 +1,65 @@
+From 80fe43f2bbd5138f3b04476bb4a954a2a34bc960 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 7 Sep 2012 12:15:16 +0530
+Subject: [PATCH] ath9k_hw: Read and configure thermocal for AR9462
+
+Read and configure thermometer calibration results read from
+OTP card.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 19 +++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  6 ++++++
+ 2 files changed, 25 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -4015,6 +4015,24 @@ static void ar9003_hw_thermometer_apply(
+ 	}
+ }
+ 
++static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
++{
++	u32 data, ko, kg;
++
++	if (!AR_SREV_9462_20(ah))
++		return;
++	ar9300_otp_read_word(ah, 1, &data);
++	ko = data & 0xff;
++	kg = (data >> 8) & 0xff;
++	if (ko || kg) {
++		REG_RMW_FIELD(ah, AR_PHY_BB_THERM_ADC_3,
++			      AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET, ko);
++		REG_RMW_FIELD(ah, AR_PHY_BB_THERM_ADC_3,
++			      AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN,
++			      kg + 256);
++	}
++}
++
+ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
+ 					     struct ath9k_channel *chan)
+ {
+@@ -4031,6 +4049,7 @@ static void ath9k_hw_ar9300_set_board_va
+ 	ar9003_hw_apply_tuning_caps(ah);
+ 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
+ 	ar9003_hw_thermometer_apply(ah);
++	ar9003_hw_thermo_cal_apply(ah);
+ }
+ 
+ static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -609,6 +609,12 @@
+ #define AR_PHY_BB_THERM_ADC_1_INIT_THERM		0x000000ff
+ #define AR_PHY_BB_THERM_ADC_1_INIT_THERM_S		0
+ 
++#define AR_PHY_BB_THERM_ADC_3				(AR_SM_BASE + 0x250)
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN	0x0001ff00
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN_S	8
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET		0x000000ff
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET_S	0
++
+ #define AR_PHY_BB_THERM_ADC_4				(AR_SM_BASE + 0x254)
+ #define AR_PHY_BB_THERM_ADC_4_LATEST_THERM_VALUE	0x000000ff
+ #define AR_PHY_BB_THERM_ADC_4_LATEST_THERM_VALUE_S	0
diff --git a/linux-next-cherry-picks/0043-ath9k-Add-Generic-hardware-timer-interrupt-in-debugf.patch b/linux-next-cherry-picks/0043-ath9k-Add-Generic-hardware-timer-interrupt-in-debugf.patch
new file mode 100644
index 0000000..71df6a6
--- /dev/null
+++ b/linux-next-cherry-picks/0043-ath9k-Add-Generic-hardware-timer-interrupt-in-debugf.patch
@@ -0,0 +1,54 @@
+From c9e6e980433a0399c02061a59175bbc819eb8507 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Fri, 7 Sep 2012 15:54:13 +0530
+Subject: [PATCH] ath9k: Add Generic hardware timer interrupt in debugfs
+
+Having generic hardware timer interrupt in debugfs
+would come handy when we are debugging 3 WIRE
+BTCOEX issues.
+
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/debug.c | 3 +++
+ drivers/net/wireless/ath/ath9k/debug.h | 3 +++
+ 2 files changed, 6 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/debug.c
++++ b/drivers/net/wireless/ath/ath9k/debug.c
+@@ -373,6 +373,8 @@ void ath_debug_stat_interrupt(struct ath
+ 		sc->debug.stats.istats.tsfoor++;
+ 	if (status & ATH9K_INT_MCI)
+ 		sc->debug.stats.istats.mci++;
++	if (status & ATH9K_INT_GENTIMER)
++		sc->debug.stats.istats.gen_timer++;
+ }
+ 
+ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
+@@ -418,6 +420,7 @@ static ssize_t read_file_interrupt(struc
+ 	PR_IS("DTIM", dtim);
+ 	PR_IS("TSFOOR", tsfoor);
+ 	PR_IS("MCI", mci);
++	PR_IS("GENTIMER", gen_timer);
+ 	PR_IS("TOTAL", total);
+ 
+ 	len += snprintf(buf + len, mxlen - len,
+--- a/drivers/net/wireless/ath/ath9k/debug.h
++++ b/drivers/net/wireless/ath/ath9k/debug.h
+@@ -74,6 +74,8 @@ enum ath_reset_type {
+  * from a beacon differs from the PCU's internal TSF by more than a
+  * (programmable) threshold
+  * @local_timeout: Internal bus timeout.
++ * @mci: MCI interrupt, specific to MCI based BTCOEX chipsets
++ * @gen_timer: Generic hardware timer interrupt
+  */
+ struct ath_interrupt_stats {
+ 	u32 total;
+@@ -100,6 +102,7 @@ struct ath_interrupt_stats {
+ 	u32 bb_watchdog;
+ 	u32 tsfoor;
+ 	u32 mci;
++	u32 gen_timer;
+ 
+ 	/* Sync-cause stats */
+ 	u32 sync_cause_all;
diff --git a/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch b/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
new file mode 100644
index 0000000..1136c89
--- /dev/null
+++ b/linux-next-cherry-picks/0045-ath9k_hw-Add-version-revision-macros-for-AR9565.patch
@@ -0,0 +1,94 @@
+From 77fac465b4b65056a2cec62c1acdc754b7ae86ed Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Tue, 11 Sep 2012 20:09:18 +0530
+Subject: [PATCH] ath9k_hw: Add version/revision macros for AR9565
+
+And recognize the device in the init path.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c  | 7 +++++--
+ drivers/net/wireless/ath/ath9k/hw.h  | 1 +
+ drivers/net/wireless/ath/ath9k/reg.h | 9 +++++++++
+ 3 files changed, 15 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -355,7 +355,7 @@ static void ath9k_hw_read_revisions(stru
+ 			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
+ 		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
+ 
+-		if (AR_SREV_9462(ah))
++		if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+ 			ah->is_pciexpress = true;
+ 		else
+ 			ah->is_pciexpress = (val &
+@@ -650,6 +650,7 @@ static int __ath9k_hw_init(struct ath_hw
+ 	case AR_SREV_VERSION_9340:
+ 	case AR_SREV_VERSION_9462:
+ 	case AR_SREV_VERSION_9550:
++	case AR_SREV_VERSION_9565:
+ 		break;
+ 	default:
+ 		ath_err(common,
+@@ -711,7 +712,7 @@ int ath9k_hw_init(struct ath_hw *ah)
+ 	int ret;
+ 	struct ath_common *common = ath9k_hw_common(ah);
+ 
+-	/* These are all the AR5008/AR9001/AR9002 hardware family of chipsets */
++	/* These are all the AR5008/AR9001/AR9002/AR9003 hardware family of chipsets */
+ 	switch (ah->hw_version.devid) {
+ 	case AR5416_DEVID_PCI:
+ 	case AR5416_DEVID_PCIE:
+@@ -731,6 +732,7 @@ int ath9k_hw_init(struct ath_hw *ah)
+ 	case AR9300_DEVID_AR9580:
+ 	case AR9300_DEVID_AR9462:
+ 	case AR9485_DEVID_AR1111:
++	case AR9300_DEVID_AR9565:
+ 		break;
+ 	default:
+ 		if (common->bus_ops->ath_bus_type == ATH_USB)
+@@ -3157,6 +3159,7 @@ static struct {
+ 	{ AR_SREV_VERSION_9485,         "9485" },
+ 	{ AR_SREV_VERSION_9462,         "9462" },
+ 	{ AR_SREV_VERSION_9550,         "9550" },
++	{ AR_SREV_VERSION_9565,         "9565" },
+ };
+ 
+ /* For devices with external radios */
+--- a/drivers/net/wireless/ath/ath9k/hw.h
++++ b/drivers/net/wireless/ath/ath9k/hw.h
+@@ -50,6 +50,7 @@
+ #define AR9300_DEVID_AR9330	0x0035
+ #define AR9300_DEVID_QCA955X	0x0038
+ #define AR9485_DEVID_AR1111	0x0037
++#define AR9300_DEVID_AR9565     0x0036
+ 
+ #define AR5416_AR9100_DEVID	0x000b
+ 
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -801,6 +801,8 @@
+ #define AR_SREV_REVISION_9580_10	4 /* AR9580 1.0 */
+ #define AR_SREV_VERSION_9462		0x280
+ #define AR_SREV_REVISION_9462_20	2
++#define AR_SREV_VERSION_9565            0x2C0
++#define AR_SREV_REVISION_9565_10        0
+ #define AR_SREV_VERSION_9550		0x400
+ 
+ #define AR_SREV_5416(_ah) \
+@@ -909,6 +911,13 @@
+ 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+ 	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
+ 
++#define AR_SREV_9565(_ah) \
++	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
++
++#define AR_SREV_9565_10(_ah) \
++	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
++	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_10))
++
+ #define AR_SREV_9550(_ah) \
+ 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9550))
+ 
diff --git a/linux-next-cherry-picks/0046-ath9k_hw-Add-AR9565-initvals.patch b/linux-next-cherry-picks/0046-ath9k_hw-Add-AR9565-initvals.patch
new file mode 100644
index 0000000..815367e
--- /dev/null
+++ b/linux-next-cherry-picks/0046-ath9k_hw-Add-AR9565-initvals.patch
@@ -0,0 +1,1405 @@
+From aaa53ee97dab2b4c98ea2765e4f16af62d8694bb Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Mon, 10 Sep 2012 09:19:54 +0530
+Subject: [PATCH] ath9k_hw: Add AR9565 initvals
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   57 +-
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    9 +-
+ .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 1233 ++++++++++++++++++++
+ 3 files changed, 1291 insertions(+), 8 deletions(-)
+ create mode 100644 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+@@ -24,6 +24,7 @@
+ #include "ar955x_1p0_initvals.h"
+ #include "ar9580_1p0_initvals.h"
+ #include "ar9462_2p0_initvals.h"
++#include "ar9565_1p0_initvals.h"
+ 
+ /* General hardware code for the AR9003 hadware family */
+ 
+@@ -34,14 +35,12 @@
+  */
+ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
+ {
+-#define PCIE_PLL_ON_CREQ_DIS_L1_2P0 \
+-		ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
+-
+ #define AR9462_BB_CTX_COEFJ(x)	\
+ 		ar9462_##x##_baseband_core_txfir_coeff_japan_2484
+ 
+ #define AR9462_BBC_TXIFR_COEFFJ \
+ 		ar9462_2p0_baseband_core_txfir_coeff_japan_2484
++
+ 	if (AR_SREV_9330_11(ah)) {
+ 		/* mac */
+ 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+@@ -220,10 +219,10 @@ static void ar9003_hw_init_mode_regs(str
+ 
+ 		/* Awake -> Sleep Setting */
+ 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
+-				PCIE_PLL_ON_CREQ_DIS_L1_2P0);
++			       ar9462_pciephy_pll_on_clkreq_disable_L1_2p0);
+ 		/* Sleep -> Awake Setting */
+ 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+-				PCIE_PLL_ON_CREQ_DIS_L1_2P0);
++			       ar9462_pciephy_pll_on_clkreq_disable_L1_2p0);
+ 
+ 		/* Fast clock modal settings */
+ 		INIT_INI_ARRAY(&ah->iniModesFastClock,
+@@ -302,6 +301,39 @@ static void ar9003_hw_init_mode_regs(str
+ 
+ 		INIT_INI_ARRAY(&ah->iniModesFastClock,
+ 				ar9580_1p0_modes_fast_clock);
++	} else if (AR_SREV_9565(ah)) {
++		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
++			       ar9565_1p0_mac_core);
++		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
++			       ar9565_1p0_mac_postamble);
++
++		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
++			       ar9565_1p0_baseband_core);
++		INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
++			       ar9565_1p0_baseband_postamble);
++
++		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
++			       ar9565_1p0_radio_core);
++		INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
++			       ar9565_1p0_radio_postamble);
++
++		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
++			       ar9565_1p0_soc_preamble);
++		INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
++			       ar9565_1p0_soc_postamble);
++
++		INIT_INI_ARRAY(&ah->iniModesRxGain,
++			       ar9565_1p0_Common_rx_gain_table);
++		INIT_INI_ARRAY(&ah->iniModesTxGain,
++			       ar9565_1p0_Modes_lowest_ob_db_tx_gain_table);
++
++		INIT_INI_ARRAY(&ah->iniPcieSerdes,
++			       ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
++		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
++			       ar9565_1p0_pciephy_pll_on_clkreq_disable_L1);
++
++		INIT_INI_ARRAY(&ah->iniModesFastClock,
++				ar9565_1p0_modes_fast_clock);
+ 	} else {
+ 		/* mac */
+ 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+@@ -374,6 +406,9 @@ static void ar9003_tx_gain_table_mode0(s
+ 	else if (AR_SREV_9462_20(ah))
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9462_modes_low_ob_db_tx_gain_table_2p0);
++	else if (AR_SREV_9565(ah))
++		INIT_INI_ARRAY(&ah->iniModesTxGain,
++			       ar9565_1p0_modes_low_ob_db_tx_gain_table);
+ 	else
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9300Modes_lowest_ob_db_tx_gain_table_2p2);
+@@ -402,6 +437,9 @@ static void ar9003_tx_gain_table_mode1(s
+ 	else if (AR_SREV_9462_20(ah))
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9462_modes_high_ob_db_tx_gain_table_2p0);
++	else if (AR_SREV_9565(ah))
++		INIT_INI_ARRAY(&ah->iniModesTxGain,
++			       ar9565_1p0_modes_high_ob_db_tx_gain_table);
+ 	else
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9300Modes_high_ob_db_tx_gain_table_2p2);
+@@ -424,6 +462,9 @@ static void ar9003_tx_gain_table_mode2(s
+ 	else if (AR_SREV_9580(ah))
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9580_1p0_low_ob_db_tx_gain_table);
++	else if (AR_SREV_9565(ah))
++		INIT_INI_ARRAY(&ah->iniModesTxGain,
++			       ar9565_1p0_modes_low_ob_db_tx_gain_table);
+ 	else
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9300Modes_low_ob_db_tx_gain_table_2p2);
+@@ -446,6 +487,9 @@ static void ar9003_tx_gain_table_mode3(s
+ 	else if (AR_SREV_9580(ah))
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9580_1p0_high_power_tx_gain_table);
++	else if (AR_SREV_9565(ah))
++		INIT_INI_ARRAY(&ah->iniModesTxGain,
++			       ar9565_1p0_modes_high_power_tx_gain_table);
+ 	else
+ 		INIT_INI_ARRAY(&ah->iniModesTxGain,
+ 			ar9300Modes_high_power_tx_gain_table_2p2);
+@@ -538,6 +582,9 @@ static void ar9003_rx_gain_table_mode1(s
+ 	} else if (AR_SREV_9580(ah))
+ 		INIT_INI_ARRAY(&ah->iniModesRxGain,
+ 			ar9580_1p0_wo_xlna_rx_gain_table);
++	else if (AR_SREV_9565(ah))
++		INIT_INI_ARRAY(&ah->iniModesRxGain,
++			       ar9565_1p0_common_wo_xlna_rx_gain_table);
+ 	else
+ 		INIT_INI_ARRAY(&ah->iniModesRxGain,
+ 			ar9300Common_wo_xlna_rx_gain_table_2p2);
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -1312,10 +1312,10 @@ static int ar9003_hw_fast_chan_change(st
+ 	ar9003_hw_prog_ini(ah, &ah->iniMac[ATH_INI_POST], modesIndex);
+ 	ar9003_hw_prog_ini(ah, &ah->iniBB[ATH_INI_POST], modesIndex);
+ 	ar9003_hw_prog_ini(ah, &ah->iniRadio[ATH_INI_POST], modesIndex);
++
+ 	if (AR_SREV_9462_20(ah))
+-		ar9003_hw_prog_ini(ah,
+-				&ah->ini_radio_post_sys2ant,
+-				modesIndex);
++		ar9003_hw_prog_ini(ah, &ah->ini_radio_post_sys2ant,
++				   modesIndex);
+ 
+ 	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+ 
+@@ -1326,6 +1326,9 @@ static int ar9003_hw_fast_chan_change(st
+ 	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+ 		REG_WRITE_ARRAY(&ah->iniModesFastClock, modesIndex, regWrites);
+ 
++	if (AR_SREV_9565(ah))
++		REG_WRITE_ARRAY(&ah->iniModesFastClock, 1, regWrites);
++
+ 	REG_WRITE_ARRAY(&ah->iniAdditional, 1, regWrites);
+ 
+ 	ah->modes_index = modesIndex;
+--- /dev/null
++++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+@@ -0,0 +1,1233 @@
++/*
++ * Copyright (c) 2010-2011 Atheros Communications Inc.
++ * Copyright (c) 2011-2012 Qualcomm Atheros Inc.
++ *
++ * Permission to use, copy, modify, and/or distribute this software for any
++ * purpose with or without fee is hereby granted, provided that the above
++ * copyright notice and this permission notice appear in all copies.
++ *
++ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
++ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
++ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
++ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
++ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
++ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
++ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
++ */
++
++#ifndef INITVALS_9565_1P0_H
++#define INITVALS_9565_1P0_H
++
++/* AR9565 1.0 */
++
++static const u32 ar9565_1p0_mac_core[][2] = {
++	/* Addr      allmodes  */
++	{0x00000008, 0x00000000},
++	{0x00000030, 0x000a0085},
++	{0x00000034, 0x00000005},
++	{0x00000040, 0x00000000},
++	{0x00000044, 0x00000000},
++	{0x00000048, 0x00000008},
++	{0x0000004c, 0x00000010},
++	{0x00000050, 0x00000000},
++	{0x00001040, 0x002ffc0f},
++	{0x00001044, 0x002ffc0f},
++	{0x00001048, 0x002ffc0f},
++	{0x0000104c, 0x002ffc0f},
++	{0x00001050, 0x002ffc0f},
++	{0x00001054, 0x002ffc0f},
++	{0x00001058, 0x002ffc0f},
++	{0x0000105c, 0x002ffc0f},
++	{0x00001060, 0x002ffc0f},
++	{0x00001064, 0x002ffc0f},
++	{0x000010f0, 0x00000100},
++	{0x00001270, 0x00000000},
++	{0x000012b0, 0x00000000},
++	{0x000012f0, 0x00000000},
++	{0x0000143c, 0x00000000},
++	{0x0000147c, 0x00000000},
++	{0x00001810, 0x0f000003},
++	{0x00008000, 0x00000000},
++	{0x00008004, 0x00000000},
++	{0x00008008, 0x00000000},
++	{0x0000800c, 0x00000000},
++	{0x00008018, 0x00000000},
++	{0x00008020, 0x00000000},
++	{0x00008038, 0x00000000},
++	{0x0000803c, 0x00000000},
++	{0x00008040, 0x00000000},
++	{0x00008044, 0x00000000},
++	{0x00008048, 0x00000000},
++	{0x0000804c, 0xffffffff},
++	{0x00008050, 0xffffffff},
++	{0x00008054, 0x00000000},
++	{0x00008058, 0x00000000},
++	{0x0000805c, 0x000fc78f},
++	{0x00008060, 0x0000000f},
++	{0x00008064, 0x00000000},
++	{0x00008070, 0x00000310},
++	{0x00008074, 0x00000020},
++	{0x00008078, 0x00000000},
++	{0x0000809c, 0x0000000f},
++	{0x000080a0, 0x00000000},
++	{0x000080a4, 0x02ff0000},
++	{0x000080a8, 0x0e070605},
++	{0x000080ac, 0x0000000d},
++	{0x000080b0, 0x00000000},
++	{0x000080b4, 0x00000000},
++	{0x000080b8, 0x00000000},
++	{0x000080bc, 0x00000000},
++	{0x000080c0, 0x2a800000},
++	{0x000080c4, 0x06900168},
++	{0x000080c8, 0x13881c20},
++	{0x000080cc, 0x01f40000},
++	{0x000080d0, 0x00252500},
++	{0x000080d4, 0x00b00005},
++	{0x000080d8, 0x00400002},
++	{0x000080dc, 0x00000000},
++	{0x000080e0, 0xffffffff},
++	{0x000080e4, 0x0000ffff},
++	{0x000080e8, 0x3f3f3f3f},
++	{0x000080ec, 0x00000000},
++	{0x000080f0, 0x00000000},
++	{0x000080f4, 0x00000000},
++	{0x000080fc, 0x00020000},
++	{0x00008100, 0x00000000},
++	{0x00008108, 0x00000052},
++	{0x0000810c, 0x00000000},
++	{0x00008110, 0x00000000},
++	{0x00008114, 0x000007ff},
++	{0x00008118, 0x000000aa},
++	{0x0000811c, 0x00003210},
++	{0x00008124, 0x00000000},
++	{0x00008128, 0x00000000},
++	{0x0000812c, 0x00000000},
++	{0x00008130, 0x00000000},
++	{0x00008134, 0x00000000},
++	{0x00008138, 0x00000000},
++	{0x0000813c, 0x0000ffff},
++	{0x00008144, 0xffffffff},
++	{0x00008168, 0x00000000},
++	{0x0000816c, 0x00000000},
++	{0x00008170, 0x18486200},
++	{0x00008174, 0x33332210},
++	{0x00008178, 0x00000000},
++	{0x0000817c, 0x00020000},
++	{0x000081c4, 0x33332210},
++	{0x000081c8, 0x00000000},
++	{0x000081cc, 0x00000000},
++	{0x000081d4, 0x00000000},
++	{0x000081ec, 0x00000000},
++	{0x000081f0, 0x00000000},
++	{0x000081f4, 0x00000000},
++	{0x000081f8, 0x00000000},
++	{0x000081fc, 0x00000000},
++	{0x00008240, 0x00100000},
++	{0x00008244, 0x0010f424},
++	{0x00008248, 0x00000800},
++	{0x0000824c, 0x0001e848},
++	{0x00008250, 0x00000000},
++	{0x00008254, 0x00000000},
++	{0x00008258, 0x00000000},
++	{0x0000825c, 0x40000000},
++	{0x00008260, 0x00080922},
++	{0x00008264, 0x9d400010},
++	{0x00008268, 0xffffffff},
++	{0x0000826c, 0x0000ffff},
++	{0x00008270, 0x00000000},
++	{0x00008274, 0x40000000},
++	{0x00008278, 0x003e4180},
++	{0x0000827c, 0x00000004},
++	{0x00008284, 0x0000002c},
++	{0x00008288, 0x0000002c},
++	{0x0000828c, 0x000000ff},
++	{0x00008294, 0x00000000},
++	{0x00008298, 0x00000000},
++	{0x0000829c, 0x00000000},
++	{0x00008300, 0x00000140},
++	{0x00008314, 0x00000000},
++	{0x0000831c, 0x0000010d},
++	{0x00008328, 0x00000000},
++	{0x0000832c, 0x0000001f},
++	{0x00008330, 0x00000302},
++	{0x00008334, 0x00000700},
++	{0x00008338, 0xffff0000},
++	{0x0000833c, 0x02400000},
++	{0x00008340, 0x000107ff},
++	{0x00008344, 0xaa48105b},
++	{0x00008348, 0x008f0000},
++	{0x0000835c, 0x00000000},
++	{0x00008360, 0xffffffff},
++	{0x00008364, 0xffffffff},
++	{0x00008368, 0x00000000},
++	{0x00008370, 0x00000000},
++	{0x00008374, 0x000000ff},
++	{0x00008378, 0x00000000},
++	{0x0000837c, 0x00000000},
++	{0x00008380, 0xffffffff},
++	{0x00008384, 0xffffffff},
++	{0x00008390, 0xffffffff},
++	{0x00008394, 0xffffffff},
++	{0x00008398, 0x00000000},
++	{0x0000839c, 0x00000000},
++	{0x000083a4, 0x0000fa14},
++	{0x000083a8, 0x000f0c00},
++	{0x000083ac, 0x33332210},
++	{0x000083b0, 0x33332210},
++	{0x000083b4, 0x33332210},
++	{0x000083b8, 0x33332210},
++	{0x000083bc, 0x00000000},
++	{0x000083c0, 0x00000000},
++	{0x000083c4, 0x00000000},
++	{0x000083c8, 0x00000000},
++	{0x000083cc, 0x00000200},
++	{0x000083d0, 0x800301ff},
++};
++
++static const u32 ar9565_1p0_mac_postamble[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
++	{0x00001070, 0x00000168, 0x000002d0, 0x00000318, 0x0000018c},
++	{0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38},
++	{0x00008014, 0x03e803e8, 0x07d007d0, 0x10801600, 0x08400b00},
++	{0x0000801c, 0x128d8027, 0x128d804f, 0x12e00057, 0x12e0002b},
++	{0x00008120, 0x08f04800, 0x08f04800, 0x08f04810, 0x08f04810},
++	{0x000081d0, 0x00003210, 0x00003210, 0x0000320a, 0x0000320a},
++	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
++};
++
++static const u32 ar9565_1p0_baseband_core[][2] = {
++	/* Addr      allmodes  */
++	{0x00009800, 0xafe68e30},
++	{0x00009804, 0xfd14e000},
++	{0x00009808, 0x9c0a8f6b},
++	{0x0000980c, 0x04800000},
++	{0x00009814, 0x9280c00a},
++	{0x00009818, 0x00000000},
++	{0x0000981c, 0x00020028},
++	{0x00009834, 0x6400a290},
++	{0x00009838, 0x0108ecff},
++	{0x0000983c, 0x0d000600},
++	{0x00009880, 0x201fff00},
++	{0x00009884, 0x00001042},
++	{0x000098a4, 0x00200400},
++	{0x000098b0, 0x32840bbe},
++	{0x000098d0, 0x004b6a8e},
++	{0x000098d4, 0x00000820},
++	{0x000098dc, 0x00000000},
++	{0x000098e4, 0x01ffffff},
++	{0x000098e8, 0x01ffffff},
++	{0x000098ec, 0x01ffffff},
++	{0x000098f0, 0x00000000},
++	{0x000098f4, 0x00000000},
++	{0x00009bf0, 0x80000000},
++	{0x00009c04, 0xff55ff55},
++	{0x00009c08, 0x0320ff55},
++	{0x00009c0c, 0x00000000},
++	{0x00009c10, 0x00000000},
++	{0x00009c14, 0x00046384},
++	{0x00009c18, 0x05b6b440},
++	{0x00009c1c, 0x00b6b440},
++	{0x00009d00, 0xc080a333},
++	{0x00009d04, 0x40206c10},
++	{0x00009d08, 0x009c4060},
++	{0x00009d0c, 0x1883800a},
++	{0x00009d10, 0x01834061},
++	{0x00009d14, 0x00c00400},
++	{0x00009d18, 0x00000000},
++	{0x00009e08, 0x0078230c},
++	{0x00009e24, 0x990bb515},
++	{0x00009e28, 0x126f0000},
++	{0x00009e30, 0x06336f77},
++	{0x00009e34, 0x6af6532f},
++	{0x00009e38, 0x0cc80c00},
++	{0x00009e40, 0x0d261820},
++	{0x00009e4c, 0x00001004},
++	{0x00009e50, 0x00ff03f1},
++	{0x00009e54, 0xe4c355c7},
++	{0x00009e5c, 0xe9198724},
++	{0x00009fc0, 0x823e4788},
++	{0x00009fc4, 0x0001efb5},
++	{0x00009fcc, 0x40000014},
++	{0x0000a20c, 0x00000000},
++	{0x0000a220, 0x00000000},
++	{0x0000a224, 0x00000000},
++	{0x0000a228, 0x10002310},
++	{0x0000a23c, 0x00000000},
++	{0x0000a244, 0x0c000000},
++	{0x0000a2a0, 0x00000001},
++	{0x0000a2c0, 0x00000001},
++	{0x0000a2c8, 0x00000000},
++	{0x0000a2cc, 0x18c43433},
++	{0x0000a2d4, 0x00000000},
++	{0x0000a2ec, 0x00000000},
++	{0x0000a2f0, 0x00000000},
++	{0x0000a2f4, 0x00000000},
++	{0x0000a2f8, 0x00000000},
++	{0x0000a344, 0x00000000},
++	{0x0000a34c, 0x00000000},
++	{0x0000a350, 0x0000a000},
++	{0x0000a364, 0x00000000},
++	{0x0000a370, 0x00000000},
++	{0x0000a390, 0x00000001},
++	{0x0000a394, 0x00000444},
++	{0x0000a398, 0x001f0e0f},
++	{0x0000a39c, 0x0075393f},
++	{0x0000a3a0, 0xb79f6427},
++	{0x0000a3a4, 0x00000000},
++	{0x0000a3a8, 0xaaaaaaaa},
++	{0x0000a3ac, 0x3c466478},
++	{0x0000a3c0, 0x20202020},
++	{0x0000a3c4, 0x22222220},
++	{0x0000a3c8, 0x20200020},
++	{0x0000a3cc, 0x20202020},
++	{0x0000a3d0, 0x20202020},
++	{0x0000a3d4, 0x20202020},
++	{0x0000a3d8, 0x20202020},
++	{0x0000a3dc, 0x20202020},
++	{0x0000a3e0, 0x20202020},
++	{0x0000a3e4, 0x20202020},
++	{0x0000a3e8, 0x20202020},
++	{0x0000a3ec, 0x20202020},
++	{0x0000a3f0, 0x00000000},
++	{0x0000a3f4, 0x00000006},
++	{0x0000a3f8, 0x0cdbd380},
++	{0x0000a3fc, 0x000f0f01},
++	{0x0000a400, 0x8fa91f01},
++	{0x0000a404, 0x00000000},
++	{0x0000a408, 0x0e79e5c6},
++	{0x0000a40c, 0x00820820},
++	{0x0000a414, 0x1ce739ce},
++	{0x0000a418, 0x2d001dce},
++	{0x0000a41c, 0x1ce739ce},
++	{0x0000a420, 0x000001ce},
++	{0x0000a424, 0x1ce739ce},
++	{0x0000a428, 0x000001ce},
++	{0x0000a42c, 0x1ce739ce},
++	{0x0000a430, 0x1ce739ce},
++	{0x0000a434, 0x00000000},
++	{0x0000a438, 0x00001801},
++	{0x0000a43c, 0x00000000},
++	{0x0000a440, 0x00000000},
++	{0x0000a444, 0x00000000},
++	{0x0000a448, 0x05000096},
++	{0x0000a44c, 0x00000001},
++	{0x0000a450, 0x00010000},
++	{0x0000a454, 0x03000000},
++	{0x0000a458, 0x00000000},
++	{0x0000a644, 0xbfad9d74},
++	{0x0000a648, 0x0048060a},
++	{0x0000a64c, 0x00003c37},
++	{0x0000a670, 0x03020100},
++	{0x0000a674, 0x09080504},
++	{0x0000a678, 0x0d0c0b0a},
++	{0x0000a67c, 0x13121110},
++	{0x0000a680, 0x31301514},
++	{0x0000a684, 0x35343332},
++	{0x0000a688, 0x00000036},
++	{0x0000a690, 0x00000838},
++	{0x0000a6b4, 0x00512c01},
++	{0x0000a7c0, 0x00000000},
++	{0x0000a7c4, 0xfffffffc},
++	{0x0000a7c8, 0x00000000},
++	{0x0000a7cc, 0x00000000},
++	{0x0000a7d0, 0x00000000},
++	{0x0000a7d4, 0x00000004},
++	{0x0000a7dc, 0x00000001},
++	{0x0000a7f0, 0x80000000},
++};
++
++static const u32 ar9565_1p0_baseband_postamble[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8005, 0xd00a800d},
++	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a01ae},
++	{0x00009824, 0x5ac640d0, 0x5ac640d0, 0x5ac640d0, 0x63c640da},
++	{0x00009828, 0x06903081, 0x06903081, 0x06903881, 0x09143c81},
++	{0x0000982c, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4},
++	{0x00009830, 0x0000059c, 0x0000059c, 0x0000059c, 0x0000059c},
++	{0x00009c00, 0x000000c4, 0x000000c4, 0x000000c4, 0x000000c4},
++	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a0},
++	{0x00009e04, 0x00802020, 0x00802020, 0x00802020, 0x00802020},
++	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000d8},
++	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec86d2e},
++	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3379605e, 0x33795d5e},
++	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
++	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
++	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
++	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946222, 0xcf946222},
++	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
++	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
++	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
++	{0x0000a204, 0x033187c0, 0x033187c4, 0x033187c4, 0x033187c0},
++	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
++	{0x0000a22c, 0x01026a2f, 0x01026a27, 0x01026a2f, 0x01026a2f},
++	{0x0000a230, 0x0000400a, 0x00004014, 0x00004016, 0x0000400b},
++	{0x0000a234, 0x00000fff, 0x10000fff, 0x10000fff, 0x00000fff},
++	{0x0000a238, 0xffb81018, 0xffb81018, 0xffb81018, 0xffb81018},
++	{0x0000a250, 0x00000000, 0x00000000, 0x00000210, 0x00000108},
++	{0x0000a254, 0x000007d0, 0x00000fa0, 0x00001130, 0x00000898},
++	{0x0000a258, 0x02020002, 0x02020002, 0x02020002, 0x02020002},
++	{0x0000a25c, 0x01000e0e, 0x01000e0e, 0x01000e0e, 0x01000e0e},
++	{0x0000a260, 0x0a021501, 0x0a021501, 0x3a021501, 0x3a021501},
++	{0x0000a264, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e},
++	{0x0000a280, 0x00000007, 0x00000007, 0x0000000b, 0x0000000b},
++	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
++	{0x0000a288, 0x00100510, 0x00100510, 0x00100510, 0x00100510},
++	{0x0000a28c, 0x00021551, 0x00021551, 0x00021551, 0x00021551},
++	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
++	{0x0000a2d0, 0x00071982, 0x00071982, 0x00071982, 0x00071982},
++	{0x0000a2d8, 0x7999a83a, 0x7999a83a, 0x7999a83a, 0x7999a83a},
++	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000ae04, 0x00800000, 0x00800000, 0x00800000, 0x00800000},
++	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++};
++
++static const u32 ar9565_1p0_radio_core[][2] = {
++	/* Addr      allmodes  */
++	{0x00016000, 0x36db6db6},
++	{0x00016004, 0x6db6db40},
++	{0x00016008, 0x73f00000},
++	{0x0001600c, 0x00000000},
++	{0x00016010, 0x6d823601},
++	{0x00016040, 0x7f80fff8},
++	{0x0001604c, 0x1c99e04f},
++	{0x00016050, 0x6db6db6c},
++	{0x00016058, 0x6c200000},
++	{0x00016080, 0x000c0000},
++	{0x00016084, 0x9a68048c},
++	{0x00016088, 0x54214514},
++	{0x0001608c, 0x1203040b},
++	{0x00016090, 0x24926490},
++	{0x00016098, 0xd28b3330},
++	{0x000160a0, 0x0a108ffe},
++	{0x000160a4, 0x812fc491},
++	{0x000160a8, 0x423c8000},
++	{0x000160b4, 0x92000000},
++	{0x000160b8, 0x0285dddc},
++	{0x000160bc, 0x02908888},
++	{0x000160c0, 0x006db6d0},
++	{0x000160c4, 0x6dd6db60},
++	{0x000160c8, 0x6db6db6c},
++	{0x000160cc, 0x6de6c1b0},
++	{0x00016100, 0x3fffbe04},
++	{0x00016104, 0xfff80000},
++	{0x00016108, 0x00200400},
++	{0x00016110, 0x00000000},
++	{0x00016144, 0x02084080},
++	{0x00016148, 0x000080c0},
++	{0x00016280, 0x050a0001},
++	{0x00016284, 0x3d841400},
++	{0x00016288, 0x00000000},
++	{0x0001628c, 0xe3000000},
++	{0x00016290, 0xa1004080},
++	{0x00016294, 0x40000028},
++	{0x00016298, 0x55aa2900},
++	{0x00016340, 0x131c827a},
++	{0x00016344, 0x00300000},
++};
++
++static const u32 ar9565_1p0_radio_postamble[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x0001609c, 0x0b8ee524, 0x0b8ee524, 0x0b8ee524, 0x0b8ee524},
++	{0x000160ac, 0xa4646c08, 0xa4646c08, 0xa4646c08, 0xa4646c08},
++	{0x000160b0, 0x01d67f70, 0x01d67f70, 0x01d67f70, 0x01d67f70},
++	{0x0001610c, 0x40000000, 0x40000000, 0x40000000, 0x40000000},
++	{0x00016140, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
++};
++
++static const u32 ar9565_1p0_soc_preamble[][2] = {
++	/* Addr      allmodes  */
++	{0x00004078, 0x00000002},
++	{0x000040a4, 0x00a0c9c9},
++	{0x00007020, 0x00000000},
++	{0x00007034, 0x00000002},
++	{0x00007038, 0x000004c2},
++};
++
++static const u32 ar9565_1p0_soc_postamble[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x00007010, 0x00002233, 0x00002233, 0x00002233, 0x00002233},
++};
++
++static const u32 ar9565_1p0_Common_rx_gain_table[][2] = {
++	/* Addr      allmodes  */
++	{0x0000a000, 0x00010000},
++	{0x0000a004, 0x00030002},
++	{0x0000a008, 0x00050004},
++	{0x0000a00c, 0x00810080},
++	{0x0000a010, 0x00830082},
++	{0x0000a014, 0x01810180},
++	{0x0000a018, 0x01830182},
++	{0x0000a01c, 0x01850184},
++	{0x0000a020, 0x01890188},
++	{0x0000a024, 0x018b018a},
++	{0x0000a028, 0x018d018c},
++	{0x0000a02c, 0x01910190},
++	{0x0000a030, 0x01930192},
++	{0x0000a034, 0x01950194},
++	{0x0000a038, 0x038a0196},
++	{0x0000a03c, 0x038c038b},
++	{0x0000a040, 0x0390038d},
++	{0x0000a044, 0x03920391},
++	{0x0000a048, 0x03940393},
++	{0x0000a04c, 0x03960395},
++	{0x0000a050, 0x00000000},
++	{0x0000a054, 0x00000000},
++	{0x0000a058, 0x00000000},
++	{0x0000a05c, 0x00000000},
++	{0x0000a060, 0x00000000},
++	{0x0000a064, 0x00000000},
++	{0x0000a068, 0x00000000},
++	{0x0000a06c, 0x00000000},
++	{0x0000a070, 0x00000000},
++	{0x0000a074, 0x00000000},
++	{0x0000a078, 0x00000000},
++	{0x0000a07c, 0x00000000},
++	{0x0000a080, 0x22222229},
++	{0x0000a084, 0x1d1d1d1d},
++	{0x0000a088, 0x1d1d1d1d},
++	{0x0000a08c, 0x1d1d1d1d},
++	{0x0000a090, 0x171d1d1d},
++	{0x0000a094, 0x11111717},
++	{0x0000a098, 0x00030311},
++	{0x0000a09c, 0x00000000},
++	{0x0000a0a0, 0x00000000},
++	{0x0000a0a4, 0x00000000},
++	{0x0000a0a8, 0x00000000},
++	{0x0000a0ac, 0x00000000},
++	{0x0000a0b0, 0x00000000},
++	{0x0000a0b4, 0x00000000},
++	{0x0000a0b8, 0x00000000},
++	{0x0000a0bc, 0x00000000},
++	{0x0000a0c0, 0x001f0000},
++	{0x0000a0c4, 0x01000101},
++	{0x0000a0c8, 0x011e011f},
++	{0x0000a0cc, 0x011c011d},
++	{0x0000a0d0, 0x02030204},
++	{0x0000a0d4, 0x02010202},
++	{0x0000a0d8, 0x021f0200},
++	{0x0000a0dc, 0x0302021e},
++	{0x0000a0e0, 0x03000301},
++	{0x0000a0e4, 0x031e031f},
++	{0x0000a0e8, 0x0402031d},
++	{0x0000a0ec, 0x04000401},
++	{0x0000a0f0, 0x041e041f},
++	{0x0000a0f4, 0x0502041d},
++	{0x0000a0f8, 0x05000501},
++	{0x0000a0fc, 0x051e051f},
++	{0x0000a100, 0x06010602},
++	{0x0000a104, 0x061f0600},
++	{0x0000a108, 0x061d061e},
++	{0x0000a10c, 0x07020703},
++	{0x0000a110, 0x07000701},
++	{0x0000a114, 0x00000000},
++	{0x0000a118, 0x00000000},
++	{0x0000a11c, 0x00000000},
++	{0x0000a120, 0x00000000},
++	{0x0000a124, 0x00000000},
++	{0x0000a128, 0x00000000},
++	{0x0000a12c, 0x00000000},
++	{0x0000a130, 0x00000000},
++	{0x0000a134, 0x00000000},
++	{0x0000a138, 0x00000000},
++	{0x0000a13c, 0x00000000},
++	{0x0000a140, 0x001f0000},
++	{0x0000a144, 0x01000101},
++	{0x0000a148, 0x011e011f},
++	{0x0000a14c, 0x011c011d},
++	{0x0000a150, 0x02030204},
++	{0x0000a154, 0x02010202},
++	{0x0000a158, 0x021f0200},
++	{0x0000a15c, 0x0302021e},
++	{0x0000a160, 0x03000301},
++	{0x0000a164, 0x031e031f},
++	{0x0000a168, 0x0402031d},
++	{0x0000a16c, 0x04000401},
++	{0x0000a170, 0x041e041f},
++	{0x0000a174, 0x0502041d},
++	{0x0000a178, 0x05000501},
++	{0x0000a17c, 0x051e051f},
++	{0x0000a180, 0x06010602},
++	{0x0000a184, 0x061f0600},
++	{0x0000a188, 0x061d061e},
++	{0x0000a18c, 0x07020703},
++	{0x0000a190, 0x07000701},
++	{0x0000a194, 0x00000000},
++	{0x0000a198, 0x00000000},
++	{0x0000a19c, 0x00000000},
++	{0x0000a1a0, 0x00000000},
++	{0x0000a1a4, 0x00000000},
++	{0x0000a1a8, 0x00000000},
++	{0x0000a1ac, 0x00000000},
++	{0x0000a1b0, 0x00000000},
++	{0x0000a1b4, 0x00000000},
++	{0x0000a1b8, 0x00000000},
++	{0x0000a1bc, 0x00000000},
++	{0x0000a1c0, 0x00000000},
++	{0x0000a1c4, 0x00000000},
++	{0x0000a1c8, 0x00000000},
++	{0x0000a1cc, 0x00000000},
++	{0x0000a1d0, 0x00000000},
++	{0x0000a1d4, 0x00000000},
++	{0x0000a1d8, 0x00000000},
++	{0x0000a1dc, 0x00000000},
++	{0x0000a1e0, 0x00000000},
++	{0x0000a1e4, 0x00000000},
++	{0x0000a1e8, 0x00000000},
++	{0x0000a1ec, 0x00000000},
++	{0x0000a1f0, 0x00000396},
++	{0x0000a1f4, 0x00000396},
++	{0x0000a1f8, 0x00000396},
++	{0x0000a1fc, 0x00000196},
++	{0x0000b000, 0x00010000},
++	{0x0000b004, 0x00030002},
++	{0x0000b008, 0x00050004},
++	{0x0000b00c, 0x00810080},
++	{0x0000b010, 0x00830082},
++	{0x0000b014, 0x01810180},
++	{0x0000b018, 0x01830182},
++	{0x0000b01c, 0x01850184},
++	{0x0000b020, 0x02810280},
++	{0x0000b024, 0x02830282},
++	{0x0000b028, 0x02850284},
++	{0x0000b02c, 0x02890288},
++	{0x0000b030, 0x028b028a},
++	{0x0000b034, 0x0388028c},
++	{0x0000b038, 0x038a0389},
++	{0x0000b03c, 0x038c038b},
++	{0x0000b040, 0x0390038d},
++	{0x0000b044, 0x03920391},
++	{0x0000b048, 0x03940393},
++	{0x0000b04c, 0x03960395},
++	{0x0000b050, 0x00000000},
++	{0x0000b054, 0x00000000},
++	{0x0000b058, 0x00000000},
++	{0x0000b05c, 0x00000000},
++	{0x0000b060, 0x00000000},
++	{0x0000b064, 0x00000000},
++	{0x0000b068, 0x00000000},
++	{0x0000b06c, 0x00000000},
++	{0x0000b070, 0x00000000},
++	{0x0000b074, 0x00000000},
++	{0x0000b078, 0x00000000},
++	{0x0000b07c, 0x00000000},
++	{0x0000b080, 0x32323232},
++	{0x0000b084, 0x2f2f3232},
++	{0x0000b088, 0x23282a2d},
++	{0x0000b08c, 0x1c1e2123},
++	{0x0000b090, 0x14171919},
++	{0x0000b094, 0x0e0e1214},
++	{0x0000b098, 0x03050707},
++	{0x0000b09c, 0x00030303},
++	{0x0000b0a0, 0x00000000},
++	{0x0000b0a4, 0x00000000},
++	{0x0000b0a8, 0x00000000},
++	{0x0000b0ac, 0x00000000},
++	{0x0000b0b0, 0x00000000},
++	{0x0000b0b4, 0x00000000},
++	{0x0000b0b8, 0x00000000},
++	{0x0000b0bc, 0x00000000},
++	{0x0000b0c0, 0x003f0020},
++	{0x0000b0c4, 0x00400041},
++	{0x0000b0c8, 0x0140005f},
++	{0x0000b0cc, 0x0160015f},
++	{0x0000b0d0, 0x017e017f},
++	{0x0000b0d4, 0x02410242},
++	{0x0000b0d8, 0x025f0240},
++	{0x0000b0dc, 0x027f0260},
++	{0x0000b0e0, 0x0341027e},
++	{0x0000b0e4, 0x035f0340},
++	{0x0000b0e8, 0x037f0360},
++	{0x0000b0ec, 0x04400441},
++	{0x0000b0f0, 0x0460045f},
++	{0x0000b0f4, 0x0541047f},
++	{0x0000b0f8, 0x055f0540},
++	{0x0000b0fc, 0x057f0560},
++	{0x0000b100, 0x06400641},
++	{0x0000b104, 0x0660065f},
++	{0x0000b108, 0x067e067f},
++	{0x0000b10c, 0x07410742},
++	{0x0000b110, 0x075f0740},
++	{0x0000b114, 0x077f0760},
++	{0x0000b118, 0x07800781},
++	{0x0000b11c, 0x07a0079f},
++	{0x0000b120, 0x07c107bf},
++	{0x0000b124, 0x000007c0},
++	{0x0000b128, 0x00000000},
++	{0x0000b12c, 0x00000000},
++	{0x0000b130, 0x00000000},
++	{0x0000b134, 0x00000000},
++	{0x0000b138, 0x00000000},
++	{0x0000b13c, 0x00000000},
++	{0x0000b140, 0x003f0020},
++	{0x0000b144, 0x00400041},
++	{0x0000b148, 0x0140005f},
++	{0x0000b14c, 0x0160015f},
++	{0x0000b150, 0x017e017f},
++	{0x0000b154, 0x02410242},
++	{0x0000b158, 0x025f0240},
++	{0x0000b15c, 0x027f0260},
++	{0x0000b160, 0x0341027e},
++	{0x0000b164, 0x035f0340},
++	{0x0000b168, 0x037f0360},
++	{0x0000b16c, 0x04400441},
++	{0x0000b170, 0x0460045f},
++	{0x0000b174, 0x0541047f},
++	{0x0000b178, 0x055f0540},
++	{0x0000b17c, 0x057f0560},
++	{0x0000b180, 0x06400641},
++	{0x0000b184, 0x0660065f},
++	{0x0000b188, 0x067e067f},
++	{0x0000b18c, 0x07410742},
++	{0x0000b190, 0x075f0740},
++	{0x0000b194, 0x077f0760},
++	{0x0000b198, 0x07800781},
++	{0x0000b19c, 0x07a0079f},
++	{0x0000b1a0, 0x07c107bf},
++	{0x0000b1a4, 0x000007c0},
++	{0x0000b1a8, 0x00000000},
++	{0x0000b1ac, 0x00000000},
++	{0x0000b1b0, 0x00000000},
++	{0x0000b1b4, 0x00000000},
++	{0x0000b1b8, 0x00000000},
++	{0x0000b1bc, 0x00000000},
++	{0x0000b1c0, 0x00000000},
++	{0x0000b1c4, 0x00000000},
++	{0x0000b1c8, 0x00000000},
++	{0x0000b1cc, 0x00000000},
++	{0x0000b1d0, 0x00000000},
++	{0x0000b1d4, 0x00000000},
++	{0x0000b1d8, 0x00000000},
++	{0x0000b1dc, 0x00000000},
++	{0x0000b1e0, 0x00000000},
++	{0x0000b1e4, 0x00000000},
++	{0x0000b1e8, 0x00000000},
++	{0x0000b1ec, 0x00000000},
++	{0x0000b1f0, 0x00000396},
++	{0x0000b1f4, 0x00000396},
++	{0x0000b1f8, 0x00000396},
++	{0x0000b1fc, 0x00000196},
++};
++
++static const u32 ar9565_1p0_Modes_lowest_ob_db_tx_gain_table[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x0000a2dc, 0xfc0a9380, 0xfc0a9380, 0xfdab5b52, 0xfdab5b52},
++	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
++	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
++	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
++	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
++	{0x0000a500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a504, 0x06000003, 0x06000003, 0x04000002, 0x04000002},
++	{0x0000a508, 0x0a000020, 0x0a000020, 0x08000004, 0x08000004},
++	{0x0000a50c, 0x10000023, 0x10000023, 0x0b000200, 0x0b000200},
++	{0x0000a510, 0x16000220, 0x16000220, 0x0f000202, 0x0f000202},
++	{0x0000a514, 0x1c000223, 0x1c000223, 0x12000400, 0x12000400},
++	{0x0000a518, 0x21020220, 0x21020220, 0x16000402, 0x16000402},
++	{0x0000a51c, 0x27020223, 0x27020223, 0x19000404, 0x19000404},
++	{0x0000a520, 0x2b022220, 0x2b022220, 0x1c000603, 0x1c000603},
++	{0x0000a524, 0x2f022222, 0x2f022222, 0x21000a02, 0x21000a02},
++	{0x0000a528, 0x34022225, 0x34022225, 0x25000a04, 0x25000a04},
++	{0x0000a52c, 0x3a02222a, 0x3a02222a, 0x28000a20, 0x28000a20},
++	{0x0000a530, 0x3e02222c, 0x3e02222c, 0x2c000e20, 0x2c000e20},
++	{0x0000a534, 0x4202242a, 0x4202242a, 0x30000e22, 0x30000e22},
++	{0x0000a538, 0x4702244a, 0x4702244a, 0x34000e24, 0x34000e24},
++	{0x0000a53c, 0x4b02244c, 0x4b02244c, 0x38001640, 0x38001640},
++	{0x0000a540, 0x4e02246c, 0x4e02246c, 0x3c001660, 0x3c001660},
++	{0x0000a544, 0x5302266c, 0x5302266c, 0x3f001861, 0x3f001861},
++	{0x0000a548, 0x5702286c, 0x5702286c, 0x43001a81, 0x43001a81},
++	{0x0000a54c, 0x5c04286b, 0x5c04286b, 0x47001a83, 0x47001a83},
++	{0x0000a550, 0x61042a6c, 0x61042a6c, 0x4a001c84, 0x4a001c84},
++	{0x0000a554, 0x66062a6c, 0x66062a6c, 0x4e001ce3, 0x4e001ce3},
++	{0x0000a558, 0x6b062e6c, 0x6b062e6c, 0x52001ce5, 0x52001ce5},
++	{0x0000a55c, 0x7006308c, 0x7006308c, 0x56001ce9, 0x56001ce9},
++	{0x0000a560, 0x730a308a, 0x730a308a, 0x5a001ceb, 0x5a001ceb},
++	{0x0000a564, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a568, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a56c, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a570, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a574, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a578, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a57c, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a610, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a614, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a618, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a61c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a620, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a624, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a628, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a62c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a630, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a634, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a638, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a63c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00016044, 0x012482d4, 0x012482d4, 0x012482d4, 0x012482d4},
++	{0x00016048, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++};
++
++static const u32 ar9565_1p0_pciephy_pll_on_clkreq_disable_L1[][2] = {
++	/* Addr      allmodes  */
++	{0x00018c00, 0x18212ede},
++	{0x00018c04, 0x000801d8},
++	{0x00018c08, 0x0003780c},
++};
++
++static const u32 ar9565_1p0_modes_fast_clock[][3] = {
++	/* Addr      5G_HT20     5G_HT40   */
++	{0x00001030, 0x00000268, 0x000004d0},
++	{0x00001070, 0x0000018c, 0x00000318},
++	{0x000010b0, 0x00000fd0, 0x00001fa0},
++	{0x00008014, 0x044c044c, 0x08980898},
++	{0x0000801c, 0x148ec02b, 0x148ec057},
++	{0x00008318, 0x000044c0, 0x00008980},
++	{0x00009e00, 0x03721821, 0x03721821},
++	{0x0000a230, 0x0000400b, 0x00004016},
++	{0x0000a254, 0x00000898, 0x00001130},
++};
++
++static const u32 ar9565_1p0_common_wo_xlna_rx_gain_table[][2] = {
++	/* Addr      allmodes  */
++	{0x0000a000, 0x00010000},
++	{0x0000a004, 0x00030002},
++	{0x0000a008, 0x00050004},
++	{0x0000a00c, 0x00810080},
++	{0x0000a010, 0x00830082},
++	{0x0000a014, 0x01810180},
++	{0x0000a018, 0x01830182},
++	{0x0000a01c, 0x01850184},
++	{0x0000a020, 0x01890188},
++	{0x0000a024, 0x018b018a},
++	{0x0000a028, 0x018d018c},
++	{0x0000a02c, 0x03820190},
++	{0x0000a030, 0x03840383},
++	{0x0000a034, 0x03880385},
++	{0x0000a038, 0x038a0389},
++	{0x0000a03c, 0x038c038b},
++	{0x0000a040, 0x0390038d},
++	{0x0000a044, 0x03920391},
++	{0x0000a048, 0x03940393},
++	{0x0000a04c, 0x03960395},
++	{0x0000a050, 0x00000000},
++	{0x0000a054, 0x00000000},
++	{0x0000a058, 0x00000000},
++	{0x0000a05c, 0x00000000},
++	{0x0000a060, 0x00000000},
++	{0x0000a064, 0x00000000},
++	{0x0000a068, 0x00000000},
++	{0x0000a06c, 0x00000000},
++	{0x0000a070, 0x00000000},
++	{0x0000a074, 0x00000000},
++	{0x0000a078, 0x00000000},
++	{0x0000a07c, 0x00000000},
++	{0x0000a080, 0x29292929},
++	{0x0000a084, 0x29292929},
++	{0x0000a088, 0x29292929},
++	{0x0000a08c, 0x29292929},
++	{0x0000a090, 0x22292929},
++	{0x0000a094, 0x1d1d2222},
++	{0x0000a098, 0x0c111117},
++	{0x0000a09c, 0x00030303},
++	{0x0000a0a0, 0x00000000},
++	{0x0000a0a4, 0x00000000},
++	{0x0000a0a8, 0x00000000},
++	{0x0000a0ac, 0x00000000},
++	{0x0000a0b0, 0x00000000},
++	{0x0000a0b4, 0x00000000},
++	{0x0000a0b8, 0x00000000},
++	{0x0000a0bc, 0x00000000},
++	{0x0000a0c0, 0x301f3000},
++	{0x0000a0c4, 0x41004101},
++	{0x0000a0c8, 0x411e411f},
++	{0x0000a0cc, 0x411c411d},
++	{0x0000a0d0, 0x42434244},
++	{0x0000a0d4, 0x42414242},
++	{0x0000a0d8, 0x425f4240},
++	{0x0000a0dc, 0x5342425e},
++	{0x0000a0e0, 0x53405341},
++	{0x0000a0e4, 0x535e535f},
++	{0x0000a0e8, 0x7402535d},
++	{0x0000a0ec, 0x74007401},
++	{0x0000a0f0, 0x741e741f},
++	{0x0000a0f4, 0x7522741d},
++	{0x0000a0f8, 0x75207521},
++	{0x0000a0fc, 0x753e753f},
++	{0x0000a100, 0x76617662},
++	{0x0000a104, 0x767f7660},
++	{0x0000a108, 0x767d767e},
++	{0x0000a10c, 0x77e277e3},
++	{0x0000a110, 0x77e077e1},
++	{0x0000a114, 0x00000000},
++	{0x0000a118, 0x00000000},
++	{0x0000a11c, 0x00000000},
++	{0x0000a120, 0x00000000},
++	{0x0000a124, 0x00000000},
++	{0x0000a128, 0x00000000},
++	{0x0000a12c, 0x00000000},
++	{0x0000a130, 0x00000000},
++	{0x0000a134, 0x00000000},
++	{0x0000a138, 0x00000000},
++	{0x0000a13c, 0x00000000},
++	{0x0000a140, 0x301f3000},
++	{0x0000a144, 0x41004101},
++	{0x0000a148, 0x411e411f},
++	{0x0000a14c, 0x411c411d},
++	{0x0000a150, 0x42434244},
++	{0x0000a154, 0x42414242},
++	{0x0000a158, 0x425f4240},
++	{0x0000a15c, 0x5342425e},
++	{0x0000a160, 0x53405341},
++	{0x0000a164, 0x535e535f},
++	{0x0000a168, 0x7402535d},
++	{0x0000a16c, 0x74007401},
++	{0x0000a170, 0x741e741f},
++	{0x0000a174, 0x7522741d},
++	{0x0000a178, 0x75207521},
++	{0x0000a17c, 0x753e753f},
++	{0x0000a180, 0x76617662},
++	{0x0000a184, 0x767f7660},
++	{0x0000a188, 0x767d767e},
++	{0x0000a18c, 0x77e277e3},
++	{0x0000a190, 0x77e077e1},
++	{0x0000a194, 0x00000000},
++	{0x0000a198, 0x00000000},
++	{0x0000a19c, 0x00000000},
++	{0x0000a1a0, 0x00000000},
++	{0x0000a1a4, 0x00000000},
++	{0x0000a1a8, 0x00000000},
++	{0x0000a1ac, 0x00000000},
++	{0x0000a1b0, 0x00000000},
++	{0x0000a1b4, 0x00000000},
++	{0x0000a1b8, 0x00000000},
++	{0x0000a1bc, 0x00000000},
++	{0x0000a1c0, 0x00000000},
++	{0x0000a1c4, 0x00000000},
++	{0x0000a1c8, 0x00000000},
++	{0x0000a1cc, 0x00000000},
++	{0x0000a1d0, 0x00000000},
++	{0x0000a1d4, 0x00000000},
++	{0x0000a1d8, 0x00000000},
++	{0x0000a1dc, 0x00000000},
++	{0x0000a1e0, 0x00000000},
++	{0x0000a1e4, 0x00000000},
++	{0x0000a1e8, 0x00000000},
++	{0x0000a1ec, 0x00000000},
++	{0x0000a1f0, 0x00000396},
++	{0x0000a1f4, 0x00000396},
++	{0x0000a1f8, 0x00000396},
++	{0x0000a1fc, 0x00000196},
++	{0x0000b000, 0x00010000},
++	{0x0000b004, 0x00030002},
++	{0x0000b008, 0x00050004},
++	{0x0000b00c, 0x00810080},
++	{0x0000b010, 0x00830082},
++	{0x0000b014, 0x01810180},
++	{0x0000b018, 0x01830182},
++	{0x0000b01c, 0x01850184},
++	{0x0000b020, 0x02810280},
++	{0x0000b024, 0x02830282},
++	{0x0000b028, 0x02850284},
++	{0x0000b02c, 0x02890288},
++	{0x0000b030, 0x028b028a},
++	{0x0000b034, 0x0388028c},
++	{0x0000b038, 0x038a0389},
++	{0x0000b03c, 0x038c038b},
++	{0x0000b040, 0x0390038d},
++	{0x0000b044, 0x03920391},
++	{0x0000b048, 0x03940393},
++	{0x0000b04c, 0x03960395},
++	{0x0000b050, 0x00000000},
++	{0x0000b054, 0x00000000},
++	{0x0000b058, 0x00000000},
++	{0x0000b05c, 0x00000000},
++	{0x0000b060, 0x00000000},
++	{0x0000b064, 0x00000000},
++	{0x0000b068, 0x00000000},
++	{0x0000b06c, 0x00000000},
++	{0x0000b070, 0x00000000},
++	{0x0000b074, 0x00000000},
++	{0x0000b078, 0x00000000},
++	{0x0000b07c, 0x00000000},
++	{0x0000b080, 0x32323232},
++	{0x0000b084, 0x2f2f3232},
++	{0x0000b088, 0x23282a2d},
++	{0x0000b08c, 0x1c1e2123},
++	{0x0000b090, 0x14171919},
++	{0x0000b094, 0x0e0e1214},
++	{0x0000b098, 0x03050707},
++	{0x0000b09c, 0x00030303},
++	{0x0000b0a0, 0x00000000},
++	{0x0000b0a4, 0x00000000},
++	{0x0000b0a8, 0x00000000},
++	{0x0000b0ac, 0x00000000},
++	{0x0000b0b0, 0x00000000},
++	{0x0000b0b4, 0x00000000},
++	{0x0000b0b8, 0x00000000},
++	{0x0000b0bc, 0x00000000},
++	{0x0000b0c0, 0x003f0020},
++	{0x0000b0c4, 0x00400041},
++	{0x0000b0c8, 0x0140005f},
++	{0x0000b0cc, 0x0160015f},
++	{0x0000b0d0, 0x017e017f},
++	{0x0000b0d4, 0x02410242},
++	{0x0000b0d8, 0x025f0240},
++	{0x0000b0dc, 0x027f0260},
++	{0x0000b0e0, 0x0341027e},
++	{0x0000b0e4, 0x035f0340},
++	{0x0000b0e8, 0x037f0360},
++	{0x0000b0ec, 0x04400441},
++	{0x0000b0f0, 0x0460045f},
++	{0x0000b0f4, 0x0541047f},
++	{0x0000b0f8, 0x055f0540},
++	{0x0000b0fc, 0x057f0560},
++	{0x0000b100, 0x06400641},
++	{0x0000b104, 0x0660065f},
++	{0x0000b108, 0x067e067f},
++	{0x0000b10c, 0x07410742},
++	{0x0000b110, 0x075f0740},
++	{0x0000b114, 0x077f0760},
++	{0x0000b118, 0x07800781},
++	{0x0000b11c, 0x07a0079f},
++	{0x0000b120, 0x07c107bf},
++	{0x0000b124, 0x000007c0},
++	{0x0000b128, 0x00000000},
++	{0x0000b12c, 0x00000000},
++	{0x0000b130, 0x00000000},
++	{0x0000b134, 0x00000000},
++	{0x0000b138, 0x00000000},
++	{0x0000b13c, 0x00000000},
++	{0x0000b140, 0x003f0020},
++	{0x0000b144, 0x00400041},
++	{0x0000b148, 0x0140005f},
++	{0x0000b14c, 0x0160015f},
++	{0x0000b150, 0x017e017f},
++	{0x0000b154, 0x02410242},
++	{0x0000b158, 0x025f0240},
++	{0x0000b15c, 0x027f0260},
++	{0x0000b160, 0x0341027e},
++	{0x0000b164, 0x035f0340},
++	{0x0000b168, 0x037f0360},
++	{0x0000b16c, 0x04400441},
++	{0x0000b170, 0x0460045f},
++	{0x0000b174, 0x0541047f},
++	{0x0000b178, 0x055f0540},
++	{0x0000b17c, 0x057f0560},
++	{0x0000b180, 0x06400641},
++	{0x0000b184, 0x0660065f},
++	{0x0000b188, 0x067e067f},
++	{0x0000b18c, 0x07410742},
++	{0x0000b190, 0x075f0740},
++	{0x0000b194, 0x077f0760},
++	{0x0000b198, 0x07800781},
++	{0x0000b19c, 0x07a0079f},
++	{0x0000b1a0, 0x07c107bf},
++	{0x0000b1a4, 0x000007c0},
++	{0x0000b1a8, 0x00000000},
++	{0x0000b1ac, 0x00000000},
++	{0x0000b1b0, 0x00000000},
++	{0x0000b1b4, 0x00000000},
++	{0x0000b1b8, 0x00000000},
++	{0x0000b1bc, 0x00000000},
++	{0x0000b1c0, 0x00000000},
++	{0x0000b1c4, 0x00000000},
++	{0x0000b1c8, 0x00000000},
++	{0x0000b1cc, 0x00000000},
++	{0x0000b1d0, 0x00000000},
++	{0x0000b1d4, 0x00000000},
++	{0x0000b1d8, 0x00000000},
++	{0x0000b1dc, 0x00000000},
++	{0x0000b1e0, 0x00000000},
++	{0x0000b1e4, 0x00000000},
++	{0x0000b1e8, 0x00000000},
++	{0x0000b1ec, 0x00000000},
++	{0x0000b1f0, 0x00000396},
++	{0x0000b1f4, 0x00000396},
++	{0x0000b1f8, 0x00000396},
++	{0x0000b1fc, 0x00000196},
++};
++
++static const u32 ar9565_1p0_modes_low_ob_db_tx_gain_table[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x0000a2dc, 0xfc0a9380, 0xfc0a9380, 0xfdab5b52, 0xfdab5b52},
++	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
++	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
++	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
++	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
++	{0x0000a500, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a504, 0x06000003, 0x06000003, 0x04000002, 0x04000002},
++	{0x0000a508, 0x0a000020, 0x0a000020, 0x08000004, 0x08000004},
++	{0x0000a50c, 0x10000023, 0x10000023, 0x0b000200, 0x0b000200},
++	{0x0000a510, 0x16000220, 0x16000220, 0x0f000202, 0x0f000202},
++	{0x0000a514, 0x1c000223, 0x1c000223, 0x12000400, 0x12000400},
++	{0x0000a518, 0x21020220, 0x21020220, 0x16000402, 0x16000402},
++	{0x0000a51c, 0x27020223, 0x27020223, 0x19000404, 0x19000404},
++	{0x0000a520, 0x2b022220, 0x2b022220, 0x1c000603, 0x1c000603},
++	{0x0000a524, 0x2f022222, 0x2f022222, 0x21000a02, 0x21000a02},
++	{0x0000a528, 0x34022225, 0x34022225, 0x25000a04, 0x25000a04},
++	{0x0000a52c, 0x3a02222a, 0x3a02222a, 0x28000a20, 0x28000a20},
++	{0x0000a530, 0x3e02222c, 0x3e02222c, 0x2c000e20, 0x2c000e20},
++	{0x0000a534, 0x4202242a, 0x4202242a, 0x30000e22, 0x30000e22},
++	{0x0000a538, 0x4702244a, 0x4702244a, 0x34000e24, 0x34000e24},
++	{0x0000a53c, 0x4b02244c, 0x4b02244c, 0x38001640, 0x38001640},
++	{0x0000a540, 0x4e02246c, 0x4e02246c, 0x3c001660, 0x3c001660},
++	{0x0000a544, 0x5302266c, 0x5302266c, 0x3f001861, 0x3f001861},
++	{0x0000a548, 0x5702286c, 0x5702286c, 0x43001a81, 0x43001a81},
++	{0x0000a54c, 0x5c04286b, 0x5c04286b, 0x47001a83, 0x47001a83},
++	{0x0000a550, 0x61042a6c, 0x61042a6c, 0x4a001c84, 0x4a001c84},
++	{0x0000a554, 0x66062a6c, 0x66062a6c, 0x4e001ce3, 0x4e001ce3},
++	{0x0000a558, 0x6b062e6c, 0x6b062e6c, 0x52001ce5, 0x52001ce5},
++	{0x0000a55c, 0x7006308c, 0x7006308c, 0x56001ce9, 0x56001ce9},
++	{0x0000a560, 0x730a308a, 0x730a308a, 0x5a001ceb, 0x5a001ceb},
++	{0x0000a564, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a568, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a56c, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a570, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a574, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a578, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a57c, 0x770a308c, 0x770a308c, 0x5d001eec, 0x5d001eec},
++	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a610, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a614, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a618, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a61c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a620, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a624, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a628, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a62c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a630, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a634, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a638, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a63c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00016044, 0x012482d4, 0x012482d4, 0x012482d4, 0x012482d4},
++	{0x00016048, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++};
++
++static const u32 ar9565_1p0_modes_high_ob_db_tx_gain_table[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x0000a2dc, 0xfc0a9380, 0xfc0a9380, 0xfdab5b52, 0xfdab5b52},
++	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
++	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
++	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
++	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
++	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
++	{0x0000a504, 0x06002223, 0x06002223, 0x04000002, 0x04000002},
++	{0x0000a508, 0x0b022220, 0x0b022220, 0x08000004, 0x08000004},
++	{0x0000a50c, 0x10022223, 0x10022223, 0x0c000200, 0x0c000200},
++	{0x0000a510, 0x15022620, 0x15022620, 0x10000202, 0x10000202},
++	{0x0000a514, 0x19022622, 0x19022622, 0x13000400, 0x13000400},
++	{0x0000a518, 0x1c022822, 0x1c022822, 0x17000402, 0x17000402},
++	{0x0000a51c, 0x21022842, 0x21022842, 0x1b000404, 0x1b000404},
++	{0x0000a520, 0x24022c41, 0x24022c41, 0x1e000603, 0x1e000603},
++	{0x0000a524, 0x29023042, 0x29023042, 0x23000a02, 0x23000a02},
++	{0x0000a528, 0x2d023044, 0x2d023044, 0x27000a04, 0x27000a04},
++	{0x0000a52c, 0x31023644, 0x31023644, 0x2a000a20, 0x2a000a20},
++	{0x0000a530, 0x36025643, 0x36025643, 0x2e000e20, 0x2e000e20},
++	{0x0000a534, 0x3a025a44, 0x3a025a44, 0x32000e22, 0x32000e22},
++	{0x0000a538, 0x3d025e45, 0x3d025e45, 0x36000e24, 0x36000e24},
++	{0x0000a53c, 0x43025e4a, 0x43025e4a, 0x3a001640, 0x3a001640},
++	{0x0000a540, 0x4a025e6c, 0x4a025e6c, 0x3e001660, 0x3e001660},
++	{0x0000a544, 0x50025e8e, 0x50025e8e, 0x41001861, 0x41001861},
++	{0x0000a548, 0x56025eb2, 0x56025eb2, 0x45001a81, 0x45001a81},
++	{0x0000a54c, 0x5c025eb5, 0x5c025eb5, 0x49001a83, 0x49001a83},
++	{0x0000a550, 0x62025ef6, 0x62025ef6, 0x4c001c84, 0x4c001c84},
++	{0x0000a554, 0x65025f56, 0x65025f56, 0x4f001ce3, 0x4f001ce3},
++	{0x0000a558, 0x69027f56, 0x69027f56, 0x53001ce5, 0x53001ce5},
++	{0x0000a55c, 0x6d029f56, 0x6d029f56, 0x57001ce9, 0x57001ce9},
++	{0x0000a560, 0x73049f56, 0x73049f56, 0x5b001ceb, 0x5b001ceb},
++	{0x0000a564, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a568, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a56c, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a570, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a574, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a578, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a57c, 0x7804ff56, 0x7804ff56, 0x5d001eec, 0x5d001eec},
++	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a60c, 0x00804000, 0x00804000, 0x00000000, 0x00000000},
++	{0x0000a610, 0x00804201, 0x00804201, 0x00000000, 0x00000000},
++	{0x0000a614, 0x00804201, 0x00804201, 0x01404000, 0x01404000},
++	{0x0000a618, 0x00804201, 0x00804201, 0x01404501, 0x01404501},
++	{0x0000a61c, 0x02008201, 0x02008201, 0x02008501, 0x02008501},
++	{0x0000a620, 0x02c10a03, 0x02c10a03, 0x0280ca03, 0x0280ca03},
++	{0x0000a624, 0x04815205, 0x04815205, 0x02c10b04, 0x02c10b04},
++	{0x0000a628, 0x0581d406, 0x0581d406, 0x03814b04, 0x03814b04},
++	{0x0000a62c, 0x0581d607, 0x0581d607, 0x05018e05, 0x05018e05},
++	{0x0000a630, 0x0581d607, 0x0581d607, 0x05019406, 0x05019406},
++	{0x0000a634, 0x0581d607, 0x0581d607, 0x05019406, 0x05019406},
++	{0x0000a638, 0x0581d607, 0x0581d607, 0x05019406, 0x05019406},
++	{0x0000a63c, 0x0581d607, 0x0581d607, 0x05019406, 0x05019406},
++	{0x00016044, 0x056d82e4, 0x056d82e4, 0x056d82e4, 0x056d82e4},
++	{0x00016048, 0x8db49060, 0x8db49060, 0x8db49060, 0x8db49060},
++	{0x00016054, 0x6db60000, 0x6db60000, 0x6db60000, 0x6db60000},
++};
++
++static const u32 ar9565_1p0_modes_high_power_tx_gain_table[][5] = {
++	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
++	{0x0000a2dc, 0xfc0a9380, 0xfc0a9380, 0xfdab5b52, 0xfdab5b52},
++	{0x0000a2e0, 0xffecec00, 0xffecec00, 0xfd339c84, 0xfd339c84},
++	{0x0000a2e4, 0xfc0f0000, 0xfc0f0000, 0xfec3e000, 0xfec3e000},
++	{0x0000a2e8, 0xfc100000, 0xfc100000, 0xfffc0000, 0xfffc0000},
++	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
++	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
++	{0x0000a504, 0x06002223, 0x06002223, 0x04000002, 0x04000002},
++	{0x0000a508, 0x0a022220, 0x0a022220, 0x08000004, 0x08000004},
++	{0x0000a50c, 0x0f022223, 0x0f022223, 0x0b000200, 0x0b000200},
++	{0x0000a510, 0x14022620, 0x14022620, 0x0f000202, 0x0f000202},
++	{0x0000a514, 0x18022622, 0x18022622, 0x11000400, 0x11000400},
++	{0x0000a518, 0x1b022822, 0x1b022822, 0x15000402, 0x15000402},
++	{0x0000a51c, 0x20022842, 0x20022842, 0x19000404, 0x19000404},
++	{0x0000a520, 0x22022c41, 0x22022c41, 0x1b000603, 0x1b000603},
++	{0x0000a524, 0x28023042, 0x28023042, 0x1f000a02, 0x1f000a02},
++	{0x0000a528, 0x2c023044, 0x2c023044, 0x23000a04, 0x23000a04},
++	{0x0000a52c, 0x2f023644, 0x2f023644, 0x26000a20, 0x26000a20},
++	{0x0000a530, 0x34025643, 0x34025643, 0x2a000e20, 0x2a000e20},
++	{0x0000a534, 0x38025a44, 0x38025a44, 0x2e000e22, 0x2e000e22},
++	{0x0000a538, 0x3b025e45, 0x3b025e45, 0x31000e24, 0x31000e24},
++	{0x0000a53c, 0x41025e4a, 0x41025e4a, 0x34001640, 0x34001640},
++	{0x0000a540, 0x48025e6c, 0x48025e6c, 0x38001660, 0x38001660},
++	{0x0000a544, 0x4e025e8e, 0x4e025e8e, 0x3b001861, 0x3b001861},
++	{0x0000a548, 0x53025eb2, 0x53025eb2, 0x3e001a81, 0x3e001a81},
++	{0x0000a54c, 0x59025eb5, 0x59025eb5, 0x42001a83, 0x42001a83},
++	{0x0000a550, 0x5f025ef6, 0x5f025ef6, 0x44001c84, 0x44001c84},
++	{0x0000a554, 0x62025f56, 0x62025f56, 0x48001ce3, 0x48001ce3},
++	{0x0000a558, 0x66027f56, 0x66027f56, 0x4c001ce5, 0x4c001ce5},
++	{0x0000a55c, 0x6a029f56, 0x6a029f56, 0x50001ce9, 0x50001ce9},
++	{0x0000a560, 0x70049f56, 0x70049f56, 0x54001ceb, 0x54001ceb},
++	{0x0000a564, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a568, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a56c, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a570, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a574, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a578, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a57c, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
++	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a610, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a614, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a618, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a61c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a620, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a624, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a628, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a62c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a630, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a634, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a638, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x0000a63c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00016044, 0x056d82e6, 0x056d82e6, 0x056d82e6, 0x056d82e6},
++	{0x00016048, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++	{0x00016054, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
++};
++
++#endif /* INITVALS_9565_1P0_H */
diff --git a/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch b/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
new file mode 100644
index 0000000..50b0f1b
--- /dev/null
+++ b/linux-next-cherry-picks/0047-ath9k_hw-Add-AR9565-HW-support.patch
@@ -0,0 +1,269 @@
+From a4a2954ff49e72ce3fa1f78a156b2492a023c89d Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Mon, 10 Sep 2012 09:20:03 +0530
+Subject: [PATCH] ath9k_hw: Add AR9565 HW support
+
+Various parts of the code require AR9565 checks,
+this patch adds them.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ani.c           |  2 +-
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++++-----
+ drivers/net/wireless/ath/ath9k/ar9003_mac.c    |  2 +-
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 10 +++++-----
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 14 +++++++-------
+ drivers/net/wireless/ath/ath9k/eeprom.h        |  2 +-
+ drivers/net/wireless/ath/ath9k/hw.c            | 20 +++++++++++---------
+ 7 files changed, 31 insertions(+), 29 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ani.c
++++ b/drivers/net/wireless/ath/ath9k/ani.c
+@@ -237,7 +237,7 @@ static void ath9k_hw_set_cck_nil(struct
+ 				     entry_cck->fir_step_level);
+ 
+ 	/* Skip MRC CCK for pre AR9003 families */
+-	if (!AR_SREV_9300_20_OR_LATER(ah) || AR_SREV_9485(ah))
++	if (!AR_SREV_9300_20_OR_LATER(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah))
+ 		return;
+ 
+ 	if (aniState->mrcCCK != entry_cck->mrc_cck_on)
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3520,7 +3520,7 @@ static void ar9003_hw_xpa_bias_level_app
+ 
+ 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
+ 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
+-	else if (AR_SREV_9462(ah) || AR_SREV_9550(ah))
++	else if (AR_SREV_9462(ah) || AR_SREV_9550(ah) || AR_SREV_9565(ah))
+ 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
+ 	else {
+ 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
+@@ -3568,7 +3568,7 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 
+ 	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
+ 				AR_SWITCH_TABLE_COM_AR9462_ALL, value);
+ 	} else if (AR_SREV_9550(ah)) {
+@@ -3612,7 +3612,7 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 		}
+ 	}
+ 
+-	if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
++	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
+ 		value = ath9k_hw_ar9300_get_eeprom(ah, EEP_ANT_DIV_CTL1);
+ 		/*
+ 		 * main_lnaconf, alt_lnaconf, main_tb, alt_tb
+@@ -3843,7 +3843,7 @@ void ar9003_hw_internal_regulator_apply(
+ 			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
+ 			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
+ 				return;
+-		} else if (AR_SREV_9462(ah)) {
++		} else if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 			reg_val = le32_to_cpu(pBase->swreg);
+ 			REG_WRITE(ah, AR_PHY_PMU1, reg_val);
+ 		} else {
+@@ -3874,7 +3874,7 @@ void ar9003_hw_internal_regulator_apply(
+ 			while (!REG_READ_FIELD(ah, AR_PHY_PMU2,
+ 						AR_PHY_PMU2_PGM))
+ 				udelay(10);
+-		} else if (AR_SREV_9462(ah))
++		} else if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+ 			REG_RMW_FIELD(ah, AR_PHY_PMU1, AR_PHY_PMU1_PWD, 0x1);
+ 		else {
+ 			reg_val = REG_READ(ah, AR_RTC_SLEEP_CLK) |
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+@@ -31,7 +31,7 @@ ar9003_set_txdesc(struct ath_hw *ah, voi
+ 	u32 val, ctl12, ctl17;
+ 	u8 desc_len;
+ 
+-	desc_len = (AR_SREV_9462(ah) ? 0x18 : 0x17);
++	desc_len = ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x18 : 0x17);
+ 
+ 	val = (ATHEROS_VENDOR_ID << AR_DescId_S) |
+ 	      (1 << AR_TxRxDesc_S) |
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -88,7 +88,7 @@ static int ar9003_hw_set_channel(struct
+ 			channelSel = (freq * 4) / div;
+ 			chan_frac = (((freq * 4) % div) * 0x20000) / div;
+ 			channelSel = (channelSel << 17) | chan_frac;
+-		} else if (AR_SREV_9485(ah)) {
++		} else if (AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
+ 			u32 chan_frac;
+ 
+ 			/*
+@@ -736,7 +736,7 @@ static int ar9003_hw_process_ini(struct
+ 	if (chan->channel == 2484)
+ 		ar9003_hw_prog_ini(ah, &ah->ini_japan2484, 1);
+ 
+-	if (AR_SREV_9462(ah))
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+ 		REG_WRITE(ah, AR_GLB_SWREG_DISCONT_MODE,
+ 			  AR_GLB_SWREG_DISCONT_EN_BT_WLAN);
+ 
+@@ -746,9 +746,9 @@ static int ar9003_hw_process_ini(struct
+ 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+ 	ath9k_hw_apply_txpower(ah, chan, false);
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+-				AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL))
++				   AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL))
+ 			ah->enabled_cals |= TX_IQ_CAL;
+ 		else
+ 			ah->enabled_cals &= ~TX_IQ_CAL;
+@@ -1111,7 +1111,7 @@ static void ar9003_hw_set_nf_limits(stru
+ 	if (AR_SREV_9330(ah))
+ 		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9330_2GHZ;
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9462_2GHZ;
+ 		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9462_2GHZ;
+ 		ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ;
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -632,8 +632,8 @@
+ #define AR_PHY_AIC_STAT_2_B0	(AR_SM_BASE + 0x4cc)
+ 
+ #define AR_PHY_65NM_CH0_SYNTH4      0x1608c
+-#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   (AR_SREV_9462(ah) ? 0x00000001 : 0x00000002)
+-#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT_S (AR_SREV_9462(ah) ? 0 : 1)
++#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x00000001 : 0x00000002)
++#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT_S ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0 : 1)
+ #define AR_PHY_65NM_CH0_SYNTH7      0x16098
+ #define AR_PHY_65NM_CH0_BIAS1       0x160c0
+ #define AR_PHY_65NM_CH0_BIAS2       0x160c4
+@@ -643,7 +643,7 @@
+ #define AR_PHY_65NM_CH2_RXTX4       0x1690c
+ 
+ #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
+-				((AR_SREV_9462(ah) ? 0x1628c : 0x16280)))
++			 (((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x1628c : 0x16280)))
+ #define AR_CH0_TOP_XPABIASLVL (AR_SREV_9550(ah) ? 0x3c0 : 0x300)
+ #define AR_CH0_TOP_XPABIASLVL_S (AR_SREV_9550(ah) ? 6 : 8)
+ 
+@@ -671,7 +671,7 @@
+ #define AR_SWITCH_TABLE_ALL_S (0)
+ 
+ #define AR_PHY_65NM_CH0_THERM       (AR_SREV_9300(ah) ? 0x16290 :\
+-					(AR_SREV_9462(ah) ? 0x16294 : 0x1628c))
++				     ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16294 : 0x1628c))
+ 
+ #define AR_PHY_65NM_CH0_THERM_LOCAL   0x80000000
+ #define AR_PHY_65NM_CH0_THERM_LOCAL_S 31
+@@ -693,17 +693,17 @@
+ #define AR_CH0_TOP2_XPABIASLVL_S	12
+ 
+ #define AR_CH0_XTAL		(AR_SREV_9300(ah) ? 0x16294 : \
+-					(AR_SREV_9462(ah) ? 0x16298 : 0x16290))
++				 ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16298 : 0x16290))
+ #define AR_CH0_XTAL_CAPINDAC	0x7f000000
+ #define AR_CH0_XTAL_CAPINDAC_S	24
+ #define AR_CH0_XTAL_CAPOUTDAC	0x00fe0000
+ #define AR_CH0_XTAL_CAPOUTDAC_S	17
+ 
+-#define AR_PHY_PMU1		(AR_SREV_9462(ah) ? 0x16340 : 0x16c40)
++#define AR_PHY_PMU1		((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16340 : 0x16c40)
+ #define AR_PHY_PMU1_PWD		0x1
+ #define AR_PHY_PMU1_PWD_S	0
+ 
+-#define AR_PHY_PMU2		(AR_SREV_9462(ah) ? 0x16344 : 0x16c44)
++#define AR_PHY_PMU2		((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16344 : 0x16c44)
+ #define AR_PHY_PMU2_PGM		0x00200000
+ #define AR_PHY_PMU2_PGM_S	21
+ 
+--- a/drivers/net/wireless/ath/ath9k/eeprom.h
++++ b/drivers/net/wireless/ath/ath9k/eeprom.h
+@@ -108,7 +108,7 @@
+ #define EEP_RFSILENT_ENABLED_S      0
+ #define EEP_RFSILENT_POLARITY       0x0002
+ #define EEP_RFSILENT_POLARITY_S     1
+-#define EEP_RFSILENT_GPIO_SEL       (AR_SREV_9462(ah) ? 0x00fc : 0x001c)
++#define EEP_RFSILENT_GPIO_SEL       ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x00fc : 0x001c)
+ #define EEP_RFSILENT_GPIO_SEL_S     2
+ 
+ #define AR5416_OPFLAGS_11A           0x01
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -605,6 +605,11 @@ static int __ath9k_hw_init(struct ath_hw
+ 	if (AR_SREV_9462(ah))
+ 		ah->WARegVal &= ~AR_WA_D3_L1_DISABLE;
+ 
++	if (AR_SREV_9565(ah)) {
++		ah->WARegVal |= AR_WA_BIT22;
++		REG_WRITE(ah, AR_WA, ah->WARegVal);
++	}
++
+ 	ath9k_hw_init_defaults(ah);
+ 	ath9k_hw_init_config(ah);
+ 
+@@ -805,8 +810,7 @@ static void ath9k_hw_init_pll(struct ath
+ {
+ 	u32 pll;
+ 
+-	if (AR_SREV_9485(ah)) {
+-
++	if (AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
+ 		/* program BB PLL ki and kd value, ki=0x4, kd=0x40 */
+ 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+ 			      AR_CH0_BB_DPLL2_PLL_PWD, 0x1);
+@@ -2037,7 +2041,7 @@ static void ath9k_set_power_sleep(struct
+ {
+ 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		REG_CLR_BIT(ah, AR_TIMER_MODE, 0xff);
+ 		REG_CLR_BIT(ah, AR_NDP2_TIMER_MODE, 0xff);
+ 		REG_CLR_BIT(ah, AR_SLP32_INC, 0xfffff);
+@@ -2492,7 +2496,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+ 
+ 	if (AR_SREV_9300_20_OR_LATER(ah)) {
+ 		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_FASTCLOCK;
+-		if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah))
++		if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah) && !AR_SREV_9565(ah))
+ 			pCap->hw_caps |= ATH9K_HW_CAP_LDPC;
+ 
+ 		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
+@@ -2574,14 +2578,12 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+ 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
+ 	}
+ 
+-	if (AR_SREV_9462(ah)) {
+-
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		if (!(ah->ent_mode & AR_ENT_OTP_49GHZ_DISABLE))
+ 			pCap->hw_caps |= ATH9K_HW_CAP_MCI;
+ 
+ 		if (AR_SREV_9462_20(ah))
+ 			pCap->hw_caps |= ATH9K_HW_CAP_RTT;
+-
+ 	}
+ 
+ 
+@@ -2747,7 +2749,7 @@ void ath9k_hw_setrxfilter(struct ath_hw
+ 
+ 	ENABLE_REGWRITE_BUFFER(ah);
+ 
+-	if (AR_SREV_9462(ah))
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+ 		bits |= ATH9K_RX_FILTER_CONTROL_WRAPPER;
+ 
+ 	REG_WRITE(ah, AR_RX_FILTER, bits);
+@@ -3044,7 +3046,7 @@ void ath9k_hw_gen_timer_start(struct ath
+ 	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
+ 		    gen_tmr_configuration[timer->index].mode_mask);
+ 
+-	if (AR_SREV_9462(ah)) {
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+ 		/*
+ 		 * Starting from AR9462, each generic timer can select which tsf
+ 		 * to use. But we still follow the old rule, 0 - 7 use tsf and
diff --git a/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch b/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
new file mode 100644
index 0000000..705b258
--- /dev/null
+++ b/linux-next-cherry-picks/0048-ath9k-Set-correct-max-streams-for-AR9565.patch
@@ -0,0 +1,39 @@
+From e41db61d55fa58de9854c1d4932ea255f448d4b8 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Mon, 10 Sep 2012 09:20:12 +0530
+Subject: [PATCH] ath9k: Set correct max streams for AR9565
+
+Also, set the correct chainmask.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c   | 5 ++++-
+ drivers/net/wireless/ath/ath9k/init.c | 2 +-
+ 2 files changed, 5 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -2408,7 +2408,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+ 	if (eeval & AR5416_OPFLAGS_11G)
+ 		pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
+ 
+-	if (AR_SREV_9485(ah) || AR_SREV_9285(ah) || AR_SREV_9330(ah))
++	if (AR_SREV_9485(ah) ||
++	    AR_SREV_9285(ah) ||
++	    AR_SREV_9330(ah) ||
++	    AR_SREV_9565(ah))
+ 		chip_chainmask = 1;
+ 	else if (AR_SREV_9462(ah))
+ 		chip_chainmask = 3;
+--- a/drivers/net/wireless/ath/ath9k/init.c
++++ b/drivers/net/wireless/ath/ath9k/init.c
+@@ -260,7 +260,7 @@ static void setup_ht_cap(struct ath_soft
+ 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+ 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
+ 
+-	if (AR_SREV_9330(ah) || AR_SREV_9485(ah))
++	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah))
+ 		max_streams = 1;
+ 	else if (AR_SREV_9462(ah))
+ 		max_streams = 2;
diff --git a/linux-next-cherry-picks/0049-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch b/linux-next-cherry-picks/0049-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch
new file mode 100644
index 0000000..ba99d2f
--- /dev/null
+++ b/linux-next-cherry-picks/0049-ath9k_hw-Fix-spur-mitigation-for-AR9565.patch
@@ -0,0 +1,165 @@
+From d43d04a9e10f743c601fca8d9a019798ea7ce866 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Mon, 10 Sep 2012 09:20:20 +0530
+Subject: [PATCH] ath9k_hw: Fix spur mitigation for AR9565
+
+Exclude CCK spur mitigation, freq 2437 for OFDM and
+add AR9565-specific logic.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c | 67 ++++++++++++++++++++++++++---
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h | 15 +++++--
+ 2 files changed, 72 insertions(+), 10 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -206,6 +206,7 @@ static void ar9003_hw_spur_mitigate_mrc_
+ 	for (i = 0; i < max_spur_cnts; i++) {
+ 		if (AR_SREV_9462(ah) && (i == 0 || i == 3))
+ 			continue;
++
+ 		negative = 0;
+ 		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
+ 		    AR_SREV_9550(ah))
+@@ -301,7 +302,9 @@ static void ar9003_hw_spur_ofdm(struct a
+ 				int freq_offset,
+ 				int spur_freq_sd,
+ 				int spur_delta_phase,
+-				int spur_subchannel_sd)
++				int spur_subchannel_sd,
++				int range,
++				int synth_freq)
+ {
+ 	int mask_index = 0;
+ 
+@@ -316,8 +319,11 @@ static void ar9003_hw_spur_ofdm(struct a
+ 		      AR_PHY_SFCORR_EXT_SPUR_SUBCHANNEL_SD, spur_subchannel_sd);
+ 	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+ 		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_AGC, 0x1);
+-	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+-		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR, 0x1);
++
++	if (!(AR_SREV_9565(ah) && range == 10 && synth_freq == 2437))
++		REG_RMW_FIELD(ah, AR_PHY_TIMING11,
++			      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR, 0x1);
++
+ 	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+ 		      AR_PHY_TIMING4_ENABLE_SPUR_RSSI, 0x1);
+ 	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+@@ -358,9 +364,44 @@ static void ar9003_hw_spur_ofdm(struct a
+ 		      AR_PHY_SPUR_REG_MASK_RATE_CNTL, 0xff);
+ }
+ 
++static void ar9003_hw_spur_ofdm_9565(struct ath_hw *ah,
++				     int freq_offset)
++{
++	int mask_index = 0;
++
++	mask_index = (freq_offset << 4) / 5;
++	if (mask_index < 0)
++		mask_index = mask_index - 1;
++
++	mask_index = mask_index & 0x7f;
++
++	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
++		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_B,
++		      mask_index);
++
++	/* A == B */
++	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_B,
++		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A,
++		      mask_index);
++
++	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
++		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_B,
++		      mask_index);
++	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
++		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_B, 0xe);
++	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
++		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_B, 0xe);
++
++	/* A == B */
++	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_B,
++		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A, 0xa0);
++}
++
+ static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
+ 				     struct ath9k_channel *chan,
+-				     int freq_offset)
++				     int freq_offset,
++				     int range,
++				     int synth_freq)
+ {
+ 	int spur_freq_sd = 0;
+ 	int spur_subchannel_sd = 0;
+@@ -402,7 +443,8 @@ static void ar9003_hw_spur_ofdm_work(str
+ 			    freq_offset,
+ 			    spur_freq_sd,
+ 			    spur_delta_phase,
+-			    spur_subchannel_sd);
++			    spur_subchannel_sd,
++			    range, synth_freq);
+ }
+ 
+ /* Spur mitigation for OFDM */
+@@ -447,7 +489,17 @@ static void ar9003_hw_spur_mitigate_ofdm
+ 		freq_offset = ath9k_hw_fbin2freq(spurChansPtr[i], mode);
+ 		freq_offset -= synth_freq;
+ 		if (abs(freq_offset) < range) {
+-			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset);
++			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset,
++						 range, synth_freq);
++
++			if (AR_SREV_9565(ah) && (i < 4)) {
++				freq_offset = ath9k_hw_fbin2freq(spurChansPtr[i + 1],
++								 mode);
++				freq_offset -= synth_freq;
++				if (abs(freq_offset) < range)
++					ar9003_hw_spur_ofdm_9565(ah, freq_offset);
++			}
++
+ 			break;
+ 		}
+ 	}
+@@ -456,7 +508,8 @@ static void ar9003_hw_spur_mitigate_ofdm
+ static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
+ 				    struct ath9k_channel *chan)
+ {
+-	ar9003_hw_spur_mitigate_mrc_cck(ah, chan);
++	if (!AR_SREV_9565(ah))
++		ar9003_hw_spur_mitigate_mrc_cck(ah, chan);
+ 	ar9003_hw_spur_mitigate_ofdm(ah, chan);
+ }
+ 
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -223,15 +223,24 @@
+ #define AR_PHY_ML_CNTL_2       (AR_MRC_BASE + 0x1c)
+ #define AR_PHY_TST_ADC         (AR_MRC_BASE + 0x20)
+ 
+-#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A              0x00000FE0
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A      0x00000FE0
+ #define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A_S    5
+-#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A                  0x1F
+-#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A_S                0
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A          0x1F
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A_S        0
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_B      0x00FE0000
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_B_S    17
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_B          0x0001F000
++#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_B_S        12
+ 
+ #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A        0x00000FE0
+ #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A_S      5
+ #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A            0x1F
+ #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A_S		0
++#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_B	0x00FE0000
++#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_B_S	17
++#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_B		0x0001F000
++#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_B_S		12
++
+ 
+ /*
+  * MRC Feild Definitions
diff --git a/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch b/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
new file mode 100644
index 0000000..213af97
--- /dev/null
+++ b/linux-next-cherry-picks/0050-ath9k_hw-Program-correct-PLL-value-for-AR9565.patch
@@ -0,0 +1,23 @@
+From 8565f8bf478e28a416e2816d906a84e323e5629c Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Mon, 10 Sep 2012 09:20:29 +0530
+Subject: [PATCH] ath9k_hw: Program correct PLL value for AR9565
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 3 ++-
+ 1 file changed, 2 insertions(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -921,7 +921,8 @@ static void ath9k_hw_init_pll(struct ath
+ 	}
+ 
+ 	pll = ath9k_hw_compute_pll_control(ah, chan);
+-
++	if (AR_SREV_9565(ah))
++		pll |= 0x40000;
+ 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
+ 
+ 	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
diff --git a/linux-next-cherry-picks/0051-ath9k-Add-PCI-ID-for-AR9565.patch b/linux-next-cherry-picks/0051-ath9k-Add-PCI-ID-for-AR9565.patch
new file mode 100644
index 0000000..c86b242
--- /dev/null
+++ b/linux-next-cherry-picks/0051-ath9k-Add-PCI-ID-for-AR9565.patch
@@ -0,0 +1,23 @@
+From 0c8070f92f483b764623f6d3960a4d69f8911351 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Mon, 10 Sep 2012 09:20:39 +0530
+Subject: [PATCH] ath9k: Add PCI ID for AR9565
+
+Enable AR9565.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/pci.c | 1 +
+ 1 file changed, 1 insertion(+)
+
+--- a/drivers/net/wireless/ath/ath9k/pci.c
++++ b/drivers/net/wireless/ath/ath9k/pci.c
+@@ -40,6 +40,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_i
+ 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
+ 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
+ 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
++	{ PCI_VDEVICE(ATHEROS, 0x0036) }, /* PCI-E  AR9565 */
+ 	{ 0 }
+ };
+ 
diff --git a/linux-next-cherry-picks/0052-ath9k_hw-Wait-BT-calibration-to-complete.patch b/linux-next-cherry-picks/0052-ath9k_hw-Wait-BT-calibration-to-complete.patch
new file mode 100644
index 0000000..43f74e8
--- /dev/null
+++ b/linux-next-cherry-picks/0052-ath9k_hw-Wait-BT-calibration-to-complete.patch
@@ -0,0 +1,72 @@
+From 83ad49a96edaf139333be7f3f7ed261dd41e4ad3 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 10 Sep 2012 17:05:09 +0530
+Subject: [PATCH] ath9k_hw: Wait BT calibration to complete
+
+Whenever BT calibration requested, WLAN has to wait for the
+calibration to be completed. But right now we defer the waiting
+which might cause BT calibration to fail. Fix that.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |  1 +
+ drivers/net/wireless/ath/ath9k/debug.h      |  1 -
+ drivers/net/wireless/ath/ath9k/mci.c        | 19 ++++++++++++++++++-
+ 3 files changed, 19 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -714,6 +714,7 @@ bool ar9003_mci_start_reset(struct ath_h
+ 
+ 	return true;
+ }
++EXPORT_SYMBOL(ar9003_mci_start_reset);
+ 
+ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+ 			 struct ath9k_hw_cal_data *caldata)
+--- a/drivers/net/wireless/ath/ath9k/debug.h
++++ b/drivers/net/wireless/ath/ath9k/debug.h
+@@ -41,7 +41,6 @@ enum ath_reset_type {
+ 	RESET_TYPE_PLL_HANG,
+ 	RESET_TYPE_MAC_HANG,
+ 	RESET_TYPE_BEACON_STUCK,
+-	RESET_TYPE_MCI,
+ 	__RESET_TYPE_MAX
+ };
+ 
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -191,6 +191,23 @@ skip_tuning:
+ 	ath9k_btcoex_timer_resume(sc);
+ }
+ 
++static void ath_mci_wait_btcal_done(struct ath_softc *sc)
++{
++	struct ath_hw *ah = sc->sc_ah;
++
++	/* Stop tx & rx */
++	ieee80211_stop_queues(sc->hw);
++	ath_stoprecv(sc);
++	ath_drain_all_txq(sc, false);
++
++	/* Wait for cal done */
++	ar9003_mci_start_reset(ah, ah->curchan);
++
++	/* Resume tx & rx */
++	ath_startrecv(sc);
++	ieee80211_wake_queues(sc->hw);
++}
++
+ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+@@ -202,7 +219,7 @@ static void ath_mci_cal_msg(struct ath_s
+ 	case MCI_GPM_BT_CAL_REQ:
+ 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
+ 			mci_hw->bt_state = MCI_BT_CAL_START;
+-			ath9k_queue_reset(sc, RESET_TYPE_MCI);
++			ath_mci_wait_btcal_done(sc);
+ 		}
+ 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
+ 		break;
diff --git a/linux-next-cherry-picks/0053-ath9k_hw-use-peak-detection-for-5GHz.patch b/linux-next-cherry-picks/0053-ath9k_hw-use-peak-detection-for-5GHz.patch
new file mode 100644
index 0000000..d01315d
--- /dev/null
+++ b/linux-next-cherry-picks/0053-ath9k_hw-use-peak-detection-for-5GHz.patch
@@ -0,0 +1,22 @@
+From c21d34a302c21580133748a781af6f03a9a06aa7 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 10 Sep 2012 17:05:10 +0530
+Subject: [PATCH] ath9k_hw: use peak detection for 5GHz
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
++++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+@@ -58,7 +58,7 @@ static const u32 ar9462_2p0_baseband_pos
+ 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
+ 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+ 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
+-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
++	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcfd5c782, 0xcfd5c282},
+ 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
+ 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
+ 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
diff --git a/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch b/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
new file mode 100644
index 0000000..9bf0d60
--- /dev/null
+++ b/linux-next-cherry-picks/0054-ath9k_hw-add-8-points-for-5G-temp-slop.patch
@@ -0,0 +1,112 @@
+From 420e2b1b4a9120b6f89bc98e37173a6b2a48a798 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 10 Sep 2012 17:05:11 +0530
+Subject: [PATCH] ath9k_hw: add 8 points for 5G temp slop
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 26 +++++++++++++++++++-------
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  3 ++-
+ drivers/net/wireless/ath/ath9k/eeprom.h        |  1 +
+ 3 files changed, 22 insertions(+), 8 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -138,7 +138,8 @@ static const struct ar9300_eeprom ar9300
+ 	 },
+ 	.base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	},
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -713,7 +714,8 @@ static const struct ar9300_eeprom ar9300
+ 	 },
+ 	 .base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	 },
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -1289,7 +1291,8 @@ static const struct ar9300_eeprom ar9300
+ 	},
+ 	.base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	},
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -1865,7 +1868,8 @@ static const struct ar9300_eeprom ar9300
+ 	},
+ 	.base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	},
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -2440,7 +2444,8 @@ static const struct ar9300_eeprom ar9300
+ 	 },
+ 	 .base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	 },
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -4586,7 +4591,7 @@ static int ar9003_hw_power_control_overr
+ {
+ 	int tempSlope = 0;
+ 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+-	int f[3], t[3];
++	int f[8], t[8], i;
+ 
+ 	REG_RMW(ah, AR_PHY_TPC_11_B0,
+ 		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+@@ -4619,7 +4624,14 @@ static int ar9003_hw_power_control_overr
+ 	 */
+ 	if (frequency < 4000)
+ 		tempSlope = eep->modalHeader2G.tempSlope;
+-	else if (eep->base_ext2.tempSlopeLow != 0) {
++	else if ((eep->baseEepHeader.miscConfiguration & 0x20) != 0) {
++		for (i = 0; i < 8; i++) {
++			t[i] = eep->base_ext1.tempslopextension[i];
++			f[i] = FBIN2FREQ(eep->calFreqPier5G[i], 0);
++		}
++		tempSlope = ar9003_hw_power_interpolate((s32) frequency,
++							f, t, 8);
++	} else if (eep->base_ext2.tempSlopeLow != 0) {
+ 		t[0] = eep->base_ext2.tempSlopeLow;
+ 		f[0] = 5180;
+ 		t[1] = eep->modalHeader5G.tempSlope;
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+@@ -267,7 +267,8 @@ struct cal_ctl_data_5g {
+ 
+ struct ar9300_BaseExtension_1 {
+ 	u8 ant_div_control;
+-	u8 future[11];
++	u8 future[3];
++	u8 tempslopextension[8];
+ 	int8_t quick_drop_low;
+ 	int8_t quick_drop_high;
+ } __packed;
+--- a/drivers/net/wireless/ath/ath9k/eeprom.h
++++ b/drivers/net/wireless/ath/ath9k/eeprom.h
+@@ -96,6 +96,7 @@
+ 
+ #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
+ #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
++#define FBIN2FREQ(x, y)		((y) ? (2300 + x) : (4800 + 5 * x))
+ #define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
+ 
+ #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
diff --git a/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch b/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
new file mode 100644
index 0000000..06f6fb2
--- /dev/null
+++ b/linux-next-cherry-picks/0055-ath9k_hw-Handle-gentimer-termination-properly.patch
@@ -0,0 +1,30 @@
+From b7f597668657c9c9579dbdff9692aea3e8e9bf5a Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Tue, 11 Sep 2012 10:46:24 +0530
+Subject: [PATCH] ath9k_hw: Handle gentimer termination properly
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 10 ++++++++++
+ 1 file changed, 10 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -3084,6 +3084,16 @@ void ath9k_hw_gen_timer_stop(struct ath_
+ 	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
+ 			gen_tmr_configuration[timer->index].mode_mask);
+ 
++	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
++		/*
++		 * Need to switch back to TSF if it was using TSF2.
++		 */
++		if ((timer->index >= AR_GEN_TIMER_BANK_1_LEN)) {
++			REG_CLR_BIT(ah, AR_MAC_PCU_GEN_TIMER_TSF_SEL,
++				    (1 << timer->index));
++		}
++	}
++
+ 	/* Disable both trigger and thresh interrupt masks */
+ 	REG_CLR_BIT(ah, AR_IMR_S5,
+ 		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
diff --git a/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch b/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
new file mode 100644
index 0000000..b2a47b3
--- /dev/null
+++ b/linux-next-cherry-picks/0056-ath9k_hw-Rename-antenna-diversity-macros.patch
@@ -0,0 +1,173 @@
+From 9aa49ea3f5999a6a36823bd259892088896af140 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Tue, 11 Sep 2012 10:46:38 +0530
+Subject: [PATCH] ath9k_hw: Rename antenna diversity macros
+
+The register macros for antenna diversity are common for
+AR9462 and AR9565, rename them.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 27 +++++++---------
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 45 +++++++++++++-------------
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 34 +++++++++----------
+ 3 files changed, 51 insertions(+), 55 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3627,19 +3627,16 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 		regval &= (~AR_ANT_DIV_CTRL_ALL);
+ 		regval |= (value & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
+ 		/* enable_lnadiv */
+-		regval &= (~AR_PHY_9485_ANT_DIV_LNADIV);
+-		regval |= ((value >> 6) & 0x1) <<
+-				AR_PHY_9485_ANT_DIV_LNADIV_S;
++		regval &= (~AR_PHY_ANT_DIV_LNADIV);
++		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
+ 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+ 
+ 		/*enable fast_div */
+ 		regval = REG_READ(ah, AR_PHY_CCK_DETECT);
+ 		regval &= (~AR_FAST_DIV_ENABLE);
+-		regval |= ((value >> 7) & 0x1) <<
+-				AR_FAST_DIV_ENABLE_S;
++		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
+ 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
+-		ant_div_ctl1 =
+-			ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
++		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+ 		/* check whether antenna diversity is enabled */
+ 		if ((ant_div_ctl1 >> 0x6) == 0x3) {
+ 			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+@@ -3647,15 +3644,15 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
+ 			 * main_tb, alt_tb
+ 			 */
+-			regval &= (~(AR_PHY_9485_ANT_DIV_MAIN_LNACONF |
+-					AR_PHY_9485_ANT_DIV_ALT_LNACONF |
+-					AR_PHY_9485_ANT_DIV_ALT_GAINTB |
+-					AR_PHY_9485_ANT_DIV_MAIN_GAINTB));
++			regval &= (~(AR_PHY_ANT_DIV_MAIN_LNACONF |
++				     AR_PHY_ANT_DIV_ALT_LNACONF |
++				     AR_PHY_ANT_DIV_ALT_GAINTB |
++				     AR_PHY_ANT_DIV_MAIN_GAINTB));
+ 			/* by default use LNA1 for the main antenna */
+-			regval |= (AR_PHY_9485_ANT_DIV_LNA1 <<
+-					AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S);
+-			regval |= (AR_PHY_9485_ANT_DIV_LNA2 <<
+-					AR_PHY_9485_ANT_DIV_ALT_LNACONF_S);
++			regval |= (AR_PHY_ANT_DIV_LNA1 <<
++				   AR_PHY_ANT_DIV_MAIN_LNACONF_S);
++			regval |= (AR_PHY_ANT_DIV_LNA2 <<
++				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
+ 			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+ 		}
+ 
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -1276,17 +1276,17 @@ static void ar9003_hw_set_radar_conf(str
+ }
+ 
+ static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+-				   struct ath_hw_antcomb_conf *antconf)
++					   struct ath_hw_antcomb_conf *antconf)
+ {
+ 	u32 regval;
+ 
+ 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+-	antconf->main_lna_conf = (regval & AR_PHY_9485_ANT_DIV_MAIN_LNACONF) >>
+-				  AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S;
+-	antconf->alt_lna_conf = (regval & AR_PHY_9485_ANT_DIV_ALT_LNACONF) >>
+-				 AR_PHY_9485_ANT_DIV_ALT_LNACONF_S;
+-	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
+-				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
++	antconf->main_lna_conf = (regval & AR_PHY_ANT_DIV_MAIN_LNACONF) >>
++				  AR_PHY_ANT_DIV_MAIN_LNACONF_S;
++	antconf->alt_lna_conf = (regval & AR_PHY_ANT_DIV_ALT_LNACONF) >>
++				 AR_PHY_ANT_DIV_ALT_LNACONF_S;
++	antconf->fast_div_bias = (regval & AR_PHY_ANT_FAST_DIV_BIAS) >>
++				  AR_PHY_ANT_FAST_DIV_BIAS_S;
+ 
+ 	if (AR_SREV_9330_11(ah)) {
+ 		antconf->lna1_lna2_delta = -9;
+@@ -1306,22 +1306,21 @@ static void ar9003_hw_antdiv_comb_conf_s
+ 	u32 regval;
+ 
+ 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+-	regval &= ~(AR_PHY_9485_ANT_DIV_MAIN_LNACONF |
+-		    AR_PHY_9485_ANT_DIV_ALT_LNACONF |
+-		    AR_PHY_9485_ANT_FAST_DIV_BIAS |
+-		    AR_PHY_9485_ANT_DIV_MAIN_GAINTB |
+-		    AR_PHY_9485_ANT_DIV_ALT_GAINTB);
+-	regval |= ((antconf->main_lna_conf <<
+-					AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S)
+-		   & AR_PHY_9485_ANT_DIV_MAIN_LNACONF);
+-	regval |= ((antconf->alt_lna_conf << AR_PHY_9485_ANT_DIV_ALT_LNACONF_S)
+-		   & AR_PHY_9485_ANT_DIV_ALT_LNACONF);
+-	regval |= ((antconf->fast_div_bias << AR_PHY_9485_ANT_FAST_DIV_BIAS_S)
+-		   & AR_PHY_9485_ANT_FAST_DIV_BIAS);
+-	regval |= ((antconf->main_gaintb << AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S)
+-		   & AR_PHY_9485_ANT_DIV_MAIN_GAINTB);
+-	regval |= ((antconf->alt_gaintb << AR_PHY_9485_ANT_DIV_ALT_GAINTB_S)
+-		   & AR_PHY_9485_ANT_DIV_ALT_GAINTB);
++	regval &= ~(AR_PHY_ANT_DIV_MAIN_LNACONF |
++		    AR_PHY_ANT_DIV_ALT_LNACONF |
++		    AR_PHY_ANT_FAST_DIV_BIAS |
++		    AR_PHY_ANT_DIV_MAIN_GAINTB |
++		    AR_PHY_ANT_DIV_ALT_GAINTB);
++	regval |= ((antconf->main_lna_conf << AR_PHY_ANT_DIV_MAIN_LNACONF_S)
++		   & AR_PHY_ANT_DIV_MAIN_LNACONF);
++	regval |= ((antconf->alt_lna_conf << AR_PHY_ANT_DIV_ALT_LNACONF_S)
++		   & AR_PHY_ANT_DIV_ALT_LNACONF);
++	regval |= ((antconf->fast_div_bias << AR_PHY_ANT_FAST_DIV_BIAS_S)
++		   & AR_PHY_ANT_FAST_DIV_BIAS);
++	regval |= ((antconf->main_gaintb << AR_PHY_ANT_DIV_MAIN_GAINTB_S)
++		   & AR_PHY_ANT_DIV_MAIN_GAINTB);
++	regval |= ((antconf->alt_gaintb << AR_PHY_ANT_DIV_ALT_GAINTB_S)
++		   & AR_PHY_ANT_DIV_ALT_GAINTB);
+ 
+ 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+ }
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -280,23 +280,23 @@
+ #define AR_ANT_DIV_ENABLE_S	24
+ 
+ 
+-#define AR_PHY_9485_ANT_FAST_DIV_BIAS			0x00007e00
+-#define AR_PHY_9485_ANT_FAST_DIV_BIAS_S                  9
+-#define AR_PHY_9485_ANT_DIV_LNADIV			0x01000000
+-#define AR_PHY_9485_ANT_DIV_LNADIV_S			24
+-#define AR_PHY_9485_ANT_DIV_ALT_LNACONF			0x06000000
+-#define AR_PHY_9485_ANT_DIV_ALT_LNACONF_S		25
+-#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF		0x18000000
+-#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S		27
+-#define AR_PHY_9485_ANT_DIV_ALT_GAINTB			0x20000000
+-#define AR_PHY_9485_ANT_DIV_ALT_GAINTB_S		29
+-#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB			0x40000000
+-#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S		30
++#define AR_PHY_ANT_FAST_DIV_BIAS                0x00007e00
++#define AR_PHY_ANT_FAST_DIV_BIAS_S              9
++#define AR_PHY_ANT_DIV_LNADIV                   0x01000000
++#define AR_PHY_ANT_DIV_LNADIV_S                 24
++#define AR_PHY_ANT_DIV_ALT_LNACONF              0x06000000
++#define AR_PHY_ANT_DIV_ALT_LNACONF_S            25
++#define AR_PHY_ANT_DIV_MAIN_LNACONF             0x18000000
++#define AR_PHY_ANT_DIV_MAIN_LNACONF_S           27
++#define AR_PHY_ANT_DIV_ALT_GAINTB               0x20000000
++#define AR_PHY_ANT_DIV_ALT_GAINTB_S             29
++#define AR_PHY_ANT_DIV_MAIN_GAINTB              0x40000000
++#define AR_PHY_ANT_DIV_MAIN_GAINTB_S            30
+ 
+-#define AR_PHY_9485_ANT_DIV_LNA1_MINUS_LNA2		0x0
+-#define AR_PHY_9485_ANT_DIV_LNA2			0x1
+-#define AR_PHY_9485_ANT_DIV_LNA1			0x2
+-#define AR_PHY_9485_ANT_DIV_LNA1_PLUS_LNA2		0x3
++#define AR_PHY_ANT_DIV_LNA1_MINUS_LNA2          0x0
++#define AR_PHY_ANT_DIV_LNA2                     0x1
++#define AR_PHY_ANT_DIV_LNA1                     0x2
++#define AR_PHY_ANT_DIV_LNA1_PLUS_LNA2           0x3
+ 
+ #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
+ #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
diff --git a/linux-next-cherry-picks/0057-ath9k-Choose-correct-LED-pin-for-AR9565.patch b/linux-next-cherry-picks/0057-ath9k-Choose-correct-LED-pin-for-AR9565.patch
new file mode 100644
index 0000000..c0a60cb
--- /dev/null
+++ b/linux-next-cherry-picks/0057-ath9k-Choose-correct-LED-pin-for-AR9565.patch
@@ -0,0 +1,22 @@
+From 46025f550401c830be9773e14d62b7cab8856216 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Tue, 11 Sep 2012 11:04:00 +0530
+Subject: [PATCH] ath9k: Choose correct LED pin for AR9565
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -51,7 +51,7 @@ void ath_init_leds(struct ath_softc *sc)
+ 			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
+ 		else if (AR_SREV_9300(sc->sc_ah))
+ 			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
+-		else if (AR_SREV_9462(sc->sc_ah))
++		else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
+ 			sc->sc_ah->led_pin = ATH_LED_PIN_9462;
+ 		else
+ 			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
-- 
1.7.12

