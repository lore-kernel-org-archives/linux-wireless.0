Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24375 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0AUUfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 15:35:19 -0500
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH v2 1/1] mac80211: tell driver when dtim change detected
Date: Thu, 21 Jan 2010 12:31:48 -0800
Message-Id: <1264105908-10757-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In current implementation, mac80211 send dtim_period update to driver
during association, but if no NetworkManager or similar application perform
scan operation, plus tim_ie is not part of probe response; mac80211 will not
get beacon with dtim information later, then  mac80211 will not pass the
information to driver for update.

Call ieee80211_hw_config() with IEEE80211_CONF_CHANGE_PS flag set to
allow driver make correct dtim adjustment if dtim_period change
detected. Also perform recalc_ps operation if needed.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
v2: move the function to ieee80211_rx_bss_info() to make sure only call
    when needed
---
 net/mac80211/mlme.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1e1d16c..1cc1b5b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1157,6 +1157,23 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 }
 
 
+static void ieee80211_update_dtim(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_local *local,
+				  struct ieee80211_bss *bss)
+{
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+		return;
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    sdata->vif.bss_conf.dtim_period != bss->dtim_period) {
+		sdata->vif.bss_conf.dtim_period = bss->dtim_period;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		mutex_lock(&local->iflist_mtx);
+		ieee80211_recalc_ps(local, -1);
+		mutex_unlock(&local->iflist_mtx);
+	}
+}
+
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
@@ -1181,8 +1198,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel, beacon);
-	if (bss)
+	if (bss) {
 		ieee80211_rx_bss_put(local, bss);
+		ieee80211_update_dtim(sdata, local, bss);
+	}
 
 	if (!sdata->u.mgd.associated)
 		return;
-- 
1.5.6.3

