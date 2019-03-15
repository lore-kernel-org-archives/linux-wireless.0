Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21BEC10F0C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2B6205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbfCOPjS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:39:18 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44104 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727619AbfCOPjR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:39:17 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovU-0004n1-Cv; Fri, 15 Mar 2019 17:39:16 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:39:00 +0200
Message-Id: <20190315153907.16192-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315153907.16192-1-luca@coelho.fi>
References: <20190315153907.16192-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/11] cfg80211: Handle WMM rules in regulatory domain intersection
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

The support added for regulatory WMM rules did not handle
the case of regulatory domain intersections. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/reg.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2f1bf91eb226..0ba778f371cb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1309,6 +1309,16 @@ reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
 	return dfs_region1;
 }
 
+static void reg_wmm_rules_intersect(const struct ieee80211_wmm_ac *wmm_ac1,
+				    const struct ieee80211_wmm_ac *wmm_ac2,
+				    struct ieee80211_wmm_ac *intersect)
+{
+	intersect->cw_min = max_t(u16, wmm_ac1->cw_min, wmm_ac2->cw_min);
+	intersect->cw_max = max_t(u16, wmm_ac1->cw_max, wmm_ac2->cw_max);
+	intersect->cot = min_t(u16, wmm_ac1->cot, wmm_ac2->cot);
+	intersect->aifsn = max_t(u8, wmm_ac1->aifsn, wmm_ac2->aifsn);
+}
+
 /*
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
@@ -1323,6 +1333,8 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	struct ieee80211_freq_range *freq_range;
 	const struct ieee80211_power_rule *power_rule1, *power_rule2;
 	struct ieee80211_power_rule *power_rule;
+	const struct ieee80211_wmm_rule *wmm_rule1, *wmm_rule2;
+	struct ieee80211_wmm_rule *wmm_rule;
 	u32 freq_diff, max_bandwidth1, max_bandwidth2;
 
 	freq_range1 = &rule1->freq_range;
@@ -1333,6 +1345,10 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	power_rule2 = &rule2->power_rule;
 	power_rule = &intersected_rule->power_rule;
 
+	wmm_rule1 = &rule1->wmm_rule;
+	wmm_rule2 = &rule2->wmm_rule;
+	wmm_rule = &intersected_rule->wmm_rule;
+
 	freq_range->start_freq_khz = max(freq_range1->start_freq_khz,
 					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
@@ -1376,6 +1392,29 @@ static int reg_rules_intersect(const struct ieee80211_regdomain *rd1,
 	intersected_rule->dfs_cac_ms = max(rule1->dfs_cac_ms,
 					   rule2->dfs_cac_ms);
 
+	if (rule1->has_wmm && rule2->has_wmm) {
+		u8 ac;
+
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+			reg_wmm_rules_intersect(&wmm_rule1->client[ac],
+						&wmm_rule2->client[ac],
+						&wmm_rule->client[ac]);
+			reg_wmm_rules_intersect(&wmm_rule1->ap[ac],
+						&wmm_rule2->ap[ac],
+						&wmm_rule->ap[ac]);
+		}
+
+		intersected_rule->has_wmm = true;
+	} else if (rule1->has_wmm) {
+		*wmm_rule = *wmm_rule1;
+		intersected_rule->has_wmm = true;
+	} else if (rule2->has_wmm) {
+		*wmm_rule = *wmm_rule2;
+		intersected_rule->has_wmm = true;
+	} else {
+		intersected_rule->has_wmm = false;
+	}
+
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
 
-- 
2.20.1

