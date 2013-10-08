Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3JHIx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 04:53:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: vendor command support
Date: Tue,  8 Oct 2013 10:53:21 +0200
Message-Id: <1381222401-21999-1-git-send-email-johannes@sipsolutions.net> (sfid-20131008_105333_267072_1FB26C10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for vendor-specific commands to nl80211. This is
intended to be used for really vendor-specific functionality
that can't be implemented in a generic fashion for any reason.
It's *NOT* intended to be used for any normal/generic feature
or any optimisations that could be implemented across drivers.

Currently, only vendor commands (with replies) are supported,
no dump operations or vendor-specific notifications.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 108 +++++++++++++++++++-
 include/uapi/linux/nl80211.h |  41 ++++++++
 net/wireless/core.h          |   4 +-
 net/wireless/nl80211.c       | 235 ++++++++++++++++++++++++++++++-------------
 4 files changed, 314 insertions(+), 74 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 45f6bf5..9297ca0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2664,6 +2664,26 @@ struct wiphy_coalesce_support {
 };
 
 /**
+ * enum wiphy_vendor_command_flags - validation flags for vendor commands
+ * @WIPHY_VENDOR_CMD_NEED_WDEV: vendor command requires wdev
+ * @WIPHY_VENDOR_CMD_NEED_NETDEV: vendor command requires netdev
+ * @WIPHY_VENDOR_CMD_NEED_RUNNING: interface/wdev must be up & running
+ *	(must be combined with %_WDEV or %_NETDEV)
+ */
+enum wiphy_vendor_command_flags {
+	WIPHY_VENDOR_CMD_NEED_WDEV = BIT(0),
+	WIPHY_VENDOR_CMD_NEED_NETDEV = BIT(1),
+	WIPHY_VENDOR_CMD_NEED_RUNNING = BIT(2),
+};
+
+struct wiphy_vendor_command {
+	struct nl80211_vendor_cmd_info info;
+	u32 flags;
+	int (*doit)(struct wiphy *wiphy, struct wireless_dev *wdev,
+		    void *data, int data_len);
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -2774,6 +2794,9 @@ struct wiphy_coalesce_support {
  * @extended_capabilities_mask: mask of the valid values
  * @extended_capabilities_len: length of the extended capabilities
  * @coalesce: packet coalescing support information
+ *
+ * @vendor_commands: array of vendor commands supported by the hardware
+ * @n_vendor_commands: number of vendor commands
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2885,6 +2908,9 @@ struct wiphy {
 
 	const struct wiphy_coalesce_support *coalesce;
 
+	const struct wiphy_vendor_command *vendor_commands;
+	int n_vendor_commands;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -3815,6 +3841,75 @@ void wiphy_rfkill_start_polling(struct wiphy *wiphy);
  */
 void wiphy_rfkill_stop_polling(struct wiphy *wiphy);
 
+/**
+ * DOC: Vendor commands
+ *
+ * Occasionally, there are special protocol or firmware features that
+ * can't be implemented very openly. For this and similar cases, the
+ * vendor command functionality allows implementing the features with
+ * (typically closed-source) userspace and firmware, using nl80211 as
+ * the configuration mechanism.
+ *
+ * A driver supporting vendor commands must register them as an array
+ * in struct wiphy, with handlers for each one, each command has an
+ * OUI and sub command ID to identify it.
+ *
+ * Note that this feature should not be (ab)used to implement protocol
+ * features that could openly be shared across drivers. In particular,
+ * it must never be required to use vendor commands to implement any
+ * "normal" functionality that higher-level userspace like connection
+ * managers etc. need.
+ */
+
+struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
+					   enum nl80211_commands cmd,
+					   enum nl80211_attrs attr,
+					   int approxlen);
+
+/**
+ * cfg80211_vendor_cmd_alloc_reply_skb - allocate vendor command reply
+ * @wiphy: the wiphy
+ * @approxlen: an upper bound of the length of the data that will
+ *	be put into the skb
+ *
+ * This function allocates and pre-fills an skb for a reply to
+ * a vendor command. Since it is intended for a reply, calling
+ * it outside of a vendor command's doit() operation is invalid.
+ *
+ * The returned skb is pre-filled with some identifying data in
+ * a way that any data that is put into the skb (with skb_put(),
+ * nla_put() or similar) will end up being within the
+ * %NL80211_ATTR_VENDOR_DATA attribute, so all that needs to be done
+ * with the skb is adding data for the corresponding userspace tool
+ * which can then read that data out of the testdata attribute. You
+ * must not modify the skb in any other way.
+ *
+ * When done, call cfg80211_vendor_cmd_reply() with the skb and return
+ * its error code as the result of the doit() operation.
+ *
+ * Return: An allocated and pre-filled skb. %NULL if any errors happen.
+ */
+static inline struct sk_buff *
+cfg80211_vendor_cmd_alloc_reply_skb(struct wiphy *wiphy, int approxlen)
+{
+	return __cfg80211_alloc_reply_skb(wiphy, NL80211_CMD_TESTMODE,
+					  NL80211_ATTR_TESTDATA, approxlen);
+}
+
+/**
+ * cfg80211_vendor_cmd_reply - send the reply skb
+ * @skb: The skb, must have been allocated with
+ *	cfg80211_vendor_cmd_alloc_reply_skb()
+ *
+ * Since calling this function will usually be the last thing
+ * before returning from the vendor command doit() you should
+ * return the error code.  Note that this function consumes the
+ * skb regardless of the return value.
+ *
+ * Return: An error code or 0 on success.
+ */
+int cfg80211_vendor_cmd_reply(struct sk_buff *skb);
+
 #ifdef CONFIG_NL80211_TESTMODE
 /**
  * DOC: Test mode
@@ -3850,8 +3945,12 @@ void wiphy_rfkill_stop_polling(struct wiphy *wiphy);
  *
  * Return: An allocated and pre-filled skb. %NULL if any errors happen.
  */
-struct sk_buff *cfg80211_testmode_alloc_reply_skb(struct wiphy *wiphy,
-						  int approxlen);
+static inline struct sk_buff *
+cfg80211_testmode_alloc_reply_skb(struct wiphy *wiphy, int approxlen)
+{
+	return __cfg80211_alloc_reply_skb(wiphy, NL80211_CMD_TESTMODE,
+					  NL80211_ATTR_TESTDATA, approxlen);
+}
 
 /**
  * cfg80211_testmode_reply - send the reply skb
@@ -3865,7 +3964,10 @@ struct sk_buff *cfg80211_testmode_alloc_reply_skb(struct wiphy *wiphy,
  *
  * Return: An error code or 0 on success.
  */
-int cfg80211_testmode_reply(struct sk_buff *skb);
+static inline int cfg80211_testmode_reply(struct sk_buff *skb)
+{
+	return cfg80211_vendor_cmd_reply(skb);
+}
 
 /**
  * cfg80211_testmode_alloc_event_skb - allocate testmode event
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..d0a479a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -686,6 +686,15 @@
  *	other station that transmission must be blocked until the channel
  *	switch is complete.
  *
+ * @NL80211_CMD_VENDOR: Vendor-specified command/event. The command is specified
+ *	by the %NL80211_ATTR_VENDOR_ID attribute and a sub-command in
+ *	%NL80211_ATTR_VENDOR_SUBCMD. Parameter(s) can be transported in
+ *	%NL80211_ATTR_VENDOR_DATA.
+ *	For feature advertisement, the %NL80211_ATTR_VENDOR_DATA attribute is
+ *	used in the wiphy data as a nested attribute containing descriptions
+ *	(&struct nl80211_vendor_cmd_info) of the supported vendor commands.
+ *	This may also be sent as an event with the same attributes.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -853,6 +862,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CHANNEL_SWITCH,
 
+	NL80211_CMD_VENDOR,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1496,6 +1507,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
  *	As specified in the &enum nl80211_rxmgmt_flags.
  *
+ * @NL80211_ATTR_VENDOR_ID: The vendor ID, either a 24-bit OUI or, if
+ *	%NL80211_VENDOR_ID_IS_LINUX is set, a special Linux ID (not used yet)
+ * @NL80211_ATTR_VENDOR_SUBCMD: vendor sub-command
+ * @NL80211_ATTR_VENDOR_DATA: data for the vendor command, if any; this
+ *	attribute is also used for vendor command feature advertisement
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1806,6 +1823,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_VENDOR_ID,
+	NL80211_ATTR_VENDOR_SUBCMD,
+	NL80211_ATTR_VENDOR_DATA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3917,4 +3938,24 @@ enum nl80211_rxmgmt_flags {
 	NL80211_RXMGMT_FLAG_ANSWERED = 1 << 0,
 };
 
+/*
+ * If this flag is unset, the lower 24 bits are an OUI, if set
+ * a Linux nl80211 vendor ID is used (no such IDs are allocated
+ * yet, so that's not valid so far)
+ */
+#define NL80211_VENDOR_ID_IS_LINUX	0x80000000
+
+/**
+ * struct nl80211_vendor_cmd_info - vendor command data
+ * @vendor_id: If the %NL80211_VENDOR_ID_IS_LINUX flag is clear, then the
+ *	value is a 24-bit OUI; if it is set then a separately allocated ID
+ *	may be used, but no such IDs are allocated yet. New IDs should be
+ *	added to this file when needed.
+ * @subcmd: sub-command ID for the command
+ */
+struct nl80211_vendor_cmd_info {
+	u32 vendor_id;
+	u32 subcmd;
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b43efac..296c101 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -67,9 +67,7 @@ struct cfg80211_registered_device {
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
 
-#ifdef CONFIG_NL80211_TESTMODE
-	struct genl_info *testmode_info;
-#endif
+	struct genl_info *cur_cmd_info;
 
 	struct work_struct conn_work;
 	struct work_struct event_work;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2838206..92d34e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_VENDOR_ID] = { .type = NLA_U32 },
+	[NL80211_ATTR_VENDOR_SUBCMD] = { .type = NLA_U32 },
+	[NL80211_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 };
 
 /* policy for the key attributes */
@@ -1151,6 +1154,7 @@ struct nl80211_dump_wiphy_state {
 	s64 filter_wiphy;
 	long start;
 	long split_start, band_start, chan_start;
+	long vendor_start;
 	bool split;
 };
 
@@ -1162,6 +1166,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_cmds;
+	struct nlattr *nl_vendor_cmds;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
 	int i;
@@ -1556,6 +1561,20 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	case 10:
 		if (nl80211_send_coalesce(msg, dev))
 			goto nla_put_failure;
+		state->split_start++;
+		break;
+	case 11:
+		nl_vendor_cmds = nla_nest_start(msg, NL80211_ATTR_VENDOR_DATA);
+		if (!nl_vendor_cmds)
+			goto nla_put_failure;
+
+		for (i = state->vendor_start;
+		     i < dev->wiphy.n_vendor_commands; i++)
+			if (nla_put(msg, i + 1,
+				    sizeof(struct nl80211_vendor_cmd_info),
+				    &dev->wiphy.vendor_commands[i].info))
+				goto nla_put_failure;
+		nla_nest_end(msg, nl_vendor_cmds);
 
 		/* done */
 		state->split_start = 0;
@@ -6605,6 +6624,40 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static struct sk_buff *
+__cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
+			    int approxlen, u32 portid, u32 seq,
+			    enum nl80211_commands cmd,
+			    enum nl80211_attrs attr, gfp_t gfp)
+{
+	struct sk_buff *skb;
+	void *hdr;
+	struct nlattr *data;
+
+	skb = nlmsg_new(approxlen + 100, gfp);
+	if (!skb)
+		return NULL;
+
+	hdr = nl80211hdr_put(skb, portid, seq, 0, cmd);
+	if (!hdr) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	if (nla_put_u32(skb, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
+		goto nla_put_failure;
+	data = nla_nest_start(skb, attr);
+
+	((void **)skb->cb)[0] = rdev;
+	((void **)skb->cb)[1] = hdr;
+	((void **)skb->cb)[2] = data;
+
+	return skb;
+
+ nla_put_failure:
+	kfree_skb(skb);
+	return NULL;
+}
 
 #ifdef CONFIG_NL80211_TESTMODE
 static struct genl_multicast_group nl80211_testmode_mcgrp = {
@@ -6633,11 +6686,11 @@ static int nl80211_testmode_do(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_TESTDATA])
 		return -EINVAL;
 
-	rdev->testmode_info = info;
+	rdev->cur_cmd_info = info;
 	err = rdev_testmode_cmd(rdev, wdev,
 				nla_data(info->attrs[NL80211_ATTR_TESTDATA]),
 				nla_len(info->attrs[NL80211_ATTR_TESTDATA]));
-	rdev->testmode_info = NULL;
+	rdev->cur_cmd_info = NULL;
 
 	return err;
 }
@@ -6737,77 +6790,14 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 	return err;
 }
 
-static struct sk_buff *
-__cfg80211_testmode_alloc_skb(struct cfg80211_registered_device *rdev,
-			      int approxlen, u32 portid, u32 seq, gfp_t gfp)
-{
-	struct sk_buff *skb;
-	void *hdr;
-	struct nlattr *data;
-
-	skb = nlmsg_new(approxlen + 100, gfp);
-	if (!skb)
-		return NULL;
-
-	hdr = nl80211hdr_put(skb, portid, seq, 0, NL80211_CMD_TESTMODE);
-	if (!hdr) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
-	if (nla_put_u32(skb, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
-		goto nla_put_failure;
-	data = nla_nest_start(skb, NL80211_ATTR_TESTDATA);
-
-	((void **)skb->cb)[0] = rdev;
-	((void **)skb->cb)[1] = hdr;
-	((void **)skb->cb)[2] = data;
-
-	return skb;
-
- nla_put_failure:
-	kfree_skb(skb);
-	return NULL;
-}
-
-struct sk_buff *cfg80211_testmode_alloc_reply_skb(struct wiphy *wiphy,
-						  int approxlen)
-{
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	if (WARN_ON(!rdev->testmode_info))
-		return NULL;
-
-	return __cfg80211_testmode_alloc_skb(rdev, approxlen,
-				rdev->testmode_info->snd_portid,
-				rdev->testmode_info->snd_seq,
-				GFP_KERNEL);
-}
-EXPORT_SYMBOL(cfg80211_testmode_alloc_reply_skb);
-
-int cfg80211_testmode_reply(struct sk_buff *skb)
-{
-	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
-	void *hdr = ((void **)skb->cb)[1];
-	struct nlattr *data = ((void **)skb->cb)[2];
-
-	if (WARN_ON(!rdev->testmode_info)) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
-	nla_nest_end(skb, data);
-	genlmsg_end(skb, hdr);
-	return genlmsg_reply(skb, rdev->testmode_info);
-}
-EXPORT_SYMBOL(cfg80211_testmode_reply);
-
 struct sk_buff *cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy,
 						  int approxlen, gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	return __cfg80211_testmode_alloc_skb(rdev, approxlen, 0, 0, gfp);
+	return __cfg80211_alloc_vendor_skb(rdev, approxlen, 0, 0,
+					   NL80211_CMD_TESTMODE,
+					   NL80211_ATTR_TESTDATA, gfp);
 }
 EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb);
 
@@ -8791,6 +8781,108 @@ static int nl80211_crit_protocol_stop(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev =
+		__cfg80211_wdev_from_attrs(genl_info_net(info), info->attrs);
+	int i, err;
+	u32 vid, subcmd;
+
+	if (!rdev->wiphy.vendor_commands)
+		return -EOPNOTSUPP;
+
+	if (IS_ERR(wdev)) {
+		err = PTR_ERR(wdev);
+		if (err != -EINVAL)
+			return err;
+		wdev = NULL;
+	} else if (wdev->wiphy != &rdev->wiphy) {
+		return -EINVAL;
+	}
+
+	if (!info->attrs[NL80211_ATTR_VENDOR_ID] ||
+	    !info->attrs[NL80211_ATTR_VENDOR_SUBCMD])
+		return -EINVAL;
+
+	vid = nla_get_u32(info->attrs[NL80211_ATTR_VENDOR_ID]);
+	subcmd = nla_get_u32(info->attrs[NL80211_ATTR_VENDOR_SUBCMD]);
+	for (i = 0; i < rdev->wiphy.n_vendor_commands; i++) {
+		const struct wiphy_vendor_command *vcmd;
+		void *data = NULL;
+		int len = 0;
+
+		vcmd = &rdev->wiphy.vendor_commands[i];
+
+		if (vcmd->info.vendor_id != vid || vcmd->info.subcmd != subcmd)
+			continue;
+
+		if (vcmd->flags & (WIPHY_VENDOR_CMD_NEED_WDEV |
+				   WIPHY_VENDOR_CMD_NEED_NETDEV)) {
+			if (!wdev)
+				return -EINVAL;
+			if (vcmd->flags & WIPHY_VENDOR_CMD_NEED_NETDEV &&
+			    !wdev->netdev)
+				return -EINVAL;
+
+			if (vcmd->flags & WIPHY_VENDOR_CMD_NEED_RUNNING) {
+				if (wdev->netdev &&
+				    !netif_running(wdev->netdev))
+					return -ENETDOWN;
+				else if (!wdev->p2p_started)
+					return -ENETDOWN;
+			}
+		} else {
+			wdev = NULL;
+		}
+
+		if (info->attrs[NL80211_ATTR_VENDOR_DATA]) {
+			data = nla_data(info->attrs[NL80211_ATTR_VENDOR_DATA]);
+			len = nla_len(info->attrs[NL80211_ATTR_VENDOR_DATA]);
+		}
+
+		return rdev->wiphy.vendor_commands[i].doit(&rdev->wiphy, wdev,
+							   data, len);
+	}
+
+	return -EOPNOTSUPP;
+}
+
+struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
+					   enum nl80211_commands cmd,
+					   enum nl80211_attrs attr,
+					   int approxlen)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	if (WARN_ON(!rdev->cur_cmd_info))
+		return NULL;
+
+	return __cfg80211_alloc_vendor_skb(rdev, approxlen,
+					   rdev->cur_cmd_info->snd_portid,
+					   rdev->cur_cmd_info->snd_seq,
+					   cmd, attr, GFP_KERNEL);
+}
+EXPORT_SYMBOL(__cfg80211_alloc_reply_skb);
+
+int cfg80211_vendor_cmd_reply(struct sk_buff *skb)
+{
+	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
+	void *hdr = ((void **)skb->cb)[1];
+	struct nlattr *data = ((void **)skb->cb)[2];
+
+	if (WARN_ON(!rdev->cur_cmd_info)) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	nla_nest_end(skb, data);
+	genlmsg_end(skb, hdr);
+	return genlmsg_reply(skb, rdev->cur_cmd_info);
+}
+EXPORT_SYMBOL(cfg80211_vendor_cmd_reply);
+
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -9515,6 +9607,13 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_VENDOR,
+		.doit = nl80211_vendor_cmd,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.8.4.rc3

