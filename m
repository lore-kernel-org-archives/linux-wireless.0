Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42429 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2CGL5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 06:57:21 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH v3] cfg80211: Add background scan period attribute.
Date: Wed, 7 Mar 2012 17:27:12 +0530
Message-ID: <1331121432-8721-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120307_125724_686523_CBAC1D07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Receive background scan period as part of connect
command and pass the same to the driver.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 include/linux/nl80211.h |   10 ++++++++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |    8 ++++++++
 net/wireless/wext-sme.c |    3 +++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index c37d67a..e474f6e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -369,6 +369,11 @@
  *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
  *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	Background scan period can optionally be
+ *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
+ *	if not specified default background scan configuration
+ *	in driver is used and if period value is 0, bg scan will be disabled.
+ *	This attribute is ignored if driver does not support roam scan.
  *	It is also sent as an event, with the BSSID and response IEs when the
  *	connection is established or failed to be established. This can be
  *	determined by the STATUS_CODE attribute.
@@ -1207,6 +1212,9 @@ enum nl80211_commands {
  *	this attribute is (depending on the driver capabilities) added to
  *	received frames indicated with %NL80211_CMD_FRAME.
  *
+ * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
+ *      or 0 to disable background scan.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1456,6 +1464,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RX_SIGNAL_DBM,
 
+	NL80211_ATTR_BG_SCAN_PERIOD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 57c9fdd..66f4603 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1203,6 +1203,8 @@ struct cfg80211_ibss_params {
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
  * @flags:  See &enum cfg80211_assoc_req_flags
+ * @bg_scan_period:  Background scan period in seconds
+ *   or -1 to indicate that default value is to be used.
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
@@ -1220,6 +1222,7 @@ struct cfg80211_connect_params {
 	const u8 *key;
 	u8 key_len, key_idx;
 	u32 flags;
+	int bg_scan_period;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 39dbdf2..4c1eb94 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -205,6 +205,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -5116,6 +5117,13 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	wiphy = &rdev->wiphy;
 
+	connect.bg_scan_period = -1;
+	if (info->attrs[NL80211_ATTR_BG_SCAN_PERIOD] &&
+		(wiphy->flags & WIPHY_FLAG_SUPPORTS_FW_ROAM)) {
+		connect.bg_scan_period =
+			nla_get_u16(info->attrs[NL80211_ATTR_BG_SCAN_PERIOD]);
+	}
+
 	if (info->attrs[NL80211_ATTR_MAC])
 		connect.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 	connect.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
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

