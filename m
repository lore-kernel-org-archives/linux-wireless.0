Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63892 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1DECHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 22:07:05 -0400
Received: by iwn34 with SMTP id 34so6341997iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 19:07:03 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own stack.
Date: Mon,  4 Apr 2011 19:06:58 -0700
Message-Id: <1301969218-9878-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful for implementing frame protection in userspace. The kernel may
request a userspace daemon to verify a frame (sent to userspace via
cfg80211_rx_mgmt()).  The userspace daemon can then pass back the
verified/unprotected frame to the stack for further processing (via a
self-addressed frame sent with cfg80211_mlme_mgmt_tx())

We are using this for our implementation authenticated peering.  11s defines
two versions of mesh peering, the non-secure mesh peering management (MPM) and
the Authenticated Mesh Peering Exchange (AMPE).  The latter is based on the
exact same state machine as MPM.  It is really convenient to use the in-kernel
MPM with a minimal userspace daemon to add the security bits introduced by
AMPE.  This way both secured and open mesh networks can use exact same peering
code.

What do you think... will this fly?

---
 net/mac80211/cfg.c  |   12 +++++++++++-
 net/wireless/mlme.c |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5548a4c..8b6ff5a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1773,6 +1773,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 		    IEEE80211_TX_CTL_REQ_TX_STATUS;
 	bool is_offchan = false;
+	bool is_to_self = false;
 
 	/* Check that we are on the requested channel for transmission */
 	if (chan != local->tmp_channel &&
@@ -1792,6 +1793,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	if (is_offchan && !offchan)
 		return -EBUSY;
 
+	is_to_self = !memcmp(mgmt->da, dev->dev_addr, ETH_ALEN);
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
@@ -1799,7 +1802,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!ieee80211_is_action(mgmt->frame_control) ||
-		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
+		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
+		    is_to_self)
 			break;
 		rcu_read_lock();
 		sta = sta_info_get(sdata, mgmt->da);
@@ -1827,6 +1831,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	*cookie = (unsigned long) skb;
 
+	if (is_to_self) {
+		ieee80211_rx_irqsafe(wiphy_to_ieee80211_hw(wiphy),
+				skb);
+		return 0;
+	}
+
 	if (is_offchan && local->ops->offchannel_tx) {
 		int ret;
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 493b939..eb00d60 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -983,7 +983,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0)
+	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0 &&
+		memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) != 0)
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
-- 
1.7.1

