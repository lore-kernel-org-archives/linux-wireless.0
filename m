Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:36252 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBNHyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 02:54:20 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so4936583eaj.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 23:54:19 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] cfg80211: regulatory, reset regdomain in case of error
Date: Fri, 14 Feb 2014 08:54:00 +0100
Message-Id: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140214_085424_407118_7CE44ABE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reset regdomain to world regdomain in case
of errors in set_regdom() function.

This will fix a problem with such scenario:
- iw reg set US
- iw reg set 00
- iw reg set US
The last step always fail and we get deadlock
in kernel regulatory code. Next setting new
regulatory wasn't possible due to:

Pending regulatory request, waiting for it to be processed...

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/reg.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c80f20e..c4c3af1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2504,6 +2504,7 @@ static int reg_set_rd_country_ie(const struct ieee80211_regdomain *rd,
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	struct regulatory_request *lr;
+	bool user_reset = false;
 	int r;
 
 	if (!reg_is_valid_request(rd->alpha2)) {
@@ -2520,6 +2521,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 		break;
 	case NL80211_REGDOM_SET_BY_USER:
 		r = reg_set_rd_user(rd, lr);
+		user_reset = true;
 		break;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		r = reg_set_rd_driver(rd, lr);
@@ -2533,8 +2535,14 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	if (r) {
-		if (r == -EALREADY)
+		switch (r) {
+		case -EALREADY:
 			reg_set_request_processed();
+			break;
+		default:
+			/* Back to world regulatory in case of errors */
+			restore_regulatory_settings(user_reset);
+		}
 
 		kfree(rd);
 		return r;
-- 
1.7.9.5

