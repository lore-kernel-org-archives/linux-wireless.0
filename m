Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbZLOUKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 15:10:48 -0500
Message-Id: <20091215200739.285681277@sipsolutions.net>
Date: Tue, 15 Dec 2009 21:06:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Subject: [RFC/RFT 3/5] mac80211: remove useless setting of
 IEEE80211_TX_INTFL_DONT_ENCRYPT
References: <20091215200618.253970634@sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/tx.c	2009-12-15 20:42:50.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-12-15 20:42:56.000000000 +0100
@@ -487,9 +487,6 @@ ieee80211_tx_h_select_key(struct ieee802
 		}
 	}
 
-	if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-
 	return TX_CONTINUE;
 }
 


