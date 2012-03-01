Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab2CAPVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 10:21:44 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Add an attribute to set inactivity timeout in AP mode
Date: Thu, 1 Mar 2012 20:51:34 +0530
Message-ID: <1330615294-13123-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120301_162148_053909_10231E83)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an attribute, NL80211_ATTR_INACTIVITY_TIMEOUT,
to set the inactivity timeout which can be used to remove the
station in AP mode. This can be passed in NL80211_CMD_START_AP
and used by the drivers which have AP MLME in firmware but
don't support get_station() properly. To disable inactivity
timer in userspace, wpa_s for example, there is a capability
flag, WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER, through which
drivers can register their capability to use the inactivity
timeout to free the stations.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 include/linux/nl80211.h |   17 +++++++++++++++--
 include/net/cfg80211.h  |    5 +++++
 net/wireless/nl80211.c  |   11 +++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be35a68..b03f860 100644
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
@@ -1197,6 +1197,15 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
  *
+ * @NL80211_ATTR_INACTIVITY_TIMER_SUPPORT: Indicates if the driver has the
+ *	capability to use %NL80211_ATTR_INACTIVITY_TIMEOUT for freeing up
+ *	connected stations.
+ * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
+ *	used by the drivers which has MLME in firmware and does not have support
+ *	to report per station tx/rx activity to free up the staion entry from
+ *	the list. This should not be sent from userspace when the driver does
+ *	not register it's capability to timeout the stations.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1442,6 +1451,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_INACTIVITY_TIMER_SUPPORT,
+
+	NL80211_ATTR_INACTIVITY_TIMEOUT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0178c74..1b3163c 100644
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
@@ -1760,6 +1762,8 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER: Device has support to remove inactive
+ *	connected stations in AP mode.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1783,6 +1787,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER	= BIT(22),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1998c36..eddd864 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_INACTIVITY_TIMER_SUPPORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -749,6 +751,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_FLAG(msg, NL80211_ATTR_TDLS_SUPPORT);
 	if (dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_INACTIVITY_TIMER_SUPPORT);
 
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
@@ -2214,6 +2218,13 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]) {
+		if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER))
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

