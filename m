Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab3FCP2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:28:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: take WoWLAN support information out of wiphy struct
Date: Mon,  3 Jun 2013 17:28:16 +0200
Message-Id: <1370273296-14385-1-git-send-email-johannes@sipsolutions.net> (sfid-20130603_172826_069273_735F1E17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to take up the space for devices that don't
support WoWLAN, and most drivers can even make the support
data static const (except where it's modified at runtime.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c  | 24 ++++++++-----
 drivers/net/wireless/ath/ath9k/init.c       | 20 ++++++-----
 drivers/net/wireless/iwlwifi/dvm/dev.h      |  3 ++
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 17 ++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 26 +++++++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/mwifiex/cfg80211.c     | 16 ++++++---
 drivers/net/wireless/ti/wlcore/main.c       | 19 +++++-----
 include/net/cfg80211.h                      |  2 +-
 net/wireless/core.c                         | 20 ++++++-----
 net/wireless/nl80211.c                      | 56 ++++++++++++++---------------
 11 files changed, 114 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5c9736a..f7995b2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3679,6 +3679,20 @@ err:
 	return NULL;
 }
 
+#ifdef CONFIG_PM
+static const struct wiphy_wowlan_support ath6kl_wowlan_support = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT |
+		 WIPHY_WOWLAN_DISCONNECT |
+		 WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
+		 WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+		 WIPHY_WOWLAN_EAP_IDENTITY_REQ   |
+		 WIPHY_WOWLAN_4WAY_HANDSHAKE,
+	.n_patterns = WOW_MAX_FILTERS_PER_LIST,
+	.pattern_min_len = 1,
+	.pattern_max_len = WOW_PATTERN_SIZE,
+};
+#endif
+
 int ath6kl_cfg80211_init(struct ath6kl *ar)
 {
 	struct wiphy *wiphy = ar->wiphy;
@@ -3772,15 +3786,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
 #ifdef CONFIG_PM
-	wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
-			      WIPHY_WOWLAN_DISCONNECT |
-			      WIPHY_WOWLAN_GTK_REKEY_FAILURE  |
-			      WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
-			      WIPHY_WOWLAN_EAP_IDENTITY_REQ   |
-			      WIPHY_WOWLAN_4WAY_HANDSHAKE;
-	wiphy->wowlan.n_patterns = WOW_MAX_FILTERS_PER_LIST;
-	wiphy->wowlan.pattern_min_len = 1;
-	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
+	wiphy->wowlan = &ath6kl_wowlan_support;
 #endif
 
 	wiphy->max_sched_scan_ssids = MAX_PROBED_SSIDS;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0237b28..f993362 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -755,6 +755,15 @@ static const struct ieee80211_iface_combination if_comb[] = {
 	}
 };
 
+#ifdef CONFIG_PM
+static const struct wiphy_wowlan_support ath9k_wowlan_support = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+	.n_patterns = MAX_NUM_USER_PATTERN,
+	.pattern_min_len = 1,
+	.pattern_max_len = MAX_PATTERN_SIZE,
+};
+#endif
+
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -797,15 +806,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 #ifdef CONFIG_PM_SLEEP
 
 	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
