Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:52111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1CUVmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:42:36 -0400
Received: from kpbe18.cbf.corp.google.com (kpbe18.cbf.corp.google.com [172.25.105.82])
	by smtp-out.google.com with ESMTP id p2LLgYBU029470
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:42:35 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by kpbe18.cbf.corp.google.com with ESMTP id p2LLgXbs021226
	for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:42:34 -0700
From: Paul Stewart <pstew@google.com>
Date: Mon, 21 Mar 2011 14:31:10 -0700
Subject: [RFC] iw: Add station BSS params to output
To: linux-wireless@vger.kernel.org
Message-Id: <20110321214233.9074020880@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note -- This patch can't be used verbatim, as there are other changes
to nl80211.h in compat since the current version of iw in git has been
pulled.  Specifically nl80211_sta_info has more in it.


Signed-off-by: Paul Stewart <pstew@google.com>
---
 nl80211.h |   33 +++++++++++++++++++++++++++++++++
 station.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 2b89b71..8968aa5 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1216,6 +1216,36 @@ enum nl80211_rate_info {
 };
 
 /**
+ * enum nl80211_sta_bss_param - BSS information collected by STA
+ *
+ * These attribute types are used with %NL80211_STA_INFO_BSS_PARAM
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_STA_BSS_PARAM_INVALID: attribute number 0 is reserved
+ * @NL80211_STA_BSS_PARAM_CTS_PROT: whether CTS protection is enabled (flag)
+ * @NL80211_STA_BSS_PARAM_SHORT_PREAMBLE:  whether short preamble is enabled
+ *     (flag)
+ * @NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME:  whether short slot time is enabled
+ *     (flag)
+ * @NL80211_STA_BSS_PARAM_DTIM_PERIOD: DTIM period for beaconing (u8)
+ * @NL80211_STA_BSS_PARAM_BEACON_INTERVAL: Beacon interval (u16)
+ * @NL80211_STA_BSS_PARAM_MAX: highest sta_bss_param number currently defined
+ * @__NL80211_STA_BSS_PARAM_AFTER_LAST: internal use
+ */
+enum nl80211_sta_bss_param {
+	__NL80211_STA_BSS_PARAM_INVALID,
+	NL80211_STA_BSS_PARAM_CTS_PROT,
+	NL80211_STA_BSS_PARAM_SHORT_PREAMBLE,
+	NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME,
+	NL80211_STA_BSS_PARAM_DTIM_PERIOD,
+	NL80211_STA_BSS_PARAM_BEACON_INTERVAL,
+	
+	/* keep last */
+	__NL80211_STA_BSS_PARAM_AFTER_LAST,
+	NL80211_STA_BSS_PARAM_MAX = __NL80211_STA_BSS_PARAM_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_sta_info - station information
  *
  * These attribute types are used with %NL80211_ATTR_STA_INFO
@@ -1236,6 +1266,8 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_TX_RETRIES: total retries (u32, to this station)
  * @NL80211_STA_INFO_TX_FAILED: total failed packets (u32, to this station)
  * @NL80211_STA_INFO_SIGNAL_AVG: signal strength average (u8, dBm)
+ * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
+ *     containing info as possible, see &enum nl80211_sta_bss_param
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -1252,6 +1284,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TX_RETRIES,
 	NL80211_STA_INFO_TX_FAILED,
 	NL80211_STA_INFO_SIGNAL_AVG,
+	NL80211_STA_INFO_BSS_PARAM,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/station.c b/station.c
index 6581d50..e658167 100644
--- a/station.c
+++ b/station.c
@@ -36,6 +36,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
 	struct nlattr *rinfo[NL80211_RATE_INFO_MAX + 1];
+	struct nlattr *binfo[NL80211_STA_BSS_PARAM_MAX + 1];
 	char mac_addr[20], state_name[10], dev[20];
 	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] = {
 		[NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
@@ -58,6 +59,14 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_RATE_INFO_40_MHZ_WIDTH] = { .type = NLA_FLAG },
 		[NL80211_RATE_INFO_SHORT_GI] = { .type = NLA_FLAG },
 	};
+	static struct nla_policy bss_policy[NL80211_STA_BSS_PARAM_MAX + 1] = {
+		[NL80211_STA_BSS_PARAM_CTS_PROT] = { .type = NLA_FLAG },
+		[NL80211_STA_BSS_PARAM_SHORT_PREAMBLE] = { .type = NLA_FLAG },
+		[NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME] = { .type = NLA_FLAG },
+		[NL80211_STA_BSS_PARAM_DTIM_PERIOD] = { .type = NLA_U8 },
+		[NL80211_STA_BSS_PARAM_BEACON_INTERVAL] = { .type = NLA_U16 },
+       };
+
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -167,6 +176,31 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\tmesh plink:\t%s", state_name);
 	}
 
+	if (sinfo[NL80211_STA_INFO_BSS_PARAM]) {
+		if (nla_parse_nested(binfo, NL80211_STA_BSS_PARAM_MAX,
+				     sinfo[NL80211_STA_INFO_BSS_PARAM],
+				     bss_policy)) {
+			fprintf(stderr, "failed to parse nested bss parameters!\n");
+		} else {
+			char *delim = "";
+			printf("\n\tbss flags:\t");
+			if (binfo[NL80211_STA_BSS_PARAM_CTS_PROT]) {
+				printf("CTS-protection");
+				delim = " ";
+			}
+			if (binfo[NL80211_STA_BSS_PARAM_SHORT_PREAMBLE]) {
+				printf("%sshort-preamble", delim);
+				delim = " ";
+			}
+			if (binfo[NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME])
+				printf("%sshort-slot-time", delim);
+			printf("\n\tdtim period:\t%d",
+			       nla_get_u8(binfo[NL80211_STA_BSS_PARAM_DTIM_PERIOD]));
+			printf("\n\tbeacon int:\t%d",
+			       nla_get_u16(binfo[NL80211_STA_BSS_PARAM_BEACON_INTERVAL]));
+		}
+	}
+
 	printf("\n");
 	return NL_SKIP;
 }
-- 
1.7.3.1

