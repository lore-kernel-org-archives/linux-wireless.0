Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:43891 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbaAFH6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 02:58:22 -0500
Date: Mon, 6 Jan 2014 09:51:26 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan
 requests
Message-ID: <20140106075126.GA31046@w1.fi> (sfid-20140106_085829_307081_44FED5B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds new nl80211 attributes to allow MinChannelTime and
MaxChannelTime to be specified for scan requests. The parameters can be
used to control the amount of time spent on each channel during a scan
as specified in the IEEE Std 802.11-2012 MLME-SCAN.request() primitive.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 include/net/cfg80211.h       |    7 +++++++
 include/uapi/linux/nl80211.h |   11 +++++++++++
 net/wireless/nl80211.c       |   14 ++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b5777a..3553c3a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1367,6 +1367,11 @@ struct cfg80211_ssid {
  * @aborted: (internal) scan request was notified as aborted
  * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @min_chan_time: MinChannelTime in TUs; time to spend waiting for
+ * PHY-CCA.indication (channel busy) in Active scan; 0 to indicate that driver
+ * default value to be used
+ * @max_chan_time: MaxChannelTime in TUs; time to spend waiting for Beacon or
+ * Probe Response frames; 0 to indicate that driver default value to be used
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1376,6 +1381,8 @@ struct cfg80211_scan_request {
 	const u8 *ie;
 	size_t ie_len;
 	u32 flags;
+	unsigned int min_chan_time;
+	unsigned int max_chan_time;
 
 	u32 rates[IEEE80211_NUM_BANDS];
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e57de33..86b8888 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1568,6 +1568,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_MAC_HINT: MAC address recommendation as initial BSS
  * @NL80211_ATTR_WIPHY_FREQ_HINT: frequency of the recommended initial BSS
  *
+ * @NL80211_ATTR_MIN_CHANNEL_TIME: MinChannelTime - Minimum time (in TU) to
+ *	spend on each channel when scanning (used for active scans). If not
+ *	included, the driver will use its default value. u32 attribute.
+ * @NL80211_ATTR_MAX_CHANNEL_TIME: MaxChannelTime - Maximum time (in TU) to
+ *	spend on each channel when scanning (used for both active and passive
+ *	scans). If not included, the driver will use its default value. u32
+ *	attribute.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1899,6 +1907,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAC_HINT,
 	NL80211_ATTR_WIPHY_FREQ_HINT,
 
+	NL80211_ATTR_MIN_CHANNEL_TIME,
+	NL80211_ATTR_MAX_CHANNEL_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a3a6fb7..caf2829 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -386,6 +386,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
 	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
+	[NL80211_ATTR_MIN_CHANNEL_TIME] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAX_CHANNEL_TIME] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -5443,6 +5445,18 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
+	if (info->attrs[NL80211_ATTR_MIN_CHANNEL_TIME])
+		request->min_chan_time = nla_get_u32(
+			info->attrs[NL80211_ATTR_MIN_CHANNEL_TIME]);
+	if (info->attrs[NL80211_ATTR_MAX_CHANNEL_TIME])
+		request->max_chan_time = nla_get_u32(
+			info->attrs[NL80211_ATTR_MAX_CHANNEL_TIME]);
+	if (request->max_chan_time &&
+	    request->max_chan_time < request->min_chan_time) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
 	request->scan_start = jiffies;
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
