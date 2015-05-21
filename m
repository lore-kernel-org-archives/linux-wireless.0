Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbbEUQ5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:57:38 -0400
Date: Thu, 21 May 2015 09:57:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
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
Message-ID: <20150521165737.GB12932@kroah.com> (sfid-20150521_185742_785618_5CC0D756)
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
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521155319.GG18164@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 06:53:19PM +0300, Petko Manolov wrote:
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

The device can also verify "is this firmware from a trusted source", and
it should if it is a "good" device.  "correctness" can just be a simple
checksum, and I think most of the firmware blobs already have that in
them :)

Are these patches "verifying the vendor"?  Right now it just looks like
they are "verifying the packager" as none of the hundreds of firmware
images we have actually have stand-alone signatures.

Do we have firmware images that are going to be signed by the vendor?
If so, are they also not signed in the firmware itself?  Why are we
forcing the kernel to do this verification that the device should be
doing instead?

thanks,

greg k-h
