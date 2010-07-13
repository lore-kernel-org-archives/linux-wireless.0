Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab0GMI4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 04:56:03 -0400
Subject: [PATCH] cfg80211: don't get expired BSSes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	jiajia.zheng@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 10:55:38 +0200
Message-ID: <1279011338.3758.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When kernel-internal users use cfg80211_get_bss()
to get a reference to a BSS struct, they may end
up getting one that would have been removed from
the list if there had been any userspace access
to the list. This leads to inconsistencies and
problems.

Fix it by making cfg80211_get_bss() ignore BSSes
that cfg80211_bss_expire() would remove.

Fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2180

Cc: stable@kernel.org
Reported-by: Jiajia Zheng <jiajia.zheng@intel.com>
Tested-by: Jiajia Zheng <jiajia.zheng@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- wireless-testing.orig/net/wireless/scan.c	2010-07-13 10:21:04.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2010-07-13 10:25:23.000000000 +0200
@@ -275,6 +275,7 @@ struct cfg80211_bss *cfg80211_get_bss(st
 {
 	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
+	unsigned long now = jiffies;
 
 	spin_lock_bh(&dev->bss_lock);
 
@@ -283,6 +284,10 @@ struct cfg80211_bss *cfg80211_get_bss(st
 			continue;
 		if (channel && bss->pub.channel != channel)
 			continue;
+		/* Don't get expired BSS structs */
+		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
+		    !atomic_read(&bss->hold))
+			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
 			res = bss;
 			kref_get(&res->ref);


