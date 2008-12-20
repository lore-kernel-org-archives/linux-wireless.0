Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:4718 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYLTKCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:03 -0500
Received: by ey-out-2122.google.com with SMTP id 22so125894eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:02 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 8/15] rt2x00: Implement WDS support
Date: Sat, 20 Dec 2008 10:57:02 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201055.58126.IvDoorn@gmail.com> <200812201056.36218.IvDoorn@gmail.com>
In-Reply-To: <200812201056.36218.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201057.02583.IvDoorn@gmail.com> (sfid-20081220_110214_294570_9C2013C2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WDS support should be very easy to handle, mac80211 handles
everything for us, so all that is needed is to set the
support flags and handle it in the add_interface() callback.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00config.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    9 ++++++---
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index a35265c..ab139f2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -43,6 +43,7 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_WDS:
 		conf.sync = TSF_SYNC_BEACON;
 		break;
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b484197..3cb417f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -191,7 +191,8 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_ADHOC &&
-	    vif->type != NL80211_IFTYPE_MESH_POINT)
+	    vif->type != NL80211_IFTYPE_MESH_POINT &&
+	    vif->type != NL80211_IFTYPE_WDS)
 		return;
 
 	/*
@@ -784,7 +785,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->hw->wiphy->interface_modes |=
 		    BIT(NL80211_IFTYPE_ADHOC) |
 		    BIT(NL80211_IFTYPE_AP) |
-		    BIT(NL80211_IFTYPE_MESH_POINT);
+		    BIT(NL80211_IFTYPE_MESH_POINT) |
+		    BIT(NL80211_IFTYPE_WDS);
 
 	/*
 	 * Let the driver probe the device to detect the capabilities.
@@ -943,7 +945,8 @@ static void rt2x00lib_resume_intf(void *data, u8 *mac,
 	 */
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC ||
-	    vif->type == NL80211_IFTYPE_MESH_POINT)
+	    vif->type == NL80211_IFTYPE_MESH_POINT ||
+	    vif->type == NL80211_IFTYPE_WDS)
 		intf->delayed_flags |= DELAYED_UPDATE_BEACON;
 
 	spin_unlock(&intf->lock);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 137386e..e6fba83 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -227,6 +227,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_WDS:
 		/*
 		 * We don't support mixed combinations of
 		 * sta and ap interfaces.
-- 
1.5.6.1

