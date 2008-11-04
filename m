Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:8882 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYKDM6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 07:58:14 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1782456wah.21
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 04:58:12 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18704.17983.404883.555913@localhost.localdomain> (sfid-20081104_135818_989636_BC2EC653)
Date: Tue, 4 Nov 2008 18:25:27 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix compilation failure when RFKILL is enabled
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c67dadc..b1c2d48 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -37,6 +37,8 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ 0 }
 };
 
+static void ath_detach(struct ath_softc *sc);
+
 static int ath_get_channel(struct ath_softc *sc,
 			   struct ieee80211_channel *chan)
 {
@@ -814,7 +816,7 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 			pci_iounmap(sc->pdev, sc->mem);
 			pci_release_region(sc->pdev, 0);
 			pci_disable_device(sc->pdev);
-			ieee80211_free_hw(hw);
+			ieee80211_free_hw(sc->hw);
 			return -EIO;
 		} else {
 			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
-- 
1.6.0.3

