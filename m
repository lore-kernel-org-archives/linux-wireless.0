Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.129.253]:57987 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbZKJOUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 09:20:51 -0500
Received: from mx51.mymxserver.com (mail5103.mittwald.de [172.16.51.3])
	by emita2.mittwald.de (Postfix) with ESMTP id A9DA95FD454
	for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 15:20:55 +0100 (CET)
From: Holger Schurig <holgerschurig@gmail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFC, v2] cfg80211: first stab at channel survey
Date: Tue, 10 Nov 2009 15:20:06 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911101520.06333.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the NL80211_CMD_GET_SURVEY command and an get_survey()
ops that a driver can implement. The goal of this command is to allow a
driver to report back channel survey data (e.g. channel noise, channel
occupation) back to cfg80211 and thus via nl80211 to user-space.

In future, they will either be a survey-trigger command --- or the existing
scan-trigger command will be enhanced. However, the get_survey() operation
is usable even in absence of this: a driver can report the channel noise in
mBm with the implemented mechanism.

get_survey() is currently modelled like get_key(). I hope that's right.

struct survey_info is modelled like struct station_info. This allows different
drivers to fill in different fields.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
v2: * channel is mandatory (by way of callback-parameter)
    * switched to .dump operation, e.g. nl80211_dump_survey() is now
      similar to nl80211_dump_stations() and nl80211_send_survey()
      is similar to nl80211_send_station().
    * this also means that the cfg80211_ops dump_survey() now carries
      an idx. A possible implementation (sketched, not compile-tested)
      for libertas could be:

int lbs_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
	int idx, struct survey_info *info)
{
	struct lbs_private *priv = wiphy_priv(wiphy);

	if (idx != 0)
		return -ENOENT;

	info->channel = priv->channel;
	info->filled = SURVEY_INFO_NOISE_MBM;
	info->noise = CAL_NF(...);
	return 0;
}

but other drives would use idx to iterate over stored survey information and
return the according information.


Johannes, this is so far only compile-, sparse- and checkpatch.pl tested. I
haven't yet added code to libertas and "iw", but this will be done ASAP.

I also wonder if I should add code to mac80211_hwsim to just report
back something, so that we have a hardware independend guinea pig :-)
    

--- linux-wl.orig/include/linux/nl80211.h
+++ linux-wl/include/linux/nl80211.h
@@ -160,6 +160,11 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_GET_SURVEY: get survey resuls, e.g. channel occupation
+ *      or noise level
+ * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
+ *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
+ *
  * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
  * 	has been changed and provides details of the request information
  * 	that caused the change such as who initiated the regulatory request
@@ -341,6 +346,9 @@
 
 	NL80211_CMD_SET_WIPHY_NETNS,
 
+	NL80211_CMD_GET_SURVEY,
+	NL80211_CMD_NEW_SURVEY_RESULTS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -584,6 +592,11 @@
  *	changed then the list changed and the dump should be repeated
  *	completely from scratch.
  *
+ * @NL80211_ATTR_SURVEY_NOISE: noise from survey in mBm
+ * @NL80211_ATTR_SURVEY_INFO: survey information about a channel, part of
+ *      the survey response for %NL80211_CMD_GET_SURVEY, nested attribute
+ *      containing info as possible, see &enum survey_info.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -714,6 +727,9 @@
 
 	NL80211_ATTR_PID,
 
