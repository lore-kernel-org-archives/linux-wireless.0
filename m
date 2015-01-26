Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47175 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbbAZQn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 11:43:27 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix target wakeup timeout
Date: Mon, 26 Jan 2015 22:13:06 +0530
Message-ID: <1422290586-10955-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150126_174330_214104_B0BC4DA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During drv_start/drv_stop stress testing in ARM platform,
sometimes target is taking more that 5ms to wake up. Similar
behaviour also noted during driver load and unload iterations.
On such cases, the wakup duration lies between 5-6ms. Hence
increasing pci wakup timeout 10ms to be more safer. With this
changes, able to complete power down/up >100 iterations without
any issues.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index ce4a1ef..bddf543 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -194,7 +194,7 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 
 #define ATH10K_PCI_RX_POST_RETRY_MS 50
 #define ATH_PCI_RESET_WAIT_MAX 10 /* ms */
-#define PCIE_WAKE_TIMEOUT 5000	/* 5ms */
+#define PCIE_WAKE_TIMEOUT 10000	/* 10ms */
 
 #define BAR_NUM 0
 
-- 
2.2.2

