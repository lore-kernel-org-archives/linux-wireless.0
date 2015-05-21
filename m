Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43145 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025AbbEUFl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 01:41:26 -0400
Date: Thu, 21 May 2015 08:41:02 +0300
From: Petko Manolov <petkan@mip-labs.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521054101.GA15037@localhost> (sfid-20150521_074145_720274_F4EEC057)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521044104.GH22632@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-20 21:41:04, Greg Kroah-Hartman wrote:
> On Wed, May 20, 2015 at 07:46:13PM +0300, Petko Manolov wrote:
> > On 15-05-20 17:24:46, One Thousand Gnomes wrote:
> > > 
> > > More to the point why do you want to sign firmware files ? Leaving aside the 
> > > fact that someone will produce a device with GPLv3 firmware just to p*ss you 
> > > off there's the rather more relevant fact that firmware for devices on a so 
> > > called "trusted" platform already have signed firmware.
> > 
> > For "trusted" systems one would like to make sure everything that goes in has 
> > known provenance.  Maybe this was the idea?
> 
> If so, then just do what people do today, verify their known valid disk image 
> before mounting it and then they know they can trust the data on it to be use 
> for whatever (including firmware.)  No kernel changes needed, distro support 
> is already there for this.

I do agree, the infrastructure is already in place.  The project i am working on 
has very strict security requirements, quite unlike regular Linux box.  I was 
pleasantly surprised that it didn't take much kernel hacking to get to the point 
where stuff is working to our liking.

> I too don't understand this need to sign something that you don't really know 
> what it is from some other company, just to send it to a separate device that 
> is going to do whatever it wants with it if it is signed or not.

This is not the point.  What you need to know is _where_ the firmware came from, 
not _what_ it does once it reach your system.  If you don't care about such 
things, just ignore the signature. :)


		Petko
