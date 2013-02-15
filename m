Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3BOKuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 05:50:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix harmless station flush warning
Date: Fri, 15 Feb 2013 11:49:56 +0100
Message-Id: <1360925396-18355-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_115014_486099_278D969B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If an interface is set down while authenticating or
associating, there's a station entry that will be
removed by the flushing in do_stop() and that will
cause a warning. It's otherwise harmless, but avoid
the warning by calling ieee80211_mgd_stop() first.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4a7129c..fe62a99 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -695,6 +695,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_roc_purge(sdata);
 
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		ieee80211_mgd_stop(sdata);
+
 	/*
 	 * Remove all stations associated with this interface.
 	 *
@@ -782,8 +785,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 		spin_unlock_irqrestore(&ps->bc_buf.lock, flags);
-	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		ieee80211_mgd_stop(sdata);
 	}
 
 	if (going_down)
-- 
1.8.0

