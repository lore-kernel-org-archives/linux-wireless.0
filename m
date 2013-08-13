Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab3HMH3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 03:29:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: neilb@suse.de, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11] cfg80211: don't request disconnect if not connected
Date: Tue, 13 Aug 2013 09:29:36 +0200
Message-Id: <1376378976-9588-1-git-send-email-johannes@sipsolutions.net> (sfid-20130813_092948_171352_CB47677C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Neil Brown reports that with libertas, my recent cfg80211
SME changes in commit ceca7b7121795ef81bd598a240d53a92566
("cfg80211: separate internal SME implementation") broke
libertas suspend because it we now asked it to disconnect
while already disconnected.

The problematic change is in cfg80211_disconnect() as it
previously checked the SME state and now calls the driver
disconnect operation unconditionally.

Fix this by checking if there's a current_bss indicating
a connection, and do nothing if not.

Reported-and-tested-by: Neil Brown <neilb@suse.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 81c8a10..20e86a9 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -976,21 +976,19 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason, bool wextev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int err;
+	int err = 0;
 
 	ASSERT_WDEV_LOCK(wdev);
 
 	kfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
-	if (wdev->conn) {
+	if (wdev->conn)
 		err = cfg80211_sme_disconnect(wdev, reason);
-	} else if (!rdev->ops->disconnect) {
+	else if (!rdev->ops->disconnect)
 		cfg80211_mlme_down(rdev, dev);
-		err = 0;
-	} else {
+	else if (wdev->current_bss)
 		err = rdev_disconnect(rdev, dev, reason);
-	}
 
 	return err;
 }
-- 
1.8.0

