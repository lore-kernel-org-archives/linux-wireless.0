Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161377AbXBZW7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 17:59:38 -0500
Subject: [PATCH] d80211: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 23:59:19 +0100
Message-Id: <1172530759.3870.205.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some sparse warnings in d80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
A few warnings remain:

net/d80211/ieee80211.c:820:37: warning: potentially expensive pointer subtraction

net/d80211/ieee80211_ioctl.c:779:4: warning: incorrect type in argument 6 (different signedness)
net/d80211/ieee80211_ioctl.c:779:4:    expected int *err
net/d80211/ieee80211_ioctl.c:779:4:    got unsigned int *<noident>

net/d80211/sta_info.c:232:3: warning: context imbalance in 'sta_info_free' - unexpected unlock

The last of these is bogus, the code is perfectly fine. The other two I
don't understand.

---
 net/d80211/ieee80211.c       |    6 +++---
 net/d80211/ieee80211_sta.c   |    6 +++---
 net/d80211/ieee80211_sysfs.c |    1 +
 3 files changed, 7 insertions(+), 6 deletions(-)

--- wireless-dev.orig/net/d80211/ieee80211.c	2007-02-26 23:51:34.284692803 +0100
+++ wireless-dev/net/d80211/ieee80211.c	2007-02-26 23:53:26.114692803 +0100
@@ -2640,7 +2640,7 @@ ieee80211_get_rate(struct ieee80211_loca
 	return NULL;
 }
 
-void
+static void
 ieee80211_fill_frame_info(struct ieee80211_local *local,
 			  struct ieee80211_frame_info *fi,
 			  struct ieee80211_rx_status *status)
@@ -2747,7 +2747,7 @@ ieee80211_rx_mgmt(struct ieee80211_local
 	netif_rx(skb);
 }
 
-void
+static void
 ieee80211_rx_monitor(struct net_device *dev, struct sk_buff *skb,
 		     struct ieee80211_rx_status *status)
 {
@@ -3635,7 +3635,7 @@ static void ieee80211_rx_michael_mic_rep
 
 	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
 	    rx->sdata->type == IEEE80211_IF_TYPE_AP) {
-		int keyidx = ieee80211_wep_get_keyidx(rx->skb);
+		keyidx = ieee80211_wep_get_keyidx(rx->skb);
 		/* AP with Pairwise keys support should never receive Michael
 		 * MIC errors for non-zero keyidx because these are reserved
 		 * for group keys and only the AP is sending real multicast
--- wireless-dev.orig/net/d80211/ieee80211_sta.c	2007-02-26 23:55:39.234692803 +0100
+++ wireless-dev/net/d80211/ieee80211_sta.c	2007-02-26 23:57:09.244692803 +0100
@@ -2247,11 +2247,11 @@ static int ieee80211_sta_join_ibss(struc
 
 		rates = 0;
 		for (i = 0; i < bss->supp_rates_len; i++) {
-			int rate = (bss->supp_rates[i] & 0x7f) * 5;
+			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
 			if (local->hw.conf.phymode == MODE_ATHEROS_TURBO)
-				rate *= 2;
+				bitrate *= 2;
 			for (j = 0; j < local->num_curr_rates; j++)
-				if (local->curr_rates[j].rate == rate)
+				if (local->curr_rates[j].rate == bitrate)
 					rates |= BIT(j);
 		}
 		ifsta->supp_rates_bits = rates;
--- wireless-dev.orig/net/d80211/ieee80211_sysfs.c	2007-02-26 23:56:36.904692803 +0100
+++ wireless-dev/net/d80211/ieee80211_sysfs.c	2007-02-26 23:56:43.854692803 +0100
@@ -16,6 +16,7 @@
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#include "ieee80211_sysfs.h"
 
 static inline struct ieee80211_local *to_ieee80211_local(struct device *dev)
 {


