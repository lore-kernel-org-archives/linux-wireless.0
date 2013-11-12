Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:43223 "EHLO
	ashevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3KLHNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 02:13:01 -0500
Date: Tue, 12 Nov 2013 13:12:32 +0600
From: Alex Hacker <hacker@epn.ru>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Sven Eckelmann <sven@open-mesh.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf QCA9558 when setting rxchainmask
Message-ID: <20131112071232.GB11218@infinet.ru> (sfid-20131112_081306_802063_08B694DA)
References: <19772470.YgPhAz9cYD@bentobox> <87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de> <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com> <2985619.kldLYNDlSX@bentobox> <21120.58000.344447.562435@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <21120.58000.344447.562435@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Sujith. Probably I understood the following patch in a wrong way.
Felix removed all chain masks checking. If the mask 5 is invalid, how about
the mask 4 and 6?
Regards,
Alex

commit 24171dd92096fc370b195f3f6bdc0798855dc3f9
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Jan 20 21:55:21 2013 +0100

    ath9k_hw: fix chain swap setting when setting rx chainmask to 5
    
    Chain swapping should only be enabled when the EEPROM chainmask is set to 5,
    regardless of what the runtime chainmask is.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8290edd..3afc24b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -588,30 +588,17 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
-	switch (rx) {
-	case 0x5:
+	if (ah->caps.tx_chainmask == 5 || ah->caps.rx_chainmask == 5)
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
-	case 0x3:
-	case 0x1:
-	case 0x2:
-	case 0x7:
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
-		break;
-	default:
-		break;
-	}
+
+	REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
+	REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else
-		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+		tx = 3;
 
-	if (tx == 0x5) {
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	}
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx);
 }
 
 /*
