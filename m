Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1713 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3KBFjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 01:39:12 -0400
From: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, jouni@qca.qualcomm.com
Cc: hbahini@qca.qualcomm.com, jjohnson@qca.qualcomm.com,
	schang@qca.qualcomm.com, xunl@qca.qualcomm.com,
	sameert@qca.qualcomm.com, c_arifh@qca.qualcomm.com,
	rajeshc@qca.qualcomm.com
Subject: [PATCHv2] cfg80211/nl80211: Add API to report frequency range(s) to be avoided
Date: Fri,  1 Nov 2013 22:38:48 -0700
Message-Id: <1383370728-10799-1-git-send-email-rajeshc@qca.qualcomm.com> (sfid-20131102_063930_176935_9D9DBE94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for WLAN driver to report frequency range(s) to be avoided
because of interference. If SoftAP/P2P-GO is operating on interfering
frequency then user space should stop and restart them avoiding
interfering frequency range(s). User space may decide to continue
operation on interfering frequency, but in such case, there might be
impact on performance.

Signed-off-by: Rajesh Chauhan <rajeshc@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 35 +++++++++++++++++++++
 include/uapi/linux/nl80211.h | 42 +++++++++++++++++++++++++
 net/wireless/nl80211.c       | 73 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 150 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 419202c..ffeaf79 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1933,6 +1933,28 @@ struct cfg80211_update_ft_ies_params {
 };
 
 /**
+ * struct cfg80211_avoid_frequency_range - frequency range(s) to avoid
+ *
+ * This structure provides frequency range(s) that should be avoided
+ *	because of interference.
+ *
+ * @interference_source: enum nl80211_freq_interference_source_type
+ *	is used to specify source of interference.
+ * @start_freq: start of frequency (KHz)
+ * @end_freq: end of frequency (KHz)
+ */
+struct cfg80211_avoid_frequency_range {
+	enum nl80211_freq_interference_source_type interference_source;
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
@@ -4349,6 +4371,19 @@ void cfg80211_ft_event(struct net_device *netdev,
 		       struct cfg80211_ft_event_params *ft_event);
 
 /**
+ * cfg80211_avoid_frequency_event - notify userspace about frequency range(s)
+ *	to avoid because of interference.
+ * @netdev: network device
+ * @freq_list: frequency range(s) information
+ * @gfp: allocation flags
+ *
+ * WLAN driver calls this function to notify userspace about frequency
+ * range(s) that should be avoided because of interference.
+ */
+void cfg80211_avoid_frequency_event(struct net_device *netdev,
+		   struct cfg80211_avoid_frequency_list *freq_list, gfp_t gfp);
+
+/**
  * cfg80211_get_p2p_attr - find and copy a P2P attribute from IE buffer
  * @ies: the input IE buffer
  * @len: the input length
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..cf24eeb 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -686,6 +686,13 @@
  *	other station that transmission must be blocked until the channel
  *	switch is complete.
  *
+ * @NL80211_CMD_AVOID_FREQUENCIES_EVENT: Send range(s) of interfering
+ *	frequencies that should be avoided, from the WLAN driver to the user
+ *	space. If SoftAP/P2P-GO is operating on interfering frequency then
+ *	user space should stop and resart them avoiding interfering frequency
+ *	range(s). User space may decide to continue operation on interfering
+ *	frequency, but in such case, there might be impact on performance.
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
@@ -2255,6 +2268,35 @@ enum nl80211_frequency_attr {
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
 
 /**
+ * enum nl80211_freq_interference_source_type - interference source type
+ * @NL80211_FREQUENCY_INTERFERENCE_SOURCE_CELLULAR: interference source
+ *	is cellular
+ */
+enum nl80211_freq_interference_source_type {
+	NL80211_FREQUENCY_INTERFERENCE_SOURCE_CELLULAR
+};
+
+/**
+ * enum nl80211_avoid_frequency_attr - avoid frequency attributes
+ * @__NL80211_FREQUENCY_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_AVOID_FREQUENCY_ATTR_INTERFERENCE_SOURCE_TYPE: interference source
+ * @NL80211_AVOID_FREQUENCY_ATTR_START_FREQ: Start of frequency (KHz) range
+ * @NL80211_AVOID_FREQUENCY_ATTR_END_FREQ: End of frequency (KHz) range
+ * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_avoid_frequency_attr {
+	__NL80211_AVOID_FREQUENCY_ATTR_INVALID,
+	NL80211_AVOID_FREQUENCY_ATTR_INTERFERENCE_SOURCE_TYPE,
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
index cbbef88..469116f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_AVOID_FREQUENCIES] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -11234,6 +11235,78 @@ void cfg80211_ft_event(struct net_device *netdev,
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
+		if (nla_put_u32(msg,
+		      NL80211_AVOID_FREQUENCY_ATTR_INTERFERENCE_SOURCE_TYPE,
+		      freq_list->freq_range[i]->interference_source) ||
+		    nla_put_u32(msg,
+		      NL80211_AVOID_FREQUENCY_ATTR_START_FREQ,
+		      freq_list->freq_range[i]->start_freq) ||
+		    nla_put_u32(msg,
+		      NL80211_AVOID_FREQUENCY_ATTR_END_FREQ,
+		      freq_list->freq_range[i]->end_freq))
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

