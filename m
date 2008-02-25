Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:59030 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYBYBeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 20:34:04 -0500
Date: Sun, 24 Feb 2008 20:33:45 -0500
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, linville@tuxdriver.com, hch@infradead.org
Subject: [PATCH] ath5k: set pcie flag before calling wakeup
Message-ID: <20080225013345.GA8833@hash.localnet> (sfid-20080225_013425_819391_9E27BE36)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From bd98f2fb1e651dd942a7822e25b73e735b026b6e Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Sun, 24 Feb 2008 10:30:50 -0500
Subject: [PATCH] ath5k: set pcie flag before calling wakeup

In ath5k_hw_nic_wakeup we do not reset the pci unit for pcie devices.
However, we didn't mark devices as pcie until after the first call to
wakeup causing such devices to hang.

Changes-licensed-under: ISC
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Fixed whitespace and bracing issues.  Also moved the comment about
getting MAC/PHY revisions back where it was originally since my moving
it didn't make any sense.

 drivers/net/wireless/ath5k/hw.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index adcce6f..1888b8d 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -178,13 +178,21 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	else if (ah->ah_version <= AR5K_AR5211)
 		ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
 
+	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+
+	/* Identify PCI-E cards */
+	if ((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
+	    srev >= AR5K_SREV_VER_AR5416)
+		ah->ah_pcie = true;
+	else
+		ah->ah_pcie = false;
+
 	/* Bring device out of sleep and reset it's units */
 	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
 	if (ret)
 		goto err_free;
 
 	/* Get MAC, PHY and RADIO revisions */
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

