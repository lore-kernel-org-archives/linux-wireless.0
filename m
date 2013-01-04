Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43205 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab3ADFZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 00:25:37 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/5] mwifiex: flush TX ring for PCIe after disconnect or bss stop
Date: Thu,  3 Jan 2013 21:21:31 -0800
Message-Id: <1357276892-32759-5-git-send-email-bzhao@marvell.com> (sfid-20130104_062542_577774_BCF78789)
In-Reply-To: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
References: <1357276892-32759-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds handler to clean PCIe TX rings after disconnect
or bss stop is called for PCIe based mwifiex driver.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |    1 +
 drivers/net/wireless/mwifiex/pcie.c |   32 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/pcie.h |   13 +++++++++++++
 drivers/net/wireless/mwifiex/wmm.c  |    2 ++
 4 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ef02a5b..51044e3 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -602,6 +602,7 @@ struct mwifiex_if_ops {
 	int (*init_fw_port) (struct mwifiex_adapter *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
+	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
 };
 
 struct mwifiex_adapter {
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index ac20bc4..19b5a83 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -764,6 +764,37 @@ static int mwifiex_pcie_delete_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+/* This function flushes the TX buffer descriptor ring
+ * This function defined as handler is also called while cleaning TXRX
+ * during disconnect/ bss stop.
+ */
+static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	u32 rdptr;
+
+	/* Read the TX ring read pointer set by firmware */
+	if (mwifiex_read_reg(adapter, REG_TXBD_RDPTR, &rdptr)) {
+		dev_err(adapter->dev,
+			"Flush TXBD: failed to read REG_TXBD_RDPTR\n");
+		return -1;
+	}
+
+	if (!mwifiex_pcie_txbd_empty(card, rdptr)) {
+		card->txbd_flush = 1;
+		/* write pointer already set at last send
+		 * send dnld-rdy intr again, wait for completion.
+		 */
+		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
+				      CPU_INTR_DNLD_RDY)) {
+			dev_err(adapter->dev,
+				"failed to assert dnld-rdy interrupt.\n");
+			return -1;
+		}
+	}
+	return 0;
+}
+
 /*
  * This function sends data buffer to device
  */
@@ -1995,6 +2026,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.update_mp_end_port =		NULL,
 	.cleanup_mpa_buf =		NULL,
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
+	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 87201f5..24a39b3 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -114,6 +114,7 @@ struct pcie_service_card {
 	struct pci_dev *dev;
 	struct mwifiex_adapter *adapter;
 
+	u8 txbd_flush;
 	u32 txbd_wrptr;
 	u32 txbd_rdptr;
 	u32 txbd_ring_size;
@@ -146,4 +147,16 @@ struct pcie_service_card {
 	void __iomem *pci_mmap1;
 };
 
+static inline int
+mwifiex_pcie_txbd_empty(struct pcie_service_card *card, u32 rdptr)
+{
+	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) ==
+			(rdptr & MWIFIEX_TXBD_MASK)) &&
+	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
+			(rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND)))
+		return 1;
+
+	return 0;
+}
+
 #endif /* _MWIFIEX_PCIE_H */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 818f871..6d641cb 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -568,6 +568,8 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	mwifiex_wmm_delete_all_ralist(priv);
 	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
 
+	if (priv->adapter->if_ops.clean_pcie_ring)
+		priv->adapter->if_ops.clean_pcie_ring(priv->adapter);
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
 
-- 
1.7.0.2

