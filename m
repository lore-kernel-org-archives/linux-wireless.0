Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36324 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbbCUUQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 16:16:20 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kevin Mullican <kevin@mullican.com>,
	Shao Fu <shaofu@realtek.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: Fix IOMMU mapping leak in AP mode
Date: Sat, 21 Mar 2015 15:16:05 -0500
Message-Id: <1426968965-30161-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150321_211626_340019_C3EF85BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Transmission of an AP beacon does not call the TX interrupt service routine,
which usually does the cleanup. Instead, cleanup is handled in a tasklet
completion routine. Unfortunately, this routine has a serious bug in that it does
not release the DMA mapping before it frees the skb, thus one IOMMU mapping is
leaked for each beacon. The test system failed with no free IOMMU mapping slots
approximately one hour after hostapd was used to start an AP.

This issue was reported and tested at https://github.com/lwfinger/rtlwifi_new/issues/30.

Reported-and-tested-by: Kevin Mullican <kevin@mullican.com>
Cc: Kevin Mullican <kevin@mullican.com>
Signed-off-by: Shao Fu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>  [3.18+]
---

Kalle,

This patch should be applied as soon as possible - 4.0 would be best. I know it is
late in the 4.0 release cycle, but it took a while to diagnose the problem.

Thanks,

Larry
---
 drivers/net/wireless/rtlwifi/pci.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 7069778..11ef17d 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1120,12 +1120,22 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	/*This is for new trx flow*/
 	struct rtl_tx_buffer_desc *pbuffer_desc = NULL;
 	u8 temp_one = 1;
+	u8 *entry;
 
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
+	if (rtlpriv->use_new_trx_flow)
+		entry = (u8 *)(&ring->buffer_desc[ring->idx]);
+	else
+		entry = (u8 *)(&ring->desc[ring->idx]);
+	if (pskb) {
+		pci_unmap_single(rtlpci->pdev,
+				 rtlpriv->cfg->ops->get_desc(
+				 (u8 *)entry, true, HW_DESC_TXBUFF_ADDR),
+				 pskb->len, PCI_DMA_TODEVICE);
 		kfree_skb(pskb);
+	}
 
 	/*NB: the beacon data buffer must be 32-bit aligned. */
 	pskb = ieee80211_beacon_get(hw, mac->vif);
-- 
2.1.4

