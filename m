Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40809 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778AbaGQOOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:08 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2879725wiw.6
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:05 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/15] mac80211: fix error path for TDLS setup
Date: Thu, 17 Jul 2014 17:14:18 +0300
Message-Id: <1405606471-30128-3-git-send-email-arik@wizery.com> (sfid-20140717_161518_088753_B9E33219)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "8f02e6b mac80211: make sure TDLS peer STA exists during
setup" broke TDLS error paths where the STA doesn't exist when sending
the error.
Fix it by only testing for STA existence during a non-error flow.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index b01b310..53c235d 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -349,15 +349,19 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	/*
 	 * make sure we have a STA representing the peer so we drop or buffer
 	 * non-TDLS-setup frames to the peer. We can't send other packets
-	 * during setup through the AP path
+	 * during setup through the AP path.
+	 * Allow error packets to be sent - sometimes we don't even add a STA
+	 * before failing the setup.
 	 */
-	rcu_read_lock();
-	if (!sta_info_get(sdata, peer)) {
+	if (status_code == 0) {
+		rcu_read_lock();
+		if (!sta_info_get(sdata, peer)) {
+			rcu_read_unlock();
+			ret = -ENOLINK;
+			goto exit;
+		}
 		rcu_read_unlock();
-		ret = -ENOLINK;
-		goto exit;
 	}
-	rcu_read_unlock();
 
 	ieee80211_flush_queues(local, sdata);
 
-- 
1.9.1

