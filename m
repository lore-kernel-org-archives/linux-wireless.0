Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55114 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751803AbdIOTn2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 15:43:28 -0400
Message-ID: <1505504598.5400.296.camel@coelho.fi> (sfid-20170915_214336_721889_79E4A117)
From: Luca Coelho <luca@coelho.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: Srinath Mannam <srinath.mannam@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 15 Sep 2017 22:43:18 +0300
In-Reply-To: <CA+55aFzjz2c=q4Uatso1Lp6HAUOAyGdbZLWorFW56MiapoF5Sg@mail.gmail.com>
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
         <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
         <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
         <1505246657.1974.11.camel@sipsolutions.net>
         <feabbc25-eb85-ffa2-0fd6-254c07e3574b@kernel.dk>
         <CAErSpo777jq9FVRtmoHXVbzE-ZOc7mnT+eRJ_PhP_Dd=MbKv4g@mail.gmail.com>
         <e7af2f85-0ab3-e524-a544-c2ccdf4f8bd6@kernel.dk>
         <CABe79T7WObM+LOGdPFfYC7hf0dKrhm5NwMgQ3DpcWst3eP6kNg@mail.gmail.com>
         <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
         <93bfbc9b-8829-66fa-f4d6-6d47124e460c@kernel.dk>
         <CABe79T79WhBh66iQB-5LLCQO0d37evg5tsKUGkj7+z8vNGTHcA@mail.gmail.com>
         <a5fd0c11-916f-1404-c979-2fd566ed72ec@kernel.dk>
         <ee04c95d-167b-0782-1860-253a2271d66c@kernel.dk>
         <CA+55aFzjz2c=q4Uatso1Lp6HAUOAyGdbZLWorFW56MiapoF5Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi firmware load broken in current -git
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-15 at 12:38 -0700, Linus Torvalds wrote:
> On Fri, Sep 15, 2017 at 12:32 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > > 
> > > In any case, your patch introduces a regression on systems. Please get
> > > it reverted now, and then you can come up with a new approach to fix the
> > > double enable of the upstream bridge.
> > 
> > Who's sending in the revert? I can certainly do it if no one else does,
> > but it needs to be done.
> > 
> > I'm not seeing any patches coming out of Srinath to fix up the
> > situation, so we should revert the broken patch until a better solution
> > exists.
> 
> Hmm. I don't have the history here (apparently it never made lkml, for
> example), so I don't even know which commit you're talking about.
> 
> From some of the context it looks like commit 40f11adc7cd9 ("PCI:
> Avoid race while enabling upstream bridges"), is that correct?

Yes, that's the one.  And Bjorn already sent a revert:

https://lkml.org/lkml/2017/9/15/46

--
Luca.
