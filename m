Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:33396 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYBXR7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 12:59:48 -0500
Date: Sun, 24 Feb 2008 12:59:33 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080224175933.GA4360@hash.localnet> (sfid-20080224_182031_577736_569CC0B5)
References: <20080224042851.GE4426@makis.domain.invalid> <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2008 at 06:45:33AM +0200, Nick Kossifidis wrote:
> >  +       /* Identify PCI-E cards */
> >  +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
> >  +       srev >= AR5K_SREV_VER_AR5416) {
> >  +               ah->ah_pcie = true;
> >  +       } else {
> >  +               ah->ah_pcie = false;
> >  +       }

This won't work, because reset is called before we ever set ah_pcie.
Moving the set before the first call to wakeup (patch below) does the
trick.  Then it works at least as well as I had it working (still with
random calibration failures, but I am again sending this mail using the
driver).

Thanks!

>From f59b2bc93059e7f1bd504714ca22654f4242d78d Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Sun, 24 Feb 2008 10:30:50 -0500
Subject: [PATCH] Grab srev before resetting card.

Setting ah_pcie variable must be done before the first call to
ath5k_hw_nic_wakeup.
---
 drivers/net/wireless/ath5k/hw.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index adcce6f..71cdbd9 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -178,13 +178,21 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	else if (ah->ah_version <= AR5K_AR5211)
 		ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
 
+	/* Get MAC, PHY and RADIO revisions */
+	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+	/* Identify PCI-E cards */
+	if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
+	srev >= AR5K_SREV_VER_AR5416) {
+		ah->ah_pcie = true;
+	} else {
+		ah->ah_pcie = false;
+	}
+
 	/* Bring device out of sleep and reset it's units */
 	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
 	if (ret)
 		goto err_free;
 
-	/* Get MAC, PHY and RADIO revisions */
-	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
 	ah->ah_mac_srev = srev;
 	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
 	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
@@ -214,14 +222,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		ah->ah_single_chip = false;
 	}
 
-	/* Identify PCI-E cards */
-	if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
-	srev >= AR5K_SREV_VER_AR5416) {
-		ah->ah_pcie = true;
-	} else {
-		ah->ah_pcie = false;
-	}
-
 	/* Single chip radio */
 	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
 		ah->ah_radio_2ghz_revision = 0;
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com 

