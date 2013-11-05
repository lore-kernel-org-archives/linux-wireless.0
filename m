Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:54730 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3KERRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:47 -0500
Received: by mail-bk0-f44.google.com with SMTP id mx11so1064136bkb.31
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:46 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 17/19] cfg80211: set user regulatory updates on its own
Date: Tue,  5 Nov 2013 09:18:15 -0800
Message-Id: <1383671897-7746-18-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181753_779481_BA7384DC)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits out the user regulatory update on its
own, this helps simplify reading the case.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index cb20ccc..fa3bcbe 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2196,6 +2196,39 @@ static int reg_set_rd_core(const struct ieee80211_regdomain *rd)
 	return 0;
 }
 
+static int reg_set_rd_user(const struct ieee80211_regdomain *rd,
+			   struct regulatory_request *user_request)
+{
+	const struct ieee80211_regdomain *intersected_rd = NULL;
+
+	if (is_world_regdom(rd->alpha2))
+		return -EINVAL;
+
+	if (!regdom_changes(rd->alpha2))
+		return -EALREADY;
+
+	if (!is_valid_rd(rd)) {
+		pr_err("Invalid regulatory domain detected:\n");
+		print_regdomain_info(rd);
+		return -EINVAL;
+	}
+
+	if (!user_request->intersect) {
+		reset_regdomains(false, rd);
+		return 0;
+	}
+
+	intersected_rd = regdom_intersect(rd, get_cfg80211_regdom());
+	if (!intersected_rd)
+		return -EINVAL;
+
+	kfree(rd);
+	rd = NULL;
+	reset_regdomains(false, intersected_rd);
+
+	return 0;
+}
+
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd,
 			struct regulatory_request *lr)
@@ -2326,6 +2359,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 		r = reg_set_rd_core(rd);
 		break;
 	case NL80211_REGDOM_SET_BY_USER:
+		r = reg_set_rd_user(rd, lr);
+		break;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		r = __set_regdom(rd, lr);
-- 
1.8.4.rc3

