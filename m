Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbbEUPpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 11:45:09 -0400
Date: Thu, 21 May 2015 08:45:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
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
Message-ID: <20150521154508.GA11821@kroah.com> (sfid-20150521_174526_530183_7EC4F60A)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
 <20150521061453.GC30864@kroah.com>
 <1432213521.4230.43.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432213521.4230.43.camel@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 09:05:21AM -0400, Mimi Zohar wrote:
> On Wed, 2015-05-20 at 23:14 -0700, Greg Kroah-Hartman wrote:
> > On Thu, May 21, 2015 at 08:41:02AM +0300, Petko Manolov wrote:
> > > > I too don't understand this need to sign something that you don't really know 
> > > > what it is from some other company, just to send it to a separate device that 
> > > > is going to do whatever it wants with it if it is signed or not.
> > > 
> > > This is not the point.  What you need to know is _where_ the firmware came from, 
> > > not _what_ it does once it reach your system.  If you don't care about such 
> > > things, just ignore the signature. :)
> > 
> > Ok, but how do we know "where"?  Who is going to start signing and
> > attesting to the validity of all of the firmware images in the
> > linux-firmware tree suddenly?  Why is it the kernel's job to attest this
> > "where"?  Shouldn't your distro/manufacturer be doing that as part of
> > their "put this file on this disk" responsibilities (i.e. the package
> > manager?)
> 
> Signatures don't provide any guarantees as to code quality or
> correctness.   They do provide file integrity and provenance.  In
> addition to the license and a Signed-off-by line, having the firmware
> provider include a signature of the firmware would be nice.

That would be "nice", but that's not going to be happening here, from
what I can tell.  The firmware provider should be putting the signature
inside the firmware image itself, and verifying it on the device, in
order to properly "know" that it should be running that firmware.  The
kernel shouldn't be involved here at all, as Alan pointed out.

> > What is verifying a firmware image signature in the kernel attesting
> > that isn't already known in userspace?
> 
> Appraising and enforcing firmware integrity before use.

That should be done on the device itself, not in the kernel.

thanks,

greg k-h
