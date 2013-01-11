Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:57920 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3AKSiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 13:38:06 -0500
Received: by mail-da0-f53.google.com with SMTP id x6so887457dac.12
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 10:38:04 -0800 (PST)
From: mcgrof@do-not-panic.com
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] wireless: make the reg_notifier() void
Date: Fri, 11 Jan 2013 18:37:57 +0000
Message-Id: <1357929477-11280-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130111_193811_403610_EF9B5C3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The reg_notifier()'s return value need not be checked
as it is only supposed to do post regulatory work and
that should never fail. Any behaviour to regulatory
that needs to be considered before cfg80211 does work
to a driver should be specified by using the already
existing flags, the reg_notifier() just does post
processing should it find it needs to.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath5k/base.c             |    5 +++--
 drivers/net/wireless/ath/ath6kl/cfg80211.c        |   16 +++++-----------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c     |    8 ++++----
 drivers/net/wireless/ath/ath9k/init.c             |    9 +++------
 drivers/net/wireless/ath/carl9170/main.c          |    6 +++---
 drivers/net/wireless/ath/regd.c                   |   18 ++++++++----------
 drivers/net/wireless/ath/regd.h                   |   10 +++++-----
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |    6 ++----
 drivers/net/wireless/libertas/cfg.c               |    8 +++-----
 drivers/net/wireless/libertas/cfg.h               |    3 ---
 drivers/net/wireless/mwifiex/cfg80211.c           |    6 ++----
 drivers/net/wireless/rtlwifi/regd.c               |   20 +++++++++-----------
 drivers/net/wireless/rtlwifi/regd.h               |    6 +++---
 drivers/net/wireless/ti/wlcore/main.c             |    6 ++----
 include/net/cfg80211.h                            |    4 ++--
 15 files changed, 54 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 30ca0a6..1d264c0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -240,13 +240,14 @@ static const struct ath_ops ath5k_common_ops = {
 * Driver Initialization *
 \***********************/
 
-static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+static void ath5k_reg_notifier(struct wiphy *wiphy,
+			       struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath5k_hw *ah = hw->priv;
 	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
 
-	return ath_reg_notifier_apply(wiphy, request, regulatory);
+	ath_reg_notifier_apply(wiphy, request, regulatory);
 }
 
 /********************\
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5516a8c..4225cca 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3492,8 +3492,8 @@ void ath6kl_cfg80211_stop_all(struct ath6kl *ar)
 		ath6kl_cfg80211_stop(vif);
 }
 
-static int ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
-				      struct regulatory_request *request)
+static void ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
+				       struct regulatory_request *request)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
 	u32 rates[IEEE80211_NUM_BANDS];
@@ -3506,17 +3506,13 @@ static int ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
 		   request->processed ? " processed" : "",
 		   request->initiator, request->user_reg_hint_type);
 
-	/*
-	 * As firmware is not able intersect regdoms, we can only listen to
-	 * cellular hints.
-	 */
 	if (request->user_reg_hint_type != NL80211_USER_REG_HINT_CELL_BASE)
-		return -EOPNOTSUPP;
+		return;
 
 	ret = ath6kl_wmi_set_regdomain_cmd(ar->wmi, request->alpha2);
 	if (ret) {
 		ath6kl_err("failed to set regdomain: %d\n", ret);
-		return ret;
+		return;
 	}
 
 	/*
@@ -3536,10 +3532,8 @@ static int ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
 	if (ret) {
 		ath6kl_err("failed to start scan for a regdomain change: %d\n",
 			   ret);
-		return ret;
+		return;
 	}
-
-	return 0;
 }
 
 static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index b2f85cb..716058b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -280,14 +280,14 @@ err:
 	return ret;
 }
 
-static int ath9k_reg_notifier(struct wiphy *wiphy,
-			      struct regulatory_request *request)
+static void ath9k_reg_notifier(struct wiphy *wiphy,
+			       struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath9k_htc_priv *priv = hw->priv;
 
-	return ath_reg_notifier_apply(wiphy, request,
-				      ath9k_hw_regulatory(priv->ah));
+	ath_reg_notifier_apply(wiphy, request,
+			       ath9k_hw_regulatory(priv->ah));
 }
 
 static unsigned int ath9k_regread(void *hw_priv, u32 reg_offset)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 90cfcb3..4b1abc7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -303,16 +303,15 @@ static void setup_ht_cap(struct ath_softc *sc,
 	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 }
 
-static int ath9k_reg_notifier(struct wiphy *wiphy,
-			      struct regulatory_request *request)
+static void ath9k_reg_notifier(struct wiphy *wiphy,
+			       struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
-	int ret;
 
-	ret = ath_reg_notifier_apply(wiphy, request, reg);
+	ath_reg_notifier_apply(wiphy, request, reg);
 
 	/* Set tx power */
 	if (ah->curchan) {
@@ -322,8 +321,6 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
 		ath9k_ps_restore(sc);
 	}
-
-	return ret;
 }
 
 /*
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f22da26..ef82751 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1981,13 +1981,13 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	return 0;
 }
 
-static int carl9170_reg_notifier(struct wiphy *wiphy,
-				 struct regulatory_request *request)
+static void carl9170_reg_notifier(struct wiphy *wiphy,
+				  struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ar9170 *ar = hw->priv;
 
-	return ath_reg_notifier_apply(wiphy, request, &ar->common.regulatory);
+	ath_reg_notifier_apply(wiphy, request, &ar->common.regulatory);
 }
 
 int carl9170_register(struct ar9170 *ar)
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 7a6c79e..ccc4c71 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -356,9 +356,9 @@ static u16 ath_regd_find_country_by_name(char *alpha2)
 	return -1;
 }
 
-int ath_reg_notifier_apply(struct wiphy *wiphy,
-			   struct regulatory_request *request,
-			   struct ath_regulatory *reg)
+void ath_reg_notifier_apply(struct wiphy *wiphy,
+			    struct regulatory_request *request,
+			    struct ath_regulatory *reg)
 {
 	struct ath_common *common = container_of(reg, struct ath_common,
 						 regulatory);
@@ -373,7 +373,7 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
 	 * any pending requests in the queue.
 	 */
 	if (!request)
