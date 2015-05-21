Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43777 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754830AbbEUPxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 11:53:32 -0400
Date: Thu, 21 May 2015 18:53:19 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
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
Message-ID: <20150521155319.GG18164@localhost> (sfid-20150521_180648_373123_4122CBFC)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
 <20150521061453.GC30864@kroah.com>
 <1432213521.4230.43.camel@linux.vnet.ibm.com>
 <20150521154508.GA11821@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521154508.GA11821@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-21 08:45:08, Greg Kroah-Hartman wrote:
> On Thu, May 21, 2015 at 09:05:21AM -0400, Mimi Zohar wrote:
> > 
> > Signatures don't provide any guarantees as to code quality or
> > correctness.   They do provide file integrity and provenance.  In
> > addition to the license and a Signed-off-by line, having the firmware
> > provider include a signature of the firmware would be nice.
> 
> That would be "nice", but that's not going to be happening here, from what I 
> can tell.  The firmware provider should be putting the signature inside the 
> firmware image itself, and verifying it on the device, in order to properly 
> "know" that it should be running that firmware.  The kernel shouldn't be 
> involved here at all, as Alan pointed out.

It is device's job to verify firmware's correctness.  It is user's job to verify 
vendor's identity.  Two different things, not related to each other.

I think Alan meant something else.  What i read is that if somebody have 
physical access to the device they may harm the device much easier and would 
not bother to tamper with firmware.

> > > What is verifying a firmware image signature in the kernel attesting
> > > that isn't already known in userspace?
> > 
> > Appraising and enforcing firmware integrity before use.
> 
> That should be done on the device itself, not in the kernel.

Oh, well...
