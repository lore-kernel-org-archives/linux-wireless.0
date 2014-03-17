Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24148 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbaCQNe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:57 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 09/21] wil6210: fix for HW bug in interrupt setup logic
Date: Mon, 17 Mar 2014 15:34:13 +0200
Message-ID: <1395063265-6522-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143508_351589_112161C2)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware bug triggered by the MSI init while INTx asserted for some reason.
De-assert INTx prior to MSI set-up

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  1 +
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 10919f9..52c40e1 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -493,6 +493,23 @@ free0:
 
 	return rc;
 }
+/* can't use wil_ioread32_and_clear because ICC value is not ser yet */
+static inline void wil_clear32(void __iomem *addr)
+{
+	u32 x = ioread32(addr);
+
+	iowrite32(x, addr);
+}
+
+void wil6210_clear_irq(struct wil6210_priv *wil)
+{
+	wil_clear32(wil->csr + HOSTADDR(RGF_DMA_EP_RX_ICR) +
+		    offsetof(struct RGF_ICR, ICR));
+	wil_clear32(wil->csr + HOSTADDR(RGF_DMA_EP_TX_ICR) +
+		    offsetof(struct RGF_ICR, ICR));
+	wil_clear32(wil->csr + HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+		    offsetof(struct RGF_ICR, ICR));
+}
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq)
 {
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index d96e811..c609761 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -153,6 +153,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, wil);
 	wil->pdev = pdev;
 
+	wil6210_clear_irq(wil);
 	/* FW should raise IRQ when ready */
 	rc = wil_if_pcie_enable(wil);
 	if (rc) {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 14f861c..317621c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -476,6 +476,7 @@ int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason);
 
+void wil6210_clear_irq(struct wil6210_priv *wil);
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
 void wil6210_disable_irq(struct wil6210_priv *wil);
-- 
1.8.3.2

