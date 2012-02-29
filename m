Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33295 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab2B2MfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 07:35:10 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH] cfg80211: Add background scan period attribute.
Date: Wed, 29 Feb 2012 18:04:56 +0530
Message-ID: <1330518896-15230-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120229_133516_521752_BEEDD972)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Receive background scan period as part of connect
command and pass the same to driver.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 include/linux/nl80211.h |    8 ++++++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    7 +++++++
 net/wireless/wext-sme.c |    5 +++++
 4 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ad56e21..7cef223 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -367,6 +367,9 @@
  *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
  *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	Background scan period can also be
+ *	optionally specified in %NL80211_ATTR_BG_SCAN_PERIOD.
+ *	If period value is 0, bg scan will be disabled.
  *	It is also sent as an event, with the BSSID and response IEs when the
  *	connection is established or failed to be established. This can be
  *	determined by the STATUS_CODE attribute.
@@ -1193,6 +1196,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_BG_SCAN_PERIOD: Specify background scan period,
+ *      if period is 0 bg scan will be disabled.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1438,6 +1444,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_BG_SCAN_PERIOD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2964205..3b78d5f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1189,6 +1189,7 @@ struct cfg80211_ibss_params {
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
  * @flags:  See &enum cfg80211_assoc_req_flags
+ * @bg_scan_period:  Background scan period in seconds
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
@@ -1206,6 +1207,7 @@ struct cfg80211_connect_params {
 	const u8 *key;
 	u8 key_len, key_idx;
 	u32 flags;
+	int bg_scan_period;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c910b07..5d05dec 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -5059,6 +5060,12 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
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
index 326750b..9dff494 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -29,6 +29,11 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 
 	wdev->wext.connect.ie = wdev->wext.ie;
 	wdev->wext.connect.ie_len = wdev->wext.ie_len;
+	/*
+	 * make bg_scan_period to be -1 so that it
+	 * will not be configured.
+	 */
+	wdev->wext.connect.bg_scan_period = -1;
 
 	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
-- 
1.7.4.1

