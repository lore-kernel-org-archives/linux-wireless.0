Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:41767 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbEZRJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 13:09:04 -0400
Date: Tue, 26 May 2015 18:08:13 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Petko Manolov <petkan@mip-labs.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk> (sfid-20150526_190937_975987_3F41A3DC)
In-Reply-To: <20150521155319.GG18164@localhost>
References: <20150519200232.GM23057@wotan.suse.de>
	<20150520140426.GB126473@ubuntu-hedt>
	<20150520172446.4dab5399@lxorguk.ukuu.org.uk>
	<20150520164613.GD10473@localhost>
	<20150521044104.GH22632@kroah.com>
	<20150521054101.GA15037@localhost>
	<20150521061453.GC30864@kroah.com>
	<1432213521.4230.43.camel@linux.vnet.ibm.com>
	<20150521154508.GA11821@kroah.com>
	<20150521155319.GG18164@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 May 2015 18:53:19 +0300
Petko Manolov <petkan@mip-labs.com> wrote:

> On 15-05-21 08:45:08, Greg Kroah-Hartman wrote:
> > On Thu, May 21, 2015 at 09:05:21AM -0400, Mimi Zohar wrote:
> > > 
> > > Signatures don't provide any guarantees as to code quality or
> > > correctness.   They do provide file integrity and provenance.  In
> > > addition to the license and a Signed-off-by line, having the firmware
> > > provider include a signature of the firmware would be nice.
> > 
> > That would be "nice", but that's not going to be happening here, from what I 
> > can tell.  The firmware provider should be putting the signature inside the 
> > firmware image itself, and verifying it on the device, in order to properly 
> > "know" that it should be running that firmware.  The kernel shouldn't be 
> > involved here at all, as Alan pointed out.
> 
> It is device's job to verify firmware's correctness.  It is user's job to verify 
> vendor's identity.  Two different things, not related to each other.

The device verifies the firmwares identity. The firmware's correctness is
unknownable if the mathematicians are correct.

The device will accept firmware signed in some manner with some key that
is probably part of a root of trust embedded deeply im the hardware
itself. If it's vendor X hardware then firmware not signed with the key
for that hardware won't work, and vendor X has the key locked away.

It's also worth remembering most of the dumb non signature checking
devices are things like USB. They don't have access to the internals of
the system so their attack options are more limited.

On Thu, 21 May 2015 16:03:02 +0000
"Woodhouse, David" <david.woodhouse@intel.com> wrote:

> In the case where kernel and modules are signed, it *is* useful for a
> kernel device driver also to be able to validate that what it's about
> to load into a device is authentic.

You also need to know its "authentic" for that specific device. Otherwise
you may be able to exploit something by loading an authentic firmware for
another piece of hardware.

Ie you need to sign something more than the firmware, such as (firmware,
modinfo), so it's signed for "firmware X on PCI:8086,1114 or "firmware Y
on ACPI:0A1D"

I want to understand the model, who signs what, and what security is
allegedly provided over the existing. If there are users sufficiently
paranoid to believe that signing firmware saves them, then fine. For
most hardware it can cut out some attackers, although anyone with
sufficient money or a TLA can no doubt just tap someone on the shoulder
and say you are signing this for us.

IMHO we want the supplier of a given firmware providing signatures on
the firmware git tree if this is done. A generic linux-firmware owned key
would be both a horrendously inviting attack target, and a single point of
failure.

Git can already do all the needed commit signing bits unless I'm missing
something here ?

Alan
