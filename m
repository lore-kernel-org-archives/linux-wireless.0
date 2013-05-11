Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54541 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3EKAwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 20:52:10 -0400
Received: by mail-pb0-f51.google.com with SMTP id wy7so3129587pbc.10
        for <linux-wireless@vger.kernel.org>; Fri, 10 May 2013 17:52:09 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, ashok@cozybit.com
Subject: [PATCH] iw: Allow basic rates to be configured when joining mesh
Date: Fri, 10 May 2013 17:52:01 -0700
Message-Id: <1368233521-10642-1-git-send-email-ashok@cozybit.com> (sfid-20130511_025212_850847_B0DB1601)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds option to configure basic rates during mesh join

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 mesh.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/mesh.c b/mesh.c
index 5a09b62..c6aa9ce 100644
--- a/mesh.c
+++ b/mesh.c
@@ -431,8 +431,11 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
+	unsigned char rates[NL80211_MAX_SUPP_RATES];
+	int n_rates = 0;
 	int bintval, dtim_period;
 	char *end;
+	char *value = NULL, *sptr = NULL;
 
 	if (argc < 1)
 		return 1;
@@ -441,6 +444,34 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 	argc--;
 	argv++;
 
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
@@ -506,11 +537,13 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>]"
+COMMAND(mesh, join, "<mesh ID> [basic-rates <rate in Mbps,rate2,...>]"
+	"[mcast-rate <rate in Mbps>]"
 	" [beacon-interval <time in TUs>] [dtim-period <value>]"
 	" [vendor_sync on|off] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
-	"Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
+	"Join a mesh with the given mesh ID with basic-rates, "
+	"mcast-rate and mesh parameters.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv,
-- 
1.7.5.4

