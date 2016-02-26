Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42803 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbcBZOG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 09:06:28 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] cfg80211: Allow a scan request for a specific BSSID
Date: Fri, 26 Feb 2016 16:06:04 +0200
Message-ID: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20160226_150634_733221_D3570244)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows scans for a specific BSSID to be optimized by the user space
application by requesting the driver to set the Probe Request frame
BSSID field (Address 3) to the specified BSSID instead of the wildcard
BSSID. This prevents other APs from replying which reduces airtime need
and latency in getting the response from the target AP through.

This is an optimization and as such, it is acceptable for some of the
drivers not to support the mechanism. If not supported, the wildcard
BSSID will be used and more responses may be received.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 4 +++-
 net/wireless/nl80211.c       | 6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9e1b24c..14c0c43 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1455,6 +1455,7 @@ struct cfg80211_ssid {
  * @mac_addr_mask: MAC address mask used with randomisation, bits that
  *	are 0 in the mask should be randomised, bits that are 1 should
  *	be taken from the @mac_addr
+ * @bssid: BSSID to scan for (most commonly, the wildcard BSSID)
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1471,6 +1472,7 @@ struct cfg80211_scan_request {
 
 	u8 mac_addr[ETH_ALEN] __aligned(2);
 	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
+	u8 bssid[ETH_ALEN] __aligned(2);
 
 	/* internal */
 	struct wiphy *wiphy;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5a30a75..23bf066 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -322,7 +322,9 @@
  * @NL80211_CMD_GET_SCAN: get scan results
  * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
  *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
- *	probe requests at CCK rate or not.
+ *	probe requests at CCK rate or not. %NL80211_ATTR_MAC can be used to
+ *	specify a BSSID to scan for; if not included, the wildcard BSSID will
+ *	be used.
  * @NL80211_CMD_NEW_SCAN_RESULTS: scan notification (as a reply to
  *	NL80211_CMD_GET_SCAN and on the "scan" multicast group)
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 98c9242..1b43f78 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5996,6 +5996,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
+	if (info->attrs[NL80211_ATTR_MAC])
+		memcpy(request->bssid, nla_data(info->attrs[NL80211_ATTR_MAC]),
+		       ETH_ALEN);
+	else
+		eth_broadcast_addr(request->bssid);
+
 	request->wdev = wdev;
 	request->wiphy = &rdev->wiphy;
 	request->scan_start = jiffies;
-- 
1.9.1

