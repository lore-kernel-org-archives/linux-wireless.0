Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19956 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932758AbcKWWIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 17:08:02 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vamsi Krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 1/2] nl80211: Use different attrs for BSSID and random MAC addr in scan req
Date: Thu, 24 Nov 2016 00:07:36 +0200
Message-ID: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20161123_230806_184950_D7CAB7A4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vamsi Krishna <vamsin@qti.qualcomm.com>

NL80211_ATTR_MAC was used to set both the specific BSSID to be scanned
and the random MAC address to be used when privacy is enabled. When both
the features are enabled, both the BSSID and the local MAC address were
getting same value causing Probe Request frames to go with unintended
DA. Hence, this has been fixed by using a different NL80211_ATTR_BSSID
attribute to set the specific BSSID (which was the more recent addition
in cfg80211) for a scan.

Backwards compatibility with old userspace software is maintained to
some extend by allowing NL80211_ATTR_MAC to be used to set the specific
BSSID when scanning without enabling random MAC address use.

Scanning with random source MAC address was introduced by commit
ad2b26abc157 ("cfg80211: allow drivers to support random MAC addresses
for scan") and the issue was introduced with the addition of the second
user for the same attribute in commit 818965d39177 ("cfg80211: Allow a
scan request for a specific BSSID").

Fixes: 818965d39177 ("cfg80211: Allow a scan request for a specific BSSID")
Signed-off-by: Vamsi Krishna <vamsin@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h |  8 +++++++-
 net/wireless/nl80211.c       | 16 +++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 259c9c7..984a35ac 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -323,7 +323,7 @@
  * @NL80211_CMD_GET_SCAN: get scan results
  * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
  *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
- *	probe requests at CCK rate or not. %NL80211_ATTR_MAC can be used to
+ *	probe requests at CCK rate or not. %NL80211_ATTR_BSSID can be used to
  *	specify a BSSID to scan for; if not included, the wildcard BSSID will
  *	be used.
  * @NL80211_CMD_NEW_SCAN_RESULTS: scan notification (as a reply to
@@ -1977,6 +1977,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED: Indicates whether or not multicast
  *	packets should be send out as unicast to all stations (flag attribute).
  *
+ * @NL80211_ATTR_BSSID: The BSSID of the AP (various uses). Note that
+ *	%NL80211_ATTR_MAC has also been used in various commands/events for
+ *	specifying the BSSID.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2381,6 +2385,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED,
 
+	NL80211_ATTR_BSSID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4f718e..8db5cb1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -404,6 +404,7 @@ enum nl80211_multicast_groups {
 				    .len = FILS_MAX_KEK_LEN },
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
+	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
 };
 
 /* policy for the key attributes */
@@ -6703,7 +6704,20 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
-	if (info->attrs[NL80211_ATTR_MAC])
+	/* Initial implementation used NL80211_ATTR_MAC to set the specific
+	 * BSSID to scan for. This was problematic because that same attribute
+	 * was already used for another purpose (local random MAC address). The
+	 * NL80211_ATTR_BSSID attribute was added to fix this. For backwards
+	 * compatibility with older userspace components, also use the
+	 * NL80211_ATTR_MAC value here if it can be determined to be used for
+	 * the specific BSSID use case instead of the random MAC address
+	 * (NL80211_ATTR_SCAN_FLAGS is used to enable random MAC address use).
+	 */
+	if (info->attrs[NL80211_ATTR_BSSID])
+		memcpy(request->bssid,
+		       nla_data(info->attrs[NL80211_ATTR_BSSID]), ETH_ALEN);
+	else if (!info->attrs[NL80211_ATTR_SCAN_FLAGS] &&
+		 info->attrs[NL80211_ATTR_MAC])
 		memcpy(request->bssid, nla_data(info->attrs[NL80211_ATTR_MAC]),
 		       ETH_ALEN);
 	else
-- 
1.9.1
