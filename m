Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2728 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab2KSLCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 06:02:19 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] mac80211: check add_chanctx callback before use in
 ieee80211_reconfig
Date: Mon, 19 Nov 2012 12:01:05 +0100
Message-ID: <1353322865-7500-1-git-send-email-arend@broadcom.com> (sfid-20121119_120223_124392_C9E3AC54)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During testing our mac80211 driver a fatal error occurred which was
signalled to mac80211. Upon performing the reconfiguration of the
device a WARN_ON was triggered. This warning checked the return value
of drv_add_chanctx(). However, this returns -EOPNOTSUPP when the
driver does not provide the callback. As the callback is optional
better check it is defined before calling drv_add_chanctx().

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 net/mac80211/util.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5bad758..9c3b3ba 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1417,10 +1417,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 
 	/* add channel contexts */
-	mutex_lock(&local->chanctx_mtx);
-	list_for_each_entry(ctx, &local->chanctx_list, list)
-		WARN_ON(drv_add_chanctx(local, ctx));
-	mutex_unlock(&local->chanctx_mtx);
+	if (local->ops->add_chanctx) {
+		mutex_lock(&local->chanctx_mtx);
+		list_for_each_entry(ctx, &local->chanctx_list, list)
+			WARN_ON(drv_add_chanctx(local, ctx));
+		mutex_unlock(&local->chanctx_mtx);
+	}
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		struct ieee80211_chanctx_conf *ctx_conf;
-- 
1.7.10.4


