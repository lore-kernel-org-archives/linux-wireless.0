Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35673 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208Ab2FHCXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 22:23:22 -0400
Received: by pbbrp8 with SMTP id rp8so1893420pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 19:23:22 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	devel@lists.open80211s.org, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH] iw: Allow basic rates to be configured when joining mesh
Date: Thu,  7 Jun 2012 19:23:05 -0700
Message-Id: <1339122185-23315-1-git-send-email-ashok@cozybit.com> (sfid-20120608_042325_535080_E6CD12B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 mesh.c |   38 +++++++++++++++++++++++++++++++++++---
 1 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/mesh.c b/mesh.c
index f678dc0..76bd6e4 100644
--- a/mesh.c
+++ b/mesh.c
@@ -376,7 +376,10 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
+	unsigned char rates[NL80211_MAX_SUPP_RATES];
+	int n_rates = 0;
 	char *end;
+	char *value = NULL, *sptr = NULL;
 
 	if (argc < 1)
 		return 1;
@@ -385,6 +388,34 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
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
@@ -424,10 +455,11 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>] [vendor_sync on|off]"
-	" [<param>=<value>]*",
+COMMAND(mesh, join, "<mesh ID> [basic-rates <rate in Mbps,rate2,...>]"
+	"[mcast-rate <rate in Mbps>] [vendor_sync on|off] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
-	"Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
+	"Join a mesh with the given mesh ID with basic-rates,"
+	"mcast-rate and mesh parameters.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv)
-- 
1.7.5.4

