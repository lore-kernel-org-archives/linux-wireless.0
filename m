Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34255 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756703AbdGYBOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:14 -0400
Received: by mail-pg0-f54.google.com with SMTP id 123so64046332pgj.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:14 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 03/20] mwifiex: pcie: don't allow cmd buffer reuse after reset
Date: Mon, 24 Jul 2017 18:13:19 -0700
Message-Id: <20170725011336.99993-4-briannorris@chromium.org> (sfid-20170725_031514_627727_55374C3F)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rogue cases (due to other bugs) it's possible we try to process an
old command response *after* resetting the device. This could trigger a
double-free (or the SKB can get reallocated elsewhere...causing other
memory corruptions) in mwifiex_pcie_process_cmd_complete().

For safety (and symmetry) let's always NULL out the command buffer as we
free it up. We're already doing this for the command response buffer.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: no change
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index b53ecf1eddda..5c07edd4e094 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1030,12 +1030,14 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 		mwifiex_unmap_pci_memory(adapter, card->cmdrsp_buf,
 					 PCI_DMA_FROMDEVICE);
 		dev_kfree_skb_any(card->cmdrsp_buf);
+		card->cmdrsp_buf = NULL;
 	}
 
 	if (card && card->cmd_buf) {
 		mwifiex_unmap_pci_memory(adapter, card->cmd_buf,
 					 PCI_DMA_TODEVICE);
 		dev_kfree_skb_any(card->cmd_buf);
+		card->cmd_buf = NULL;
 	}
 	return 0;
 }
@@ -2921,7 +2923,6 @@ static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
 	mwifiex_pcie_delete_evtbd_ring(adapter);
 	mwifiex_pcie_delete_rxbd_ring(adapter);
 	mwifiex_pcie_delete_txbd_ring(adapter);
-	card->cmdrsp_buf = NULL;
 }
 
 /*
-- 
2.14.0.rc0.284.gd933b75aa4-goog
