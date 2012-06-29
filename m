Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:45411 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab2F2Kr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:28 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 09/13] cfg80211: track monitor channel
Date: Fri, 29 Jun 2012 12:47:04 +0200
Message-ID: <1340966828-22874-10-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124747_091593_1FB8D17C)
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it even more obvious we support single
monitor channel. This will allow us to remove
.get_channel.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/chan.c |    9 ++++++++-
 net/wireless/core.c |    8 +++++++-
 net/wireless/core.h |    3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 019401b..434c56b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -82,6 +82,7 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 int freq, enum nl80211_channel_type chantype)
 {
 	struct ieee80211_channel *chan;
+	int err;
 
 	if (!rdev->ops->set_monitor_channel)
 		return -EOPNOTSUPP;
@@ -92,7 +93,13 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 	if (!chan)
 		return -EINVAL;
 
-	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
+	err = rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
+	if (!err) {
+		rdev->monitor_channel = chan;
+		rdev->monitor_channel_type = chantype;
+	}
+
+	return err;
 }
 
 void
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8412da7..1b5daa7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -730,9 +730,15 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 		rdev->num_running_monitor_ifaces += num;
 
 	has_monitors_only_new = cfg80211_has_monitors_only(rdev);
-	if (has_monitors_only_new != has_monitors_only_old)
+	if (has_monitors_only_new != has_monitors_only_old) {
 		rdev->ops->set_monitor_enabled(&rdev->wiphy,
 					       has_monitors_only_new);
+
+		if (!has_monitors_only_new) {
+			rdev->monitor_channel = NULL;
+			rdev->monitor_channel_type = NL80211_CHAN_NO_HT;
+		}
+	}
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 99acd51..d5efe1b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -59,6 +59,9 @@ struct cfg80211_registered_device {
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
 
+	struct ieee80211_channel *monitor_channel;
+	enum nl80211_channel_type monitor_channel_type;
+
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
 	struct list_head bss_list;
-- 
1.7.0.4

