Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:51224 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZJZQbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 12:31:00 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] libertas: minimal WEXT handler for MESH
Date: Mon, 26 Oct 2009 17:29:36 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910261729.36583.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here I moved some WEXT related for the mesh interface from wext.c
into the upcoming "mesh.c". Near the very end of this patch you
see the new iw_handler definition.

For many handlers, I simply put NULL there, but I guess
that I should do this:

a) register mesh_dev with cfg80211 as well
b) use the handlers from compat-wext.c instead

Is this right?  And I guess that I connot do b) without a)

Or is it ok to do b) without a). Would then cfg80211 than always
calls into the priv->dev (for the station's struct net_device *).
I'm puzzled.

I guess that this patch --- as it is --- will leave you with a broken
mesh implementation. Or with a partially broken one, e.g. where you
can define mesh-SSID, but you cannot reduce the TX power. Not sure if
that is what we want ---- or in other words, not sure if the mesh-WEXT
handler really only needs 4 or so handler functions.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -104,45 +104,6 @@
 }
 
 /**
- *  @brief Find the channel frequency power info with specific channel
- *
- *  @param priv 	A pointer to struct lbs_private structure
- *  @param band		it can be BAND_A, BAND_G or BAND_B
- *  @param channel      the channel for looking
- *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
- */
-struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
-	struct lbs_private *priv,
-	u8 band,
-	u16 channel)
-{
-	struct chan_freq_power *cfp = NULL;
-	struct region_channel *rc;
-	int i, j;
-
-	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
-		rc = &priv->region_channel[j];
-
-		if (!rc->valid || !rc->CFP)
-			continue;
-		if (rc->band != band)
-			continue;
-		for (i = 0; i < rc->nrcfp; i++) {
-			if (rc->CFP[i].channel == channel) {
-				cfp = &rc->CFP[i];
-				break;
-			}
-		}
-	}
-
-	if (!cfp && channel)
-		lbs_deb_wext("lbs_find_cfp_by_band_and_channel: can't find "
-		       "cfp by band %d / channel %d\n", band, channel);
-
-	return cfp;
-}
-
-/**
  *  @brief Find the channel frequency power info with specific frequency
  *
  *  @param priv 	A pointer to struct lbs_private structure
@@ -213,7 +174,7 @@
 	return 0;
 }
 
-static int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
+int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
 			 struct iw_freq *fwrq, char *extra)
 {
 	struct lbs_private *priv = dev->ml_priv;
@@ -422,18 +383,6 @@
 	return 0;
 }
 
-static int mesh_wlan_get_mode(struct net_device *dev,
-		              struct iw_request_info *info, u32 * uwrq,
-			      char *extra)
-{
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	*uwrq = IW_MODE_REPEAT;
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
 static int lbs_get_txpow(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_param *vwrq, char *extra)
@@ -838,7 +787,7 @@
 	return 0;
 }
 
-static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
+struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 {
 	enum {
 		POOR = 30,
@@ -1010,58 +959,6 @@
 	return ret;
 }
 
-static int lbs_mesh_set_freq(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_freq *fwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	struct chan_freq_power *cfp;
-	int ret = -EINVAL;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	/* If setting by frequency, convert to a channel */
-	if (fwrq->e == 1) {
-		long f = fwrq->m / 100000;
-
-		cfp = find_cfp_by_band_and_freq(priv, 0, f);
-		if (!cfp) {
-			lbs_deb_wext("invalid freq %ld\n", f);
-			goto out;
-		}
-
-		fwrq->e = 0;
-		fwrq->m = (int) cfp->channel;
-	}
-
-	/* Setting by channel number */
-	if (fwrq->m > 1000 || fwrq->e > 0) {
-		goto out;
-	}
-
-	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, fwrq->m);
-	if (!cfp) {
-		goto out;
-	}
-
-	if (fwrq->m != priv->channel) {
-		lbs_deb_wext("mesh channel change forces eth disconnect\n");
-		if (priv->mode == IW_MODE_INFRA)
-			lbs_cmd_80211_deauthenticate(priv,
-						     priv->curbssparams.bssid,
-						     WLAN_REASON_DEAUTH_LEAVING);
-		else if (priv->mode == IW_MODE_ADHOC)
-			lbs_adhoc_stop(priv);
-	}
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, fwrq->m);
-	lbs_update_channel(priv);
-	ret = 0;
-
-out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
 static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
