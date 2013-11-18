Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:56580 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KRRC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:02:56 -0500
Received: by mail-bk0-f42.google.com with SMTP id w11so575793bkz.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 09:02:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] mac80211: remove sta_info_flush() from interface teardown
Date: Mon, 18 Nov 2013 19:02:43 +0200
Message-Id: <1384794166-10906-3-git-send-email-egrumbach@gmail.com> (sfid-20131118_180301_403561_7E78846E)
In-Reply-To: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All interface types now properly clean up their stations
using some form of sta_info_flush() themselves, so there's
no need to try it again at teardown. Remove the call to
get rid of the extra delay from the synchronize_net() and
rcu_barrier() calls.

Reported-by: Moshe Benji <moshe.benji@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ff101ea..a3d106d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1036,7 +1036,6 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
  */
 static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	int flushed;
 	int i;
 
 	/* free extra data */
@@ -1050,9 +1049,6 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_rmc_free(sdata);
-
-	flushed = sta_info_flush(sdata);
-	WARN_ON(flushed);
 }
 
 static void ieee80211_uninit(struct net_device *dev)
-- 
1.7.9.5

