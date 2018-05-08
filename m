Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932204AbeEHRUi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 13:20:38 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH] iw: Add duration parameter to scan command 
Date: Tue,  8 May 2018 10:20:30 -0700
Message-Id: <1525800030-19322-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180508_192042_783043_7D5CD309)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch lets user to specify duration(TUs) and set duration-mandatory
flag in scan command.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---

 scan.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/scan.c b/scan.c
index 74ccc06..3e9daef 100644
--- a/scan.c
+++ b/scan.c
@@ -411,10 +411,13 @@ static int handle_scan(struct nl80211_state *state,
 		IES,
 		SSID,
 		MESHID,
+		DURATION,
 		DONE,
 	} parse = NONE;
 	int freq;
+	unsigned int duration = 0;
 	bool passive = false, have_ssids = false, have_freqs = false;
+	bool duration_mandatory = false;
 	size_t ies_len = 0, meshid_len = 0;
 	unsigned char *ies = NULL, *meshid = NULL, *tmpies;
 	unsigned int flags = 0;
@@ -448,6 +451,9 @@ static int handle_scan(struct nl80211_state *state,
 			} else if (strcmp(argv[i], "ap-force") == 0) {
 				flags |= NL80211_SCAN_FLAG_AP;
 				break;
+			} else if (strcmp(argv[i], "duration-mandatory") == 0) {
+				duration_mandatory = true;
+				break;
 			} else if (strncmp(argv[i], "randomise", 9) == 0 ||
 				   strncmp(argv[i], "randomize", 9) == 0) {
 				flags |= NL80211_SCAN_FLAG_RANDOM_ADDR;
@@ -466,6 +472,9 @@ static int handle_scan(struct nl80211_state *state,
 			} else if (strcmp(argv[i], "meshid") == 0) {
 				parse = MESHID;
 				break;
+			} else if (strcmp(argv[i], "duration") == 0) {
+				parse = DURATION;
+				break;
 			}
 		case DONE:
 			nlmsg_free(ssids);
@@ -501,6 +510,10 @@ static int handle_scan(struct nl80211_state *state,
 			meshid_len += 2;
 			parse = NONE;
 			break;
+		case DURATION:
+			duration = strtoul(argv[i], &eptr, 10);
+			parse = NONE;
+			break;
 		}
 	}
 
@@ -535,6 +548,17 @@ static int handle_scan(struct nl80211_state *state,
 		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
 	if (flags)
 		NLA_PUT_U32(msg, NL80211_ATTR_SCAN_FLAGS, flags);
+	if (duration)
+		NLA_PUT_U16(msg, NL80211_ATTR_MEASUREMENT_DURATION, duration);
+	if (duration_mandatory) {
+		if (duration) {
+			NLA_PUT_FLAG(msg,
+				     NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY);
+		} else {
+			err = -EINVAL;
+			goto nla_put_failure;
+		}
+	}
 
 	err = 0;
  nla_put_failure:
@@ -2275,7 +2299,7 @@ static int handle_scan_combined(struct nl80211_state *state,
 	dump_argv[0] = argv[0];
 	return handle_cmd(state, id, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [randomise[=<addr>/<mask>]] [ssid <ssid>*|passive]", 0, 0,
+TOPLEVEL(scan, "[-u] [freq <freq>*] [duration <dur>] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force,duration-mandatory] [randomise[=<addr>/<mask>]] [ssid <ssid>*|passive]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -2285,10 +2309,11 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force] [randomise[=<addr>/<mask>]] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [duration <dur>] [ies <hex as 00:11:..>] [meshid <meshid>] [lowpri,flush,ap-force,duration-mandatory] [randomise[=<addr>/<mask>]] [ssid <ssid>*|passive]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
-	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
+	 "SSIDs (or wildcard if not given) unless passive scanning is requested.\n"
+	 "Duration(in TUs), if specified, will be used to set dwell times.\n");
 
 
 static int handle_scan_abort(struct nl80211_state *state,
-- 
1.9.1
