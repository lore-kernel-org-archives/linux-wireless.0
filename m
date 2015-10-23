Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7822 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbJWMb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 08:31:56 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 2/4] ath10k: remove send completion validation in diag read/write
Date: Fri, 23 Oct 2015 18:01:04 +0530
Message-ID: <1445603466-14138-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151023_143212_057820_B61AD78F)
In-Reply-To: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CE diag window access is serialized (it has to be by design) so
there's no way to get a different send completion. so there's no
need for post completion validation.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5c05b0c..6f3c3e0 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -920,16 +920,6 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 			}
 		}
 
-		if (nbytes != completed_nbytes) {
-			ret = -EIO;
-			goto done;
-		}
-
-		if (buf != (u32)address) {
-			ret = -EIO;
-			goto done;
-		}
-
 		i = 0;
 		while (ath10k_ce_completed_recv_next_nolock(ce_diag, NULL, &buf,
 							    &completed_nbytes,
@@ -1094,16 +1084,6 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 			}
 		}
 
-		if (nbytes != completed_nbytes) {
-			ret = -EIO;
-			goto done;
-		}
-
-		if (buf != ce_data) {
-			ret = -EIO;
-			goto done;
-		}
-
 		i = 0;
 		while (ath10k_ce_completed_recv_next_nolock(ce_diag, NULL, &buf,
 							    &completed_nbytes,
-- 
2.6.1

