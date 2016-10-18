Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5914 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932186AbcJROxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:53:02 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: sequence diagrams in rst documentation
In-Reply-To: <1476799968.6425.33.camel@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> <20161011072119.7ad4e3a3@lwn.net> <1476193466.4118.10.camel@sipsolutions.net> <1476194038.4118.11.camel@sipsolutions.net> <1476791021.6425.25.camel@sipsolutions.net> <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de> <1476799968.6425.33.camel@sipsolutions.net>
Date: Tue, 18 Oct 2016 17:52:57 +0300
Message-ID: <87eg3dvhdi.fsf@intel.com> (sfid-20161018_165309_969847_80D7B0FE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 18 Oct 2016, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-10-18 at 15:51 +0200, Markus Heiser wrote:
>> Here are my thoughts ...
>> 
>> Every extension which is not a part of the sphinx distro brings new
>> external dependencies 
>
> I agree.
>
>> and the development of such extensions is IMO
>> far of kernel development's scope.
>
> Arguably, having good documentation *is* in the scope of kernel
> development.
>
> Also, it could be argued that shipping a module in the kernel sources
> would be more reliable than having to require it being externally
> installed, like the GCC plugins perhaps.

This could probably be argued either way...

My view has been all along that we should prefer to use existing
extensions written and maintained by others. Perhaps we (the kind of
royal "we" of which I'm personally really not part of) could take on
maintainership of some extensions in the interest of improving kernel
documentation, but I think the goal should be that the extensions are
maintained outside of the kernel tree, that the extensions are generally
usable, and have a chance of attracting attention and contributions from
outside of the kernel community. (Note that this doesn't preclude us
from shipping the extensions in the kernel tree, as long as it's updated
from the upstream, not forked.)

(This is one part of me being unhappy about making it easy to run
arbitrary scripts to produce documentation; those will never be generic,
and we'll never be able to offload their maintenance outside of the
kernel. We should not think that we have some really special needs in
the kernel.)

>> ATM, there are not many use cases for diagram generators, so why not
>> be KISS and creating diagrams with the favorite tool only adding the
>> resulting (e.g.) PNG to the Kernel's source?
>
> *Only* adding the PNG would be awful, I'd have to keep track of the
> corresponding source elsewhere, and perhaps couldn't even GPL it
> because then I couldn't distribute the PNG without corresponding
> source...
>
> Adding the source text would really be the only practical choice, but
> doing so makes it easy to mismatch things, and also very easy to use
> proprietary services for it that may go away at any time, etc.

Agreed. And there are other problems with attaching binaries (although
I'd say we should fix them too) [1].

BR,
Jani.


[1] http://lkml.kernel.org/r/02a78907-933d-3f61-572e-28154b16b9e5@redhat.com


-- 
Jani Nikula, Intel Open Source Technology Center
