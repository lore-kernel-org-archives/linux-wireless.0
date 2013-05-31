Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56048 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3EaCJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:09:42 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so1368048pdi.22
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:09:41 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 01/40] crda: make reg_rules_intersect() style match Linux
Date: Thu, 30 May 2013 19:08:50 -0700
Message-Id: <1369966169-23640-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_040945_138126_27E02EEF)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This makes reg_rules_intersect() style match exactly
as it is upstream as of next-20130522.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/intersect.c b/intersect.c
index 012750d..aa67dbc 100644
--- a/intersect.c
+++ b/intersect.c
@@ -56,11 +56,11 @@ static int reg_rules_intersect(
 	power_rule = &intersected_rule->power_rule;
 
 	freq_range->start_freq_khz = max(freq_range1->start_freq_khz,
-		freq_range2->start_freq_khz);
+					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
-		freq_range2->end_freq_khz);
+				       freq_range2->end_freq_khz);
 	freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
-		freq_range2->max_bandwidth_khz);
+					    freq_range2->max_bandwidth_khz);
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 	if (freq_range->max_bandwidth_khz > freq_diff)
@@ -71,7 +71,7 @@ static int reg_rules_intersect(
 	power_rule->max_antenna_gain = min(power_rule1->max_antenna_gain,
 		power_rule2->max_antenna_gain);
 
-	intersected_rule->flags = (rule1->flags | rule2->flags);
+	intersected_rule->flags = rule1->flags | rule2->flags;
 
 	if (!is_valid_reg_rule(intersected_rule))
 		return -EINVAL;
-- 
1.7.10.4

