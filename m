Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab3EWTQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 15:16:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] mac80211: fix queue handling crash
Date: Thu, 23 May 2013 21:16:09 +0200
Message-Id: <1369336569-13358-1-git-send-email-johannes@sipsolutions.net> (sfid-20130523_211619_431464_2B97C9D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code I added in "mac80211: don't start new netdev queues
if driver stopped" crashes for monitor and AP VLAN interfaces
because while they have a netdev, they don't have queues set
up by the driver.

To fix the crash, exclude these from queue accounting here
and just start their netdev queues unconditionally.

For monitor, this is the best we can do, as we can redirect
frames there to any other interface and don't know which one
that will since it can be different for each frame.

For AP VLAN interfaces, we can do better later and actually
properly track the queue status. Not doing this is really a
separate bug though.

Reported-by: Ilan Peer <ilan.peer@intel.com>
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..68f51c3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -653,7 +653,11 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 	ieee80211_recalc_ps(local, -1);
 
-	if (dev) {
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		/* XXX: for AP_VLAN, actually track AP queues */
+		netif_tx_start_all_queues(dev);
+	} else if (dev) {
 		unsigned long flags;
 		int n_acs = IEEE80211_NUM_ACS;
 		int ac;
-- 
1.8.0

