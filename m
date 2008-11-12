Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13748 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYKLWWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 14:22:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 06/10] cfg80211: call_crda() won't tell us if CRDA was present
Date: Wed, 12 Nov 2008 14:22:00 -0800
Message-ID: <1226528524-32678-7-git-send-email-lrodriguez@atheros.com> (sfid-20081112_232219_799077_36292D60)
In-Reply-To: <1226528524-32678-6-git-send-email-lrodriguez@atheros.com>
References: <1226528524-32678-1-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-2-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-3-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-4-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-5-git-send-email-lrodriguez@atheros.com>
 <1226528524-32678-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kobject_uevent_env() can return an error but it just tells us
if the uvent was built/sent or not, it doesn't tell us anything
about what happened in userspace, whether the udev rule was present
nor does it tell us if CRDA was present or not. So remove
the informative complaint about it assuming it will tell us
such things.

Note that you can determine if CRDA is present after loading cfg80211
by using:

is_old_static_regdom(cfg80211_regdomain)

but this doesn't account for possible user install after initial
boot, and also for when the user uses the static EU regulatory
domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f062b8b..f8e7beb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -711,14 +711,7 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 
 	kfree(last_request);
 	last_request = request;
-	r = call_crda(alpha2);
-
-#ifndef CONFIG_WIRELESS_OLD_REGULATORY
-	if (r)
-		printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
-#endif
-
-	return r;
+	return call_crda(alpha2);
 }
 
 void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
-- 
1.5.6.3

