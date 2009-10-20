Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZJTGJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 02:09:46 -0400
Subject: [PATCH] mac80211: keep auth state when assoc fails
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Oct 2009 15:08:12 +0900
Message-Id: <1256018892.4475.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When association fails, we should stay authenticated,
which in mac80211 is represented by the existence of
the mlme work struct, so we cannot free that, instead
we need to just set it to idle.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-10-20 15:01:40.000000000 +0900
+++ wireless-testing/net/mac80211/mlme.c	2009-10-20 15:01:46.000000000 +0900
@@ -1457,8 +1457,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	if (status_code != WLAN_STATUS_SUCCESS) {
 		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
 		       sdata->dev->name, status_code);
-		list_del(&wk->list);
-		kfree(wk);
+		wk->state = IEEE80211_MGD_STATE_IDLE;
 		return RX_MGMT_CFG80211_ASSOC;
 	}
 


