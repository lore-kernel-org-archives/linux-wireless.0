Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab1ETQDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 12:03:19 -0400
Subject: [PATCH] nl80211: add testmode dump support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 09:05:54 -0700
Message-ID: <1305907554.4640.5.camel@jlt3.sipsolutions.net> (sfid-20110520_180323_624266_2C1AF3B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This adds dump support to testmode. The testmode
dump support in nl80211 requires using two of the
six cb->args, the rest can be used by the driver
to figure out where the dump position is at or to
store other data across invocations.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |   11 ++++++
 include/net/mac80211.h |    4 ++
 net/mac80211/cfg.c     |   14 +++++++
 net/wireless/nl80211.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+)

--- a/include/net/cfg80211.h	2011-05-19 16:36:39.000000000 -0700
+++ b/include/net/cfg80211.h	2011-05-20 07:40:35.000000000 -0700
@@ -1250,6 +1250,12 @@ struct cfg80211_wowlan {
  *	frame on another channel
  *
  * @testmode_cmd: run a test mode command
+ * @testmode_dump: Implement a test mode dump. The cb->args[2] and up may be
+ *	used by the function, but 0 and 1 must not be touched. Additionally,
+ *	return error codes other than -ENOBUFS and -ENOENT will terminate the
+ *	dump and return to userspace with an error, so be careful. If any data
+ *	was passed in from userspace then the data/len arguments will be present
+ *	and point to the data contained in %NL80211_ATTR_TESTDATA.
  *
  * @set_bitrate_mask: set the bitrate mask configuration
  *
@@ -1395,6 +1401,9 @@ struct cfg80211_ops {
 
 #ifdef CONFIG_NL80211_TESTMODE
 	int	(*testmode_cmd)(struct wiphy *wiphy, void *data, int len);
+	int	(*testmode_dump)(struct wiphy *wiphy, struct sk_buff *skb,
+				 struct netlink_callback *cb,
+				 void *data, int len);
 #endif
 
 	int	(*set_bitrate_mask)(struct wiphy *wiphy,
@@ -2692,8 +2701,10 @@ struct sk_buff *cfg80211_testmode_alloc_
 void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp);
 
 #define CFG80211_TESTMODE_CMD(cmd)	.testmode_cmd = (cmd),
+#define CFG80211_TESTMODE_DUMP(cmd)	.testmode_dump = (cmd),
 #else
 #define CFG80211_TESTMODE_CMD(cmd)
+#define CFG80211_TESTMODE_DUMP(cmd)
 #endif
 
 /**
--- a/include/net/mac80211.h	2011-05-19 16:36:39.000000000 -0700
+++ b/include/net/mac80211.h	2011-05-20 08:59:54.000000000 -0700
@@ -1794,6 +1794,7 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @testmode_cmd: Implement a cfg80211 test mode command.
  *	The callback can sleep.
+ * @testmode_dump: Implement a cfg80211 test mode dump. The callback can sleep.
  *
  * @flush: Flush all pending frames from the hardware queue, making sure
  *	that the hardware queues are empty. If the parameter @drop is set
@@ -1908,6 +1909,9 @@ struct ieee80211_ops {
 	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
+	int (*testmode_dump)(struct ieee80211_hw *hw, struct sk_buff *skb,
+			     struct netlink_callback *cb,
+			     void *data, int len);
 #endif
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
--- a/net/mac80211/cfg.c	2011-05-19 16:36:39.000000000 -0700
+++ b/net/mac80211/cfg.c	2011-05-20 08:59:54.000000000 -0700
@@ -1518,6 +1518,19 @@ static int ieee80211_testmode_cmd(struct
 
 	return local->ops->testmode_cmd(&local->hw, data, len);
 }
+
+static int ieee80211_testmode_dump(struct wiphy *wiphy,
+				   struct sk_buff *skb,
+				   struct netlink_callback *cb,
+				   void *data, int len)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (!local->ops->testmode_dump)
+		return -EOPNOTSUPP;
+
+	return local->ops->testmode_dump(&local->hw, skb, cb, data, len);
+}
 #endif
 
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
@@ -2096,6 +2109,7 @@ struct cfg80211_ops mac80211_config_ops
 	.set_wds_peer = ieee80211_set_wds_peer,
 	.rfkill_poll = ieee80211_rfkill_poll,
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
+	CFG80211_TESTMODE_DUMP(ieee80211_testmode_dump)
 	.set_power_mgmt = ieee80211_set_power_mgmt,
 	.set_bitrate_mask = ieee80211_set_bitrate_mask,
 	.remain_on_channel = ieee80211_remain_on_channel,
--- a/net/wireless/nl80211.c	2011-05-19 16:36:39.000000000 -0700
+++ b/net/wireless/nl80211.c	2011-05-20 07:56:47.000000000 -0700
@@ -4089,6 +4089,93 @@ static int nl80211_testmode_do(struct sk
 	return err;
 }
 
+static int nl80211_testmode_dump(struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct cfg80211_registered_device *dev;
+	int err;
+	long phy_idx;
+	void *data = NULL;
+	int data_len = 0;
+
+	if (cb->args[0]) {
+		/*
+		 * 0 is a valid index, but not valid for args[0],
+		 * so we need to offset by 1.
+		 */
+		phy_idx = cb->args[0] - 1;
+	} else {
+		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
+				  nl80211_policy);
+		if (err)
+			return err;
+		if (!nl80211_fam.attrbuf[NL80211_ATTR_WIPHY])
+			return -EINVAL;
+		phy_idx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_WIPHY]);
+		if (nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA])
+			cb->args[1] =
+				(long)nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA];
+	}
+
+	if (cb->args[1]) {
+		data = nla_data((void *)cb->args[1]);
+		data_len = nla_len((void *)cb->args[1]);
+	}
+
+	mutex_lock(&cfg80211_mutex);
+	dev = cfg80211_rdev_by_wiphy_idx(phy_idx);
+	if (!dev) {
+		mutex_unlock(&cfg80211_mutex);
+		return -ENOENT;
+	}
+	cfg80211_lock_rdev(dev);
+	mutex_unlock(&cfg80211_mutex);
+
+	if (!dev->ops->testmode_dump) {
+		err = -EOPNOTSUPP;
+		goto out_err;
+	}
+
+	while (1) {
+		void *hdr = nl80211hdr_put(skb, NETLINK_CB(cb->skb).pid,
+					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					   NL80211_CMD_TESTMODE);
+		struct nlattr *tmdata;
+
+		if (nla_put_u32(skb, NL80211_ATTR_WIPHY, dev->wiphy_idx) < 0) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		}
+
+		tmdata = nla_nest_start(skb, NL80211_ATTR_TESTDATA);
+		if (!tmdata) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		}
+		err = dev->ops->testmode_dump(&dev->wiphy, skb, cb,
+					      data, data_len);
+		nla_nest_end(skb, tmdata);
+
+		if (err == -ENOBUFS || err == -ENOENT) {
+			genlmsg_cancel(skb, hdr);
+			break;
+		} else if (err) {
+			genlmsg_cancel(skb, hdr);
+			goto out_err;
+		}
+
+		genlmsg_end(skb, hdr);
+	}
+
+	err = skb->len;
+	/* see above */
+	cb->args[0] = phy_idx + 1;
+ out_err:
+	cfg80211_unlock_rdev(dev);
+	return err;
+}
+
 static struct sk_buff *
 __cfg80211_testmode_alloc_skb(struct cfg80211_registered_device *rdev,
 			      int approxlen, u32 pid, u32 seq, gfp_t gfp)
@@ -5370,6 +5457,7 @@ static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_TESTMODE,
 		.doit = nl80211_testmode_do,
+		.dumpit = nl80211_testmode_dump,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |


