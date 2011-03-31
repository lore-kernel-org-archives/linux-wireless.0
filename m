Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57057 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1CaWcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 18:32:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 15:31:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <gregoryx.alagnou@intel.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: add a timer for invalid user reg hints
Date: Thu, 31 Mar 2011 15:31:38 -0700
Message-ID: <1301610698-3688-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have no other option but to inform userspace that we have
queued up their regulatory hint request when we are given one
given that nl80211 operates atomically on user requests. The
best we can do is accept the request, and set a timer for processing
it. If the timer is hit we restore the regulatory settings and
ignore the user input.

This fixes this reported bug:

https://bugzilla.kernel.org/show_bug.cgi?id=28112

Reported-by: gregoryx.alagnou@intel.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3332d5b..62d9ea1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -42,6 +42,7 @@
 #include <linux/ctype.h>
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
+#include <linux/timer.h>
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
@@ -106,6 +107,10 @@ struct reg_beacon {
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
+static struct timer_list reg_timer;
+static void reg_timeout_work(struct work_struct *work);
+static DECLARE_WORK(reg_timeout, reg_timeout_work);
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 5,
@@ -1330,6 +1335,9 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
+	if (last_request->initiator == NL80211_REGDOM_SET_BY_USER)
+		del_timer_sync(&reg_timer);
+
 	if (need_more_processing)
 		schedule_work(&reg_work);
 }
@@ -1584,6 +1592,7 @@ int regulatory_hint_user(const char *alpha2)
 	request->initiator = NL80211_REGDOM_SET_BY_USER;
 
 	queue_regulatory_request(request);
+	mod_timer(&reg_timer, jiffies + msecs_to_jiffies(3142));
 
 	return 0;
 }
@@ -1787,7 +1796,6 @@ static void restore_regulatory_settings(bool reset_user)
 		regulatory_hint_user(user_alpha2);
 }
 
-
 void regulatory_hint_disconnect(void)
 {
 	REG_DBG_PRINT("All devices are disconnected, going to "
@@ -2125,6 +2133,18 @@ out:
 	mutex_unlock(&reg_mutex);
 }
 
+static void reg_timeout_work(struct work_struct *work)
+{
+	restore_regulatory_settings(true);
+}
+
+static void reg_set_failed_timer(unsigned long data)
+{
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply,"
+		      "restoring regulatory settings");
+	schedule_work(&reg_timeout);
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
@@ -2137,6 +2157,7 @@ int __init regulatory_init(void)
 
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
+	setup_timer(&reg_timer, reg_set_failed_timer, (unsigned long) NULL);
 
 	cfg80211_regdomain = cfg80211_world_regdom;
 
@@ -2178,6 +2199,8 @@ void /* __init_or_exit */ regulatory_exit(void)
 	struct reg_beacon *reg_beacon, *btmp;
 
 	cancel_work_sync(&reg_work);
+	cancel_work_sync(&reg_timeout);
+	del_timer_sync(&reg_timer);
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
-- 
1.7.4.15.g7811d

