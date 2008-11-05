Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64251 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYKECuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] cfg80211: remove switch from __set_regdom()
Date: Tue, 4 Nov 2008 18:50:02 -0800
Message-ID: <1225853406-16322-4-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035023_880534_E90A5641)
In-Reply-To: <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have control over the REGDOM_SET_BY_* macros passed
so remove the switch.

This patch has no functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e44f005..290ecec 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -829,21 +829,12 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	reset_regdomains();
 
 	/* Country IE parsing coming soon */
-	switch (last_request->initiator) {
-	case REGDOM_SET_BY_CORE:
-	case REGDOM_SET_BY_DRIVER:
-	case REGDOM_SET_BY_USER:
-		if (!is_valid_rd(rd)) {
-			printk(KERN_ERR "cfg80211: Invalid "
-				"regulatory domain detected:\n");
-			print_regdomain_info(rd);
-			return -EINVAL;
-		}
-		break;
-	case REGDOM_SET_BY_COUNTRY_IE: /* Not yet */
-		WARN_ON(1);
-	default:
-		return -EOPNOTSUPP;
+
+	if (!is_valid_rd(rd)) {
+		printk(KERN_ERR "cfg80211: Invalid "
+			"regulatory domain detected:\n");
+		print_regdomain_info(rd);
+		return -EINVAL;
 	}
 
 	if (unlikely(last_request->intersect)) {
-- 
1.5.6.3

