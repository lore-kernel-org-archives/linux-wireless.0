Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:49360 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZCWAhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 20:37:09 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1562973qwh.37
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 17:37:06 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
	 <1237581564.21165.5.camel@abhi-desktop>
	 <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 20:37:01 -0400
Message-Id: <1237768621.8764.13.camel@rainbow> (sfid-20090323_013715_377932_93011D77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-03-22 at 13:29 -0400, Jason Andryuk wrote:
> The patch did not work.
> 
> However, I do not think it's an alignment issue.
> 
> pci_map_single on x86_64 with >3G memory and no IOMMU uses the swiotlb
> by default.  swiotlb provides "bounce buffers" for physical addresses
> over 4GB.  So for memory where the kmalloc value is at a physical
> address over 2**32, pci_map_single will copy to a swiotlb slot.  That
> means the dma_handle return value of pci_map_single is not necessarily
> the physical address of the virtual address.
> 
> In iwl3945_tx_skb (iwl3945-base.c line 1099) use the pci_map_single
> which copies the memory of out_cmd at that time.  However,
> iwl3945_build_tx_cmd_basic, iwl3945_hw_build_tx_cmd_rate, and
> iwl3945_build_tx_cmd_hwcrypto are all passed out_cmd and modify memory
> located there.  These modifications are not reflected in the memory
> located at txcmd_phys.
> 
> pci_map_single should only be called once the tx command structures
> are completely written.
> 
> Additionally, pci_unmap_single should be called once the memory is no
> longer needed to free the swiotlb entry for that command.  I am not
> sure if this is currently handled for all cases.
> 
> Previous use of pci_alloc_coherent meant that memory would allocated
> at an physical address below 4GB and kept in-sync both the device and
> cpu.
> 
> Refer to Documentation/x86/x86_64/boot-options.txt and lib/swiotlb.c
> for information on IOMMU and swiotlb
> 
> Jason

I hacked up an inelegant patch that does get the driver working.

We call pci_dma_sync_single_for_device to ensure the correct contents
are visible to the device.  That is, we copy out_cmd to phys_addr, so
the desired contents are viewable for the device.

I tried moving the pci_map_single call to right before the call to
iwl_txq_update_write_ptr, but I never got that working successfully.
Presumably that is how the problem should be fixed.  Another failed
attempt was to map from "out_cmd + offsetof(struck iwl_cmd, hdr)"
instead of out_cmd.  The phys_addr + offsetof(struck iwl_cmd, hdr) is
what is passed to txq_attach_buf_to_tfd, so I thought that should work.
Unfortunately it did not.  The added benefit would have been that it
moved "len" and "mapping" of struct iwl_cmd_meta out of the mapped area.
Then losing them since they were written after the mapping would not
have been a problem. 

If struct iwl_cmd_meta's len and mapping members are read by one of the
"reclaim" functions, then they should probably be sync'ed with
pci_dma_sync_single_for_cpu beforehand.

Jason

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index b13862a..8ec26c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -975,6 +975,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	pci_unmap_len_set(&out_cmd->meta, len, len);
 	phys_addr += offsetof(struct iwl_cmd, hdr);
 
+	pci_dma_sync_single_for_device(priv->pci_dev, phys_addr,
+				   len, PCI_DMA_BIDIRECTIONAL);
+
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   phys_addr, fix_size, 1,
 						   U32_PAD(cmd->len));
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 279d10c..a32ee4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1151,6 +1151,12 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
 			   ieee80211_hdrlen(fc));
 
+	pci_dma_sync_single_for_device(priv->pci_dev,
+				    txcmd_phys, sizeof(struct iwl_cmd),
+				    PCI_DMA_TODEVICE);
+	pci_dma_sync_single_for_device(priv->pci_dev, phys_addr,
+					   skb->len - hdr_len,
+				PCI_DMA_TODEVICE);
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl_txq_update_write_ptr(priv, txq);

