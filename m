Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:16356 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZCSBxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 21:53:00 -0400
Received: by yx-out-2324.google.com with SMTP id 31so341102yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 18:52:58 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1237254243.13077.33.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk> <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk> <1236649234.6685.9.camel@rainbow>
	 <1236661466.15923.53.camel@rc-desk> <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 21:52:48 -0400
Message-Id: <1237427568.6943.13.camel@rainbow> (sfid-20090319_025308_669540_0CFDF43B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-16 at 21:44 -0400, Jason Andryuk wrote:
> I believe there may be some incorrect use of the DMA API.
> 
> My tree is as follows:
> git checkout -f ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
> git cherry-pick -x fadd267e5f9c2319ad62edad30f7af07b6b368ef
> patch -p1 < iwl3945-rb_stts_and_BUG_to_WARN.patch (attached)
> plus patch from below.

Slightly updated patch attached.  len value for SCAN command is
corrected and attach_len saves the correct len value.

Still does not work.  No Microcode SW errors though.

Another potential problem with the SWIOTLB is that pci_unmap_addr_set
writes to out_cmd->meta.  Memory which the driver no longer owns.  This
will probably be a problem when unmapping pages as the address will not
necessarily be present.

I wonder if it is a problem now as pci_map_single is repeatedly called
on the same memory.  The return value is not checked.

The driver doesn't show any calls to iwl3945_rx_reply_tx, either
successful or invalid.  Does that mean the hardware is not updating the
queue pointers?

Have any of the Intel folks make any progress on this?

Jason

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3b39aef..11c5f4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -510,16 +510,9 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 
-	len = (idx == TFD_CMD_SLOTS) ?
-			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
-
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-					len, PCI_DMA_TODEVICE);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
-	phys_addr += offsetof(struct iwl_cmd, hdr);
-
-	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
+	len = sizeof(struct iwl_cmd);
+	if (idx == TFD_CMD_SLOTS)
+		len += IWL_MAX_SCAN_SIZE;
 
 	pad = U32_PAD(cmd->len);
 	tfd->control_flags |= cpu_to_le32(TFD_CTL_PAD_SET(pad));
@@ -532,6 +525,13 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	txq->need_update = 1;
 
+	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
+					len, PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
+	pci_unmap_len_set(&out_cmd->meta, len, len);
+	phys_addr += offsetof(struct iwl_cmd, hdr);
+
+	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
@@ -2263,7 +2263,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
-	u16 len, idx, len_org, hdr_len;
+	u16 len, idx, len_org, hdr_len, attach_len;
 	u8 id;
 	u8 unicast;
 	u8 sta_id;
@@ -2390,42 +2390,11 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	else
 		len_org = 0;
 
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev,
-				    out_cmd, sizeof(struct iwl_cmd),
-				    PCI_DMA_TODEVICE);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
-	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	txcmd_phys += offsetof(struct iwl_cmd, hdr);
-
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
+	attach_len = len;
 
 	if (info->control.hw_key)
 		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, 0);
 
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	len = skb->len - hdr_len;
-	if (len) {
-		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
-					   len, PCI_DMA_TODEVICE);
-		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
-	}
-
-	if (!len)
-		/* If there is no payload, then we use only one Tx buffer */
-		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(1));
-	else
-		/* Else use 2 buffers.
-		 * Tell 3945 about any padding after MAC header */
-		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(2) |
-			TFD_CTL_PAD_SET(U32_PAD(len)));
-
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	tx->len = cpu_to_le16(len);
@@ -2453,6 +2422,39 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
+	len = skb->len - hdr_len;
+	if (!len)
+		/* If there is no payload, then we use only one Tx buffer */
+		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(1));
+	else
+		/* Else use 2 buffers.
+		 * Tell 3945 about any padding after MAC header */
+		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(2) |
+			TFD_CTL_PAD_SET(U32_PAD(len)));
+
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
+	txcmd_phys = pci_map_single(priv->pci_dev,
+				    out_cmd, sizeof(struct iwl_cmd),
+				    PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
+	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	txcmd_phys += offsetof(struct iwl_cmd, hdr);
+
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, attach_len);
+
+	if (len) {
+		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
+					   len, PCI_DMA_TODEVICE);
+		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
+	}
+
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);

