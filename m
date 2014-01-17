Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:44149 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQIcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 03:32:19 -0500
Received: by mail-ea0-f179.google.com with SMTP id q10so843583ead.38
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:32:18 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 4/5] cfg80211: introduce strict bandwidth regulatory flag
Date: Fri, 17 Jan 2014 09:32:03 +0100
Message-Id: <1389947524-6102-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093228_397224_8D1B51D5)
In-Reply-To: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce NL80211_RRF_STRICT_BW regulatory rule flag.
This mean we will check only banwidth defined in
regulatory database and not check contiguous rules.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/uapi/linux/nl80211.h |    2 ++
 net/wireless/reg.c           |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..6a4fa90 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2475,6 +2475,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_PTP_ONLY: this is only for Point To Point links
  * @NL80211_RRF_PTMP_ONLY: this is only for Point To Multi Point links
  * @NL80211_RRF_NO_IR: no mechanisms that initiate radiation are allowed,
+ * @NL80211_RRF_STRICT_BW: strict BW setting
  * 	this includes probe requests or modes of operation that require
  * 	beaconing.
  */
@@ -2488,6 +2489,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_PTMP_ONLY		= 1<<6,
 	NL80211_RRF_NO_IR		= 1<<7,
 	__NL80211_RRF_NO_IBSS		= 1<<8,
+	NL80211_RRF_STRICT_BW		= 1<<9,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8165303..8c337f2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -549,6 +549,11 @@ static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 	const struct ieee80211_reg_rule *tmp;
 	u32 start_freq, end_freq, idx, no;
 
+	/* First check if STRICT_BW flag */
+	if (rule->flags & NL80211_RRF_STRICT_BW)
+		return freq_range->max_bandwidth_khz;
+
+	/* Next check contiguous rules */
 	for (idx = 0; idx < rd->n_reg_rules; idx++)
 		if (rule == &rd->reg_rules[idx])
 			break;
@@ -566,6 +571,9 @@ static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 		if (freq_range_tmp->end_freq_khz < freq_range->start_freq_khz)
 			break;
 
+		if (tmp->flags & NL80211_RRF_STRICT_BW)
+			break;
+
 		freq_range = freq_range_tmp;
 	};
 
@@ -582,6 +590,9 @@ static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 		if (freq_range_tmp->start_freq_khz > freq_range->end_freq_khz)
 			break;
 
+		if (tmp->flags & NL80211_RRF_STRICT_BW)
+			break;
+
 		freq_range = freq_range_tmp;
 	}
 
@@ -594,6 +605,7 @@ static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
 	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	u32 freq_diff;
 
 	if (freq_range->start_freq_khz <= 0 || freq_range->end_freq_khz <= 0)
 		return false;
@@ -604,6 +616,12 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 	if (freq_range->end_freq_khz <= freq_range->start_freq_khz)
 		return false;
 
+	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
+
+	if ((rule->flags & NL80211_RRF_STRICT_BW) &&
+	    freq_range->max_bandwidth_khz > freq_diff)
+		return false;
+
 	return true;
 }
 
-- 
1.7.9.5

