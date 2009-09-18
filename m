Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbZIRRge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 13:36:34 -0400
Subject: Re: [PATCH] libertas: Add auto deep sleep support for
 SD8385/SD8686/SD8688
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
In-Reply-To: <200909180937.42727.hs4233@mail.mn-solutions.de>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
	 <45e8e6c40909161347l23caaf4ct14d4ef7b416b3387@mail.gmail.com>
	 <20090917161154.GA877@Chamillionaire.breakpoint.cc>
	 <200909180937.42727.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 10:37:04 -0700
Message-Id: <1253295424.8764.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-09-18 at 09:37 +0200, Holger Schurig wrote:
> > I agree on this. Debugfs is for debug only and should stay
> > that way. What do other driver in regard to this?
> 
> I see this now as an example where a Manufacturer (Marvell) 
> starts to work with the community, has a nice feature (probably 
> bacause of customer-request) and cannot get this into the kernel 
> because of this issue :-)

We've been over this for a long time actually.  I'm the one that removed
all the private vendor ioctls in the first place back in 2006 from the
vendor driver.  The reasons were known then, and are still the same.

But Bing probably wasn't involved then, and he doesn't need to bear the
brunt of that :)  I'm very happy to be getting more active contributions
from Marvell and we should work this sort of thing out.

The major issue then was that iwpriv is a "quick fix" that is not
standardized and *is* kernel API that cannot/should not change.  Thus,
unless it's well-designed and generic, it probably shouldn't even go in
in the first place.

We (Woodhouse, I, and Marcelo Tosatti) pushed back on Michail and
Marvell at the time and nobody (Michail in particular) was not willing
to spend the time to _do it right_ and help out with nl80211.  Getting
attributes Marvell wanted into nl80211 would have been fine, and still
would be fine, but there's a process to follow and it will take longer
than a single iwpriv patch.

> Debugfs isn't suitable for anything except debugging. It is, per 
> definition, an interface for developers that want to debug it. 
> The idea is that a kernel for end-user devices won't even have 
> debugfs compiled in.

Correct; that's the point: if we can't find a generic API to put this
into, it probably shouldn't go in, because the interface hasn't been
thought out well enough.  Yes, that means a little more work, but it's
much more maintainable in the long run.

> If libertas currently does use debugfs for something != 
> debugging?  I don't know, but than that has been a lapse, an 
> oversight. Let's not do that oversight again.
> 
> 
> So you can use
> 
> * iwpriv

No.

> * sysfs

No, it's basically the same thing as iwpriv just in a file.  Slightly
better (since there's the rule of one-value-per-file) but not much.

> * kernel module parameters

No, because they usually cannot be changed at runtime.

> * nl80211/cfg80211

Yes.

> * Maybe the new "stable debugfs" proposed by Rostedt (see the
>   Article "A stable debugfs" on http://lwn.net/Articles/350463/,
>   but here it's not even clear that this will come).

No, if the value isn't for debugging.

> For me, iwpriv seems the best candidate as long as libertas 
> doesn't have a cfg80211/nl80211 interface.

Then maybe we should convert it to cfg80211/nl80211.  We should anyway.

> 
> 
> > I hardly belive that the libertas driver is the only "deep
> > sleep" user. 
> 
> I think that ATH6K WLAN devices might be candidates for this, 
> too. If the interface is "iwpriv XXX deepsleep 0" / "iwpriv XXX 
> deepsleep 1" I don't see a reason they could do it similar.

So if libertas isn't the only user, then we can make a more generic
interface for this that uses 'iw' and cfg80211.

Dan

> 
> > iwconfig has an interface for this I think:
> > |interface power {period N|timeout N|saving N|off}
> 
> That's something very differently.
> 
> 

