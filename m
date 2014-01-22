Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaAVKfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/7] mac80211: make cfg80211 ops and privid const
Date: Wed, 22 Jan 2014 11:34:53 +0100
Message-Id: <1390386898-14316-3-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113535_215053_B17FE3F1)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The wiphy privid (to identify wiphys) and the cfg80211
ops should both be const, so change them to be.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 2 +-
 net/mac80211/cfg.h         | 2 +-
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/util.c        | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d2125a3..cf27c62 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3918,7 +3918,7 @@ static int ieee80211_set_qos_map(struct wiphy *wiphy,
 	return 0;
 }
 
-struct cfg80211_ops mac80211_config_ops = {
+const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
 	.change_virtual_intf = ieee80211_change_iface,
diff --git a/net/mac80211/cfg.h b/net/mac80211/cfg.h
index 7d7879f..2d51f62 100644
--- a/net/mac80211/cfg.h
+++ b/net/mac80211/cfg.h
@@ -4,6 +4,6 @@
 #ifndef __CFG_H
 #define __CFG_H
 
-extern struct cfg80211_ops mac80211_config_ops;
+extern const struct cfg80211_ops mac80211_config_ops;
 
 #endif /* __CFG_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 96eb272..d37dc75 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1608,7 +1608,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 }
 
 /* utility functions/constants */
-extern void *mac80211_wiphy_privid; /* for wiphy privid */
+extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 676dc09..128a0c5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -34,7 +34,7 @@
 #include "wep.h"
 
 /* privid for wiphys to determine whether they belong to us or not */
-void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
+const void *const mac80211_wiphy_privid = &mac80211_wiphy_privid;
 
 struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 {
-- 
1.8.5.1

