Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58036 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751873AbaKGMcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 07:32:06 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri,  7 Nov 2014 14:31:37 +0200
Message-Id: <1415363497-8475-4-git-send-email-luca@coelho.fi> (sfid-20141107_133212_835864_EA64BAA3)
In-Reply-To: <1415363497-8475-1-git-send-email-luca@coelho.fi>
References: <1415363497-8475-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 3/3] cfg80211/nl80211: allow any interface to send channel switch notifications
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For multi-vif channel switches, we want to send
NL80211_CMD_CH_SWITCH_NOTIFY to the userspace to let it decide whether
other interfaces need to be moved as well.  This is needed when we
want a P2P GO interface to follow the channel of a station, for
example.

Modify the code so that all interfaces can send CSA notifications.
Additionally, send notifications for STA CSA as well.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/uapi/linux/nl80211.h | 4 +++-
 net/mac80211/mlme.c          | 2 ++
 net/wireless/nl80211.c       | 6 ------
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 3541634..a552736 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -643,7 +643,9 @@
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ and the
- *	attributes determining channel width.
+ *	attributes determining channel width.  This indication may also be
+ *	sent when a remotely-initiated switch (e.g., when a STA receives a CSA
+ *	from the remote AP) is completed;
  *
  * @NL80211_CMD_CH_SWITCH_STARTED_NOTIFY: Notify that a channel switch
  *	has been started on an interface, regardless of the initiator
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e31299f..6c60bfb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1049,6 +1049,8 @@ static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
 		sdata->csa_block_tx = false;
 	}
 
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->reserved_chandef);
+
 	sdata->vif.csa_active = false;
 	ifmgd->csa_waiting_bcn = false;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24fd292..d0a8361 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11702,12 +11702,6 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	trace_cfg80211_ch_switch_notify(dev, chandef);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
-		    wdev->iftype != NL80211_IFTYPE_ADHOC &&
-		    wdev->iftype != NL80211_IFTYPE_MESH_POINT))
-		return;
-
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
-- 
2.1.1

