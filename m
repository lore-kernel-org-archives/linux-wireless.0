Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40822 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1CXB1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 21:27:15 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p2O1RDqw014107
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 18:27:14 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpaq1.eem.corp.google.com with ESMTP id p2O1RCD9028312
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 18:27:12 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 23 Mar 2011 18:22:14 -0700
Subject: [PATCH] Add station BSS params to iw output
To: linux-wireless@vger.kernel.org
Message-Id: <20110324012711.DEEF4202EE@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Paul Stewart <pstew@google.com>
---
 link.c    |   34 ++++++++++++++++++++++++++++++++++
 nl80211.h |   33 +++++++++++++++++++++++++++++++++
 station.c |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/link.c b/link.c
index 297073d..38983e1 100644
--- a/link.c
+++ b/link.c
@@ -115,6 +115,7 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
 	struct nlattr *rinfo[NL80211_RATE_INFO_MAX + 1];
+	struct nlattr *binfo[NL80211_STA_BSS_PARAM_MAX + 1];
 	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] = {
 		[NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_RX_BYTES] = { .type = NLA_U32 },
@@ -135,6 +136,14 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 		[NL80211_RATE_INFO_SHORT_GI] = { .type = NLA_FLAG },
 	};
 
+	static struct nla_policy bss_policy[NL80211_STA_BSS_PARAM_MAX + 1] = {
+		[NL80211_STA_BSS_PARAM_CTS_PROT] = { .type = NLA_FLAG },
+		[NL80211_STA_BSS_PARAM_SHORT_PREAMBLE] = { .type = NLA_FLAG },
+		[NL80211_STA_BSS_PARAM_SHORT_SLOT_TIME] = { .type = NLA_FLAG },
+		[NL80211_STA_BSS_PARAM_DTIM_PERIOD] = { .type = NLA_U8 },
+		[NL80211_STA_BSS_PARAM_BEACON_INTERVAL] = { .type = NLA_U16 },
+	};
+
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
 
@@ -182,6 +191,31 @@ static int print_link_sta(struct nl_msg *msg, void *arg)
 		}
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
 	return NL_SKIP;
 }
 
diff --git a/nl80211.h b/nl80211.h
index 2b89b71..341bd65 100644
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

