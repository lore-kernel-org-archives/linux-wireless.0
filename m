Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35860 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaLDKWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 05:22:15 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so34282116wiv.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 02:22:13 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>, stable@vger.kernel.org
Subject: [PATCH] cfg80211: avoid mem leak on driver hint set
Date: Thu,  4 Dec 2014 12:22:16 +0200
Message-Id: <1417688536-9145-1-git-send-email-arik@wizery.com> (sfid-20141204_112609_483659_B56E61C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the already-set and intersect case of a driver-hint, the previous
wiphy regdomain was not freed before being reset with a copy of the
cfg80211 regdomain.

Cc: stable@vger.kernel.org
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 net/wireless/reg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 004ea14..8941e1c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1916,7 +1916,7 @@ static enum reg_request_treatment
 reg_process_hint_driver(struct wiphy *wiphy,
 			struct regulatory_request *driver_request)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd, *tmp;
 	enum reg_request_treatment treatment;
 
 	treatment = __reg_process_hint_driver(driver_request);
@@ -1936,7 +1936,10 @@ reg_process_hint_driver(struct wiphy *wiphy,
 			reg_free_request(driver_request);
 			return REG_REQ_IGNORE;
 		}
+
+		tmp = get_wiphy_regdom(wiphy);
 		rcu_assign_pointer(wiphy->regd, regd);
+		rcu_free_regdom(tmp);
 	}
 
 
-- 
1.9.1