+	NL80211_ATTR_SURVEY_NOISE,
+	NL80211_ATTR_SURVEY_INFO,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- linux-wl.orig/include/net/cfg80211.h
+++ linux-wl/include/net/cfg80211.h
@@ -233,6 +233,35 @@
 };
 
 /**
+ * enum survey_info_flags - survey information flags
+ *
+ * Used by the driver to indicate which info in &struct survey_info
+ * it has filled in during the get_survey().
+ */
+enum survey_info_flags {
+	SURVEY_INFO_NOISE_MBM = 1<<0,
+};
+
+/**
+ * struct survey_info - channel survey response
+ *
+ * Used by dump_survey() to report back per-channel survey information.
+ *
+ * @channel: the channel this survey record reports, mandatory
+ * @filled: bitflag of flags from &enum survey_info_flags
+ * @noise: channel noise in mBm. This and all following fields are
+ *     optional
+ *
+ * This structure can later be expanded with things like
+ * channel duty cycle etc.
+ */
+struct survey_info {
+	struct ieee80211_channel *channel;
+	u32 filled;
+	s32 noise;
+};
+
+/**
  * struct beacon_parameters - beacon parameters
  *
  * Used to configure the beacon for an interface.
@@ -941,6 +970,8 @@
  * @rfkill_poll: polls the hw rfkill line, use cfg80211 reporting
  *	functions to adjust rfkill hw state
  *
+ * @dump_survey: get site survey information about.
+ *
  * @testmode_cmd: run a test mode command
  */
 struct cfg80211_ops {
@@ -1060,6 +1091,9 @@
 				    const u8 *peer,
 				    const struct cfg80211_bitrate_mask *mask);
 
+	int	(*dump_survey)(struct wiphy *wiphy, struct net_device *netdev,
+			int idx, struct survey_info *info);
+
 	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
--- linux-wl.orig/net/wireless/nl80211.c
+++ linux-wl/net/wireless/nl80211.c
@@ -3229,6 +3229,101 @@
 	return err;
 }
 
+static int nl80211_send_survey(struct sk_buff *msg, u32 pid, u32 seq,
+				int flags, struct net_device *dev,
+				struct survey_info *survey)
+{
+	void *hdr;
+	struct nlattr *surveyattr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags,
+			     NL80211_CMD_NEW_SURVEY_RESULTS);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+
+	surveyattr = nla_nest_start(msg, NL80211_ATTR_SURVEY_INFO);
+	if (!surveyattr)
+		goto nla_put_failure;
+
+	if (nl80211_msg_put_channel(msg, survey->channel))
+		goto nla_put_failure;
+
+	if (survey->filled & SURVEY_INFO_NOISE_MBM)
+		NLA_PUT_U32(msg, NL80211_ATTR_SURVEY_NOISE,
+			    survey->noise);
+	nla_nest_end(msg, surveyattr);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int nl80211_dump_survey(struct sk_buff *skb,
+			struct netlink_callback *cb)
+{
+	struct survey_info survey;
+	struct cfg80211_registered_device *dev;
+	struct net_device *netdev;
+	int ifidx = cb->args[0];
+	int survey_idx = cb->args[1];
+	int err;
+
+	if (!ifidx)
+		ifidx = nl80211_get_ifidx(cb);
+	if (ifidx < 0)
+		return ifidx;
+
+	rtnl_lock();
+
+	netdev = __dev_get_by_index(sock_net(skb->sk), ifidx);
+	if (!netdev) {
+		err = -ENODEV;
+		goto out_rtnl;
+	}
+
+	dev = cfg80211_get_dev_from_ifindex(sock_net(skb->sk), ifidx);
+	if (IS_ERR(dev)) {
+		err = PTR_ERR(dev);
+		goto out_rtnl;
+	}
+
+	if (!dev->ops->dump_survey) {
+		err = -EOPNOTSUPP;
+		goto out_err;
+	}
+
+	while (1) {
+		err = dev->ops->dump_survey(&dev->wiphy, netdev, survey_idx,
+					    &survey);
+		if (err == -ENOENT)
+			break;
+		if (err)
+			goto out_err;
+
+		if (nl80211_send_survey(skb,
+				NETLINK_CB(cb->skb).pid,
+				cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				netdev,
+				&survey) < 0)
+			goto out;
+		survey_idx++;
+	}
+
+ out:
+	cb->args[1] = survey_idx;
+	err = skb->len;
+ out_err:
+	cfg80211_unlock_rdev(dev);
+ out_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
 static bool nl80211_valid_auth_type(enum nl80211_auth_type auth_type)
 {
 	return auth_type <= NL80211_AUTHTYPE_MAX;
@@ -4306,6 +4401,11 @@
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_GET_SURVEY,
+		.policy = nl80211_policy,
+		.dumpit = nl80211_dump_survey,
+	},
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",

-- 
http://www.holgerschurig.de
