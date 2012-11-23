Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:42072 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2KWUxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:53:25 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 1/4] iw: add beacon interval and DTIM period parameters to mesh join
Date: Fri, 23 Nov 2012 12:53:11 -0800
Message-Id: <1353703994-13093-2-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_215336_512246_EE8668D7)
In-Reply-To: <1353703994-13093-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353703994-13093-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the beacon interval and DTIM period with the mesh join command:
iw <dev> mesh join <meshid> beacon-interval <time in TUs> dtim-period <value>

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 mesh.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/mesh.c b/mesh.c
index 4fdad6a..958c2c0 100644
--- a/mesh.c
+++ b/mesh.c
@@ -383,6 +383,7 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 {
 	struct nlattr *container;
 	float rate;
+	int bintval, dtim_period;
 	char *end;
 
 	if (argc < 1)
@@ -405,6 +406,32 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		argc--;
 	}
 
+	if (argc > 1 && strcmp(argv[0], "beacon-interval") == 0) {
+		argc--;
+		argv++;
+
+		bintval = strtoul(argv[0], &end, 10);
+		if (*end != '\0')
+			return 1;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_BEACON_INTERVAL, bintval);
+		argv++;
+		argc--;
+	}
+
+	if (argc > 1 && strcmp(argv[0], "dtim-period") == 0) {
+		argc--;
+		argv++;
+
+		dtim_period = strtoul(argv[0], &end, 10);
+		if (*end != '\0')
+			return 1;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_DTIM_PERIOD, dtim_period);
+		argv++;
+		argc--;
+	}
+
 	container = nla_nest_start(msg, NL80211_ATTR_MESH_SETUP);
 	if (!container)
 		return -ENOBUFS;
@@ -431,8 +458,9 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>] [vendor_sync on|off]"
-	" [<param>=<value>]*",
+COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>]"
+	" [beacon-interval <time in TUs>] [dtim-period <value>]"
+	" [vendor_sync on|off] [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
 	"Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
 
-- 
1.7.9.5

