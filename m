Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab0AHSBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:01:09 -0500
Subject: [PATCH] mac80211: fix return from ieee80211_assoc_success
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 19:01:07 +0100
Message-ID: <1262973667.32112.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse pointed out that I made a mistake converting
the return value of ieee80211_assoc_success to bool,
this place should return false instead of one of the
enum values (which would be true).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-01-08 18:24:44.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-01-08 18:24:53.000000000 +0100
@@ -1096,7 +1096,7 @@ static bool ieee80211_assoc_success(stru
 	if (err) {
 		printk(KERN_DEBUG "%s: failed to insert STA entry for"
 		       " the AP (error %d)\n", sdata->name, err);
-		return RX_MGMT_CFG80211_ASSOC_ERROR;
+		return false;
 	}
 
 	if (elems.wmm_param)


