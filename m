Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41325 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbaIRNf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:35:58 -0400
Received: by mail-wi0-f182.google.com with SMTP id hi2so226413wib.15
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:35:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: add debug dump for pci rx
Date: Thu, 18 Sep 2014 15:25:21 +0200
Message-Id: <1411046721-20510-4-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153607_083840_A01983AD)
In-Reply-To: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com>
References: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to debug the device-target
communication at a very low level.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 59e0ea8..8319d83 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -861,6 +861,12 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 		}
 
 		skb_put(skb, nbytes);
+
+		ath10k_dbg(ar, ATH10K_DBG_PCI, "pci rx ce pipe %d len %d\n",
+			   ce_state->id, skb->len);
+		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci rx: ",
+				skb->data, skb->len);
+
 		cb->rx_completion(ar, skb, pipe_info->pipe_num);
 	}
 
-- 
1.8.5.3

