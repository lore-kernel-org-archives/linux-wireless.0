Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:33746 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYGTDhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:37:37 -0400
Date: Sun, 20 Jul 2008 06:38:16 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 5/12] ath5k: Do ADC test during reset
Message-ID: <20080720033816.GE7440@makis> (sfid-20080720_053739_122135_716FAF93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Do an ADC test during reset to match recent regdumps

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 82b4ff8..cab1a8a 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -1079,6 +1079,19 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	}
 
 	/*
+	 * Perform ADC test (?)
+	 */
+	data = ath5k_hw_reg_read(ah, AR5K_PHY_TST1);
+	ath5k_hw_reg_write(ah, AR5K_PHY_TST1_TXHOLD, AR5K_PHY_TST1);
+	for (i = 0; i <= 20; i++) {
+		if (!(ath5k_hw_reg_read(ah, AR5K_PHY_ADC_TEST) & 0x10))
+			break;
+		udelay(200);
+	}
+	ath5k_hw_reg_write(ah, data, AR5K_PHY_TST1);
+	data = 0;
+
+	/*
 	 * Enable calibration and wait until completion
 	 */
 	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,

