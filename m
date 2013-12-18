Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3LRN4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 08:56:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: support vendor-specific events
Date: Wed, 18 Dec 2013 14:56:36 +0100
Message-Id: <1387374996-4968-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_145647_374788_568DBF14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In addition to vendor-specific commands, also support vendor-specific
events. These must be registered with cfg80211 before they can be used.
They're also advertised in nl80211 in the wiphy information so that
userspace knows can be expected. The events themselves are sent on a
new multicast group called "vendor".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 65 +++++++++++++++++++++++++++--
 include/uapi/linux/nl80211.h |  4 ++
 net/wireless/nl80211.c       | 98 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 144 insertions(+), 23 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8363512..9a9e3f1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2830,6 +2830,8 @@ struct wiphy_vendor_command {
  *
  * @vendor_commands: array of vendor commands supported by the hardware
  * @n_vendor_commands: number of vendor commands
+ * @vendor_events: array of vendor events supported by the hardware
+ * @n_vendor_events: number of vendor events
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2942,7 +2944,8 @@ struct wiphy {
 	const struct wiphy_coalesce_support *coalesce;
 
 	const struct wiphy_vendor_command *vendor_commands;
-	int n_vendor_commands;
+	const struct nl80211_vendor_cmd_info *vendor_events;
+	int n_vendor_commands, n_vendor_events;
 
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
@@ -3913,6 +3916,14 @@ struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 					   enum nl80211_attrs attr,
 					   int approxlen);
 
+struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
+					   enum nl80211_commands cmd,
+					   enum nl80211_attrs attr,
+					   int vendor_event_idx,
+					   int approxlen, gfp_t gfp);
+
+void __cfg80211_send_event_skb(struct sk_buff *skb, gfp_t gfp);
+
 /**
  * cfg80211_vendor_cmd_alloc_reply_skb - allocate vendor command reply
  * @wiphy: the wiphy
@@ -3957,6 +3968,44 @@ cfg80211_vendor_cmd_alloc_reply_skb(struct wiphy *wiphy, int approxlen)
  */
 int cfg80211_vendor_cmd_reply(struct sk_buff *skb);
 
+/**
+ * cfg80211_vendor_event_alloc - allocate vendor-specific event skb
+ * @wiphy: the wiphy
+ * @event_idx: index of the vendor event in the wiphy's vendor_events
+ * @approxlen: an upper bound of the length of the data that will
+ *	be put into the skb
+ * @gfp: allocation flags
+ *
+ * This function allocates and pre-fills an skb for an event on the
+ * vendor-specific multicast group.
+ *
+ * When done filling the skb, call cfg80211_vendor_event() with the
+ * skb to send the event.
+ *
+ * Return: An allocated and pre-filled skb. %NULL if any errors happen.
+ */
+static inline struct sk_buff *
+cfg80211_vendor_event_alloc(struct wiphy *wiphy, int approxlen,
+			    int event_idx, gfp_t gfp)
+{
+	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_VENDOR,
+					  NL80211_ATTR_VENDOR_DATA,
+					  event_idx, approxlen, gfp);
+}
+
+/**
+ * cfg80211_vendor_event - send the event
+ * @skb: The skb, must have been allocated with cfg80211_vendor_event_alloc()
+ * @gfp: allocation flags
+ *
+ * This function sends the given @skb, which must have been allocated
+ * by cfg80211_vendor_event_alloc(), as an event. It always consumes it.
+ */
+static inline void cfg80211_vendor_event(struct sk_buff *skb, gfp_t gfp)
+{
+	__cfg80211_send_event_skb(skb, gfp);
+}
+
 #ifdef CONFIG_NL80211_TESTMODE
 /**
  * DOC: Test mode
@@ -4037,8 +4086,13 @@ static inline int cfg80211_testmode_reply(struct sk_buff *skb)
  *
  * Return: An allocated and pre-filled skb. %NULL if any errors happen.
  */
