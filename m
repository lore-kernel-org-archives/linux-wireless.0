Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39295 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967Ab2HHMCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:02:25 -0400
Received: by ggnf4 with SMTP id f4so645497ggn.28
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:02:24 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 4/7] hostapd: add dfs support into interface init flow
Date: Wed,  8 Aug 2012 14:55:35 +0300
Message-Id: <1344426938-1883-5-git-send-email-victorg@ti.com> (sfid-20120808_140228_806794_2E28D85B)
In-Reply-To: <1344426938-1883-1-git-send-email-victorg@ti.com>
References: <1344426938-1883-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement Channel Availability Check (CAC) during initialization
phase. According to DFS requirements the AP should monitor 'radar
channels' for potential radar interference for a minimum CAC time
prior enabling the transmissions.

Add dfs support into hw features, allow the usage of the radar
channels if ieee80211h is enabled in the hostapd.conf and the
driver supports radar detection with AP channel switch ability.

Signed-hostap: Boris Presman <boris.presman@ti.com>
Signed-hostap: Victor Goldenshtein <victorg@ti.com>
---
 src/ap/hostapd.c             |   16 ++++++++++------
 src/ap/hw_features.c         |   30 ++++++++++++++++++++----------
 src/ap/hw_features.h         |    9 +++++++++
 src/drivers/driver.h         |    5 +++++
 src/drivers/driver_nl80211.c |    9 +++++++++
 src/utils/eloop.c            |    1 +
 6 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/src/ap/hostapd.c b/src/ap/hostapd.c
index 2fbc6ef..24a5384 100644
--- a/src/ap/hostapd.c
+++ b/src/ap/hostapd.c
@@ -857,6 +857,12 @@ static int setup_interface(struct hostapd_iface *iface)
 				   "be completed in a callback");
 			return 0;
 		}
+
+		if (iface->current_mode->dfs_supported &&
+		    iface->conf->ieee80211h) {
+			wpa_printf(MSG_DEBUG, "DFS support is enabled");
+			iface->dfs_state |= DFS_ENABLED;
+		}
 	}
 	return hostapd_setup_interface_complete(iface, 0);
 }
@@ -882,14 +888,12 @@ int hostapd_setup_interface_complete(struct hostapd_iface *iface, int err)
 			   hostapd_hw_mode_txt(hapd->iconf->hw_mode),
 			   hapd->iconf->channel, iface->freq);
 
