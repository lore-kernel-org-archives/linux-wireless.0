Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49894 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KERRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:43 -0500
Received: by mail-bk0-f53.google.com with SMTP id w11so3005839bkz.40
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:42 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 15/19] cfg80211: pass the last_request to __set_regdom()
Date: Tue,  5 Nov 2013 09:18:13 -0800
Message-Id: <1383671897-7746-16-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181752_585269_DFAA4D98)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

last_request is RCU protected, since we're getting it
on set_regdom() we might as well pass it to ensure the
same request is being processed, otherwise there is a
small race it could have changed. This makes processing
of the request atomic.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e77ae8d..dc99f3e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2189,12 +2189,12 @@ static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 }
 
 /* Takes ownership of rd only if it doesn't fail */
-static int __set_regdom(const struct ieee80211_regdomain *rd)
+static int __set_regdom(const struct ieee80211_regdomain *rd,
+			struct regulatory_request *lr)
 {
 	const struct ieee80211_regdomain *regd;
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 	struct wiphy *request_wiphy;
-	struct regulatory_request *lr = get_last_request();
 
 	/* Some basic sanity checks first */
 
@@ -2320,7 +2320,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	lr = get_last_request();
 
 	/* Note that this doesn't update the wiphys, this is done below */
-	r = __set_regdom(rd);
+	r = __set_regdom(rd, lr);
 	if (r) {
 		if (r == -EALREADY)
 			reg_set_request_processed();
-- 
1.8.4.rc3

