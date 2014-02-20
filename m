Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaBTPOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 10:14:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: document sched_scan_stop synchronous behaviour
Date: Thu, 20 Feb 2014 16:14:10 +0100
Message-Id: <1392909251-5557-1-git-send-email-johannes@sipsolutions.net> (sfid-20140220_161422_053235_8F6171D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to userspace assumptions, the sched_scan_stop operation must
be synchronous, i.e. once it returns a new scheduled scan must be
able to start immediately. Document this in the API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 7 ++++++-
 include/uapi/linux/nl80211.h | 5 +++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c89a5b5bd103..7c9fe4b05927 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2206,7 +2206,12 @@ struct cfg80211_qos_map {
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
- * @sched_scan_stop: Tell the driver to stop an ongoing scheduled scan.
+ * @sched_scan_stop: Tell the driver to stop an ongoing scheduled scan. This
+ *	call must stop the scheduled scan and be ready for starting a new one
+ *	before it returns, i.e. @sched_scan_start may be called immediately
+ *	after that again and should not fail in that case. The driver should
+ *	not call cfg80211_sched_scan_stopped() for a requested stop (when this
+ *	method returns 0.)
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 47d7087513e0..81481cff1dc1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -303,8 +303,9 @@
  *	passed, all channels allowed for the current regulatory domain
  *	are used.  Extra IEs can also be passed from the userspace by
  *	using the %NL80211_ATTR_IE attribute.
- * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan.  Returns -ENOENT
- *	if scheduled scan is not running.
+ * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan. Returns -ENOENT if
+ *	scheduled scan is not running. The caller may assume that as soon
+ *	as the call returns, it is safe to start a new scheduled scan again.
  * @NL80211_CMD_SCHED_SCAN_RESULTS: indicates that there are scheduled scan
  *	results available.
  * @NL80211_CMD_SCHED_SCAN_STOPPED: indicates that the scheduled scan has
-- 
1.8.5.3

