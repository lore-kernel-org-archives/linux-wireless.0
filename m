Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3B1WTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:19:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: simplify AP interface stop
Date: Thu, 28 Feb 2013 23:19:31 +0100
Message-Id: <1362089971-12182-2-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231940_319630_88DD054B)
In-Reply-To: <1362089971-12182-1-git-send-email-johannes@sipsolutions.net>
References: <1362089971-12182-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For AP interfaces, there's no need to flush stations
or keys again when the interface is stopped as already
happened when the BSS was stopped on the interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 74228d9..6c60711 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -832,14 +832,16 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		rcu_barrier();
 		sta_info_flush_cleanup(sdata);
 
-		skb_queue_purge(&sdata->skb_queue);
-
 		/*
 		 * Free all remaining keys, there shouldn't be any,
 		 * except maybe in WDS mode?
 		 */
 		ieee80211_free_keys(sdata);
 
+		/* fall through */
+	case NL80211_IFTYPE_AP:
+		skb_queue_purge(&sdata->skb_queue);
+
 		drv_remove_interface_debugfs(local, sdata);
 
 		if (going_down)
-- 
1.8.0

