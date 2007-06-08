Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:63002 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762575AbXFHAoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 20:44:14 -0400
Date: Thu, 07 Jun 2007 19:43:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
Message-ID: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
adds the missing routine. It supports the 'auto' keyword, fixed rates,
and the combination of 'auto' and a fixed rate to select an upper bound.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 ieee80211_ioctl.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -2013,6 +2013,55 @@ static int ieee80211_ioctl_giwscan(struc
 }
 
 
+static int ieee80211_ioctl_siwrate(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *rate, char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw_mode *mode;
+	int i;
+	u32 target_rate = rate->value / 100000;
+	u32 supp = 0;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	mode = local->oper_hw_mode;
+	/* value = -1, rate->fixed = 0 means auto only, so use all rates
+	 * value = X, rate->fixed = 1 means only rate X
+	 * value = X, rate->fixed = 0 means all rates <= X */
+	for (i=0; i< mode->num_rates; i++) {
+		struct ieee80211_rate *rates = &mode->rates[i];
+		int target = rates->rate;
+
+		if (mode->mode == MODE_ATHEROS_TURBO ||
+		    mode->mode == MODE_ATHEROS_TURBOG)
+			target *= 2;
+		if ((target_rate == target) && rate->fixed) {
+			supp |= BIT(i);
+			sdata->u.ap.force_unicast_rateidx = i;
+			sdata->u.ap.max_ratectrl_rateidx = i;
+			break;
+		}
+		if ((!rate->fixed && (target <= target_rate)) || (rate->value < 0)) {
+			supp |= BIT(i);
+			sdata->u.ap.force_unicast_rateidx = -1;
+			if (target_rate == target)
+				sdata->u.ap.max_ratectrl_rateidx = i;
+		}
+	}
+	sdata->u.sta.supp_rates_bits = supp;
+	if (sdata->type == IEEE80211_IF_TYPE_STA) {
+		sta = sta_info_get(local, sdata->u.sta.bssid);
+		if (sta) {
+			sta->txrate = sdata->u.ap.max_ratectrl_rateidx;
+			sta->supp_rates = supp;
+			sta_info_put(sta);
+		}
+	}
+	return 0;
+}
+
 static int ieee80211_ioctl_giwrate(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rate, char *extra)
@@ -3159,7 +3208,7 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* SIOCGIWNICKN */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* SIOCSIWRATE */
+	(iw_handler) ieee80211_ioctl_siwrate,		/* SIOCSIWRATE */
 	(iw_handler) ieee80211_ioctl_giwrate,		/* SIOCGIWRATE */
 	(iw_handler) ieee80211_ioctl_siwrts,		/* SIOCSIWRTS */
 	(iw_handler) ieee80211_ioctl_giwrts,		/* SIOCGIWRTS */
