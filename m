Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.orange.fr ([80.12.242.100]:57359 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYGDIsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 04:48:05 -0400
Date: Fri, 4 Jul 2008 10:49:31 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: [PATCH] mac80211: power management wext hooks (was [PATCH 1/2]
	mac80211: add power management support)
Message-ID: <20080704084930.GA3061@sortiz.org> (sfid-20080704_104814_996713_85E1E3C3)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <200711161929.36283.mboton.lkml@gmail.com> <200711161953.26801.mboton.lkml@gmail.com> <20080626174058.GA3063@sortiz.org> <20080626175507.GA23142@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080626175507.GA23142@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, Jun 26, 2008 at 01:55:07PM -0400, John W. Linville wrote:
> > > This patch adds power management support in mac80211.
> > Sorry for being late to the game, but would a similar patch against your
> > -next-2.6 tree be considered for inclusion ?
> 
> It seems like a reasonable start to me.  Anyone else have comments?
Here is my version then, against your wireless-next tree:

This patch implements the power management routines wireless extensions
for mac80211.
For now we only support switching PS mode between on and off.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/wext.c    |   43 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

Index: wireless-next-2.6/net/mac80211/wext.c
===================================================================
--- wireless-next-2.6.orig/net/mac80211/wext.c	2008-07-04 10:05:46.000000000 +0200
+++ wireless-next-2.6/net/mac80211/wext.c	2008-07-04 10:42:03.000000000 +0200
@@ -1000,6 +1000,45 @@ static int ieee80211_ioctl_giwencode(str
 	return 0;
 }
 
+static int ieee80211_ioctl_siwpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    struct iw_param *wrq,
+				    char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (wrq->disabled) {
+		conf->flags &= ~IEEE80211_CONF_PS;
+		return ieee80211_hw_config(local);
+	}
+
+	switch (wrq->flags & IW_POWER_MODE) {
+	case IW_POWER_ON:       /* If not specified */
+	case IW_POWER_MODE:     /* If set all mask */
+	case IW_POWER_ALL_R:    /* If explicitely state all */
+		conf->flags |= IEEE80211_CONF_PS;
+		break;
+	default:                /* Otherwise we don't support it */
+		return -EINVAL;
+	}
+
+	return ieee80211_hw_config(local);
+}
+
+static int ieee80211_ioctl_giwpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *wrqu,
+				    char *extra)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	wrqu->power.disabled = !(conf->flags & IEEE80211_CONF_PS);
+
+	return 0;
+}
+
 static int ieee80211_ioctl_siwauth(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_param *data, char *extra)
@@ -1202,8 +1241,8 @@ static const iw_handler ieee80211_handle
 	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
 	(iw_handler) ieee80211_ioctl_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) NULL,				/* SIOCSIWPOWER */
-	(iw_handler) NULL,				/* SIOCGIWPOWER */
+	(iw_handler) ieee80211_ioctl_siwpower,		/* SIOCSIWPOWER */
+	(iw_handler) ieee80211_ioctl_giwpower,		/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) ieee80211_ioctl_siwgenie,		/* SIOCSIWGENIE */
Index: wireless-next-2.6/include/net/mac80211.h
===================================================================
--- wireless-next-2.6.orig/include/net/mac80211.h	2008-07-04 10:05:45.000000000 +0200
+++ wireless-next-2.6/include/net/mac80211.h	2008-07-04 10:42:03.000000000 +0200
@@ -396,11 +396,13 @@ struct ieee80211_rx_status {
  * @IEEE80211_CONF_SHORT_SLOT_TIME: use 802.11g short slot time
  * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
  * @IEEE80211_CONF_SUPPORT_HT_MODE: use 802.11n HT capabilities (if supported)
+ * @IEEE80211_CONF_PS: Enable 802.11 power save mode
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_SHORT_SLOT_TIME	= (1<<0),
 	IEEE80211_CONF_RADIOTAP		= (1<<1),
 	IEEE80211_CONF_SUPPORT_HT_MODE	= (1<<2),
+	IEEE80211_CONF_PS		= (1<<3),
 };
 
 /**