-		if (hostapd_set_freq(hapd, hapd->iconf->hw_mode, iface->freq,
-				     hapd->iconf->channel,
-				     hapd->iconf->ieee80211n,
-				     hapd->iconf->secondary_channel)) {
-			wpa_printf(MSG_ERROR, "Could not set channel for "
-				   "kernel driver");
+		if (hostapd_check_set_freq(hapd)) {
+			wpa_printf(MSG_ERROR, "Couldn't check/set freq");
 			return -1;
 		}
+
+		wpa_printf(MSG_DEBUG, "Continuing with init flow");
 	}
 
 	if (iface->current_mode) {
diff --git a/src/ap/hw_features.c b/src/ap/hw_features.c
index bbd2b03..3fc43eb 100644
--- a/src/ap/hw_features.c
+++ b/src/ap/hw_features.c
@@ -70,26 +70,36 @@ int hostapd_get_hw_features(struct hostapd_iface *iface)
 
 	for (i = 0; i < num_modes; i++) {
 		struct hostapd_hw_modes *feature = &modes[i];
+		u8 dfs_enabled = (hapd->iconf->ieee80211h &&
+				  feature->dfs_supported);
 		/* set flag for channels we can use in current regulatory
 		 * domain */
 		for (j = 0; j < feature->num_channels; j++) {
+			u8 dfs = FALSE;
 			/*
 			 * Disable all channels that are marked not to allow
-			 * IBSS operation or active scanning. In addition,
-			 * disable all channels that require radar detection,
-			 * since that (in addition to full DFS) is not yet
-			 * supported.
+			 * IBSS operation or active scanning.
+			 * Use radar channels only if the driver supports
+			 * DFS.
 			 */
-			if (feature->channels[j].flag &
-			    (HOSTAPD_CHAN_NO_IBSS |
-			     HOSTAPD_CHAN_PASSIVE_SCAN |
-			     HOSTAPD_CHAN_RADAR))
+			if ((feature->channels[j].flag &
+			    HOSTAPD_CHAN_RADAR) && dfs_enabled) {
+				dfs = TRUE;
+			} else if (feature->channels[j].flag &
+				   (HOSTAPD_CHAN_NO_IBSS |
+				   HOSTAPD_CHAN_PASSIVE_SCAN |
+				   HOSTAPD_CHAN_DISABLED)) {
 				feature->channels[j].flag |=
 					HOSTAPD_CHAN_DISABLED;
-			if (feature->channels[j].flag & HOSTAPD_CHAN_DISABLED)
+			}
+
+			if (feature->channels[j].flag & HOSTAPD_CHAN_DISABLED) {
 				continue;
-			wpa_printf(MSG_MSGDUMP, "Allowed channel: mode=%d "
+			}
+
+			wpa_printf(MSG_WARNING, "Allowed %schannel: mode=%d "
 				   "chan=%d freq=%d MHz max_tx_power=%d dBm",
+				   dfs ? "(DFS) " : "",
 				   feature->mode,
 				   feature->channels[j].chan,
 				   feature->channels[j].freq,
diff --git a/src/ap/hw_features.h b/src/ap/hw_features.h
index b8e287b..67bab44 100644
--- a/src/ap/hw_features.h
+++ b/src/ap/hw_features.h
@@ -46,6 +46,11 @@ static inline int hostapd_select_hw_mode(struct hostapd_iface *iface)
 	return -100;
 }
 
+static inline int hostapd_select_radar_detector(struct hostapd_iface *iface)
+{
+	return -1;
+}
+
 static inline const char * hostapd_hw_mode_txt(int mode)
 {
 	return NULL;
@@ -67,6 +72,10 @@ static inline int hostapd_prepare_rates(struct hostapd_iface *iface,
 	return 0;
 }
 
+static inline int hostapd_get_channel_flag(struct hostapd_data *hapd, int chan)
+{
+	return 0;
+}
 #endif /* NEED_AP_MLME */
 
 #endif /* HW_FEATURES_H */
diff --git a/src/drivers/driver.h b/src/drivers/driver.h
index 5b031a8..ed032b9 100644
--- a/src/drivers/driver.h
+++ b/src/drivers/driver.h
@@ -140,6 +140,11 @@ struct hostapd_hw_modes {
 	u8 vht_mcs_set[8];
 
 	unsigned int flags; /* HOSTAPD_MODE_FLAG_* */
+
+	/**
+	 * dfs_supported - DFS radar detection is supported in driver/HW.
+	 */
+	u8 dfs_supported;
 };
 
 
diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 36cdbc8..3ac485c 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -4786,6 +4786,15 @@ static int phy_info_handler(struct nl_msg *msg, void *arg)
 		mode->flags = HOSTAPD_MODE_FLAG_HT_INFO_KNOWN;
 		*(phy_info->num_modes) += 1;
 
+		if (tb_msg[NL80211_ATTR_FEATURE_FLAGS]) {
+			u32 drv_feature_flags =
+				nla_get_u32(tb_msg[NL80211_ATTR_FEATURE_FLAGS]);
+			mode->dfs_supported = ((drv_feature_flags &
+						NL80211_FEATURE_DFS) &&
+						(drv_feature_flags &
+						NL80211_FEATURE_AP_CH_SWITCH));
+		}
+
 		nla_parse(tb_band, NL80211_BAND_ATTR_MAX, nla_data(nl_band),
 			  nla_len(nl_band), NULL);
 
diff --git a/src/utils/eloop.c b/src/utils/eloop.c
index bb32401..8cb34dc 100644
--- a/src/utils/eloop.c
+++ b/src/utils/eloop.c
@@ -775,6 +775,7 @@ void eloop_run(void)
 	}
 
 out:
+	eloop.terminate = 0;
 #ifndef CONFIG_ELOOP_POLL
 	os_free(rfds);
 	os_free(wfds);
-- 
1.7.5.4

