Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53948 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYLTKB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:01:58 -0500
Received: by ey-out-2122.google.com with SMTP id 22so125886eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:01:58 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/15] rt2x00: Add mesh support
Date: Sat, 20 Dec 2008 10:55:34 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201054.22904.IvDoorn@gmail.com> <200812201054.54391.IvDoorn@gmail.com>
In-Reply-To: <200812201054.54391.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201055.34597.IvDoorn@gmail.com> (sfid-20081220_110209_452724_61BF41E6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Yurovsky <andrey@cozybit.com>

This adds initial support for Mesh Point mode.  For this we tell mac80211 that
we support NL80211_IFTYPE_MESH_POINT.  We also need to send beacons.  mac80211
will configure our RX filter accordingly.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   11 +++++++----
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 2f4cb8d..a35265c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -42,6 +42,7 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		conf.sync = TSF_SYNC_BEACON;
 		break;
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 1c49a9c..b484197 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -190,7 +190,8 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 
 	if (vif->type != NL80211_IFTYPE_AP &&
-	    vif->type != NL80211_IFTYPE_ADHOC)
+	    vif->type != NL80211_IFTYPE_ADHOC &&
+	    vif->type != NL80211_IFTYPE_MESH_POINT)
 		return;
 
 	/*
@@ -782,7 +783,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00dev->ops->bcn->entry_num > 0)
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
-		    BIT(NL80211_IFTYPE_AP);
+		    BIT(NL80211_IFTYPE_AP) |
+		    BIT(NL80211_IFTYPE_MESH_POINT);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
@@ -937,10 +939,11 @@ static void rt2x00lib_resume_intf(void *data, u8 *mac,
 
 
 	/*
-	 * Master or Ad-hoc mode require a new beacon update.
+	 * AP, Ad-hoc, and Mesh Point mode require a new beacon update.
 	 */
 	if (vif->type == NL80211_IFTYPE_AP ||
-	    vif->type == NL80211_IFTYPE_ADHOC)
+	    vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_MESH_POINT)
 		intf->delayed_flags |= DELAYED_UPDATE_BEACON;
 
 	spin_unlock(&intf->lock);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 38edee5..137386e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -226,6 +226,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		/*
 		 * We don't support mixed combinations of
 		 * sta and ap interfaces.
-- 
1.5.6.1