-		return 0;
+		return;
 
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
@@ -409,8 +409,6 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
 
 		break;
 	}
-
-	return 0;
 }
 EXPORT_SYMBOL(ath_reg_notifier_apply);
 
@@ -500,8 +498,8 @@ ath_get_regpair(int regdmn)
 static int
 ath_regd_init_wiphy(struct ath_regulatory *reg,
 		    struct wiphy *wiphy,
-		    int (*reg_notifier)(struct wiphy *wiphy,
-					struct regulatory_request *request))
+		    void (*reg_notifier)(struct wiphy *wiphy,
+					 struct regulatory_request *request))
 {
 	const struct ieee80211_regdomain *regd;
 
@@ -621,8 +619,8 @@ static int __ath_regd_init(struct ath_regulatory *reg)
 int
 ath_regd_init(struct ath_regulatory *reg,
 	      struct wiphy *wiphy,
-	      int (*reg_notifier)(struct wiphy *wiphy,
-				  struct regulatory_request *request))
+	      void (*reg_notifier)(struct wiphy *wiphy,
+				   struct regulatory_request *request))
 {
 	struct ath_common *common = container_of(reg, struct ath_common,
 						 regulatory);
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 03a8268..37f53bd 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -252,12 +252,12 @@ enum CountryCode {
 bool ath_is_world_regd(struct ath_regulatory *reg);
 bool ath_is_49ghz_allowed(u16 redomain);
 int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
-		  int (*reg_notifier)(struct wiphy *wiphy,
-		  struct regulatory_request *request));
+		  void (*reg_notifier)(struct wiphy *wiphy,
+				       struct regulatory_request *request));
 u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
 			  enum ieee80211_band band);
-int ath_reg_notifier_apply(struct wiphy *wiphy,
-			   struct regulatory_request *request,
-			   struct ath_regulatory *reg);
+void ath_reg_notifier_apply(struct wiphy *wiphy,
+			    struct regulatory_request *request,
+			    struct ath_regulatory *reg);
 
 #endif
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 4eb3f0d..cdb62b8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -702,8 +702,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	}
 }
 
-static int brcms_reg_notifier(struct wiphy *wiphy,
-			      struct regulatory_request *request)
+static void brcms_reg_notifier(struct wiphy *wiphy,
+			       struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct brcms_info *wl = hw->priv;
@@ -744,8 +744,6 @@ static int brcms_reg_notifier(struct wiphy *wiphy,
 	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
 					brcms_c_japan_ccode(request->alpha2));
-
-	return 0;
 }
 
 void brcms_c_regd_init(struct brcms_c_info *wlc)
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index ec6d5d6..e520253 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -2184,11 +2184,10 @@ int lbs_cfg_register(struct lbs_private *priv)
 	return ret;
 }
 
