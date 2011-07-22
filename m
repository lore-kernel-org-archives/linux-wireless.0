Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1GVNbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 09:31:14 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT 6/6] ath9k: always initialize hw registers related to PCIe PM
Date: Fri, 22 Jul 2011 15:31:52 +0200
Message-Id: <1311341512-2882-7-git-send-email-sgruszka@redhat.com> (sfid-20110722_153120_356917_66A39EC5)
In-Reply-To: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We might not initialize registers if ah->aspm_enabled == false, assure
we do this.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    5 +----
 drivers/net/wireless/ath/ath9k/pci.c |    4 ++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4ef7313..7084bb5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -595,10 +595,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_init_mode_regs(ah);
 
-
-	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, false);
-	else
+	if (!ah->is_pciexpress)
 		ath9k_hw_disablepcie(ah);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 835a50a..d1c75ec 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -118,6 +118,10 @@ static void ath_pci_aspm_init(struct ath_softc *sc)
 	if (!pci_is_pcie(pdev))
 		return;
 
+	/* initalize PCIe PM registers if device introduce itself as PCIe */
+	if (ah->is_pciexpress)
+		ath9k_hw_ops(ah)->config_pci_powersave(ah, false);
+
 	parent = pdev->bus->self;
 
 	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
-- 
1.7.1

