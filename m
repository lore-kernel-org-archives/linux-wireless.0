Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22496 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbYJ3UeF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:34:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:34:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] cfg80211: Add kdoc for struct regulatory_request
Date: Thu, 30 Oct 2008 13:33:56 -0700
Message-ID: <1225398836-28633-6-git-send-email-lrodriguez@atheros.com> (sfid-20081030_213411_223104_932606F4)
In-Reply-To: <1225398836-28633-5-git-send-email-lrodriguez@atheros.com>
References: <1225398836-28633-1-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-2-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-3-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-4-git-send-email-lrodriguez@atheros.com>
 <1225398836-28633-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As regulatory_request gets bigger there will be more questions
of what things means, so clarify documenation for it and
keep track of the special alpha2 codes we use internally
and on the userspace regulatory agents.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3f18a1d..4c7e39d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -42,9 +42,24 @@
 #include "core.h"
 #include "reg.h"
 
-/*
- * wiphy is set if this request's initiator is
- * REGDOM_SET_BY_COUNTRY_IE or _DRIVER
+/**
+ * struct regulatory_request - receipt of last regulatory request
+ *
+ * @wiphy: this is set if this request's initiator is
+ * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
+ * 	can be used by the wireless core to deal with conflicts
+ * 	and potentially inform users of which devices specifically
+ * 	cased the conflicts.
+ * @initiator: indicates who sent this request, could be any of
+ * 	of those set in reg_set_by, %REGDOM_SET_BY_*
+ * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
+ * 	regulatory domain. We have a few special codes:
+ * 	00 - World regulatory domain
+ * 	99 - built by driver but a specific alpha2 cannot be determined
+ * 	98 - result of an intersection between two regulatory domains
+ * @intersect: indicates whether the wireless core should intersect
+ * 	the requested regulatory domain with the presently set regulatory
+ * 	domain.
  */
 struct regulatory_request {
 	struct wiphy *wiphy;
@@ -53,6 +68,7 @@ struct regulatory_request {
 	bool intersect;
 };
 
+/* Receipt of information from last regulatory request */
 static struct regulatory_request *last_request;
 
 /* To trigger userspace events */
-- 
1.5.6.3

