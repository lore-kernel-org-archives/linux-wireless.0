Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ranger.systems.pipex.net ([62.241.162.32]:40937 "EHLO
	ranger.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbXH1XN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 19:13:56 -0400
From: Adam Baker <adam@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] Fix breakage on WEP for cards that rely on software decoding
Date: Tue, 28 Aug 2007 23:45:52 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200708282345.53016.adam@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The test to drop out of ieee80211_rx_h_load_key if we don't know the IV should
check if the packet has already been decrypted, otherwise we need to load
the key to be able to decrypt it

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
---

When using rt2x00 with WEP we get continuous reports of "RX WEP frame, but
no key set" without this patch. As the rt2x00 driver currently relies on
mac80211 to perform the decryption I believe it would be incorrect for the driver
to set IEEE80211_HW_WEP_INCLUDE_IV. Also reading some of the code
comments it appears that even for a card that does HW decryption there are
circumstances where the SW decryption will get used and in those cases
we need to set the key.

The patch was generated against the rt2x00 git but looks like it applies to
the current wireless-dev everything.

---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9c02dff..5bf7185 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -363,7 +363,8 @@ ieee80211_rx_h_load_key(struct ieee80211
 		 * we somehow allow the driver to tell us which key
 		 * the hardware used if this flag is set?
 		 */
-		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
+		if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
+		    (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)))
 			return TXRX_CONTINUE;
 
 		hdrlen = ieee80211_get_hdrlen(rx->fc);
