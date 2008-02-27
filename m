Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:36887 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYB0NaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 08:30:20 -0500
Received: by el-out-1112.google.com with SMTP id v27so2409437ele.23
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2008 05:30:19 -0800 (PST)
Message-ID: <43e72e890802270530j6ca4a6eal832d642a94a49e94@mail.gmail.com> (sfid-20080227_133024_359983_1D6B9471)
Date: Wed, 27 Feb 2008 08:30:18 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: "Bob Copeland" <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0802262154k4e768257hb8ad255e2eb1f6a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
	 <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
	 <43e72e890802261923g528f4006ofd665edbba335d99@mail.gmail.com>
	 <40f31dec0802262154k4e768257hb8ad255e2eb1f6a2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2008 at 12:54 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/2/27, Luis R. Rodriguez <mcgrof@gmail.com>:
>
>
> > On Sun, Feb 24, 2008 at 1:58 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  >  > 2008/2/24, Bob Copeland <me@bobcopeland.com>:
>  >  >
>  >  >
>  >  > > On Sun, Feb 24, 2008 at 06:45:33AM +0200, Nick Kossifidis wrote:
>  >  >  >  > >  +       /* Identify PCI-E cards */
>  >  >  >  > >  +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  >  >  >  > >  +       srev >= AR5K_SREV_VER_AR5416) {
>  >  >  >  > >  +               ah->ah_pcie = true;
>  >
>  >
>  > struct pci_dev now has member,  "is_pcie" which could be used here I
>  >  think instead. No need to add to ath5k_hw the ah_pcie then.
>  >
>  >
>  >   Luis
>  >
>
>  What if there is a pci-e card in the future that needs _PCI bit ?

I don't follow, the member is for struct pci_dev so its either a pci
or pci-express device. If you mean what if we later have some srev in
the range that is not pci-e, well then we'd use srevs wouldn't we?

> I guess for now we can work on with srevs to be safe but it's good to
>  know of that feature, thanx ;-)

The point is that if there is already a variable we can use to detect
if a device is pci-e then we shouldn't introduce any other new ones.

   Luis
