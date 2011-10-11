Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33703 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1JKSCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 14:02:05 -0400
Received: by qyk30 with SMTP id 30so3796240qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 11:02:05 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH] iw: add DFS region parsing support
Date: Tue, 11 Oct 2011 10:59:04 -0700
Message-Id: <1318355944-24708-8-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_200210_694223_089A5999)
In-Reply-To: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets iw parse the DFS region passed on by the kernel
when one is found for the currently used regulatory domain.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 nl80211.h |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reg.c     |   31 +++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index c73582f..2dbb799 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -506,6 +506,9 @@
  * @NL80211_CMD_PMKSA_CANDIDATE: This is used as an event to inform userspace
  *	of PMKSA caching dandidates.
  *
+ * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -632,6 +635,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_PMKSA_CANDIDATE,
 
+	NL80211_CMD_TDLS_OPER,
+	NL80211_CMD_TDLS_MGMT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1089,6 +1095,24 @@ enum nl80211_commands {
  *	This attribute is used with %NL80211_CMD_TRIGGER_SCAN and
  *	%NL80211_CMD_FRAME commands.
  *
+ * @NL80211_ATTR_TDLS_ACTION: Low level TDLS action code (e.g. link setup
+ *	request, link setup confirm, link teardown, etc.). Values are
+ *	described in the TDLS (802.11z) specification.
+ * @NL80211_ATTR_TDLS_DIALOG_TOKEN: Non-zero token for uniquely identifying a
+ *	TDLS conversation between two devices.
+ * @NL80211_ATTR_TDLS_OPERATION: High level TDLS operation; see
+ *	&enum nl80211_tdls_operation, represented as a u8.
+ * @NL80211_ATTR_TDLS_SUPPORT: A flag indicating the device can operate
+ *	as a TDLS peer sta.
+ * @NL80211_ATTR_TDLS_EXTERNAL_SETUP: The TDLS discovery/setup and teardown
+ *	procedures should be performed by sending TDLS packets via
+ *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
+ *	used for asking the driver to perform a TDLS operation.
+ *
+ * @NL80211_ATTR_DFS_REGION: region for regulatory rules which this country
+ *    abides to when initiating radiation on DFS channels. A country maps
+ *    to one DFS region.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1311,6 +1335,14 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_NO_CCK_RATE,
 
+	NL80211_ATTR_TDLS_ACTION,
+	NL80211_ATTR_TDLS_DIALOG_TOKEN,
+	NL80211_ATTR_TDLS_OPERATION,
+	NL80211_ATTR_TDLS_SUPPORT,
+	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
+
+	NL80211_ATTR_DFS_REGION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1408,6 +1440,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1418,6 +1451,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
+	NL80211_STA_FLAG_TDLS_PEER,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -1815,6 +1849,21 @@ enum nl80211_reg_rule_flags {
 };
 
 /**
+ * enum nl80211_dfs_regions - regulatory DFS regions
+ *
+ * @NL80211_DFS_UNSET: Country has no DFS master region specified
+ * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
+ * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
+ * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
+ */
+enum nl80211_dfs_regions {
+	NL80211_DFS_UNSET	= 0,
+	NL80211_DFS_FCC		= 1,
+	NL80211_DFS_ETSI	= 2,
+	NL80211_DFS_JP		= 3,
+};
+
+/**
  * enum nl80211_survey_info - survey information
  *
  * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
@@ -2604,4 +2653,20 @@ enum nl80211_pmksa_candidate_attr {
 	MAX_NL80211_PMKSA_CANDIDATE = NUM_NL80211_PMKSA_CANDIDATE - 1
 };
 
+/**
+ * enum nl80211_tdls_operation - values for %NL80211_ATTR_TDLS_OPERATION
+ * @NL80211_TDLS_DISCOVERY_REQ: Send a TDLS discovery request
+ * @NL80211_TDLS_SETUP: Setup TDLS link
+ * @NL80211_TDLS_TEARDOWN: Teardown a TDLS link which is already established
+ * @NL80211_TDLS_ENABLE_LINK: Enable TDLS link
+ * @NL80211_TDLS_DISABLE_LINK: Disable TDLS link
+ */
+enum nl80211_tdls_operation {
+	NL80211_TDLS_DISCOVERY_REQ,
+	NL80211_TDLS_SETUP,
+	NL80211_TDLS_TEARDOWN,
+	NL80211_TDLS_ENABLE_LINK,
+	NL80211_TDLS_DISABLE_LINK,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/reg.c b/reg.c
index c4ee1c4..4fa5bec 100644
--- a/reg.c
+++ b/reg.c
@@ -96,6 +96,31 @@ COMMAND(reg, set, "<ISO/IEC 3166-1 alpha2>",
 	NL80211_CMD_REQ_SET_REG, 0, CIB_NONE, handle_reg_set,
 	"Notify the kernel about the current regulatory domain.");
 
+static void print_dfs_region(__u8 dfs_region)
+{
+	if (!dfs_region)
+		return;
+
+	printf("DFS Master region: ");
+
+	switch (dfs_region) {
+	case NL80211_DFS_FCC:
+		printf("FCC");
+		break;
+	case NL80211_DFS_ETSI:
+		printf("ETSI");
+		break;
+	case NL80211_DFS_JP:
+		printf("JP");
+		break;
+	default:
+		printf("Uknown");
+		break;
+	}
+
+	printf("\n");
+}
+
 static int print_reg_handler(struct nl_msg *msg, void *arg)
 
 {
@@ -107,6 +132,7 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	char *alpha2;
+	__u8 dfs_region = 0;
 	struct nlattr *nl_rule;
 	int rem_rule;
 	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
@@ -132,7 +158,12 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 	}
 
 	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
+
+	if (tb_msg[NL80211_ATTR_DFS_REGION])
+		dfs_region = nla_get_u8(tb_msg[NL80211_ATTR_DFS_REGION]);
+
 	printf("country %c%c:\n", alpha2[0], alpha2[1]);
+	print_dfs_region(dfs_region);
 
 	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
 		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
-- 
1.7.4.15.g7811d

