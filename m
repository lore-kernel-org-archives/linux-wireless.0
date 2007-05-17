Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([207.189.120.12]:58904 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892AbXEQPTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 11:19:36 -0400
Date: Thu, 17 May 2007 08:05:40 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-ID: <20070517080540.4db88dd4@freepuppy>
In-Reply-To: <20070516203505.556df4f9.randy.dunlap@oracle.com>
References: <464B7B7C.5080800@linux.intel.com>
	<20070516203505.556df4f9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 16 May 2007 20:35:05 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:


> 
> 5.  This function:
> 
> +static inline u8 iwl4965_get_dma_hi_address(dma_addr_t addr)
> +{
> +#ifdef _X86_64_TYPES_H
> +	return addr >> 32;
> +#else
> +#ifdef _I386_TYPES_H
> +	return 0;
> +#else
> +#error "unsupported architecture"
> +#endif
> +#endif
> +}
> 
> a.  For i386, dma_addr_t can still be 64 bits.  See asm-i386/types.h:
> 
> #ifdef CONFIG_HIGHMEM64G
> typedef u64 dma_addr_t;
> #else
> typedef u32 dma_addr_t;
> #endif
> 
> b.  Should use CONFIG_64BIT instead of checking _X64_64_TYPES_H or
> _I386_TYPES_H.
> 
> c.  can just shift addr 32 bits right (in 2 shifts) in all cases:
> 
> 	return (addr >> 16) >> 16;
>

I did this in sky2 driver:

/* Return high part of DMA address (could be 32 or 64 bit) */
static inline u32 high32(dma_addr_t a)
{
	return sizeof(a) > sizeof(u32) ? (a >> 16) >> 16 : 0;
}



-- 
Stephen Hemminger <shemminger@linux-foundation.org>
