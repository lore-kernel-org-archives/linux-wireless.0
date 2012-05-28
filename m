Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64704 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2E1LTj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:39 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 06/14] cfg80211: introduce cfg80211_get_used_channel
Date: Mon, 28 May 2012 13:18:54 +0200
Message-ID: <1338203942-5667-7-git-send-email-michal.kazior@tieto.com> (sfid-20120528_132034_751387_8FE7EE5C)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helper function for finding out which channel is
used by a given interface.

Will be used for matching interface combinations.

Change-Id: Ic9e5a68d66aaa26e73901648b04a6e9b465430d0
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/chan.c |   31 +++++++++++++++++++++++++++++++
 net/wireless/core.h |    4 ++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c1999e4..45b28ab 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -92,3 +92,34 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 
 	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
 }
+
+struct ieee80211_channel *
+cfg80211_get_used_channel(struct cfg80211_registered_device *rdev,
+			  struct wireless_dev *wdev)
+{
+	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_WDEV_LOCK(wdev);
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (wdev->current_bss)
+			return wdev->current_bss->pub.channel;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
+		return wdev->channel;
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+		/* these interface types don't really have a channel */
+		return NULL;
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NUM_NL80211_IFTYPES:
+		WARN_ON(1);
+	}
+
+	return NULL;
+}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a366ffd..54c24de 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -446,6 +446,10 @@ cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
 }
 
 struct ieee80211_channel *
+cfg80211_get_used_channel(struct cfg80211_registered_device *rdev,
+			  struct wireless_dev *wdev);
+
+struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type);
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
-- 
1.7.0.4

