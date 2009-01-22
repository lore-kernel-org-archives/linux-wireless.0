Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42513 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbZAVXGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 05/12] cfg80211: process user requests only after previous user/driver/core requests
Date: Thu, 22 Jan 2009 15:05:47 -0800
Message-ID: <1232665554-26132-6-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000705_024972_D915DB6F)
In-Reply-To: <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-4-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents user regulatory changes to be considered prior to previous
pending user, core or driver requests which have not be applied.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c744788..1ff1a05 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1099,6 +1099,16 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_USER &&
 			  last_request->intersect)
 			return -EOPNOTSUPP;
+		/* Process user requests only after previous user/driver/core
+		 * requests have been processed */
+		if (last_request->initiator == REGDOM_SET_BY_CORE ||
+		    last_request->initiator == REGDOM_SET_BY_DRIVER ||
+		    last_request->initiator == REGDOM_SET_BY_USER) {
+			if (!alpha2_equal(last_request->alpha2,
+			    cfg80211_regdomain->alpha2))
+				return -EAGAIN;
+		}
+
 		return 0;
 	}
 
-- 
1.6.1.rc3.51.g5832d

