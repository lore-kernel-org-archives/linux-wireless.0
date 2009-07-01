Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbZGATf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:56 -0400
Message-Id: <20090701193420.192948769@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/20 v4] cfg80211: introduce nl80211 testmode command
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces a new NL80211_CMD_TESTMODE for testing
and calibration use with nl80211. There's no multiplexing
like like iwpriv had, and the command is not available by
default, it needs to be explicitly enabled in Kconfig and
shouldn't be enabled in most kernels.

The command requires a wiphy index or interface index to
identify the device to operate on, and the new TESTDATA
attribute. There also is API for sending replies to the
command, and testmode multicast messages (on a testmode
multicast group).

I've also updated mac80211 to be able to pass through the
command to the driver, since it itself doesn't implement
the testmode command.

Additionally, to give people an idea of how to use the
command, I've added a little code to hwsim that makes use
of the new command to set the powersave mode, this is
currently done via debugfs and should remain there, and
the testmode command only serves as an example of how to
use this best -- with nested netlink attributes in the
TESTDATA attribute. A hwsim testmode tool can be found at
http://git.sipsolutions.net/hwsim.git/. This tool is BSD
licensed so people can easily use it as a basis for their
own internal fabrication and validation tools.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I haven't implemented dumping because right now I'm not sure
how to, nor whether people will use it when they can allocate
larger skbs for more data which in test environments should
be acceptable.

 drivers/net/wireless/mac80211_hwsim.c |   68 +++++++++++++++++
 include/linux/nl80211.h               |   11 ++
 include/net/cfg80211.h                |   83 ++++++++++++++++++++
 include/net/mac80211.h                |    5 +
 net/mac80211/cfg.c                    |   13 +++
 net/wireless/Kconfig                  |   15 +++
 net/wireless/core.h                   |    4 +
 net/wireless/nl80211.c                |  136 ++++++++++++++++++++++++++++++++++
 8 files changed, 335 insertions(+)

--- wireless-testing.orig/include/linux/nl80211.h	2009-07-01 08:55:06.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-07-01 09:01:20.000000000 +0200
@@ -242,6 +242,10 @@
  * @NL80211_CMD_LEAVE_IBSS: Leave the IBSS -- no special arguments, the IBSS is
  *	determined by the network interface.
  *
+ * @NL80211_CMD_TESTMODE: testmode command, takes a wiphy (or ifindex) attribute
+ *	to identify the device, and the TESTDATA blob attribute to pass through
+ *	to the driver.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -310,6 +314,8 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_IBSS,
 	NL80211_CMD_LEAVE_IBSS,
 
