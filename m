Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36818 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932290AbcKGO75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:59:57 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 6/8] Add commands to send CSA
Date: Mon,  7 Nov 2016 15:59:41 +0100
Message-Id: <20161107145943.16761-7-benjamin@sipsolutions.net> (sfid-20161107_160004_083166_43506BF0)
In-Reply-To: <20161107145943.16761-1-benjamin@sipsolutions.net>
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Add a new set of commands to send a CSA. Both the number of beacons and the
flag to block TX can be given optionally.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 interface.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 iw.h        |  1 +
 2 files changed, 73 insertions(+)

diff --git a/interface.c b/interface.c
index 57dd3c3..1c9ebfb 100644
--- a/interface.c
+++ b/interface.c
@@ -644,3 +644,75 @@ nla_put_failure:
 COMMAND(set, mcast_rate, "<rate in Mbps>",
 	NL80211_CMD_SET_MCAST_RATE, 0, CIB_NETDEV, set_mcast_rate,
 	"Set the multicast bitrate.");
+
+
+static int handle_chanfreq(struct nl80211_state *state, struct nl_msg *msg,
+			   bool chan, int argc, char **argv,
+			   enum id_input id)
+{
+	struct chandef chandef;
+	int res;
+	int parsed;
+	char *end;
+
+	res = parse_freqchan(&chandef, chan, argc, argv, &parsed);
+	if (res)
+		return res;
+
+	argc -= parsed;
+	argv += parsed;
+
+	while (argc) {
+		unsigned int beacons = 10;
+
+		if (strcmp(argv[0], "beacons") == 0) {
+			if (argc < 2)
+				return 1;
+
+			beacons = strtol(argv[1], &end, 10);
+			if (*end)
+				return 1;
+
+			argc -= 2;
+			argv += 2;
+
+			NLA_PUT_U32(msg, NL80211_ATTR_CH_SWITCH_COUNT, beacons);
+		} else if (strcmp(argv[0], "block-tx") == 0) {
+			argc -= 1;
+			argv += 1;
+
+			NLA_PUT_FLAG(msg, NL80211_ATTR_CH_SWITCH_BLOCK_TX);
+		} else {
+			return 1;
+		}
+	}
+
+	return put_chandef(msg, &chandef);
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int handle_freq(struct nl80211_state *state, struct nl_msg *msg,
+		       int argc, char **argv,
+		       enum id_input id)
+{
+	return handle_chanfreq(state, msg, false, argc, argv, id);
+}
+
+static int handle_chan(struct nl80211_state *state, struct nl_msg *msg,
+		       int argc, char **argv,
+		       enum id_input id)
+{
+	return handle_chanfreq(state, msg, true, argc, argv, id);
+}
+
+SECTION(switch);
+COMMAND(switch, freq,
+	"<freq> [NOHT|HT20|HT40+|HT40-|5MHz|10MHz|80MHz] [beacons <count>] [block-tx]\n"
+	"<control freq> [5|10|20|40|80|80+80|160] [<center1_freq> [<center2_freq>]] [beacons <count>] [block-tx]",
+	NL80211_CMD_CHANNEL_SWITCH, 0, CIB_NETDEV, handle_freq,
+	"Switch the operating channel by sending a channel switch announcement (CSA).");
+COMMAND(switch, channel, "<channel> [NOHT|HT20|HT40+|HT40-|5MHz|10MHz|80MHz] [beacons <count>] [block-tx]",
+	NL80211_CMD_CHANNEL_SWITCH, 0, CIB_NETDEV, handle_chan, NULL);
+
diff --git a/iw.h b/iw.h
index 7d56391..0857baf 100644
--- a/iw.h
+++ b/iw.h
@@ -202,6 +202,7 @@ int get_cf1(const struct chanmode *chanmode, unsigned long freq);
 	"[randomise[=<addr>/<mask>]]"
 int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv);
 
+DECLARE_SECTION(switch);
 DECLARE_SECTION(set);
 DECLARE_SECTION(get);
 
-- 
2.10.2
