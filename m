Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46498 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaDVDjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 23:39:48 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so4436303pab.38
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 20:39:48 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, lkml20140418@newton.leun.net,
	arik@wizery.com, linux@eikelenboom.it,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 1/2] cfg80211: avoid freeing last_request while in flight
Date: Mon, 21 Apr 2014 20:39:34 -0700
Message-Id: <1398137975-14275-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20140422_053952_446153_60B99368)
In-Reply-To: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Avoid freeing the last request while it is being processed. This can
happen in some cases if reg_work is kicked for some reason while the
currently pending request is in flight.

Cc: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/wireless/reg.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9d32633..081c571 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -263,8 +263,16 @@ static char user_alpha2[2];
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
-static void reg_free_request(struct regulatory_request *lr)
+static void reg_free_request(struct regulatory_request *request)
 {
+	if (request != get_last_request())
+		kfree(request);
+}
+
+static void reg_free_last_request(void)
+{
+	struct regulatory_request *lr = get_last_request();
+
 	if (lr != &core_request_world && lr)
 		kfree_rcu(lr, rcu_head);
 }
@@ -277,7 +285,7 @@ static void reg_update_last_request(struct regulatory_request *request)
 	if (lr == request)
 		return;
 
-	reg_free_request(lr);
+	reg_free_last_request();
 	rcu_assign_pointer(last_request, request);
 }
 
@@ -1661,7 +1669,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 	if (treatment == REG_REQ_IGNORE ||
 	    treatment == REG_REQ_ALREADY_SET ||
 	    treatment == REG_REQ_USER_HINT_HANDLED) {
-		kfree(user_request);
+		reg_free_request(user_request);
 		return treatment;
 	}
 
@@ -1722,14 +1730,14 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		break;
 	case REG_REQ_IGNORE:
 	case REG_REQ_USER_HINT_HANDLED:
-		kfree(driver_request);
+		reg_free_request(driver_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
 		regd = reg_copy_regd(get_cfg80211_regdom());
 		if (IS_ERR(regd)) {
-			kfree(driver_request);
+			reg_free_request(driver_request);
 			return REG_REQ_IGNORE;
 		}
 		rcu_assign_pointer(wiphy->regd, regd);
@@ -1824,10 +1832,10 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 	case REG_REQ_USER_HINT_HANDLED:
 		/* fall through */
 	case REG_REQ_ALREADY_SET:
-		kfree(country_ie_request);
+		reg_free_request(country_ie_request);
 		return treatment;
 	case REG_REQ_INTERSECT:
-		kfree(country_ie_request);
+		reg_free_request(country_ie_request);
 		/*
 		 * This doesn't happen yet, not sure we
 		 * ever want to support it for this case.
@@ -1888,7 +1896,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	return;
 
 out_free:
-	kfree(reg_request);
+	reg_free_request(reg_request);
 }
 
 /*
-- 
1.9.0

