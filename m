Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:50398 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:46:14 -0400
Subject: [PATCH v2 6/8] ath10k: implement ath10k_pci_soc_read/write32()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:46:11 +0300
Message-ID: <20131016134611.25095.80204.stgit@localhost6.localdomain6> (sfid-20131016_154616_698446_2C0AFCEF)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it easier to access SOC registers. No functional
changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |    3 +--
 drivers/net/wireless/ath/ath10k/pci.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d09f8a2..5c78383 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2454,8 +2454,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		return ret;
 	}
 
-	chip_id = ath10k_pci_read32(ar,
-				    RTC_SOC_BASE_ADDRESS + SOC_CHIP_ID_ADDRESS);
+	chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 
 	ath10k_do_pci_sleep(ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 52fb7b9..a304c33 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -318,6 +318,16 @@ static inline u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
 	return ioread32(ar_pci->mem + offset);
 }
 
+static inline u32 ath10k_pci_soc_read32(struct ath10k *ar, u32 addr)
+{
+	return ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS + addr);
+}
+
+static inline void ath10k_pci_soc_write32(struct ath10k *ar, u32 addr, u32 val)
+{
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + addr, val);
+}
+
 int ath10k_do_pci_wake(struct ath10k *ar);
 void ath10k_do_pci_sleep(struct ath10k *ar);
 

