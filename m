Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbbEUSYA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 14:24:00 -0400
Date: Thu, 21 May 2015 20:23:57 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Message-ID: <20150521182356.GD23057@wotan.suse.de> (sfid-20150521_202420_384403_7F86A93C)
References: <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
 <20150521061453.GC30864@kroah.com>
 <1432213521.4230.43.camel@linux.vnet.ibm.com>
 <20150521154508.GA11821@kroah.com>
 <1432224181.8004.7.camel@intel.com>
 <20150521170236.GC12932@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521170236.GC12932@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 10:02:36AM -0700, gregkh@linuxfoundation.org wrote:
> On Thu, May 21, 2015 at 04:03:02PM +0000, Woodhouse, David wrote:
> > On Thu, 2015-05-21 at 08:45 -0700, Greg Kroah-Hartman wrote:
> > > On Thu, May 21, 2015 at 09:05:21AM -0400, Mimi Zohar wrote:
> > > > Signatures don't provide any guarantees as to code quality or
> > > > correctness.   They do provide file integrity and provenance.  In
> > > > addition to the license and a Signed-off-by line, having the 
> > > > firmware provider include a signature of the firmware would be 
> > > > nice.
> > > 
> > > That would be "nice", but that's not going to be happening here, from
> > > what I can tell.  The firmware provider should be putting the signature
> > > inside the firmware image itself, and verifying it on the device, in
> > > order to properly "know" that it should be running that firmware.  The
> > > kernel shouldn't be involved here at all, as Alan pointed out.
> > 
> > In a lot of cases we have loadable firmware precisely to allow us to
> > reduce the cost of the hardware. Adding cryptographic capability in the
> > 'load firmware' state of the device isn't really compatible with that
> > :)
> 
> We do?  What devices want this?  That's really a bad hardware design to
> trust the kernel to get all of this correct.

On the 802.11 front its a CPU cost analysis issue Vs device CPU cost.  Atheros
for a long time found the device CPU too costly, while keeping a full ASIC
design the cheapest solution. Part of the issue with not using a device CPU
however is power consumption issues and if you are combining technologies
(for instance in the beginning 802.11 and Bluetooth) this becomes a practicel
impossibility as folks tend to end up preferring single-chip solutions. As
David alludes to though the more requirements you have on device CPU
functionality the costlier they will be, it would certainly be unfair to say
that relying on software signature verification would be a mistake, that's
pretty subjective. We should enable the market to do what it wishes and enable
the best solution to win. I do believe having this option can make Linux more
flexible.

There another side to this too, firmware signing is not just about getting
a vendor's own firmware to load. There's a bit of political game here I can
argue for here which IMHO can enable winning an argument for open firmware.
As I noted in my other thread there is somewhat of a dog and pony show to
this, but yet there is still some technical merit to it all as well. Let
folks doing the dog and pony show keep dancing -- one argument I can use
to help make a case for open firmware here, for instance is that like
with CFG80211_CERTIFICATION_ONUS we should be able to have developers opt
in to wish to use their own firmare. One can argue whether or not that
should enable one to win an argument over open firmware, but given I've
made these arguments before and I succeeded with open firmware, I do
believe it can help. Consider it part of a bag of tricks we need. Another
gain here is that if you do go with fw signing you do need a signature on
it, and well if distros only carry what is on linux-firmware, and if say
linux-firmware only has reasonable licensing practices in place *cough*,
well then -- some vendors better consider their licensing practices...

> And I say this as someone who is currently working on a hardware design
> that does just this for a very tiny device.  It's only a few hundred
> bytes of firmware size to be able to do proper key verification that the
> firmware image is correct and can be "trusted".

Sounds like a great project if you have the freedom and flexibility to
enable such hardware component. Now, if you can save a few bucks on it
per unit, how much would it be exactly? Just curious.

> > In the case where kernel and modules are signed, it *is* useful for a
> > kernel device driver also to be able to validate that what it's about
> > to load into a device is authentic. Where 'authentic' will originally
> > just mean that it's come from the linux-firmware.git repository or the
> > same entity that built (and signed) the kernel, but actually I *do*
> > expect vendors who are actively maintaining the firmware images in
> > linux-firmware.git to start providing detached signatures of their own.
> 
> Again, why have a detached signature and not just part of the firmware
> blob?

We can have both. If a device wants to use crypto hw signature checks,
let them, the file signature check thing can be for software solutions.
Alternatively if a vendor wanted to split the firmware binary from the
signature too and use it for hw crypto they can still do so. At least
for software separating the fw signature from the binary helps with
licensing. I am not sure if this can help with hw crypto solutions.

> The device needs to be caring about this, not the kernel.

Is that subjective?

> Do other operating systems have this type of "feature"?

Why follow? No one has CRDA, but then again, IMHO other OS solutions have
shit solutions for regulatory.

> As the kernel doesn't know/care about what the firmware blob really is,

Ah but it can. Consider open firmware solutions, and Kyle also happens
to be the maintainer of linux-firmware, so I wouldn't want to run a fimware
that didn't go through the policies set in place for linux-firmware.

> I don't see why it should be caring about firmware signing as that's a
> binary running on a separate "computer".

Provenance and integrity, and linux-firmware as the gate, while Kyle is
the gatekeeper.

> Do we want to take this
> the next logical step further and start requiring networked devices to
> attest their kernels are signed correctly before we can talk to them?

Wow. I'm glad I haven't had to deal with this political dog and pony
show concern.

> We do that, and we are back at the old ISDN nightmare :)

Someone thought of this for ISDN ?

 Luis
