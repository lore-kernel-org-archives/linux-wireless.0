Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:55418 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYKCWZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:25:57 -0500
Date: Tue, 4 Nov 2008 00:25:54 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH] ath5k: Fix IMR init
Message-ID: <20081103222554.GA3006@makis> (sfid-20081103_232603_024556_66BEBA47)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 *On a previous patch i splitted AR5K_INT_TX to multiple different TX 
 interrupt flags for better handling but i forgot to unmask the new 
 TXDESC and TXEOL interrupts on ath5k_init and only left TXOK. However 
 for each queue we enable TXDESC and TXEOL interrupts, not TXOK so we don't 
 handle TX interrupts at all (because these interrupts remain masked on 
 PISR) and under load it results packet loss. Fix the problem by 
 unmasking TXDESC and TXEOL on ath5k_init.


 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 5ef8cc4..f5f46fe 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2219,9 +2219,9 @@ ath5k_init(struct ath5k_softc *sc, bool is_resume)
 	 */
 	sc->curchan = sc->hw->conf.channel;
 	sc->curband = &sc->sbands[sc->curchan->band];
-	sc->imask = AR5K_INT_RXOK | AR5K_INT_TXOK | AR5K_INT_RXEOL |
-		AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL |
-		AR5K_INT_MIB;
+	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
+		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
+		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
 	ret = ath5k_reset(sc, false, false);
 	if (ret)
 		goto done;
