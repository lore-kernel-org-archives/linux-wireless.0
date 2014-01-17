Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41099 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQIcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 03:32:17 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so1938828eek.17
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:32:16 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Subject: [PATCH 2/5] cfg80211: add helper reg_get_regdomain() function
Date: Fri, 17 Jan 2014 09:32:01 +0100
Message-Id: <1389947524-6102-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093222_235373_039CC4F9)
In-Reply-To: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add helper function that will return regdomain.
Follow the driver's regulatory domain, if present,
unless a country IE has been processed or a user
wants to help complaince further.

Signed-off-by: Janusz Dziedzic <janusz.dziedzi@tieto.com>
---
 net/wireless/reg.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 89bfac1..71d360c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -522,6 +522,25 @@ bool reg_is_valid_request(const char *alpha2)
 	return alpha2_equal(lr->alpha2, alpha2);
 }
 
+static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
+{
+	const struct ieee80211_regdomain *regd;
+	struct regulatory_request *lr = get_last_request();
+
+	/*
+	 * Follow the driver's regulatory domain, if present, unless a country
+	 * IE has been processed or a user wants to help complaince further
+	 */
+	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
+	    wiphy->regd)
+		regd = get_wiphy_regdom(wiphy);
+	else
+		regd = get_cfg80211_regdom();
+
+	return regd;
+}
+
 /* Sanity check on a regulatory rule */
 static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
@@ -817,18 +836,8 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
 					       u32 center_freq)
 {
 	const struct ieee80211_regdomain *regd;
-	struct regulatory_request *lr = get_last_request();
 
-	/*
-	 * Follow the driver's regulatory domain, if present, unless a country
-	 * IE has been processed or a user wants to help complaince further
-	 */
-	if (lr->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    lr->initiator != NL80211_REGDOM_SET_BY_USER &&
-	    wiphy->regd)
-		regd = get_wiphy_regdom(wiphy);
-	else
-		regd = get_cfg80211_regdom();
+	regd = reg_get_regdomain(wiphy);
 
 	return freq_reg_info_regd(wiphy, center_freq, regd);
 }
-- 
1.7.9.5

