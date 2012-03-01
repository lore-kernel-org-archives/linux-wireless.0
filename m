Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56887 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab2CAMwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 07:52:13 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Add an attribute to set inactivity timeout in AP mode
Date: Thu, 1 Mar 2012 18:22:19 +0530
Message-ID: <1330606339-9055-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120301_135217_410928_22FE1691)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an attribute, NL80211_ATTR_INACTIVITY_TIMEOUT,
to set the inactivity timeout which can be used to remove the
station in AP mode. This can be passed in NL80211_CMD_START_AP
and used by the drivers which have AP MLME in firmware but
don't support get_station() properly.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 include/linux/nl80211.h |   11 +++++++++--
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    5 +++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be35a68..9fe9595 100644
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
@@ -1197,6 +1197,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
+ *	used by the drivers which has MLME in firmware and does not have support
+ *	to report per station tx/rx activity to free up the staion entry from
+ *	the list.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1442,6 +1447,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_INACTIVITY_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
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
index 1998c36..9d0f391 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -2214,6 +2215,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT])
+		params.inactivity_timeout = nla_get_u16(
+			info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]);
+
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
 	if (!err)
 		wdev->beacon_interval = params.beacon_interval;
-- 
1.7.0.4

