Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62843 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab2F2Krb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:31 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 10/13] cfg80211: set initial monitor channel
Date: Fri, 29 Jun 2012 12:47:05 +0200
Message-ID: <1340966828-22874-11-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124748_645481_19493E73)
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implements behaviour seen in mac80211. A running
monitor always has a channel - even before
.set_channel. This way we won't break current
behaviour.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1b5daa7..580551e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -717,6 +717,35 @@ static struct device_type wiphy_type = {
 	.name	= "wlan",
 };
 
+static struct ieee80211_channel *
+cfg80211_get_any_chan(struct cfg80211_registered_device *rdev)
+{
+	struct ieee80211_supported_band *sband;
+	int i;
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		sband = rdev->wiphy.bands[i];
+		if (sband && sband->n_channels > 0)
+			return &sband->channels[0];
+	}
+
+	return NULL;
+}
+
+static void cfg80211_init_mon_chan(struct cfg80211_registered_device *rdev)
+{
+	struct ieee80211_channel *chan;
+
+	chan = cfg80211_get_any_chan(rdev);
+	if (WARN_ON(!chan))
+		return;
+
+	mutex_lock(&rdev->devlist_mtx);
+	WARN_ON(cfg80211_set_monitor_channel(rdev, chan->center_freq,
+					     NL80211_CHAN_NO_HT));
+	mutex_unlock(&rdev->devlist_mtx);
+}
+
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num)
 {
@@ -737,6 +766,8 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 		if (!has_monitors_only_new) {
 			rdev->monitor_channel = NULL;
 			rdev->monitor_channel_type = NL80211_CHAN_NO_HT;
+		} else {
+			cfg80211_init_mon_chan(rdev);
 		}
 	}
 }
-- 
1.7.0.4

