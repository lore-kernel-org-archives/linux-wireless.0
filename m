Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2704 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab0BBSym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 13:54:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.33] mac80211: fix deferred hardware scan requests
Date: Tue,  2 Feb 2010 10:54:38 -0800
Message-Id: <1265136878-5844-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265136878-5844-1-git-send-email-reinette.chatre@intel.com>
References: <1265136878-5844-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

mac80211 will defer the handling of scan requests if it is busy
with management work at the time. The scan requests are
deferred and run after the work has completed. When this occurs
there are currently two problems.

* The scan request for hardware scan is not fully populated with
  the band and channels to scan not initialized.
* When the scan is queued the state is not correctly updated to
  reflect that a scan is in progress. The problem here is that when
  the driver completes the scan and calls ieee80211_scan_completed()
  a warning will be triggered since mac80211 was not aware that a scan
  was in progress.

Both issues are fixed here by first ensuring that scan request is fully
initialized before it is queued and next by setting the scanning state
correctly before it is queued for execution.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/mlme.c |    9 ++++++++-
 net/mac80211/scan.c |    8 +++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 05a18f4..efbc3f9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2196,10 +2196,17 @@ static void ieee80211_sta_work(struct work_struct *work)
 		}
 	}
 	if (!anybusy &&
-	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request))
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request)) {
+		if (local->ops->hw_scan)
+			__set_bit(SCAN_HW_SCANNING, &local->scanning);
+		/*
+		 * For software scanning ieee80211_scan_work expects
+		 * to be called without local->scanning set.
+		 */
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
 					     round_jiffies_relative(0));
+	}
 
 	mutex_unlock(&ifmgd->mtx);
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f934c96..e0f688c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -463,6 +463,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
+	if (local->ops->hw_scan)
+		WARN_ON(!ieee80211_prep_hw_scan(local));
+
 	if (req != local->int_scan_req &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !list_empty(&ifmgd->work_list)) {
@@ -489,10 +492,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->scan_mtx);
 
-	if (local->ops->hw_scan) {
-		WARN_ON(!ieee80211_prep_hw_scan(local));
+	if (local->ops->hw_scan)
 		rc = drv_hw_scan(local, local->hw_scan_req);
-	} else
+	else
 		rc = ieee80211_start_sw_scan(local);
 
 	mutex_lock(&local->scan_mtx);
-- 
1.6.3.3

