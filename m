Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4216 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab0KVUI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:08:57 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Greg KH" <gregkh@suse.de>,
	"Zimny Lech" <napohybelskurwysynom2010@gmail.com>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 22 Nov 2010 12:08:28 -0800
Subject: RE: linux-next: Tree for November 22
Message-ID: <400C43189542CE41BC0A5B252FC90136952F05944A@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>
 <AANLkTi=QeU_vb6+XRei0pqz7GSfp2E4TC3oTJYy9adv4@mail.gmail.com>,<20101122194643.GB21985@suse.de>
In-Reply-To: <20101122194643.GB21985@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg, Stephen,

The file wl_iw.c declare a struct semaphore variable and uses semaphore function, but there is no explicit inclusion of <linux/semaphore.h>. I hit this problem last week when trying a minimal kernel configuration for my development system. Normally we build and test against kernel configuration similar to Ubuntu configuration and we got the semaphore definitions for free. Expect a patch soon.

Gr. AvS
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Greg KH [gregkh@suse.de]
Sent: Monday, November 22, 2010 8:46 PM
To: Zimny Lech
Cc: Stephen Rothwell; linux-next@vger.kernel.org; LKML; Brett Rudley; Henry Ptasinski; linux-wireless@vger.kernel.org
Subject: Re: linux-next: Tree for November 22

On Mon, Nov 22, 2010 at 04:37:57PM +0100, Zimny Lech wrote:
> Salve
>
> 2010/11/22 Stephen Rothwell <sfr@canb.auug.org.au>:
> > Hi all,
> >
> > Changes since 20101119:
> >
>
>
>   CC [M]  drivers/staging/brcm80211/brcmfmac/wl_iw.o
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:130:19:
> error: field 'sysioc_sem' has incomplete type
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
> function 'wl_iw_timerfunc':
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:1070:4:
> error: implicit declaration of function 'up'
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
> function '_iscan_sysioc_thread':
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:1181:2:
> error: implicit declaration of function 'down_interruptible'
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c: In
> function 'wl_iw_attach':
> /home/test/linux-2.6/drivers/staging/brcm80211/brcmfmac/wl_iw.c:3708:2:
> error: implicit declaration of function 'sema_init'
> make[5]: *** [drivers/staging/brcm80211/brcmfmac/wl_iw.o] Error 1
> make[4]: *** [drivers/staging/brcm80211/brcmfmac] Error 2
> make[3]: *** [drivers/staging/brcm80211] Error 2
> make[2]: *** [drivers/staging] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2
>

Ick, not good.

Henry, Brett, any ideas?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


