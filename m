Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934075Ab3FSJA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 05:00:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: use small state buffer for wiphy_dump
Date: Wed, 19 Jun 2013 11:00:22 +0200
Message-Id: <1371632422-21760-1-git-send-email-johannes@sipsolutions.net> (sfid-20130619_110039_742827_520A4B7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Avoid parsing the original dump message again and again by
allocating a small state struct that is used by the functions
involved in the dump, storing this struct in cb->args[0].
This reduces the memory allocation size as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 210 +++++++++++++++++++++++++++----------------------
 1 file changed, 116 insertions(+), 94 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f8ffb9a..7dc3343 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1111,10 +1111,16 @@ nl80211_send_mgmt_stypes(struct sk_buff *msg,
 	return 0;
 }
 
+struct nl80211_dump_wiphy_state {
+	s64 filter_wiphy;
+	long start;
+	long split_start, band_start, chan_start;
+	bool split;
+};
+
 static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			      struct sk_buff *msg, u32 portid, u32 seq,
-			      int flags, bool split, long *split_start,
-			      long *band_start, long *chan_start)
+			      int flags, struct nl80211_dump_wiphy_state *state)
 {
 	void *hdr;
 	struct nlattr *nl_bands, *nl_band;
@@ -1125,19 +1131,14 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	int i;
 	const struct ieee80211_txrx_stypes *mgmt_stypes =
 				dev->wiphy.mgmt_stypes;
-	long start = 0, start_chan = 0, start_band = 0;
 	u32 features;
 
 	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
 		return -ENOBUFS;
 
-	/* allow always using the variables */
-	if (!split) {
-		split_start = &start;
-		band_start = &start_band;
-		chan_start = &start_chan;
-	}
+	if (WARN_ON(!state))
+		return -EINVAL;
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, dev->wiphy_idx) ||
 	    nla_put_string(msg, NL80211_ATTR_WIPHY_NAME,
@@ -1146,7 +1147,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			cfg80211_rdev_list_generation))
 		goto nla_put_failure;
 
-	switch (*split_start) {
+	switch (state->split_start) {
 	case 0:
 		if (nla_put_u8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT,
 			       dev->wiphy.retry_short) ||
@@ -1192,8 +1193,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		    nla_put_flag(msg, WIPHY_FLAG_SUPPORTS_5_10_MHZ))
 			goto nla_put_failure;
 
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 	case 1:
 		if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
@@ -1237,22 +1238,23 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			}
 		}
 
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 	case 2:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					dev->wiphy.interface_modes))
 				goto nla_put_failure;
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 	case 3:
 		nl_bands = nla_nest_start(msg, NL80211_ATTR_WIPHY_BANDS);
 		if (!nl_bands)
 			goto nla_put_failure;
 
