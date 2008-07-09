Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:40572 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYGITog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 15:44:36 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3007816wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 12:44:36 -0700 (PDT)
Subject: [PATCH 3/4] ath5k: explicitly check skb->len
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 12:44:32 -0700
Message-Id: <1215632672.476.86.camel@brick> (sfid-20080709_214438_751531_10B97091)
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
index a43e9b2..ae10ee0 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1596,7 +1596,7 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 		struct sk_buff *skb, struct ath5k_rx_status *rs)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
-	unsigned int keyix, hlen = ieee80211_get_hdrlen_from_skb(skb);
+	unsigned int keyix, hlen;
 
 	if (!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
 			rs->rs_keyix != AR5K_RXKEYIX_INVALID)
@@ -1605,6 +1605,7 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 	/* Apparently when a default key is used to decrypt the packet
 	   the hw does not set the index used to decrypt.  In such cases
 	   get the index from the packet. */
+	hlen = ieee80211_hdrlen(hdr->frame_control);
 	if (ieee80211_has_protected(hdr->frame_control) &&
 	    !(rs->rs_status & AR5K_RXERR_DECRYPT) &&
 	    skb->len >= hlen + 4) {
-- 
1.5.6.1.322.ge904b


