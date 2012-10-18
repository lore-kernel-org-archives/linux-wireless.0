Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38879 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2JRGgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 02:36:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 1/6] {nl,cfg}80211: add a flags word to scan requests
Date: Wed, 17 Oct 2012 23:34:26 -0700
Message-Id: <1350542071-26498-2-git-send-email-bzhao@marvell.com> (sfid-20121018_083605_267000_078BA384)
In-Reply-To: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add a flags word to direct and scheduled scan requests; it will
be used for control of optional behaviours such as flushing the
bss cache prior to doing a scan.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |    4 ++++
 include/uapi/linux/nl80211.h |    4 ++++
 net/wireless/nl80211.c       |   12 ++++++++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 607b5c0..d95da8f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1002,6 +1002,7 @@ struct cfg80211_ssid {
  * @n_channels: total number of channels to scan
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
  * @wdev: the wireless device to scan for
@@ -1014,6 +1015,7 @@ struct cfg80211_scan_request {
 	u32 n_channels;
 	const u8 *ie;
 	size_t ie_len;
+	u32 flags;
 
 	u32 rates[IEEE80211_NUM_BANDS];
 
@@ -1046,6 +1048,7 @@ struct cfg80211_match_set {
  * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @match_sets: sets of parameters to be matched for a scan result
  * 	entry to be considered valid and to be passed to the host
  * 	(others are filtered out).
@@ -1063,6 +1066,7 @@ struct cfg80211_sched_scan_request {
 	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
+	u32 flags;
 	struct cfg80211_match_set *match_sets;
 	int n_match_sets;
 	s32 rssi_thold;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 71ab23b..751a292 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1279,6 +1279,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_VHT_CAPABILITY: VHT Capability information element (from
  *	association request when used with NL80211_CMD_NEW_STATION)
  *
+ * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1540,6 +1542,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_VHT_CAPABILITY,
 
+	NL80211_ATTR_SCAN_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ef170e9..dc08211 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -356,6 +356,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
+	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -4367,6 +4368,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(
+			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
@@ -4598,6 +4603,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(
+			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 	request->interval = interval;
@@ -7663,6 +7672,9 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	    nla_put(msg, NL80211_ATTR_IE, req->ie_len, req->ie))
 		goto nla_put_failure;
 
+	if (req->flags)
+		nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);
+
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
-- 
1.7.0.4

