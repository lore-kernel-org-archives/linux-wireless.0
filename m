Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50392 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbcJZJpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 05:45:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: move unsplit command advertising to a separate function
Date: Wed, 26 Oct 2016 11:44:56 +0200
Message-Id: <1477475096-798-1-git-send-email-johannes@sipsolutions.net> (sfid-20161026_114600_463358_94185C5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we split the wiphy dump because it got too large, I added a
comment and asked that all new command advertising be done only
for userspace clients capable of receiving split data, in order
to not break older ones (which can't use the new commands anyway)

This mostly worked, and we haven't added many new commands, but
I occasionally get patches that modify the wrong place.

Make this easier to detect and understand by splitting out the
old commands to a separate function that makes it more clear it
should never be modified again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 142 +++++++++++++++++++++++++++----------------------
 1 file changed, 79 insertions(+), 63 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46cd48993ce9..b0440de82171 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1328,6 +1328,82 @@ nl80211_send_mgmt_stypes(struct sk_buff *msg,
 	return 0;
 }
 
+#define CMD(op, n)							\
+	 do {								\
+		if (rdev->ops->op) {					\
+			i++;						\
+			if (nla_put_u32(msg, i, NL80211_CMD_ ## n)) 	\
+				goto nla_put_failure;			\
+		}							\
+	} while (0)
+
+static int nl80211_add_commands_unsplit(struct cfg80211_registered_device *rdev,
+					struct sk_buff *msg)
+{
+	int i = 0;
+
+	/*
+	 * do *NOT* add anything into this function, new things need to be
+	 * advertised only to new versions of userspace that can deal with
+	 * the split (and they can't possibly care about new features...
+	 */
+	CMD(add_virtual_intf, NEW_INTERFACE);
+	CMD(change_virtual_intf, SET_INTERFACE);
+	CMD(add_key, NEW_KEY);
+	CMD(start_ap, START_AP);
+	CMD(add_station, NEW_STATION);
+	CMD(add_mpath, NEW_MPATH);
+	CMD(update_mesh_config, SET_MESH_CONFIG);
+	CMD(change_bss, SET_BSS);
+	CMD(auth, AUTHENTICATE);
+	CMD(assoc, ASSOCIATE);
+	CMD(deauth, DEAUTHENTICATE);
+	CMD(disassoc, DISASSOCIATE);
+	CMD(join_ibss, JOIN_IBSS);
+	CMD(join_mesh, JOIN_MESH);
+	CMD(set_pmksa, SET_PMKSA);
+	CMD(del_pmksa, DEL_PMKSA);
+	CMD(flush_pmksa, FLUSH_PMKSA);
+	if (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL)
+		CMD(remain_on_channel, REMAIN_ON_CHANNEL);
+	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
+	CMD(mgmt_tx, FRAME);
+	CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
+	if (rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
+		i++;
+		if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
+			goto nla_put_failure;
+	}
+	if (rdev->ops->set_monitor_channel || rdev->ops->start_ap ||
+	    rdev->ops->join_mesh) {
+		i++;
+		if (nla_put_u32(msg, i, NL80211_CMD_SET_CHANNEL))
+			goto nla_put_failure;
+	}
+	CMD(set_wds_peer, SET_WDS_PEER);
+	if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+		CMD(tdls_mgmt, TDLS_MGMT);
+		CMD(tdls_oper, TDLS_OPER);
+	}
+	if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+		CMD(sched_scan_start, START_SCHED_SCAN);
+	CMD(probe_client, PROBE_CLIENT);
+	CMD(set_noack_map, SET_NOACK_MAP);
+	if (rdev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS) {
+		i++;
+		if (nla_put_u32(msg, i, NL80211_CMD_REGISTER_BEACONS))
+			goto nla_put_failure;
+	}
+	CMD(start_p2p_device, START_P2P_DEVICE);
+	CMD(set_mcast_rate, SET_MCAST_RATE);
+#ifdef CONFIG_NL80211_TESTMODE
+	CMD(testmode_cmd, TESTMODE);
+#endif
+	return i;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
 struct nl80211_dump_wiphy_state {
 	s64 filter_wiphy;
 	long start;
@@ -1555,68 +1631,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if (!nl_cmds)
 			goto nla_put_failure;
 
-		i = 0;
-#define CMD(op, n)							\
-		 do {							\
-			if (rdev->ops->op) {				\
-				i++;					\
-				if (nla_put_u32(msg, i, NL80211_CMD_ ## n)) \
-					goto nla_put_failure;		\
-			}						\
-		} while (0)
-
-		CMD(add_virtual_intf, NEW_INTERFACE);
-		CMD(change_virtual_intf, SET_INTERFACE);
-		CMD(add_key, NEW_KEY);
-		CMD(start_ap, START_AP);
-		CMD(add_station, NEW_STATION);
-		CMD(add_mpath, NEW_MPATH);
-		CMD(update_mesh_config, SET_MESH_CONFIG);
-		CMD(change_bss, SET_BSS);
-		CMD(auth, AUTHENTICATE);
-		CMD(assoc, ASSOCIATE);
-		CMD(deauth, DEAUTHENTICATE);
-		CMD(disassoc, DISASSOCIATE);
-		CMD(join_ibss, JOIN_IBSS);
-		CMD(join_mesh, JOIN_MESH);
-		CMD(set_pmksa, SET_PMKSA);
-		CMD(del_pmksa, DEL_PMKSA);
-		CMD(flush_pmksa, FLUSH_PMKSA);
-		if (rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL)
-			CMD(remain_on_channel, REMAIN_ON_CHANNEL);
-		CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
-		CMD(mgmt_tx, FRAME);
-		CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
-		if (rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
-			i++;
-			if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
-				goto nla_put_failure;
-		}
-		if (rdev->ops->set_monitor_channel || rdev->ops->start_ap ||
-		    rdev->ops->join_mesh) {
-			i++;
-			if (nla_put_u32(msg, i, NL80211_CMD_SET_CHANNEL))
-				goto nla_put_failure;
-		}
-		CMD(set_wds_peer, SET_WDS_PEER);
-		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
-			CMD(tdls_mgmt, TDLS_MGMT);
-			CMD(tdls_oper, TDLS_OPER);
-		}
-		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
-			CMD(sched_scan_start, START_SCHED_SCAN);
-		CMD(probe_client, PROBE_CLIENT);
-		CMD(set_noack_map, SET_NOACK_MAP);
-		if (rdev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS) {
-			i++;
-			if (nla_put_u32(msg, i, NL80211_CMD_REGISTER_BEACONS))
-				goto nla_put_failure;
-		}
-		CMD(start_p2p_device, START_P2P_DEVICE);
-		CMD(set_mcast_rate, SET_MCAST_RATE);
-#ifdef CONFIG_NL80211_TESTMODE
-		CMD(testmode_cmd, TESTMODE);
-#endif
+		i = nl80211_add_commands_unsplit(rdev, msg);
+		if (i < 0)
+			goto nla_put_failure;
 		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
@@ -1627,7 +1644,6 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 					NL80211_FEATURE_SUPPORTS_WMM_ADMISSION)
 				CMD(add_tx_ts, ADD_TX_TS);
 		}
-		/* add into the if now */
 #undef CMD
 
 		if (rdev->ops->connect || rdev->ops->auth) {
-- 
2.8.1
