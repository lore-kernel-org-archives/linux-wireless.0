Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0KLQmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:42:38 -0500
Date: Fri, 12 Nov 2010 17:46:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] iwlagn: simplify iwlagn_tx_skb
Message-ID: <20101112164620.GA10877@redhat.com>
References: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
 <1289548027-3383-2-git-send-email-sgruszka@redhat.com>
 <1289577125.16178.7.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289577125.16178.7.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Nov 12, 2010 at 07:52:05AM -0800, Guy, Wey-Yi wrote:
> On Thu, 2010-11-11 at 23:47 -0800, Stanislaw Gruszka wrote:
> > We can simplify length calculation in iwlagn_tx_skb, that function
> > is enough complex, without fuzz it more than necessary.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   33 ++++++++++------------------
> >  1 files changed, 12 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> > index 2b078a9..1205cec 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
> > @@ -522,7 +522,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
> >  	dma_addr_t phys_addr;
> >  	dma_addr_t txcmd_phys;
> >  	dma_addr_t scratch_phys;
> > -	u16 len, len_org, firstlen, secondlen;
> > +	u16 len, firstlen, secondlen;
> >  	u16 seq_number = 0;
> >  	__le16 fc;
> >  	u8 hdr_len;
> > @@ -687,30 +687,23 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
> >  	 */
> >  	len = sizeof(struct iwl_tx_cmd) +
> >  		sizeof(struct iwl_cmd_header) + hdr_len;
> > -
> > -	len_org = len;
> > -	firstlen = len = (len + 3) & ~3;
> > -
> > -	if (len_org != len)
> > -		len_org = 1;
> > -	else
> > -		len_org = 0;
> > +	firstlen = (len + 3) & ~3;
> >  
> >  	/* Tell NIC about any 2-byte padding after MAC header */
> > -	if (len_org)
> > +	if (firstlen != len)
> >  		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
> >  
> >  	/* Physical address of this Tx command's header (not MAC header!),
> >  	 * within command buffer array. */
> >  	txcmd_phys = pci_map_single(priv->pci_dev,
> > -				    &out_cmd->hdr, len,
> > +				    &out_cmd->hdr, firstlen,
> >  				    PCI_DMA_BIDIRECTIONAL);
> >  	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
> > -	dma_unmap_len_set(out_meta, len, len);
> > +	dma_unmap_len_set(out_meta, len, firstlen);
> 
> it is possible len != firstlen, right?

Yes it is, firstlen is aligned up to 4 byes value, txcmd_phys dma map
size is firstlen and in consequence I use it every time with txcmd_phys.

> >  	/* Add buffer containing Tx command and MAC(!) header to TFD's
> >  	 * first entry */
> >  	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
> > -						   txcmd_phys, len, 1, 0);
> > +						   txcmd_phys, firstlen, 1, 0);
> >  
> >  	if (!ieee80211_has_morefrags(hdr->frame_control)) {
> >  		txq->need_update = 1;
> > @@ -721,23 +714,21 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
> >  
> >  	/* Set up TFD's 2nd entry to point directly to remainder of skb,
> >  	 * if any (802.11 null frames have no payload). */
> > -	secondlen = len = skb->len - hdr_len;
> > -	if (len) {
> > +	secondlen = skb->len - hdr_len;
> > +	if (secondlen > 0) {
> >  		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
> > -					   len, PCI_DMA_TODEVICE);
> > +					   secondlen, PCI_DMA_TODEVICE);
> >  		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
> > -							   phys_addr, len,
> > +							   phys_addr, secondlen,
> >  							   0, 0);
> >  	}
> >  
> >  	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
> >  				offsetof(struct iwl_tx_cmd, scratch);
> >  
> > -	len = sizeof(struct iwl_tx_cmd) +
> > -		sizeof(struct iwl_cmd_header) + hdr_len;
> >  	/* take back ownership of DMA buffer to enable update */
> >  	pci_dma_sync_single_for_cpu(priv->pci_dev, txcmd_phys,
> > -				    len, PCI_DMA_BIDIRECTIONAL);
> > +				    firstlen, PCI_DMA_BIDIRECTIONAL);
> 
> same here, "firstlen" not necessary equal "len"

I guess its enough to sync just "len" but I prefer to use the
size we used to map dma.

Stanislaw
