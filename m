Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1BPHrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 02:47:01 -0500
Subject: [PATCH] mac80211: fix 2.4 GHz 40 MHz disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 08:46:58 +0100
Message-ID: <1297842418.3973.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The module parameter ieee80211_disable_40mhz_24ghz
was meant to allow disabling 40 MHz operation in
the 2.4 GHz band by default. However, it is buggy
as implemented because while it advertises to the
AP that the device doesn't support 40 MHz, it will
itself still use 40 MHz configurations.

To fix this, clear the 40 MHz bits from the sband
completely instead of overriding where used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 --
 net/mac80211/main.c        |   14 +++++++++++++-
 net/mac80211/util.c        |    6 ------
 net/mac80211/work.c        |    6 ------
 4 files changed, 13 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2011-02-15 18:21:21.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2011-02-15 18:22:18.000000000 +0100
@@ -1066,8 +1066,6 @@ void ieee80211_bss_info_change_notify(st
 void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
-extern bool ieee80211_disable_40mhz_24ghz;
-
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/main.c	2011-02-15 18:19:04.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2011-02-15 18:23:33.000000000 +0100
@@ -34,7 +34,7 @@
 #include "debugfs.h"
 
 
-bool ieee80211_disable_40mhz_24ghz;
+static bool ieee80211_disable_40mhz_24ghz;
 module_param(ieee80211_disable_40mhz_24ghz, bool, 0644);
 MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
 		 "Disable 40MHz support in the 2.4GHz band");
@@ -723,6 +723,18 @@ int ieee80211_register_hw(struct ieee802
 		}
 		channels += sband->n_channels;
 
+		/*
+		 * Since ieee80211_disable_40mhz_24ghz is global, we can
+		 * modify the sband's ht data even if the driver uses a
+		 * global structure for that.
+		 */
+		if (ieee80211_disable_40mhz_24ghz &&
+		    band == IEEE80211_BAND_2GHZ &&
+		    sband->ht_cap.ht_supported) {
+			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
 		if (max_bitrates < sband->n_bitrates)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
--- wireless-testing.orig/net/mac80211/util.c	2011-02-15 18:21:21.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2011-02-15 18:22:24.000000000 +0100
@@ -986,12 +986,6 @@ int ieee80211_build_preq_ies(struct ieee
 		u16 cap = sband->ht_cap.cap;
 		__le16 tmp;
 
-		if (ieee80211_disable_40mhz_24ghz &&
-		    sband->band == IEEE80211_BAND_2GHZ) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
 		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
--- wireless-testing.orig/net/mac80211/work.c	2011-02-15 18:21:21.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2011-02-15 18:22:02.000000000 +0100
@@ -126,12 +126,6 @@ static void ieee80211_add_ht_ie(struct s
 
 	/* determine capability flags */
 
-	if (ieee80211_disable_40mhz_24ghz &&
-	    sband->band == IEEE80211_BAND_2GHZ) {
-		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		cap &= ~IEEE80211_HT_CAP_SGI_40;
-	}
-
 	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {


