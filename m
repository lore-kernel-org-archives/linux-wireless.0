Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65191 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:48:13 -0400
Received: by mail-yw0-f46.google.com with SMTP id 5so1034660ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:48:13 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 6/8] crda: add support to send DFS master region
Date: Tue,  4 Oct 2011 16:47:45 -0700
Message-Id: <1317772067-6998-7-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014816_436069_5691EAFD)
In-Reply-To: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless-regdb now has support for a DFS master region
for each country. We must read this from the file and
send it as an NL80211_ATTR_DFS_REGION attribute.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 crda.c  |    1 +
 regdb.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/crda.c b/crda.c
index 6857e3f..dfc5353 100644
--- a/crda.c
+++ b/crda.c
@@ -280,6 +280,7 @@ int main(int argc, char **argv)
 				country->reg_collection_ptr);
 
 	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, (char *) country->alpha2);
+	NLA_PUT_U8(msg, NL80211_ATTR_DFS_REGION, country->dfs_region);
 
 	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
 	if (!nl_reg_rules) {
diff --git a/regdb.h b/regdb.h
index 045a0e3..b59115f 100644
--- a/regdb.h
+++ b/regdb.h
@@ -96,7 +96,8 @@ struct regdb_file_reg_rules_collection {
 
 struct regdb_file_reg_country {
 	__u8	alpha2[2];
-	__u8	PAD[2];
+	__u8	PAD;
+	__u8	dfs_region;
 	/* pointer (offset) into the file to a struct
 	 * regdb_file_reg_rules_collection */
 	__be32	reg_collection_ptr;
-- 
1.7.4.15.g7811d

