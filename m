Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:53817 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZDUBlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 21:41:49 -0400
Received: by yx-out-2324.google.com with SMTP id 3so980482yxj.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 18:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238538161.10366.144.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
	 <1237581564.21165.5.camel@abhi-desktop>
	 <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com>
	 <1237768621.8764.13.camel@rainbow>
	 <1238538161.10366.144.camel@rc-desk>
Date: Mon, 20 Apr 2009 21:41:47 -0400
Message-ID: <c4d76b3b0904201841m502cb3bbw45a0c5c1c52295ba@mail.gmail.com> (sfid-20090421_034159_163998_BDD0494D)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette,

This patch never made it to wireless-testing.

Jason

On Tue, Mar 31, 2009 at 6:22 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> I addressed these issues as well as a few more that I uncovered while
> digging into this.
>
> Could you please try this patch?
>
>
> >From c152258435c047dfd7423e0279781c3fcb2f4e71 Mon Sep 17 00:00:00 20=
01
> From: Reinette Chatre <reinette.chatre@intel.com>
> Date: Tue, 31 Mar 2009 14:16:05 -0700
> Subject: [PATCH] iwlwifi: DMA fixes
>
> A few issues wrt DMA were uncovered when using the driver with swiotl=
b.
> - driver should not use memory after it has been mapped
> - iwl3945's RX queue management cannot use all of iwlagn because
> =A0the size of the RX buffer is different. Revert back to using
> =A0iwl3945 specific routines that map/unmap memory.
> - no need to "dma_syn_single_range_for_cpu" followed by pci_unmap_sin=
gle,
> =A0we can just call pci_unmap_single initially
> - only map the memory area that will be used by device. this is espec=
ially
> =A0relevant to the mapping of iwl_cmd. we should not map the entire
> =A0structure because the meta data at the beginning of structure cont=
ains
> =A0the address to be used later for unmapping. If the address to be u=
sed for
> =A0unmapping is stored in mapped data it creates a problem.
> - ensure that _if_ memory needs to be modified after it is mapped tha=
t we
> =A0call _sync_single_for_cpu first, and then release it back to devic=
e with
> =A0_sync_single_for_device
> - we mapped the wrong length of data for host commands, with mapped l=
ength
> =A0differing with length provided to device, fix that.
>
> Thanks to Jason Andryuk <jandryuk@gmail.com> for significant bisectin=
g
> help to find these issues.
>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> CC: Jason Andryuk <jandryuk@gmail.com>
> ---
> =A0drivers/net/wireless/iwlwifi/iwl-3945.c =A0 =A0 | =A0 =A02 +-
> =A0drivers/net/wireless/iwlwifi/iwl-3945.h =A0 =A0 | =A0 =A01 +
> =A0drivers/net/wireless/iwlwifi/iwl-agn.c =A0 =A0 =A0| =A0 11 +--
> =A0drivers/net/wireless/iwlwifi/iwl-dev.h =A0 =A0 =A0| =A0 =A04 +
> =A0drivers/net/wireless/iwlwifi/iwl-tx.c =A0 =A0 =A0 | =A0 93 +++++++=
+++--------
> =A0drivers/net/wireless/iwlwifi/iwl3945-base.c | =A0144 +++++++++++++=
++++++--------
> =A06 files changed, 161 insertions(+), 94 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wi=
reless/iwlwifi/iwl-3945.c
> index d03f553..05cd499 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -1192,7 +1192,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0} else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl_rx_queue_reset(priv, rxq);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl3945_rx_queue_reset(priv, rxq);
>
> =A0 =A0 =A0 =A0iwl3945_rx_replenish(priv);
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wi=
reless/iwlwifi/iwl-3945.h
> index 29bc0d2..3213a63 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
> @@ -214,6 +214,7 @@ extern int iwl3945_calc_sig_qual(int rssi_dbm, in=
t noise_dbm);
> =A0extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct iwl_tx=
_queue *txq, int count, u32 id);
> =A0extern void iwl3945_rx_replenish(void *data);
> +extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl=
_rx_queue *rxq);
> =A0extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iw=
l_tx_queue *txq);
> =A0extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 =
len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const void *da=
ta);
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wir=
eless/iwlwifi/iwl-agn.c
> index 51f6a01..ea859f6 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -976,11 +976,9 @@ void iwl_rx_handle(struct iwl_priv *priv)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rxq->queue[i] =3D NULL;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_sync_single_range_for_cpu(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &priv->=
pci_dev->dev, rxb->real_dma_addr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rxb->al=
igned_dma_addr - rxb->real_dma_addr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->h=
w_params.rx_buf_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PCI_DMA=
_FROMDEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(priv->pci_dev, rxb->re=
al_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0priv=
->hw_params.rx_buf_size + 256,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PCI_=
DMA_FROMDEVICE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pkt =3D (struct iwl_rx_packet *)rxb->s=
kb->data;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Reclaim a command buffer only if th=
is packet is a response
> @@ -1031,9 +1029,6 @@ void iwl_rx_handle(struct iwl_priv *priv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rxb->skb =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(priv->pci_dev, rxb->re=
al_dma_addr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0priv=
->hw_params.rx_buf_size + 256,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PCI_=
DMA_FROMDEVICE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&rxq->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&rxb->list, &priv->rxq.r=
x_used);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&rxq->lock, fla=
gs);
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wir=
eless/iwlwifi/iwl-dev.h
> index 0baae80..721c80f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -360,12 +360,16 @@ struct iwl_host_cmd {
>
> =A0/**
> =A0* struct iwl_rx_queue - Rx queue
> + * @bd: driver's pointer to buffer of receive buffer descriptors (rb=
d)
> + * @dma_addr: bus address of buffer of receive buffer descriptors (r=
bd)
> =A0* @read: Shared index to newest available Rx buffer
> =A0* @write: Shared index to oldest written Rx packet
> =A0* @free_count: Number of pre-allocated buffers in rx_free
> =A0* @rx_free: list of free SKBs for use
> =A0* @rx_used: List of Rx buffers with no SKB
> =A0* @need_update: flag to indicate we need to update read/write inde=
x
> + * @rb_stts: driver's pointer to receive buffer status
> + * @rb_stts_dma: bus address of receive buffer status
> =A0*
> =A0* NOTE: =A0rx_free and rx_used are used as a FIFO for iwl_rx_mem_b=
uffers
> =A0*/
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wire=
less/iwlwifi/iwl-tx.c
> index 57ea320..f85b47f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -797,6 +797,22 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_=
buff *skb)
> =A0 =A0 =A0 =A0/* Copy MAC header from skb into command buffer */
> =A0 =A0 =A0 =A0memcpy(tx_cmd->hdr, hdr, hdr_len);
>
> +
> + =A0 =A0 =A0 /* Total # bytes to be transmitted */
> + =A0 =A0 =A0 len =3D (u16)skb->len;
> + =A0 =A0 =A0 tx_cmd->len =3D cpu_to_le16(len);
> +
> + =A0 =A0 =A0 if (info->control.hw_key)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl_tx_cmd_build_hwcrypto(priv, info, t=
x_cmd, skb, sta_id);
> +
> + =A0 =A0 =A0 /* TODO need this for burst mode later on */
> + =A0 =A0 =A0 iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id)=
;
> +
> + =A0 =A0 =A0 /* set is_hcca to 0; it probably will never be implemen=
ted */
> + =A0 =A0 =A0 iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0=
);
> +
> + =A0 =A0 =A0 iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Use the first empty entry in this queue's command b=
uffer array
> =A0 =A0 =A0 =A0 * to contain the Tx command and MAC header concatenat=
ed together
> @@ -817,21 +833,30 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk=
_buff *skb)
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len_org =3D 0;
>
> + =A0 =A0 =A0 /* Tell NIC about any 2-byte padding after MAC header *=
/
> + =A0 =A0 =A0 if (len_org)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx_cmd->tx_flags |=3D TX_CMD_FLG_MH_PAD=
_MSK;
> +
> =A0 =A0 =A0 =A0/* Physical address of this Tx command's header (not M=
AC header!),
> =A0 =A0 =A0 =A0 * within command buffer array. */
> =A0 =A0 =A0 =A0txcmd_phys =3D pci_map_single(priv->pci_dev,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 out_cmd, sizeof(struct iwl_cmd),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 &out_cmd->hdr, len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PCI_DMA_BIDIRECTIONAL);
> =A0 =A0 =A0 =A0pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys=
);
> - =A0 =A0 =A0 pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iw=
l_cmd));
> + =A0 =A0 =A0 pci_unmap_len_set(&out_cmd->meta, len, len);
> =A0 =A0 =A0 =A0/* Add buffer containing Tx command and MAC(!) header =
to TFD's
> =A0 =A0 =A0 =A0 * first entry */
> - =A0 =A0 =A0 txcmd_phys +=3D offsetof(struct iwl_cmd, hdr);
> =A0 =A0 =A0 =A0priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 txcmd_phys, len, 1, 0);
>
> - =A0 =A0 =A0 if (info->control.hw_key)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl_tx_cmd_build_hwcrypto(priv, info, t=
x_cmd, skb, sta_id);
> + =A0 =A0 =A0 if (!ieee80211_has_morefrags(hdr->frame_control)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (qc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->stations[sta_id].=
tid[tid].seq_number =3D seq_number;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_write_ptr =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 0;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* Set up TFD's 2nd entry to point directly to remaind=
er of skb,
> =A0 =A0 =A0 =A0 * if any (802.11 null frames have no payload). */
> @@ -844,42 +869,26 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk=
_buff *skb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, 0);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* Tell NIC about any 2-byte padding after MAC header *=
/
> - =A0 =A0 =A0 if (len_org)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx_cmd->tx_flags |=3D TX_CMD_FLG_MH_PAD=
_MSK;
> -
> - =A0 =A0 =A0 /* Total # bytes to be transmitted */
> - =A0 =A0 =A0 len =3D (u16)skb->len;
> - =A0 =A0 =A0 tx_cmd->len =3D cpu_to_le16(len);
> - =A0 =A0 =A0 /* TODO need this for burst mode later on */
> - =A0 =A0 =A0 iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id)=
;
> -
> - =A0 =A0 =A0 /* set is_hcca to 0; it probably will never be implemen=
ted */
> - =A0 =A0 =A0 iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0=
);
> -
> - =A0 =A0 =A0 iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
> -
> =A0 =A0 =A0 =A0scratch_phys =3D txcmd_phys + sizeof(struct iwl_cmd_he=
ader) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsetof(struct iwl_tx_cmd, scratch);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offseto=
f(struct iwl_tx_cmd, scratch);
> +
> + =A0 =A0 =A0 len =3D sizeof(struct iwl_tx_cmd) +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct iwl_cmd_header) + hdr_len=
;
> + =A0 =A0 =A0 /* take back ownership of DMA buffer to enable update *=
/
> + =A0 =A0 =A0 pci_dma_sync_single_for_cpu(priv->pci_dev, txcmd_phys,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 len, PCI_DMA_BIDIRECTIONAL);
> =A0 =A0 =A0 =A0tx_cmd->dram_lsb_ptr =3D cpu_to_le32(scratch_phys);
> =A0 =A0 =A0 =A0tx_cmd->dram_msb_ptr =3D iwl_get_dma_hi_addr(scratch_p=
hys);
>
> - =A0 =A0 =A0 if (!ieee80211_has_morefrags(hdr->frame_control)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (qc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->stations[sta_id].=
tid[tid].seq_number =3D seq_number;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_write_ptr =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 0;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, size=
of(*tx_cmd));
> -
> =A0 =A0 =A0 =A0iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr,=
 hdr_len);
>
> =A0 =A0 =A0 =A0/* Set up entry for this TFD in Tx byte-count array */
> =A0 =A0 =A0 =A0priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq=
, len);
>
> + =A0 =A0 =A0 pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phy=
s,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0len, PCI_DMA_BIDIRECTIONAL);
> +
> =A0 =A0 =A0 =A0/* Tell device the write index *just past* this latest=
 filled TFD */
