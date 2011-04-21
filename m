Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab1DUHSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 03:18:31 -0400
Date: Thu, 21 Apr 2011 09:17:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: fix possible data overwrite in hcmd callback
Message-ID: <20110421071749.GA2203@redhat.com>
References: <1303308178-5297-1-git-send-email-sgruszka@redhat.com>
 <1303308348.14995.149.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303308348.14995.149.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Wed, Apr 20, 2011 at 07:05:48AM -0700, Guy, Wey-Yi wrote:
> > -	spin_lock_irqsave(&priv->hcmd_lock, flags);
> > -
> >  	cmd_index = get_cmd_index(&txq->q, index, huge);
> >  	cmd = txq->cmd[cmd_index];
> >  	meta = &txq->meta[cmd_index];
> > @@ -634,13 +629,14 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
> >  			 dma_unmap_len(meta, len),
> >  			 PCI_DMA_BIDIRECTIONAL);
> >  
> > -	callback = NULL;
> >  	/* Input error checking is done when commands are added to queue. */
> >  	if (meta->flags & CMD_WANT_SKB) {
> >  		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
> >  		rxb->page = NULL;
> > -	} else
> > -		callback = meta->callback;
> > +	} else if (meta->callback)
> > +		meta->callback(priv, cmd, pkt);
> > +
> > +	spin_lock_irqsave(&priv->hcmd_lock, flags);
> >  
> >  	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
> >  
> > @@ -655,7 +651,4 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
> >  	meta->flags = 0;
> >  
> >  	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
> > -
> > -	if (callback)
> > -		callback(priv, cmd, pkt);
> >  }
> 
> Could you elaborate a bit more, why you do not need to protect getting
> the cmd index.

get_cmd_index() is simple mathematical function of index local variable
(provided by firmware) and globally canst q->n_window, not need to be
protected.

What need to be protected is iwl_hcdm_queue_reclaim() as is touch
q->read_ptr and meta->flags to make assure is synchronized across
different cpus, when new huge command come instantly.

Note circular queue management could be done lock-less, but need
trickery described in Documentation/circular-buffers.txt to synchronize
q->read_ptr and q->write_ptr properly. What is probably too complex to
be worth to consider instead of simply using a spin lock.

Stanislaw
