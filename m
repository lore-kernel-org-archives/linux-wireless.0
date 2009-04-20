Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30786 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759567AbZDTWaQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 18:30:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: do not print WARN if config interface fails during reconfigure
Date: Mon, 20 Apr 2009 15:36:18 -0700
Message-Id: <1240266979-9254-1-git-send-email-reinette.chatre@intel.com> (sfid-20090421_003031_397105_37C96189)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is expected that config interface will always succeed as mac80211
will only request what driver supports. The exception here is when a
device has rfkill enabled. At this time the rfkill state is unknown to
mac80211 and config interface can fail. When this happens we deal with
this error instead of printing a WARN.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/util.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 52ef8d4..0ee74e8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1047,8 +1047,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
-			WARN_ON(ieee80211_if_config(sdata, changed));
-			ieee80211_bss_info_change_notify(sdata, ~0);
+			/*
+			 * Driver's config_interface can fail if rfkill is
+			 * enabled. Accommodate this return code.
+			 * FIXME: When mac80211 has knowledge of rfkill
+			 * state the code below can change back to:
+			 *   WARN(ieee80211_if_config(sdata, changed));
+			 *   ieee80211_bss_info_change_notify(sdata, ~0);
+			 */
+			if (ieee80211_if_config(sdata, changed))
+				printk(KERN_DEBUG "%s: failed to reconfigure interface\n",
+				       sdata->dev->name);
+			else
+				ieee80211_bss_info_change_notify(sdata, ~0);
 			break;
 		case NL80211_IFTYPE_WDS:
 			break;
-- 
1.5.6.3

