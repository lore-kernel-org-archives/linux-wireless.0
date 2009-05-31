Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZEaWYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 18:24:36 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] cfg80211: fix for duplicate userspace replies
Date: Sun, 31 May 2009 18:24:34 -0400
Message-Id: <1243808674-8414-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes an incorrect assumption (BUG_ON) made in
cfg80211 when handling country IE regulatory requests.
The assumption was that we won't try to call_crda()
twice for the same event and therefore we will not
recieve two replies through nl80211 for the regulatory
request. As it turns out it is true we don't call_crda()
twice for the same event, however, kobject_uevent_env()
*might* send the udev event twice and/or userspace can
simply process the udev event twice. We remove the BUG_ON()
and simply ignore the duplicate request.

For details refer to this thread:

http://marc.info/?l=linux-wireless&m=124149987921337&w=2

Cc: stable@kernel.org
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f87ac1d..ea4c299 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2171,7 +2171,13 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	 * the country IE rd with what CRDA believes that country should have
 	 */
 
-	BUG_ON(!country_ie_regdomain);
+	/*
+	 * Userspace could have sent two replies with only
+	 * one kernel request. By the second reply we would have
+	 * already processed and consumed the country_ie_regdomain.
+	 */
+	if (!country_ie_regdomain)
+		return -EALREADY;
 	BUG_ON(rd == country_ie_regdomain);
 
 	/*
-- 
1.6.2.2.446.gfbdc0

