Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:58990 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab0GQDNo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 23:13:44 -0400
Subject: [RFC] cfg80211: fix race between sysfs and cfg80211
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Jul 2010 05:13:35 +0200
Message-ID: <1279336415.1941.6.camel@kero>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


device_add() is called before adding the phy to the cfg80211 device
list.

So if a userspace program uses sysfs uevents to detect new phy
devices, and queries nl80211 to get phy info, it can get ENODEV even
though the phy exists in sysfs.

An easy workaround is to hold the cfg80211 mutex until the phy is
present both in sysfs and cfg80211 device list.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 net/wireless/core.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6ac70c1..8952ec4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -472,15 +472,19 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
+	mutex_lock(&cfg80211_mutex);
+
 	res = device_add(&rdev->wiphy.dev);
-	if (res)
+	if (res) {
+		mutex_unlock(&cfg80211_mutex);
 		return res;
+	}
 
 	res = rfkill_register(rdev->rfkill);
-	if (res)
+	if (res) {
+		mutex_unlock(&cfg80211_mutex);
 		goto out_rm_dev;
-
-	mutex_lock(&cfg80211_mutex);
+	}
 
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
-- 
1.7.1



-- 
Maxime