-int lbs_reg_notifier(struct wiphy *wiphy,
-		struct regulatory_request *request)
+static void lbs_reg_notifier(struct wiphy *wiphy,
+			     struct regulatory_request *request)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
-	int ret = 0;
 
 	lbs_deb_enter_args(LBS_DEB_CFG80211, "cfg80211 regulatory domain "
 			"callback for domain %c%c\n", request->alpha2[0],
@@ -2196,10 +2195,9 @@ int lbs_reg_notifier(struct wiphy *wiphy,
 
 	memcpy(priv->country_code, request->alpha2, sizeof(request->alpha2));
 	if (lbs_iface_active(priv))
-		ret = lbs_set_11d_domain_info(priv);
+		lbs_set_11d_domain_info(priv);
 
 	lbs_deb_leave(LBS_DEB_CFG80211);
-	return ret;
 }
 
 void lbs_scan_deinit(struct lbs_private *priv)
diff --git a/drivers/net/wireless/libertas/cfg.h b/drivers/net/wireless/libertas/cfg.h
index 558168c..10995f5 100644
--- a/drivers/net/wireless/libertas/cfg.h
+++ b/drivers/net/wireless/libertas/cfg.h
@@ -10,9 +10,6 @@ struct wireless_dev *lbs_cfg_alloc(struct device *dev);
 int lbs_cfg_register(struct lbs_private *priv);
 void lbs_cfg_free(struct lbs_private *priv);
 
-int lbs_reg_notifier(struct wiphy *wiphy,
-		struct regulatory_request *request);
-
 void lbs_send_disconnect_notification(struct lbs_private *priv);
 void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f5f96c2..0c66329 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -519,8 +519,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
  *      - Set by user
  *      - Set bt Country IE
  */
-static int mwifiex_reg_notifier(struct wiphy *wiphy,
-				struct regulatory_request *request)
+static void mwifiex_reg_notifier(struct wiphy *wiphy,
+				 struct regulatory_request *request)
 {
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 
@@ -540,8 +540,6 @@ static int mwifiex_reg_notifier(struct wiphy *wiphy,
 		break;
 	}
 	mwifiex_send_domain_info_cmd_fw(wiphy);
-
-	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index 7e3ead7..d7d0d49 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -298,9 +298,9 @@ static void _rtl_reg_apply_world_flags(struct wiphy *wiphy,
 	return;
 }
 
-static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
-				   struct regulatory_request *request,
-				   struct rtl_regulatory *reg)
+static void _rtl_reg_notifier_apply(struct wiphy *wiphy,
+				    struct regulatory_request *request,
+				    struct rtl_regulatory *reg)
 {
 	/* We always apply this */
 	_rtl_reg_apply_radar_flags(wiphy);
@@ -314,8 +314,6 @@ static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 		_rtl_reg_apply_world_flags(wiphy, request->initiator, reg);
 		break;
 	}
-
-	return 0;
 }
 
 static const struct ieee80211_regdomain *_rtl_regdomain_select(
@@ -348,9 +346,9 @@ static const struct ieee80211_regdomain *_rtl_regdomain_select(
 
 static int _rtl_regd_init_wiphy(struct rtl_regulatory *reg,
 				struct wiphy *wiphy,
-				int (*reg_notifier) (struct wiphy *wiphy,
-						     struct regulatory_request *
-						     request))
+				void (*reg_notifier) (struct wiphy *wiphy,
+						      struct regulatory_request *
+						      request))
 {
 	const struct ieee80211_regdomain *regd;
 
@@ -379,7 +377,7 @@ static struct country_code_to_enum_rd *_rtl_regd_find_country(u16 countrycode)
 }
 
 int rtl_regd_init(struct ieee80211_hw *hw,
-		  int (*reg_notifier) (struct wiphy *wiphy,
+		  void (*reg_notifier) (struct wiphy *wiphy,
 				       struct regulatory_request *request))
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -421,12 +419,12 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 	return 0;
 }
 
-int rtl_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+void rtl_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	RT_TRACE(rtlpriv, COMP_REGD, DBG_LOUD, "\n");
 
-	return _rtl_reg_notifier_apply(wiphy, request, &rtlpriv->regd);
+	_rtl_reg_notifier_apply(wiphy, request, &rtlpriv->regd);
 }
diff --git a/drivers/net/wireless/rtlwifi/regd.h b/drivers/net/wireless/rtlwifi/regd.h
index 70ef2f4..4e1f4f00 100644
--- a/drivers/net/wireless/rtlwifi/regd.h
+++ b/drivers/net/wireless/rtlwifi/regd.h
@@ -55,7 +55,7 @@ enum country_code_type_t {
 };
 
 int rtl_regd_init(struct ieee80211_hw *hw,
-		  int (*reg_notifier) (struct wiphy *wiphy,
-				       struct regulatory_request *request));
-int rtl_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
+		  void (*reg_notifier) (struct wiphy *wiphy,
+					struct regulatory_request *request));
+void rtl_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d7de063..ce6e62a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -89,8 +89,8 @@ static int wl12xx_set_authorized(struct wl1271 *wl,
 	return 0;
 }
 
-static int wl1271_reg_notify(struct wiphy *wiphy,
-			     struct regulatory_request *request)
+static void wl1271_reg_notify(struct wiphy *wiphy,
+			      struct regulatory_request *request)
 {
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *ch;
@@ -107,8 +107,6 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 				     IEEE80211_CHAN_PASSIVE_SCAN;
 
 	}
-
-	return 0;
 }
 
 static int wl1271_set_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b7f0069..4d1992d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2364,8 +2364,8 @@ struct wiphy {
 	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
 
 	/* Lets us get back the wiphy on the callback */
-	int (*reg_notifier)(struct wiphy *wiphy,
-			    struct regulatory_request *request);
+	void (*reg_notifier)(struct wiphy *wiphy,
+			     struct regulatory_request *request);
 
 	/* fields below are read-only, assigned by cfg80211 */
 
-- 
1.7.10.4

