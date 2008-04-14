Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYDNPWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 11:22:48 -0400
Subject: Re: Alternative Libertas SDIO driver seen
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, claud_yu <claud_yu@yahoo.com.tw>,
	"Harvey, Timothy" <tharvey@irobot.com>, feng.tang@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <200804141211.43539.hs4233@mail.mn-solutions.de>
References: <252063.3227.qm@web72209.mail.tp2.yahoo.com>
	 <200804141211.43539.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 11:19:59 -0400
Message-Id: <1208186399.31015.23.camel@localhost.localdomain> (sfid-20080414_162252_502785_F78B34D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-14 at 12:11 +0200, Holger Schurig wrote:
> On Monday 14 April 2008 11:12:38 claud_yu wrote:
> > Hi ,
> >
> > Currently I use wi2wi W2SW0001, I send Murata module
> > back. I still try to port the libertas driver to mx31.
> > Wi2Wi provide a SD card development card on wi2wi
> > website. I also try another 88w8686 driver from
> > project moblin (http://www.moblin.org/). The driver
> > should based on marvell SDIO driver. But the driver
> > still have some problem while firmware download.
> 
> Okay, I find a kernel tree there which, in 
> debian/patches/0019-marvell_8686_8688.patch contains another 
> libertas driver.

Yeah, this is based on the V8/V9 Marvell vendor driver, which is a
continuation of the driver that got dropped on OLPC.  So you'll notice
quite a few similarities to early versions of the upstream libertas
driver.

I'd like to think we've improved on the vendor driver greatly, from a
cleanup standpoint (getting rid of the SBI abstraction stuff), from a
Wireless Extensions standpoint, from a readability/maintainability
standpoint, etc.

Unfortunately we never got any buy-in from Marvell themselves on
developing on the upstream driver together, though we did get some
patches from their engineers that were against upstream.

We can only really pull stuff from the moblin/vendor driver since if we
wanted to use that code, we'd have to re-do all the work we've done over
the past 2 years cleaning up the existing libertas driver but on the
moblin/vendor driver.  The vendor driver probably has better support for
things like WMM, power management, etc in it that are useful to mobile
stuff but haven't yet been a focus of the existing libertas driver since
it too so long just to get it to work reliably with a lot of different
hardware than just the 868x.

Dan

> Unfortunately, the (Intel created) moblin.org webpage only 
> supports the "http://" access protocol to the git tree, which is 
> rather inefficent. I'm currently trying to get this tree 
> with "git clone --reference /usr/src/linux-git 
> http://www.moblin.org/repos/projects/kernel-mid-2.6.24.git/", 
> and takes ages. Maybe they also made this tree from scratch, so 
> that the reference to Linus' git tree won't help the 
> downloading.
> 
> 
> 
> Okay, to the driver:
> 
> * it's GPL, so we can copy from it
> * it's an if_sdio.c only-driver (and also contains something
>    with bluetooth stuff)
> * it's weird, as this patch contains two wlan_11.c files
>   which differ. This is true for effectively every wlan_XXX.c
>   file.
> * it looks similar to what Marvell donated originally to OLPC
> * compared to the current in-kernel libertas driver, it has
>   some more code for 802.11a frequencies
> * older Marvell drivers contained firmware as *.h files, this
>   driver now uses #include <linux/firmware.h> as well
> 
> As this driver is sdio-only, and we have already other libertas 
> drivers supported in the kernel, it would never accepted as-is 
> in mainland kernel. Therefore I invite Marvell and Intel to 
> participate with the in-kernel libertas driver. I understand 
> that for Intel this might not be possible immediately, because 
> the current libertas driver might not work on their 
> Atom-reference platform, but I guess in the long-run could be 
> beneficial.
> 
> I CC'ed feng tang from "git log 
> debian/patches/0019-marvell_8686_8688.patch" therefore :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

