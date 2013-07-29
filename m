Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61506 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab3G2Iji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 04:39:38 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/3] nl/cfg80211: add chan_time for scan request
Date: Mon, 29 Jul 2013 10:39:16 +0200
Message-ID: <1375087158-22077-2-git-send-email-michal.kazior@tieto.com> (sfid-20130729_103943_645360_300806D2)
In-Reply-To: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new scan parameter allows user to specify how
long driver should remain on each scanned channel.

The default is to leave it up to driver to decide.
If specified it is preferred for driver to respect
this setting although it may ignore it if it can't
support it.

This can be useful to do very quick/slow scans
and/or gether survey data, e.g. for automatic
channel selection.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |    7 +++++++
 net/wireless/nl80211.c       |    4 ++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aeaf6df..2d46112 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1323,6 +1323,8 @@ struct cfg80211_ssid {
  * @aborted: (internal) scan request was notified as aborted
  * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @chan_time: how many msec driver should stay on each channel during scan.
+ *	Setting 0 leaves the decision up to the driver.
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1332,6 +1334,7 @@ struct cfg80211_scan_request {
 	const u8 *ie;
 	size_t ie_len;
 	u32 flags;
+	int chan_time;
 
 	u32 rates[IEEE80211_NUM_BANDS];
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index eb68735..4ea1d9b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1469,6 +1469,11 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
  *
+ * @NL80211_ATTR_SCAN_CHAN_TIME: Specifies how many msec should a driver spend
+ *	on each channel during scanning. This is optional and the default is
+ *	leave the decision up to the driver. This setting may, but preferrably
+ *	shouldn't, be ignored by driver.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1771,6 +1776,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_COALESCE_RULE,
 
+	NL80211_ATTR_SCAN_CHAN_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 03d4ef9..27a8fef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5298,6 +5298,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
+	if (info->attrs[NL80211_ATTR_SCAN_CHAN_TIME])
+		request->chan_time =
+			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_CHAN_TIME]);
+
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
 	request->scan_start = jiffies;
-- 
1.7.9.5