-	    device_can_wakeup(sc->dev)) {
-
-		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
-					  WIPHY_WOWLAN_DISCONNECT;
-		hw->wiphy->wowlan.n_patterns = MAX_NUM_USER_PATTERN;
-		hw->wiphy->wowlan.pattern_min_len = 1;
-		hw->wiphy->wowlan.pattern_max_len = MAX_PATTERN_SIZE;
-
-	}
+	    device_can_wakeup(sc->dev))
+		hw->wiphy->wowlan = &ath9k_wowlan_support;
 
 	atomic_set(&sc->wow_sleep_proc_intr, -1);
 	atomic_set(&sc->wow_got_bmiss_intr, -1);
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 71ea775..e71acfd 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -870,6 +870,9 @@ struct iwl_priv {
 	__le64 replay_ctr;
 	__le16 last_seq_ctl;
 	bool have_rekey_data;
+#ifdef CONFIG_PM_SLEEP
+	struct wiphy_wowlan_support wowlan_support;
+#endif
 
 	/* device_pointers: pointers to ucode event tables */
 	struct {
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index cab23af..661b5e7 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -208,20 +208,21 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	    priv->trans->ops->d3_suspend &&
 	    priv->trans->ops->d3_resume &&
 	    device_can_wakeup(priv->trans->dev)) {
-		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
-					  WIPHY_WOWLAN_DISCONNECT |
-					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
-					  WIPHY_WOWLAN_RFKILL_RELEASE;
+		priv->wowlan_support.flags = WIPHY_WOWLAN_MAGIC_PKT |
+					     WIPHY_WOWLAN_DISCONNECT |
+					     WIPHY_WOWLAN_EAP_IDENTITY_REQ |
+					     WIPHY_WOWLAN_RFKILL_RELEASE;
 		if (!iwlwifi_mod_params.sw_crypto)
-			hw->wiphy->wowlan.flags |=
+			priv->wowlan_support.flags |=
 				WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
 				WIPHY_WOWLAN_GTK_REKEY_FAILURE;
 
-		hw->wiphy->wowlan.n_patterns = IWLAGN_WOWLAN_MAX_PATTERNS;
-		hw->wiphy->wowlan.pattern_min_len =
+		priv->wowlan_support.n_patterns = IWLAGN_WOWLAN_MAX_PATTERNS;
+		priv->wowlan_support.pattern_min_len =
 					IWLAGN_WOWLAN_MIN_PATTERN_LEN;
-		hw->wiphy->wowlan.pattern_max_len =
+		priv->wowlan_support.pattern_max_len =
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
+		hw->wiphy->wowlan = &priv->wowlan_support;
 	}
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index dd158ec..827fa64 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -222,20 +222,20 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    mvm->trans->ops->d3_suspend &&
 	    mvm->trans->ops->d3_resume &&
 	    device_can_wakeup(mvm->trans->dev)) {
-		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
-					  WIPHY_WOWLAN_DISCONNECT |
-					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
-					  WIPHY_WOWLAN_RFKILL_RELEASE;
+		mvm->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
+				    WIPHY_WOWLAN_DISCONNECT |
+				    WIPHY_WOWLAN_EAP_IDENTITY_REQ |
+				    WIPHY_WOWLAN_RFKILL_RELEASE;
 		if (!iwlwifi_mod_params.sw_crypto)
-			hw->wiphy->wowlan.flags |=
-				WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
-				WIPHY_WOWLAN_GTK_REKEY_FAILURE |
-				WIPHY_WOWLAN_4WAY_HANDSHAKE;
-
-		hw->wiphy->wowlan.n_patterns = IWL_WOWLAN_MAX_PATTERNS;
-		hw->wiphy->wowlan.pattern_min_len = IWL_WOWLAN_MIN_PATTERN_LEN;
-		hw->wiphy->wowlan.pattern_max_len = IWL_WOWLAN_MAX_PATTERN_LEN;
-		hw->wiphy->wowlan.tcp = &iwl_mvm_wowlan_tcp_support;
+			mvm->wowlan.flags |= WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+					     WIPHY_WOWLAN_GTK_REKEY_FAILURE |
+					     WIPHY_WOWLAN_4WAY_HANDSHAKE;
+
+		mvm->wowlan.n_patterns = IWL_WOWLAN_MAX_PATTERNS;
+		mvm->wowlan.pattern_min_len = IWL_WOWLAN_MIN_PATTERN_LEN;
+		mvm->wowlan.pattern_max_len = IWL_WOWLAN_MAX_PATTERN_LEN;
+		mvm->wowlan.tcp = &iwl_mvm_wowlan_tcp_support;
+		hw->wiphy->wowlan = &mvm->wowlan;
 	}
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 8269bc5..b62a948 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -336,6 +336,7 @@ struct iwl_mvm {
 	struct ieee80211_vif *p2p_device_vif;
 
 #ifdef CONFIG_PM_SLEEP
+	struct wiphy_wowlan_support wowlan;
 	int gtk_ivlen, gtk_icvlen, ptk_ivlen, ptk_icvlen;
 #endif
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e42b266..6007789 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2426,6 +2426,16 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 #endif
 };
 
