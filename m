Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1DSSoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 14:44:08 -0400
Subject: [PATCH 2.6.39] mac80211: fix SMPS debugfs locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 20:44:04 +0200
Message-ID: <1303238644.3489.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The locking with SMPS requests means that the
debugs file should lock the mgd mutex, not the
iflist mutex. Calls to __ieee80211_request_smps()
need to hold that mutex, so add an assertion.

This has always been wrong, but for some reason
never been noticed, probably because the locking
error only happens while unassociated.

Cc: stable@kernel.org [2.6.34+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c            |    2 ++
 net/mac80211/debugfs_netdev.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/debugfs_netdev.c	2011-04-19 17:41:45.000000000 +0200
+++ b/net/mac80211/debugfs_netdev.c	2011-04-19 20:38:44.000000000 +0200
@@ -177,9 +177,9 @@ static int ieee80211_set_smps(struct iee
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
-	mutex_lock(&local->iflist_mtx);
+	mutex_lock(&sdata->u.mgd.mtx);
 	err = __ieee80211_request_smps(sdata, smps_mode);
-	mutex_unlock(&local->iflist_mtx);
+	mutex_unlock(&sdata->u.mgd.mtx);
 
 	return err;
 }
--- a/net/mac80211/cfg.c	2011-04-19 20:38:09.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-04-19 20:38:28.000000000 +0200
@@ -1526,6 +1526,8 @@ int __ieee80211_request_smps(struct ieee
 	enum ieee80211_smps_mode old_req;
 	int err;
 
+	lockdep_assert_held(&sdata->u.mgd.mtx);
+
 	old_req = sdata->u.mgd.req_smps;
 	sdata->u.mgd.req_smps = smps_mode;
 