-struct sk_buff *cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy,
-						  int approxlen, gfp_t gfp);
+static inline struct sk_buff *
+cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy, int approxlen, gfp_t gfp)
+{
+	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_TESTMODE,
+					  NL80211_ATTR_TESTDATA, -1,
+					  approxlen, gfp);
+}
 
 /**
  * cfg80211_testmode_event - send the event
@@ -4050,7 +4104,10 @@ struct sk_buff *cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy,
  * by cfg80211_testmode_alloc_event_skb(), as an event. It always
  * consumes it.
  */
-void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp);
+static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
+{
+	__cfg80211_send_event_skb(skb, gfp);
+}
 
 #define CFG80211_TESTMODE_CMD(cmd)	.testmode_cmd = (cmd),
 #define CFG80211_TESTMODE_DUMP(cmd)	.testmode_dump = (cmd),
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e561260..5d6d771 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1540,6 +1540,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_VENDOR_SUBCMD: vendor sub-command
  * @NL80211_ATTR_VENDOR_DATA: data for the vendor command, if any; this
  *	attribute is also used for vendor command feature advertisement
+ * @NL80211_ATTR_VENDOR_EVENTS: used for event list advertising in the wiphy
+ *	info, containing a nested array of possible events
  *
  * @NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST: Drop protocol unicast packets
  *	that were group protected at the wireless level. This flag attribute
@@ -1877,6 +1879,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST,
 	NL80211_ATTR_DROP_PROXY_SERVICE_ARP_NA,
 
+	NL80211_ATTR_VENDOR_EVENTS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 384a67c..449470c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -53,6 +53,7 @@ enum nl80211_multicast_groups {
 	NL80211_MCGRP_SCAN,
 	NL80211_MCGRP_REGULATORY,
 	NL80211_MCGRP_MLME,
+	NL80211_MCGRP_VENDOR,
 	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
 };
 
@@ -61,6 +62,7 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
 	[NL80211_MCGRP_SCAN] = { .name = "scan", },
 	[NL80211_MCGRP_REGULATORY] = { .name = "regulatory", },
 	[NL80211_MCGRP_MLME] = { .name = "mlme", },
+	[NL80211_MCGRP_VENDOR] = { .name = "vendor", },
 #ifdef CONFIG_NL80211_TESTMODE
 	[NL80211_MCGRP_TESTMODE] = { .name = "testmode", }
 #endif
@@ -1190,7 +1192,6 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_cmds;
-	struct nlattr *nl_vendor_cmds;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
 	int i;
@@ -1589,16 +1590,38 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		state->split_start++;
 		break;
 	case 11:
-		nl_vendor_cmds = nla_nest_start(msg, NL80211_ATTR_VENDOR_DATA);
-		if (!nl_vendor_cmds)
-			goto nla_put_failure;
+		if (dev->wiphy.n_vendor_commands) {
+			const struct nl80211_vendor_cmd_info *info;
+			struct nlattr *nested;
+
+			nested = nla_nest_start(msg, NL80211_ATTR_VENDOR_DATA);
+			if (!nested)
+				goto nla_put_failure;
+
+			for (i = 0; i < dev->wiphy.n_vendor_commands; i++) {
+				info = &dev->wiphy.vendor_commands[i].info;
+				if (nla_put(msg, i + 1, sizeof(*info), info))
+					goto nla_put_failure;
+			}
+			nla_nest_end(msg, nested);
+		}
+
+		if (dev->wiphy.n_vendor_events) {
+			const struct nl80211_vendor_cmd_info *info;
+			struct nlattr *nested;
 
-		for (i = 0; i < dev->wiphy.n_vendor_commands; i++)
-			if (nla_put(msg, i + 1,
-				    sizeof(struct nl80211_vendor_cmd_info),
-				    &dev->wiphy.vendor_commands[i].info))
+			nested = nla_nest_start(msg,
+						NL80211_ATTR_VENDOR_EVENTS);
+			if (!nested)
 				goto nla_put_failure;
-		nla_nest_end(msg, nl_vendor_cmds);
+
+			for (i = 0; i < dev->wiphy.n_vendor_events; i++) {
+				info = &dev->wiphy.vendor_events[i];
+				if (nla_put(msg, i + 1, sizeof(*info), info))
+					goto nla_put_failure;
+			}
+			nla_nest_end(msg, nested);
+		}
 
 		/* done */
 		state->split_start = 0;
