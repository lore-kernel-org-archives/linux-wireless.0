Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab0AUPzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 10:55:01 -0500
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: tell driver when dtim change detected
Date: Thu, 21 Jan 2010 07:51:30 -0800
Message-Id: <1264089090-7014-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In current implementation, mac80211 send dtim_period update to driver during
association, but if no NetworkManager or similar application perform scan
operation, plus tim_ie is not part of probe response; mac80211 will not get
beacon with dtim information later, then  mac80211 will not pass the 
information to driver for update.

Call ieee80211_hw_config() with IEEE80211_CONF_CHANGE_PS flag set to
allow driver make correct dtim adjustment if dtim_period change detected.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/scan.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 71e10ca..a5508f5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -64,6 +64,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	struct ieee80211_bss *bss;
 	int clen;
 	s32 signal = 0;
+	struct ieee80211_sub_if_data *sdata;
 
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		signal = rx_status->signal * 100;
@@ -87,7 +88,23 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	if (elems->tim) {
 		struct ieee80211_tim_ie *tim_ie =
 			(struct ieee80211_tim_ie *)elems->tim;
-		bss->dtim_period = tim_ie->dtim_period;
+		if (bss->dtim_period != tim_ie->dtim_period) {
+			bss->dtim_period = tim_ie->dtim_period;
+			mutex_lock(&local->iflist_mtx);
+			list_for_each_entry(sdata, &local->interfaces, list) {
+				if (!netif_running(sdata->dev))
+					continue;
+				if (sdata->vif.type ==
+				    NL80211_IFTYPE_STATION &&
+				    sdata->u.mgd.associated == bss) {
+					sdata->vif.bss_conf.dtim_period =
+						bss->dtim_period;
+					ieee80211_hw_config(local,
+						IEEE80211_CONF_CHANGE_PS);
+				}
+			}
+			mutex_unlock(&local->iflist_mtx);
+		}
 	}
 
 	/* set default value for buggy AP/no TIM element */
-- 
1.5.6.3

