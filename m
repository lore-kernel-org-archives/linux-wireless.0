Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C689AC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 20:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9960C2083B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 20:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfBEUHF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:07:05 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40838 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfBEUHE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 15:07:04 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gr6zl-0006X7-B9; Tue, 05 Feb 2019 21:07:01 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: restore regulatory without calling userspace
Date:   Tue,  5 Feb 2019 21:06:58 +0100
Message-Id: <20190205200658.9320-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Jouni reports that in some cases it is possible that getting
disconnected (or stopping AP, after previous patches) results
in further operations hitting the window within the regulatory
core restoring the regdomain to the defaults. The reason for
this is that we have to call out to CRDA or otherwise do some
asynchronous work, and thus can't do the restore atomically.

However, we've previously seen all the data we need to do the
restore, so we can hang on to that data and use it later for
the restore. This makes the whole thing happen within a single
locked section and thus atomic.

However, we can't *always* do this - there are unfortunately
cases where the restore needs to re-request, because this is
also used (abused?) as an error recovery process, so make the
new behaviour optional and only use it when doing a regular
restore as described above.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 70 ++++++++++++++++++++++++++++++++++++----------
 net/wireless/reg.h |  1 +
 2 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dd58b9909ac9..d35bb51e03a4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -131,7 +131,8 @@ static spinlock_t reg_indoor_lock;
 /* Used to track the userspace process controlling the indoor setting */
 static u32 reg_is_indoor_portid;
 
-static void restore_regulatory_settings(bool reset_user);
+static void restore_regulatory_settings(bool reset_user, bool cached);
+static void print_regdomain(const struct ieee80211_regdomain *rd);
 
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
@@ -263,6 +264,7 @@ static const struct ieee80211_regdomain *cfg80211_world_regdom =
 
 static char *ieee80211_regdom = "00";
 static char user_alpha2[2];
+static const struct ieee80211_regdomain *cfg80211_user_regdom;
 
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
@@ -445,6 +447,15 @@ reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 	return regd;
 }
 
+static void cfg80211_save_user_regdom(const struct ieee80211_regdomain *rd)
+{
+	ASSERT_RTNL();
+
+	if (!IS_ERR(cfg80211_user_regdom))
+		kfree(cfg80211_user_regdom);
+	cfg80211_user_regdom = reg_copy_regd(rd);
+}
+
 struct reg_regdb_apply_request {
 	struct list_head list;
 	const struct ieee80211_regdomain *regdom;
@@ -510,7 +521,7 @@ static void crda_timeout_work(struct work_struct *work)
 	pr_debug("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
 	rtnl_lock();
 	reg_crda_timeouts++;
-	restore_regulatory_settings(true);
+	restore_regulatory_settings(true, false);
 	rtnl_unlock();
 }
 
@@ -1044,7 +1055,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	if (restore)
-		restore_regulatory_settings(true);
+		restore_regulatory_settings(true, false);
 
 	rtnl_unlock();
 
@@ -3119,7 +3130,7 @@ static void restore_custom_reg_settings(struct wiphy *wiphy)
  * keep their own regulatory domain on wiphy->regd so that does does
  * not need to be remembered.
  */
-static void restore_regulatory_settings(bool reset_user)
+static void restore_regulatory_settings(bool reset_user, bool cached)
 {
 	char alpha2[2];
 	char world_alpha2[2];
@@ -3178,15 +3189,40 @@ static void restore_regulatory_settings(bool reset_user)
 			restore_custom_reg_settings(&rdev->wiphy);
 	}
 
-	regulatory_hint_core(world_alpha2);
+	if (cached && is_an_alpha2(alpha2) &&
+	    !IS_ERR_OR_NULL(cfg80211_user_regdom)) {
+		reset_regdomains(false, cfg80211_world_regdom);
+		update_all_wiphy_regulatory(NL80211_REGDOM_SET_BY_CORE);
+		print_regdomain(get_cfg80211_regdom());
+		nl80211_send_reg_change_event(&core_request_world);
+		reg_set_request_processed();
 
-	/*
-	 * This restores the ieee80211_regdom module parameter
-	 * preference or the last user requested regulatory
-	 * settings, user regulatory settings takes precedence.
-	 */
-	if (is_an_alpha2(alpha2))
-		regulatory_hint_user(alpha2, NL80211_USER_REG_HINT_USER);
+		if (!regulatory_hint_user(alpha2, NL80211_USER_REG_HINT_USER)) {
+			struct regulatory_request *ureq;
+
+			spin_lock(&reg_requests_lock);
+			ureq = list_last_entry(&reg_requests_list,
+					       struct regulatory_request,
+					       list);
+			list_del(&ureq->list);
+			spin_unlock(&reg_requests_lock);
+
+			notify_self_managed_wiphys(ureq);
+			reg_update_last_request(ureq);
+			set_regdom(reg_copy_regd(cfg80211_user_regdom),
+				   REGD_SOURCE_CACHED);
+		}
+	} else {
+		regulatory_hint_core(world_alpha2);
+
+		/*
+		 * This restores the ieee80211_regdom module parameter
+		 * preference or the last user requested regulatory
+		 * settings, user regulatory settings takes precedence.
+		 */
+		if (is_an_alpha2(alpha2))
+			regulatory_hint_user(alpha2, NL80211_USER_REG_HINT_USER);
+	}
 
 	spin_lock(&reg_requests_lock);
 	list_splice_tail_init(&tmp_reg_req_list, &reg_requests_list);
@@ -3246,7 +3282,7 @@ void regulatory_hint_disconnect(void)
 	}
 
 	pr_debug("All devices are disconnected, going to restore regulatory settings\n");
-	restore_regulatory_settings(false);
+	restore_regulatory_settings(false, true);
 }
 
 static bool freq_is_chan_12_13_14(u32 freq)
@@ -3563,6 +3599,9 @@ int set_regdom(const struct ieee80211_regdomain *rd,
 	bool user_reset = false;
 	int r;
 
+	if (IS_ERR_OR_NULL(rd))
+		return -ENODATA;
+
 	if (!reg_is_valid_request(rd->alpha2)) {
 		kfree(rd);
 		return -EINVAL;
@@ -3579,6 +3618,7 @@ int set_regdom(const struct ieee80211_regdomain *rd,
 		r = reg_set_rd_core(rd);
 		break;
 	case NL80211_REGDOM_SET_BY_USER:
+		cfg80211_save_user_regdom(rd);
 		r = reg_set_rd_user(rd, lr);
 		user_reset = true;
 		break;
@@ -3601,7 +3641,7 @@ int set_regdom(const struct ieee80211_regdomain *rd,
 			break;
 		default:
 			/* Back to world regulatory in case of errors */
-			restore_regulatory_settings(user_reset);
+			restore_regulatory_settings(user_reset, false);
 		}
 
 		kfree(rd);
@@ -3937,6 +3977,8 @@ void regulatory_exit(void)
 
 	if (!IS_ERR_OR_NULL(regdb))
 		kfree(regdb);
+	if (!IS_ERR_OR_NULL(cfg80211_user_regdom))
+		kfree(cfg80211_user_regdom);
 
 	free_regdb_keyring();
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9ceeb5f3a7cb..906a5a92f701 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -22,6 +22,7 @@
 enum ieee80211_regd_source {
 	REGD_SOURCE_INTERNAL_DB,
 	REGD_SOURCE_CRDA,
+	REGD_SOURCE_CACHED,
 };
 
 extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
-- 
2.17.2

