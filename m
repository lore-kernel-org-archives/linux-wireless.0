Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:44742 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2EXSzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 14:55:32 -0400
Received: by ghbf1 with SMTP id f1so81029ghb.37
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 11:55:30 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [PATCH 1/2] nl80211/cfg80211: add scan channel times to scan command
Date: Thu, 24 May 2012 21:52:48 +0300
Message-Id: <1337885569-32711-1-git-send-email-victorg@ti.com> (sfid-20120524_205536_821697_23ED55D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to give the usermode an ability to configure
scan channel times, and as it required for the beacon
reports in the 802.11k standard.

Add to the scan command min/max channel times. Add
min/max passive channel times, since a single scan
can contain both passive and active channels due to
regulatory constraints.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |   22 ++++++++++++++++++++++
 include/net/cfg80211.h  |   11 +++++++++++
 net/wireless/nl80211.c  |   25 +++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2540e86..8dca611 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1222,6 +1222,23 @@ enum nl80211_commands {
  * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
  *      or 0 to disable background scan.
  *
+ * @NL80211_ATTR_SCAN_MIN_CH_TIME: Minimum active scan time (in TUs),
+ *	u32 attribute to setup minimum time to wait on each channel, if received
+ *	at least one probe_resp/beacon during this period will continue waiting
+ *	@NL80211_ATTR_SCAN_MAX_CH_TIME, otherwise will move to next channel.
+ * @NL80211_ATTR_SCAN_MAX_CH_TIME: Maximum active scan time (in TUs),
+ *	u32 attribute to setup maximum time to wait on the channel.
+ * @NL80211_ATTR_SCAN_PSV_MIN_CH_TIME: Minimum passive scan time (in TUs),
+ *	u32 attribute (similar to @NL80211_ATTR_SCAN_MIN_CH_TIME).
+ * @NL80211_ATTR_SCAN_PSV_MAX_CH_TIME: Maximum passive scan time (in TUs),
+ *	u32 attribute (similar to @NL80211_ATTR_SCAN_MAX_CH_TIME).
+ *	Note:
+ *	 The above channel time attributes are for the %NL80211_CMD_TRIGGER_SCAN
+ *	 command. The attributes are optional, the driver will use default
+ *	 channel time values if the attribute is not set or set to zero.
+ *	 If one of the min times will be greater than max, -EINVAL will be
+ *	 returned. For the software scan only the min times are relevant.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1473,6 +1490,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BG_SCAN_PERIOD,
 
+	NL80211_ATTR_SCAN_MIN_CH_TIME,
+	NL80211_ATTR_SCAN_MAX_CH_TIME,
+	NL80211_ATTR_SCAN_PSV_MIN_CH_TIME,
+	NL80211_ATTR_SCAN_PSV_MAX_CH_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index adb2320..948cf60 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -920,6 +920,12 @@ struct cfg80211_ssid {
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @min_ch_time: minimum time to wait on each channel for active scans
+ * @max_ch_time: maximum time to wait on each channel for active scans
+ * @min_passive_ch_time: minimum time to wait on each channel for passive scans
+ * @max_passive_ch_time: maximum time to wait on each channel for passive scans
+ *  Note: If the above channel times are not set or set to zero, the default
+ *  channel times will be used.
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -936,6 +942,11 @@ struct cfg80211_scan_request {
 	bool aborted;
 	bool no_cck;
 
+	u32 min_ch_time;
+	u32 max_ch_time;
+	u32 min_passive_ch_time;
+	u32 max_passive_ch_time;
+
 	/* keep last */
 	struct ieee80211_channel *channels[0];
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 859bd66..4ac8fed 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -206,6 +206,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
+	[NL80211_ATTR_SCAN_MIN_CH_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_MAX_CH_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3884,6 +3888,27 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) {
+		request->min_ch_time =
+			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]);
+	}
+	if (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]) {
+		request->max_ch_time =
+			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]);
+		if (request->min_ch_time > request->max_ch_time)
+			return -EINVAL;
+	}
+	if (info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]) {
+		request->min_passive_ch_time =
+		    nla_get_u32(info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]);
+	}
+	if (info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]) {
+		request->max_passive_ch_time =
+		    nla_get_u32(info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]);
+		if (request->min_passive_ch_time > request->max_passive_ch_time)
+			return -EINVAL;
+	}
+
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 		if (wiphy->bands[i])
 			request->rates[i] =
-- 
1.7.5.4

