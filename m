Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40767 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1DERtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:49:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 10:48:45 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <gregoryx.alagnou@intel.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 2/2] cfg80211: add a timer for invalid user reg hints
Date: Tue, 5 Apr 2011 10:49:04 -0700
Message-ID: <1302025744-824-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1302025744-824-1-git-send-email-lrodriguez@atheros.com>
References: <1302025744-824-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have no other option but to inform userspace that we
have queued up their regulatory hint request when we are
given one given that nl80211 operates atomically on user
requests. The best we can do is accept the request, and
add a delayed work item for processing failure and cancel it
if we succeeed. Upon failure we restore the regulatory
settings and ignore the user input.

This fixes this reported bug:

https://bugzilla.kernel.org/show_bug.cgi?id=28112

Reported-by: gregoryx.alagnou@intel.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
v5:
Just resending both to be clear, no further feedback has been
provided, I think these are ready.

v4:
didn't exist

v3:
The slight modification here was we did the part 1 to this
patch as a separate fix and then I moved the delayed work
scheduling call to reg_process_hint() instead of the user
reg hint call, given that when we restore regulatory we
want to also trigger the delay timer check.

 net/wireless/reg.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e759204..2480bfd 100644
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
@@ -1440,8 +1446,17 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	r = __regulatory_hint(wiphy, reg_request);
 	/* This is required so that the orig_* parameters are saved */
 	if (r == -EALREADY && wiphy &&
-	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
 		wiphy_update_regulatory(wiphy, initiator);
+		return;
+	}
+
+	/*
+	 * We only time out user hints, given that they should be the only
+	 * source of bogus requests.
+	 */
+	if (reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
+		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 }
 
 /*
@@ -2169,6 +2184,13 @@ out:
 	mutex_unlock(&reg_mutex);
 }
 
+static void reg_timeout_work(struct work_struct *work)
+{
+	REG_DBG_PRINT("Timeout while waiting for CRDA to reply, "
+		      "restoring regulatory settings");
+	restore_regulatory_settings(true);
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
@@ -2222,6 +2244,7 @@ void /* __init_or_exit */ regulatory_exit(void)
 	struct reg_beacon *reg_beacon, *btmp;
 
 	cancel_work_sync(&reg_work);
+	cancel_delayed_work_sync(&reg_timeout);
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
-- 
1.7.4.15.g7811d

