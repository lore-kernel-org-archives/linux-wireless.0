Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbbCAHK1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/16] mac80211: Update beacon's timing and DTIM count on every beacon
Date: Sun,  1 Mar 2015 09:10:00 +0200
Message-Id: <1425193815-17785-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081039_784267_24193765)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Beacon's timestamp, device system time associated with this beacon and
DTIM count parameters are not updated in the associated vif context
if the latest beacon's content is identical to the previously received.
It make sense to update these changing parameters on every beacon so the
driver can get most updated values. This may be necessary, for example,
to avoid either beacons' drift effect or device time stamp overrun.
IMPORTANT: Three sync_* parameters - sync_ts, sync_device_ts and
sync_dtim_count would possibly be out of sync by the time the driver will
use them. The synchronized view is currently guaranteed only in certain
callbacks.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h |  7 +++++--
 net/mac80211/mlme.c    | 32 ++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d52914b..3a029f0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -337,12 +337,15 @@ enum ieee80211_rssi_event {
  *	HW flag %IEEE80211_HW_TIMING_BEACON_ONLY is set, then this can
  *	only come from a beacon, but might not become valid until after
  *	association when a beacon is received (which is notified with the
- *	%BSS_CHANGED_DTIM flag.)
+ *	%BSS_CHANGED_DTIM flag.). See also sync_dtim_count important notice.
  * @sync_device_ts: the device timestamp corresponding to the sync_tsf,
  *	the driver/device can use this to calculate synchronisation
- *	(see @sync_tsf)
+ *	(see @sync_tsf). See also sync_dtim_count important notice.
  * @sync_dtim_count: Only valid when %IEEE80211_HW_TIMING_BEACON_ONLY
  *	is requested, see @sync_tsf/@sync_device_ts.
+ *	IMPORTANT: These three sync_* parameters would possibly be out of sync
+ *	by the time the driver will use them. The synchronized view is currently
+ *	guaranteed only in certain callbacks.
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
  * @basic_rates: bitmap of basic rates, each bit stands for an
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 10ac632..cf3ae93 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3419,6 +3419,26 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->csa_waiting_bcn)
 		ieee80211_chswitch_post_beacon(sdata);
 
+	/*
+	 * Update beacon timing and dtim count on every beacon appearance. This
+	 * will allow the driver to use the most updated values. Do it before
+	 * comparing this one with last received beacon.
+	 * IMPORTANT: These parameters would possibly be out of sync by the time
+	 * the driver will use them. The synchronized view is currently
+	 * guaranteed only in certain callbacks.
+	 */
+	if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
+		sdata->vif.bss_conf.sync_tsf =
+			le64_to_cpu(mgmt->u.beacon.timestamp);
+		sdata->vif.bss_conf.sync_device_ts =
+			rx_status->device_timestamp;
+		if (elems.tim)
+			sdata->vif.bss_conf.sync_dtim_count =
+				elems.tim->dtim_count;
+		else
+			sdata->vif.bss_conf.sync_dtim_count = 0;
+	}
+
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
@@ -3446,18 +3466,6 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		else
 			bss_conf->dtim_period = 1;
 
-		if (local->hw.flags & IEEE80211_HW_TIMING_BEACON_ONLY) {
-			sdata->vif.bss_conf.sync_tsf =
-				le64_to_cpu(mgmt->u.beacon.timestamp);
-			sdata->vif.bss_conf.sync_device_ts =
-				rx_status->device_timestamp;
-			if (elems.tim)
-				sdata->vif.bss_conf.sync_dtim_count =
-					elems.tim->dtim_count;
-			else
-				sdata->vif.bss_conf.sync_dtim_count = 0;
-		}
-
 		changed |= BSS_CHANGED_BEACON_INFO;
 		ifmgd->have_beacon = true;
 
-- 
1.9.1