> =A0 =A0 =A0 =A0q->write_ptr =3D iwl_queue_inc_wrap(q->write_ptr, q->n=
_bd);
> =A0 =A0 =A0 =A0ret =3D iwl_txq_update_write_ptr(priv, txq);
> @@ -966,18 +975,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, stru=
ct iwl_host_cmd *cmd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0INDEX_TO_SEQ(q->write_=
ptr));
> =A0 =A0 =A0 =A0if (out_cmd->meta.flags & CMD_SIZE_HUGE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out_cmd->hdr.sequence |=3D SEQ_HUGE_FR=
AME;
> - =A0 =A0 =A0 len =3D (idx =3D=3D TFD_CMD_SLOTS) ?
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IWL_MAX_SCAN_SIZE : siz=
eof(struct iwl_cmd);
> -
> - =A0 =A0 =A0 phys_addr =3D pci_map_single(priv->pci_dev, out_cmd,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
len, PCI_DMA_BIDIRECTIONAL);
> - =A0 =A0 =A0 pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
> - =A0 =A0 =A0 pci_unmap_len_set(&out_cmd->meta, len, len);
> - =A0 =A0 =A0 phys_addr +=3D offsetof(struct iwl_cmd, hdr);
> + =A0 =A0 =A0 len =3D sizeof(struct iwl_cmd) - sizeof(struct iwl_cmd_=
meta);
> + =A0 =A0 =A0 len +=3D (idx =3D=3D TFD_CMD_SLOTS) ? =A0IWL_MAX_SCAN_S=
IZE : 0;
>
> - =A0 =A0 =A0 priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phys_addr, fix_size, 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0U32_PAD(cmd->len));
>
> =A0#ifdef CONFIG_IWLWIFI_DEBUG
> =A0 =A0 =A0 =A0switch (out_cmd->hdr.cmd) {
> @@ -1005,6 +1005,15 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, st=
ruct iwl_host_cmd *cmd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Set up entry in queue's byte count =
circular buffer */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0priv->cfg->ops->lib->txq_update_byte_c=
nt_tbl(priv, txq, 0);
>
> + =A0 =A0 =A0 phys_addr =3D pci_map_single(priv->pci_dev, &out_cmd->h=
dr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fix_size, PCI_DMA_BIDIRECTIONAL);
> + =A0 =A0 =A0 pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
> + =A0 =A0 =A0 pci_unmap_len_set(&out_cmd->meta, len, fix_size);
> +
> + =A0 =A0 =A0 priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phys_addr, fix_size, 1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0U32_PAD(cmd->len));
> +
> =A0 =A0 =A0 =A0/* Increment and update queue's write index */
> =A0 =A0 =A0 =A0q->write_ptr =3D iwl_queue_inc_wrap(q->write_ptr, q->n=
_bd);
> =A0 =A0 =A0 =A0ret =3D iwl_txq_update_write_ptr(priv, txq);
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/ne=
t/wireless/iwlwifi/iwl3945-base.c
> index c29189b..c4c8943 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -972,7 +972,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, =
struct sk_buff *skb)
> =A0 =A0 =A0 =A0dma_addr_t phys_addr;
> =A0 =A0 =A0 =A0dma_addr_t txcmd_phys;
> =A0 =A0 =A0 =A0int txq_id =3D skb_get_queue_mapping(skb);
> - =A0 =A0 =A0 u16 len, idx, len_org, hdr_len;
> + =A0 =A0 =A0 u16 len, idx, len_org, hdr_len; /* TODO: len_org is not=
 used */
