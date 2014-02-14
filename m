Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43486 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaBNKWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 05:22:13 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, yeohchunyeow@gmail.com,
	sw@simonwunderlich.de
Subject: [PATCH] nl80211: make sure we check for DFS with mesh channel switch
Date: Fri, 14 Feb 2014 12:22:07 +0200
Message-Id: <1392373327-12063-1-git-send-email-luca@coelho.fi> (sfid-20140214_112216_421945_D6BDFE3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Since mesh support for DFS channels was added, we also need to check
for DFS channels when performing a channel switch with
NL80211_IFTYPE_MESHPOINT.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1797864..b78d734 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5912,7 +5912,8 @@ skip_beacons:
 
 	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
 	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO ||
-	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC) {
+	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC ||
+	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_MESH_POINT) {
 		err = cfg80211_chandef_dfs_required(wdev->wiphy,
 						    &params.chandef);
 		if (err < 0) {
-- 
1.8.5.3

