Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64103 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYLFAT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 19:19:58 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2008 16:19:58 -0800
Date: Fri, 5 Dec 2008 16:19:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dan E <trg_info@mailhaven.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CRDA question
Message-ID: <20081206001956.GE5926@tesla> (sfid-20081206_012002_583824_66DAFBFD)
References: <1228454249.2652.1288380409@webmail.messagingengine.com> <43e72e890812042132y6b676a1ucf446a678e1d8a81@mail.gmail.com> <1228515313.30577.1288527655@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228515313.30577.1288527655@webmail.messagingengine.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 05, 2008 at 02:15:13PM -0800, Dan E wrote:
> 
> On Thu, 4 Dec 2008 21:32:48 -0800, "Luis R. Rodriguez"
> <mcgrof@gmail.com> said:
> > On Thu, Dec 4, 2008 at 9:17 PM, Dan E <trg_info@mailhaven.com> wrote:
> > > What is the purpose of the "intersect" program in CRDA? It builds but it
> > > doesn't seem to be used anywhere.
> >
> > We use it to check to see if we have to update the world regulatory
> > domain. You run intersect against the regulatory.bin for example to
> > get the intersection of all regulatory domains.
> 
> Now it makes sense.
> 
> > > I also notice the CRDA source has its
> > > own nl80211.h header file, as does the source tree for "iw". Shouldn't
> > > userspace tools just include the sanitized kernel header from the
> > > standard gcc include-file locations? Having multiple copies (and
> > > versions) of nl80211.h everywhere seems like a bad idea.
> >
> > Yes and no.
> >
> > We keep the latest header in crda and iw so we can get it to compile
> > to work with the latest stuff, even if you don't have support for the
> > new stuff on your old kernel.
> 
> But with an old kernel none of that shiny new stuff is going to work
> anyway.

Right.

> > So although iw and crda are built with support for the shiny new stuff
> > the kernel netlink messages which apply to the new stuff simply won't
> > work. This lets you have, for example, an iw and crda for 2.6.28 and
> > still have it working in case you want to test drive wireless-testing
> > (which as stuff for 2.6.29) or compat-wireless (which has
> > wireless-testing stuff backported).
> 
> Which is why I kept getting -22 (-EINVAL) return codes when I tried to
> run the crda I built on a 2.6.27.7 kernel.  I then went through the
> somewhat painful procedure of setting up my environment to build against
> wireless-testing HEAD.  If crda used <linux/nl80211.h> in the first
> place I could have avoided finding that out the hard way.
> 
> It makes zero sense IMO to build a userspace tool that's going to
> netlink messages to the kernel which it doesn't understand or, even
> worse, will misinterpret if the various tools are built using
> out-of-sync 'enum nl80211_commmands'.  Doing that is like re-inventing
> wireless extensions all over again.  So now I have to maintain my own
> branches to replace 'include "nl80211.h"' with 'include
> <linux/nl80211.h>' everywhere.  Wonderful.

It makes zero sense for you to package CRDA for 2.6.27 unless you want
to help users of compat-wireless or wireless-testing.

> IW is especially tedious
> because even though the common iw.h includes its own private nl80211
> header, every one of its C source code file also includes it.  From my
> perspective as a developer it's cruft that doesn't need to be there and
> which causes unnecessary headaches and maintenance concerns.

Technically speaking we can remove our own packaged nl80211.h but then
users of older kernels won't get to use the new stuff when using
wireless-testing or compat-wireless.

If we remove our own nl80211.h then users would have to compile their
own iw and refer to a new place for the headers or have the distribution
ship several versions of it.

Userspace applications which *do* want to test against a feature can do tests
like:

#ifdef NL80211_NEW_STUFF
#endif

as wpa_supplicant does it, but that's up to each developer.

Here are the #ifdef'able features:

NL80211_CMD_SET_BSS

NL80211_ATTR_HT_CAPABILITY
NL80211_ATTR_BSS_BASIC_RATES
NL80211_ATTR_WIPHY_TXQ_PARAMS
NL80211_ATTR_WIPHY_FREQ
NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET

In CRDA's case I'm sticking to the packaged nl80211.h.

> > > Will CRDA work with AP mode? That's where my primary interest lies (I'm
> > > writing a new driver for an as-yet unsupported chipset). I can see the
> > > usefulness of CRDA in a laptop. I have a much harder time seeing the
> > > benefit of a 250K application to process 3,000 bytes of data
> > > (regulatory.bin) in an embedded AP context where filesystem space is at
> > > a premium.
> >
> > Would you prefer that being duplicated in kernel space by each driver?
> > That's sort of what we had before. Each driver had their own
> > regulatory solution.
> 
> Each driver doing its own implementation is orthogonal to kernel vs
> userspace.

Yes but the fact that the database gets updated on regularly (when
the cosmos align, a new war breaks out, a user reads new docs, etc)
and the data actually *is* a database means we want to keep such silly
updates in userspace.

> It could be both common and in the kernel, available for
> every driver to use.  I do understand, at a bigger-picture level, why
> it's desirable to put this stuff in userspace.  I'll use it for now, but
> I still think it's a solution looking for a problem.

We had a long discussion about this a long time ago and my first
approach was to do it all in-kernel, then people complained and we moved
it to userspace. Now its there and it works well. If you are so
concerned about the size of the database then trim it yourself, make
your let CRDA use it, or go ahead and customize the kernel and define
statically your *one* single regulatory domain.

Supporting regulatory considerations on STA/AP for different countries
requires that you do have some sort of regulatory information somewhere.
Some people keep it in firmware, some in the driver, and some in a
combination of EEPROM and driver or even some info from Windows registry files.
We've generalized what we can from all drivers. If you think you can do a
better job please send patches and go through the review cycle.

If you have actual issues to point out then please point them out or
better yet just send a patch for the solution.

  Luis
