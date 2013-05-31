Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41690 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3EaCMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:12:03 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz12so1393216pbc.17
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:12:03 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 32/40] crda: rename min() to reglib_min()
Date: Thu, 30 May 2013 19:09:21 -0700
Message-Id: <1369966169-23640-33-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042938_441861_333C5670)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |    8 ++++----
 reglib.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/reglib.c b/reglib.c
index 57bb22b..4643fa8 100644
--- a/reglib.c
+++ b/reglib.c
@@ -440,18 +440,18 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 
 	freq_range->start_freq_khz = reglib_max(freq_range1->start_freq_khz,
 					 freq_range2->start_freq_khz);
-	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
+	freq_range->end_freq_khz = reglib_min(freq_range1->end_freq_khz,
 				       freq_range2->end_freq_khz);
-	freq_range->max_bandwidth_khz = min(freq_range1->max_bandwidth_khz,
+	freq_range->max_bandwidth_khz = reglib_min(freq_range1->max_bandwidth_khz,
 					    freq_range2->max_bandwidth_khz);
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 	if (freq_range->max_bandwidth_khz > freq_diff)
 		freq_range->max_bandwidth_khz = freq_diff;
 
-	power_rule->max_eirp = min(power_rule1->max_eirp,
+	power_rule->max_eirp = reglib_min(power_rule1->max_eirp,
 		power_rule2->max_eirp);
-	power_rule->max_antenna_gain = min(power_rule1->max_antenna_gain,
+	power_rule->max_antenna_gain = reglib_min(power_rule1->max_antenna_gain,
 		power_rule2->max_antenna_gain);
 
 	intersected_rule->flags = rule1->flags | rule2->flags;
diff --git a/reglib.h b/reglib.h
index 21518d2..8a31e0d 100644
--- a/reglib.h
+++ b/reglib.h
@@ -65,7 +65,7 @@ static inline uint32_t reglib_max(uint32_t a, uint32_t b)
 	return (a > b) ? a : b;
 }
 
-static inline uint32_t min(uint32_t a, uint32_t b)
+static inline uint32_t reglib_min(uint32_t a, uint32_t b)
 {
 	return (a > b) ? b : a;
 }
-- 
1.7.10.4

