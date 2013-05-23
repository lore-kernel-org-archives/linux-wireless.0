Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757Ab3EWXKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 19:10:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] mac80211: close AP_VLAN interfaces before unregistering all
Date: Fri, 24 May 2013 01:10:08 +0200
Message-Id: <1369350608-26874-1-git-send-email-johannes@sipsolutions.net> (sfid-20130524_011018_018111_648D90EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since Eric's commit efe117ab8 ("Speedup ieee80211_remove_interfaces")
there's a bug in mac80211 when it unregisters with AP_VLAN interfaces
up. If the AP_VLAN interface was registered after the AP it belongs
to (which is the typical case) and then we get into this code path,
unregister_netdevice_many() will crash because it isn't prepared to
deal with interfaces being closed in the middle of it. Exactly this
happens though, because we iterate the list, find the AP master this
AP_VLAN belongs to and dev_close() the dependent VLANs. After this,
unregister_netdevice_many() won't pick up the fact that the AP_VLAN
is already down and will do it again, causing a crash.

Cc: stable@vger.kernel.org [2.6.33+]
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 00e2238..ceef644 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1703,6 +1703,15 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
 	ASSERT_RTNL();
 
+	/*
+	 * Close all AP_VLAN interfaces first, as otherwise they
+	 * might be closed while the AP interface they belong to
+	 * is closed, causing unregister_netdevice_many() to crash.
+	 */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			dev_close(sdata->dev);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
-- 
1.8.0