@@ -6733,7 +6756,9 @@ static struct sk_buff *
 __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 			    int approxlen, u32 portid, u32 seq,
 			    enum nl80211_commands cmd,
-			    enum nl80211_attrs attr, gfp_t gfp)
+			    enum nl80211_attrs attr,
+			    const struct nl80211_vendor_cmd_info *info,
+			    gfp_t gfp)
 {
 	struct sk_buff *skb;
 	void *hdr;
@@ -6751,6 +6776,16 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 
 	if (nla_put_u32(skb, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
 		goto nla_put_failure;
+
+	if (info) {
+		if (nla_put_u32(skb, NL80211_ATTR_VENDOR_ID,
+				info->vendor_id))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, NL80211_ATTR_VENDOR_SUBCMD,
+				info->subcmd))
+			goto nla_put_failure;
+	}
+
 	data = nla_nest_start(skb, attr);
 
 	((void **)skb->cb)[0] = rdev;
@@ -6891,29 +6926,54 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 	return err;
 }
 
-struct sk_buff *cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy,
-						  int approxlen, gfp_t gfp)
+struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
+					   enum nl80211_commands cmd,
+					   enum nl80211_attrs attr,
+					   int vendor_event_idx,
+					   int approxlen, gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	const struct nl80211_vendor_cmd_info *info;
+
+	switch (cmd) {
+	case NL80211_CMD_TESTMODE:
+		if (WARN_ON(vendor_event_idx != -1))
+			return NULL;
+		info = NULL;
+		break;
+	case NL80211_CMD_VENDOR:
+		if (WARN_ON(vendor_event_idx < 0 ||
+			    vendor_event_idx >= wiphy->n_vendor_events))
+			return NULL;
+		info = &wiphy->vendor_events[vendor_event_idx];
+		break;
+	default:
+		WARN_ON(1);
+		return NULL;
+	}
 
 	return __cfg80211_alloc_vendor_skb(rdev, approxlen, 0, 0,
-					   NL80211_CMD_TESTMODE,
-					   NL80211_ATTR_TESTDATA, gfp);
+					   cmd, attr, info, gfp);
 }
-EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb);
+EXPORT_SYMBOL(__cfg80211_alloc_event_skb);
 
-void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
+void __cfg80211_send_event_skb(struct sk_buff *skb, gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
+	enum nl80211_multicast_groups mcgrp = NL80211_MCGRP_TESTMODE;
 
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
+
+	if (data->nla_type == NL80211_ATTR_VENDOR_DATA)
+		mcgrp = NL80211_MCGRP_VENDOR;
+
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), skb, 0,
-				NL80211_MCGRP_TESTMODE, gfp);
+				mcgrp, gfp);
 }
-EXPORT_SYMBOL(cfg80211_testmode_event);
+EXPORT_SYMBOL(__cfg80211_send_event_skb);
 #endif
 
 static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
@@ -9046,7 +9106,7 @@ struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 	return __cfg80211_alloc_vendor_skb(rdev, approxlen,
 					   rdev->cur_cmd_info->snd_portid,
 					   rdev->cur_cmd_info->snd_seq,
-					   cmd, attr, GFP_KERNEL);
+					   cmd, attr, NULL, GFP_KERNEL);
 }
 EXPORT_SYMBOL(__cfg80211_alloc_reply_skb);
 
-- 
1.8.5.1

