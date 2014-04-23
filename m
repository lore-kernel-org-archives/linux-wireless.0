Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55160 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDWJhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 05:37:50 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k: fix race in setting ATH_OP_INVALID
Date: Wed, 23 Apr 2014 15:07:57 +0530
Message-ID: <1398245877-21106-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140423_113757_772790_BE5F3F01)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: move sc_flags to ath_common" moved setting
ATH_OP_INVALID flag below ieee80211_register_hw. This is causing
the flag never being cleared randomly as the drv_start is called
prior to setting flag. Fix this by setting the flag prior to
register_hw.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c  | 4 ----
 drivers/net/wireless/ath/ath9k/init.c | 3 +++
 drivers/net/wireless/ath/ath9k/pci.c  | 5 -----
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index a0398fe..be3eb2a 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -86,7 +86,6 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	int irq;
 	int ret = 0;
 	struct ath_hw *ah;
-	struct ath_common *common;
 	char hw_name[64];
 
 	if (!dev_get_platdata(&pdev->dev)) {
@@ -146,9 +145,6 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)mem, irq);
 
-	common = ath9k_hw_common(sc->sc_ah);
-	/* Will be cleared in ath9k_start() */
-	set_bit(ATH_OP_INVALID, &common->op_flags);
 	return 0;
 
  err_irq:
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cbbb02a..36ae649 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -783,6 +783,9 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 	common = ath9k_hw_common(ah);
 	ath9k_set_hw_capab(sc, hw);
 
+	/* Will be cleared in ath9k_start() */
+	set_bit(ATH_OP_INVALID, &common->op_flags);
+
 	/* Initialize regulatory */
 	error = ath_regd_init(&common->regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 25304ad..914dbc6 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -784,7 +784,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
-	struct ath_common *common;
 	u8 csz;
 	u32 val;
 	int ret = 0;
@@ -877,10 +876,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)sc->mem, pdev->irq);
 
-	/* Will be cleared in ath9k_start() */
-	common = ath9k_hw_common(sc->sc_ah);
-	set_bit(ATH_OP_INVALID, &common->op_flags);
-
 	return 0;
 
 err_init:
-- 
1.9.2

