Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62684 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3FCRe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:34:28 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so6025399pbb.13
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 10:34:27 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH 2/2] iw: Allow basic rates to be configured when joining mesh
Date: Mon,  3 Jun 2013 10:34:19 -0700
Message-Id: <1370280859-9860-2-git-send-email-ashok@cozybit.com> (sfid-20130603_193431_389103_8CBFC1B9)
In-Reply-To: <1370280859-9860-1-git-send-email-ashok@cozybit.com>
References: <1370280859-9860-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds option to configure basic rates during mesh join. basic-rates
has to be passed along with "freq" attribute. For instance:

iw $MESH_IFACE mesh join mymeshid freq 2437 basic-rates 5.5,11

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 mesh.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/mesh.c b/mesh.c
index ec202c9..f7c4c35 100644
--- a/mesh.c
+++ b/mesh.c
@@ -431,8 +431,9 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
-	int bintval, dtim_period, i;
-	char *end;
+	unsigned char rates[NL80211_MAX_SUPP_RATES];
+	int bintval, dtim_period, i, n_rates = 0;
+	char *end, *value = NULL, *sptr = NULL;
 	static const struct {
 		const char *name;
 		unsigned int val;
@@ -482,6 +483,34 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 
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
+
+		argv++;
+		argc--;
+	}
+
+	/* multicast rate */
+
 	if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
 		argv++;
 		argc--;
@@ -547,13 +576,14 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]"
-	" [mcast-rate <rate in Mbps>]"
+COMMAND(mesh, join, "<mesh ID> [freq in MHz [HT20|HT40+|HT40-|NOHT]"
+	" [basic-rates <rate in Mbps,rate2,...>]], [mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
-	"Join a mesh with the given mesh ID with freq, mcast-rate, "
-	"and mesh parameters.");
+	"Join a mesh with the given mesh ID with frequency, basic-rates,\n"
+	"mcast-rate and mesh parameters. basic-rates are be applied only if\n"
+	"frequency is provided.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv,
-- 
1.7.5.4

