Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34940 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab1IVWpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 18:45:23 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.1] iwlagn: fix dangling scan request
Date: Thu, 22 Sep 2011 14:59:04 -0700
Message-Id: <1316728744-23701-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_004527_207704_577C08A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If iwl_scan_initiate() fails for any reason,
priv->scan_request and priv->scan_vif are left
dangling. This can lead to a crash later when
iwl_bg_scan_completed() tries to run a pending
scan request.

In practice, this seems to be very rare due to
the STATUS_SCANNING check earlier. That check,
however, is wrong -- it should allow a scan to
be queued when a reset/roc scan is going on.
When a normal scan is already going on, a new
one can't be issued by mac80211, so that code
can be removed completely. I introduced this
bug when adding off-channel support in commit
266af4c745952e9bebf687dd68af58df553cb59d.

Cc: stable@kernel.org [3.0]
Reported-by: Peng Yan <peng.yan@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
hese patches are also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-scan.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index dd6937e..77e528f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -405,31 +405,33 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    priv->scan_type != IWL_SCAN_NORMAL) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	/* mac80211 will only ask for one band at a time */
-	priv->scan_request = req;
-	priv->scan_vif = vif;
-
 	/*
 	 * If an internal scan is in progress, just set
 	 * up the scan_request as per above.
 	 */
 	if (priv->scan_type != IWL_SCAN_NORMAL) {
-		IWL_DEBUG_SCAN(priv, "SCAN request during internal scan\n");
+		IWL_DEBUG_SCAN(priv,
+			       "SCAN request during internal scan - defer\n");
+		priv->scan_request = req;
+		priv->scan_vif = vif;
 		ret = 0;
-	} else
+	} else {
+		priv->scan_request = req;
+		priv->scan_vif = vif;
+		/*
+		 * mac80211 will only ask for one band at a time
+		 * so using channels[0] here is ok
+		 */
 		ret = iwl_scan_initiate(priv, vif, IWL_SCAN_NORMAL,
 					req->channels[0]->band);
+		if (ret) {
+			priv->scan_request = NULL;
+			priv->scan_vif = NULL;
+		}
+	}
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-out_unlock:
 	mutex_unlock(&priv->mutex);
 
 	return ret;
-- 
1.7.0.4

