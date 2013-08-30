Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:60848 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H3UqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 16:46:11 -0400
Message-ID: <522104B1.2070004@openwrt.org> (sfid-20130830_224614_779631_CFC3E664)
Date: Fri, 30 Aug 2013 22:46:41 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] ath10k: remove void pointer from struct ath10k_pci_compl
References: <20130830122905.31164.50662.stgit@localhost6.localdomain6> <20130830123021.31164.8374.stgit@localhost6.localdomain6>
In-Reply-To: <20130830123021.31164.8374.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.08.30. 14:30 keltezéssel, Kalle Valo írta:
> Void pointers are bad, mmkay.
> 
> No functional changes.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
>  drivers/net/wireless/ath/ath10k/pci.h |    2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 

<snip>

> @@ -1026,7 +1026,7 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
>  				break;
>  			}
>  
> -			skb = (struct sk_buff *)compl->transfer_context;
> +			skb = (struct sk_buff *)compl->skb;

The cast can be removed from here as well.

>  			nbytes = compl->nbytes;
>  
>  			ath10k_dbg(ATH10K_DBG_PCI,
> diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
> index c65fe1b..2e1f422 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.h
> +++ b/drivers/net/wireless/ath/ath10k/pci.h
> @@ -54,7 +54,7 @@ struct ath10k_pci_compl {
>  	enum ath10k_pci_compl_state state;
>  	struct ath10k_ce_pipe *ce_state;
>  	struct ath10k_pci_pipe *pipe_info;
> -	void *transfer_context;
> +	struct sk_buff *skb;
>  	unsigned int nbytes;
>  	unsigned int transfer_id;
>  	unsigned int flags;
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
> 

