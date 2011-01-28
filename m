Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41822 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1A1SU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 13:20:59 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211: Be more careful when changing channels.
Date: Fri, 28 Jan 2011 10:20:47 -0800
Message-Id: <1296238847-8301-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If we cannot set the channel type, set the channel back to the
original.

Don't update the driver hardware if nothing actually changed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Fix == typo, simplify logic slightly by testing
   oper-channel-type set first.

:100644 100644 9bf2193... 70fc329... M	net/mac80211/cfg.c
 net/mac80211/cfg.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9bf2193..70fc329 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1223,6 +1223,9 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = NULL;
+	struct ieee80211_channel *old_oper;
+	enum nl80211_channel_type old_oper_type;
+	enum nl80211_channel_type old_vif_oper_type= NL80211_CHAN_NO_HT;
 
 	if (netdev)
 		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
@@ -1240,13 +1243,23 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 		break;
 	}
 
-	local->oper_channel = chan;
-
+	if (sdata)
+		old_vif_oper_type = sdata->vif.bss_conf.channel_type;
+	old_oper_type = local->_oper_channel_type;
+	
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
 		return -EBUSY;
 
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR)
+	old_oper = local->oper_channel;
+	local->oper_channel = chan;
+
+	/* Update driver if changes were actually made. */
+	if ((old_oper != local->oper_channel) ||
+	    (old_oper_type != local->_oper_channel_type))
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	if ((sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR) &&
+	    old_vif_oper_type != sdata->vif.bss_conf.channel_type)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
 
 	return 0;
-- 
1.7.2.3

