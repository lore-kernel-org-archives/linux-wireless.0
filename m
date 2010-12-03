Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:36635 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab0LCEJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:09:39 -0500
Received: by ewy10 with SMTP id 10so5228139ewy.4
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:09:38 -0800 (PST)
Date: Fri, 3 Dec 2010 06:09:38 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Subject: [PATCH 4/6] ath5k: Fix reporting of RX dma stop failure
Message-ID: <20101203040938.GD2988@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Correctly report failure to stop RX DMA

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 82541fe..0064be7 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -72,7 +72,7 @@ static int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 			i--)
 		udelay(100);
 
-	if (i)
+	if (!i)
 		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
 				"failed to stop RX DMA !\n");
 
