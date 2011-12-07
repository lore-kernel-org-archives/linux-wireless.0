Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46081 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab1LGVEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 16:04:21 -0500
Received: by qcqz2 with SMTP id z2so796584qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 13:04:21 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] Support mcast-rate in Mesh Node
Date: Wed,  7 Dec 2011 13:04:15 -0800
Message-Id: <1323291855-8418-1-git-send-email-thomas@cozybit.com> (sfid-20111207_220425_440511_963886CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 mesh.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/mesh.c b/mesh.c
index dc8f49c..bdd5d1d 100644
--- a/mesh.c
+++ b/mesh.c
@@ -342,6 +342,9 @@ COMMAND(get, mesh_param, "[<param>]",
 static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		     struct nl_msg *msg, int argc, char **argv)
 {
+	float rate = 0;
+	char *end;
+
 	if (argc < 1)
 		return 1;
 
@@ -349,15 +352,34 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 	argc--;
 	argv++;
 
+	if (argc) {
+		if (strcmp(argv[0], "mcast-rate") == 0) {
+			argc--;
+			argv++;
+
+			rate = strtod(argv[0], &end);
+			if (*end != '\0')
+				return 0;
+
+			if (rate)
+				NLA_PUT_U32(msg, NL80211_ATTR_MCAST_RATE,
+						(int)(rate * 10));
+
+				argv++;
+				argc--;
+		}
+	}
+
 	if (!argc)
 		return 0;
+
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

