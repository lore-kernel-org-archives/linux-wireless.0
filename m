Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web54407.mail.yahoo.com ([206.190.49.137]:48403 "HELO
	web54407.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751314AbYDNNqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 09:46:18 -0400
Date: Mon, 14 Apr 2008 06:39:37 -0700 (PDT)
From: David Anders <dave123_aml@yahoo.com>
Subject: Re: Alternative Libertas SDIO driver seen
To: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
Cc: "Harvey, Timothy" <tharvey@irobot.com>, feng.tang@intel.com,
	linux-wireless@vger.kernel.org, claud_yu <claud_yu@yahoo.com.tw>
In-Reply-To: <200804141211.43539.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <916547.28931.qm@web54407.mail.yahoo.com> (sfid-20080414_144622_491414_C7C6BD78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger,

the moblin libertas driver is originally based on source marvell released for both the OLPC and
the UMPC, which is then used in conjunction with the atheros sdio stack that was announced some
time back:

http://www.linuxdevices.com/news/NS6177996610.html

thanks
Dave Anders


--- Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

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
> 
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
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
> 



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
