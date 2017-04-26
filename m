Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54532 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956652AbdDZH7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Johannes Berg <johannes.berg@intel.com>
Date: Wed, 26 Apr 2017 10:58:52 +0300
Message-Id: <20170426075854.13546-8-luca@coelho.fi> (sfid-20170426_095926_748665_E039C209)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 7/9] ieee80211: fix kernel-doc parsing errors
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some of the enum definitions are unnamed but there's still
an attempt at documenting them - that doesn't work. Name
them to make that work.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 13f23036dc05..69033353d0d1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2177,37 +2177,37 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_BSS_COEX_INFORMATION_REQUEST	BIT(0)
 
 /**
- * enum - mesh synchronization method identifier
+ * enum ieee80211_mesh_sync_method - mesh synchronization method identifier
  *
  * @IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET: the default synchronization method
  * @IEEE80211_SYNC_METHOD_VENDOR: a vendor specific synchronization method
  *	that will be specified in a vendor specific information element
  */
-enum {
+enum ieee80211_mesh_sync_method {
 	IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET = 1,
 	IEEE80211_SYNC_METHOD_VENDOR = 255,
 };
 
 /**
- * enum - mesh path selection protocol identifier
+ * enum ieee80211_mesh_path_protocol - mesh path selection protocol identifier
  *
  * @IEEE80211_PATH_PROTOCOL_HWMP: the default path selection protocol
  * @IEEE80211_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will
  *	be specified in a vendor specific information element
  */
-enum {
+enum ieee80211_mesh_path_protocol {
 	IEEE80211_PATH_PROTOCOL_HWMP = 1,
 	IEEE80211_PATH_PROTOCOL_VENDOR = 255,
 };
 
 /**
- * enum - mesh path selection metric identifier
+ * enum ieee80211_mesh_path_metric - mesh path selection metric identifier
  *
  * @IEEE80211_PATH_METRIC_AIRTIME: the default path selection metric
  * @IEEE80211_PATH_METRIC_VENDOR: a vendor specific metric that will be
  *	specified in a vendor specific information element
  */
-enum {
+enum ieee80211_mesh_path_metric {
 	IEEE80211_PATH_METRIC_AIRTIME = 1,
 	IEEE80211_PATH_METRIC_VENDOR = 255,
 };
-- 
2.11.0
