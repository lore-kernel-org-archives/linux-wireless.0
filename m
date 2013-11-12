Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23257 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab3KLPqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 10:46:37 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] iw: Use NL80211_FREQUENCY_ATTR_NO_IR channel attribute
Date: Tue, 12 Nov 2013 17:46:50 +0200
Message-Id: <1384271210-26762-1-git-send-email-ilan.peer@intel.com> (sfid-20131112_164640_986833_456571BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align iw with the change in nl80211.h where NL80211_FREQUENCY_ATTR_NO_IBSS
and NL80211_FREQUENCY_ATTR_PASSIVE_SCAN were replaced by
NL80211_FREQUENCY_ATTR_NO_IR.

In case both NL80211_FREQUENCY_ATTR_NO_IR and __NL80211_FREQUENCY_ATTR_NO_IBSS
are set, assume that a new kernel is used and use the NO_IR notation,
otherwise use the previous notation.

This change requires nl80211.h with the new definitions

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 event.c |   24 ++++++++++++++----------
 info.c  |   18 ++++++++++++------
 reg.c   |   10 ++++++++--
 3 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/event.c b/event.c
index 603b072..bfdb0fb 100644
--- a/event.c
+++ b/event.c
@@ -11,7 +11,7 @@ static int no_seq_check(struct nl_msg *msg, void *arg)
 
 struct ieee80211_beacon_channel {
 	__u16 center_freq;
-	bool passive_scan;
+	bool no_ir;
 	bool no_ibss;
 };
 
@@ -21,8 +21,8 @@ static int parse_beacon_hint_chan(struct nlattr *tb,
 	struct nlattr *tb_freq[NL80211_FREQUENCY_ATTR_MAX + 1];
 	static struct nla_policy beacon_freq_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
 		[NL80211_FREQUENCY_ATTR_FREQ] = { .type = NLA_U32 },
-		[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN] = { .type = NLA_FLAG },
-		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_NO_IR] = { .type = NLA_FLAG },
+		[__NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
 	};
 
 	if (nla_parse_nested(tb_freq,
@@ -33,9 +33,9 @@ static int parse_beacon_hint_chan(struct nlattr *tb,
 
 	chan->center_freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
 
-	if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN])
-		chan->passive_scan = true;
-	if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IBSS])
+	if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IR])
+		chan->no_ir = true;
+	if (tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS])
 		chan->no_ibss = true;
 
 	return 0;
@@ -394,10 +394,14 @@ static int print_event(struct nl_msg *msg, void *arg)
 		       chan_before_beacon.center_freq,
 		       ieee80211_frequency_to_channel(chan_before_beacon.center_freq));
 
-		if (chan_before_beacon.passive_scan && !chan_after_beacon.passive_scan)
-			printf("\to active scanning enabled\n");
-		if (chan_before_beacon.no_ibss && !chan_after_beacon.no_ibss)
-			printf("\to beaconing enabled\n");
+		if (chan_before_beacon.no_ir && !chan_after_beacon.no_ir) {
+			if (chan_before_beacon.no_ibss && !chan_after_beacon.no_ibss)
+				printf("\to Initiating radiation enabled\n");
+			else
+				printf("\to active scan enabled\n");
+		} else if (chan_before_beacon.no_ibss && !chan_after_beacon.no_ibss) {
+			printf("\to ibss enabled\n");
+		}
 
 		break;
 	case NL80211_CMD_NEW_STATION:
diff --git a/info.c b/info.c
index 7e61e88..b918439 100644
--- a/info.c
+++ b/info.c
@@ -74,8 +74,8 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 	static struct nla_policy freq_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
 		[NL80211_FREQUENCY_ATTR_FREQ] = { .type = NLA_U32 },
 		[NL80211_FREQUENCY_ATTR_DISABLED] = { .type = NLA_FLAG },
-		[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN] = { .type = NLA_FLAG },
-		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_NO_IR] = { .type = NLA_FLAG },
+		[__NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_RADAR] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] = { .type = NLA_U32 },
 	};
@@ -172,10 +172,16 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 						print_flag("disabled", &open);
 						goto next;
 					}
-					if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN])
-						print_flag("passive scanning", &open);
-					if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IBSS])
-						print_flag("no IBSS", &open);
+
+					/* If both flags are set assume an new kernel */
+					if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IR] && tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS]) {
+						print_flag("not allowed to initiate radiation", &open);
+					} else if (tb_freq[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN]) {
+						print_flag("passive scan", &open);
+					} else if (tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS]){
+						print_flag("no ibss", &open);
+					}
+
 					if (tb_freq[NL80211_FREQUENCY_ATTR_RADAR])
 						print_flag("radar detection", &open);
 next:
diff --git a/reg.c b/reg.c
index 9a60cec..f2481fe 100644
--- a/reg.c
+++ b/reg.c
@@ -193,8 +193,14 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 		PARSE_FLAG(NL80211_RRF_NO_OUTDOOR, "NO-OUTDOOR");
 		PARSE_FLAG(NL80211_RRF_DFS, "DFS");
 		PARSE_FLAG(NL80211_RRF_PTP_ONLY, "PTP-ONLY");
-		PARSE_FLAG(NL80211_RRF_PASSIVE_SCAN, "PASSIVE-SCAN");
-		PARSE_FLAG(NL80211_RRF_NO_IBSS, "NO-IBSS");
+
+		/* Kernels that support NO_IR always turn on both flags */
+		if ((flags & NL80211_RRF_NO_IR) && (flags & __NL80211_RRF_NO_IBSS)) {
+			printf(", NO-IR");
+		} else {
+			PARSE_FLAG(NL80211_RRF_PASSIVE_SCAN, "PASSIVE-SCAN");
+			PARSE_FLAG(__NL80211_RRF_NO_IBSS, "NO-IBSS");
+		}
 
 		printf("\n");
 	}
-- 
1.7.10.4

