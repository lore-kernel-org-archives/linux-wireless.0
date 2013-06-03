Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43971 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3FCRe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:34:26 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so5973160pbc.25
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 10:34:25 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH 1/2] iw: Allow user to provide freq during mesh join
Date: Mon,  3 Jun 2013 10:34:18 -0700
Message-Id: <1370280859-9860-1-git-send-email-ashok@cozybit.com> (sfid-20130603_193429_089368_B1F2BE9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow user to configure frequency and channel type during mesh join command.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 mesh.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/mesh.c b/mesh.c
index 5a09b62..ec202c9 100644
--- a/mesh.c
+++ b/mesh.c
@@ -431,8 +431,18 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
-	int bintval, dtim_period;
+	int bintval, dtim_period, i;
 	char *end;
+	static const struct {
+		const char *name;
+		unsigned int val;
+	} htmap[] = {
+		{ .name = "HT20", .val = NL80211_CHAN_HT20, },
+		{ .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
+		{ .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
+		{ .name = "NOHT", .val = NL80211_CHAN_NO_HT, },
+	};
+	unsigned int htval;
 
 	if (argc < 1)
 		return 1;
@@ -441,6 +451,37 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 	argc--;
 	argv++;
 
+	/* freq */
+	if (argc > 1 && strcmp(argv[0], "freq") == 0) {
+		argv++;
+		argc--;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
+			    strtoul(argv[0], &end, 10));
+		if (*end != '\0')
+			return 1;
+		argv++;
+		argc--;
+
+	}
+
+	/* channel type */
+	if (argc) {
+		for (i = 0; i < ARRAY_SIZE(htmap); i++) {
+			if (strcasecmp(htmap[i].name, argv[0]) == 0) {
+				htval = htmap[i].val;
+				break;
+			}
+		}
+		if (i != ARRAY_SIZE(htmap)) {
+			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				    htval);
+			argv++;
+			argc--;
+		}
+
+	}
+
 	if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
 		argv++;
 		argc--;
@@ -506,11 +547,13 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>]"
+COMMAND(mesh, join, "<mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]"
+	" [mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
-	"Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
+	"Join a mesh with the given mesh ID with freq, mcast-rate, "
+	"and mesh parameters.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv,
-- 
1.7.5.4

