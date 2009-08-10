Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34206 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZHJAae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 20:30:34 -0400
Date: Mon, 10 Aug 2009 03:30:32 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Subject: [PATCH 4/5] ath5k: Preserve pcicfg bits during attach
Message-ID: <20090810003032.GD7079@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * During attach preserve pcicfg bits when enabling pci core
   sw retry fix.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 238eeb7..65d438b 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -261,7 +261,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	/* Enable pci core retry fix on Hainan (5213A) and later chips */
 	if (srev >= AR5K_SREV_AR5213A)
-		ath5k_hw_reg_write(ah, AR5K_PCICFG_RETRY_FIX, AR5K_PCICFG);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_RETRY_FIX);
 
 	/*
 	 * Get card capabilities, calibration values etc
