Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2BTOdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 09:33:55 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [RFC] cfg80211: Add background scan period attribute.
Date: Mon, 20 Feb 2012 20:03:47 +0530
Message-ID: <1329748427-1862-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120220_153359_900909_9BFDC783)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send background scan period as part of connect
command. Background scanning will be disabled
if the period value is zero.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 include/linux/nl80211.h |    9 ++++++++-
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    6 ++++++
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ad56e21..3519054 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -366,7 +366,9 @@
  *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_MAC,
  *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
- *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT. Background scan period can
+ *	also be optionally specified in %NL80211_ATTR_BG_SCAN_PERIOD,
+ *	zero period value is used to disable background scan.
  *	It is also sent as an event, with the BSSID and response IEs when the
  *	connection is established or failed to be established. This can be
  *	determined by the STATUS_CODE attribute.
@@ -1193,6 +1195,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_BG_SCAN_PERIOD: Specify background scan period,
+ *      zero value is used to disable background scan.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1438,6 +1443,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_BG_SCAN_PERIOD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c9ff3..10f4373 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1190,6 +1190,7 @@ struct cfg80211_ibss_params {
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
  * @flags:  See &enum cfg80211_assoc_req_flags
+ * @bg_period:  Background scan period in seconds
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
@@ -1207,6 +1208,7 @@ struct cfg80211_connect_params {
 	const u8 *key;
 	u8 key_len, key_idx;
 	u32 flags;
+	int bg_period;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fe27476..ba9cb26 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -5061,6 +5062,11 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	} else
 		connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 
+	connect.bg_period = -1;
+	if (info->attrs[NL80211_ATTR_BG_SCAN_PERIOD])
+		connect.bg_period =
+			nla_get_u16(info->attrs[NL80211_ATTR_BG_SCAN_PERIOD]);
+
 	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
 
 	err = nl80211_crypto_settings(rdev, info, &connect.crypto,
-- 
1.7.4.1

