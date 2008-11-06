Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28767 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYKFUpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 15:45:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 12:45:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/3] cfg80211: call_crda() won't tell us if CRDA was present
Date: Thu, 6 Nov 2008 12:45:25 -0800
Message-ID: <1226004327-10290-2-git-send-email-lrodriguez@atheros.com> (sfid-20081106_214539_018811_20C6396B)
In-Reply-To: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
References: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com>
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

