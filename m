Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38080 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3GIJJd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 05:09:33 -0400
Message-ID: <1373360959.21065.183.camel@cumari.coelho.fi> (sfid-20130709_110936_250810_F093C397)
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>,
	"=?ISO-8859-1?Q?Jos=E9?= Miguel =?ISO-8859-1?Q?Gon=E7alves?="
	<jose.goncalves@inov.pt>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 9 Jul 2013 12:09:19 +0300
In-Reply-To: <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
References: <51DB0ACC.7050800@inov.pt>
	 <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>
	 <51DB4195.8090103@inov.pt>
	 <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Arik, for helping with this.

On Tue, 2013-07-09 at 10:21 +0300, Arik Nemtsov wrote:
> On Tue, Jul 9, 2013 at 1:47 AM, José Miguel Gonçalves
> <jose.goncalves@inov.pt> wrote:
> > Hi Arik,
> >
> > Yep, that patch solved the kernel warning, but the association with  the AP
> > is still lost after 3 warnings;

Cool, I have just sent this patch to the stable mailing list, for
inclusion on  v.3.9.y.


> > wlcore: Beacon loss detected. roles:0xff
> 
> This one is possibly a FW version issue. I'd give it a go with the
> latest FW in TI's git:
> https://github.com/TI-OpenLink/ti-utils/tree/master/hw/firmware

More specifically, try the hw/firmware/wl127x-fw-4-sr.bin and the
hw/firmware/wl127x-fw-4-mr.bin (if you're using multirole).  Note that
you need to rename them to wl127x-fw-5-sr.bin and wl127x-fw-5-mr.bin,
respectively.

What we have in the linux-firmware git at the moment are versions
6.3.10.0.133 (singlerole) and 6.5.7.0.42 (multirole).  The new ones in
TI's github repo are 6.3.10.0.136 and 6.5.7.0.46.

If the new firmwares solve your problem, please let me know and I'll
push them to the linux-firmware git repo.


> > To use the driver in the Luca's tree I need to do some work to adapt my
> > platform to the latest kernel version, what I would like to avoid  for now.
> > Is there any set of patches to put  the driver in vanilla kernel 3.9 in a
> > more stable condition?
> 
> Well 3.9 is pretty new, so the difference is not that big. A simple
> cherry pick of all patches done on <root>/drivers/wireless/ti/ would
> do the trick.
> 
> Or you could always used compat-wireless, or in it's new name "driver
> backports":
> https://backports.wiki.kernel.org/index.php/Main_Page

I'd really recommend cherry-picking just what is needed.  It should be
very few patches.  And every time you find a new patch that fixes some
real issue you're seeing, let me know and I'll send to stable.

You're so close to the mainline that it would be silly to use compat
just for a few patches. ;)

--
Cheers,
Luca.

