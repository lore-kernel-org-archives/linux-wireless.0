Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755184AbZCMWKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 18:10:20 -0400
Date: Fri, 13 Mar 2009 15:02:59 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [ath9k-devel] [PATCH v6 0/3] ath9k: SMP fixes
Message-ID: <20090313220259.GA29459@kroah.com> (sfid-20090313_231024_467759_987AF353)
References: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com> <43e72e890903131429h560dd786j74dd93a9e80fac12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e890903131429h560dd786j74dd93a9e80fac12@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2009 at 02:29:08PM -0700, Luis R. Rodriguez wrote:
> On Thu, Mar 12, 2009 at 3:18 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > This v6 removes the hotplug CPU stuff which although it technically
> > would be correct is more cruft and highly unlikely. The down side
> > is you will get serialization applied even if you only have one
> > CPU but who cares, I doubt those nutty SGI guys are toying with
> > ath9k in the lab.
> >
> > Yesterday I started mucking with an alternative approach to
> > serialization which worked. I added just 5 udelay()s in key places
> > where we had a lot of consecutive IO read/writes issued and that
> > resolved the issue at least for STA mode but it didn't do the trick
> > for AP mode. Technically it should be possible to groom all hardwar=
e
> > access routines to do the same but I'm tired of this issue and want
> > to a fix merged today not a few weeks from now. Anyway if you are
> > curious you can check out that patch replacement approach for
> > serialization here:
> >
> > http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/=
2009-03-12/smp-udelay-fix.patch
> >
> > Note that AP won't work though so if you have a lot of time in your
> > hands and have an SMP box with PCI Atheros 11n and are seeing the h=
angs
> > and want a neat alternative to the current serialization implementa=
tion
> > try adding udelays like the ones in the patch in places where we do=
 a lot
> > of io read/writes. Send me the results :)
> >
> > The compromise is to keep serialization conditional -- we do not wa=
nt to
> > do it for every read/write regardless of the type of card you have,=
 the
> > code overhead is not great and we maintain this anyway. Adding it f=
or all
> > cases would just not be optimal.
> >
> > Luis R. Rodriguez (3):
> > =A0ath9k: implement IO serialization
> > =A0ath9k: AR9280 PCI devices must serialize IO as well
> > =A0ath9k: remove dummy PCI "retry timeout" fix
> >
> > =A0drivers/net/wireless/ath9k/ath9k.h | =A0 34 ++++++++++++++++++++=
++++++++++++++
> > =A0drivers/net/wireless/ath9k/hw.c =A0 =A0| =A0 28 ++++++++++++++++=
+++++++++++-
> > =A0drivers/net/wireless/ath9k/hw.h =A0 =A0| =A0 =A04 ++--
> > =A0drivers/net/wireless/ath9k/main.c =A0| =A0 =A01 +
> > =A0drivers/net/wireless/ath9k/pci.c =A0 | =A0 18 ------------------
> > =A05 files changed, 64 insertions(+), 21 deletions(-)
>=20
> John, Greg,
>=20
> these patches require a port down to the other stable kernels, I've
> taken the time to port only the necessary patches (the first two) to
> fix the SMP hang on each stable kernel and test them accordingly:
>=20
> * 2.6.27
> * 2.6.28
> * 2.6.29
>=20
> Once merged into wireless-testing the following patches can be used t=
o
> push into Linus' tree:
>=20
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/20=
09-03-12/serialization-v6/for-2.6.29/
>=20
> Once merged into stable these can be used to merge into 2.6.27 and 2.=
6.28:
>=20
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/20=
09-03-12/serialization-v6/for-2.6.27/
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/20=
09-03-12/serialization-v6/for-2.6.28/
>=20
> Just replace:
>=20
> This is a port of commit SHA1 <BLEH>
>=20
> With the respective SHA1.
>=20
> I can also simply resend the ports for 27 and 28 once merged into
> Linus' tree. Whatever makes it easier for you.

Please, when the patches go into Linus's tree, send stable@kernel.org
the backported patches, with the proper git commit id in them.

Otherwise it's just too much confusing work for me and I'll easily mess
it up.  The number of -stable patches is increasing and I need all the
help I can get in handling this in a sane manner :)

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
