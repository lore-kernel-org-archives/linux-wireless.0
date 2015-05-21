Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284AbbEURt3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 13:49:29 -0400
Date: Thu, 21 May 2015 19:49:25 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seth.forshee@canonical.com" <seth.forshee@canonical.com>,
	"zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>,
	"mricon@kernel.org" <mricon@kernel.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"jlee@suse.de" <jlee@suse.de>, "kyle@kernel.org" <kyle@kernel.org>,
	"gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521174925.GC23057@wotan.suse.de> (sfid-20150521_195004_366957_DF180BBF)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
 <20150521061453.GC30864@kroah.com>
 <1432213521.4230.43.camel@linux.vnet.ibm.com>
 <20150521154508.GA11821@kroah.com>
 <1432224181.8004.7.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432224181.8004.7.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 04:03:02PM +0000, Woodhouse, David wrote:
> On Thu, 2015-05-21 at 08:45 -0700, Greg Kroah-Hartman wrote:
> > On Thu, May 21, 2015 at 09:05:21AM -0400, Mimi Zohar wrote:
> > > Signatures don't provide any guarantees as to code quality or
> > > correctness.   They do provide file integrity and provenance.  In
> > > addition to the license and a Signed-off-by line, having the 
> > > firmware provider include a signature of the firmware would be 
> > > nice.
> > 
> > That would be "nice", but that's not going to be happening here, from
> > what I can tell.  The firmware provider should be putting the signature
> > inside the firmware image itself, and verifying it on the device, in
> > order to properly "know" that it should be running that firmware.  The
> > kernel shouldn't be involved here at all, as Alan pointed out.
> 
> In a lot of cases we have loadable firmware precisely to allow us to
> reduce the cost of the hardware. Adding cryptographic capability in the
> 'load firmware' state of the device isn't really compatible with that
> :)

Standards aside -- using crypto functionality on hardware or software are best
practices quite a few folks are picking up. Now, let me remind us that it was
crypto practices in software which in the end allowed us to gain huge corporate
support on the uphill battle to find vendors to start becoming friendly on
working with us upstream on the 802.11 front on Linux.  To be crystal clear,
although providing signature check support for file integrity and provenance
checks might seem like a "dog and pony show" [0] it nevertheless helped us
hugely upstream. For those that wish to side on the "dog and pony show" side
of the argument you have the freedom to do that, and should always have that.
In the end, that flexibility and maintaining peoples freedom's completely
(see CFG80211_CERTIFICATION_ONUS) are IMHO the best form of compromises we
can make for both camps.

There's two sides to the topic at hand:

1) Technical merit
2) Political merit

We went down the road of using some aspects of 1) to win on 2), I can say with
confidence that this was the case for 802.11 to the extend we even now have today
GPLv2 open firmware on linux-firmware. That was a huge win considering we lacked
most vendor support in the beginning. Not sure if something similar is applicable
to modules, there must've been some good amount of 2) and 1) to get it upstream
into Linux after all, I frankly don't care, but I suspect there must be some of it.

Since I can only speak on behalf of one side of the historical aspects of this
from a practical point of view I think we should look at this problem as ensuring
we do what we need to allow us developers to get the job done while folks working
on the political front figure what the fuck is needed from 1) to win 2) -- so long
as they keep our freedoms in mind. Although a few folks trimmed my original
comments about original motivation for this signature checking effort its important
to remind folks on the thread that the original motivation for all this was to
simply come together on a unified solution for both *modules* and 802.11 regulatory
for 2) and 1). On the 802.11 front CRDA has historically been very useful, but
since the kernel got module signature check support we can simply do away with
our own subsystem specific practices and file redistribution mechanism by unifying
our efforts on firmware with file integrity / provenance.

So the quest here is not to shove down folk's distribution's practices or beliefs
but rather simplify things for 802.11 and upkeeping the same flexibility to let
folks enable / disable things. So please keep in mind if you argue over signed
firmware as a solution to replace CRDA upstream, I'd like to also hear an
alternative to do away with it. I don't think expecting folks to use IMA is a
good option yet, from what I had reviewed so far.

So we have 2) and 1) for modules. We have 2) and 1) for 802.11. The goal here
was to simplify redistribution / code by sharing while keeping everyone's
freedoms to ignore all this as well.

Since the focus is to use the technical solution on modules, I think folks are
*seriously* confusing the issues on the technical front with the political. This
is bad! Those folks should simply write their alternative solutions and APIs
if we do not have them yet. What makes this problem harder is we now also have
IMA and LSM and even LSM stacking come to our future Linux tree, this allows
even more flexibility, and IMHO gets folks barking up the wrong trees [1].

What makes thing even more difficult is folks are arguing we now revisit
the technical aspects for modules using IMA while we have other folks
extending the old module technical solution. I think we can have a reasonable
compromise on all fronts here, but this requires a bit more review. Without
completing this review -- I'll prematurely say then that it would seem we could
keep everyone happy by enabling the existing extensions to module signing
to use PKCS#7 while folks who disagree with this figure out what path to
make the decision of what technical solution to use here configurable. Without
a final review on my part I'm inclined to believe we can accomplish this easily
with LSM stacking, by having module signature checks be:

a) optional
b) an LSM module can provide its own file integrity checks
c) the above can provide APIs that can be used for both modules and firmware

We actually already have an LSM hook for modules and firmware so technically
this should already be all possible, and folk who do not want PKCS#7 should
simply disable that stuff. Long term it may make sense to just LSM'ify it.

I believe this would be the right approach because we already went down the
module signing path and folks still working on that due to 1) or 2) are just
extending and perfecting that. Meanwhile, on the 802.11 front we're just trying
to simplify and unify things while keeping folk's beliefs on the dog and pony
show in mind.

> In the case where kernel and modules are signed, it *is* useful for a
> kernel device driver also to be able to validate that what it's about
> to load into a device is authentic. Where 'authentic' will originally
> just mean that it's come from the linux-firmware.git repository or the
> same entity that built (and signed) the kernel, but actually I *do*
> expect vendors who are actively maintaining the firmware images in
> linux-firmware.git to start providing detached signatures of their own.

Although we originally did not discuss this as firmware signature check support
was being fleshed out, I do believe this makes sense and as much dog and pony
show folks want to call this I do believe it will also help us with vendor
support. To this day I can say with a very straight face I believe Linux has
the best regulatory solution on the planet, perhaps this is of little value to
some folks, but I dealt with the politics first hand, I also *know* we have a
great track record to this day on Linux, let's keep it that way and see what
things we can do to make things easier for those technical folks trying to
iron out the politics for us. Now if you want to argue about the political 
aspects of any of this, you can do so, but this is perhaps not the best venue.
We can avoid those issues ourselves by enabling those we trust to create
flexibility to enable the differing leading technical solutions.

[0] https://en.wikipedia.org/wiki/Dog_and_pony_show
[1] https://en.wikipedia.org/wiki/Barking_up_the_wrong_tree

  Luis
