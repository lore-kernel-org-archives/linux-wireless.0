Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbCAHKo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/16] mac80211: allow TDLS setup code to take wdev lock
Date: Sun,  1 Mar 2015 09:10:09 +0200
Message-Id: <1425193815-17785-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083417_018336_4BD2D30E)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

TDLS off-channel can be allowed in channels marked with GO_CONCURRENT,
provided the device is connected to an AP on the same UNII.
When relaxing the NO-IR requirements for TDLS, we might hit flows in
cfg80211_reg_can_beacon that acquire the wdev lock. Take some measures
to allow this during TDLS setup.
Acquire the RCU read lock later in the flow that invokes
cfg80211_reg_can_beacon.
Avoid taking local->mtx when preparing the setup packet to avoid
circular deadlocks with mac80211 code that is invoked with wdev-mtx
held.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 5bcd542..bc7e404 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -287,17 +287,6 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 	size_t offset = 0, noffset;
 	u8 *pos;
 
-	rcu_read_lock();
-
-	/* we should have the peer STA if we're already responding */
-	if (action_code == WLAN_TDLS_SETUP_RESPONSE) {
-		sta = sta_info_get(sdata, peer);
-		if (WARN_ON_ONCE(!sta)) {
-			rcu_read_unlock();
-			return;
-		}
-	}
-
 	ieee80211_add_srates_ie(sdata, skb, false, band);
 	ieee80211_add_ext_srates_ie(sdata, skb, false, band);
 	ieee80211_tdls_add_supp_channels(sdata, skb);
@@ -350,6 +339,17 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		offset = noffset;
 	}
 
+	rcu_read_lock();
+
+	/* we should have the peer STA if we're already responding */
+	if (action_code == WLAN_TDLS_SETUP_RESPONSE) {
+		sta = sta_info_get(sdata, peer);
+		if (WARN_ON_ONCE(!sta)) {
+			rcu_read_unlock();
+			return;
+		}
+	}
+
 	/*
 	 * with TDLS we can switch channels, and HT-caps are not necessarily
 	 * the same on all bands. The specification limits the setup to a
@@ -983,7 +983,7 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	if (!is_zero_ether_addr(sdata->u.mgd.tdls_peer) &&
 	    !ether_addr_equal(sdata->u.mgd.tdls_peer, peer)) {
 		ret = -EBUSY;
-		goto exit;
+		goto out_unlock;
 	}
 
 	/*
@@ -998,27 +998,34 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 		if (!sta_info_get(sdata, peer)) {
 			rcu_read_unlock();
 			ret = -ENOLINK;
-			goto exit;
+			goto out_unlock;
 		}
 		rcu_read_unlock();
 	}
 
 	ieee80211_flush_queues(local, sdata, false);
+	memcpy(sdata->u.mgd.tdls_peer, peer, ETH_ALEN);
+	mutex_unlock(&local->mtx);
 
+	/* we cannot take the mutex while preparing the setup packet */
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
 					      peer_capability, initiator,
 					      extra_ies, extra_ies_len, 0,
 					      NULL);
-	if (ret < 0)
-		goto exit;
+	if (ret < 0) {
+		mutex_lock(&local->mtx);
+		eth_zero_addr(sdata->u.mgd.tdls_peer);
+		mutex_unlock(&local->mtx);
+		return ret;
+	}
 
-	memcpy(sdata->u.mgd.tdls_peer, peer, ETH_ALEN);
 	ieee80211_queue_delayed_work(&sdata->local->hw,
 				     &sdata->u.mgd.tdls_peer_del_work,
 				     TDLS_PEER_SETUP_TIMEOUT);
+	return 0;
 
-exit:
+out_unlock:
 	mutex_unlock(&local->mtx);
 	return ret;
 }
-- 
1.9.1

