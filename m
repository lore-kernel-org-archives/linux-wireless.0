Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40123 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2JCSHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 14:07:15 -0400
Received: by pbbrr4 with SMTP id rr4so10112851pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 11:07:15 -0700 (PDT)
Date: Wed, 3 Oct 2012 11:07:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
In-Reply-To: <20121003113659.GD2259@redhat.com>
Message-ID: <alpine.DEB.2.00.1210031104120.29765@chino.kir.corp.google.com> (sfid-20121003_200723_895448_68605CE8)
References: <20120909213228.GA5538@elf.ucw.cz> <alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com> <20120910111113.GA25159@elf.ucw.cz> <20120911162536.bd5171a1.akpm@linux-foundation.org> <20120912101826.GL11266@suse.de>
 <20121003113659.GD2259@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 3 Oct 2012, Stanislaw Gruszka wrote:

> So, can this problem be solved like on below patch, or I should rather
> split firmware loading into chunks similar like was already iwlwifi did?
> 
> diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
> index 5f50177..1b58222 100644
> --- a/drivers/net/wireless/iwlegacy/common.h
> +++ b/drivers/net/wireless/iwlegacy/common.h
> @@ -2247,7 +2247,7 @@ il_alloc_fw_desc(struct pci_dev *pci_dev, struct fw_desc *desc)
>  
>  	desc->v_addr =
>  	    dma_alloc_coherent(&pci_dev->dev, desc->len, &desc->p_addr,
> -			       GFP_KERNEL);
> +			       GFP_KERNEL | __GFP_REPEAT);
>  	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
>  }
>  

I think this will certainly make memory compaction more aggressive by 
avoiding the logic to defer calling compaction in the page allocator, but 
because we lack lumpy reclaim this still has a higher probability of 
failing than it had in the past because it will fail if 128KB of memory is 
reclaimed that may not happen to be contiguous for an order-5 allocation 
to succeed.
