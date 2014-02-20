Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:55916 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaBTFKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 00:10:19 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v2 1/7] nl80211: make sure we check for DFS with mesh channel switch
Date: Thu, 20 Feb 2014 07:10:07 +0200
Message-Id: <1392873013-21772-2-git-send-email-luca@coelho.fi> (sfid-20140220_061048_044334_9C2FDC17)
In-Reply-To: <1392873013-21772-1-git-send-email-luca@coelho.fi>
References: <1392873013-21772-1-git-send-email-luca@coelho.fi>
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

