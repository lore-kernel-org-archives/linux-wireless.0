Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30821 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZCMWZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 18:25:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 15:25:27 -0700
Date: Fri, 13 Mar 2009 14:24:46 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [stable] [ath9k-devel] [PATCH v6 0/3] ath9k: SMP fixes
Message-ID: <20090313212445.GD1620@tesla> (sfid-20090313_232532_070181_3D1AF05B)
References: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com> <43e72e890903131429h560dd786j74dd93a9e80fac12@mail.gmail.com> <20090313220259.GA29459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090313220259.GA29459@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2009 at 03:02:59PM -0700, Greg KH wrote:
> On Fri, Mar 13, 2009 at 02:29:08PM -0700, Luis R. Rodriguez wrote:
> > On Thu, Mar 12, 2009 at 3:18 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> > > This v6 removes the hotplug CPU stuff which although it technically
> > > would be correct is more cruft and highly unlikely. The down side
> > > is you will get serialization applied even if you only have one
> > > CPU but who cares, I doubt those nutty SGI guys are toying with
> > > ath9k in the lab.
> > >
> > > Yesterday I started mucking with an alternative approach to
> > > serialization which worked. I added just 5 udelay()s in key places
> > > where we had a lot of consecutive IO read/writes issued and that
> > > resolved the issue at least for STA mode but it didn't do the trick
> > > for AP mode. Technically it should be possible to groom all hardware
> > > access routines to do the same but I'm tired of this issue and want
> > > to a fix merged today not a few weeks from now. Anyway if you are
> > > curious you can check out that patch replacement approach for
> > > serialization here:
> > >
> > > http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/smp-udelay-fix.patch
> > >
> > > Note that AP won't work though so if you have a lot of time in your
> > > hands and have an SMP box with PCI Atheros 11n and are seeing the hangs
> > > and want a neat alternative to the current serialization implementation
> > > try adding udelays like the ones in the patch in places where we do a lot
> > > of io read/writes. Send me the results :)
> > >
> > > The compromise is to keep serialization conditional -- we do not want to
> > > do it for every read/write regardless of the type of card you have, the
> > > code overhead is not great and we maintain this anyway. Adding it for all
> > > cases would just not be optimal.
> > >
> > > Luis R. Rodriguez (3):
> > >  ath9k: implement IO serialization
> > >  ath9k: AR9280 PCI devices must serialize IO as well
> > >  ath9k: remove dummy PCI "retry timeout" fix
> > >
> > >  drivers/net/wireless/ath9k/ath9k.h |   34 ++++++++++++++++++++++++++++++++++
> > >  drivers/net/wireless/ath9k/hw.c    |   28 +++++++++++++++++++++++++++-
> > >  drivers/net/wireless/ath9k/hw.h    |    4 ++--
> > >  drivers/net/wireless/ath9k/main.c  |    1 +
> > >  drivers/net/wireless/ath9k/pci.c   |   18 ------------------
> > >  5 files changed, 64 insertions(+), 21 deletions(-)
> >
> > John, Greg,
> >
> > these patches require a port down to the other stable kernels, I've
> > taken the time to port only the necessary patches (the first two) to
> > fix the SMP hang on each stable kernel and test them accordingly:
> >
> > * 2.6.27
> > * 2.6.28
> > * 2.6.29
> >
> > Once merged into wireless-testing the following patches can be used to
> > push into Linus' tree:
> >
> > http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/serialization-v6/for-2.6.29/
> >
> > Once merged into stable these can be used to merge into 2.6.27 and 2.6.28:
> >
> > http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/serialization-v6/for-2.6.27/
> > http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2009-03-12/serialization-v6/for-2.6.28/
> >
> > Just replace:
> >
> > This is a port of commit SHA1 <BLEH>
> >
> > With the respective SHA1.
> >
> > I can also simply resend the ports for 27 and 28 once merged into
> > Linus' tree. Whatever makes it easier for you.
> 
> Please, when the patches go into Linus's tree, send stable@kernel.org
> the backported patches, with the proper git commit id in them.
> 
> Otherwise it's just too much confusing work for me and I'll easily mess
> it up.  The number of -stable patches is increasing and I need all the
> help I can get in handling this in a sane manner :)

Sure will do thanks,

  Luis