+#ifdef CONFIG_PM
+static const struct wiphy_wowlan_support mwifiex_wowlan_support = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT,
+	.n_patterns = MWIFIEX_MAX_FILTERS,
+	.pattern_min_len = 1,
+	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
+	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
+};
+#endif
+
 /*
  * This function registers the device with CFG802.11 subsystem.
  *
@@ -2483,11 +2493,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
 
 #ifdef CONFIG_PM
-	wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT;
-	wiphy->wowlan.n_patterns = MWIFIEX_MAX_FILTERS;
-	wiphy->wowlan.pattern_min_len = 1;
-	wiphy->wowlan.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN;
-	wiphy->wowlan.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN;
+	wiphy->wowlan = &mwifiex_wowlan_support;
 #endif
 
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 953111a..796928b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6018,6 +6018,15 @@ int wlcore_free_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wlcore_free_hw);
 
+#ifdef CONFIG_PM
+static const struct wiphy_wowlan_support wlcore_wowlan_support = {
+	.flags = WIPHY_WOWLAN_ANY,
+	.n_patterns = WL1271_MAX_RX_FILTERS,
+	.pattern_min_len = 1,
+	.pattern_max_len = WL1271_RX_FILTER_MAX_PATTERN_SIZE,
+};
+#endif
+
 static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 {
 	struct wl1271 *wl = context;
@@ -6071,14 +6080,8 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	if (!ret) {
 		wl->irq_wake_enabled = true;
 		device_init_wakeup(wl->dev, 1);
-		if (pdata->pwr_in_suspend) {
-			wl->hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY;
-			wl->hw->wiphy->wowlan.n_patterns =
-				WL1271_MAX_RX_FILTERS;
-			wl->hw->wiphy->wowlan.pattern_min_len = 1;
-			wl->hw->wiphy->wowlan.pattern_max_len =
-				WL1271_RX_FILTER_MAX_PATTERN_SIZE;
-		}
+		if (pdata->pwr_in_suspend)
+			wl->hw->wiphy->wowlan = &wlcore_wowlan_support;
 	}
 #endif
 	disable_irq(wl->irq);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6dd1959..6169fca 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2654,7 +2654,7 @@ struct wiphy {
 	u32 hw_version;
 
 #ifdef CONFIG_PM
-	struct wiphy_wowlan_support wowlan;
+	const struct wiphy_wowlan_support *wowlan;
 	struct cfg80211_wowlan *wowlan_config;
 #endif
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 41cec17..f553b94 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -449,8 +449,13 @@ int wiphy_register(struct wiphy *wiphy)
 	u16 ifmodes = wiphy->interface_modes;
 
 #ifdef CONFIG_PM
-	if (WARN_ON((wiphy->wowlan.flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
-		    !(wiphy->wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)))
+	if (WARN_ON(wiphy->wowlan &&
+		    (wiphy->wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
+		    !(wiphy->wowlan->flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)))
+		return -EINVAL;
+	if (WARN_ON(wiphy->wowlan &&
+		    !wiphy->wowlan->flags && !wiphy->wowlan->n_patterns &&
+		    !wiphy->wowlan->tcp))
 		return -EINVAL;
 #endif
 
@@ -540,12 +545,11 @@ int wiphy_register(struct wiphy *wiphy)
 	}
 
 #ifdef CONFIG_PM
-	if (rdev->wiphy.wowlan.n_patterns) {
-		if (WARN_ON(!rdev->wiphy.wowlan.pattern_min_len ||
-			    rdev->wiphy.wowlan.pattern_min_len >
-			    rdev->wiphy.wowlan.pattern_max_len))
-			return -EINVAL;
-	}
+	if (WARN_ON(rdev->wiphy.wowlan && rdev->wiphy.wowlan->n_patterns &&
+		    (!rdev->wiphy.wowlan->pattern_min_len ||
+		     rdev->wiphy.wowlan->pattern_min_len >
+				rdev->wiphy.wowlan->pattern_max_len)))
+		return -EINVAL;
 #endif
 
 	/* check and set up bitrates */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 31d265f..34cac2f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -908,7 +908,7 @@ nla_put_failure:
 static int nl80211_send_wowlan_tcp_caps(struct cfg80211_registered_device *rdev,
 					struct sk_buff *msg)
 {
-	const struct wiphy_wowlan_tcp_support *tcp = rdev->wiphy.wowlan.tcp;
+	const struct wiphy_wowlan_tcp_support *tcp = rdev->wiphy.wowlan->tcp;
 	struct nlattr *nl_tcp;
 
 	if (!tcp)
@@ -951,37 +951,37 @@ static int nl80211_send_wowlan(struct sk_buff *msg,
 {
 	struct nlattr *nl_wowlan;
 
-	if (!dev->wiphy.wowlan.flags && !dev->wiphy.wowlan.n_patterns)
+	if (!dev->wiphy.wowlan)
 		return 0;
 
 	nl_wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED);
 	if (!nl_wowlan)
 		return -ENOBUFS;
 
-	if (((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_ANY) &&
+	if (((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_ANY) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_ANY)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_DISCONNECT) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_DISCONNECT) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_DISCONNECT)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_MAGIC_PKT) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_MAGIC_PKT) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_4WAY_HANDSHAKE) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_4WAY_HANDSHAKE) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE)) ||
-	    ((dev->wiphy.wowlan.flags & WIPHY_WOWLAN_RFKILL_RELEASE) &&
+	    ((dev->wiphy.wowlan->flags & WIPHY_WOWLAN_RFKILL_RELEASE) &&
 	     nla_put_flag(msg, NL80211_WOWLAN_TRIG_RFKILL_RELEASE)))
 		return -ENOBUFS;
 
