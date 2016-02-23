Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:54003 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbcBWVF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 16:05:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: report CLOCK_BOOTTIME for scan results
Date: Tue, 23 Feb 2016 23:05:06 +0200
Message-Id: <1456261506-30469-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160223_220529_471485_737D3F4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was requested by Android, and the appropriate cfg80211 API
had been added by Dmitry. Support it in mac80211, allowing drivers
to provide the timestamp.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 3 +++
 net/mac80211/scan.c    | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9cf92d0..7cb791f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1123,6 +1123,8 @@ enum mac80211_rx_vht_flags {
  *
  * @mactime: value in microseconds of the 64-bit Time Synchronization Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
+ * @boottime_ns: CLOCK_BOOTTIME timestamp the frame was received at, this is
+ *	needed only for beacons and probe responses that update the scan cache.
  * @device_timestamp: arbitrary timestamp for the device, mac80211 doesn't use
  *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
@@ -1149,6 +1151,7 @@ enum mac80211_rx_vht_flags {
  */
 struct ieee80211_rx_status {
 	u64 mactime;
+	u64 boottime_ns;
 	u32 device_timestamp;
 	u32 ampdu_reference;
 	u64 flag;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a413e52..612f410 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -66,7 +66,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	int clen, srlen;
-	struct cfg80211_inform_bss bss_meta = {};
+	struct cfg80211_inform_bss bss_meta = {
+		.boottime_ns = rx_status->boottime_ns,
+	};
 	bool signal_valid;
 
 	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
-- 
2.5.0

