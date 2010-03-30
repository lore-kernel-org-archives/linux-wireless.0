Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53003 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655Ab0C3Ghl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:37:41 -0400
Date: Mon, 29 Mar 2010 23:37:36 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Do not indicate RX_FLAG_DECRYPTED for unprotected
 frames
Message-ID: <20100330063736.GE4953@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 skips drop_unencrypted checks if the driver/firmware has
already taken care of this. In case of ath9k, we must not indicate
that the frame was decrypted if no decryption was actually done.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 drivers/net/wireless/ath/ath9k/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/common.c	2010-03-29 23:32:13.000000000 -0700
+++ wireless-testing/drivers/net/wireless/ath/ath9k/common.c	2010-03-29 23:36:52.000000000 -0700
@@ -255,7 +255,8 @@ void ath9k_cmn_rx_skb_postprocess(struct
 
 	keyix = rx_stats->rs_keyix;
 
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error &&
+	    ieee80211_has_protected(fc)) {
 		rxs->flag |= RX_FLAG_DECRYPTED;
 	} else if (ieee80211_has_protected(fc)
 		   && !decrypt_error && skb->len >= hdrlen + 4) {

-- 
Jouni Malinen                                            PGP id EFC895FA
