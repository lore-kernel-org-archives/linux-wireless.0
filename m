Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZG2Nqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 09:46:53 -0400
Subject: [PATCH] mac80211: fix sparse warnings/errors
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 15:46:21 +0200
Message-Id: <1248875181.25614.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse complains about a shadowed variable, which
we can just rename, and lots of stuff if the API
tracer is enabled, so kick out the tracer code in
a sparse run -- the macros just confuse it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/driver-trace.c |    3 +++
 net/mac80211/iface.c        |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/driver-trace.c	2009-07-29 15:43:22.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.c	2009-07-29 15:45:38.000000000 +0200
@@ -1,6 +1,9 @@
 /* bug in tracepoint.h, it should include this */
 #include <linux/module.h>
 
+/* sparse isn't too happy with all macros... */
+#ifndef __CHECKER__
 #include "driver-ops.h"
 #define CREATE_TRACE_POINTS
 #include "driver-trace.h"
+#endif
--- wireless-testing.orig/net/mac80211/iface.c	2009-07-29 15:42:46.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-29 15:43:11.000000000 +0200
@@ -401,7 +401,7 @@ static int ieee80211_stop(struct net_dev
 
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan, *tmp;
+		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon = sdata->u.ap.beacon;
 
 		/* remove beacon */
@@ -410,7 +410,7 @@ static int ieee80211_stop(struct net_dev
 		kfree(old_beacon);
 
 		/* down all dependent devices, that is VLANs */
-		list_for_each_entry_safe(vlan, tmp, &sdata->u.ap.vlans,
+		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
 					 u.vlan.list)
 			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));


