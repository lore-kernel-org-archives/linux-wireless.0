Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39941 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463Ab1EENAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 09:00:48 -0400
Received: by eyg7 with SMTP id 7so861699eyg.13
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 06:00:40 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 3/3] cfg80211/nl80211: add interval attribute for scheduled scans
Date: Thu,  5 May 2011 16:00:19 +0300
Message-Id: <1304600420-24227-4-git-send-email-coelho@ti.com> (sfid-20110505_150052_084689_802544EE)
In-Reply-To: <1304600420-24227-1-git-send-email-coelho@ti.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce NL80211_ATTR_SCHED_SCAN_INTERVAL as a required attribute for
NL80211_CMD_START_SCHED_SCAN.  This value informs the driver at which
intervals the scheduled scan cycles should be executed.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |   24 +++++++++++++++---------
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |   10 ++++++++++
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 355fb65..2ab1b92 100644
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
@@ -927,6 +929,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
  *	allows auth frames in a mesh to be passed to userspace for processing via
  *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
+ * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
+ *	cycles, in msecs.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1117,6 +1121,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORT_MESH_AUTH,
 
+	NL80211_ATTR_SCHED_SCAN_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 117df56..d0460ee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -798,6 +798,7 @@ struct cfg80211_scan_request {
  * @ssids: SSIDs to report (other SSIDs will be filtered out)
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
index a971501..5e1bb00 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -173,6 +173,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -3331,6 +3332,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct nlattr *attr;
 	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_channels, i;
+	u32 interval;
 	enum ieee80211_band band;
 	size_t ie_len;
 
@@ -3344,6 +3346,13 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
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
@@ -3466,6 +3475,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
+	request->interval = interval;
 
 	rdev->sched_scan_req = request;
 
-- 
1.7.1

