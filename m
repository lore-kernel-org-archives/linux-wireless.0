Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:47920 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab2FTGO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:14:26 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFCv2 05/13] cfg80211: introduce cfg80211_get_chan_state
Date: Wed, 20 Jun 2012 08:14:11 +0200
Message-ID: <1340172859-18146-6-git-send-email-michal.kazior@tieto.com> (sfid-20120620_081512_683108_167D46FD)
In-Reply-To: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helper function for finding out which channel is
used by a given interface.

An exclusive channel can be used only by a single
interface. This is mainly for non-fixed channel
IBSS handling.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/chan.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h |   12 ++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c1999e4..167e7cb 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -92,3 +92,54 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 
 	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
 }
+
+void
+cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
+		        struct wireless_dev *wdev,
+		        struct ieee80211_channel **chan,
+		        enum cfg80211_chan_mode *chanmode)
+{
+	*chan = NULL;
+	*chanmode = CHAN_MODE_UNDEFINED;
+
+	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (!netif_running(wdev->netdev))
+		return;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		if (wdev->current_bss) {
+			*chan = wdev->current_bss->pub.channel;
+			*chanmode = wdev->ibss_fixed
+				  ? CHAN_MODE_SHARED
+				  : CHAN_MODE_EXCLUSIVE;
+			return;
+		}
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (wdev->current_bss) {
+			*chan = wdev->current_bss->pub.channel;
+			*chanmode = CHAN_MODE_SHARED;
+			return;
+		}
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
+		*chan = wdev->channel;
+		*chanmode = CHAN_MODE_SHARED;
+		return;
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+		/* these interface types don't really have a channel */
+		return;
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NUM_NL80211_IFTYPES:
+		WARN_ON(1);
+	}
+
+	return;
+}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a366ffd..bbf2f75 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -267,6 +267,12 @@ struct cfg80211_cached_keys {
 	int def, defmgmt;
 };
 
+enum cfg80211_chan_mode {
+	CHAN_MODE_UNDEFINED,
+	CHAN_MODE_SHARED,
+	CHAN_MODE_EXCLUSIVE,
+};
+
 
 /* free object */
 extern void cfg80211_dev_free(struct cfg80211_registered_device *rdev);
@@ -445,6 +451,12 @@ cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
 	return cfg80211_can_change_interface(rdev, NULL, iftype);
 }
 
+void
+cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
+		        struct wireless_dev *wdev,
+		        struct ieee80211_channel **chan,
+		        enum cfg80211_chan_mode *chanmode);
+
 struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type);
-- 
1.7.0.4

