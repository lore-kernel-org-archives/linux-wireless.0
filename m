Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:46093 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYBKPBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 10:01:37 -0500
Date: Mon, 11 Feb 2008 10:00:12 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080211150012.GA15956@hash.localnet> (sfid-20080211_150150_705870_47F2C50D)
References: <20080131155901.GA7997@hash.localnet> <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com> <20080201040358.GA13428@hash.localnet> <40f31dec0802010409i47374309o5da3d76fb1bc7025@mail.gmail.com> <20080201225345.GA15922@hash.localnet> <40f31dec0802011748i5a1b8aaftf42f7798762cca3d@mail.gmail.com> <20080203014559.GA20177@hash.localnet> <40f31dec0802050113w6f332a00ja7c9ad849f80e2e0@mail.gmail.com> <20080210162155.GA10894@hash.localnet> <40f31dec0802101105o61442683ia6b56c264a9af556@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802101105o61442683ia6b56c264a9af556@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 10, 2008 at 09:05:38PM +0200, Nick Kossifidis wrote:
> 2008/2/10, Bob Copeland <me@bobcopeland.com>:
> > I'll post a patch later tonight.

Well I spoke too soon :)  I was unable to repeatedly get this to work
so I guess maybe I was lucky the times it did.  Here's what I have so
far.

 - in my traces the hal always set DMA == 128B.  So I did not bump it up,
 and that seemed to cure rx overrun.  Obviously should be done on a
 per-card basis.

 - turned off reset of PCI to avoid host interface unit hang as discussed
   previously
    
 - noticed this card has a different sleep pending value, not sure what
   the rf5413 uses compared to this

 - added various registers that I have no idea what they do.

> Did you forced b mode via iwpriv while tracing (even if ap is b-only
> card will use g settings) ? You should at least see different IFS etc
> settings (check out initvals).

Not sure, I'll try them again.  Are the other traces for other cards
online somewhere?

> Good work ;-)

Heh I really don't know a phy from a sta so feel free to pick this
apart...


>From 53d584dd188a131632e09353d1dd674f02a15b3c Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Sat, 9 Feb 2008 00:16:12 -0500
Subject: [PATCH] ath5k: changes for 5424/2424 cards

This adds some register writes and updates some values used by
the Atheros 5424 chipset.  This is just an experimental patch that
should not be applied.
---
 drivers/net/wireless/ath5k/hw.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3a4bf40..ba832b0 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -358,8 +358,8 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	}
 
 	/* ...reset chipset and PCI device */
-	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
-				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
+	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah, 
+		AR5K_RESET_CTL_CHIP)) {
 		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
 		return -EIO;
 	}
@@ -887,9 +887,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	 */
 	if (ah->ah_version != AR5K_AR5210) {
 		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
-				AR5K_DMASIZE_512B | AR5K_TXCFG_DMASIZE);
+				AR5K_DMASIZE_128B | AR5K_TXCFG_DMASIZE);
 		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
-				AR5K_DMASIZE_512B);
+				AR5K_DMASIZE_128B);
 	}
 
 	/*
@@ -981,14 +981,22 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	 * Set the 32MHz reference clock on 5212 phy clock sleep register
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
+		int spending;
+
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-		ath5k_hw_reg_write(ah, ah->ah_radio == AR5K_RF5111 ?
-			AR5K_PHY_SPENDING_RF5111 : AR5K_PHY_SPENDING_RF5112,
-			AR5K_PHY_SPENDING);
+
+		if (ah->ah_radio <= AR5K_RF5111)
+			spending = AR5K_PHY_SPENDING_RF5111;
+		else if (ah->ah_radio <= AR5K_RF5112)
+			spending = AR5K_PHY_SPENDING_RF5112;
+		else
+			spending = 0x12;
+
+		ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
 	}
 
 	/*
@@ -997,6 +1005,13 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE |
 			AR5K_BEACON_RESET_TSF);
 
+	if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2424) {
+		ath5k_hw_reg_write(ah, 0x000100aa, 0x8118);
+		ath5k_hw_reg_write(ah, 0x00003210, 0x811c);
+		ath5k_hw_reg_write(ah, 0x00000052, 0x8108);
+		ath5k_hw_reg_write(ah, 0x001e1e1e, AR5K_TXPC);
+		ath5k_hw_reg_write(ah, 0x00000004, 0x8120);
+	}
 	return 0;
 }
 
-- 
1.5.4


-- 
Bob Copeland %% www.bobcopeland.com 

