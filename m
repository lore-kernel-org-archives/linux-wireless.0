Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40743 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbZEBUHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 16:07:36 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add option to dump unknown IEs with scan command
Date: Sat,  2 May 2009 13:07:24 -0700
Message-Id: <1241294844-27746-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/scan.c b/scan.c
index 48f803a..91e94ed 100644
--- a/scan.c
+++ b/scan.c
@@ -340,12 +340,13 @@ static int handle_scan_combined(struct nl80211_state *state,
 		NULL,
 		"scan",
 		"dump",
+		NULL,
 	};
 	static const __u32 cmds[] = {
 		NL80211_CMD_NEW_SCAN_RESULTS,
 		NL80211_CMD_SCAN_ABORTED,
 	};
-	int err;
+	int dump_argc, err;
 
 	trig_argv[0] = argv[0];
 	err = handle_cmd(state, II_NETDEV, ARRAY_SIZE(trig_argv), trig_argv);
@@ -382,7 +383,13 @@ static int handle_scan_combined(struct nl80211_state *state,
 		return 0;
 	}
 
+	if (argc == 3 && !strcmp(argv[2], "-u")) {
+		dump_argc = 4;
+		dump_argv[3] = "-u";
+	} else
+		dump_argc = 3;
+
 	dump_argv[0] = argv[0];
-	return handle_cmd(state, II_NETDEV, ARRAY_SIZE(dump_argv), dump_argv);
+	return handle_cmd(state, II_NETDEV, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, NULL, 0, 0, CIB_NETDEV, handle_scan_combined);
+TOPLEVEL(scan, "[-u]", 0, 0, CIB_NETDEV, handle_scan_combined);
-- 
1.6.0.6

