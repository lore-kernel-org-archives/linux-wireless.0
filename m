Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYJUJIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 05:08:31 -0400
Subject: [PATCH] wireless: fix EU check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 11:08:27 +0200
Message-Id: <1224580107.5521.4.camel@johannes.berg> (sfid-20081021_110834_825499_CFE32035)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://en.wikipedia.org/wiki/De_Morgan%27s_laws is useful.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/wireless/reg.c	2008-10-21 11:06:25.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-21 11:06:29.000000000 +0200
@@ -792,7 +792,7 @@ int regulatory_init(void)
 	 * you have CRDA you get it updated, otherwise you get
 	 * stuck with the static values. We ignore "EU" code as
 	 * that is not a valid ISO / IEC 3166 alpha2 */
-	if (ieee80211_regdom[0] != 'E' && ieee80211_regdom[1] != 'U')
+	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
 		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
 					ieee80211_regdom, NULL);
 #else


