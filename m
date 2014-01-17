Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61105 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaAQIcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 03:32:16 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so745420ead.27
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:32:15 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/5] cfg80211: don't check regulatory bandwidth
Date: Fri, 17 Jan 2014 09:32:00 +0100
Message-Id: <1389947524-6102-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093222_952069_DA9710BA)
In-Reply-To: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't check regulatory bandwith base on
single regulatory rule. There will be introduced
new code that will calculate maximum bandwidth
base on all contiguous rules.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/reg.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7d20d84..89bfac1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -526,7 +526,6 @@ bool reg_is_valid_request(const char *alpha2)
 static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
 	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
-	u32 freq_diff;
 
 	if (freq_range->start_freq_khz <= 0 || freq_range->end_freq_khz <= 0)
 		return false;
@@ -534,10 +533,7 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	if (freq_range->start_freq_khz > freq_range->end_freq_khz)
 		return false;
 
-	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
-
-	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
-	    freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz)
 		return false;
 
 	return true;
-- 
1.7.9.5

