Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:44004 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbbEURPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 13:15:10 -0400
Date: Thu, 21 May 2015 20:14:38 +0300
From: Petko Manolov <petkan@mip-labs.com>
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
	"mcgrof@suse.com" <mcgrof@suse.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521171438.GK18164@localhost> (sfid-20150521_191518_483116_3E0A23A2)
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

On 15-05-21 10:02:36, gregkh@linuxfoundation.org wrote:
> On Thu, May 21, 2015 at 04:03:02PM +0000, Woodhouse, David wrote:
> > 
> > In a lot of cases we have loadable firmware precisely to allow us to
> > reduce the cost of the hardware. Adding cryptographic capability in the
> > 'load firmware' state of the device isn't really compatible with that
> > :)
> 
> We do?  What devices want this?  That's really a bad hardware design to trust 
> the kernel to get all of this correct.

Which means nearly all hardware we use today is badly designed... :)

> And I say this as someone who is currently working on a hardware design that 
> does just this for a very tiny device.  It's only a few hundred bytes of 
> firmware size to be able to do proper key verification that the firmware image 
> is correct and can be "trusted".

And a "few" more bytes for the hash algorithm along the one for asymmetric key 
computation and management. :)

> > In the case where kernel and modules are signed, it *is* useful for a kernel 
> > device driver also to be able to validate that what it's about to load into 
> > a device is authentic. Where 'authentic' will originally just mean that it's 
> > come from the linux-firmware.git repository or the same entity that built 
> > (and signed) the kernel, but actually I *do* expect vendors who are actively 
> > maintaining the firmware images in linux-firmware.git to start providing 
> > detached signatures of their own.
> 
> Again, why have a detached signature and not just part of the firmware blob?  
> The device needs to be caring about this, not the kernel.

In ideal world this is what should be done.  However, adding the simplest (read 
slowest) MD5 implementation requires a few K's of ram on 32bit cpu.  MD5 is 
dead.  So we need SHA-something, which isn't smaller in terms of code size.  Add 
the asymmetric cryptography to the picture and we've already put away all 
vendors.

> As the kernel doesn't know/care about what the firmware blob really is, I 
> don't see why it should be caring about firmware signing as that's a binary 
> running on a separate "computer".  Do we want to take this the next logical 
> step further and start requiring networked devices to attest their kernels are 
> signed correctly before we can talk to them?

I think it is enough for you to know that your iwlwifi's firmware comes from 
Intel and not from a random Internet punk.  If you trust Intel with your wifi 
adapter you probably trust them to write good firmware for it.


		Petko
