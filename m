Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64564 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYKNWoY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 17:44:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 14:44:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: don't assume driver has been attached on registration
Date: Fri, 14 Nov 2008 14:44:22 -0800
Message-ID: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com> (sfid-20081114_234428_933381_3CC6F744)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's ieee80211_register_hw() is often called within the
probe path so it cannot assume the device's driver structure
has been attached yet so to create a workqueue instead of
using driver->name use the wiphy's phy%d name. The name doesn't
really matter anyway.

This should fix sporadic oopses found when we race to beat the
driver pointer setting. Not even sure how this was working properly.

http://www.kerneloops.org/search.php?search=ieee80211_register_hw

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---

This has been acked now.

 net/mac80211/main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d631dc9..cec9b6d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -722,7 +722,6 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	const char *name;
 	int result;
 	enum ieee80211_band band;
 	struct net_device *mdev;
@@ -787,8 +786,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	mdev->header_ops = &ieee80211_header_ops;
 	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
 
-	name = wiphy_dev(local->hw.wiphy)->driver->name;
-	local->hw.workqueue = create_freezeable_workqueue(name);
+	local->hw.workqueue =
+		create_freezeable_workqueue(wiphy_name(local->hw.wiphy));
 	if (!local->hw.workqueue) {
 		result = -ENOMEM;
 		goto fail_workqueue;
-- 
1.5.6.3

