Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:55675 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbcHBHz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 03:55:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Scott Wood <scott.wood@nxp.com>,
	"qiang.zhao@freescale.com" <qiang.zhao@freescale.com>,
	"viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David.Laight@aculab.com" <David.Laight@aculab.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"scottwood@freescale.com" <scottwood@freescale.com>,
	Arvind Yadav <arvind.yadav.cs@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux@roeck-us.net" <linux@roeck-us.net>
Subject: Re: [v4] Fix to avoid IS_ERR_VALUE and IS_ERR abuses on 64bit systems.
Date: Tue, 02 Aug 2016 09:45:18 +0200
Message-ID: <2484583.95xFmO7xir@wuerfel> (sfid-20160802_095625_615665_0BD796FE)
In-Reply-To: <DB5PR0401MB19280ACA87C7F5EE2822D5FB91040@DB5PR0401MB1928.eurprd04.prod.outlook.com>
References: <1469963924-8800-1-git-send-email-arvind.yadav.cs@gmail.com> <1956647.cOmaJREgOE@wuerfel> <DB5PR0401MB19280ACA87C7F5EE2822D5FB91040@DB5PR0401MB1928.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 1, 2016 4:55:43 PM CEST Scott Wood wrote:
> On 08/01/2016 02:02 AM, Arnd Bergmann wrote:

> >> diff --git a/include/linux/err.h b/include/linux/err.h
> >> index 1e35588..c2a2789 100644
> >> --- a/include/linux/err.h
> >> +++ b/include/linux/err.h
> >> @@ -18,7 +18,17 @@
> >>  
> >>  #ifndef __ASSEMBLY__
> >>  
> >> -#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
> >> +#define IS_ERR_VALUE(x) unlikely(is_error_check(x))
> >> +
> >> +static inline int is_error_check(unsigned long error)
> > 
> > Please leave the existing macro alone. I think you were looking for
> > something specific to the return code of qe_muram_alloc() function,
> > so please add a helper in that subsystem if you need it, not in
> > the generic header files.
> 
> qe_muram_alloc (a.k.a. cpm_muram_alloc) returns unsigned long.  The
> problem is certain callers that store the return value in a u32.  Why
> not just fix those callers to store it in unsigned long (at least until
> error checking is done)?
> 

Yes, that would also address another problem with code like

         kfree((void *)ugeth->tx_bd_ring_offset[i]);

which is not 64-bit safe when tx_bd_ring_offset is a 32-bit value
that also holds the return value of qe_muram_alloc.

	Arnd
