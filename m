Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100Ab3CNLsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 07:48:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Krzysztof Kolasa <kkolasa@winsoft.pl>,
	Pedro Francisco <pedrogfrancisco@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.9] iwl3945: fix length of dma buffers
Date: Thu, 14 Mar 2013 12:48:40 +0100
Message-Id: <1363261720-4344-1-git-send-email-sgruszka@redhat.com> (sfid-20130314_124855_270788_E33C9E4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit bdb084b22d8aee66c87af5e9c36bd6cf7f3bccfd
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Wed Feb 13 15:49:08 2013 +0100

    iwlegacy: more checks for dma mapping errors
 
broke il3945_tx_skb() dma buffer length settings, what results on
firmware errors like showed below and make 3945 device non usable.

iwl3945 0000:02:00.0: Microcode SW error detected. Restarting 0x82000008.
iwl3945 0000:02:00.0: Loaded firmware version: 15.32.2.9
iwl3945 0000:02:00.0: Start IWL Error Log Dump:
iwl3945 0000:02:00.0: Status: 0x000202E4, count: 1
iwl3945 0000:02:00.0: Desc 	Time	   asrtPC blink2 ilink1  nmiPC   Line
iwl3945 0000:02:00.0: SYSASSERT     (0x5) 0000208934 0x008B6 0x0035E 0x00320 0x00000 267
iwl3945 0000:02:00.0: Error Reply type 0x00000001 cmd

Reported-by: Zdenek Kabelac <zkabelac@redhat.com> 
Reported-by: Krzysztof Kolasa <kkolasa@winsoft.pl>
Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com> 
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 3630a41..c353b5f 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -475,6 +475,7 @@ il3945_tx_skb(struct il_priv *il,
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
 	u16 len, idx, hdr_len;
+	u16 firstlen, secondlen;
 	u8 id;
 	u8 unicast;
 	u8 sta_id;
@@ -589,21 +590,22 @@ il3945_tx_skb(struct il_priv *il,
 	len =
 	    sizeof(struct il3945_tx_cmd) + sizeof(struct il_cmd_header) +
 	    hdr_len;
-	len = (len + 3) & ~3;
+	firstlen = (len + 3) & ~3;
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
 	txcmd_phys =
-	    pci_map_single(il->pci_dev, &out_cmd->hdr, len, PCI_DMA_TODEVICE);
+	    pci_map_single(il->pci_dev, &out_cmd->hdr, firstlen,
+			   PCI_DMA_TODEVICE);
 	if (unlikely(pci_dma_mapping_error(il->pci_dev, txcmd_phys)))
 		goto drop_unlock;
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
-	len = skb->len - hdr_len;
-	if (len) {
+	secondlen = skb->len - hdr_len;
+	if (secondlen > 0) {
 		phys_addr =
-		    pci_map_single(il->pci_dev, skb->data + hdr_len, len,
+		    pci_map_single(il->pci_dev, skb->data + hdr_len, secondlen,
 				   PCI_DMA_TODEVICE);
 		if (unlikely(pci_dma_mapping_error(il->pci_dev, phys_addr)))
 			goto drop_unlock;
@@ -611,12 +613,12 @@ il3945_tx_skb(struct il_priv *il,
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
+	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	dma_unmap_len_set(out_meta, len, len);
-	if (len)
-		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, len, 0,
-					       U32_PAD(len));
+	dma_unmap_len_set(out_meta, len, firstlen);
+	if (secondlen > 0)
+		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen, 0,
+					       U32_PAD(secondlen));
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
-- 
1.7.1

