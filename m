Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45320 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaISCYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 22:24:52 -0400
Received: by mail-pd0-f172.google.com with SMTP id v10so2665591pde.31
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 19:24:51 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Ashok Nagarajan <ashok.dragon@gmail.com>
Subject: [PATCH v2 1/2] iw: Allow user to provide freq during mesh join
Date: Fri, 19 Sep 2014 10:24:35 +0800
Message-Id: <1411093476-15685-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140919_042456_644339_D0AB075F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow user to configure frequency and channel type during
mesh join command.

Signed-off-by: Ashok Nagarajan <ashok.dragon@gmail.com>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

v2: use chandef similar to IBSS
---
 mesh.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/mesh.c b/mesh.c
index ca065bf..69c54cc 100644
--- a/mesh.c
+++ b/mesh.c
@@ -438,8 +438,32 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
-	int bintval, dtim_period;
+	int bintval, dtim_period, i;
 	char *end;
+	unsigned long freq = 0;
+	static const struct {
+		const char *name;
+		unsigned int width;
+		int freq1_diff;
+		int chantype; /* for older kernel */
+	} *chanmode_selected = NULL, chanmode[] = {
+		{ .name = "HT20",
+		  .width = NL80211_CHAN_WIDTH_20,
+		  .freq1_diff = 0,
+		  .chantype = NL80211_CHAN_HT20 },
+		{ .name = "HT40+",
+		  .width = NL80211_CHAN_WIDTH_40,
+		  .freq1_diff = 10,
+		  .chantype = NL80211_CHAN_HT40PLUS },
+		{ .name = "HT40-",
+		  .width = NL80211_CHAN_WIDTH_40,
+		  .freq1_diff = -10,
+		  .chantype = NL80211_CHAN_HT40MINUS },
+		{ .name = "NOHT",
+		  .width = NL80211_CHAN_WIDTH_20_NOHT,
+		  .freq1_diff = 0,
+		  .chantype = NL80211_CHAN_NO_HT },
+	};
 
 	if (argc < 1)
 		return 1;
@@ -448,6 +472,44 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 	argc--;
 	argv++;
 
+	/* freq */
+	if (argc > 1 && strcmp(argv[0], "freq") == 0) {
+		argv++;
+		argc--;
+
+		freq = strtoul(argv[0], &end, 10);
+		if (*end != '\0')
+			return 1;
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+
+		argv++;
+		argc--;
+	}
+
+	/* channel type */
+	if (argc) {
+		for (i = 0; i < ARRAY_SIZE(chanmode); i++) {
+			if (strcasecmp(chanmode[i].name, argv[0]) == 0) {
+				chanmode_selected = &chanmode[i];
+				break;
+			}
+		}
+
+		if (chanmode_selected) {
+			NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL_WIDTH,
+				    chanmode_selected->width);
+			NLA_PUT_U32(msg, NL80211_ATTR_CENTER_FREQ1,
+				    freq + chanmode_selected->freq1_diff);
+			if (chanmode_selected->chantype != -1)
+				NLA_PUT_U32(msg,
+					    NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+					    chanmode_selected->chantype);
+
+			argv++;
+			argc--;
+		}
+	}
+
 	if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
 		argv++;
 		argc--;
@@ -513,11 +575,13 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
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
+	"Join a mesh with the given mesh ID with frequency, mcast-rate, "
+	"and mesh parameters.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv,
-- 
1.9.2

