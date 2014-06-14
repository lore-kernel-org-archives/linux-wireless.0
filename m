Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45827 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaFNUms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 16:42:48 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so3198364pab.22
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 13:42:48 -0700 (PDT)
From: mihirsht@gmail.com
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@do-not-panic.com
Cc: Mihir Shete <mihirsht@gmail.com>
Subject: [PATCH] cfg80211: unblock user hint when cfg80211_regdom is intersected
Date: Sun, 15 Jun 2014 02:12:16 +0530
Message-Id: <1402778536-31305-1-git-send-email-mihirsht@gmail.com> (sfid-20140614_224401_614498_2D0D7D8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mihir Shete <mihirsht@gmail.com>

User hints are always ignored if cfg80211_regdom is intersected.
Add checks to make sure that user hints are processed if the
previous hints are done processing.

Signed-off-by: Mihir Shete <mihirsht@gmail.com>
---
 net/wireless/reg.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b4973bc..2c4e2ba 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -396,6 +396,14 @@ static bool regdom_changes(const char *alpha2)
 	return !alpha2_equal(r->alpha2, alpha2);
 }
 
+static bool is_cfg80211_regdom_intersected(void)
+{
+	const struct ieee80211_regdomain *r = get_cfg80211_regdom();
+
+	if (!r)
+		return false;
+	return is_intersected_alpha2(r->alpha2);
+}
 /*
  * The NL80211_REGDOM_SET_BY_USER regdom alpha2 is cached, this lets
  * you know if a valid regulatory hint with NL80211_REGDOM_SET_BY_USER
@@ -1650,9 +1658,14 @@ __reg_process_hint_user(struct regulatory_request *user_request)
 	 */
 	if ((lr->initiator == NL80211_REGDOM_SET_BY_CORE ||
 	     lr->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
-	     lr->initiator == NL80211_REGDOM_SET_BY_USER) &&
-	    regdom_changes(lr->alpha2))
-		return REG_REQ_IGNORE;
+	     lr->initiator == NL80211_REGDOM_SET_BY_USER)) {
+		if (lr->intersect) {
+			if (!is_cfg80211_regdom_intersected())
+				return REG_REQ_IGNORE;
+		} else if (regdom_changes(lr->alpha2)) {
+			return REG_REQ_IGNORE;
+		}
+	}
 
 	if (!regdom_changes(user_request->alpha2))
 		return REG_REQ_ALREADY_SET;
-- 
1.8.2.1

