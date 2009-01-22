Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42538 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759894AbZAVXHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:07:02 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:07:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 12/12] cfg80211: allow users to help a driver's compliance
Date: Thu, 22 Jan 2009 15:05:54 -0800
Message-ID: <1232665554-26132-13-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000710_341675_F2E37AAA)
In-Reply-To: <1232665554-26132-12-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-6-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-7-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-8-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-9-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-10-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-11-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-12-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let users be more compliant if so desired.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2da5427..f643d39 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -772,8 +772,9 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	regd = custom_regd ? custom_regd : cfg80211_regdomain;
 
 	/* Follow the driver's regulatory domain, if present, unless a country
-	 * IE has been processed */
+	 * IE has been processed or a user wants to help complaince further */
 	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
+	    last_request->initiator != REGDOM_SET_BY_USER &&
 	    wiphy->regd)
 		regd = wiphy->regd;
 
-- 
1.6.1.rc3.51.g5832d

