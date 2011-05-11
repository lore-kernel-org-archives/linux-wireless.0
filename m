Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37752 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128Ab1EKP4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 11:56:52 -0400
Received: by mail-ww0-f45.google.com with SMTP id 36so598014wwi.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 08:56:50 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	eliad@wizery.com
Subject: [PATCH v3 3/3] cfg80211/nl80211: add interval attribute for scheduled scans
Date: Wed, 11 May 2011 17:09:37 +0300
Message-Id: <1305122977-6740-4-git-send-email-coelho@ti.com> (sfid-20110511_175708_103334_A94EB141)
In-Reply-To: <1305122977-6740-1-git-send-email-coelho@ti.com>
References: <1305122977-6740-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce NL80211_ATTR_SCHED_SCAN_INTERVAL as a required attribute for
NL80211_CMD_START_SCHED_SCAN.  This value informs the driver at which
intervals the scheduled scan cycles should be executed.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |   25 ++++++++++++++++---------
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |   10 ++++++++++
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8f02fac..5912529 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -203,15 +203,17 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
- * @NL80211_CMD_START_SCHED_SCAN: start a scheduled scan.  Like with normal
- *	scans, if SSIDs (%NL80211_ATTR_SCAN_SSIDS) are passed, they are used
- *	in the probe requests.  For broadcast, a broadcast SSID must be
- *	passed (ie. an empty string).  If no SSID is passed, no probe
- *	requests are sent and a passive scan is performed.
- *	%NL80211_ATTR_SCAN_FREQUENCIES, if passed, define which channels
- *	should be scanned; if not passed, all channels allowed for the
- *	current regulatory domain are used.  Extra IEs can also be passed
- *	from the userspace by using the %NL80211_ATTR_IE attribute.
+ * @NL80211_CMD_START_SCHED_SCAN: start a scheduled scan at certain
+ *	intervals, as specified by %NL80211_ATTR_SCHED_SCAN_INTERVAL.
+ *	Like with normal scans, if SSIDs (%NL80211_ATTR_SCAN_SSIDS)
+ *	are passed, they are used in the probe requests.  For
+ *	broadcast, a broadcast SSID must be passed (ie. an empty
+ *	string).  If no SSID is passed, no probe requests are sent and
+ *	a passive scan is performed.  %NL80211_ATTR_SCAN_FREQUENCIES,
+ *	if passed, define which channels should be scanned; if not
+ *	passed, all channels allowed for the current regulatory domain
+ *	are used.  Extra IEs can also be passed from the userspace by
+ *	using the %NL80211_ATTR_IE attribute.
  * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan
  * @NL80211_CMD_SCHED_SCAN_RESULTS: indicates that there are scheduled scan
  *	results available.
@@ -945,6 +947,9 @@ enum nl80211_commands {
  *	indicate which WoW triggers should be enabled. This is also
  *	used by %NL80211_CMD_GET_WOWLAN to get the currently enabled WoWLAN
  *	triggers.
+
+ * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
+ *	cycles, in msecs.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1138,6 +1143,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_WOWLAN_TRIGGERS,
 	NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED,
 
+	NL80211_ATTR_SCHED_SCAN_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d9b92c4..b18327f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -798,6 +798,7 @@ struct cfg80211_scan_request {
  * @ssids: SSIDs to scan for (passed in the probe_reqs in active scans)
  * @n_ssids: number of SSIDs
  * @n_channels: total number of channels to scan
+ * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
  * @wiphy: the wiphy this was for
@@ -808,6 +809,7 @@ struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
 	u32 n_channels;
+	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0c32faf..b95436a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -174,6 +174,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3362,6 +3363,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct nlattr *attr;
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
+	u32 interval;
 	enum ieee80211_band band;
 	size_t ie_len;
 
@@ -3375,6 +3377,13 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (rdev->sched_scan_req)
 		return -EINPROGRESS;
 
+	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL])
+		return -EINVAL;
+
+	interval = nla_get_u32(info->attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL]);
+	if (interval == 0)
+		return -EINVAL;
+
 	wiphy = &rdev->wiphy;
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
@@ -3497,6 +3506,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
+	request->interval = interval;
 
 	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
 	if (!err) {
-- 
1.7.1

