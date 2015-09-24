Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10309 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbbIXOY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:24:28 -0400
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: Increase pci wakeup timeout to 30 ms
Date: Thu, 24 Sep 2015 19:54:00 +0530
Message-ID: <1443104640-13965-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20150924_162431_637485_0AFC1B4D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

It is noticed that pci wakeup time is exceeding current timeout (10ms)
randomly which is tested on QCA988x. So, the wake up time is increased
to 30 ms and added debug prints to log total timeout.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 +++++-
 drivers/net/wireless/ath/ath10k/pci.h | 3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 1046ab6..2df1692 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -452,8 +452,12 @@ static int ath10k_pci_wake_wait(struct ath10k *ar)
 	int curr_delay = 5;
 
 	while (tot_delay < PCIE_WAKE_TIMEOUT) {
-		if (ath10k_pci_is_awake(ar))
+		if (ath10k_pci_is_awake(ar)) {
+			if (tot_delay > PCIE_WAKE_LATE_US)
+				ath10k_warn(ar, "device wakeup took %d ms which is unusally long, otherwise it works normally.\n",
+					    tot_delay / 1000);
 			return 0;
+		}
 
 		udelay(curr_delay);
 		tot_delay += curr_delay;
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 8d364fb..54af2d7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -230,7 +230,8 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 
 #define ATH10K_PCI_RX_POST_RETRY_MS 50
 #define ATH_PCI_RESET_WAIT_MAX 10 /* ms */
-#define PCIE_WAKE_TIMEOUT 10000	/* 10ms */
+#define PCIE_WAKE_TIMEOUT 30000	/* 30ms */
+#define PCIE_WAKE_LATE_US 10000	/* 10ms */
 
 #define BAR_NUM 0
 
-- 
1.9.1

