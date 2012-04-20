Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2DTQnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 12:43:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH v3 1/1] mac80211: declare ieee80211_ave_rssi as EXPORT
Date: Fri, 20 Apr 2012 09:38:33 -0700
Message-Id: <1334939913-9787-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120420_184322_245950_94B6B16E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_ave_rssi need to be declare as export for driver to use it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/util.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89c1e5b..4a8cd29 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1794,6 +1794,14 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
 	return 0;
 }
 
+/**
+ * ieee80211_ave_rssi - report the average rssi for the specified interface
+ *
+ * @vif: the specified virtual interface
+ *
+ * This function return the average rssi value for the requested interface.
+ * It assumes that the given vif is valid.
+ */
 int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
@@ -1801,3 +1809,4 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 
 	return ifmgd->ave_beacon_signal;
 }
+EXPORT_SYMBOL_GPL(ieee80211_ave_rssi);
-- 
1.7.0.4

