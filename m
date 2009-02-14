Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27451 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbZBNFej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:39 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: [PATCH 06/10] cfg80211: propagate -ENOMEM during regulatory_init()
Date: Fri, 13 Feb 2009 21:33:43 -0800
Message-ID: <1234589627-16977-7-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063443_384226_05C80A89)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling kobject_uevent_env() can fail mainly due to out of
memory conditions. We do not want to continue during such
conditions so propagate that as well instead of letting
cfg80211 load as if everything is peachy.

Additionally lets clarify that when CRDA is not called during
cfg80211's initialization _and_ if the error is not an -ENOMEM
its because kobject_uevent_env() failed to call CRDA, not because
CRDA failed. For those who want to find out why we also let you
do so by enabling the kernel config CONFIG_CFG80211_REG_DEBUG --
you'll get an actual stack trace.

So for now we'll treat non -ENOMEM kobject_uevent_env() failures as
non fatal during cfg80211's initialization.

CC: Greg KH <greg@kroah.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 679fded..47d5056 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1616,7 +1616,7 @@ void reg_device_remove(struct wiphy *wiphy)
 
 int regulatory_init(void)
 {
-	int err;
+	int err = 0;
 
 	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
 	if (IS_ERR(reg_pdev))
@@ -1637,14 +1637,24 @@ int regulatory_init(void)
 	cfg80211_regdomain = cfg80211_world_regdom;
 
 	err = regulatory_hint_core("00");
+#endif
 	if (err) {
 		if (err == -ENOMEM)
 			return err;
-		printk(KERN_ERR "cfg80211: calling CRDA failed - "
-		       "unable to update world regulatory domain, "
-		       "using static definition\n");
-	}
+		/*
+		 * N.B. kobject_uevent_env() can fail mainly for when we're out
+		 * memory which is handled and propagated appropriately above
+		 * but it can also fail during a netlink_broadcast() or during
+		 * early boot for call_usermodehelper(). For now treat these
+		 * errors as non-fatal.
+		 */
+		printk(KERN_ERR "cfg80211: kobject_uevent_env() was unable "
+			"to call CRDA during init");
+#ifdef CONFIG_CFG80211_REG_DEBUG
+		/* We want to find out exactly why when debugging */
+		WARN_ON(err);
 #endif
+	}
 
 	return 0;
 }
-- 
1.6.1.2.253.ga34a

