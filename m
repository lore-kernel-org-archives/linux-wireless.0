Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2G0LC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:02:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: add IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF
Date: Fri, 27 Jul 2012 13:02:51 +0200
Message-Id: <1343386972-5044-4-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130305_606764_CD8A1855)
In-Reply-To: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net>
References: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some devices like the current iwlwifi implementation
require that the P2P interface address match the P2P
Device address (only one P2P interface is supported.)
Add the HW flag IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF
that allows drivers to request that P2P Interfaces
added while a P2P Device is active get the same MAC
address by default.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/iface.c   |   15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bb86aa6..924b6c1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1203,6 +1203,10 @@ enum sta_notify_cmd {
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
  *	control for more details.
+ *
+ * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
+ *	P2P Interface. This will be honoured even if more than one interface
+ *	is supported.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1230,6 +1234,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
+	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index aa985ea..f280e1f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1320,7 +1320,6 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	    local->hw.wiphy->n_addresses <= 1)
 		return;
 
-
 	mutex_lock(&local->iflist_mtx);
 
 	switch (type) {
@@ -1338,6 +1337,19 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		}
 		/* keep default if no AP interface present */
 		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		if (local->hw.flags & IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF) {
+			list_for_each_entry(sdata, &local->interfaces, list) {
+				if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
+					continue;
+				if (!ieee80211_sdata_running(sdata))
+					continue;
+				memcpy(perm_addr, sdata->vif.addr, ETH_ALEN);
+				goto out_unlock;
+			}
+		}
+		/* otherwise fall through */
 	default:
 		/* assign a new address if possible -- try n_addresses first */
 		for (i = 0; i < local->hw.wiphy->n_addresses; i++) {
@@ -1412,6 +1424,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		break;
 	}
 
+ out_unlock:
 	mutex_unlock(&local->iflist_mtx);
 }
 
-- 
1.7.10.4

