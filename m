Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60678 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728778AbeHVPRC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:17:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Grzegorz=20Duszy=C5=84ski?= <gfduszynski@gmail.com>
Subject: [PATCH 2/2] cfg80211: validate wmm rule when setting
Date: Wed, 22 Aug 2018 13:52:22 +0200
Message-Id: <1534938742-9998-2-git-send-email-sgruszka@redhat.com> (sfid-20180822_135230_568260_EA7A3D10)
In-Reply-To: <1534938742-9998-1-git-send-email-sgruszka@redhat.com>
References: <1534938742-9998-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add validation check for wmm rule when copy rules from fwdb and print
error when rule is invalid.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/wireless/reg.c | 64 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2f702adf2912..bf7611bf4740 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -847,22 +847,36 @@ static bool valid_regdb(const u8 *data, unsigned int size)
 	return true;
 }
 
-static void set_wmm_rule(struct ieee80211_reg_rule *rrule,
-			 struct fwdb_wmm_rule *wmm)
-{
-	struct ieee80211_wmm_rule *rule = &rrule->wmm_rule;
-	unsigned int i;
+static void set_wmm_rule(const struct fwdb_header *db,
+			 const struct fwdb_country *country,
+			 const struct fwdb_rule *rule,
+			 struct ieee80211_reg_rule *rrule)
+{
+	struct ieee80211_wmm_rule *wmm_rule = &rrule->wmm_rule;
+	struct fwdb_wmm_rule *wmm;
+	unsigned int i, wmm_ptr;
+
+	wmm_ptr = be16_to_cpu(rule->wmm_ptr) << 2;
+	wmm = (void *)((u8 *)db + wmm_ptr);
+
+	if (!valid_wmm(wmm)) {
+		pr_err("Invalid regulatory WMM rule %u-%u in domain %c%c\n",
+		       be32_to_cpu(rule->start), be32_to_cpu(rule->end),
+		       country->alpha2[0], country->alpha2[1]);
+		return;
+	}
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		rule->client[i].cw_min =
+		wmm_rule->client[i].cw_min =
 			ecw2cw((wmm->client[i].ecw & 0xf0) >> 4);
-		rule->client[i].cw_max = ecw2cw(wmm->client[i].ecw & 0x0f);
-		rule->client[i].aifsn =  wmm->client[i].aifsn;
-		rule->client[i].cot = 1000 * be16_to_cpu(wmm->client[i].cot);
-		rule->ap[i].cw_min = ecw2cw((wmm->ap[i].ecw & 0xf0) >> 4);
-		rule->ap[i].cw_max = ecw2cw(wmm->ap[i].ecw & 0x0f);
-		rule->ap[i].aifsn = wmm->ap[i].aifsn;
-		rule->ap[i].cot = 1000 * be16_to_cpu(wmm->ap[i].cot);
+		wmm_rule->client[i].cw_max = ecw2cw(wmm->client[i].ecw & 0x0f);
+		wmm_rule->client[i].aifsn =  wmm->client[i].aifsn;
+		wmm_rule->client[i].cot =
+			1000 * be16_to_cpu(wmm->client[i].cot);
+		wmm_rule->ap[i].cw_min = ecw2cw((wmm->ap[i].ecw & 0xf0) >> 4);
+		wmm_rule->ap[i].cw_max = ecw2cw(wmm->ap[i].ecw & 0x0f);
+		wmm_rule->ap[i].aifsn = wmm->ap[i].aifsn;
+		wmm_rule->ap[i].cot = 1000 * be16_to_cpu(wmm->ap[i].cot);
 	}
 
 	rrule->has_wmm = true;
@@ -870,7 +884,7 @@ static void set_wmm_rule(struct ieee80211_reg_rule *rrule,
 
 static int __regdb_query_wmm(const struct fwdb_header *db,
 			     const struct fwdb_country *country, int freq,
-			     struct ieee80211_reg_rule *rule)
+			     struct ieee80211_reg_rule *rrule)
 {
 	unsigned int ptr = be16_to_cpu(country->coll_ptr) << 2;
 	struct fwdb_collection *coll = (void *)((u8 *)db + ptr);
@@ -879,18 +893,14 @@ static int __regdb_query_wmm(const struct fwdb_header *db,
 	for (i = 0; i < coll->n_rules; i++) {
 		__be16 *rules_ptr = (void *)((u8 *)coll + ALIGN(coll->len, 2));
 		unsigned int rule_ptr = be16_to_cpu(rules_ptr[i]) << 2;
-		struct fwdb_rule *rrule = (void *)((u8 *)db + rule_ptr);
-		struct fwdb_wmm_rule *wmm;
-		unsigned int wmm_ptr;
+		struct fwdb_rule *rule = (void *)((u8 *)db + rule_ptr);
 
-		if (rrule->len < offsetofend(struct fwdb_rule, wmm_ptr))
+		if (rule->len < offsetofend(struct fwdb_rule, wmm_ptr))
 			continue;
 
-		if (freq >= KHZ_TO_MHZ(be32_to_cpu(rrule->start)) &&
-		    freq <= KHZ_TO_MHZ(be32_to_cpu(rrule->end))) {
-			wmm_ptr = be16_to_cpu(rrule->wmm_ptr) << 2;
-			wmm = (void *)((u8 *)db + wmm_ptr);
-			set_wmm_rule(rule, wmm);
+		if (freq >= KHZ_TO_MHZ(be32_to_cpu(rule->start)) &&
+		    freq <= KHZ_TO_MHZ(be32_to_cpu(rule->end))) {
+			set_wmm_rule(db, country, rule, rrule);
 			return 0;
 		}
 	}
@@ -972,12 +982,8 @@ static int regdb_query_country(const struct fwdb_header *db,
 		if (rule->len >= offsetofend(struct fwdb_rule, cac_timeout))
 			rrule->dfs_cac_ms =
 				1000 * be16_to_cpu(rule->cac_timeout);
-		if (rule->len >= offsetofend(struct fwdb_rule, wmm_ptr)) {
-			u32 wmm_ptr = be16_to_cpu(rule->wmm_ptr) << 2;
-			struct fwdb_wmm_rule *wmm = (void *)((u8 *)db + wmm_ptr);
-
-			set_wmm_rule(rrule, wmm);
-		}
+		if (rule->len >= offsetofend(struct fwdb_rule, wmm_ptr))
+			set_wmm_rule(db, country, rule, rrule);
 	}
 
 	return reg_schedule_apply(regdom);
-- 
2.7.5
