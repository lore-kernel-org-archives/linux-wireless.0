Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38809 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab2JQTUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 15:20:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] iw: add lowpri and flush scan operands
Date: Wed, 17 Oct 2012 12:20:04 -0700
Message-Id: <1350501604-25253-1-git-send-email-bzhao@marvell.com> (sfid-20121017_212053_643277_9EBBB3FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add lowpri (low priority) and flush operands to the scan cmd to
request the equivalent flags be set in the scan request. Note
these are applied regardless of the feature flags to support
testing drivers that do not implement them.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: give lowpri/flush flags before ssid (Johannes Berg)

 info.c |    4 ++++
 scan.c |   15 +++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index c4b5de2..799f6d3 100644
--- a/info.c
+++ b/info.c
@@ -444,6 +444,10 @@ broken_combination:
 			printf("\tDevice accepts cell base station regulatory hints.\n");
 		if (features & NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL)
 			printf("\tP2P Device uses a channel (of the concurrent ones)\n");
+		if (features & NL80211_FEATURE_LOW_PRIORITY_SCAN)
+			printf("\tDevice supports low priority scan.\n");
+		if (features & NL80211_FEATURE_SCAN_FLUSH)
+			printf("\tDevice supports scan flush.\n");
 	}
 
 	return NL_SKIP;
diff --git a/scan.c b/scan.c
index bb84a67..ba423c4 100644
--- a/scan.c
+++ b/scan.c
@@ -73,6 +73,7 @@ static int handle_scan(struct nl80211_state *state,
 	bool passive = false, have_ssids = false, have_freqs = false;
 	size_t tmp;
 	unsigned char *ies;
+	int flags = 0;
 
 	ssids = nlmsg_alloc();
 	if (!ssids)
@@ -94,6 +95,14 @@ static int handle_scan(struct nl80211_state *state,
 			} else if (strcmp(argv[i], "ies") == 0) {
 				parse = IES;
 				break;
+			} else if (strcmp(argv[i], "lowpri") == 0) {
+				parse = NONE;
+				flags |= NL80211_SCAN_FLAG_LOW_PRIORITY;
+				break;
+			} else if (strcmp(argv[i], "flush") == 0) {
+				parse = NONE;
+				flags |= NL80211_SCAN_FLAG_FLUSH;
+				break;
 			} else if (strcmp(argv[i], "ssid") == 0) {
 				parse = SSID;
 				have_ssids = true;
@@ -136,6 +145,8 @@ static int handle_scan(struct nl80211_state *state,
 
 	if (have_freqs)
 		nla_put_nested(msg, NL80211_ATTR_SCAN_FREQUENCIES, freqs);
+	if (flags)
+		NLA_PUT_U32(msg, NL80211_ATTR_SCAN_FLAGS, flags);
 
 	err = 0;
  nla_put_failure:
@@ -1344,7 +1355,7 @@ static int handle_scan_combined(struct nl80211_state *state,
 	dump_argv[0] = argv[0];
 	return handle_cmd(state, id, dump_argc, dump_argv);
 }
-TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive]", 0, 0,
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [lowpri|flush] [ssid <ssid>*|passive]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1354,7 +1365,7 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [lowpri|flush] [ssid <ssid>*|passive]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.7.9.5

