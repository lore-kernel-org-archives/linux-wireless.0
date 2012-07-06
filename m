Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2GFP6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 11:58:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: update BSS info on AC parameters change
Date: Fri,  6 Jul 2012 17:58:29 +0200
Message-Id: <1341590309-9799-1-git-send-email-johannes@sipsolutions.net> (sfid-20120706_175836_685994_9A02C101)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the AC parameters change, drivers might rely
on getting a bss_info_changed notification with
BSS_CHANGED_QOS in addition to the conf_tx call.

Always call the function when userspace updates
are made (in AP/GO modes) and also set the change
flag when updates were made by the AP (in managed
mode.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  |    2 ++
 net/mac80211/mlme.c |   28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ccbe241..6a171e2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1741,6 +1741,8 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
+
 	return 0;
 }
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d563f7c..6eab633 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1108,7 +1108,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 }
 
 /* MLME */
-static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
+static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
@@ -1119,23 +1119,23 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	u8 *pos, uapsd_queues = 0;
 
 	if (!local->ops->conf_tx)
-		return;
+		return false;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
-		return;
+		return false;
 
 	if (!wmm_param)
-		return;
+		return false;
 
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
-		return;
+		return false;
 
 	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
 		uapsd_queues = ifmgd->uapsd_queues;
 
 	count = wmm_param[6] & 0x0f;
 	if (count == ifmgd->wmm_last_param_set)
-		return;
+		return false;
 	ifmgd->wmm_last_param_set = count;
 
 	pos = wmm_param + 8;
@@ -1202,6 +1202,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 
 	/* enable WMM or activate new settings */
 	sdata->vif.bss_conf.qos = true;
+	return true;
 }
 
 static void __ieee80211_stop_poll(struct ieee80211_sub_if_data *sdata)
@@ -2438,14 +2439,6 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		directed_tim = ieee80211_check_tim(elems.tim, elems.tim_len,
 						   ifmgd->aid);
 
-	if (ncrc != ifmgd->beacon_crc || !ifmgd->beacon_crc_valid) {
-		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
-				      true);
-
-		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
-					 elems.wmm_param_len);
-	}
-
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
@@ -2476,6 +2469,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ifmgd->beacon_crc = ncrc;
 	ifmgd->beacon_crc_valid = true;
 
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
+			      true);
+
+	if (ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
+				     elems.wmm_param_len))
+		changed |= BSS_CHANGED_QOS;
+
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		erp_valid = true;
 		erp_value = elems.erp_info[0];
-- 
1.7.10.4

