Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab2EPVzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:02 -0400
Message-Id: <20120516215038.241452917@sipsolutions.net> (sfid-20120516_235518_579555_AD7EAE5E)
Date: Wed, 16 May 2012 23:50:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] mac80211: clean up ieee80211_set_channel
References: <20120516215014.379333357@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for ieee80211_set_channel to check
whether a change in configuration happened since
ieee80211_hw_config() auto-detects it.

Additionally, it's wrong to pretend the HT config
for the BSS changed, it didn't, the BSS can't be
up & running (AP beaconing etc.) when the channel
type is changed anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/net/mac80211/cfg.c	2012-05-15 20:14:44.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-05-15 20:14:53.000000000 +0200
@@ -1684,9 +1684,6 @@ static int ieee80211_set_channel(struct
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = NULL;
-	struct ieee80211_channel *old_oper;
-	enum nl80211_channel_type old_oper_type;
-	enum nl80211_channel_type old_vif_oper_type= NL80211_CHAN_NO_HT;
 
 	if (netdev)
 		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
@@ -1704,24 +1701,13 @@ static int ieee80211_set_channel(struct
 		break;
 	}
 
-	if (sdata)
-		old_vif_oper_type = sdata->vif.bss_conf.channel_type;
-	old_oper_type = local->_oper_channel_type;
-
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
 		return -EBUSY;
 
-	old_oper = local->oper_channel;
 	local->oper_channel = chan;
 
-	/* Update driver if changes were actually made. */
-	if ((old_oper != local->oper_channel) ||
-	    (old_oper_type != local->_oper_channel_type))
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-	    old_vif_oper_type != sdata->vif.bss_conf.channel_type)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
+	/* auto-detects changes */
+	ieee80211_hw_config(local, 0);
 
 	return 0;
 }


