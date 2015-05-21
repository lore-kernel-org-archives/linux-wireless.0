Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58715 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbbEUNGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 09:06:21 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 21 May 2015 23:06:18 +1000
Message-ID: <1432213521.4230.43.camel@linux.vnet.ibm.com> (sfid-20150521_150651_544651_8DA58FBA)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
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
	mricon@kernel.org
Date: Thu, 21 May 2015 09:05:21 -0400
In-Reply-To: <20150521061453.GC30864@kroah.com>
References: <20150519200232.GM23057@wotan.suse.de>
	 <20150520140426.GB126473@ubuntu-hedt>
	 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
	 <20150520164613.GD10473@localhost> <20150521044104.GH22632@kroah.com>
	 <20150521054101.GA15037@localhost> <20150521061453.GC30864@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-20 at 23:14 -0700, Greg Kroah-Hartman wrote:
> On Thu, May 21, 2015 at 08:41:02AM +0300, Petko Manolov wrote:
> > > I too don't understand this need to sign something that you don't really know 
> > > what it is from some other company, just to send it to a separate device that 
> > > is going to do whatever it wants with it if it is signed or not.
> > 
> > This is not the point.  What you need to know is _where_ the firmware came from, 
> > not _what_ it does once it reach your system.  If you don't care about such 
> > things, just ignore the signature. :)
> 
> Ok, but how do we know "where"?  Who is going to start signing and
> attesting to the validity of all of the firmware images in the
> linux-firmware tree suddenly?  Why is it the kernel's job to attest this
> "where"?  Shouldn't your distro/manufacturer be doing that as part of
> their "put this file on this disk" responsibilities (i.e. the package
> manager?)

Signatures don't provide any guarantees as to code quality or
correctness.   They do provide file integrity and provenance.  In
addition to the license and a Signed-off-by line, having the firmware
provider include a signature of the firmware would be nice.

> What is verifying a firmware image signature in the kernel attesting
> that isn't already known in userspace?

Appraising and enforcing firmware integrity before use.

Mimi

