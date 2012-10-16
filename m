Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:50168 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558Ab2JPAXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 20:23:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] iw: add lowpri and flush scan operands
Date: Mon, 15 Oct 2012 17:22:27 -0700
Message-Id: <1350346947-21280-1-git-send-email-bzhao@marvell.com> (sfid-20121016_022320_172537_B8491A4D)
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
 info.c    |    6 ++++++
 nl80211.h |   27 +++++++++++++++++++++++++++
 scan.c    |   16 ++++++++++++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index f039bba..87b85c2 100644
--- a/info.c
+++ b/info.c
@@ -438,6 +438,12 @@ broken_combination:
 		if (nla_get_u32(tb_msg[NL80211_ATTR_FEATURE_FLAGS]) &
 				NL80211_FEATURE_HT_IBSS)
 			printf("\tDevice supports HT-IBSS.\n");
+		if (nla_get_u32(tb_msg[NL80211_ATTR_FEATURE_FLAGS]) &
+				NL80211_FEATURE_LOW_PRIORITY_SCAN)
+			printf("\tDevice supports low priority scan.\n");
+		if (nla_get_u32(tb_msg[NL80211_ATTR_FEATURE_FLAGS]) &
+				NL80211_FEATURE_SCAN_FLUSH)
+			printf("\tDevice supports scan flush.\n");
 	}
 
 	return NL_SKIP;
diff --git a/nl80211.h b/nl80211.h
index 2f38788..0a39e05 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1506,6 +1506,14 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_CONN_FAILED_REASON,
+
+	NL80211_ATTR_SAE_DATA,
+
+	NL80211_ATTR_VHT_CAPABILITY,
+
+	NL80211_ATTR_SCAN_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2994,12 +3002,16 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
  *	to work properly to suppport receiving regulatory hints from
  *	cellular base stations.
+ * @NL80211_FEATURE_LOW_PRIORITY_SCAN: This driver supports low priority scan
+ * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS = 1 << 3,
+	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
+	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
 };
 
 /**
@@ -3023,4 +3035,19 @@ enum nl80211_probe_resp_offload_support_attr {
 	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
 };
 
+/**
+ * enum nl80211_scan_flags -  scan request control flags
+ *
+ * Scan request control flags are used to control the handling
+ * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
+ * requests.
+ *
+ * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
+ * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
+ */
+enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
+	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/scan.c b/scan.c
index bb84a67..85fb5a9 100644
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
+			} else if (strcmp(argv[i], "lowpri") == 0) {
+				parse = DONE;
+				flags |= NL80211_SCAN_FLAG_LOW_PRIORITY;
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
+TOPLEVEL(scan, "[-u] [freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive|lowpri|flush]", 0, 0,
 	 CIB_NETDEV, handle_scan_combined,
 	 "Scan on the given frequencies and probe for the given SSIDs\n"
 	 "(or wildcard if not given) unless passive scanning is requested.\n"
@@ -1354,7 +1365,8 @@ COMMAND(scan, dump, "[-u]",
 	NL80211_CMD_GET_SCAN, NLM_F_DUMP, CIB_NETDEV, handle_scan_dump,
 	"Dump the current scan results. If -u is specified, print unknown\n"
 	"data in scan results.");
-COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive]",
+COMMAND(scan, trigger, "[freq <freq>*] [ies <hex as 00:11:..>] [ssid <ssid>*|passive|lowpri|flush]",
 	NL80211_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, handle_scan,
 	 "Trigger a scan on the given frequencies with probing for the given\n"
+
 	 "SSIDs (or wildcard if not given) unless passive scanning is requested.");
-- 
1.7.7.3