-		for (band = *band_start; band < IEEE80211_NUM_BANDS; band++) {
+		for (band = state->band_start;
+		     band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 
 			sband = dev->wiphy.bands[band];
@@ -1264,12 +1266,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			if (!nl_band)
 				goto nla_put_failure;
 
-			switch (*chan_start) {
+			switch (state->chan_start) {
 			case 0:
 				if (nl80211_send_band_rateinfo(msg, sband))
 					goto nla_put_failure;
-				(*chan_start)++;
-				if (split)
+				state->chan_start++;
+				if (state->split)
 					break;
 			default:
 				/* add frequencies */
@@ -1278,7 +1280,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 				if (!nl_freqs)
 					goto nla_put_failure;
 
-				for (i = *chan_start - 1;
+				for (i = state->chan_start - 1;
 				     i < sband->n_channels;
 				     i++) {
 					nl_freq = nla_nest_start(msg, i);
@@ -1287,26 +1289,27 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 					chan = &sband->channels[i];
 
-					if (nl80211_msg_put_channel(msg, chan,
-								    split))
+					if (nl80211_msg_put_channel(
+							msg, chan,
+							state->split))
 						goto nla_put_failure;
 
 					nla_nest_end(msg, nl_freq);
-					if (split)
+					if (state->split)
 						break;
 				}
 				if (i < sband->n_channels)
-					*chan_start = i + 2;
+					state->chan_start = i + 2;
 				else
-					*chan_start = 0;
+					state->chan_start = 0;
 				nla_nest_end(msg, nl_freqs);
 			}
 
 			nla_nest_end(msg, nl_band);
 
-			if (split) {
+			if (state->split) {
 				/* start again here */
-				if (*chan_start)
+				if (state->chan_start)
 					band--;
 				break;
 			}
@@ -1314,14 +1317,14 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		nla_nest_end(msg, nl_bands);
 
 		if (band < IEEE80211_NUM_BANDS)
-			*band_start = band + 1;
+			state->band_start = band + 1;
 		else
-			*band_start = 0;
+			state->band_start = 0;
 
 		/* if bands & channels are done, continue outside */
-		if (*band_start == 0 && *chan_start == 0)
-			(*split_start)++;
-		if (split)
+		if (state->band_start == 0 && state->chan_start == 0)
+			state->split_start++;
+		if (state->split)
 			break;
 	case 4:
 		nl_cmds = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_COMMANDS);
@@ -1387,7 +1390,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
-		if (split) {
+		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
 		}
@@ -1411,8 +1414,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 
 		nla_nest_end(msg, nl_cmds);
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 	case 5:
 		if (dev->ops->remain_on_channel &&
@@ -1428,29 +1431,30 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 
 		if (nl80211_send_mgmt_stypes(msg, mgmt_stypes))
 			goto nla_put_failure;
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 	case 6:
 #ifdef CONFIG_PM
-		if (nl80211_send_wowlan(msg, dev, split))
+		if (nl80211_send_wowlan(msg, dev, state->split))
 			goto nla_put_failure;
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 #else
-		(*split_start)++;
+		state->split_start++;
 #endif
 	case 7:
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SOFTWARE_IFTYPES,
 					dev->wiphy.software_iftypes))
 			goto nla_put_failure;
 
-		if (nl80211_put_iface_combinations(&dev->wiphy, msg, split))
+		if (nl80211_put_iface_combinations(&dev->wiphy, msg,
+						   state->split))
 			goto nla_put_failure;
 
-		(*split_start)++;
-		if (split)
+		state->split_start++;
+		if (state->split)
 			break;
 	case 8:
 		if ((dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
@@ -1464,7 +1468,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		 * dump is split, otherwise it makes it too big. Therefore
 		 * only advertise it in that case.
 		 */
-		if (split)
+		if (state->split)
 			features |= NL80211_FEATURE_ADVERTISE_CHAN_LIMITS;
 		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS, features))
 			goto nla_put_failure;
@@ -1491,7 +1495,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		 * case we'll continue with more data in the next round,
 		 * but break unconditionally so unsplit data stops here.
 		 */
-		(*split_start)++;
+		state->split_start++;
 		break;
 	case 9:
 		if (dev->wiphy.extended_capabilities &&
@@ -1510,7 +1514,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			goto nla_put_failure;
 
 		/* done */
-		*split_start = 0;
+		state->split_start = 0;
 		break;
 	}
 	return genlmsg_end(msg, hdr);
@@ -1520,66 +1524,76 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	return -EMSGSIZE;
 }
 
+static int nl80211_dump_wiphy_parse(struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    struct nl80211_dump_wiphy_state *state)
+{
+	struct nlattr **tb = nl80211_fam.attrbuf;
+	int ret = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			      tb, nl80211_fam.maxattr, nl80211_policy);
+	/* ignore parse errors for backward compatibility */
+	if (ret)
+		return 0;
+
+	state->split = tb[NL80211_ATTR_SPLIT_WIPHY_DUMP];
+	if (tb[NL80211_ATTR_WIPHY])
+		state->filter_wiphy = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
+	if (tb[NL80211_ATTR_WDEV])
+		state->filter_wiphy = nla_get_u64(tb[NL80211_ATTR_WDEV]) >> 32;
+	if (tb[NL80211_ATTR_IFINDEX]) {
+		struct net_device *netdev;
+		struct cfg80211_registered_device *rdev;
+		int ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
+
+		netdev = dev_get_by_index(sock_net(skb->sk), ifidx);
+		if (!netdev)
+			return -ENODEV;
+		if (netdev->ieee80211_ptr) {
+			rdev = wiphy_to_dev(
+				netdev->ieee80211_ptr->wiphy);
+			state->filter_wiphy = rdev->wiphy_idx;
+		}
+		dev_put(netdev);
+	}
+
+	return 0;
+}
+
 static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int idx = 0, ret;
-	int start = cb->args[0];
+	struct nl80211_dump_wiphy_state *state = (void *)cb->args[0];
 	struct cfg80211_registered_device *dev;
-	s64 filter_wiphy = -1;
-	bool split = false;
-	struct nlattr **tb;
-	int res;
-
-	/* will be zeroed in nlmsg_parse() */
-	tb = kmalloc(sizeof(*tb) * (NL80211_ATTR_MAX + 1), GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
 
 	rtnl_lock();
-	res = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-			  tb, NL80211_ATTR_MAX, nl80211_policy);
-	if (res == 0) {
-		split = tb[NL80211_ATTR_SPLIT_WIPHY_DUMP];
-		if (tb[NL80211_ATTR_WIPHY])
-			filter_wiphy = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
-		if (tb[NL80211_ATTR_WDEV])
-			filter_wiphy = nla_get_u64(tb[NL80211_ATTR_WDEV]) >> 32;
-		if (tb[NL80211_ATTR_IFINDEX]) {
-			struct net_device *netdev;
-			int ifidx = nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
-
-			netdev = dev_get_by_index(sock_net(skb->sk), ifidx);
-			if (!netdev) {
-				rtnl_unlock();
-				kfree(tb);
-				return -ENODEV;
-			}
-			if (netdev->ieee80211_ptr) {
-				dev = wiphy_to_dev(
-					netdev->ieee80211_ptr->wiphy);
-				filter_wiphy = dev->wiphy_idx;
-			}
-			dev_put(netdev);
+	if (!state) {
+		state = kzalloc(sizeof(*state), GFP_KERNEL);
+		if (!state)
+			return -ENOMEM;
+		state->filter_wiphy = -1;
+		ret = nl80211_dump_wiphy_parse(skb, cb, state);
+		if (ret) {
+			kfree(state);
+			rtnl_unlock();
+			return ret;
 		}
+		cb->args[0] = (long)state;
 	}
-	kfree(tb);
 
 	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
 		if (!net_eq(wiphy_net(&dev->wiphy), sock_net(skb->sk)))
 			continue;
-		if (++idx <= start)
+		if (++idx <= state->start)
 			continue;
-		if (filter_wiphy != -1 && dev->wiphy_idx != filter_wiphy)
+		if (state->filter_wiphy != -1 &&
+		    state->filter_wiphy != dev->wiphy_idx)
 			continue;
 		/* attempt to fit multiple wiphy data chunks into the skb */
 		do {
 			ret = nl80211_send_wiphy(dev, skb,
 						 NETLINK_CB(cb->skb).portid,
 						 cb->nlh->nlmsg_seq,
-						 NLM_F_MULTI,
-						 split, &cb->args[1],
-						 &cb->args[2],
-						 &cb->args[3]);
+						 NLM_F_MULTI, state);
 			if (ret < 0) {
 				/*
 				 * If sending the wiphy data didn't fit (ENOBUFS
@@ -1604,27 +1618,34 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 				idx--;
 				break;
 			}
-		} while (cb->args[1] > 0);
+		} while (state->split_start > 0);
 		break;
 	}
 	rtnl_unlock();
 
-	cb->args[0] = idx;
+	state->start = idx;
 
 	return skb->len;
 }
 
+static int nl80211_dump_wiphy_done(struct netlink_callback *cb)
+{
+	kfree((void *)cb->args[0]);
+	return 0;
+}
+
 static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
 	struct cfg80211_registered_device *dev = info->user_ptr[0];
+	struct nl80211_dump_wiphy_state state = {};
 
 	msg = nlmsg_new(4096, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
 	if (nl80211_send_wiphy(dev, msg, info->snd_portid, info->snd_seq, 0,
-			       false, NULL, NULL, NULL) < 0) {
+			       &state) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -8418,6 +8439,7 @@ static struct genl_ops nl80211_ops[] = {
 		.cmd = NL80211_CMD_GET_WIPHY,
 		.doit = nl80211_get_wiphy,
 		.dumpit = nl80211_dump_wiphy,
+		.done = nl80211_dump_wiphy_done,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -9038,13 +9060,13 @@ static struct genl_multicast_group nl80211_regulatory_mcgrp = {
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
 {
 	struct sk_buff *msg;
+	struct nl80211_dump_wiphy_state state = {};
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	if (nl80211_send_wiphy(rdev, msg, 0, 0, 0,
-			       false, NULL, NULL, NULL) < 0) {
+	if (nl80211_send_wiphy(rdev, msg, 0, 0, 0, &state) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
-- 
1.8.0

