Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:41489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZLBRRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 12:17:10 -0500
Received: by fg-out-1718.google.com with SMTP id 16so187758fgg.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 09:17:15 -0800 (PST)
Subject: Re: Panic in iwl3945 driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259732550.12157.130.camel@debian>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>  <1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop> <1259659724.12157.110.camel@debian>
	 <1259732550.12157.130.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 19:17:06 +0200
Message-ID: <1259774227.26287.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-02 at 13:42 +0800, Zhu Yi wrote: 
> On Tue, 2009-12-01 at 17:28 +0800, Zhu Yi wrote:
> > On Tue, 2009-12-01 at 06:35 +0800, Maxim Levitsky wrote:
> > > 0x000000000001668e <iwl3945_rx_reply_tx+302>:	lea    0x38(%r8),%rdi
> > > 0x0000000000016692 <iwl3945_rx_reply_tx+306>:	lea    0x4f(%r8),%rax
> > 
> > When this happened, from your previous post, r8 is 0x0 and rdi is 0x38.
> > Since "info" is %rdi (see below), this means
> > txq->txb[txq->q.read_ptr].skb[0], aka. r8 is 0.
> > 
> > > 	rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
> > > 
> > > 0x0000000000016696 <iwl3945_rx_reply_tx+310>:	movb   $0x0,0x9(%rdi)        <---------- RIP
> > > 0x000000000001669a <iwl3945_rx_reply_tx+314>:	movb   $0x0,0xc(%rdi)
> > > 0x000000000001669e <iwl3945_rx_reply_tx+318>:	movb   $0x0,0xf(%rdi)
> > > 0x00000000000166a2 <iwl3945_rx_reply_tx+322>:	movb   $0x0,0x12(%rdi)
> > > 0x00000000000166a6 <iwl3945_rx_reply_tx+326>:	movb   $0x0,0x15(%rdi)
> > 
> > This equals to below code in ieee80211_tx_info_clear_status(). "info" is
> > %rdi, which is 0x38. That matches NULL pointer dereference at 0x41 in
> > your oops header.
> > 
> > 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
> >                 info->status.rates[i].count = 0;
> > 
> > I guess there is a race for txq->q.read_ptr somewhere. Haven't checked
> > though.
> 
> OK. 3945 updated write_ptr without regard to read_ptr on the Tx path.
> This messes up our TFD on high load. The patch should fix your problem.
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 994db4a..b31b34c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -548,6 +548,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
>  	txq = &priv->txq[txq_id];
>  	q = &txq->q;
>  
> +	if ((iwl_queue_space(q) < q->high_mark))
> +		goto drop;
> +
>  	spin_lock_irqsave(&priv->lock, flags);
>  
>  	idx = get_cmd_index(q, q->write_ptr, 0);
>  
> 
I applied that patch, everything works.
I let you know if I see another kernel panic
(I can capture any panic on that system, I set up everything for that)

Best regards,
Maxim Levitsky


