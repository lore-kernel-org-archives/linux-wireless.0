Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57618 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932463AbcJRTUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 15:20:24 -0400
Message-ID: <1476818413.6425.50.camel@sipsolutions.net> (sfid-20161018_212050_191899_D5D64397)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Tue, 18 Oct 2016 21:20:13 +0200
In-Reply-To: <87eg3dvhdi.fsf@intel.com>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <B9AC83F3-AA14-414B-B538-81436620E432@darmarit.de>
         <1476799968.6425.33.camel@sipsolutions.net> <87eg3dvhdi.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This could probably be argued either way...

Yeah, I guess it could :)

> My view has been all along that we should prefer to use existing
> extensions written and maintained by others. Perhaps we (the kind of
> royal "we" of which I'm personally really not part of) could take on
> maintainership of some extensions in the interest of improving kernel
> documentation, but I think the goal should be that the extensions are
> maintained outside of the kernel tree, that the extensions are
> generally usable, and have a chance of attracting attention and
> contributions from outside of the kernel community. (Note that this
> doesn't preclude us from shipping the extensions in the kernel tree,
> as long as it's updated from the upstream, not forked.)

Right. I tend to agree, though in the particular case I'm looking at
we'd probably have to fork outside the kernel, forming a new upstream,
and then ship that version (or perhaps rewrite it, forming a new
upstream, and then ship that - doesn't matter all that much)

> (This is one part of me being unhappy about making it easy to run
> arbitrary scripts to produce documentation; those will never be
> generic, and we'll never be able to offload their maintenance outside
> of the kernel. We should not think that we have some really special
> needs in the kernel.)

I agree that we don't necessarily have any special needs (*), but in
cases like this (**) it does seem more practical to just ship the
plugin with the kernel. Whether or not a separate "upstream" is formed
for it could be a secondary question, although it does seem better to
do so.

(*) although not wanting to ship binary files *is* kinda special :)

(**) where the upstream is essentially dead (for all I can tell) and
severely limited to the point where a rewrite will be a better choice.

Anyway, I'll have to see if we (Intel Linux WiFi team) actually want to
do things this way. Using the existing blockdiag/seqdiag is practical
since it all exists already. OTOH, a simpler and better-looking
solution would also be nice, so if we do go this way I'll investigate
more what we can do around this.

johannes
