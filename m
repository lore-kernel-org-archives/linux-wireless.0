Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:54840 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2JZOma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:42:30 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 2/2] iw: add support for the forced AP scan
Date: Fri, 26 Oct 2012 16:41:48 +0200
Message-Id: <1351262508-23386-2-git-send-email-ordex@autistici.org> (sfid-20121026_164249_646055_D73D2FE3)
In-Reply-To: <1351262508-23386-1-git-send-email-ordex@autistici.org>
References: <1351262508-23386-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces the "ap-force" argument to the scan command.
This argument instructs mac80211 to trigger the scan even if the
interface is configured as AP and has already started beaconing (the
driver may not support such operation)

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 scan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/scan.c b/scan.c
index 91984e5..73fb3fe 100644
--- a/scan.c
+++ b/scan.c
@@ -103,6 +103,10 @@ static int handle_scan(struct nl80211_state *state,
 				parse = NONE;
 				flags |= NL80211_SCAN_FLAG_FLUSH;
 				break;
+			} else if (strcmp(argv[i], "ap-force") == 0) {
+				parse = NONE;
+				flags |= NL80211_SCAN_FLAG_AP;
+				break;
 			} else if (strcmp(argv[i], "ssid") == 0) {
 				parse = SSID;
 				have_ssids = true;
@@ -1355,7 +1359,7 @@ static int handle_scan_combined(struct nl80211_state *state,
 	dump_argv[0] = argv[0];
 	return handle_cmd(state, id, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush] [ssid <ssid>*|passive]", 0, 0,
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1365,7 +1369,7 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.7.12.4

