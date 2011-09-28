Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41755 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1I1ILq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 04:11:46 -0400
Subject: Re: [PATCHv2.1] wireless: at76c50x: use native hex_pack_byte()
 method
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 28 Sep 2011 11:11:17 +0300
In-Reply-To: <20110927154739.2cd368d5@mj>
References: <71d8213731be21f26a82255a4fffdbe1b6dd4a44.1316774801.git.andriy.shevchenko@linux.intel.com>
	 <3feae30d537a79c064495cc834f585192a1e636d.1317124866.git.andriy.shevchenko@linux.intel.com>
	 <20110927154739.2cd368d5@mj>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1317197477.2676.89.camel@smile> (sfid-20110928_101151_305157_BCC39A68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 15:47 -0400, Pavel Roskin wrote: 
> On Tue, 27 Sep 2011 15:01:49 +0300
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: "John W. Linville" <linville@tuxdriver.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/net/wireless/at76c50x-usb.c |   18 +++++++-----------
> >  1 files changed, 7 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/at76c50x-usb.c
> 
> ...
> 
> > b/drivers/net/wireless/at76c50x-usb.c index 2986014..2dde5f6 100644
> > -		*obuf++ = BIN2HEX(*ibuf >> 4);
> > -		*obuf++ = BIN2HEX(*ibuf & 0xf);
> > +		obuf = pack_hex_byte(obuf, *ibuf++);
> >  		*obuf++ = '-';
> > -		ibuf++;
> >  	}
> > -	*(--obuf) = '\0';
> > +
> > +	if (*obuf == '-')
> > +		obuf--;
> 
> This will access uninitialized data and fail to strip the final "-" in
> most cases.  The check for len being 0 was there for a reason.  Please
> actually test your code.
In case of len == 0 we have either '\0' or hex digit in the first byte
of the array. Otherwise it's a mess in the memory which should not be
happened.

> 
> NACK

> 
> By the way, I don't think it's necessary to copy linux-kernel and
> netdev about a change affecting just a wireless driver.
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
