Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:33978 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZCCVzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 16:55:21 -0500
Received: by ewy25 with SMTP id 25so2526599ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2009 13:55:19 -0800 (PST)
Message-ID: <49ADA749.6020901@gmail.com> (sfid-20090303_225525_548709_1436F011)
Date: Tue, 03 Mar 2009 22:55:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cfg80211: test before subtraction on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

freq_diff is unsigned, so test before subtraction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 85c9034..bd0a16c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -380,7 +380,8 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 
-	if (freq_diff <= 0 || freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
+			freq_range->max_bandwidth_khz > freq_diff)
 		return false;
 
 	return true;
