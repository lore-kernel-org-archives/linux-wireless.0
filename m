Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15365 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYKMAVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 19:21:38 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH RFC 1/1] mac80211: disassociate prior to unlinking AP/sta
Date: Thu, 13 Nov 2008 02:21:33 +0200
Message-Id: <1226535693-22979-1-git-send-email-tomas.winkler@intel.com> (sfid-20081113_012142_693115_1F416268)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reorders calls during disassociation in
ieee80211_set_disassoc func.
Since sta_info_unlink calls sta_notify(REMOVE) it will
remove the AP from the driver before it has disassociated from
it (bss_info_changed).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 60ef983..ae831ab 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -857,16 +857,26 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (self_disconnected)
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

