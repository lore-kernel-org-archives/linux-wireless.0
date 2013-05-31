Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35090 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3EaCJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 22:09:46 -0400
Received: by mail-pd0-f174.google.com with SMTP id 3so1384591pdj.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 19:09:45 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 02/40] crda: port over Linux is_valid_reg_rule() change bd05f28e
Date: Thu, 30 May 2013 19:08:51 -0700
Message-Id: <1369966169-23640-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20130531_040948_582357_B9255A92)
In-Reply-To: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
References: <1369966169-23640-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This was added upstream:

mcgrof@frijol ~/linux-stable (git::master)$ git describe --contains bd05f28e
v2.6.29~3^2~47

commit bd05f28e1a15ae62994fe309a524695fe26dd834
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Tue Mar 3 22:55:21 2009 +0100

    cfg80211: test before subtraction on unsigned

    freq_diff is unsigned, so test before subtraction

    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 intersect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/intersect.c b/intersect.c
index aa67dbc..e35f2cc 100644
--- a/intersect.c
+++ b/intersect.c
@@ -30,7 +30,8 @@ static int is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 
-	if (freq_diff == 0 || freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
+	    freq_range->max_bandwidth_khz > freq_diff)
 		return 0;
 
 	return 1;
-- 
1.7.10.4

