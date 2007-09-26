Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbXIZNZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:25:01 -0400
Message-Id: <20070926132136.132114000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 10/12] mac80211: remove all prism2 ioctls
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all prism2 ioctls.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
I intend to maintain a quilt or git tree that has the
necessary code to get hostapd working, but having this
in wireless-2.6 at the same time is a bit icky since
I will end up removing it piece by piece.

 net/mac80211/hostapd_ioctl.h   |   61 ---------
 net/mac80211/ieee80211_i.h     |    5 
 net/mac80211/ieee80211_ioctl.c |  272 -----------------------------------------
 net/mac80211/ieee80211_sta.c   |    1 
 4 files changed, 339 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-26 12:09:06.705337487 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-26 14:38:16.958936654 +0200
@@ -21,46 +21,11 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-#include "hostapd_ioctl.h"
 #include "ieee80211_rate.h"
 #include "wpa.h"
 #include "aes_ccm.h"
 
 
-/*
- * Wow. This ioctl interface is such crap, it's tied
- * to internal definitions. I hope it dies soon.
- */
-static int mode_to_hostapd_mode(enum ieee80211_phymode mode)
-{
-	switch (mode) {
-	case MODE_IEEE80211A:
-		return 0;
-	case MODE_IEEE80211B:
-		return 1;
-	case MODE_IEEE80211G:
-		return 3;
-	case NUM_IEEE80211_MODES:
-		WARN_ON(1);
-		break;
-	}
-	WARN_ON(1);
-	return -1;
-}
-
-static enum ieee80211_phymode hostapd_mode_to_mode(int hostapd_mode)
-{
-	switch (hostapd_mode) {
-	case 0:
-		return MODE_IEEE80211A;
-	case 1:
-		return MODE_IEEE80211B;
-	case 3:
-		return MODE_IEEE80211G;
-	}
-	return NUM_IEEE80211_MODES;
-}
-
 static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
 				    int idx, int alg, int set_tx_key,
 				    const u8 *_key, size_t key_len)
