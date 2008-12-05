Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56355 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819AbYLEWPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 17:15:15 -0500
Message-Id: <1228515313.30577.1288527655@webmail.messagingengine.com> (sfid-20081205_231521_865484_500B8F8F)
From: "Dan E" <trg_info@mailhaven.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1228454249.2652.1288380409@webmail.messagingengine.com>
 <43e72e890812042132y6b676a1ucf446a678e1d8a81@mail.gmail.com>
Subject: Re: CRDA question
In-Reply-To: <43e72e890812042132y6b676a1ucf446a678e1d8a81@mail.gmail.com>
Date: Fri, 05 Dec 2008 17:15:13 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 4 Dec 2008 21:32:48 -0800, "Luis R. Rodriguez"
<mcgrof@gmail.com> said:
> On Thu, Dec 4, 2008 at 9:17 PM, Dan E <trg_info@mailhaven.com> wrote:
> > What is the purpose of the "intersect" program in CRDA? It builds but it
> > doesn't seem to be used anywhere.
> 
> We use it to check to see if we have to update the world regulatory
> domain. You run intersect against the regulatory.bin for example to
> get the intersection of all regulatory domains.

Now it makes sense.

> > I also notice the CRDA source has its
> > own nl80211.h header file, as does the source tree for "iw". Shouldn't
> > userspace tools just include the sanitized kernel header from the
> > standard gcc include-file locations? Having multiple copies (and
> > versions) of nl80211.h everywhere seems like a bad idea.
> 
> Yes and no.
> 
> We keep the latest header in crda and iw so we can get it to compile
> to work with the latest stuff, even if you don't have support for the
> new stuff on your old kernel.

But with an old kernel none of that shiny new stuff is going to work
anyway.

> So although iw and crda are built with support for the shiny new stuff
> the kernel netlink messages which apply to the new stuff simply won't
> work. This lets you have, for example, an iw and crda for 2.6.28 and
> still have it working in case you want to test drive wireless-testing
> (which as stuff for 2.6.29) or compat-wireless (which has
> wireless-testing stuff backported).

Which is why I kept getting -22 (-EINVAL) return codes when I tried to
run the crda I built on a 2.6.27.7 kernel.  I then went through the
somewhat painful procedure of setting up my environment to build against
wireless-testing HEAD.  If crda used <linux/nl80211.h> in the first
place I could have avoided finding that out the hard way.

It makes zero sense IMO to build a userspace tool that's going to
netlink messages to the kernel which it doesn't understand or, even
worse, will misinterpret if the various tools are built using
out-of-sync 'enum nl80211_commmands'.  Doing that is like re-inventing
wireless extensions all over again.  So now I have to maintain my own
branches to replace 'include "nl80211.h"' with 'include
<linux/nl80211.h>' everywhere.  Wonderful.  IW is especially tedious
because even though the common iw.h includes its own private nl80211
header, every one of its C source code file also includes it.  From my
perspective as a developer it's cruft that doesn't need to be there and
which causes unnecessary headaches and maintenance concerns.

> > Will CRDA work with AP mode? That's where my primary interest lies (I'm
> > writing a new driver for an as-yet unsupported chipset). I can see the
> > usefulness of CRDA in a laptop. I have a much harder time seeing the
> > benefit of a 250K application to process 3,000 bytes of data
> > (regulatory.bin) in an embedded AP context where filesystem space is at
> > a premium.
> 
> Would you prefer that being duplicated in kernel space by each driver?
> That's sort of what we had before. Each driver had their own
> regulatory solution.

Each driver doing its own implementation is orthogonal to kernel vs
userspace.  It could be both common and in the kernel, available for
every driver to use.  I do understand, at a bigger-picture level, why
it's desirable to put this stuff in userspace.  I'll use it for now, but
I still think it's a solution looking for a problem.

-- 
http://www.fastmail.fm - Email service worth paying for. Try it for free

