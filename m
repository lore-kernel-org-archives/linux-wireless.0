Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:53213 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbYGTDwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:52:05 -0400
Date: Sun, 20 Jul 2008 06:32:32 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 2/12] ath5k: Restore saved initval after POST
Message-ID: <20080720033232.GB7440@makis> (sfid-20080720_055207_955149_6FFA91F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Restore saved initial value after POST

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 2e60cf0..3e889f1 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -139,6 +139,8 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 	for (c = 0; c < 2; c++) {
 
 		cur_reg = regs[c];
+
+		/* Save previous value */
 		init_val = ath5k_hw_reg_read(ah, cur_reg);
 
 		for (i = 0; i < 256; i++) {
@@ -170,6 +172,10 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 			var_pattern = 0x003b080f;
 			ath5k_hw_reg_write(ah, var_pattern, cur_reg);
 		}
+
+		/* Restore previous value */
+		ath5k_hw_reg_write(ah, init_val, cur_reg);
+
 	}
 
 	return 0;

