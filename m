Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47957 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaIWIdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 04:33:43 -0400
Received: by mail-wg0-f44.google.com with SMTP id z12so173720wgg.15
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 01:33:42 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/3] ath10k: add debug dump for pci rx
Date: Tue, 23 Sep 2014 10:22:54 +0200
Message-Id: <1411460574-5424-4-git-send-email-michal.kazior@tieto.com> (sfid-20140923_103354_754959_E86483F5)
In-Reply-To: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
References: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
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

