Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52965 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab2IZS1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 14:27:51 -0400
Received: by ggnq2 with SMTP id q2so104346ggn.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 11:27:51 -0700 (PDT)
From: Sam Leffler <sleffler@chromium.org>
Date: Wed, 26 Sep 2012 11:24:49 -0700
Subject: [PATCH] iw: add txabort and flush scan operands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120926182750.46A011E055E@sleffler.sfo.corp.google.com> (sfid-20120926_202755_524251_C74E69E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add txabort and flush operands to the scan cmd to request the equivalent
flags be set in the scan request.
---
 nl80211.h |   16 ++++++++++++++++
 scan.c    |   16 ++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 2f38788..b9d3afd 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1506,6 +1506,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_SCAN_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3023,4 +3025,18 @@ enum nl80211_probe_resp_offload_support_attr {
 	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
 };
 
+/**
+ * enum nl80211_scan_flags -  scan request control flags
+ *
+ * Scan request control flags are used to control the handling
+ * of NL80211_CMD_TRIGGER_SCAN, requests.
+ *
+ * @NL80211_SCAN_FLAG_TX_ABORT: abort scan if tx collides
+ * @NL80211_SCAN_FLAG_FLUSH: flush bss cache before scan
+ */
+enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_TX_ABORT	= 1<<0,
+	NL80211_SCAN_FLAG_FLUSH		= 1<<1,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/scan.c b/scan.c
index bb84a67..44ffaf8 100644
--- a/scan.c
+++ b/scan.c
@@ -73,6 +73,7 @@ static int handle_scan(struct nl80211_state *state,
 	bool passive = false, have_ssids = false, have_freqs = false;
 	size_t tmp;
 	unsigned char *ies;
+	int flags = 0;
 
 	ssids = nlmsg_alloc();
 	if (!ssids)
@@ -102,6 +103,14 @@ static int handle_scan(struct nl80211_state *state,
 				parse = DONE;
 				passive = true;
 				break;
+			} else if (strcmp(argv[i], "txabort") == 0) {
+				parse = DONE;
+				flags |= NL80211_SCAN_FLAG_TX_ABORT;
+				break;
+			} else if (strcmp(argv[i], "flush") == 0) {
+				parse = DONE;
+				flags |= NL80211_SCAN_FLAG_FLUSH;
+				break;
 			}
 		case DONE:
 			return 1;
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
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive|txabort|flush]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1354,7 +1365,8 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive|txabort|flush]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
+
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.7.7.3

