Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45552 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbaBLRn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 12:43:27 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so4495746eek.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 09:43:26 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] crda: handle AUTO bw setting in db2rd
Date: Wed, 12 Feb 2014 18:43:08 +0100
Message-Id: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_184331_450529_5F4DFDFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle AUTO bandwidth setting in db2rd.
Don't add NL80211_ATTR_FREQ_RANGE_MAX_BW attribute
in case of AUTO bw calculation.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 crda.c   |    3 ++-
 reglib.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/crda.c b/crda.c
index 0bf83a1..2fc5bce 100644
--- a/crda.c
+++ b/crda.c
@@ -127,7 +127,8 @@ static int put_reg_rule(const struct ieee80211_reg_rule *rule, struct nl_msg *ms
 	NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,		rule->flags);
 	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,		freq_range->start_freq_khz);
 	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_END,		freq_range->end_freq_khz);
-	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,	freq_range->max_bandwidth_khz);
+	if (freq_range->max_bandwidth_khz)
+		NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW, freq_range->max_bandwidth_khz);
 	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,	power_rule->max_antenna_gain);
 	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,	power_rule->max_eirp);
 
diff --git a/reglib.c b/reglib.c
index af38fe7..bb8ce96 100644
--- a/reglib.c
+++ b/reglib.c
@@ -1116,7 +1116,7 @@ reglib_parse_rule_args_cac(char *line, struct ieee80211_reg_rule *reg_rule)
 static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 {
 	char line[1024];
-	char *line_p;
+	char *line_p, *auto_p;
 	unsigned int i;
 	int r = 0;
 	struct reglib_rule_parse_list *reglib_rule_parsers;
@@ -1150,6 +1150,13 @@ static int reglib_parse_rule(FILE *fp, struct ieee80211_reg_rule *reg_rule)
 		return -EINVAL;
 	}
 
+	auto_p = strstr(line_p, "@ AUTO");
+	if (auto_p) {
+		/* This will be much easier instead of adding new parser! */
+		memcpy(&auto_p[0], "@ 0", 3);
+		memcpy(&auto_p[3], &auto_p[6], strlen(line_p) + 1 - (auto_p + 3 - line_p));
+	}
+
 	for (i = 0; i < reglib_rule_parsers->n_parsers; i++) {
 		r = reglib_rule_parsers->rule_parsers[i](line, reg_rule);
 		if (r == 0)
-- 
1.7.9.5

