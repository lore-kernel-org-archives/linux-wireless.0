Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36783 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0EUKmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 06:42:45 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4LAfbFp015186
	for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 05:42:44 -0500
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4LAfxov017222
	for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 13:42:01 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 1/1] cfg80211: Fix user-space crda query stall
Date: Fri, 21 May 2010 13:42:19 +0300
Message-Id: <1274438539-11259-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1274438539-11259-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274438539-11259-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The userspace crda utility can fail to respond to kernel requests in (at least)
two scenarios: it is not runnable for any reason, or it is invoked with a
country code not in its database.

When the userspace crda utility fails to respond to kernel requests (i.e. it
does not use NL80211_CMD_SET_REG to provide the kernel regulatory information
for the requested country) the kernel crda subsystem will stall. It will
refuse to process any further regulatory hints. This is easiest demonstrated
by using for instance the "iw" tool:

   iw reg set EU
   iw reg set US

"EU" is not a country code present in the database, so user space crda will
not respond. Attempting to define US after that will be silently ignored
(internally, an -EAGAIN is the result, as the "EU" request is still
"being processed".)

To fix this issue, this patch implements timeout protection for the userspace
crda invocation. If there is no response for five seconds, the crda code will
force itself to the world regulatory domain for maximum safety.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/reg.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8f0d97d..6e72f90 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -385,6 +385,41 @@ static inline void reg_regdb_query(const char *alpha2) {}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
 /*
+ * This gets invoked if crda in userspace is not responding (it's not getting
+ * executed or the country code in the hint is not in the database.
+ */
+
+static void call_crda_timeout_work(struct work_struct *work)
+{
+	if (!last_request)
+		return;
+
+	printk(KERN_INFO "cfg80211: Call crda daemon timed out for country: "
+	       "%c%c\n", last_request->alpha2[0], last_request->alpha2[1]);
+
+	mutex_lock(&cfg80211_mutex);
+
+	/*
+	 * As we are not getting data for the current country, force us back
+	 * to the world regdomain.
+	 */
+	last_request->alpha2[0] = '0';
+	last_request->alpha2[1] = '0';
+	set_regdom(cfg80211_world_regdom);
+	mutex_unlock(&cfg80211_mutex);
+}
+
+static DECLARE_WORK(crda_uevent_timeout_work, call_crda_timeout_work);
+
+#define CRDA_UEVENT_TIMEOUT 5000
+static void crda_uevent_timeout(unsigned long data)
+{
+	schedule_work(&crda_uevent_timeout_work);
+}
+
+static DEFINE_TIMER(crda_uevent_timer, crda_uevent_timeout, 0, 0);
+
+/*
  * This lets us keep regulatory code which is updated on a regulatory
  * basis in userspace.
  */
@@ -409,6 +444,10 @@ static int call_crda(const char *alpha2)
 	country_env[8] = alpha2[0];
 	country_env[9] = alpha2[1];
 
+	/* start timeout timer */
+	mod_timer(&crda_uevent_timer,
+		  jiffies + msecs_to_jiffies(CRDA_UEVENT_TIMEOUT));
+
 	return kobject_uevent_env(&reg_pdev->dev.kobj, KOBJ_CHANGE, envp);
 }
 
@@ -2581,6 +2620,9 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	assert_cfg80211_lock();
 
+	/* cancel timeout */
+	del_timer(&crda_uevent_timer);
+
 	mutex_lock(&reg_mutex);
 
 	/* Note that this doesn't update the wiphys, this is done below */
@@ -2683,6 +2725,9 @@ void regulatory_exit(void)
 
 	cancel_work_sync(&reg_work);
 
+	del_timer_sync(&crda_uevent_timer);
+	cancel_work_sync(&crda_uevent_timeout_work);
+
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
-- 
1.6.3.3

