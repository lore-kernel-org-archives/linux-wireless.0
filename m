Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50402 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab2FZMam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:30:42 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 13/13] cfg80211: respect iface combinations when starting operation
Date: Tue, 26 Jun 2012 14:30:18 +0200
Message-ID: <1340713818-28549-14-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143048_305774_58E28647)
In-Reply-To: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

devlist_mtx locking is changed to accomodate changes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c    |    2 ++
 net/wireless/ibss.c    |   10 ++++++++++
 net/wireless/mesh.c    |   12 ++++++++++++
 net/wireless/mlme.c    |   16 ++++++++++++++++
 net/wireless/nl80211.c |    8 ++++++++
 net/wireless/util.c    |    5 +++--
 6 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2fed61b..5752067 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1049,7 +1049,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			return notifier_from_errno(-EOPNOTSUPP);
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
+		mutex_lock(&rdev->devlist_mtx);
 		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
+		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
 		cfg80211_lock_rdev(rdev);
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index b90fd86..ca5672f 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -118,6 +118,16 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	wdev->wext.ibss.channel = params->channel;
 #endif
 	wdev->sme_state = CFG80211_SME_CONNECTING;
+
+	err = cfg80211_can_use_chan(rdev, wdev, params->channel,
+				    params->channel_fixed
+				    ? CHAN_MODE_SHARED
+				    : CHAN_MODE_EXCLUSIVE);
+	if (err) {
+		wdev->connect_keys = NULL;
+		return err;
+	}
+
 	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
 	if (err) {
 		wdev->connect_keys = NULL;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 4f218c1..97f6c41 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -149,6 +149,11 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 					  setup->channel_type))
 		return -EINVAL;
 
+	err = cfg80211_can_use_chan(rdev, wdev, setup->channel,
+				    CHAN_MODE_SHARED);
+	if (err)
+		return err;
+
 	err = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
@@ -167,9 +172,11 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
 	err = __cfg80211_join_mesh(rdev, dev, setup, conf);
 	wdev_unlock(wdev);
+	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -202,6 +209,11 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
 
+		err = cfg80211_can_use_chan(rdev, wdev, channel,
+					    CHAN_MODE_SHARED);
+		if (err)
+			return err;
+
 		err = rdev->ops->libertas_set_mesh_channel(&rdev->wiphy,
 							   wdev->netdev,
 							   channel);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a7882eb..d4fece3 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -302,8 +302,14 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	if (!req.bss)
 		return -ENOENT;
 
+	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
+				    CHAN_MODE_SHARED);
+	if (err)
+		goto out;
+
 	err = rdev->ops->auth(&rdev->wiphy, dev, &req);
 
+out:
 	cfg80211_put_bss(req.bss);
 	return err;
 }
@@ -317,11 +323,13 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 {
 	int err;
 
+	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				   ssid, ssid_len, ie, ie_len,
 				   key, key_len, key_idx);
 	wdev_unlock(dev->ieee80211_ptr);
+	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
@@ -397,8 +405,14 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 		return -ENOENT;
 	}
 
+	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
+				    CHAN_MODE_SHARED);
+	if (err)
+		goto out;
+
 	err = rdev->ops->assoc(&rdev->wiphy, dev, &req);
 
+out:
 	if (err) {
 		if (was_connected)
 			wdev->sme_state = CFG80211_SME_CONNECTED;
@@ -421,11 +435,13 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	mutex_lock(&rdev->devlist_mtx);
 	wdev_lock(wdev);
 	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 				    ssid, ssid_len, ie, ie_len, use_mfp, crypt,
 				    assoc_flags, ht_capa, ht_capa_mask);
 	wdev_unlock(wdev);
+	mutex_unlock(&rdev->devlist_mtx);
 
 	return err;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 819ebc0..85ddb3e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2349,6 +2349,14 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					  params.channel_type))
 		return -EINVAL;
 
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_chan(rdev, wdev, params.channel,
+				    CHAN_MODE_SHARED);
+	mutex_unlock(&rdev->devlist_mtx);
+
+	if (err)
+		return err;
+
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
 	if (!err) {
 		wdev->beacon_interval = params.beacon_interval;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b8e3f70..748ad2e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -805,8 +805,10 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EBUSY;
 
 	if (ntype != otype && netif_running(dev)) {
+		mutex_lock(&rdev->devlist_mtx);
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
+		mutex_unlock(&rdev->devlist_mtx);
 		if (err)
 			return err;
 
@@ -956,6 +958,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	int i, j;
 
 	ASSERT_RTNL();
+	lockdep_assert_held(&rdev->devlist_mtx);
 
 	/* Always allow software iftypes */
 	if (rdev->wiphy.software_iftypes & BIT(iftype))
@@ -979,7 +982,6 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		break;
 	}
 
-	mutex_lock(&rdev->devlist_mtx);
 	list_for_each_entry(wdev_iter, &rdev->netdev_list, list) {
 		if (wdev_iter == wdev)
 			continue;
@@ -1015,7 +1017,6 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		total++;
 		used_iftypes |= BIT(wdev_iter->iftype);
 	}
-	mutex_unlock(&rdev->devlist_mtx);
 
 	if (total == 1)
 		return 0;
-- 
1.7.0.4

