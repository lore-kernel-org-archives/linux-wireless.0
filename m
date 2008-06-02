Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37362 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654AbYFBLyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 07:54:52 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] mac80211: fix panic when using hardware WEP
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 02 Jun 2008 07:54:50 -0400
Message-ID: <20080602115437.12734.42209.stgit@dv.roinet.com> (sfid-20080602_135503_655717_6656C575)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

57ccbb1cbe3f8e10a500ff8b9fb26dc1a542fe99 misplaced code for setting
hardware WEP keys.  Move it back.  This fixes kernel panic in b43 if WEP
is used and hardware encryption is enabled.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 net/mac80211/wep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index c9fd129..e7b6344 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -335,10 +335,10 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	info->control.icv_len = WEP_ICV_LEN;
 
 	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		info->control.hw_key = &tx->key->conf;
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
+		info->control.hw_key = &tx->key->conf;
 		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
 			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
 				return -1;
