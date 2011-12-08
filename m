Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61103 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1LHSZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 13:25:22 -0500
Received: by iakc1 with SMTP id c1so2912957iak.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 10:25:21 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2] iw: allow setting mesh mcast-rate
Date: Thu,  8 Dec 2011 10:25:15 -0800
Message-Id: <1323368715-6473-1-git-send-email-thomas@cozybit.com> (sfid-20111208_192530_632509_8508CF3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2: style and weirdness (Johannes)
 mesh.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/mesh.c b/mesh.c
index dc8f49c..37fd1cd 100644
--- a/mesh.c
+++ b/mesh.c
@@ -342,6 +342,9 @@ COMMAND(get, mesh_param, "[<param>]",
 static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		     struct nl_msg *msg, int argc, char **argv)
 {
+	float rate;
+	char *end;
+
 	if (argc < 1)
 		return 1;
 
@@ -349,15 +352,28 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 	argc--;
 	argv++;
 
+	if (argc > 1 && strcmp(argv[0], "mcast-rate") == 0) {
+		argv++;
+		argc--;
+
+		rate = strtod(argv[0], &end);
+		if (*end != '\0')
+			return 1;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE, (int)(rate * 10));
+		argv++;
+		argc--;
+	}
+
 	if (!argc)
 		return 0;
 	return set_interface_meshparam(state, cb, msg, argc, argv);
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [<param>=<value>]*",
+COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
-	"Join a mesh with the given mesh ID and mesh parameters.");
+	"Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
 
 static int leave_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		      struct nl_msg *msg, int argc, char **argv)
-- 
1.7.5.4

