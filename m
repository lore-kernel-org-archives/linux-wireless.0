Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64425 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760689AbYDOCFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 22:05:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Subject: RE: Alternative Libertas SDIO driver seen
Date: Tue, 15 Apr 2008 10:05:45 +0800
Message-ID: <8AD95083DC3E36478732061D9752441502FE7C65@pdsmsx411.ccr.corp.intel.com> (sfid-20080415_030557_705971_7AFFC188)
In-Reply-To: <1208186399.31015.23.camel@localhost.localdomain>
References: <252063.3227.qm@web72209.mail.tp2.yahoo.com> <200804141211.43539.hs4233@mail.mn-solutions.de> <1208186399.31015.23.camel@localhost.localdomain>
From: "Tang, Feng" <feng.tang@intel.com>
To: "Dan Williams" <dcbw@redhat.com>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>
Cc: <libertas-dev@lists.infradead.org>,
	"claud_yu" <claud_yu@yahoo.com.tw>,
	"Harvey, Timothy" <tharvey@irobot.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi, Dan, Hlger,

Yes, moblin.org has some drivers for Marvell SDIO 868x devices. One rea=
son for that is moblin.org need suppport some Marvell devices which are=
 brand new and not covered by current Libertas driver.

Also Marvell driver on moblin.org is updated frequently as it keeps get=
ting new developing versons from Marvell, which make it difficult to cl=
ean up the code to open-source format for each new version.

Thanks,
=46eng
-----Original Message-----
=46rom: Dan Williams [mailto:dcbw@redhat.com]=20
Sent: 2008=C4=EA4=D4=C214=C8=D5 23:20
To: Holger Schurig
Cc: libertas-dev@lists.infradead.org; claud_yu; Harvey, Timothy; Tang, =
=46eng; linux-wireless@vger.kernel.org
Subject: Re: Alternative Libertas SDIO driver seen

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
>=20
> Okay, I find a kernel tree there which, in=20
> debian/patches/0019-marvell_8686_8688.patch contains another=20
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
wanted to use that code, we'd have to re-do all the work we've done ove=
r
the past 2 years cleaning up the existing libertas driver but on the
moblin/vendor driver.  The vendor driver probably has better support fo=
r
things like WMM, power management, etc in it that are useful to mobile
stuff but haven't yet been a focus of the existing libertas driver sinc=
e
it too so long just to get it to work reliably with a lot of different
hardware than just the 868x.

Dan

> Unfortunately, the (Intel created) moblin.org webpage only=20
> supports the "http://" access protocol to the git tree, which is=20
> rather inefficent. I'm currently trying to get this tree=20
> with "git clone --reference /usr/src/linux-git=20
> http://www.moblin.org/repos/projects/kernel-mid-2.6.24.git/",=20
> and takes ages. Maybe they also made this tree from scratch, so=20
> that the reference to Linus' git tree won't help the=20
> downloading.
>=20
>=20
>=20
> Okay, to the driver:
>=20
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
>=20
> As this driver is sdio-only, and we have already other libertas=20
> drivers supported in the kernel, it would never accepted as-is=20
> in mainland kernel. Therefore I invite Marvell and Intel to=20
> participate with the in-kernel libertas driver. I understand=20
> that for Intel this might not be possible immediately, because=20
> the current libertas driver might not work on their=20
> Atom-reference platform, but I guess in the long-run could be=20
> beneficial.
>=20
> I CC'ed feng tang from "git log=20
> debian/patches/0019-marvell_8686_8688.patch" therefore :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
