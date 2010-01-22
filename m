Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab0AVVIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 16:08:09 -0500
Subject: [PATCH] mac80211: add missing key check
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 22:07:59 +0100
Message-ID: <1264194479.2593.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_tx_h_select_key might decide that a frame
need not be encrypted at all, in which case it will
clear tx->key. In that case it may crash if a key
was previously selected, e.g. as the default key.

This is also due to my patch
"mac80211: move control.hw_key assignment".

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-01-22 21:44:40.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-01-22 21:49:50.000000000 +0100
@@ -557,7 +557,7 @@ ieee80211_tx_h_select_key(struct ieee802
 			break;
 		}
 
-		if (!skip_hw &&
+		if (!skip_hw && tx->key &&
 		    tx->key->conf.flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
 	}


