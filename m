Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50162 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2CAGje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:39:34 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH v2] cfg80211: Add background scan period attribute.
Date: Thu, 1 Mar 2012 12:09:25 +0530
Message-ID: <1330583965-8415-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120301_073937_156683_BFB54260)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Receive background scan period as part of connect
command and pass the same to driver.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 include/linux/nl80211.h |    9 +++++++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |    7 +++++++
 net/wireless/wext-sme.c |    3 +++
 4 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be35a68..e81d327 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -369,6 +369,10 @@
  *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
  *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	Background scan period can optionally be
+ *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
+ *	if not specified default background scan configuration
+ *	in driver is used and if period value is 0, bg scan will be disabled.
  *	It is also sent as an event, with the BSSID and response IEs when the
  *	connection is established or failed to be established. This can be
  *	determined by the STATUS_CODE attribute.
@@ -1197,6 +1201,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
+ *      or 0 to disable background scan.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1442,6 +1449,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_BG_SCAN_PERIOD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0178c74..8b3b3b8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1200,6 +1200,8 @@ struct cfg80211_ibss_params {
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
  * @flags:  See &enum cfg80211_assoc_req_flags
+ * @bg_scan_period:  Background scan period in seconds
+ *   or -1 to indicate that default value is to be used.
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
@@ -1217,6 +1219,7 @@ struct cfg80211_connect_params {
 	const u8 *key;
 	u8 key_len, key_idx;
 	u32 flags;
+	int bg_scan_period;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1998c36..a3a6013 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -5090,6 +5091,12 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	} else
 		connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 
+	connect.bg_scan_period = -1;
+	if (info->attrs[NL80211_ATTR_BG_SCAN_PERIOD]) {
+		connect.bg_scan_period =
+			nla_get_u16(info->attrs[NL80211_ATTR_BG_SCAN_PERIOD]);
+	}
+
 	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
 
 	err = nl80211_crypto_settings(rdev, info, &connect.crypto,
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 326750b..7c01c2f 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -30,6 +30,9 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 	wdev->wext.connect.ie = wdev->wext.ie;
 	wdev->wext.connect.ie_len = wdev->wext.ie_len;
 
+	/* Use default background scan period */
+	wdev->wext.connect.bg_scan_period = -1;
+
 	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
 		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
-- 
1.7.4.1

