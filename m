Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:44244
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752933AbeBEPFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 10:05:40 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/6] qtnfmac: enable reloading of qtnfmac kernel modules
Date: Mon,  5 Feb 2018 18:05:12 +0300
Message-Id: <20180205150516.16030-3-sergey.matyukevich.os@quantenna.com> (sfid-20180205_160630_979558_38011362)
In-Reply-To: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sergei Maksimenko <smaksimenko@quantenna.com>

This patch enables rmmod/insmod for qtnfmac kernel modules:
- do not 'pin' pci device in order to disable it on module unload
- implement card reset procedure
- restore PCI bar addresses for restarted wireless card

Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c       | 15 ++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h   |  1 +
 .../wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h    |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index be5813aa1486..7aa222286d8e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -162,6 +162,17 @@ static void qtnf_deassert_intx(struct qtnf_pcie_bus_priv *priv)
 	qtnf_non_posted_write(cfg, reg);
 }
 
+static void qtnf_reset_card(struct qtnf_pcie_bus_priv *priv)
+{
+	const u32 data = QTN_PEARL_IPC_IRQ_WORD(QTN_PEARL_LHOST_EP_RESET);
+	void __iomem *reg = priv->sysctl_bar +
+			    QTN_PEARL_SYSCTL_LHOST_IRQ_OFFSET;
+
+	qtnf_non_posted_write(data, reg);
+	msleep(QTN_EP_RESET_WAIT_MS);
+	pci_restore_state(priv->pdev);
+}
+
 static void qtnf_ipc_gen_ep_int(void *arg)
 {
 	const struct qtnf_pcie_bus_priv *priv = arg;
@@ -1308,7 +1319,6 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
-	pcim_pin_device(pdev);
 	pci_set_master(pdev);
 
 	ret = qtnf_pcie_init_irq(pcie_priv);
@@ -1323,6 +1333,8 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_base;
 	}
 
+	pci_save_state(pdev);
+
 	ret = qtnf_pcie_init_shm_ipc(pcie_priv);
 	if (ret < 0) {
 		pr_err("PCIE SHM IPC init failed\n");
@@ -1425,6 +1437,7 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 	qtnf_debugfs_remove(bus);
 
 	qtnf_pcie_free_shm_ipc(priv);
+	qtnf_reset_card(priv);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
index c5a4e46d26ef..00bb21a1c47a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
@@ -46,6 +46,7 @@
 /* state transition timeouts */
 #define QTN_FW_DL_TIMEOUT_MS	3000
 #define QTN_FW_QLINK_TIMEOUT_MS	30000
+#define QTN_EP_RESET_WAIT_MS	1000
 
 #define PCIE_HDP_INT_RX_BITS (0		\
 	| PCIE_HDP_INT_EP_TXDMA		\
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
index 5b48b425fa7f..0bfe285b6b48 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
@@ -351,5 +351,6 @@
 
 #define QTN_PEARL_IPC_IRQ_WORD(irq)	(BIT(irq) | BIT(irq + 16))
 #define QTN_PEARL_LHOST_IPC_IRQ		(6)
+#define QTN_PEARL_LHOST_EP_RESET	(7)
 
 #endif /* __PEARL_PCIE_H */
-- 
2.11.0
