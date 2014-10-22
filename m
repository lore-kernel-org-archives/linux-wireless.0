Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49411 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaJVHjy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 03:39:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: sanity check CW_min/CW_max towards driver
Date: Wed, 22 Oct 2014 09:39:50 +0200
Message-Id: <1413963590-22300-1-git-send-email-johannes@sipsolutions.net> (sfid-20141022_093958_996605_D9FA84C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to ever set invalid CW_min/CW_max to the
drivers, we should catch it in higher layers. However, the
consequences of setting it wrong can be quite severe, so
double-check at a low level and error out for invalid data.

Change-Id: Ibf01670252676f2b6238308e0e2ef74475fbc1b0
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/45309
Tested-by: IWL Jenkins
---
 net/mac80211/driver-ops.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1bbb0790264f..3df28e0fa045 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -631,6 +631,12 @@ static inline int drv_conf_tx(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
+	if (WARN_ONCE(params->cw_min == 0 ||
+		      params->cw_min > params->cw_max,
+		      "%s: invalid CW_min/CW_max: %d/%d\n",
+		      sdata->name, params->cw_min, params->cw_max))
+		return -EINVAL;
+
 	trace_drv_conf_tx(local, sdata, ac, params);
 	if (local->ops->conf_tx)
 		ret = local->ops->conf_tx(&local->hw, &sdata->vif,
-- 
2.1.0

