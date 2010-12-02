Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59125 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab0LBLLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:11:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:10:51 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 09/27] ath9k: Enable extended synch for AR9485 to fix L0s recovery issue
Date: Thu, 2 Dec 2010 03:06:53 -0800
Message-ID: <1291288031-3409-10-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath.h        |    1 +
 drivers/net/wireless/ath/ath9k/hw.c   |    5 +++++
 drivers/net/wireless/ath/ath9k/hw.h   |    2 ++
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 drivers/net/wireless/ath/ath9k/pci.c  |   12 ++++++++++++
 5 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 26bdbee..f913db4 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -131,6 +131,7 @@ struct ath_bus_ops {
 	void (*read_cachesize)(struct ath_common *common, int *csz);
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void (*bt_coex_prep)(struct ath_common *common);
+	void (*extn_synch_en)(struct ath_common *common);
 };
 
 struct ath_common {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 513ae64..b1d3c1e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1984,6 +1984,11 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 
 
+	if (AR_SREV_9485_10(ah)) {
+		pCap->pcie_lcr_extsync_en = true;
+		pCap->pcie_lcr_offset = 0x80;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index bde1df3..1eb6a14 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -210,6 +210,8 @@ struct ath9k_hw_capabilities {
 	u8 rx_status_len;
 	u8 tx_desc_len;
 	u8 txs_len;
+	u16 pcie_lcr_offset;
+	bool pcie_lcr_extsync_en;
 };
 
 struct ath9k_ops_config {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f026a03..581dbd7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1188,6 +1188,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	pm_qos_update_request(&sc->pm_qos_req, 55);
 
+	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
+		common->bus_ops->extn_synch_en(common);
+
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 09f69a9..c5a523d 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -104,11 +104,23 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
 }
 
+static void ath_pci_extn_synch_enable(struct ath_common *common)
+{
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	u8 lnkctl;
+
+	pci_read_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, &lnkctl);
+	lnkctl |= PCI_EXP_LNKCTL_ES;
+	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
+}
+
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath_pci_read_cachesize,
 	.eeprom_read = ath_pci_eeprom_read,
 	.bt_coex_prep = ath_pci_bt_coex_prep,
+	.extn_synch_en = ath_pci_extn_synch_enable,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.7.0.4

