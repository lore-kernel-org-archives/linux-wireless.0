Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34389 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164693AbdEYALi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:38 -0400
Received: by mail-pf0-f178.google.com with SMTP id 9so150117018pfj.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:38 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 04/14] mwifiex: pcie: don't allow cmd buffer reuse after reset
Date: Wed, 24 May 2017 17:11:09 -0700
Message-Id: <20170525001119.64791-4-briannorris@chromium.org> (sfid-20170525_021431_582981_A68F7E72)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
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
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index ea75315bf19d..3d5c29d79609 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1060,12 +1060,14 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
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
@@ -2946,7 +2948,6 @@ static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
 	mwifiex_pcie_delete_evtbd_ring(adapter);
 	mwifiex_pcie_delete_rxbd_ring(adapter);
 	mwifiex_pcie_delete_txbd_ring(adapter);
-	card->cmdrsp_buf = NULL;
 }
 
 /*
-- 
2.13.0.219.gdb65acc882-goog
