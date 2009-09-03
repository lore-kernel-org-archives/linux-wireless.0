Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZICGLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 02:11:10 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak reports
Date: Thu,  3 Sep 2009 02:11:06 -0400
Message-Id: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was giving false positives. We use eventually free this
through kref_put(), things are not so obvious through
cfg80211_bss_update().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/scan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 19c5a9a..79f7a5d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -495,6 +495,9 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 
 	kref_init(&res->ref);
 
+	/* cfg80211_bss_update() eats up res - we ensure we free it there */
+	kmemleak_ignore(res);
+
 	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
 	if (!res)
 		return NULL;
-- 
1.6.3.3

