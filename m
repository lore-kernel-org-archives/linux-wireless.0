Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55602 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933268Ab0KMAba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 19:31:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 16:31:17 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH] cfg80211: fix extension channel checks to initiate communication
Date: Fri, 12 Nov 2010 16:31:23 -0800
Message-ID: <1289608283-3978-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating in a mode that initiates communication and using
HT40 we should fail if we cannot use both primary and secondary
channels to initiate communication. Our current ht40 allowmap
only covers STA mode of operation, for beaconing modes we need
a check on the fly as the mode of operation is dynamic and
there other flags other than disable which we should read
to check if we can initiate communication.

Do not allow for initiating communication if our secondary HT40
channel has is either disabled, has a passive scan flag, a
no-ibss flag or is a radar channel. Userspace now has similar
checks but this is also needed in-kernel.

Reported-by: Jouni Malinen <jouni.malinen@atheros.com>
Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/chan.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d0c92dd..c8d190d 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -44,6 +44,36 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 	return chan;
 }
 
+static bool can_beacon_sec_chan(struct wiphy *wiphy,
+				struct ieee80211_channel *chan,
+				enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_channel *sec_chan;
+	int diff;
+
+	switch (channel_type) {
+	case NL80211_CHAN_HT40PLUS:
+		diff = 20;
+	case NL80211_CHAN_HT40MINUS:
+		diff = -20;
+	default:
+		return false;
+	}
+
+	sec_chan = ieee80211_get_channel(wiphy, chan->center_freq + diff);
+	if (!sec_chan)
+		return false;
+
+	/* we'll need a DFS capability later */
+	if (sec_chan->flags & (IEEE80211_CHAN_DISABLED |
+			       IEEE80211_CHAN_PASSIVE_SCAN |
+			       IEEE80211_CHAN_NO_IBSS |
+			       IEEE80211_CHAN_RADAR))
+		return false;
+
+	return true;
+}
+
 int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, int freq,
 		      enum nl80211_channel_type channel_type)
@@ -68,6 +98,28 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	if (!chan)
 		return -EINVAL;
 
+	/* Both channels should be able to initiate communication */
+	if (wdev && (wdev->iftype == NL80211_IFTYPE_ADHOC ||
+		     wdev->iftype == NL80211_IFTYPE_AP ||
+		     wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
+		     wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
+		     wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
+		switch (channel_type) {
+		case NL80211_CHAN_HT40PLUS:
+		case NL80211_CHAN_HT40MINUS:
+			if (!can_beacon_sec_chan(&rdev->wiphy, chan,
+						 channel_type)) {
+				printk(KERN_DEBUG
+				       "cfg80211: Secondary channel not "
+				       "allowed to initiate communication\n");
+				return -EINVAL;
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
 	result = rdev->ops->set_channel(&rdev->wiphy,
 					wdev ? wdev->netdev : NULL,
 					chan, channel_type);
-- 
1.7.3.2.90.gd4c43

