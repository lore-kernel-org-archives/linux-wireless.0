Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36824 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753107AbcKGO75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:59:57 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 7/8] Add flag for DFS handling in IBSS
Date: Mon,  7 Nov 2016 15:59:42 +0100
Message-Id: <20161107145943.16761-8-benjamin@sipsolutions.net> (sfid-20161107_160002_894217_8D285352)
In-Reply-To: <20161107145943.16761-1-benjamin@sipsolutions.net>
References: <20161107145943.16761-1-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <sw@simonwunderlich.de>

When Userspace is capable of handling DFS, it can inform the kernel
about that by sending the NL80211_ATTR_HANDLE_DFS attribute when joining
an IBSS. DFS channels will then be unlocked.

Note that this flag is only added for debugging purposes and therefore
hidden from the user by prefixing with __ and not documenting it.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 ibss.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ibss.c b/ibss.c
index 84f1e95..7087cc9 100644
--- a/ibss.c
+++ b/ibss.c
@@ -47,6 +47,12 @@ static int join_ibss(struct nl80211_state *state,
 		argc--;
 	}
 
+	if (argc && strcmp(argv[0], "__dfs-enable") == 0) {
+		NLA_PUT_FLAG(msg, NL80211_ATTR_HANDLE_DFS);
+		argv++;
+		argc--;
+	}
+
 	if (argc) {
 		if (mac_addr_a2n(abssid, argv[0]) == 0) {
 			NLA_PUT(msg, NL80211_ATTR_MAC, 6, abssid);
-- 
2.10.2
