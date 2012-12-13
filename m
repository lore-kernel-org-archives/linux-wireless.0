Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMW7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:59:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] mac80211: warn if unexpectedly removing stations
Date: Thu, 13 Dec 2012 23:59:32 +0100
Message-Id: <1355439573-13206-5-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235924_370077_D61D9153)
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interface is brought down it must have been
disconnected (or similar) in all modes other than WDS,
so warn if any stations were removed in other modes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 36109eb..9dacc3a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -756,7 +756,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
-	int i;
+	int i, flushed;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -781,11 +781,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	 * (because if we remove a STA after ops->remove_interface()
 	 * the driver will have removed the vif info already!)
 	 *
-	 * This is relevant only in AP, WDS and mesh modes, since in
-	 * all other modes we've already removed all stations when
-	 * disconnecting etc.
+	 * This is relevant only in WDS mode, in all other modes we've
+	 * already removed all stations when disconnecting or similar,
+	 * so warn otherwise.
 	 */
-	sta_info_flush(sdata);
+	flushed = sta_info_flush(sdata);
+	WARN_ON_ONCE((sdata->vif.type != NL80211_IFTYPE_WDS && flushed > 0) ||
+		     (sdata->vif.type == NL80211_IFTYPE_WDS && flushed != 1));
 
 	/*
 	 * Don't count this interface for promisc/allmulti while it
-- 
1.8.0