+	NL80211_CMD_TESTMODE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -511,6 +517,9 @@ enum nl80211_commands {
  *	authorized by user space. Otherwise, port is marked authorized by
  *	default in station mode.
  *
+ * @NL80211_ATTR_TESTDATA: Testmode data blob, passed through to the driver.
+ *	We recommend using nested, driver-specific attributes within this.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -619,6 +628,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CONTROL_PORT,
 
+	NL80211_ATTR_TESTDATA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2009-07-01 09:01:19.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-01 09:01:20.000000000 +0200
@@ -857,6 +857,8 @@ enum tx_power_setting {
  *
  * @rfkill_poll: polls the hw rfkill line, use cfg80211 reporting
  *	functions to adjust rfkill hw state
+ *
+ * @testmode_cmd: run a test mode command
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -955,6 +957,10 @@ struct cfg80211_ops {
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
 
 	void	(*rfkill_poll)(struct wiphy *wiphy);
+
+#ifdef CONFIG_NL80211_TESTMODE
+	int	(*testmode_cmd)(struct wiphy *wiphy, void *data, int len);
+#endif
 };
 
 /*
@@ -1705,4 +1711,81 @@ void wiphy_rfkill_start_polling(struct w
  */
 void wiphy_rfkill_stop_polling(struct wiphy *wiphy);
 
+#ifdef CONFIG_NL80211_TESTMODE
+/**
+ * cfg80211_testmode_alloc_reply_skb - allocate testmode reply
+ * @wiphy: the wiphy
+ * @approxlen: an upper bound of the length of the data that will
+ *	be put into the skb
+ *
+ * This function allocates and pre-fills an skb for a reply to
+ * the testmode command. Since it is intended for a reply, calling
+ * it outside of the @testmode_cmd operation is invalid.
+ *
+ * The returned skb (or %NULL if any errors happen) is pre-filled
+ * with the wiphy index and set up in a way that any data that is
+ * put into the skb (with skb_put(), nla_put() or similar) will end
+ * up being within the %NL80211_ATTR_TESTDATA attribute, so all that
+ * needs to be done with the skb is adding data for the corresponding
+ * userspace tool which can then read that data out of the testdata
+ * attribute. You must not modify the skb in any other way.
+ *
+ * When done, call cfg80211_testmode_reply() with the skb and return
+ * its error code as the result of the @testmode_cmd operation.
+ */
+struct sk_buff *cfg80211_testmode_alloc_reply_skb(struct wiphy *wiphy,
+						  int approxlen);
+
+/**
+ * cfg80211_testmode_reply - send the reply skb
+ * @skb: The skb, must have been allocated with
+ *	cfg80211_testmode_alloc_reply_skb()
+ *
+ * Returns an error code or 0 on success, since calling this
+ * function will usually be the last thing before returning
+ * from the @testmode_cmd you should return the error code.
+ * Note that this function consumes the skb regardless of the
+ * return value.
+ */
+int cfg80211_testmode_reply(struct sk_buff *skb);
+
+/**
+ * cfg80211_testmode_alloc_event_skb - allocate testmode event
+ * @wiphy: the wiphy
+ * @approxlen: an upper bound of the length of the data that will
+ *	be put into the skb
+ * @gfp: allocation flags
+ *
+ * This function allocates and pre-fills an skb for an event on the
+ * testmode multicast group.
+ *
+ * The returned skb (or %NULL if any errors happen) is set up in the
+ * same way as with cfg80211_testmode_alloc_reply_skb() but prepared
+ * for an event. As there, you should simply add data to it that will
+ * then end up in the %NL80211_ATTR_TESTDATA attribute. Again, you must
+ * not modify the skb in any other way.
+ *
+ * When done filling the skb, call cfg80211_testmode_event() with the
+ * skb to send the event.
+ */
+struct sk_buff *cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy,
+						  int approxlen, gfp_t gfp);
+
+/**
+ * cfg80211_testmode_event - send the event
+ * @skb: The skb, must have been allocated with
+ *	cfg80211_testmode_alloc_event_skb()
+ * @gfp: allocation flags
+ *
+ * This function sends the given @skb, which must have been allocated
+ * by cfg80211_testmode_alloc_event_skb(), as an event. It always
+ * consumes it.
+ */
+void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp);
+
+#define CFG80211_TESTMODE_CMD(cmd)	.testmode_cmd = (cmd),
+#else
+#define CFG80211_TESTMODE_CMD(cmd)
+#endif
+
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/wireless/Kconfig	2009-07-01 08:59:43.000000000 +0200
+++ wireless-testing/net/wireless/Kconfig	2009-07-01 09:01:20.000000000 +0200
@@ -2,6 +2,21 @@ config CFG80211
 	tristate "Improved wireless configuration API"
 	depends on RFKILL || !RFKILL
 
+config NL80211_TESTMODE
+	bool "nl80211 testmode command"
+	depends on CFG80211
+	help
+	  The nl80211 testmode command helps implementing things like
+	  factory calibration or validation tools for wireless chips.
+
+	  Select this option ONLY for kernels that are specifically
+	  built for such purposes.
+
+	  Debugging tools that are supposed to end up in the hands of
+	  users should better be implemented with debugfs.
+
+	  Say N.
+
 config CFG80211_REG_DEBUG
 	bool "cfg80211 regulatory debugging"
 	depends on CFG80211
