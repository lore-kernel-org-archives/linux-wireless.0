Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16274 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbYGPBoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:05 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1738137yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:04 -0700 (PDT)
Subject: [PATCH 03/12] ath5k: explicitly check skb->len
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:02 -0700
Message-Id: <1216172642.6610.50.camel@brick> (sfid-20080716_034408_221089_187A6F9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_hdrlen_from_skb internally checks that the skb is long
enough to hold the full header, or it returns 0 if not.  The check in
ath5k does not check this case and assumes it always got the actual
header length which it then checks against the skb->len plus some headroom.

Change to ieee80211_hdrlen which always returns the hdrlen and keep the
existing headroom check.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 217d506..a93ed81 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1595,7 +1595,7 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 		struct sk_buff *skb, struct ath5k_rx_status *rs)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	unsigned int keyix, hlen = ieee80211_get_hdrlen_from_skb(skb);
+	unsigned int keyix, hlen;
 
 	if (!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
 			rs->rs_keyix != AR5K_RXKEYIX_INVALID)
@@ -1604,6 +1604,7 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 	/* Apparently when a default key is used to decrypt the packet
 	   the hw does not set the index used to decrypt.  In such cases
 	   get the index from the packet. */
+	hlen = ieee80211_hdrlen(hdr->frame_control);
 	if (ieee80211_has_protected(hdr->frame_control) &&
 	    !(rs->rs_status & AR5K_RXERR_DECRYPT) &&
 	    skb->len >= hlen + 4) {
-- 
1.5.6.3.499.geae9


