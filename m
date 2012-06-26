Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64975 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab2FZMag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:30:36 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 03/13] cfg80211: add channel tracking for AP and mesh
Date: Tue, 26 Jun 2012 14:30:08 +0200
Message-ID: <1340713818-28549-4-git-send-email-michal.kazior@tieto.com> (sfid-20120626_145130_113367_E0135A34)
In-Reply-To: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to know which channel is used by a running
AP and mesh for channel context accounting and
finding matching/active interface combination.

STA/IBSS have current_bss already which allows us
to check which channel a vif is tuned to.
Non-fixed channel IBSS can be handled with
additional changes.

Monitor mode is going to be handled differently.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h |    3 +++
 net/wireless/ap.c      |    4 +++-
 net/wireless/mesh.c    |   18 ++++++++++++++----
 net/wireless/mlme.c    |    1 +
 net/wireless/nl80211.c |    5 ++++-
 5 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..0f9d7b4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2335,6 +2335,9 @@ struct wireless_dev {
 	struct ieee80211_channel *preset_chan;
 	enum nl80211_channel_type preset_chantype;
 
+	/* for AP and mesh channel tracking */
+	struct ieee80211_channel *channel;
+
 	bool ps;
 	int ps_timeout;
 
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 45199cc..fcc60d8 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -24,8 +24,10 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		return -ENOENT;
 
 	err = rdev->ops->stop_ap(&rdev->wiphy, dev);
-	if (!err)
+	if (!err) {
 		wdev->beacon_interval = 0;
+		wdev->channel = NULL;
+	}
 
 	return err;
 }
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b44c736..4f218c1 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -153,6 +153,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
 		wdev->mesh_id_len = setup->mesh_id_len;
+		wdev->channel = setup->channel;
 	}
 
 	return err;
@@ -178,6 +179,7 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 			   enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *channel;
+	int err;
 
 	channel = rdev_freq_to_chan(rdev, freq, channel_type);
 	if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
@@ -199,9 +201,14 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
-		return rdev->ops->libertas_set_mesh_channel(&rdev->wiphy,
-							    wdev->netdev,
-							    channel);
+
+		err = rdev->ops->libertas_set_mesh_channel(&rdev->wiphy,
+							   wdev->netdev,
+							   channel);
+		if (!err)
+			wdev->channel = channel;
+
+		return err;
 	}
 
 	if (wdev->mesh_id_len)
@@ -243,8 +250,11 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 		return -ENOTCONN;
 
 	err = rdev->ops->leave_mesh(&rdev->wiphy, dev);
-	if (!err)
+	if (!err) {
 		wdev->mesh_id_len = 0;
+		wdev->channel = NULL;
+	}
+
 	return err;
 }
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index da4406f..a7882eb 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -947,6 +947,7 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
 	if (WARN_ON(!chan))
 		goto out;
 
+	wdev->channel = chan;
 	nl80211_ch_switch_notify(rdev, dev, freq, type, GFP_KERNEL);
 out:
 	wdev_unlock(wdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c17b57b..5d36124 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2356,8 +2356,11 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
-	if (!err)
+	if (!err) {
 		wdev->beacon_interval = params.beacon_interval;
+		wdev->channel = params.channel;
+	}
+
 	return err;
 }
 
-- 
1.7.0.4

