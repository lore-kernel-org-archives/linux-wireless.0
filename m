Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38296 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0AVRpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 12:45:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: avoid NULL ptr deref when using WEP
Date: Fri, 22 Jan 2010 12:39:49 -0500
Message-Id: <1264181989-28483-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"mac80211: move control.hw_key assignment" changed an if-else into two
separate if statments, but the if-else is needed to prevent
dereferencing a null info->control.hw_key.  This fixes avoids a lock-up
during association on my machine when using WEP.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/wep.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 0a4c641..5d745f2 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -310,9 +310,8 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
-	}
-
-	if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
+	} else if (info->control.hw_key->flags &
+			IEEE80211_KEY_FLAG_GENERATE_IV) {
 		if (!ieee80211_wep_add_iv(tx->local, skb,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
-- 
1.6.2.5

