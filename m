Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53624 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab1JKSAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 14:00:14 -0400
Received: by pzk1 with SMTP id 1so19500487pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 11:00:13 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 4/4] crda: add support to send DFS master region
Date: Tue, 11 Oct 2011 10:59:01 -0700
Message-Id: <1318355944-24708-5-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_200018_219709_A7A64AA2)
In-Reply-To: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless-regdb now has support for a DFS master region
for each country. We must read this from the file and
send it as an NL80211_ATTR_DFS_REGION attribute.

We add a "creqs" value for the country structure but only
use the first two bits as that is all we need right now.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 crda.c    |    1 +
 nl80211.h |   21 +++++++++++++++++++++
 regdb.h   |    3 ++-
 3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/crda.c b/crda.c
index fcb0c11..1e2ff22 100644
--- a/crda.c
+++ b/crda.c
@@ -280,6 +280,7 @@ int main(int argc, char **argv)
 				country->reg_collection_ptr);
 
 	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, alpha2);
+	NLA_PUT_U8(msg, NL80211_ATTR_DFS_REGION, country->creqs & 0x3);
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules) {
diff --git a/nl80211.h b/nl80211.h
index 9d797f2..2dbb799 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1109,6 +1109,10 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DFS_REGION: region for regulatory rules which this country
+ *    abides to when initiating radiation on DFS channels. A country maps
+ *    to one DFS region.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1341,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DFS_REGION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1843,6 +1849,21 @@ enum nl80211_reg_rule_flags {
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
diff --git a/regdb.h b/regdb.h
index 045a0e3..f040aa1 100644
--- a/regdb.h
+++ b/regdb.h
@@ -96,7 +96,8 @@ struct regdb_file_reg_rules_collection {
 
 struct regdb_file_reg_country {
 	__u8	alpha2[2];
-	__u8	PAD[2];
+	__u8	PAD;
+	__u8	creqs; /* first two bits define DFS region */
 	/* pointer (offset) into the file to a struct
 	 * regdb_file_reg_rules_collection */
 	__be32	reg_collection_ptr;
-- 
1.7.4.15.g7811d

