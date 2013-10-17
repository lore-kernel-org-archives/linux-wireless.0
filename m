Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63517 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3JQE6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 00:58:07 -0400
From: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, jouni@qca.qualcomm.com
Cc: rajeshc@qca.qualcomm.com
Subject: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency ranges(s)
Date: Wed, 16 Oct 2013 21:57:13 -0700
Message-Id: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com> (sfid-20131017_065812_396456_9DBD3C4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for WLAN driver to report unsafe frequency range(s). User
space should move SAP/P2P-GO out of those unsafe frequency range(s).
User space may decide to continue operation on unsafe frequency but in
such case there might be impact on performance because of interference.

Signed-off-by: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 30 +++++++++++++++++++
 include/uapi/linux/nl80211.h | 31 ++++++++++++++++++++
 net/wireless/nl80211.c       | 68 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 129 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 45f6bf5..25b54dc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1933,6 +1933,24 @@ struct cfg80211_update_ft_ies_params {
 };
 
 /**
+ * struct cfg80211_avoid_frequency_range - frequency range(s) to avoid
+ *
+ * This structure provides frequency range(s) that should be avoided
+ *
+ * @start_freq: start of frequency (KHz)
+ * @end_freq: end of frequency (KHz)
+ */
+struct cfg80211_avoid_frequency_range {
+	unsigned int start_freq;
+	unsigned int end_freq;
+};
+
+struct cfg80211_avoid_frequency_list {
+	unsigned int n_freq_ranges;
+	struct cfg80211_avoid_frequency_range *freq_range[0];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -4340,6 +4358,18 @@ void cfg80211_ft_event(struct net_device *netdev,
 		       struct cfg80211_ft_event_params *ft_event);
 
 /**
+ * cfg80211_avoid_frequency_event - notify userspace about frequency range(s)
+ * @netdev: network device
+ * @freq_list: frequency range(s) information
+ * @gfp: allocation flags
+ *
+ * WLAN driver calls this function to notify userspace about frequency
+ * range(s) that should be avoided.
+ */
+void cfg80211_avoid_frequency_event(struct net_device *netdev,
+		   struct cfg80211_avoid_frequency_list *freq_list, gfp_t gfp);
+
+/**
  * cfg80211_get_p2p_attr - find and copy a P2P attribute from IE buffer
  * @ies: the input IE buffer
  * @len: the input length
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..457fd67 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -686,6 +686,13 @@
  *	other station that transmission must be blocked until the channel
  *	switch is complete.
  *
+ * @NL80211_CMD_AVOID_FREQUENCIES_EVENT: Send range(s) of frequencies that
+ *	should be avoided, from the WLAN driver to the user space. WLAN driver
+ *	may send unsafe frequencies to avoid interference. User space should
+ *	move SAP/P2P-GO out of those unsafe frequency ranges. User space may
+ *	decide to continue operation on unsafe frequency but in such case,
+ *	performance might get impact.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -853,6 +860,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CHANNEL_SWITCH,
 
+	NL80211_CMD_AVOID_FREQUENCIES_EVENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1496,6 +1505,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
  *	As specified in the &enum nl80211_rxmgmt_flags.
  *
+ * @NL80211_ATTR_AVOID_FREQUENCIES: Avoid frequencies container information
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1806,6 +1817,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_AVOID_FREQUENCIES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2255,6 +2268,24 @@ enum nl80211_frequency_attr {
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
 
 /**
+ * enum nl80211_avoid_frequency_attr - avoid frequency attributes
+ * @__NL80211_FREQUENCY_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_AVOID_FREQUENCY_ATTR_START_FREQ: Start of frequency (KHz) range
+ * @NL80211_AVOID_FREQUENCY_ATTR_END_FREQ: End of frequency (KHz) range
+ * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_avoid_frequency_attr {
+	__NL80211_AVOID_FREQUENCY_ATTR_INVALID,
+	NL80211_AVOID_FREQUENCY_ATTR_START_FREQ,
+	NL80211_AVOID_FREQUENCY_ATTR_END_FREQ,
+
+	/* keep last */
+	__NL80211_AVOID_FREQUENCY_ATTR_AFTER_LAST,
+	NL80211_AVOID_FREQUENCY_ATTR_MAX =
+		__NL80211_AVOID_FREQUENCY_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_bitrate_attr - bitrate attributes
  * @__NL80211_BITRATE_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_BITRATE_ATTR_RATE: Bitrate in units of 100 kbps
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cbbef88..dc3443a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_AVOID_FREQUENCIES] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -11234,6 +11235,73 @@ void cfg80211_ft_event(struct net_device *netdev,
 }
 EXPORT_SYMBOL(cfg80211_ft_event);
 
+void cfg80211_avoid_frequency_event(struct net_device *netdev,
+		struct cfg80211_avoid_frequency_list *freq_list, gfp_t gfp)
+{
+	struct wiphy *wiphy;
+	struct cfg80211_registered_device *rdev;
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *nl_ranges, *nl_range;
+	int err = -EINVAL;
+	unsigned int i;
+
+	if (!netdev || !netdev->ieee80211_ptr ||
+		   !netdev->ieee80211_ptr->wiphy || !freq_list)
+		return;
+
+	wiphy = netdev->ieee80211_ptr->wiphy;
+	rdev = wiphy_to_dev(wiphy);
+
+	if (!rdev)
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_AVOID_FREQUENCIES_EVENT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+		goto nla_put_failure;
+
+	nl_ranges = nla_nest_start(msg, NL80211_ATTR_AVOID_FREQUENCIES);
+	if (!nl_ranges)
+		goto nla_put_failure;
+
+	for (i = 0; i < freq_list->n_freq_ranges; i++) {
+		nl_range = nla_nest_start(msg, i);
+		if (!nl_range)
+			goto nla_put_failure;
+
+		if (nla_put_u32(msg, NL80211_AVOID_FREQUENCY_ATTR_START_FREQ,
+				    freq_list->freq_range[i]->start_freq) ||
+		    nla_put_u32(msg, NL80211_AVOID_FREQUENCY_ATTR_END_FREQ,
+				    freq_list->freq_range[i]->end_freq))
+			goto nla_put_failure;
+		nla_nest_end(msg, nl_range);
+	}
+	nla_nest_end(msg, nl_ranges);
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0)
+		goto nla_put_failure;
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_avoid_frequency_event);
+
 void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev;
-- 
1.8.4

