Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38335 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbYGTNyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 09:54:04 -0400
Message-ID: <48833E93.5060702@openwrt.org> (sfid-20080720_155407_971623_FEF4962B)
Date: Sun, 20 Jul 2008 15:33:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath5k-devel@lists.ath5k.org
Subject: [PATCH 1/5] ath9k: fix bad udelay
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace udelay(3000) with mdelay(3), because udelay(3000) fails on
some architectures, e.g. ARM

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -737,7 +737,7 @@
  	ath9k_hw_stoppcurecv(ah);	/* disable PCU */
  	ath9k_hw_setrxfilter(ah, 0);	/* clear recv filter */
  	stopped = ath9k_hw_stopdmarecv(ah);	/* disable DMA engine */
-	udelay(3000);			/* 3ms is long enough for 1 frame */
+	mdelay(3);			/* 3ms is long enough for 1 frame */
  	tsf = ath9k_hw_gettsf64(ah);
  	sc->sc_rxlink = NULL;		/* just in case */
  	return stopped;
