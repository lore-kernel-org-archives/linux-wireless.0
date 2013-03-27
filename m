Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3C0Qve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:51:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/3] mac80211: don't start new netdev queues if driver stopped
Date: Wed, 27 Mar 2013 17:51:22 +0100
Message-Id: <1364403082-20722-4-git-send-email-johannes@sipsolutions.net> (sfid-20130327_175137_611172_2F25F0C3)
In-Reply-To: <1364403082-20722-1-git-send-email-johannes@sipsolutions.net>
References: <1364403082-20722-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a new netdev (e.g. an AP VLAN) is created while the driver
has queues stopped, the new netdev queues will be started even
though they shouldn't. This will lead to frames accumulating
on the internal mac80211 pending queues instead of properly
being held on the netdev queues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 273d851..79f3758 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -639,8 +639,28 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 	ieee80211_recalc_ps(local, -1);
 
-	if (dev)
-		netif_tx_start_all_queues(dev);
+	if (dev) {
+		unsigned long flags;
+		int n_acs = IEEE80211_NUM_ACS;
+		int ac;
+
+		if (local->hw.queues < IEEE80211_NUM_ACS)
+			n_acs = 1;
+
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		if (sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE ||
+		    (local->queue_stop_reasons[sdata->vif.cab_queue] == 0 &&
+		     skb_queue_empty(&local->pending[sdata->vif.cab_queue]))) {
+			for (ac = 0; ac < n_acs; ac++) {
+				int ac_queue = sdata->vif.hw_queue[ac];
+
+				if (local->queue_stop_reasons[ac_queue] == 0 &&
+				    skb_queue_empty(&local->pending[ac_queue]))
+					netif_start_subqueue(dev, ac);
+			}
+		}
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
 
 	return 0;
  err_del_interface:
-- 
1.8.0

