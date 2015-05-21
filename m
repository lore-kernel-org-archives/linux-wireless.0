Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36373 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422641AbbEUQXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 12:23:22 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Fri, 22 May 2015 02:23:20 +1000
Message-ID: <1432225340.2450.6.camel@linux.vnet.ibm.com> (sfid-20150521_182356_897097_7641B4C5)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seth.forshee@canonical.com" <seth.forshee@canonical.com>,
	"mricon@kernel.org" <mricon@kernel.org>,
	"dhowells@redhat.com" <dhowells@redhat.com>,
	"rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	"jlee@suse.de" <jlee@suse.de>, "kyle@kernel.org" <kyle@kernel.org>,
	"gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"mcgrof@suse.com" <mcgrof@suse.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 21 May 2015 12:22:20 -0400
In-Reply-To: <1432224181.8004.7.camel@intel.com>
References: <20150519200232.GM23057@wotan.suse.de>
	 <20150520140426.GB126473@ubuntu-hedt>
	 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
	 <20150520164613.GD10473@localhost> <20150521044104.GH22632@kroah.com>
	 <20150521054101.GA15037@localhost> <20150521061453.GC30864@kroah.com>
	 <1432213521.4230.43.camel@linux.vnet.ibm.com>
	 <20150521154508.GA11821@kroah.com> <1432224181.8004.7.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-21 at 16:03 +0000, Woodhouse, David wrote:
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
> 
> In the case where kernel and modules are signed, it *is* useful for a
> kernel device driver also to be able to validate that what it's about
> to load into a device is authentic. Where 'authentic' will originally
> just mean that it's come from the linux-firmware.git repository or the
> same entity that built (and signed) the kernel, but actually I *do*
> expect vendors who are actively maintaining the firmware images in
> linux-firmware.git to start providing detached signatures of their own.

That's great!  What format do you expect the detached signatures to be?
Where will they reside?

Mimi

