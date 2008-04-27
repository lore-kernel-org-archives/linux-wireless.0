Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:34530 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbYD0DSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 23:18:14 -0400
Date: Sat, 26 Apr 2008 23:18:08 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat-2.6: rndis_wlan/rndis_host/usbnet problem(?)
Message-ID: <20080427031808.GC17936@ruslug.rutgers.edu> (sfid-20080427_051828_655130_2688174B)
References: <20080421200409.vvow4d67okcw84kg@hayate.ip6> <20080426045909.GA17936@ruslug.rutgers.edu> <20080426181848.foifd2bcw004kw4g@naisho.dyndns.info> <43e72e890804261126n7c4463c9y2d4bb4dc444be096@mail.gmail.com> <20080427004052.5sespv7h6o4wk8c0@hayate.ip6> <20080427025324.GB17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080427025324.GB17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 26, 2008 at 10:53:24PM -0400, Luis R. Rodriguez wrote:
> On Sun, Apr 27, 2008 at 12:40:52AM +0300, Jussi Kivilinna wrote:
> > Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
> > 
> > >
> > >Does the driver rely on all the new stuff? Or just he one you mentioned?
> > >
> > 
> > Driver rely on the patch adding 'driver_priv' pointer to 'struct  
> > usbnet' and the cdc_ether.c patch. Without cdc_ether.c patch, device  
> > fails to bind. With those patches + rndis_* changes, driver should  
> > work (atleast) on 2.6.20 and up. I'll check this when I find some time.
> 
> Ok I added cdc_ether.c and it compiles now if you use
> compat-wireless.git and wireles-testing.git to pull. I tested this
> only on 2.6.24 though, 2.6.22 compile may be broken now. We'll have
> to test that.

I just tested cdc_ether.ko on 2.6.22 and it worked. Obviously the
oops is still present though (#2). Pushed a new compat-wireless
tarball if you want to try that.

  Luis
