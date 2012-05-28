Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64704 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2E1LTp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:45 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 14/14] cfg80211: respect iface combinations when starting operation
Date: Mon, 28 May 2012 13:19:02 +0200
Message-ID: <1338203942-5667-15-git-send-email-michal.kazior@tieto.com> (sfid-20120528_131951_866178_CDF9189D)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use cfg80211_can_change_interface before starting
up any operation modes such as .start_ap or .auth
to verify whether we comply with
num_different_channels within at least one
interface combination.

Change-Id: I270c18855e28e3b7d63013f66fae5146bfd0826e
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/ibss.c    |    8 ++++++++
 net/wireless/mesh.c    |    7 +++++++
 net/wireless/mlme.c    |    6 ++++++
 net/wireless/nl80211.c |    8 ++++++++
 4 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 30f20fe..2583148 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -115,6 +115,14 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.channel = params->channel;
 #endif
+
+	err = cfg80211_can_change_interface(rdev, wdev, wdev->iftype,
+					    params->channel);
+	if (err) {
+		wdev->connect_keys = NULL;
+		return err;
+	}
+
 	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
 	if (err) {
 		wdev->connect_keys = NULL;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c9c38e3..f26ad50 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -149,6 +149,11 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 					  setup->channel_type))
 		return -EINVAL;
 
+	err = cfg80211_can_change_interface(rdev, wdev, wdev->iftype,
+					    setup->channel);
+	if (err)
+		return err;
+
 	err = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
@@ -168,7 +173,9 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	int err;
 
 	wdev_lock(wdev);
+	mutex_lock(&rdev->devlist_mtx);
 	err = __cfg80211_join_mesh(rdev, dev, setup, conf);
+	mutex_unlock(&rdev->devlist_mtx);
 	wdev_unlock(wdev);
 
 	return err;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 83155ee..9e5cab6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -302,8 +302,14 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	if (!req.bss)
 		return -ENOENT;
 
+	err = cfg80211_can_change_interface(rdev, wdev, wdev->iftype,
+					    req.bss->channel);
+	if (err)
+		goto end;
+
 	err = rdev->ops->auth(&rdev->wiphy, dev, &req);
 
+end:
 	cfg80211_put_bss(req.bss);
 	return err;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e02ec2c..2757b39 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2349,6 +2349,14 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					  params.channel_type))
 		return -EINVAL;
 
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_change_interface(rdev, wdev, wdev->iftype,
+					    params.channel);
+	mutex_unlock(&rdev->devlist_mtx);
+
+	if (err)
+		return err;
+
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
 	if (!err) {
 		wdev->beacon_interval = params.beacon_interval;
-- 
1.7.0.4

