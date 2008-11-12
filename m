Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13715 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYKLWWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 02/10] cfg80211: remove switch from __regulatory_hint()
Date: Wed, 12 Nov 2008 14:21:56 -0800
Message-ID: <1226528524-32678-3-git-send-email-lrodriguez@atheros.com> (sfid-20081112_232214_613821_51D55029)
In-Reply-To: <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have complete control over REGDOM_SET_BY_* enum passed
down to __regulatory_hint() as such there is no need to
account for unexpected REGDOM_SET_BY_*'s, lets just remove
the switch statement as this code does not change and
won't change even when we add 802.11d support.

This patch has no functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |   43 +++++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7a2ce27..e44f005 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -698,34 +698,25 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	else if (r)
 		return r;
 
-	switch (set_by) {
-	case REGDOM_SET_BY_CORE:
-	case REGDOM_SET_BY_COUNTRY_IE:
-	case REGDOM_SET_BY_DRIVER:
-	case REGDOM_SET_BY_USER:
-		request = kzalloc(sizeof(struct regulatory_request),
-				  GFP_KERNEL);
-		if (!request)
-			return -ENOMEM;
-
-		request->alpha2[0] = alpha2[0];
-		request->alpha2[1] = alpha2[1];
-		request->initiator = set_by;
-		request->wiphy = wiphy;
-		request->intersect = intersect;
-
-		kfree(last_request);
-		last_request = request;
-		r = call_crda(alpha2);
+	request = kzalloc(sizeof(struct regulatory_request),
+			  GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->alpha2[0] = alpha2[0];
+	request->alpha2[1] = alpha2[1];
+	request->initiator = set_by;
+	request->wiphy = wiphy;
+	request->intersect = intersect;
+
+	kfree(last_request);
+	last_request = request;
+	r = call_crda(alpha2);
+
 #ifndef CONFIG_WIRELESS_OLD_REGULATORY
-		if (r)
-			printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
+	if (r)
+		printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
 #endif
-		break;
-	default:
-		r = -ENOTSUPP;
-		break;
-	}
 
 	return r;
 }
-- 
1.5.6.3

