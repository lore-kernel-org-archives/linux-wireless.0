Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34310 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYKYLFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 06:05:48 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: disassociate prior to unlinking AP/station
Date: Tue, 25 Nov 2008 13:05:44 +0200
Message-Id: <1227611144-20081-1-git-send-email-tomas.winkler@intel.com> (sfid-20081125_120552_726921_E28D3B32)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reorders calls during disassociation in
ieee80211_set_disassoc function.
Since sta_info_unlink calls sta_notify(REMOVE) it will
remove the station representing AP from the driver before
it has disassociated from it using bss_info_changed callback.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 88b0b4d..2a827eb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -861,16 +861,26 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT)
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 
-	sta_info_unlink(&sta);
-
 	rcu_read_unlock();
 
-	sta_info_destroy(sta);
-
 	local->hw.conf.ht.enabled = false;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, ifsta->bssid);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	sta_info_unlink(&sta);
+
+	rcu_read_unlock();
+
+	sta_info_destroy(sta);
 }
 
 static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

