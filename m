Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60788 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755451AbcJUMZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:25:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>,
        jouni@qca.qualcomm.com, usdutt@qti.qualcomm.com,
        amarnath@qca.qualcomm.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] cfg80211: mesh: track (and thus validate) beacon interval
Date: Fri, 21 Oct 2016 14:25:11 +0200
Message-Id: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net> (sfid-20161021_142535_723754_7D056CDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is needed for beacon interval validation; if we don't
store it, then new interfaces added won't validate that the
beacon interval is the same as existing ones. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mesh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index fa2066b56f36..2d8518a37eab 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -183,6 +183,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
 		wdev->mesh_id_len = setup->mesh_id_len;
 		wdev->chandef = setup->chandef;
+		wdev->beacon_interval = setup->beacon_interval;
 	}
 
 	return err;
@@ -258,6 +259,7 @@ int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 	err = rdev_leave_mesh(rdev, dev);
 	if (!err) {
 		wdev->mesh_id_len = 0;
+		wdev->beacon_interval = 0;
 		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 		rdev_set_qos_map(rdev, dev, NULL);
 	}
-- 
2.8.1
