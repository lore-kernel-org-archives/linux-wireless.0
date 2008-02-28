Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:6515 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760171AbYB1WUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:20:19 -0500
Received: by wr-out-0506.google.com with SMTP id c48so5454760wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2008 14:20:18 -0800 (PST)
Message-ID: <43e72e890802281420h5a3bc778x2ddccac4e8948b0f@mail.gmail.com> (sfid-20080228_222024_119546_BFA15E9A)
Date: Thu, 28 Feb 2008 17:20:15 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Bob Copeland" <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	jirislaby@gmail.com
In-Reply-To: <40f31dec0802271044j43cf04a2r2fffe497053f5890@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
	 <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
	 <43e72e890802261923g528f4006ofd665edbba335d99@mail.gmail.com>
	 <40f31dec0802262154k4e768257hb8ad255e2eb1f6a2@mail.gmail.com>
	 <43e72e890802270530j6ca4a6eal832d642a94a49e94@mail.gmail.com>
	 <20080227155257.GC3078@tuxdriver.com>
	 <40f31dec0802271044j43cf04a2r2fffe497053f5890@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 1:44 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/2/27, John W. Linville <linville@tuxdriver.com>:
>
>
> > On Wed, Feb 27, 2008 at 08:30:18AM -0500, Luis R. Rodriguez wrote:
>  >  > On Wed, Feb 27, 2008 at 12:54 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  >
>  >
>  > > >  What if there is a pci-e card in the future that needs _PCI bit ?
>  >  >
>  >  > I don't follow, the member is for struct pci_dev so its either a pci
>  >  > or pci-express device. If you mean what if we later have some srev in
>  >  > the range that is not pci-e, well then we'd use srevs wouldn't we?
>  >  >
>  >  > > I guess for now we can work on with srevs to be safe but it's good to
>  >  > >  know of that feature, thanx ;-)
>  >  >
>  >  > The point is that if there is already a variable we can use to detect
>  >  > if a device is pci-e then we shouldn't introduce any other new ones.
>  >
>  >
>  > ACK for Luis's point.
>  >
>  >
>
>  Sorry for not being clear on my previous post...
>
>  We don't have access to pci_dev on nic_wakeup and other functions that
>  is possible to need that info in the future,

Yes we do, I'll post a patch based on yours, it needs testing on
PCI-E. Also noticed what may have been a typo on another patch, will
comment on that one next. I'll just post my series based on yours.

>  Have in mind that there are also ar5k devices that are not attached an
>  a pci or pci-e bus at all (ahb) that we want to support in the future.
>  Right now hw_attach does not make use of any pci-related stuff, it
>  only takes ath5k_softc for argument and mac_version and i intend to
>  keep it that way to be abstract (when we start supporting WiSOC, we
>  'll only have to tweak base.c/base.h as in MadWiFi, not hw-related
>  code and our code will be less noisy and easier to maintain).

We can take care of ahb when we get there.

>  The way i see it, if we make use of is_pcie we'll do it during
>  pci_probe and pass a bool to hw_attach if it's pcie. This will save us
>  from passing pci_dev directly to hw_attach that 'll create noise
>  during ahb implementation (we 'll need to make an abstract dev
>  structure for both pci/ahb to pass to hw_attach etc).

Its not that complicated, you'll see.

>  So all i'm saying is that i want to think about it a little more and
>  i'll come up with a patch for it. What i also want to see is check
>  traces from my 5418 card which is also pci-e and see if it sets _PCI
>  bit, if it does current flag will have no meaning (eg. not setting
>  _PCI bit wont be a property of pci-e cards but only of a specific
>  srev-range) so i'll submit a patch that eg. renames ah_pcie to
>  "ah_no_pcibit_durring_reset" or something like that.

Point taken, we can fix this if you find that.

  Luis