> =A0 =A0 =A0 =A0u8 id;
> =A0 =A0 =A0 =A0u8 unicast;
> =A0 =A0 =A0 =A0u8 sta_id;
> @@ -1074,6 +1074,38 @@ static int iwl3945_tx_skb(struct iwl_priv *pri=
v, struct sk_buff *skb)
> =A0 =A0 =A0 =A0/* Copy MAC header from skb into command buffer */
> =A0 =A0 =A0 =A0memcpy(tx->hdr, hdr, hdr_len);
>
> +
> + =A0 =A0 =A0 if (info->control.hw_key)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl3945_build_tx_cmd_hwcrypto(priv, inf=
o, out_cmd, skb, sta_id);
> +
> + =A0 =A0 =A0 /* TODO need this for burst mode later on */
> + =A0 =A0 =A0 iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, st=
a_id);
> +
> + =A0 =A0 =A0 /* set is_hcca to 0; it probably will never be implemen=
ted */
> + =A0 =A0 =A0 iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, =
sta_id, 0);
> +
> + =A0 =A0 =A0 /* Total # bytes to be transmitted */
> + =A0 =A0 =A0 len =3D (u16)skb->len;
> + =A0 =A0 =A0 tx->len =3D cpu_to_le16(len);
> +
> +
> + =A0 =A0 =A0 tx->tx_flags &=3D ~TX_CMD_FLG_ANT_A_MSK;
> + =A0 =A0 =A0 tx->tx_flags &=3D ~TX_CMD_FLG_ANT_B_MSK;
> +
> + =A0 =A0 =A0 if (!ieee80211_has_morefrags(hdr->frame_control)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (qc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->stations_39[sta_i=
d].tid[tid].seq_number =3D seq_number;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_write_ptr =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
> +
> + =A0 =A0 =A0 iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ieee80211_hdrlen=
(fc));
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Use the first empty entry in this queue's command b=
uffer array
> =A0 =A0 =A0 =A0 * to contain the Tx command and MAC header concatenat=
ed together
> @@ -1096,22 +1128,18 @@ static int iwl3945_tx_skb(struct iwl_priv *pr=
iv, struct sk_buff *skb)
>
> =A0 =A0 =A0 =A0/* Physical address of this Tx command's header (not M=
AC header!),
> =A0 =A0 =A0 =A0 * within command buffer array. */
> - =A0 =A0 =A0 txcmd_phys =3D pci_map_single(priv->pci_dev,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 out_cmd, sizeof(struct iwl_cmd),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 PCI_DMA_TODEVICE);
> + =A0 =A0 =A0 txcmd_phys =3D pci_map_single(priv->pci_dev, &out_cmd->=
hdr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 len, PCI_DMA_TODEVICE);
> + =A0 =A0 =A0 /* we do not map meta data ... so we can safely access =
address to
> + =A0 =A0 =A0 =A0* provide to unmap command*/
> =A0 =A0 =A0 =A0pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys=
);
> - =A0 =A0 =A0 pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iw=
l_cmd));
> - =A0 =A0 =A0 /* Add buffer containing Tx command and MAC(!) header t=
o TFD's
> - =A0 =A0 =A0 =A0* first entry */
> - =A0 =A0 =A0 txcmd_phys +=3D offsetof(struct iwl_cmd, hdr);
> + =A0 =A0 =A0 pci_unmap_len_set(&out_cmd->meta, len, len);
>
> =A0 =A0 =A0 =A0/* Add buffer containing Tx command and MAC(!) header =
to TFD's
> =A0 =A0 =A0 =A0 * first entry */
> =A0 =A0 =A0 =A0priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 txcmd_phys, len, 1, 0);
>
> - =A0 =A0 =A0 if (info->control.hw_key)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl3945_build_tx_cmd_hwcrypto(priv, inf=
o, out_cmd, skb, sta_id);
>
> =A0 =A0 =A0 =A0/* Set up TFD's 2nd entry to point directly to remaind=
er of skb,
> =A0 =A0 =A0 =A0 * if any (802.11 null frames have no payload). */
> @@ -1124,32 +1152,6 @@ static int iwl3945_tx_skb(struct iwl_priv *pri=
v, struct sk_buff *skb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, U32_PAD(len));
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* Total # bytes to be transmitted */
> - =A0 =A0 =A0 len =3D (u16)skb->len;
> - =A0 =A0 =A0 tx->len =3D cpu_to_le16(len);
> -
> - =A0 =A0 =A0 /* TODO need this for burst mode later on */
> - =A0 =A0 =A0 iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, st=
a_id);
> -
> - =A0 =A0 =A0 /* set is_hcca to 0; it probably will never be implemen=
ted */
> - =A0 =A0 =A0 iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, =
sta_id, 0);
> -
> - =A0 =A0 =A0 tx->tx_flags &=3D ~TX_CMD_FLG_ANT_A_MSK;
> - =A0 =A0 =A0 tx->tx_flags &=3D ~TX_CMD_FLG_ANT_B_MSK;
> -
> - =A0 =A0 =A0 if (!ieee80211_has_morefrags(hdr->frame_control)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (qc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->stations_39[sta_i=
d].tid[tid].seq_number =3D seq_number;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_write_ptr =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 txq->need_update =3D 0;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
> -
> - =A0 =A0 =A0 iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ieee80211_hdrlen=
(fc));
>
> =A0 =A0 =A0 =A0/* Tell device the write index *just past* this latest=
 filled TFD */
> =A0 =A0 =A0 =A0q->write_ptr =3D iwl_queue_inc_wrap(q->write_ptr, q->n=
_bd);
> @@ -1661,6 +1663,37 @@ static void iwl3945_rx_allocate(struct iwl_pri=
v *priv)
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&rxq->lock, flags);
> =A0}
>
> +void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_que=
ue *rxq)
> +{
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 spin_lock_irqsave(&rxq->lock, flags);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&rxq->rx_free);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&rxq->rx_used);
> + =A0 =A0 =A0 /* Fill the rx_used queue with _all_ of the Rx buffers =
*/
> + =A0 =A0 =A0 for (i =3D 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* In the reset function, these buffers=
 may have been allocated
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to an SKB, so we need to unmap and=
 free potential storage */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rxq->pool[i].skb !=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(priv->=
pci_dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0rxq->pool[i].real_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0priv->hw_params.rx_buf_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0PCI_DMA_FROMDEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->alloc_rxb_skb--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_kfree_skb(rxq->pool=
[i].skb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rxq->pool[i].skb =3D NU=
LL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&rxq->pool[i].list, &rxq-=
>rx_used);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Set us so that we have processed and used all buffer=
s, but have
> + =A0 =A0 =A0 =A0* not restocked the Rx queue with fresh buffers */
> + =A0 =A0 =A0 rxq->read =3D rxq->write =3D 0;
> + =A0 =A0 =A0 rxq->free_count =3D 0;
> + =A0 =A0 =A0 spin_unlock_irqrestore(&rxq->lock, flags);
> +}
> +EXPORT_SYMBOL(iwl3945_rx_queue_reset);
> +
> =A0/*
> =A0* this should be called while priv->lock is locked
> =A0*/
> @@ -1685,6 +1718,34 @@ void iwl3945_rx_replenish(void *data)
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&priv->lock, flags);
> =A0}
>
> +/* Assumes that the skb field of the buffers in 'pool' is kept accur=
ate.
> + * If an SKB has been detached, the POOL needs to have its SKB set t=
o NULL
> + * This free routine walks the list of POOL entries and if SKB is se=
t to
> + * non NULL it is unmapped and freed
> + */
> +void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queu=
e *rxq)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 for (i =3D 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rxq->pool[i].skb !=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(priv->=
pci_dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0rxq->pool[i].real_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0priv->hw_params.rx_buf_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0PCI_DMA_FROMDEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_kfree_skb(rxq->pool=
[i].skb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, r=
xq->bd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rxq->dma_addr);
> + =A0 =A0 =A0 pci_free_consistent(priv->pci_dev, sizeof(struct iwl_rb=
_status),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rxq->rb_stts, r=
xq->rb_stts_dma);
> + =A0 =A0 =A0 rxq->bd =3D NULL;
> + =A0 =A0 =A0 rxq->rb_stts =A0=3D NULL;
> +}
> +EXPORT_SYMBOL(iwl3945_rx_queue_free);
> +
> +
> =A0/* Convert linear signal-to-noise ratio into dB */
> =A0static u8 ratio2dB[100] =3D {
> =A0/* =A0 =A0 =A00 =A0 1 =A0 2 =A0 3 =A0 4 =A0 5 =A0 6 =A0 7 =A0 8 =A0=
 9 */
> @@ -1802,9 +1863,9 @@ static void iwl3945_rx_handle(struct iwl_priv *=
priv)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rxq->queue[i] =3D NULL;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_dma_sync_single_for_cpu(priv->pci_d=
ev, rxb->real_dma_addr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 priv->hw_params.rx_buf_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 PCI_DMA_FROMDEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(priv->pci_dev, rxb->re=
al_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->h=
w_params.rx_buf_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PCI_DMA=
_FROMDEVICE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pkt =3D (struct iwl_rx_packet *)rxb->s=
kb->data;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Reclaim a command buffer only if th=
is packet is a response
> @@ -1852,9 +1913,6 @@ static void iwl3945_rx_handle(struct iwl_priv *=
priv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rxb->skb =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_unmap_single(priv->pci_dev, rxb->re=
al_dma_addr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->h=
w_params.rx_buf_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PCI_DMA=
_FROMDEVICE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&rxq->lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&rxb->list, &priv->rxq.r=
x_used);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&rxq->lock, fla=
gs);
> @@ -5144,7 +5202,7 @@ static void __devexit iwl3945_pci_remove(struct=
 pci_dev *pdev)
> =A0 =A0 =A0 =A0iwl3945_dealloc_ucode_pci(priv);
>
> =A0 =A0 =A0 =A0if (priv->rxq.bd)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl_rx_queue_free(priv, &priv->rxq);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iwl3945_rx_queue_free(priv, &priv->rxq)=
;
> =A0 =A0 =A0 =A0iwl3945_hw_txq_ctx_free(priv);
>
> =A0 =A0 =A0 =A0iwl3945_unset_hw_params(priv);
> --
> 1.5.6.3
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
