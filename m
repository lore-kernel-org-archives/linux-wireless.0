Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3EWQMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 12:12:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] cfg80211: check wdev->netdev in connection work
Date: Thu, 23 May 2013 18:12:16 +0200
Message-Id: <1369325536-20085-1-git-send-email-johannes@sipsolutions.net> (sfid-20130523_181232_520106_98817C73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a P2P-Device is present and another virtual interface triggers
the connection work, the system crash because it tries to check
if the P2P-Device's netdev (which doesn't exist) is up. Skip any
wdevs that have no netdev to fix this.

Cc: stable@vger.kernel.org
Reported-by: YanBo <dreamfly281@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a9dc5c7..7801fff 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -231,6 +231,9 @@ void cfg80211_conn_work(struct work_struct *work)
 	mutex_lock(&rdev->sched_scan_mtx);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
-- 
1.8.0

