Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:48476 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXEZQOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 12:14:42 -0400
Date: Sat, 26 May 2007 11:14:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC/T] mac80211: Implementation of SIOCSIWRATE
Message-ID: <46585cd1.xDmttJDPjdAQW3Wz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: mabbas@linux.intel.com

The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
adds the missing routine. It supports the 'auto' keyword, fixed rates,
and the combination of 'auto' and a fixed rate to select an upper bound.

Signed-off-by: mabbas@linux.intel.com
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -2013,6 +2013,54 @@ static int ieee80211_ioctl_giwscan(struc
 }
 
 
+static int ieee80211_ioctl_siwrate(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *rate, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
+	int i;
+	u32 target_rate = rate->value /100000;
+	u32 fixed = rate->fixed;
+	u32 supp = 0;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta = NULL;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	mode = local->oper_hw_mode;
+	if (sdata->type != IEEE80211_IF_TYPE_STA)
+		return -EOPNOTSUPP;
+	sta = sta_info_get(local, sdata->u.sta.bssid);
+	if (!sta)
+		return -ENODEV;
+	/* value = -1, fixed = 0 means auto only, so we should use
+	 * all rates offered by AP
+	 * value = X, fixed = 1 means only rate X
+	 * value = X, fixed = 0 means all rates lower equal X */
+	for (i=0; i< mode->num_rates; i++) {
+		struct ieee80211_rate *rates = &mode->rates[i];
+		int target = rates->rate;
+
+		if (mode->mode == MODE_ATHEROS_TURBO ||
+		    mode->mode == MODE_ATHEROS_TURBOG)
+			target *= 2;
+		if ((target_rate == target) && fixed) {
+			supp |= BIT(i);
+			sta->txrate = i;
+			break;
+		}
+		if ((!fixed && (target_rate >= target)) || (rate->value < 0)) {
+			supp |= BIT(i);
+			if (target_rate == target)
+				sta->txrate = i;
+		}
+	}
+	sdata->u.sta.restricted_tx_rates = supp;
+	sta->restricted_tx_rates = supp;
+	sta_info_put(sta);
+	return 0;
+};
+
 static int ieee80211_ioctl_giwrate(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rate, char *extra)
@@ -3159,7 +3207,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWNICKN */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* SIOCSIWRATE */
+	(iw_handler) ieee80211_ioctl_siwrate,		/* SIOCSIWRATE */
 	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
 	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
 	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
Index: wireless-dev/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_i.h
+++ wireless-dev/net/mac80211/ieee80211_i.h
@@ -269,6 +269,7 @@ struct ieee80211_if_sta {
 	unsigned long ibss_join_req;
 	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
 	u32 supp_rates_bits;
+	u32 restricted_tx_rates; /* bitmap of user restricted tx rate */
 
 	int wmm_last_param_set;
 };
Index: wireless-dev/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c
+++ wireless-dev/net/mac80211/ieee80211_sta.c
@@ -1255,7 +1255,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 				rates |= BIT(j);
 	}
 	sta->supp_rates = rates;
