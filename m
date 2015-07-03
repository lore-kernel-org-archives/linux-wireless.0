Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59442 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbbGCNzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 09:55:47 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix target to cpu address conversion logic
Date: Fri, 3 Jul 2015 19:25:27 +0530
Message-ID: <1435931727-300-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150703_155551_140124_506EEADD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'commit 418ca5992e2f ("ath10k: Make target cpu address to
CE address conversion chip specific")' mask 0x7fff is added
by mistake instead of 0x7ff. Fix this regression.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 130746b..a69bfa4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -765,7 +765,7 @@ static u32 ath10k_pci_targ_cpu_to_ce_addr(struct ath10k *ar, u32 addr)
 	case ATH10K_HW_QCA6174:
 		val = (ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
 					  CORE_CTRL_ADDRESS) &
-		       0x7fff) << 21;
+		       0x7ff) << 21;
 		break;
 	case ATH10K_HW_QCA99X0:
 		val = ath10k_pci_read32(ar, PCIE_BAR_REG_ADDRESS);
-- 
1.9.1

