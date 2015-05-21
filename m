Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbEUGOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 02:14:54 -0400
Date: Wed, 20 May 2015 23:14:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
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
Message-ID: <20150521061453.GC30864@kroah.com> (sfid-20150521_081516_719711_EEB7659D)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521054101.GA15037@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2015 at 08:41:02AM +0300, Petko Manolov wrote:
> > I too don't understand this need to sign something that you don't really know 
> > what it is from some other company, just to send it to a separate device that 
> > is going to do whatever it wants with it if it is signed or not.
> 
> This is not the point.  What you need to know is _where_ the firmware came from, 
> not _what_ it does once it reach your system.  If you don't care about such 
> things, just ignore the signature. :)

Ok, but how do we know "where"?  Who is going to start signing and
attesting to the validity of all of the firmware images in the
linux-firmware tree suddenly?  Why is it the kernel's job to attest this
"where"?  Shouldn't your distro/manufacturer be doing that as part of
their "put this file on this disk" responsibilities (i.e. the package
manager?)

What is verifying a firmware image signature in the kernel attesting
that isn't already known in userspace?

thanks,

greg k-h
