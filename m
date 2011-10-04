Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36705 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:48:10 -0400
Received: by mail-gx0-f174.google.com with SMTP id v2so478718ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:48:10 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 5/8] crda: synch up nl80211.h
Date: Tue,  4 Oct 2011 16:47:44 -0700
Message-Id: <1317772067-6998-6-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014813_477986_EE4493B4)
In-Reply-To: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 nl80211.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 9d797f2..3d7f468 100644
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
+enum nl80211_cflags {
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
-- 
1.7.4.15.g7811d

