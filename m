Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881AbYBCGrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 01:47:08 -0500
Date: Sat, 2 Feb 2008 22:45:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: Jean Tourrilhes <jt@hpl.hp.com>, linux-wireless@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-Id: <20080202224515.20a09553.akpm@linux-foundation.org> (sfid-20080203_064739_168671_26F1B905)
In-Reply-To: <200801131516.34567.deller@gmx.de>
References: <200801131516.34567.deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Jan 2008 15:16:34 +0100 Helge Deller <deller@gmx.de> wrote:

> Convert optional struct size checks to non-optional compile-time checks.
> Furthermore BUILD_BUG_ON() which will be optimized away by the compiler.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
>  wavelan.c      |   34 +++++-----------------------------
>  wavelan.p.h    |    1 -
>  wavelan_cs.c   |   33 ++++-----------------------------
>  wavelan_cs.p.h |    1 -
>  4 files changed, 9 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
> index a1f8a16..ffe50e2 100644
> --- a/drivers/net/wireless/wavelan.c
> +++ b/drivers/net/wireless/wavelan.c
> @@ -49,27 +49,6 @@ static int __init wv_psa_to_irq(u8 irqval)
>  	return -1;
>  }
>  
> -#ifdef STRUCT_CHECK
> -/*------------------------------------------------------------------*/
> -/*
> - * Sanity routine to verify the sizes of the various WaveLAN interface
> - * structures.
> - */
> -static char *wv_struct_check(void)
> -{
> -#define	SC(t,s,n)	if (sizeof(t) != s) return(n);
> -
> -	SC(psa_t, PSA_SIZE, "psa_t");
> -	SC(mmw_t, MMW_SIZE, "mmw_t");
> -	SC(mmr_t, MMR_SIZE, "mmr_t");
> -	SC(ha_t, HA_SIZE, "ha_t");
> -
> -#undef	SC
> -
> -	return ((char *) NULL);
> -}				/* wv_struct_check */
> -#endif				/* STRUCT_CHECK */
> -
>  /********************* HOST ADAPTER SUBROUTINES *********************/
>  /*
>   * Useful subroutines to manage the WaveLAN ISA interface
> @@ -4215,14 +4194,11 @@ struct net_device * __init wavelan_probe(int unit)
>  	int i;
>  	int r = 0;
>  
> -#ifdef	STRUCT_CHECK
> -	if (wv_struct_check() != (char *) NULL) {
> -		printk(KERN_WARNING
> -		       "%s: wavelan_probe(): structure/compiler botch: \"%s\"\n",
> -		       dev->name, wv_struct_check());
> -		return -ENODEV;
> -	}
> -#endif				/* STRUCT_CHECK */
> +	/* compile-time check the sizes of structures */
> +	BUILD_BUG_ON(sizeof(psa_t) != PSA_SIZE);
> +	BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);

This assertion is now triggering with arm allmodconfig.

Rafael, please track this as a post-2.6.24 regression.