@@ -347,11 +312,6 @@ int ieee80211_set_channel(struct ieee802
 			struct ieee80211_channel *chan = &mode->channels[c];
 			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
 			    ((chan->chan == channel) || (chan->freq == freq))) {
-				/* Use next_mode as the mode preference to
-				 * resolve non-unique channel numbers. */
-				if (set && mode->mode != local->next_mode)
-					continue;
-
 				local->oper_channel = chan;
 				local->oper_hw_mode = mode;
 				set++;
@@ -844,220 +804,6 @@ static int ieee80211_ioctl_giwretry(stru
 	return 0;
 }
 
-static int ieee80211_ioctl_prism2_param(struct net_device *dev,
-					struct iw_request_info *info,
-					void *wrqu, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
-	int *i = (int *) extra;
-	int param = *i;
-	int value = *(i + 1);
-	int ret = 0;
-	int mode;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	switch (param) {
-	case PRISM2_PARAM_IEEE_802_1X:
-		if (local->ops->set_ieee8021x)
-			ret = local->ops->set_ieee8021x(local_to_hw(local),
-							value);
-		if (ret)
-			printk(KERN_DEBUG "%s: failed to set IEEE 802.1X (%d) "
-			       "for low-level driver\n", dev->name, value);
-		else
-			sdata->ieee802_1x = value;
-		break;
-
-	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
-		if (sdata->type == IEEE80211_IF_TYPE_AP) {
-			if (value)
-				sdata->flags |= IEEE80211_SDATA_USE_PROTECTION;
-			else
-				sdata->flags &= ~IEEE80211_SDATA_USE_PROTECTION;
-			ieee80211_erp_info_change_notify(dev,
-					IEEE80211_ERP_CHANGE_PROTECTION);
-		} else {
-			ret = -ENOENT;
-		}
-		break;
-
-	case PRISM2_PARAM_PREAMBLE:
-		if (sdata->type == IEEE80211_IF_TYPE_AP) {
-			if (value)
-				sdata->flags |= IEEE80211_SDATA_SHORT_PREAMBLE;
-			else
-				sdata->flags &= ~IEEE80211_SDATA_SHORT_PREAMBLE;
-			ieee80211_erp_info_change_notify(dev,
-					IEEE80211_ERP_CHANGE_PREAMBLE);
-		} else {
-			ret = -ENOENT;
-		}
-		break;
-
-	case PRISM2_PARAM_SHORT_SLOT_TIME:
-		if (value)
-			local->hw.conf.flags |= IEEE80211_CONF_SHORT_SLOT_TIME;
-		else
-			local->hw.conf.flags &= ~IEEE80211_CONF_SHORT_SLOT_TIME;
-		if (ieee80211_hw_config(local))
-			ret = -EINVAL;
-		break;
-
-	case PRISM2_PARAM_NEXT_MODE:
-		local->next_mode = hostapd_mode_to_mode(value);
-		break;
-
-	case PRISM2_PARAM_WIFI_WME_NOACK_TEST:
-		local->wifi_wme_noack_test = value;
-		break;
-
-	case PRISM2_PARAM_SCAN_FLAGS:
-		local->scan_flags = value;
-		break;
-
-	case PRISM2_PARAM_MIXED_CELL:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else {
-			if (value)
-				sdata->u.sta.flags |= IEEE80211_STA_MIXED_CELL;
-			else
-				sdata->u.sta.flags &= ~IEEE80211_STA_MIXED_CELL;
-		}
-		break;
-
-	case PRISM2_PARAM_HW_MODES:
-		mode = 1;
-		local->enabled_modes = 0;
-		while (value) {
-			if (value & 1)
-				local->enabled_modes |=
-					hostapd_mode_to_mode(mode);
-			mode <<= 1;
-			value >>= 1;
-		}
-		break;
-
-	case PRISM2_PARAM_CREATE_IBSS:
-		if (sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else {
-			if (value)
-				sdata->u.sta.flags |= IEEE80211_STA_CREATE_IBSS;
-			else
-				sdata->u.sta.flags &= ~IEEE80211_STA_CREATE_IBSS;
-		}
-		break;
-	case PRISM2_PARAM_WMM_ENABLED:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else {
-			if (value)
-				sdata->u.sta.flags |= IEEE80211_STA_WMM_ENABLED;
-			else
-				sdata->u.sta.flags &= ~IEEE80211_STA_WMM_ENABLED;
-		}
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
-
-
-static int ieee80211_ioctl_get_prism2_param(struct net_device *dev,
-					    struct iw_request_info *info,
-					    void *wrqu, char *extra)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
-	int *param = (int *) extra;
-	int ret = 0;
-	int mode;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	switch (*param) {
-	case PRISM2_PARAM_IEEE_802_1X:
-		*param = sdata->ieee802_1x;
-		break;
-
-	case PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES:
-		*param = !!(sdata->flags & IEEE80211_SDATA_USE_PROTECTION);
-		break;
-
-	case PRISM2_PARAM_PREAMBLE:
-		*param = !!(sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE);
-		break;
-
-	case PRISM2_PARAM_SHORT_SLOT_TIME:
-		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME);
-		break;
-
-	case PRISM2_PARAM_NEXT_MODE:
-		*param = local->next_mode;
-		break;
-
-	case PRISM2_PARAM_WIFI_WME_NOACK_TEST:
-		*param = local->wifi_wme_noack_test;
-		break;
-
-	case PRISM2_PARAM_SCAN_FLAGS:
-		*param = local->scan_flags;
-		break;
-
-	case PRISM2_PARAM_HW_MODES:
-		mode = 0;
-		*param = 0;
-		while (mode < NUM_IEEE80211_MODES) {
-			if (local->enabled_modes & (1<<mode))
-				*param |= mode_to_hostapd_mode(1<<mode);
-			mode++;
-		}
-		break;
-
-	case PRISM2_PARAM_CREATE_IBSS:
-		if (sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			*param = !!(sdata->u.sta.flags &
-					IEEE80211_STA_CREATE_IBSS);
-		break;
-
-	case PRISM2_PARAM_MIXED_CELL:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			*param = !!(sdata->u.sta.flags &
-					IEEE80211_STA_MIXED_CELL);
-		break;
-
-	case PRISM2_PARAM_WMM_ENABLED:
-		if (sdata->type != IEEE80211_IF_TYPE_STA &&
-		    sdata->type != IEEE80211_IF_TYPE_IBSS)
-			ret = -EINVAL;
-		else
-			*param = !!(sdata->u.sta.flags &
-					IEEE80211_STA_WMM_ENABLED);
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
-
 static int ieee80211_ioctl_siwmlme(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_point *data, char *extra)
@@ -1313,14 +1059,6 @@ static int ieee80211_ioctl_siwencodeext(
 }
 
 
-static const struct iw_priv_args ieee80211_ioctl_priv[] = {
-	{ PRISM2_IOCTL_PRISM2_PARAM,
-	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 2, 0, "param" },
-	{ PRISM2_IOCTL_GET_PRISM2_PARAM,
-	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	  IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "get_param" },
-};
-
 /* Structures to export the Wireless Handlers */
 
 static const iw_handler ieee80211_handler[] =
@@ -1383,19 +1121,9 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL,				/* -- hole -- */
 };
 
-static const iw_handler ieee80211_private_handler[] =
-{							/* SIOCIWFIRSTPRIV + */
-	(iw_handler) ieee80211_ioctl_prism2_param,	/* 0 */
-	(iw_handler) ieee80211_ioctl_get_prism2_param,	/* 1 */
-};
-
 const struct iw_handler_def ieee80211_iw_handler_def =
 {
 	.num_standard	= ARRAY_SIZE(ieee80211_handler),
-	.num_private	= ARRAY_SIZE(ieee80211_private_handler),
-	.num_private_args = ARRAY_SIZE(ieee80211_ioctl_priv),
 	.standard	= (iw_handler *) ieee80211_handler,
-	.private	= (iw_handler *) ieee80211_private_handler,
-	.private_args	= (struct iw_priv_args *) ieee80211_ioctl_priv,
 	.get_wireless_stats = ieee80211_get_wireless_stats,
 };
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-09-26 14:38:12.998936654 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,61 +0,0 @@
-/*
- * Host AP (software wireless LAN access point) user space daemon for
- * Host AP kernel driver
- * Copyright 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
- * Copyright 2002-2004, Instant802 Networks, Inc.
- * Copyright 2005, Devicescape Software, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef HOSTAPD_IOCTL_H
-#define HOSTAPD_IOCTL_H
-
-#ifdef __KERNEL__
-#include <linux/types.h>
-#endif /* __KERNEL__ */
-
-#define PRISM2_IOCTL_PRISM2_PARAM (SIOCIWFIRSTPRIV + 0)
-#define PRISM2_IOCTL_GET_PRISM2_PARAM (SIOCIWFIRSTPRIV + 1)
-#define PRISM2_IOCTL_HOSTAPD (SIOCIWFIRSTPRIV + 3)
-
-/* PRISM2_IOCTL_PRISM2_PARAM ioctl() subtypes:
- * This table is no longer added to, the whole sub-ioctl
- * mess shall be deleted completely. */
-enum {
-	PRISM2_PARAM_IEEE_802_1X = 23,
-
-	/* Instant802 additions */
-	PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES = 1001,
-	PRISM2_PARAM_PREAMBLE = 1003,
-	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
-	PRISM2_PARAM_NEXT_MODE = 1008,
-	PRISM2_PARAM_WIFI_WME_NOACK_TEST = 1033,
-	PRISM2_PARAM_SCAN_FLAGS = 1035,
-	PRISM2_PARAM_HW_MODES = 1036,
-	PRISM2_PARAM_CREATE_IBSS = 1037,
-	PRISM2_PARAM_WMM_ENABLED = 1038,
-	PRISM2_PARAM_MIXED_CELL = 1039,
-};
-
-/* Data structures used for get_hw_features ioctl */
-struct hostapd_ioctl_hw_modes_hdr {
-	int mode;
-	int num_channels;
-	int num_rates;
-};
-
-struct ieee80211_channel_data {
-	short chan; /* channel number (IEEE 802.11) */
-	short freq; /* frequency in MHz */
-	int flag; /* flag for hostapd use (IEEE80211_CHAN_*) */
-};
-
-struct ieee80211_rate_data {
-	int rate; /* rate in 100 kbps */
-	int flags; /* IEEE80211_RATE_ flags */
-};
-
-#endif /* HOSTAPD_IOCTL_H */
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-26 14:38:13.128936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-26 14:38:16.978936654 +0200
@@ -449,11 +449,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	int next_mode; /* MODE_IEEE80211*
-			* The mode preference for next channel change. This is
-			* used to select .11g vs. .11b channels (or 4.9 GHz vs.
-			* .11a) when the channel number is not unique. */
-
 	/* Supported and basic rate filters for different modes. These are
 	 * pointers to -1 terminated lists and rates in 100 kbps units. */
 	int *supp_rates[NUM_IEEE80211_MODES];
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-09-26 14:38:13.078936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-09-26 14:38:16.968936654 +0200
@@ -31,7 +31,6 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
-#include "hostapd_ioctl.h"
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3

-- 

