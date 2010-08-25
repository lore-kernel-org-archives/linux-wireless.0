Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0HYMcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 08:32:25 -0400
Subject: [PATCH] mac80211: fix mesh advertisement
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 14:34:01 +0200
Message-ID: <1282739641.3685.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a mac80211-based driver advertises mesh mode
support, this will be advertised to userspace.
However, if mac80211 was compiled without mesh
support, then that won't actually be true. Fix
this by removing the bit for mesh if mesh isn't
compiled in.

Since this synchronizes what we advertise to
cfg80211 and actually support, it means we can
now rely on cfg80211's interface type checks
and need not check again in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  |   33 ---------------------------------
 net/mac80211/main.c |    5 +++++
 2 files changed, 5 insertions(+), 33 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2010-08-25 14:32:34.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-08-25 14:32:43.000000000 +0200
@@ -622,6 +622,11 @@ int ieee80211_register_hw(struct ieee802
 	/* mac80211 always supports monitor */
 	local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 
+#ifndef CONFIG_MAC80211_MESH
+	/* mesh depends on Kconfig, but drivers should set it if they want */
+	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
+#endif
+
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
--- wireless-testing.orig/net/mac80211/cfg.c	2010-08-25 14:32:34.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-08-25 14:32:43.000000000 +0200
@@ -19,33 +19,6 @@
 #include "rate.h"
 #include "mesh.h"
 
-static bool nl80211_type_check(enum nl80211_iftype type)
-{
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
-#ifdef CONFIG_MAC80211_MESH
-	case NL80211_IFTYPE_MESH_POINT:
-#endif
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_WDS:
-		return true;
-	default:
-		return false;
-	}
-}
-
-static bool nl80211_params_check(enum nl80211_iftype type,
-				 struct vif_params *params)
-{
-	if (!nl80211_type_check(type))
-		return false;
-
-	return true;
-}
-
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       enum nl80211_iftype type, u32 *flags,
 			       struct vif_params *params)
@@ -55,9 +28,6 @@ static int ieee80211_add_iface(struct wi
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	if (!nl80211_params_check(type, params))
-		return -EINVAL;
-
 	err = ieee80211_if_add(local, name, &dev, type, params);
 	if (err || type != NL80211_IFTYPE_MONITOR || !flags)
 		return err;
@@ -85,9 +55,6 @@ static int ieee80211_change_iface(struct
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	if (!nl80211_params_check(type, params))
-		return -EINVAL;
-
 	ret = ieee80211_if_change_type(sdata, type);
 	if (ret)
 		return ret;


