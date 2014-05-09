Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44354 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756498AbaEILMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:44 +0300
Message-Id: <1399633911-12788-2-git-send-email-luca@coelho.fi> (sfid-20140509_131230_144574_F502A631)
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 1/8] cfg80211: Add API to update CSA counters in mgmt frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add NL80211_ATTR_CSA_C_OFFSETS_TX which holds an array
of offsets to the CSA counters which should be updated
when sending a management frames with NL80211_CMD_FRAME.

This API should be used by the drivers that wish to keep the
CSA counter updated in probe responses, but do not implement
probe response offloading and so, do not use
ieee80211_proberesp_get function.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  8 ++++++++
 net/wireless/nl80211.c       | 24 ++++++++++++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c7169b..ca1faf5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1986,6 +1986,8 @@ struct cfg80211_update_ft_ies_params {
  * @len: buffer length
  * @no_cck: don't use cck rates for this frame
  * @dont_wait_for_ack: tells the low level not to wait for an ack
+ * @n_csa_offsets: length of csa_offsets array
+ * @csa_offsets: array of all the csa offsets in the frame
  */
 struct cfg80211_mgmt_tx_params {
 	struct ieee80211_channel *chan;
@@ -1995,6 +1997,8 @@ struct cfg80211_mgmt_tx_params {
 	size_t len;
 	bool no_cck;
 	bool dont_wait_for_ack;
+	int n_csa_offsets;
+	const u16 *csa_offsets;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 406010d..aaa752f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -503,6 +503,9 @@
  *	TX status event pertaining to the TX request.
  *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
  *	management frames at CCK rate or not in 2GHz band.
+ *	%NL80211_ATTR_CSA_C_OFFSETS_TX is an array of offsets to CSA
+ *	counters which will be updated to the current value. This attribute
+ *	is used during CSA period.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
  *	time if it is known that it is no longer necessary.
@@ -1576,6 +1579,9 @@ enum nl80211_commands {
  *	advertise values that cannot always be met. In such cases, an attempt
  *	to add a new station entry with @NL80211_CMD_NEW_STATION may fail.
  *
+ * @NL80211_ATTR_CSA_C_OFFSETS_TX: An array of csa counter offsets (u16) which
+ *	should be updated when the frame is transmitted.
+ *
  * @NL80211_ATTR_TDLS_PEER_CAPABILITY: flags for TDLS peer capabilities, u32.
  *	As specified in the &enum nl80211_tdls_peer_capability.
  *
@@ -1920,6 +1926,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_IFACE_SOCKET_OWNER,
 
+	NL80211_ATTR_CSA_C_OFFSETS_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f1b18f2..f425a04 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -386,6 +386,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CSA_C_OFFSETS_TX] = { .type = NLA_BINARY },
 };
 
 /* policy for the key attributes */
@@ -7784,6 +7785,27 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (!chandef.chan && params.offchan)
 		return -EINVAL;
 
+	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
+	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+
+	if (info->attrs[NL80211_ATTR_CSA_C_OFFSETS_TX]) {
+		int len = nla_len(info->attrs[NL80211_ATTR_CSA_C_OFFSETS_TX]);
+		int i;
+
+		if (len % sizeof(u16))
+			return -EINVAL;
+
+		params.n_csa_offsets = len / sizeof(u16);
+		params.csa_offsets =
+			nla_data(info->attrs[NL80211_ATTR_CSA_C_OFFSETS_TX]);
+
+		/* check that all the offsets fit the frame */
+		for (i = 0; i < params.n_csa_offsets; i++) {
+			if (params.csa_offsets[i] >= params.len)
+				return -EINVAL;
+		}
+	}
+
 	if (!params.dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 		if (!msg)
@@ -7797,8 +7819,6 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	params.buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
-	params.len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
 	params.chan = chandef.chan;
 	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
 	if (err)
-- 
2.0.0.rc0

