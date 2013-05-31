Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60444 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3EaCL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:11:59 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so1382417pde.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:11:59 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 31/40] crda: rename max() to reglib_max()
Date: Thu, 30 May 2013 19:09:20 -0700
Message-Id: <1369966169-23640-32-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_042939_396923_4E4E116F)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 reglib.c |    2 +-
 reglib.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/reglib.c b/reglib.c
index 0d258d8..57bb22b 100644
--- a/reglib.c
+++ b/reglib.c
@@ -438,7 +438,7 @@ static int reg_rules_intersect(const struct ieee80211_reg_rule *rule1,
 	power_rule2 = &rule2->power_rule;
 	power_rule = &intersected_rule->power_rule;
 
-	freq_range->start_freq_khz = max(freq_range1->start_freq_khz,
+	freq_range->start_freq_khz = reglib_max(freq_range1->start_freq_khz,
 					 freq_range2->start_freq_khz);
 	freq_range->end_freq_khz = min(freq_range1->end_freq_khz,
 				       freq_range2->end_freq_khz);
diff --git a/reglib.h b/reglib.h
index 8ed94d9..21518d2 100644
--- a/reglib.h
+++ b/reglib.h
@@ -60,7 +60,7 @@ static inline int reglib_is_valid_regdom(const char *alpha2)
 	return 1;
 }
 
-static inline uint32_t max(uint32_t a, uint32_t b)
+static inline uint32_t reglib_max(uint32_t a, uint32_t b)
 {
 	return (a > b) ? a : b;
 }
-- 
1.7.10.4

