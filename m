Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19408 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbZAMT6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] cfg80211: process user requests only after previous user/driver/core requests
Date: Tue, 13 Jan 2009 11:57:53 -0800
Message-ID: <1231876675-20518-11-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205849_711488_ECD932B0)
In-Reply-To: <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-9-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-10-git-send-email-lrodriguez@atheros.com>
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
index 12a547a..460411d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1082,6 +1082,16 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_USER &&
 			  last_request->intersect)
 			return -EOPNOTSUPP;
+		if (last_request->initiator == REGDOM_SET_BY_CORE ||
+		    last_request->initiator == REGDOM_SET_BY_DRIVER ||
+		    last_request->initiator == REGDOM_SET_BY_USER) {
+			if (alpha2_equal(last_request->alpha2,
+			    cfg80211_regdomain->alpha2))
+				return 0;
+			else
+				return -EAGAIN;
+		}
+
 		return 0;
 	}
 
-- 
1.6.1.rc3.51.g5832d

