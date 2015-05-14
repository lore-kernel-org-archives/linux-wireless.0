Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56123 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742AbbENKtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 06:49:04 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/2] nl80211: Add support to configure low ack threshold
Date: Thu, 14 May 2015 16:17:35 +0530
Message-ID: <1431600456-10697-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150514_124919_127289_906D16E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new nl80211 attribute to configure low ack threshold (number of
consecutive frames) not being acked by station. This threshold is used
to kickout station by driver through low ack event. This allows user to
tune the parameter to improve robustness under noisy environment.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 11 ++++++++++-
 net/wireless/nl80211.c       |  7 +++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f8d6813..ae55d20 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -711,6 +711,8 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  *	MAC address based access control
+ * @low_ack_threshold: number of consecutive frames not being ACKed by
+ *	station, used to trigger low_ack event.
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -729,6 +731,7 @@ struct cfg80211_ap_settings {
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
+	u16 low_ack_threshold;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 241220c..0986a98 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -232,7 +232,8 @@
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
  *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT,
- *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS.
+ *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS
+ *	%NL80211_ATTR_LOW_ACK_THRESH.
  *	The channel to use can be set on the interface or be given using the
  *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
@@ -1761,6 +1762,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the device
  *      is operating in an indoor environment.
  *
+ * @NL80211_ATTR_LOW_ACK_THRESH: number of consecutive frames that are not ACKed
+ *	by station. This threshold is used to generate low ack event by driver.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2130,6 +2134,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_REG_INDOOR,
 
+	NL80211_ATTR_LOW_ACK_THRESH,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4585,4 +4591,7 @@ enum nl80211_tdls_peer_capability {
 	NL80211_TDLS_PEER_WMM = 1<<2,
 };
 
+/* Default low ack threshold for station kickout event */
+#define NL80211_DEFAULT_LOW_ACK_THRESH    50
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dd78445..7e7f96f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -400,6 +400,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_LOW_ACK_THRESH] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -3436,6 +3437,12 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.smps_mode = NL80211_SMPS_OFF;
 	}
 
+	if (info->attrs[NL80211_ATTR_LOW_ACK_THRESH])
+		params.low_ack_threshold = nla_get_u16(
+			info->attrs[NL80211_ATTR_LOW_ACK_THRESH]);
+	else
+		params.low_ack_threshold = NL80211_DEFAULT_LOW_ACK_THRESH;
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
2.4.0

