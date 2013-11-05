Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:53639 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3KERRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:37 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so2828743bkh.20
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:36 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 12/19] cfg80211: add helper for calling CRDA
Date: Tue,  5 Nov 2013 09:18:10 -0800
Message-Id: <1383671897-7746-13-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181750_692966_44AF3A04)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the regulatory request process routines use the
same pattern.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ddccc9a..4619c74 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -462,6 +462,14 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
 }
 
+static enum reg_request_treatment
+reg_call_crda(struct regulatory_request *request)
+{
+	if (call_crda(request->alpha2))
+		return REG_REQ_IGNORE;
+	return REG_REQ_OK;
+}
+
 bool reg_is_valid_request(const char *alpha2)
 {
 	struct regulatory_request *lr = get_last_request();
@@ -1371,9 +1379,7 @@ reg_process_hint_core(struct regulatory_request *core_request)
 
 	reg_update_last_request(core_request);
 
-	if (call_crda(core_request->alpha2))
-		return REG_REQ_IGNORE;
-	return REG_REQ_OK;
+	return reg_call_crda(core_request);
 }
 
 static enum reg_request_treatment
@@ -1441,9 +1447,7 @@ reg_process_hint_user(struct regulatory_request *user_request)
 	user_alpha2[0] = user_request->alpha2[0];
 	user_alpha2[1] = user_request->alpha2[1];
 
-	if (call_crda(user_request->alpha2))
-		return REG_REQ_IGNORE;
-	return REG_REQ_OK;
+	return reg_call_crda(user_request);
 }
 
 static enum reg_request_treatment
@@ -1521,9 +1525,7 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		return treatment;
 	}
 
-	if (call_crda(driver_request->alpha2))
-		return REG_REQ_IGNORE;
-	return REG_REQ_OK;
+	return reg_call_crda(driver_request);
 }
 
 static enum reg_request_treatment
@@ -1608,9 +1610,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 
 	reg_update_last_request(country_ie_request);
 
-	if (call_crda(country_ie_request->alpha2))
-		return REG_REQ_IGNORE;
-	return REG_REQ_OK;
+	return reg_call_crda(country_ie_request);
 }
 
 /* This processes *all* regulatory hints */
-- 
1.8.4.rc3