@@ -2110,60 +2007,6 @@
 	return ret;
 }
 
-static int lbs_mesh_get_essid(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	memcpy(extra, priv->mesh_ssid, priv->mesh_ssid_len);
-
-	dwrq->length = priv->mesh_ssid_len;
-
-	dwrq->flags = 1;	/* active */
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-	return 0;
-}
-
-static int lbs_mesh_set_essid(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct lbs_private *priv = dev->ml_priv;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	if (!priv->radio_on) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* Check the size of the string */
-	if (dwrq->length > IEEE80211_MAX_SSID_LEN) {
-		ret = -E2BIG;
-		goto out;
-	}
-
-	if (!dwrq->flags || !dwrq->length) {
-		ret = -EINVAL;
-		goto out;
-	} else {
-		/* Specific SSID requested */
-		memcpy(priv->mesh_ssid, extra, dwrq->length);
-		priv->mesh_ssid_len = dwrq->length;
-	}
-
-	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-			priv->channel);
- out:
-	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-	return ret;
-}
-
 /**
  *  @brief Connect to the AP or Ad-hoc Network with specific bssid
  *
@@ -2270,71 +2113,8 @@
 	(iw_handler) NULL,		/* SIOCSIWPMKSA */
 };
 
-static const iw_handler mesh_wlan_handler[] = {
-	(iw_handler) NULL,	/* SIOCSIWCOMMIT */
-	(iw_handler) lbs_get_name,	/* SIOCGIWNAME */
-	(iw_handler) NULL,	/* SIOCSIWNWID */
-	(iw_handler) NULL,	/* SIOCGIWNWID */
-	(iw_handler) lbs_mesh_set_freq,	/* SIOCSIWFREQ */
-	(iw_handler) lbs_get_freq,	/* SIOCGIWFREQ */
-	(iw_handler) NULL,		/* SIOCSIWMODE */
-	(iw_handler) mesh_wlan_get_mode,	/* SIOCGIWMODE */
-	(iw_handler) NULL,	/* SIOCSIWSENS */
-	(iw_handler) NULL,	/* SIOCGIWSENS */
-	(iw_handler) NULL,	/* SIOCSIWRANGE */
-	(iw_handler) lbs_get_range,	/* SIOCGIWRANGE */
-	(iw_handler) NULL,	/* SIOCSIWPRIV */
-	(iw_handler) NULL,	/* SIOCGIWPRIV */
-	(iw_handler) NULL,	/* SIOCSIWSTATS */
-	(iw_handler) NULL,	/* SIOCGIWSTATS */
-	iw_handler_set_spy,	/* SIOCSIWSPY */
-	iw_handler_get_spy,	/* SIOCGIWSPY */
-	iw_handler_set_thrspy,	/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,	/* SIOCGIWTHRSPY */
-	(iw_handler) NULL,	/* SIOCSIWAP */
-	(iw_handler) NULL,	/* SIOCGIWAP */
-	(iw_handler) NULL,	/* SIOCSIWMLME */
-	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
-	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
-	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
-	(iw_handler) lbs_mesh_set_essid,/* SIOCSIWESSID */
-	(iw_handler) lbs_mesh_get_essid,/* SIOCGIWESSID */
-	(iw_handler) NULL,		/* SIOCSIWNICKN */
-	(iw_handler) mesh_get_nick,	/* SIOCGIWNICKN */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) lbs_set_rate,	/* SIOCSIWRATE */
-	(iw_handler) lbs_get_rate,	/* SIOCGIWRATE */
-	(iw_handler) lbs_set_rts,	/* SIOCSIWRTS */
-	(iw_handler) lbs_get_rts,	/* SIOCGIWRTS */
-	(iw_handler) lbs_set_frag,	/* SIOCSIWFRAG */
-	(iw_handler) lbs_get_frag,	/* SIOCGIWFRAG */
-	(iw_handler) lbs_set_txpow,	/* SIOCSIWTXPOW */
-	(iw_handler) lbs_get_txpow,	/* SIOCGIWTXPOW */
-	(iw_handler) lbs_set_retry,	/* SIOCSIWRETRY */
-	(iw_handler) lbs_get_retry,	/* SIOCGIWRETRY */
-	(iw_handler) lbs_set_encode,	/* SIOCSIWENCODE */
-	(iw_handler) lbs_get_encode,	/* SIOCGIWENCODE */
-	(iw_handler) lbs_set_power,	/* SIOCSIWPOWER */
-	(iw_handler) lbs_get_power,	/* SIOCGIWPOWER */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) lbs_set_genie,	/* SIOCSIWGENIE */
-	(iw_handler) lbs_get_genie,	/* SIOCGIWGENIE */
-	(iw_handler) lbs_set_auth,	/* SIOCSIWAUTH */
-	(iw_handler) lbs_get_auth,	/* SIOCGIWAUTH */
-	(iw_handler) lbs_set_encodeext,/* SIOCSIWENCODEEXT */
-	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,		/* SIOCSIWPMKSA */
-};
 struct iw_handler_def lbs_handler_def = {
 	.num_standard	= ARRAY_SIZE(lbs_handler),
 	.standard	= (iw_handler *) lbs_handler,
 	.get_wireless_stats = lbs_get_wireless_stats,
 };
