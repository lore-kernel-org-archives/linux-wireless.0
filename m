Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZBRXZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:25:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH v4 06/15] cfg80211: propagate -ENOMEM during regulatory_init()
Date: Wed, 18 Feb 2009 18:25:36 -0500
Message-Id: <1234999545-14357-7-git-send-email-lrodriguez@atheros.com> (sfid-20090219_005317_760135_CF21B89D)
In-Reply-To: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
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
 net/wireless/reg.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6373a78..47d5056 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1616,7 +1616,7 @@ void reg_device_remove(struct wiphy *wiphy)
 
 int regulatory_init(void)
 {
-	int err;
+	int err = 0;
 
 	reg_pdev = platform_device_register_simple("regulatory", 0, NULL, 0);
 	if (IS_ERR(reg_pdev))
@@ -1637,12 +1637,24 @@ int regulatory_init(void)
 	cfg80211_regdomain = cfg80211_world_regdom;
 
 	err = regulatory_hint_core("00");
+#endif
 	if (err) {
-		printk(KERN_ERR "cfg80211: calling CRDA failed - "
-		       "unable to update world regulatory domain, "
-		       "using static definition\n");
-	}
+		if (err == -ENOMEM)
+			return err;
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
1.6.0.3