--- wireless-testing.orig/net/wireless/core.h	2009-07-01 08:55:05.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-01 09:01:20.000000000 +0200
@@ -58,6 +58,10 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	unsigned long suspend_at;
 
+#ifdef CONFIG_NL80211_TESTMODE
+	struct genl_info *testmode_info;
+#endif
+
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-01 09:01:15.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-01 09:01:20.000000000 +0200
@@ -3415,6 +3415,128 @@ unlock_rtnl:
 	return err;
 }
 
+#ifdef CONFIG_NL80211_TESTMODE
+static struct genl_multicast_group nl80211_testmode_mcgrp = {
+	.name = "testmode",
+};
+
+static int nl80211_testmode_do(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_TESTDATA])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		err = PTR_ERR(rdev);
+		goto unlock_rtnl;
+	}
+
+	err = -EOPNOTSUPP;
+	if (rdev->ops->testmode_cmd) {
+		rdev->testmode_info = info;
+		err = rdev->ops->testmode_cmd(&rdev->wiphy,
+				nla_data(info->attrs[NL80211_ATTR_TESTDATA]),
+				nla_len(info->attrs[NL80211_ATTR_TESTDATA]));
+		rdev->testmode_info = NULL;
+	}
+
+	cfg80211_put_dev(rdev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static struct sk_buff *
+__cfg80211_testmode_alloc_skb(struct cfg80211_registered_device *rdev,
+			      int approxlen, u32 pid, u32 seq, gfp_t gfp)
+{
+	struct sk_buff *skb;
+	void *hdr;
+	struct nlattr *data;
+
+	skb = nlmsg_new(approxlen + 100, gfp);
+	if (!skb)
+		return NULL;
+
+	hdr = nl80211hdr_put(skb, pid, seq, 0, NL80211_CMD_TESTMODE);
+	if (!hdr) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	NLA_PUT_U32(skb, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	data = nla_nest_start(skb, NL80211_ATTR_TESTDATA);
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
+
+struct sk_buff *cfg80211_testmode_alloc_reply_skb(struct wiphy *wiphy,
+						  int approxlen)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	if (WARN_ON(!rdev->testmode_info))
+		return NULL;
+
+	return __cfg80211_testmode_alloc_skb(rdev, approxlen,
+				rdev->testmode_info->snd_pid,
+				rdev->testmode_info->snd_seq,
+				GFP_KERNEL);
+}
+EXPORT_SYMBOL(cfg80211_testmode_alloc_reply_skb);
+
+int cfg80211_testmode_reply(struct sk_buff *skb)
+{
+	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
+	void *hdr = ((void **)skb->cb)[1];
+	struct nlattr *data = ((void **)skb->cb)[2];
+
+	if (WARN_ON(!rdev->testmode_info)) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	nla_nest_end(skb, data);
+	genlmsg_end(skb, hdr);
+	return genlmsg_reply(skb, rdev->testmode_info);
+}
+EXPORT_SYMBOL(cfg80211_testmode_reply);
+
+struct sk_buff *cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy,
+						  int approxlen, gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	return __cfg80211_testmode_alloc_skb(rdev, approxlen, 0, 0, gfp);
+}
+EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb);
+
+void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
+{
+	void *hdr = ((void **)skb->cb)[1];
+	struct nlattr *data = ((void **)skb->cb)[2];
+
+	nla_nest_end(skb, data);
+	genlmsg_end(skb, hdr);
+	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+}
+EXPORT_SYMBOL(cfg80211_testmode_event);
+#endif
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -3628,6 +3750,14 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+#ifdef CONFIG_NL80211_TESTMODE
+	{
+		.cmd = NL80211_CMD_TESTMODE,
+		.doit = nl80211_testmode_do,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+#endif
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
@@ -4101,6 +4231,12 @@ int nl80211_init(void)
 	if (err)
 		goto err_out;
 
+#ifdef CONFIG_NL80211_TESTMODE
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_testmode_mcgrp);
+	if (err)
+		goto err_out;
+#endif
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
--- wireless-testing.orig/include/net/mac80211.h	2009-07-01 08:55:06.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-07-01 09:01:20.000000000 +0200
@@ -1419,6 +1419,8 @@ enum ieee80211_ampdu_mlme_action {
  * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
  *	need to set wiphy->rfkill_poll to %true before registration,
  *	and need to call wiphy_rfkill_set_hw_state() in the callback.
+ *
+ * @testmode_cmd: Implement a cfg80211 test mode command.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1469,6 +1471,9 @@ struct ieee80211_ops {
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
+#ifdef CONFIG_NL80211_TESTMODE
+	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
+#endif
 };
 
 /**
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-01 08:55:05.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-01 09:01:20.000000000 +0200
@@ -1376,6 +1376,18 @@ static void ieee80211_rfkill_poll(struct
 	drv_rfkill_poll(local);
 }
 
+#ifdef CONFIG_NL80211_TESTMODE
+int ieee80211_testmode_cmd(struct wiphy *wiphy, void *data, int len)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (!local->ops->testmode_cmd)
+		return -EOPNOTSUPP;
+
+	return local->ops->testmode_cmd(&local->hw, data, len);
+}
+#endif
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1418,4 +1430,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
 	.rfkill_poll = ieee80211_rfkill_poll,
+	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
 };
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-01 08:56:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-01 09:01:20.000000000 +0200
@@ -699,6 +699,73 @@ static int mac80211_hwsim_conf_tx(
 	return 0;
 }
 
+#ifdef CONFIG_NL80211_TESTMODE
+/*
+ * This section contains example code for using netlink
+ * attributes with the testmode command in nl80211.
+ */
+
+/* These enums need to be kept in sync with userspace */
+enum hwsim_testmode_attr {
+	__HWSIM_TM_ATTR_INVALID	= 0,
+	HWSIM_TM_ATTR_CMD	= 1,
+	HWSIM_TM_ATTR_PS	= 2,
+
+	/* keep last */
+	__HWSIM_TM_ATTR_AFTER_LAST,
+	HWSIM_TM_ATTR_MAX	= __HWSIM_TM_ATTR_AFTER_LAST - 1
+};
+
+enum hwsim_testmode_cmd {
+	HWSIM_TM_CMD_SET_PS		= 0,
+	HWSIM_TM_CMD_GET_PS		= 1,
+};
+
+static const struct nla_policy hwsim_testmode_policy[HWSIM_TM_ATTR_MAX + 1] = {
+	[HWSIM_TM_ATTR_CMD] = { .type = NLA_U32 },
+	[HWSIM_TM_ATTR_PS] = { .type = NLA_U32 },
+};
+
+static int hwsim_fops_ps_write(void *dat, u64 val);
+
+int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
+{
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+	struct nlattr *tb[HWSIM_TM_ATTR_MAX + 1];
+	struct sk_buff *skb;
+	int err, ps;
+
+	err = nla_parse(tb, HWSIM_TM_ATTR_MAX, data, len,
+			hwsim_testmode_policy);
+	if (err)
+		return err;
+
+	if (!tb[HWSIM_TM_ATTR_CMD])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[HWSIM_TM_ATTR_CMD])) {
+	case HWSIM_TM_CMD_SET_PS:
+		if (!tb[HWSIM_TM_ATTR_PS])
+			return -EINVAL;
+		ps = nla_get_u32(tb[HWSIM_TM_ATTR_PS]);
+		return hwsim_fops_ps_write(hwsim, ps);
+	case HWSIM_TM_CMD_GET_PS:
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
+						nla_total_size(sizeof(u32)));
+		if (!skb)
+			return -ENOMEM;
+		NLA_PUT_U32(skb, HWSIM_TM_ATTR_PS, hwsim->ps);
+		return cfg80211_testmode_reply(skb);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+ nla_put_failure:
+	kfree_skb(skb);
+	return -ENOBUFS;
+}
+#endif
+
 static const struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -712,6 +779,7 @@ static const struct ieee80211_ops mac802
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
 	.conf_tx = mac80211_hwsim_conf_tx,
+	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
 };
 
 

-- 

