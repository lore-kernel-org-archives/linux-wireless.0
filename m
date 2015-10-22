Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33562 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbbJVPfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 11:35:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211/mac80211: clarify RSSI CQM reporting requirements
Date: Thu, 22 Oct 2015 17:35:14 +0200
Message-Id: <1445528114-5421-1-git-send-email-johannes@sipsolutions.net> (sfid-20151022_173524_896611_D40355AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The previous patch changed mac80211 to always report an event
after a CQM RSSI reconfiguration. Document that as expected
behaviour in both the cfg80211 and mac80211 API.

Currently, iwlmvm already implements that behaviour; the other
drivers implementing CQM RSSI events may have to be changed.

This behaviour lets userspace know what the current state is
without relying on querying the data which is racy.

Reviewed-by: Sharon, Sara <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 4 ++++
 include/net/mac80211.h | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 48155be5db7f..2c7bdb81d30c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2399,6 +2399,10 @@ struct cfg80211_qos_map {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ *	After configuration, the driver should (soon) send an event indicating
+ *	the current level is above/below the configured threshold; this may
+ *	need some care when the configuration is changed (without first being
+ *	disabled.)
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4b9dd070aeb9..dac575c55c62 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -482,7 +482,9 @@ struct ieee80211_event {
  *	Note that with TDLS this can be the case (channel is HT, protection must
  *	be used from this field) even when the BSS association isn't using HT.
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
- *	implies disabled
+ *	implies disabled. As with the cfg80211 callback, a change here should
+ *	cause an event to be sent indicating where the current value is in
+ *	relation to the newly configured threshold.
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
  * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
  *	may filter ARP queries targeted for other addresses than listed here.
-- 
2.5.1