-	if (dev->wiphy.wowlan.n_patterns) {
+	if (dev->wiphy.wowlan->n_patterns) {
 		struct nl80211_wowlan_pattern_support pat = {
-			.max_patterns = dev->wiphy.wowlan.n_patterns,
-			.min_pattern_len = dev->wiphy.wowlan.pattern_min_len,
-			.max_pattern_len = dev->wiphy.wowlan.pattern_max_len,
-			.max_pkt_offset = dev->wiphy.wowlan.max_pkt_offset,
+			.max_patterns = dev->wiphy.wowlan->n_patterns,
+			.min_pattern_len = dev->wiphy.wowlan->pattern_min_len,
+			.max_pattern_len = dev->wiphy.wowlan->pattern_max_len,
+			.max_pkt_offset = dev->wiphy.wowlan->max_pkt_offset,
 		};
 
 		if (nla_put(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN,
@@ -7580,8 +7580,7 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 	void *hdr;
 	u32 size = NLMSG_DEFAULT_SIZE;
 
-	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns &&
-	    !rdev->wiphy.wowlan.tcp)
+	if (!rdev->wiphy.wowlan)
 		return -EOPNOTSUPP;
 
 	if (rdev->wiphy.wowlan_config && rdev->wiphy.wowlan_config->tcp) {
@@ -7654,7 +7653,7 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 	u32 data_size, wake_size, tokens_size = 0, wake_mask_size;
 	int err, port;
 
-	if (!rdev->wiphy.wowlan.tcp)
+	if (!rdev->wiphy.wowlan->tcp)
 		return -EINVAL;
 
 	err = nla_parse(tb, MAX_NL80211_WOWLAN_TCP,
@@ -7674,16 +7673,16 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	data_size = nla_len(tb[NL80211_WOWLAN_TCP_DATA_PAYLOAD]);
-	if (data_size > rdev->wiphy.wowlan.tcp->data_payload_max)
+	if (data_size > rdev->wiphy.wowlan->tcp->data_payload_max)
 		return -EINVAL;
 
 	if (nla_get_u32(tb[NL80211_WOWLAN_TCP_DATA_INTERVAL]) >
-			rdev->wiphy.wowlan.tcp->data_interval_max ||
+			rdev->wiphy.wowlan->tcp->data_interval_max ||
 	    nla_get_u32(tb[NL80211_WOWLAN_TCP_DATA_INTERVAL]) == 0)
 		return -EINVAL;
 
 	wake_size = nla_len(tb[NL80211_WOWLAN_TCP_WAKE_PAYLOAD]);
-	if (wake_size > rdev->wiphy.wowlan.tcp->wake_payload_max)
+	if (wake_size > rdev->wiphy.wowlan->tcp->wake_payload_max)
 		return -EINVAL;
 
 	wake_mask_size = nla_len(tb[NL80211_WOWLAN_TCP_WAKE_MASK]);
@@ -7698,13 +7697,13 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 
 		if (!tok->len || tokens_size % tok->len)
 			return -EINVAL;
-		if (!rdev->wiphy.wowlan.tcp->tok)
+		if (!rdev->wiphy.wowlan->tcp->tok)
 			return -EINVAL;
-		if (tok->len > rdev->wiphy.wowlan.tcp->tok->max_len)
+		if (tok->len > rdev->wiphy.wowlan->tcp->tok->max_len)
 			return -EINVAL;
-		if (tok->len < rdev->wiphy.wowlan.tcp->tok->min_len)
+		if (tok->len < rdev->wiphy.wowlan->tcp->tok->min_len)
 			return -EINVAL;
-		if (tokens_size > rdev->wiphy.wowlan.tcp->tok->bufsize)
+		if (tokens_size > rdev->wiphy.wowlan->tcp->tok->bufsize)
 			return -EINVAL;
 		if (tok->offset + tok->len > data_size)
 			return -EINVAL;
@@ -7712,7 +7711,7 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 
 	if (tb[NL80211_WOWLAN_TCP_DATA_PAYLOAD_SEQ]) {
 		seq = nla_data(tb[NL80211_WOWLAN_TCP_DATA_PAYLOAD_SEQ]);
-		if (!rdev->wiphy.wowlan.tcp->seq)
+		if (!rdev->wiphy.wowlan->tcp->seq)
 			return -EINVAL;
 		if (seq->len == 0 || seq->len > 4)
 			return -EINVAL;
@@ -7793,12 +7792,11 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG];
 	struct cfg80211_wowlan new_triggers = {};
 	struct cfg80211_wowlan *ntrig;
-	struct wiphy_wowlan_support *wowlan = &rdev->wiphy.wowlan;
+	struct wiphy_wowlan_support *wowlan = rdev->wiphy.wowlan;
 	int err, i;
 	bool prev_enabled = rdev->wiphy.wowlan_config;
 
-	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns &&
-	    !rdev->wiphy.wowlan.tcp)
+	if (!wowlan)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]) {
-- 
1.8.0

