Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56512 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755251AbYBFUu2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 15:50:28 -0500
From: Helge Deller <deller@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Date: Wed, 6 Feb 2008 21:50:23 +0100
Cc: Jean Tourrilhes <jt@hpl.hp.com>, linux-wireless@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	"John W. Linville" <linville@tuxdriver.com>
References: <200801131516.34567.deller@gmx.de> <20080202224515.20a09553.akpm@linux-foundation.org>
In-Reply-To: <20080202224515.20a09553.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802062150.23930.deller@gmx.de> (sfid-20080206_205031_963476_3E91ECF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 February 2008, Andrew Morton wrote:
> On Sun, 13 Jan 2008 15:16:34 +0100 Helge Deller <deller@gmx.de> wrote:
> 
> > Convert optional struct size checks to non-optional compile-time checks.
> > Furthermore BUILD_BUG_ON() which will be optimized away by the compiler.
> > 
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > 
> >  wavelan.c      |   34 +++++-----------------------------
> >  wavelan.p.h    |    1 -
> >  wavelan_cs.c   |   33 ++++-----------------------------
> >  wavelan_cs.p.h |    1 -
> >  4 files changed, 9 insertions(+), 60 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
> > index a1f8a16..ffe50e2 100644
> > --- a/drivers/net/wireless/wavelan.c
> > +++ b/drivers/net/wireless/wavelan.c
> > @@ -49,27 +49,6 @@ static int __init wv_psa_to_irq(u8 irqval)
> >  	return -1;
> >  }
> >  
> > -#ifdef STRUCT_CHECK
> > -/*------------------------------------------------------------------*/
> > -/*
> > - * Sanity routine to verify the sizes of the various WaveLAN interface
> > - * structures.
> > - */
> > -static char *wv_struct_check(void)
> > -{
> > -#define	SC(t,s,n)	if (sizeof(t) != s) return(n);
> > -
> > -	SC(psa_t, PSA_SIZE, "psa_t");
> > -	SC(mmw_t, MMW_SIZE, "mmw_t");
> > -	SC(mmr_t, MMR_SIZE, "mmr_t");
> > -	SC(ha_t, HA_SIZE, "ha_t");
> > -
> > -#undef	SC
> > -
> > -	return ((char *) NULL);
> > -}				/* wv_struct_check */
> > -#endif				/* STRUCT_CHECK */
> > -
> >  /********************* HOST ADAPTER SUBROUTINES *********************/
> >  /*
> >   * Useful subroutines to manage the WaveLAN ISA interface
> > @@ -4215,14 +4194,11 @@ struct net_device * __init wavelan_probe(int unit)
> >  	int i;
> >  	int r = 0;
> >  
> > -#ifdef	STRUCT_CHECK
> > -	if (wv_struct_check() != (char *) NULL) {
> > -		printk(KERN_WARNING
> > -		       "%s: wavelan_probe(): structure/compiler botch: \"%s\"\n",
> > -		       dev->name, wv_struct_check());
> > -		return -ENODEV;
> > -	}
> > -#endif				/* STRUCT_CHECK */
> > +	/* compile-time check the sizes of structures */
> > +	BUILD_BUG_ON(sizeof(psa_t) != PSA_SIZE);
> > +	BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
> 
> This assertion is now triggering with arm allmodconfig.
> 
> Rafael, please track this as a post-2.6.24 regression.

Hello Andrew,

with which arm platform did you found this assertion to trigger ?
I tried a few (e.g. ARM-poodle and CONFIG_ARCH_SA1100 w/ISA) but didn't saw it breaking.
Maybe you could send me you .config file ?

Helge

PS: I tried Linus' current git tree which now includes my patch above as well.