-
+	sta->restricted_tx_rates = ifsta->restricted_tx_rates;
 	if (elems.ht_extra_param && elems.ht_cap_param && elems.wmm_param &&
 	    ifsta->ht_enabled && local->ops->conf_ht){
 		int rc;
@@ -1500,6 +1500,7 @@ static void ieee80211_rx_bss_info(struct
 			 * supported to avoid issues with TX rate ctrl. */
 			sta->supp_rates = sdata->u.sta.supp_rates_bits;
 		}
+		sta->restricted_tx_rates = sdata->u.sta.restricted_tx_rates;
 		if (sta->supp_rates != prev_rates) {
 			printk(KERN_DEBUG "%s: updated supp_rates set for "
 			       MAC_FMT " based on beacon info (0x%x & 0x%x -> "
@@ -3176,6 +3177,8 @@ struct sta_info * ieee80211_ibss_add_sta
 		return NULL;
 
 	sta->supp_rates = sdata->u.sta.supp_rates_bits;
+	/* restricted suup rate if the user specifies it */
+	sta->restricted_tx_rates= sdata->u.sta.restricted_tx_rates;
 
 	rate_control_rate_init(sta, local);
 
Index: wireless-dev/net/mac80211/rc80211_simple.c
===================================================================
--- wireless-dev.orig/net/mac80211/rc80211_simple.c
+++ wireless-dev/net/mac80211/rc80211_simple.c
@@ -38,6 +38,7 @@ static void rate_control_rate_inc(struct
 	struct ieee80211_hw_mode *mode;
 	int i = sta->txrate;
 	int maxrate;
+	u32 supp;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
@@ -45,6 +46,9 @@ static void rate_control_rate_inc(struct
 		return;
 	}
 
+	supp = sta->supp_rates & sta->restricted_tx_rates;
+	if (supp == 0)
+		supp = sta->supp_rates;
 	mode = local->oper_hw_mode;
 	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
 
@@ -53,7 +57,7 @@ static void rate_control_rate_inc(struct
 
 	while (i + 1 < mode->num_rates) {
 		i++;
-		if (sta->supp_rates & BIT(i) &&
+		if (supp & BIT(i) &&
 		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
 		    (maxrate < 0 || i <= maxrate)) {
 			sta->txrate = i;
@@ -69,6 +73,7 @@ static void rate_control_rate_dec(struct
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hw_mode *mode;
 	int i = sta->txrate;
+	u32 supp;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
@@ -80,9 +85,12 @@ static void rate_control_rate_dec(struct
 	if (i > mode->num_rates)
 		i = mode->num_rates;
 
+	supp = sta->supp_rates & sta->restricted_tx_rates;
+	if (supp == 0)
+		supp = sta->supp_rates;
 	while (i > 0) {
 		i--;
-		if (sta->supp_rates & BIT(i) &&
+		if (supp & BIT(i) &&
 		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
 			sta->txrate = i;
 			break;
@@ -234,6 +242,7 @@ rate_control_simple_get_rate(void *priv,
 	struct sta_info *sta;
 	int rateidx, nonerp_idx;
 	u16 fc;
+	u32 supp;
 
 	memset(extra, 0, sizeof(*extra));
 
@@ -261,11 +270,14 @@ rate_control_simple_get_rate(void *priv,
 		rateidx = mode->num_rates - 1;
 
 	sta->last_txrate = rateidx;
+	supp = sta->supp_rates & sta->restricted_tx_rates;
+	if (supp == 0)
+		supp = sta->supp_rates;
 	nonerp_idx = rateidx;
 	while (nonerp_idx > 0 &&
 	       ((mode->rates[nonerp_idx].flags & IEEE80211_RATE_ERP) ||
 		!(mode->rates[nonerp_idx].flags & IEEE80211_RATE_SUPPORTED) ||
-		!(sta->supp_rates & BIT(nonerp_idx))))
+		!(supp & BIT(nonerp_idx))))
 		nonerp_idx--;
 	extra->nonerp = &mode->rates[nonerp_idx];
 
@@ -281,14 +293,19 @@ static void rate_control_simple_rate_ini
 {
 	struct ieee80211_hw_mode *mode;
 	int i;
+	u32 supp;
+
 	sta->txrate = 0;
 	mode = local->oper_hw_mode;
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
 	 * after assoc.. */
+	supp = sta->supp_rates & sta->restricted_tx_rates;
+	if (supp == 0)
+		supp = sta->supp_rates;
 	for (i = 0; i < mode->num_rates; i++) {
-		if ((sta->supp_rates & BIT(i)) &&
+		if ((supp & BIT(i)) &&
 		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
 			sta->txrate = i;
 	}
Index: wireless-dev/net/mac80211/sta_info.h
===================================================================
--- wireless-dev.orig/net/mac80211/sta_info.h
+++ wireless-dev/net/mac80211/sta_info.h
@@ -58,6 +58,9 @@ struct sta_info {
 	unsigned int wep_weak_iv_count; /* number of RX frames with weak IV */
 
 	unsigned long last_rx;
+	u32 restricted_tx_rates; /* bitmap of user restricted tx rates in
+				  * u.sta.restricted_tx_rates, if 0 use all
+				  * available rates */
 	u32 supp_rates; /* bitmap of supported rates in local->curr_rates */
 	int txrate; /* index in local->curr_rates */
 	int last_txrate; /* last rate used to send a frame to this STA */
