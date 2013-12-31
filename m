Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41522 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3LaIbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 03:31:07 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so12112444pdj.18
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 00:31:06 -0800 (PST)
From: ZHAO Gang <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix possible memory leak in ieee80211_register_hw()
Date: Tue, 31 Dec 2013 16:30:22 +0800
Message-Id: <f3ed60a9575d7c1f177e09ced775972a0b70ecd0.1388478019.git.gamerh2o@gmail.com> (sfid-20131231_093111_122047_62924ED2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before return, free allocated memory in this function.

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 net/mac80211/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2bd5b55..7ee0e8a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -876,8 +876,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 		for (j = 0; j < c->n_limits; j++)
 			if ((c->limits[j].types & BIT(NL80211_IFTYPE_ADHOC)) &&
-			    c->limits[j].max > 1)
+			    c->limits[j].max > 1) {
+				kfree(local->int_scan_req);
 				return -EINVAL;
+			}
 	}
 
 #ifndef CONFIG_MAC80211_MESH
-- 
1.8.4.2

