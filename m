Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35712 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZCLVZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 17:25:18 -0400
Received: by fxm24 with SMTP id 24so2312950fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 14:25:15 -0700 (PDT)
Subject: Re: Thanks for TX power patch
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Tulio Magno Quites Machado Filho <tuliom@gmail.com>,
	Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
	 <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 23:25:11 +0200
Message-Id: <1236893111.30325.10.camel@maxim-laptop> (sfid-20090312_222522_826781_E6739A74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-12 at 10:14 -0400, Bob Copeland wrote:
> On Wed, Mar 11, 2009 at 4:15 AM, Tulio Magno Quites Machado Filho
> <tuliom@gmail.com> wrote:
> > On Wed, Mar 11, 2009 at 12:39 AM, Maxim Levitsky
> > <maximlevitsky@gmail.com> wrote:
> >> If I unload/reload the ath5k, it seems to work. but at next suspend to
> >> disk, once  system hung, other time it showed many panic, in something
> >> related to page allocator (one even was in page_alloc_pages or so)
> >
> > I'm getting some Kernel oopses after unloading ath5k with Nick patches.
> > But I'm still debugging it to find where is the problem.
> 
> Ditto here.. looks like a bug in ath5k_eeprom_free_pcal_info(), which has:
> 
>     struct ath5k_pdgain_info *pd = &chinfo->pd_curves[pdg];
> 
>     if (pd != NULL) {
>         kfree(pd->pd_step);
>         kfree(pd->pd_pwr);
>         kfree(pd);
>     }
> 
> kfree(pd) looks wrong, because pd_curves is the kzalloc()ed part, not
> the array elements themselves.  But I tried removing that and freeing
> the pd_curves array outside of the loop and got more slab debugging
> poop.  So, I punt for now.
> 
> Also, every alloc of pd_step, and pd_pwr can potentially leak earlier
> allocated memory on ENOMEM.
> 

Just to be clear, I got oopses, and hangs after resume from disk by just
using compat-wireless-2009-03-10 _without_ Nick's patches.

It seems that a memory corruption happens somewhere.
On the other hand if I avoid S2disk and module reload, everything seems
to be stable and fast (2.4 MB/s in both directions)

Best regards,
	Maxim Levitsky

