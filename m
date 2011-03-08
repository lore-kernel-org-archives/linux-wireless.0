Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55647 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1CHSp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 13:45:59 -0500
Received: by ywj3 with SMTP id 3so2087439ywj.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 10:45:59 -0800 (PST)
From: Scott James Remnant <scott@netsplit.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Sam Leffler <sleffler@chromium.org>, keybuk@google.com,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH] net/wireless: add COUNTRY to to regulatory device uevent
Date: Tue,  8 Mar 2011 10:45:30 -0800
Message-Id: <1299609930-14011-1-git-send-email-scott@netsplit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Scott James Remnant <keybuk@google.com>

Regulatory devices issue change uevents to inform userspace of a need
to call the crda tool; however these can often be sent before udevd is
running, and were not previously included in the results of
udevadm trigger (which requests a new change event using the /uevent
attribute of the sysfs object).

Add a uevent function to the device type which includes the COUNTRY
information from the last request if it has yet to be processed, the
case of multiple requests is already handled in the code by checking
whether an unprocessed one is queued in the same manner and refusing
to queue a new one.

The existing udev rule continues to work as before.

Signed-off-by: Scott James Remnant <keybuk@google.com>
Acked-By: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/wireless/reg.c |   39 ++++++++++++++++++++++++++++-----------
 net/wireless/reg.h |    1 +
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 37693b6..de71c22 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -63,6 +63,10 @@ static struct regulatory_request *last_request;
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
 
+static struct device_type reg_device_type = {
+	.uevent = reg_device_uevent,
+};
+
 /*
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
@@ -362,16 +366,11 @@ static inline void reg_regdb_query(const char *alpha2) {}
 
 /*
  * This lets us keep regulatory code which is updated on a regulatory
- * basis in userspace.
+ * basis in userspace. Country information is filled in by
+ * reg_device_uevent
  */
 static int call_crda(const char *alpha2)
 {
-	char country_env[9 + 2] = "COUNTRY=";
-	char *envp[] = {
-		country_env,
-		NULL
-	};
-
 	if (!is_world_regdom((char *) alpha2))
 		pr_info("Calling CRDA for country: %c%c\n",
 			alpha2[0], alpha2[1]);
@@ -381,10 +380,7 @@ static int call_crda(const char *alpha2)
 	/* query internal regulatory database (if it exists) */
 	reg_regdb_query(alpha2);
 
-	country_env[8] = alpha2[0];
-	country_env[9] = alpha2[1];
-
-	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
+	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
 }
 
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
@@ -2087,6 +2083,25 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return r;
 }
 
+#ifdef CONFIG_HOTPLUG
+int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	if (last_request && !last_request->processed) {
+		if (add_uevent_var(env, "COUNTRY=%c%c",
+				   last_request->alpha2[0],
+				   last_request->alpha2[1]))
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+#else
+int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_HOTPLUG */
+
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
@@ -2118,6 +2133,8 @@ int __init regulatory_init(void)
 	if (IS_ERR(reg_pdev))
 		return PTR_ERR(reg_pdev);
 
+	reg_pdev->dev.type = &reg_device_type;
+
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index c4695d0..b67d1c3 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -8,6 +8,7 @@ bool reg_is_valid_request(const char *alpha2);
 
 int regulatory_hint_user(const char *alpha2);
 
+int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 void reg_device_remove(struct wiphy *wiphy);
 
 int __init regulatory_init(void);
-- 
1.7.3.1

