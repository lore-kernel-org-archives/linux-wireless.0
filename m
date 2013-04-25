Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:35996 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3DYWCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 18:02:31 -0400
Received: by mail-da0-f41.google.com with SMTP id p8so45485dan.14
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2013 15:02:30 -0700 (PDT)
From: Jacob Minshall <jacob@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: scan using meshid
Date: Thu, 25 Apr 2013 15:02:19 -0700
Message-Id: <1366927339-4870-1-git-send-email-jacob@cozybit.com> (sfid-20130426_000235_438296_1812FA2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: jacob minshall <jacob@cozybit.com>

This patch adds the ability to perform a directed scan
for MBSSs matching meshid by

iw <dev> scan meshid <meshid>

Signed-off-by: jacob minshall <jacob@cozybit.com>
---
 scan.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/scan.c b/scan.c
index 1842655..6d770d3 100644
--- a/scan.c
+++ b/scan.c
@@ -85,12 +85,13 @@ static int handle_scan(struct nl80211_state *state,
 		FREQ,
 		IES,
 		SSID,
+		MESHID,
 		DONE,
 	} parse = NONE;
 	int freq;
 	bool passive = false, have_ssids = false, have_freqs = false;
-	size_t tmp;
-	unsigned char *ies;
+	size_t ies_len = 0, meshid_len = 0;
+	unsigned char *ies = NULL, *meshid = NULL, *tmpies;
 	int flags = 0;
 
 	ssids = nlmsg_alloc();
@@ -133,6 +134,9 @@ static int handle_scan(struct nl80211_state *state,
 				parse = DONE;
 				passive = true;
 				break;
+			} else if (strcmp(argv[i], "meshid") == 0) {
+				parse = MESHID;
+				break;
 			}
 		case DONE:
 			return 1;
@@ -147,17 +151,42 @@ static int handle_scan(struct nl80211_state *state,
 			NLA_PUT_U32(freqs, i, freq);
 			break;
 		case IES:
-			ies = parse_hex(argv[i], &tmp);
+			ies = parse_hex(argv[i], &ies_len);
 			if (!ies)
 				goto nla_put_failure;
-			NLA_PUT(msg, NL80211_ATTR_IE, tmp, ies);
-			free(ies);
 			parse = NONE;
 			break;
 		case SSID:
 			NLA_PUT(ssids, i, strlen(argv[i]), argv[i]);
 			break;
+		case MESHID:
+			meshid_len = strlen(argv[i]);
+			meshid = (unsigned char *) malloc(meshid_len + 2);
+			if (!meshid)
+				goto nla_put_failure;
+			meshid[0] = 114; /* mesh element id */
+			meshid[1] = meshid_len;
+			memcpy(&meshid[2], argv[i], meshid_len);
+			meshid_len += 2;
+			parse = NONE;
+			break;
+		}
+	}
+
+	if (ies || meshid) {
+		tmpies = (unsigned char *) malloc(ies_len + meshid_len);
+		if (!tmpies)
+			goto nla_put_failure;
+		if (ies) {
+			memcpy(tmpies, ies, ies_len);
+			free(ies);
+		}
+		if (meshid) {
+			memcpy(&tmpies[ies_len], meshid, meshid_len);
+			free(meshid);
 		}
+		NLA_PUT(msg, NL80211_ATTR_IE, ies_len + meshid_len, tmpies);
+		free(tmpies);
 	}
 
 	if (!have_ssids)
@@ -1535,7 +1564,7 @@ static int handle_scan_combined(struct nl80211_state *state,
 	dump_argv[0] = argv[0];
 	return handle_cmd(state, id, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]", 0, 0,
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1545,7 +1574,7 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [ssid <ssid>*|passive]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.8.1.2

