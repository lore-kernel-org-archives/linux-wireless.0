Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab0EEHoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 03:44:13 -0400
Subject: [PATCH] mac80211: fix BSS info reconfiguration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 09:44:02 +0200
Message-ID: <1273045442.3728.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When reconfiguring an interface due to a previous
hardware restart, mac80211 will currently include
the new IBSS flag on non-IBSS interfaces which may
confuse drivers.

Instead of doing the ~0 trick, simply spell out
which things are going to be reconfigured.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/util.c    |   25 ++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-05-01 08:47:54.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-05-05 09:41:46.000000000 +0200
@@ -160,6 +160,8 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
 	BSS_CHANGED_CQM			= 1<<10,
 	BSS_CHANGED_IBSS		= 1<<11,
+
+	/* when adding here, make sure to change ieee80211_reconfig */
 };
 
 /**
--- wireless-testing.orig/net/mac80211/util.c	2010-04-09 11:46:46.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-05-05 09:41:46.000000000 +0200
@@ -1160,18 +1160,33 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		u32 changed = ~0;
+		u32 changed;
+
 		if (!ieee80211_sdata_running(sdata))
 			continue;
+
+		/* common change flags for all interface types */
+		changed = BSS_CHANGED_ERP_CTS_PROT |
+			  BSS_CHANGED_ERP_PREAMBLE |
+			  BSS_CHANGED_ERP_SLOT |
+			  BSS_CHANGED_HT |
+			  BSS_CHANGED_BASIC_RATES |
+			  BSS_CHANGED_BEACON_INT |
+			  BSS_CHANGED_BSSID |
+			  BSS_CHANGED_CQM;
+
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
-			/* disable beacon change bits */
-			changed &= ~(BSS_CHANGED_BEACON |
-				     BSS_CHANGED_BEACON_ENABLED);
-			/* fall through */
+			changed |= BSS_CHANGED_ASSOC;
+			ieee80211_bss_info_change_notify(sdata, changed);
+			break;
 		case NL80211_IFTYPE_ADHOC:
+			changed |= BSS_CHANGED_IBSS;
+			/* fall through */
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
+			changed |= BSS_CHANGED_BEACON |
+				   BSS_CHANGED_BEACON_ENABLED;
 			ieee80211_bss_info_change_notify(sdata, changed);
 			break;
 		case NL80211_IFTYPE_WDS:


