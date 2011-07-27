Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39797 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1G0C11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 22:27:27 -0400
Subject: [PATCH 3/3] ath5k: remove last references to "softc"
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 22:27:05 -0400
Message-ID: <20110727022705.27981.260.stgit@mj.roinet.com> (sfid-20110727_042731_699111_4B49CE15)
In-Reply-To: <20110727022652.27981.27951.stgit@mj.roinet.com>
References: <20110727022652.27981.27951.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ahb.c    |    4 ++--
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/base.c   |    4 ++--
 drivers/net/wireless/ath/ath5k/base.h   |    4 ++--
 drivers/net/wireless/ath/ath5k/pci.c    |    4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 9f69a4c..a43ab71 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -170,7 +170,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 			__set_bit(ATH_STAT_2G_DISABLED, ah->status);
 	}
 
-	ret = ath5k_init_softc(ah, &ath_ahb_bus_ops);
+	ret = ath5k_init_ah(ah, &ath_ahb_bus_ops);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "failed to attach device, err=%d\n", ret);
 		ret = -ENODEV;
@@ -215,7 +215,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
 		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
 	}
 
-	ath5k_deinit_softc(ah);
+	ath5k_deinit_ah(ah);
 	platform_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index f50530d..daad6c8 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -94,7 +94,7 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 /**
  * ath5k_hw_init - Check if hw is supported and init the needed structs
  *
- * @ah: The &struct ath5k_hw we got from the driver's init_softc function
+ * @ah: The &struct ath5k_hw associated with the device
  *
  * Check if the device is supported, perform a POST and initialize the needed
  * structs. Returns -ENOMEM if we don't have memory for the needed structs,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 58b478f..8782926 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2346,7 +2346,7 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 \*************************/
 
 int __devinit
-ath5k_init_softc(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
+ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 {
 	struct ieee80211_hw *hw = ah->hw;
 	struct ath_common *common;
@@ -2900,7 +2900,7 @@ err:
 }
 
 void
-ath5k_deinit_softc(struct ath5k_hw *ah)
+ath5k_deinit_ah(struct ath5k_hw *ah)
 {
 	struct ieee80211_hw *hw = ah->hw;
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 1eb2db8..e4b5110 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -108,8 +108,8 @@ void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 
-int ath5k_init_softc(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops);
-void ath5k_deinit_softc(struct ath5k_hw *ah);
+int ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops);
+void ath5k_deinit_ah(struct ath5k_hw *ah);
 
 /* Check whether BSSID mask is supported */
 #define ath5k_hw_hasbssidmask(_ah) (ah->ah_version == AR5K_AR5212)
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index eaf79b4..c1dff2c 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -261,7 +261,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	ah->iobase = mem; /* So we can unmap it on detach */
 
 	/* Initialize */
-	ret = ath5k_init_softc(ah, &ath_pci_bus_ops);
+	ret = ath5k_init_ah(ah, &ath_pci_bus_ops);
 	if (ret)
 		goto err_free;
 
@@ -287,7 +287,7 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_hw *ah = hw->priv;
 
-	ath5k_deinit_softc(ah);
+	ath5k_deinit_ah(ah);
 	pci_iounmap(pdev, ah->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
