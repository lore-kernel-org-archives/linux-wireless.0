Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62221 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbaIWBPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 21:15:03 -0400
Received: by mail-pa0-f50.google.com with SMTP id rd3so4311870pab.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 18:15:03 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Ashok Nagarajan <ashok.dragon@gmail.com>
Subject: [PATCH v4 2/2] iw: Allow basic rates to be configured when joining mesh
Date: Tue, 23 Sep 2014 09:14:49 +0800
Message-Id: <1411434889-1456-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20140923_031745_204709_0C35955B)
In-Reply-To: <1411434889-1456-1-git-send-email-yeohchunyeow@gmail.com>
References: <1411434889-1456-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds option to configure basic rates during mesh join.

Signed-off-by: Ashok Nagarajan <ashok.dragon@gmail.com>
Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

v2: minor change for upstream
v3: fix typo error (Colleen)
---
 mesh.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/mesh.c b/mesh.c
index 570b4d3..8d69fca 100644
--- a/mesh.c
+++ b/mesh.c
@@ -438,8 +438,9 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
-	int bintval, dtim_period, i;
-	char *end;
+	unsigned char rates[NL80211_MAX_SUPP_RATES];
+	int bintval, dtim_period, i, n_rates = 0;
+	char *end, *value = NULL, *sptr = NULL;
 	unsigned long freq = 0;
 	static const struct {
 		const char *name;
@@ -510,6 +511,32 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		}
 	}
 
+	/* basic rates */
+	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
+		argv++;
+		argc--;
+
+		value = strtok_r(argv[0], ",", &sptr);
+
+		while (value && n_rates < NL80211_MAX_SUPP_RATES) {
+			rate = strtod(value, &end);
+			rates[n_rates] = rate * 2;
+
+			/* filter out suspicious values  */
+			if (*end != '\0' || !rates[n_rates] ||
+			    rate*2 != rates[n_rates])
+				return 1;
+
+			n_rates++;
+			value = strtok_r(NULL, ",", &sptr);
+		}
+
+		NLA_PUT(msg, NL80211_ATTR_BSS_BASIC_RATES, n_rates, rates);
+		argv++;
+		argc--;
+	}
+
+	/* multicast rate */
 	if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
 		argv++;
 		argc--;
@@ -575,13 +602,14 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
-	" [mcast-rate <rate in Mbps>]"
+COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
+	" [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
-	"Join a mesh with the given mesh ID with frequency, mcast-rate, "
-	"and mesh parameters.");
+	"Join a mesh with the given mesh ID with frequency, basic-rates,\n"
+	"mcast-rate and mesh parameters. Basic-rates are applied only if\n"
+	"frequency is provided.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv,
-- 
1.9.2

