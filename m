Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64241 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbYKECuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:11 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] cfg80211: remove switch from __regulatory_hint()
Date: Tue, 4 Nov 2008 18:50:01 -0800
Message-ID: <1225853406-16322-3-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035024_346557_BD3AB9DB)
In-Reply-To: <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
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

