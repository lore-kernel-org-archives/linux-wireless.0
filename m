Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab2GaLcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:32:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3/4] mac80211: add IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF
Date: Tue, 31 Jul 2012 13:32:17 +0200
Message-Id: <1343734338-14772-4-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133230_028937_3C4FC901)
In-Reply-To: <1343734338-14772-1-git-send-email-johannes@sipsolutions.net>
References: <1343734338-14772-1-git-send-email-johannes@sipsolutions.net>
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
index 8114f59..6bca2a9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1216,6 +1216,10 @@ struct ieee80211_tx_control {
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
@@ -1243,6 +1247,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
+	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0dafd38..4da014f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1333,7 +1333,6 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	    local->hw.wiphy->n_addresses <= 1)
 		return;
 
-
 	mutex_lock(&local->iflist_mtx);
 
 	switch (type) {
@@ -1351,6 +1350,19 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
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
@@ -1425,6 +1437,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		break;
 	}
 
+ out_unlock:
 	mutex_unlock(&local->iflist_mtx);
 }
 
-- 
1.7.10.4

