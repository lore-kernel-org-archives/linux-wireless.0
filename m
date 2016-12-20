Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25483 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcLTUkH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 15:40:07 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        vamsi krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] cfg80211: Random local address for Public Action frame exchange
Date: Tue, 20 Dec 2016 22:39:39 +0200
Message-ID: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20161220_214025_146580_43F8C0D2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: vamsi krishna <vamsin@qti.qualcomm.com>

Add support to use random local address (Address 2 = SA in transmit and
the same address in receive functionality) for Public Action frames in
order to improve privacy of WLAN clients. Applications fill the random
source address in the frame buffer along with setting the
NL80211_ATTR_RANDOM_SA flag when using the NL80211_CMD_FRAME command.
This can be used only with the drivers that indicate support for random
local address by setting the new NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA
and/or NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED in ext_features.

The driver needs to configure receive behavior to accept frames to the
specified random address during the time the frame exchange is pending
and such frames need to be acknowledged similarly to frames sent to the
local permanent address when this random address functionality is not
used.

Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h | 16 ++++++++++++++++
 net/wireless/mlme.c          |  5 ++++-
 net/wireless/nl80211.c       | 14 ++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ca2ac1c..c442e4c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2303,6 +2303,11 @@ struct cfg80211_update_ft_ies_params {
  * @dont_wait_for_ack: tells the low level not to wait for an ack
  * @n_csa_offsets: length of csa_offsets array
  * @csa_offsets: array of all the csa offsets in the frame
+ * @random_sa: indicates whether the source address is randomized. When this is
+ *	true, the driver needs to transmit the management frame using the
+ *	address specified in the SA field (Address 2) in the buffer and the
+ *	driver needs to receive and acknowledge the response frame to this
+ *	address instead of its permanent MAC address.
  */
 struct cfg80211_mgmt_tx_params {
 	struct ieee80211_channel *chan;
@@ -2314,6 +2319,7 @@ struct cfg80211_mgmt_tx_params {
 	bool dont_wait_for_ack;
 	int n_csa_offsets;
 	const u16 *csa_offsets;
+	bool random_sa;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d74e10b..cffc117 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -567,6 +567,9 @@
  *	%NL80211_ATTR_CSA_C_OFFSETS_TX is an array of offsets to CSA
  *	counters which will be updated to the current value. This attribute
  *	is used during CSA period.
+ *	When sending a Public Action frame, %NL80211_ATTR_MGMT_TX_RANDOM_SA can
+ *	be used to indicate that random local address (SA) is used for the
+ *	exchange.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
  *	time if it is known that it is no longer necessary.
@@ -1915,6 +1918,11 @@ enum nl80211_commands {
  *	%NL80211_ATTR_IFTYPE, %NL80211_ATTR_EXT_CAPA,
  *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended capabilities per
  *	interface type.
+ * @NL80211_ATTR_MGMT_TX_RANDOM_SA: A flag attribute indicating whether the
+ *	source address is randomized in frames sent using %NL80211_CMD_FRAME.
+ *	If this flag is not set, the source address field is verified to match
+ *	local MAC address. Random SA can be used only with Public Action frames
+ *	(e.g., GAS/ANQP).
  *
  * @NL80211_ATTR_MU_MIMO_GROUP_DATA: array of 24 bytes that defines a MU-MIMO
  *	groupID for monitor mode.
@@ -2386,6 +2394,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSSID,
 
+	NL80211_ATTR_MGMT_TX_RANDOM_SA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4697,6 +4707,10 @@ enum nl80211_feature_flags {
  *	configuration (AP/mesh) with VHT rates.
  * @NL80211_EXT_FEATURE_FILS_STA: This driver supports Fast Initial Link Setup
  *	with user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
+ * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA: This driver supports randomized SA
+ *	in @NL80211_CMD_FRAME while not associated.
+ * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED: This driver supports
+ *	randomized SA in @NL80211_CMD_FRAME while associated.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4712,6 +4726,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_BEACON_RATE_HT,
 	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
 	NL80211_EXT_FEATURE_FILS_STA,
+	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA,
+	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4646cf5..9568a72 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -657,7 +657,10 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev)))
+	if (!(params->random_sa &&
+	      (ieee80211_is_action(mgmt->frame_control) &&
+	       mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)) &&
+	    !ether_addr_equal(mgmt->sa, wdev_address(wdev)))
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2369265..efced76 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -405,6 +405,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_MGMT_TX_RANDOM_SA] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -9209,6 +9210,19 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	params.random_sa = nla_get_flag(
+		info->attrs[NL80211_ATTR_MGMT_TX_RANDOM_SA]);
+	if (params.random_sa &&
+	    ((!wdev->current_bss &&
+	      !wiphy_ext_feature_isset(
+		      &rdev->wiphy,
+		      NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA)) ||
+	     (wdev->current_bss &&
+	      !wiphy_ext_feature_isset(
+		      &rdev->wiphy,
+		      NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED))))
+		return -EINVAL;
+
 	if (!params.dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 		if (!msg)
-- 
1.9.1
