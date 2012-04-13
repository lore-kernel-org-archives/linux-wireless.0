Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35869 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762796Ab2DMApU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 20:45:20 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so2987275pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 17:45:20 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: javier@cozybit.com, marco.porsch@etit.tu-chemnitz.de,
	devel@lists.open80211s.org, Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 2/2] iw: allow user to enable vendor synchronization when joining mesh
Date: Thu, 12 Apr 2012 17:45:13 -0700
Message-Id: <1334277913-13959-2-git-send-email-ashok@cozybit.com> (sfid-20120413_024533_954762_6AEDDF2A)
In-Reply-To: <1334277913-13959-1-git-send-email-ashok@cozybit.com>
References: <1334277913-13959-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently this option just disables the default neighbor offset
synchronization method. It is useful for testing.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 mesh.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/mesh.c b/mesh.c
index 12147a2..4a3c29e 100644
--- a/mesh.c
+++ b/mesh.c
@@ -352,6 +352,7 @@ COMMAND(get, mesh_param, "[<param>]",
 static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		     struct nl_msg *msg, int argc, char **argv)
 {
+	struct nlattr *container;
 	float rate;
 	char *end;
 
@@ -375,13 +376,34 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
 		argc--;
 	}
 
+	container = nla_nest_start(msg, NL80211_ATTR_MESH_SETUP);
+	if (!container)
+		return -ENOBUFS;
+
+	if (argc > 1 && strcmp(argv[0], "vendor_sync") == 0) {
+		argv++;
+		argc--;
+		if (strcmp(argv[0], "on") == 0)
+			NLA_PUT_U8(msg,
+				   NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC, 1);
+		else
+			NLA_PUT_U8(msg,
+				   NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC, 0);
+		argv++;
+		argc--;
+	}
+	/* parse and put other NL80211_ATTR_MESH_SETUP elements here */
+
+	nla_nest_end(msg, container);
+
 	if (!argc)
 		return 0;
 	return set_interface_meshparam(state, cb, msg, argc, argv);
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>] [<param>=<value>]*",
+COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>] [vendor_sync on|off]"
+	" [<param>=<value>]*",
 	NL80211_CMD_JOIN_MESH, 0, CIB_NETDEV, join_mesh,
 	"Join a mesh with the given mesh ID with mcast-rate and mesh parameters.");
 
-- 
1.7.5.4

