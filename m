Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab3BRIkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 03:40:51 -0500
Date: Mon, 18 Feb 2013 09:40:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwl4965: fix 'phys_addr' may be used uninitialized
Message-ID: <20130218084037.GB1583@redhat.com> (sfid-20130218_094057_636677_3ED2953F)
References: <20130215095221.GE4392@redhat.com>
 <20130215192627.GE4981@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130215192627.GE4981@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2013 at 02:26:27PM -0500, John W. Linville wrote:
> I still get the warning when building wireless-next on my F17 box
> with this patch applied...

I have no warning of F17 with:

gcc-4.7.2-2.fc17.x86_64

perhaps you use i686 or kernel config is different.

This warning must be a false positive. The code looks like below:

        secondlen = skb->len - hdr_len;
        if (secondlen > 0) {
                phys_addr =
                    pci_map_single(il->pci_dev, skb->data + hdr_len, secondlen,
                                   PCI_DMA_TODEVICE);
                if (unlikely(pci_dma_mapping_error(il->pci_dev, phys_addr)))
                        goto drop_unlock;
        }
	/* */
        if (secondlen > 0)
                il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen,
                                               0, 0);

and there are no other places where phys_addr is used.

I just realized that secondlen is u16, so there is no difference between
"if (secondlen)" and "if (secondlen > 0)". So this patch can be dropped.

Stanislaw

> On Fri, Feb 15, 2013 at 10:52:21AM +0100, Stanislaw Gruszka wrote:
> > This should fix:
> > 
> > drivers/net/wireless/iwlegacy/4965-mac.c:1847:33: warning: 'phys_addr' may be used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> > index 7941eb3..d2ab1cf 100644
> > --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> > +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> > @@ -1843,7 +1843,7 @@ il4965_tx_skb(struct il_priv *il,
> >  	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
> >  	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
> >  	dma_unmap_len_set(out_meta, len, firstlen);
> > -	if (secondlen)
> > +	if (secondlen > 0)
> >  		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen,
> >  					       0, 0);
> >  
> > -- 
> > 1.7.11.7
> > 
> > 
> 
> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
