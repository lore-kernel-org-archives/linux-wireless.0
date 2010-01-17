Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab0AQAtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 19:49:13 -0500
Message-Id: <20100117004825.024885439@sipsolutions.net>
Date: Sun, 17 Jan 2010 01:47:57 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] mac80211: remove useless setting of
 IEEE80211_TX_INTFL_DONT_ENCRYPT
References: <20100117004754.624627000@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no value in setting a flag that will
never be checked after this point, this seems
to be legacy code -- I think previously the
flag was used to check whether to encrypt the
frame or not. Now, however, the flag need not
be set, and setting it actually interferes if
the frame will be processed again later.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    3 ---
 1 file changed, 3 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-01-16 20:18:50.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-01-16 20:19:05.000000000 +0100
@@ -553,9 +553,6 @@ ieee80211_tx_h_select_key(struct ieee802
 		}
 	}
 
-	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-
 	return TX_CONTINUE;
 }
 


