Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:38284 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753268AbcKQLkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:40:01 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/5] nl80211: allow reporting RTT information in scan results
Date: Thu, 17 Nov 2016 11:39:48 +0000
Message-Id: <1479382792-13131-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_124012_605382_AF2643E0)
In-Reply-To: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add distance and its variance to the BSS structure so drivers
may provide RTT information for BSS instances found during
scanning.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       | 11 +++++++++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       |  8 ++++++++
 net/wireless/scan.c          |  2 ++
 4 files changed, 27 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2019310..d1217da 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1675,6 +1675,9 @@ enum cfg80211_signal_type {
  * @scan_width: scan width that was used
  * @signal: signal strength value, according to the wiphy's
  *	signal type
+ * @distance: distance to AP with %parent_bssid in centimeters. Zero
+ *	value indicates this is undetermined.
+ * @var_distance: variance of %distance indicating accurracy.
  * @boottime_ns: timestamp (CLOCK_BOOTTIME) when the information was
  *	received; should match the time when the frame was actually
  *	received by the device (not just by the host, in case it was
@@ -1691,6 +1694,8 @@ struct cfg80211_inform_bss {
 	struct ieee80211_channel *chan;
 	enum nl80211_bss_scan_width scan_width;
 	s32 signal;
+	u32 distance;
+	u32 var_distance;
 	u64 boottime_ns;
 	u64 parent_tsf;
 	u8 parent_bssid[ETH_ALEN] __aligned(2);
@@ -1737,6 +1742,9 @@ struct cfg80211_bss_ies {
  *	that holds the beacon data. @beacon_ies is still valid, of course, and
  *	points to the same data as hidden_beacon_bss->beacon_ies in that case.
  * @signal: signal strength value (type depends on the wiphy's signal_type)
+ * @distance: distance to AP with %parent_bssid in centimeters. Zero
+ *	value indicates this is undetermined.
+ * @var_distance: variance of %distance indicating accurracy.
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
@@ -1756,6 +1764,9 @@ struct cfg80211_bss {
 
 	u8 bssid[ETH_ALEN];
 
+	u32 distance;
+	u32 var_distance;
+
 	u8 priv[0] __aligned(sizeof(void *));
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 259c9c7..7e935f6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3651,6 +3651,10 @@ enum nl80211_bss_scan_width {
  *	@NL80211_BSS_PARENT_BSSID. (u64).
  * @NL80211_BSS_PARENT_BSSID: the BSS according to which @NL80211_BSS_PARENT_TSF
  *	is set.
+ * @NL80211_BSS_DISTANCE: distance to AP with @NL80211_BSS_PARENT_BSSID in
+ *	centimeters (u32).
+ * @NL80211_BSS_VARIANCE_DISTANCE: variance of @NL80211_BSS_DISTANCE value (u32).
+ *
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3674,6 +3678,8 @@ enum nl80211_bss {
 	NL80211_BSS_PAD,
 	NL80211_BSS_PARENT_TSF,
 	NL80211_BSS_PARENT_BSSID,
+	NL80211_BSS_DISTANCE,
+	NL80211_BSS_VARIANCE_DISTANCE,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24ab199..ffce566 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7515,6 +7515,14 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			      intbss->ts_boottime, NL80211_BSS_PAD))
 		goto nla_put_failure;
 
+	if (res->distance && nla_put_u32(msg, NL80211_BSS_DISTANCE,
+					 res->distance))
+		goto nla_put_failure;
+
+	if (res->var_distance && nla_put_u32(msg, NL80211_BSS_VARIANCE_DISTANCE,
+					     res->var_distance))
+		goto nla_put_failure;
+
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
 		if (nla_put_u32(msg, NL80211_BSS_SIGNAL_MBM, res->signal))
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b5bd58d..afda1f9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -973,6 +973,8 @@ struct cfg80211_bss *
 	tmp.pub.signal = data->signal;
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
+	tmp.pub.distance = data->distance;
+	tmp.pub.var_distance = data->var_distance;
 	tmp.ts_boottime = data->boottime_ns;
 
 	/*
-- 
1.9.1
