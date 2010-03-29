Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44439 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab0C2FbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 01:31:12 -0400
Date: Sun, 28 Mar 2010 22:29:52 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix robust management frame handling (MFP)
Message-ID: <20100329052952.GA26019@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit e34e09401ee9888dd662b2fca5d607794a56daf2 incorrectly removed
use of ieee80211_has_protected() from the management frame case and in
practice, made this validation drop all Action frames when MFP is
enabled. This should have only been done for frames with Protected
field set to zero.

Signed-off-by: Jouni Malinen <j@w1.fi>
Cc: stable@kernel.org

---
 net/mac80211/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-03-28 22:14:33.000000000 -0700
+++ wireless-testing/net/mac80211/rx.c	2010-03-28 22:26:33.000000000 -0700
@@ -1404,7 +1404,8 @@ ieee80211_drop_unencrypted_mgmt(struct i
 		return res;
 
 	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
-		if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
+		if (unlikely(!ieee80211_has_protected(fc) &&
+			     ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
 			     rx->key))
 			return -EACCES;
 		/* BIP does not use Protected field, so need to check MMIE */

-- 
Jouni Malinen                                            PGP id EFC895FA