-
-struct iw_handler_def mesh_handler_def = {
-	.num_standard	= ARRAY_SIZE(mesh_wlan_handler),
-	.standard	= (iw_handler *) mesh_wlan_handler,
-	.get_wireless_stats = lbs_get_wireless_stats,
-};
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -4,6 +4,14 @@
 #ifndef	_LBS_WEXT_H_
 #define	_LBS_WEXT_H_
 
+
+struct lbs_private;
+struct net_device;
+struct iw_request_info;
+struct iw_freq;
+struct iw_statistics;
+
+
 void lbs_send_disconnect_notification(struct lbs_private *priv);
 void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
 
@@ -14,4 +22,9 @@
 
 extern struct iw_handler_def lbs_handler_def;
 
+int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
+	struct iw_freq *fwrq, char *extra);
+struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev);
+
+
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/persistcfg.c
+++ linux-wl/drivers/net/wireless/libertas/persistcfg.c
@@ -9,6 +9,7 @@
 #include "mesh.h"
 #include "decl.h"
 #include "cmd.h"
+#include "wext.h"
 
 
 /***************************************************************************
@@ -1059,6 +1060,294 @@
 
 
 /***************************************************************************
+ * WEXT related
+ */
+
+/**
+ *  @brief Find the channel frequency power info with specific frequency
+ *
+ *  @param priv 	A pointer to struct lbs_private structure
+ *  @param band		it can be BAND_A, BAND_G or BAND_B
+ *  @param freq	        the frequency for looking
+ *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
+ */
+static struct chan_freq_power *find_cfp_by_band_and_freq(
+	struct lbs_private *priv,
+	u8 band,
+	u32 freq)
+{
+	struct chan_freq_power *cfp = NULL;
+	struct region_channel *rc;
+	int i, j;
+
+	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
+		rc = &priv->region_channel[j];
+
+		if (!rc->valid || !rc->CFP)
+			continue;
+		if (rc->band != band)
+			continue;
+		for (i = 0; i < rc->nrcfp; i++) {
+			if (rc->CFP[i].freq == freq) {
+				cfp = &rc->CFP[i];
+				break;
+			}
+		}
+	}
+
+	if (!cfp && freq)
+		lbs_deb_wext("find_cfp_by_band_and_freql: can't find cfp by "
+		       "band %d / freq %d\n", band, freq);
+
+	return cfp;
+}
+
+/**
+ *  @brief Find the channel frequency power info with specific channel
+ *
+ *  @param priv 	A pointer to struct lbs_private structure
+ *  @param band		it can be BAND_A, BAND_G or BAND_B
+ *  @param channel      the channel for looking
+ *  @return 	   	A pointer to struct chan_freq_power structure or NULL if not find.
+ */
+struct chan_freq_power *lbs_find_cfp_by_band_and_channel(
+	struct lbs_private *priv,
+	u8 band,
+	u16 channel)
+{
+	struct chan_freq_power *cfp = NULL;
+	struct region_channel *rc;
+	int i, j;
+
+	for (j = 0; !cfp && (j < ARRAY_SIZE(priv->region_channel)); j++) {
+		rc = &priv->region_channel[j];
+
+		if (!rc->valid || !rc->CFP)
+			continue;
+		if (rc->band != band)
+			continue;
+		for (i = 0; i < rc->nrcfp; i++) {
+			if (rc->CFP[i].channel == channel) {
+				cfp = &rc->CFP[i];
+				break;
+			}
+		}
+	}
+
+	if (!cfp && channel)
+		lbs_deb_wext("lbs_find_cfp_by_band_and_channel: can't find "
+		       "cfp by band %d / channel %d\n", band, channel);
+
+	return cfp;
+}
+
+static int lbs_mesh_set_freq(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_freq *fwrq, char *extra)
+{
+	struct lbs_private *priv = dev->ml_priv;
+	struct chan_freq_power *cfp;
+	int ret = -EINVAL;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	/* If setting by frequency, convert to a channel */
+	if (fwrq->e == 1) {
+		long f = fwrq->m / 100000;
+
+		cfp = find_cfp_by_band_and_freq(priv, 0, f);
+		if (!cfp) {
+			lbs_deb_wext("invalid freq %ld\n", f);
+			goto out;
+		}
+
+		fwrq->e = 0;
+		fwrq->m = (int) cfp->channel;
+	}
+
+	/* Setting by channel number */
+	if (fwrq->m > 1000 || fwrq->e > 0)
+		goto out;
+
+	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, fwrq->m);
+	if (!cfp)
+		goto out;
+
+	if (fwrq->m != priv->channel) {
+		lbs_deb_wext("mesh channel change forces eth disconnect\n");
+		if (priv->mode == IW_MODE_INFRA)
+			lbs_cmd_80211_deauthenticate(priv,
+				priv->curbssparams.bssid,
+				WLAN_REASON_DEAUTH_LEAVING);
+		else if (priv->mode == IW_MODE_ADHOC)
+			lbs_adhoc_stop(priv);
+	}
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START, fwrq->m);
+	lbs_update_channel(priv);
+	ret = 0;
+
+out:
+	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+	return ret;
+}
+
+static int mesh_wlan_get_mode(struct net_device *dev,
+	struct iw_request_info *info, u32 * uwrq,
+	char *extra)
+{
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	*uwrq = IW_MODE_REPEAT;
+
+	lbs_deb_leave(LBS_DEB_WEXT);
+	return 0;
+}
+
+static int lbs_mesh_set_essid(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct lbs_private *priv = dev->ml_priv;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	if (!priv->radio_on) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Check the size of the string */
+	if (dwrq->length > IEEE80211_MAX_SSID_LEN) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	if (!dwrq->flags || !dwrq->length) {
+		ret = -EINVAL;
+		goto out;
+	} else {
+		/* Specific SSID requested */
+		memcpy(priv->mesh_ssid, extra, dwrq->length);
+		priv->mesh_ssid_len = dwrq->length;
+	}
+
+	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
+			priv->channel);
+ out:
+	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+	return ret;
+}
+
+static int lbs_mesh_get_essid(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct lbs_private *priv = dev->ml_priv;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	memcpy(extra, priv->mesh_ssid, priv->mesh_ssid_len);
+
+	dwrq->length = priv->mesh_ssid_len;
+
+	dwrq->flags = 1;	/* active */
+
+	lbs_deb_leave(LBS_DEB_WEXT);
+	return 0;
+}
+
+
+static int mesh_get_nick(struct net_device *dev, struct iw_request_info *info,
+			 struct iw_point *dwrq, char *extra)
+{
+	struct lbs_private *priv = dev->ml_priv;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	/* Use nickname to indicate that mesh is on */
+
+	if (priv->mesh_connect_status == LBS_CONNECTED) {
+		strncpy(extra, "Mesh", 12);
+		extra[12] = '\0';
+		dwrq->length = strlen(extra);
+	}
+
+	else {
+		extra[0] = '\0';
+		dwrq->length = 0;
+	}
+
+	lbs_deb_leave(LBS_DEB_WEXT);
+	return 0;
+}
+
+
+static const iw_handler mesh_wlan_handler[] = {
+	(iw_handler) NULL,	/* SIOCSIWCOMMIT */
+	(iw_handler) NULL, 	/* SIOCGIWNAME, was lbs_get_name */
+	(iw_handler) NULL,	/* SIOCSIWNWID */
+	(iw_handler) NULL,	/* SIOCGIWNWID */
+	(iw_handler) lbs_mesh_set_freq,	/* SIOCSIWFREQ */
+	(iw_handler) lbs_get_freq,	/* SIOCGIWFREQ */
+	(iw_handler) NULL,		/* SIOCSIWMODE */
+	(iw_handler) mesh_wlan_get_mode,	/* SIOCGIWMODE */
+	(iw_handler) NULL,	/* SIOCSIWSENS */
+	(iw_handler) NULL,	/* SIOCGIWSENS */
+	(iw_handler) NULL,	/* SIOCSIWRANGE */
+	(iw_handler) NULL,	/* SIOCGIWRANGE, was lbs_get_range */
+	(iw_handler) NULL,	/* SIOCSIWPRIV */
+	(iw_handler) NULL,	/* SIOCGIWPRIV */
+	(iw_handler) NULL,	/* SIOCSIWSTATS */
+	(iw_handler) NULL,	/* SIOCGIWSTATS */
+	iw_handler_set_spy,	/* SIOCSIWSPY */
+	iw_handler_get_spy,	/* SIOCGIWSPY */
+	iw_handler_set_thrspy,	/* SIOCSIWTHRSPY */
+	iw_handler_get_thrspy,	/* SIOCGIWTHRSPY */
+	(iw_handler) NULL,	/* SIOCSIWAP */
+	(iw_handler) NULL,	/* SIOCGIWAP */
+	(iw_handler) NULL,	/* SIOCSIWMLME */
+	(iw_handler) NULL,	/* SIOCGIWAPLIST - deprecated */
+	(iw_handler) lbs_set_scan,	/* SIOCSIWSCAN */
+	(iw_handler) lbs_get_scan,	/* SIOCGIWSCAN */
+	(iw_handler) lbs_mesh_set_essid,/* SIOCSIWESSID */
+	(iw_handler) lbs_mesh_get_essid,/* SIOCGIWESSID */
+	(iw_handler) NULL,	/* SIOCSIWNICKN */
+	(iw_handler) mesh_get_nick,	/* SIOCGIWNICKN */
+	(iw_handler) NULL,	/* -- hole -- */
+	(iw_handler) NULL,	/* -- hole -- */
+	(iw_handler) NULL,	/* SIOCSIWRATE, was lbs_set_rate */
+	(iw_handler) NULL,	/* SIOCGIWRATE, was lbs_get_rate */
+	(iw_handler) NULL,	/* SIOCSIWRTS, was lbs_set_rts */
+	(iw_handler) NULL,	/* SIOCGIWRTS, was lbs_get_rts */
+	(iw_handler) NULL,	/* SIOCSIWFRAG, was lbs_set_frag */
+	(iw_handler) NULL,	/* SIOCGIWFRAG, was lbs_get_frag */
+	(iw_handler) NULL,	/* SIOCSIWTXPOW, was lbs_set_txpow */
+	(iw_handler) NULL,	/* SIOCGIWTXPOW, was lbs_get_txpow */
+	(iw_handler) NULL,	/* SIOCSIWRETRY, was lbs_set_retry */
+	(iw_handler) NULL,	/* SIOCGIWRETRY, was lbs_get_retry */
+	(iw_handler) NULL,	/* SIOCSIWENCODE, was lbs_set_encode */
+	(iw_handler) NULL,	/* SIOCGIWENCODE, was lbs_get_encode */
+	(iw_handler) NULL,	/* SIOCSIWPOWER, was lbs_set_power */
+	(iw_handler) NULL,	/* SIOCGIWPOWER, was lbs_get_power */
+	(iw_handler) NULL,	/* -- hole -- */
+	(iw_handler) NULL,	/* -- hole -- */
+	(iw_handler) NULL,	/* SIOCSIWGENIE, was lbs_set_genie */
+	(iw_handler) NULL,	/* SIOCGIWGENIE, lbs_get_genie */
+	(iw_handler) NULL,	/* SIOCSIWAUTH, lbs_set_auth */
+	(iw_handler) NULL,	/* SIOCGIWAUTH, lbs_get_auth */
+	(iw_handler) NULL,	/* SIOCSIWENCODEEXT, was lbs_set_encodeext */
+	(iw_handler) NULL,	/* SIOCGIWENCODEEXT, was lbs_get_encodeext */
+	(iw_handler) NULL,	/* SIOCSIWPMKSA */
+};
+struct iw_handler_def mesh_handler_def = {
+	.num_standard	= ARRAY_SIZE(mesh_wlan_handler),
+	.standard	= (iw_handler *) mesh_wlan_handler,
+	.get_wireless_stats = lbs_get_wireless_stats,
+};
+
+
+/***************************************************************************
  * Ethtool related
  */
 

-- 
http://www.holgerschurig.de
