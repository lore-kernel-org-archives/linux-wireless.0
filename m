Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1KWCcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 21:32:04 -0500
Subject: [PATCH] cfg80211: Fix changing regulatory from userspace
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
From: Timo Lindhorst <tlnd@online.de>
Date: Wed, 23 Nov 2011 03:30:10 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201111230330.11103.tlnd@online.de> (sfid-20111123_033208_463849_FB5198A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit de3584bd62d87b4c250129fbc46ca52c80330add -
"cfg80211: fix regulatory NULL dereference" prevents the regulatory
domain from being changed by user space. A wiphy is only present
if the request comes from driver or is set by country IE, thus
check only those cases.

Signed-off-by: Timo Lindhorst <tlnd@online.de>
---
 net/wireless/reg.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 76b35df..c9588ae 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2076,7 +2076,9 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
-	if (!request_wiphy) {
+	if (((last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER) ||
+	     (last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) &&
+	    !request_wiphy) {
 		reg_set_request_processed();
 		return -ENODEV;
 	}
-- 
1.7.7.3

