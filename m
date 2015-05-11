Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57916 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbbEKOYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 10:24:25 -0400
From: "Machani, Yaniv" <yanivma@ti.com>
To: Kyle McMartin <kyle@infradead.org>
CC: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: wl18xx : firmware pull request [V2] (updated WHENCE)
Date: Mon, 11 May 2015 14:23:56 +0000
Message-ID: <AE1C82FB3D0EC64DB1F752C81CBD1101265F90EC@DFRE01.ent.ti.com> (sfid-20150511_162429_644045_E8AD9D03)
References: <AE1C82FB3D0EC64DB1F752C81CBD1101265F6B46@DFRE01.ent.ti.com>
 <20150511134844.GN27807@merlin.infradead.org>
In-Reply-To: <20150511134844.GN27807@merlin.infradead.org>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Kyle McMartin [mailto:kyle@infradead.org]
> Sent: Monday, May 11, 2015 4:49 PM
> To: Machani, Yaniv
> Cc: linux-firmware@kernel.org; linux-wireless@vger.kernel.org
> Subject: Re: wl18xx : firmware pull request [V2] (updated WHENCE)
> 
> On Sun, May 10, 2015 at 05:46:38AM +0000, Machani, Yaniv wrote:
> > - Firmware file was updated (8.9.0.0.39), includes bug fixes and
> improvements.
> > - Configuration binary removed, it is no longer fits all releases.
> >   Moreover it should be configured per HW platform.
> >   More information can found in here :
> >
> > http://processors.wiki.ti.com/index.php/Open_Source_Wireless_Connectiv
> > ity_wlconf
> >
> 
> I assume this is an embedded part, and not something for general use?
> In general, we'd like linux-firmware to be decoupled from kernel upgrades, so
> that distributions can upgrade them asynchronously, and removing wlconf.bin
> could break existing users.

Yes, this is an embedded part, 
removing the wlconf.bin is actually allowing better backward/forward compatibility, 
as the existing file does not support all flavors/HW removing it will allow the device to load using defaults instead of not loading at all.

> 
> >   git@git.ti.com:wilink8-wlan/linux-firmware.git for-upstream
> >
> 
> FWIW, you need to specify the public git:// url here instead of SSH.
> 
> > for you to fetch changes up to
> > dbe3f134bb69b62edd29be89452d016def8f6d7f
> > Yaniv Machani (1):
> >       wl18xx: update firmware file, remove conf file
> >
> 
> Pulled.

Thanks.
> 
> >  WHENCE                          |    4 +---
> >  ti-connectivity/wl18xx-conf.bin |  Bin 1221 -> 0 bytes
> > ti-connectivity/wl18xx-fw-4.bin |  Bin 681704 -> 724716 bytes
> >  3 files changed, 1 insertions(+), 3 deletions(-)  delete mode 100644
> > ti-connectivity/wl18xx-conf.bin
> >
> 
> regards, Kyle
