Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13904 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab2CBKT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 05:19:56 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH V2] cfg80211: Add an attribute to set inactivity timeout in AP mode
Date: Fri, 2 Mar 2012 15:50:02 +0530
Message-ID: <1330683602-8208-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120302_112000_090990_3A08B9C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an attribute, NL80211_ATTR_INACTIVITY_TIMEOUT,
to set the inactivity timeout which can be used to remove the
station in AP mode. This can be passed in NL80211_CMD_START_AP
and used by the drivers which have AP MLME in firmware but
don't support get_station() properly. To disable inactivity
timer in userspace, wpa_s for example, there is a new flag,
NL80211_FEATURE_INACTIVITY_TIMER, in nl80211_feature_flags
through which drivers can register their capability to use
the inactivity timeout to free the stations.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---

V2 - Define a new flag for this capability in enum nl80211_feature_flags.
   - Change the attribute doc.

 include/linux/nl80211.h |   15 +++++++++++++--
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    8 ++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be35a68..4193e6e 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -168,8 +168,8 @@
  *	%NL80211_ATTR_DTIM_PERIOD, %NL80211_ATTR_SSID,
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
- *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY and
- *	%NL80211_ATTR_AUTH_TYPE.
+ *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
+ *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
  * @NL80211_CMD_STOP_AP: Stop AP operation on the given interface
  * @NL80211_CMD_DEL_BEACON: old alias for %NL80211_CMD_STOP_AP
@@ -1197,6 +1197,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
+ *	used by the drivers which has MLME in firmware and does not have support
+ *	to report per station tx/rx activity to free up the staion entry from
+ *	the list. This needs to be used when the driver advertises the
+ *	capability to timeout the stations.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1442,6 +1448,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_INACTIVITY_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2804,10 +2812,13 @@ enum nl80211_ap_sme_features {
  *	TX status to the socket error queue when requested with the
  *	socket option.
  * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
+ * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
+ *	the connected inactive stations in AP mode.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
+	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0178c74..9cd5ef6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -413,6 +413,7 @@ struct cfg80211_beacon_data {
  * @crypto: crypto settings
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
+ * @inactivity_timeout: time in seconds to determine station's inactivity.
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_beacon_data beacon;
@@ -424,6 +425,7 @@ struct cfg80211_ap_settings {
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
 	enum nl80211_auth_type auth_type;
+	int inactivity_timeout;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1998c36..66e8a5b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -2214,6 +2215,13 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]) {
+		if (!(rdev->wiphy.features & NL80211_FEATURE_INACTIVITY_TIMER))
+			return -EOPNOTSUPP;
+		params.inactivity_timeout = nla_get_u16(
+			info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]);
+	}
+
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
 	if (!err)
 		wdev->beacon_interval = params.beacon_interval;
-- 
1.7.0.4

