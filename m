Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63220 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CaXaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 19:30:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 16:29:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <gregoryx.alagnou@intel.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2] cfg80211: add work for processing invalid user reg hints
Date: Thu, 31 Mar 2011 16:29:40 -0700
Message-ID: <1301614180-5401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have no other option but to inform userspace that we
have queued up their regulatory hint request when we are
given one given that nl80211 operates atomically on user
requests. The best we can do is accept the request, and
add a delayed work item for processing failures and cancel it
if we succeeed. Upon failure we restore the regulatory
settings and ignore the supplied user input.

This fixes this reported bug:

https://bugzilla.kernel.org/show_bug.cgi?id=28112

Reported-by: gregoryx.alagnou@intel.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This simplifies the timer/work implementation by 9 lines :D

 net/wireless/reg.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3332d5b..cb917de 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -106,6 +106,9 @@ struct reg_beacon {
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
+static void reg_timeout_work(struct work_struct *work);
+static DECLARE_DELAYED_WORK(reg_timeout, reg_timeout_work);
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 5,
@@ -1330,6 +1333,9 @@ static void reg_set_request_processed(void)
 		need_more_processing = true;
 	spin_unlock(&reg_requests_lock);
 
+	if (last_request->initiator == NL80211_REGDOM_SET_BY_USER)
+		cancel_delayed_work_sync(&reg_timeout);
+
 	if (need_more_processing)
 		schedule_work(&reg_work);
 }
@@ -1584,6 +1590,7 @@ int regulatory_hint_user(const char *alpha2)
 	request->initiator = NL80211_REGDOM_SET_BY_USER;
 
 	queue_regulatory_request(request);
+	schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 
 	return 0;
 }
@@ -1787,7 +1794,6 @@ static void restore_regulatory_settings(bool reset_user)
 		regulatory_hint_user(user_alpha2);
 }
 
-
 void regulatory_hint_disconnect(void)
 {
 	REG_DBG_PRINT("All devices are disconnected, going to "
@@ -2125,6 +2131,13 @@ out:
 	mutex_unlock(&reg_mutex);
 }
 
+static void reg_timeout_work(struct work_struct *work)
+{
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply,"
+		      "restoring regulatory settings");
+	restore_regulatory_settings(true);
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
@@ -2178,6 +2191,7 @@ void /* __init_or_exit */ regulatory_exit(void)
 	struct reg_beacon *reg_beacon, *btmp;
 
 	cancel_work_sync(&reg_work);
+	cancel_delayed_work_sync(&reg_timeout);
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
-- 
1.7.4.15.g7811d

