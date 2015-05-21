Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:43694 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755791AbbEUOqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 10:46:11 -0400
Date: Thu, 21 May 2015 17:45:52 +0300
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
Message-ID: <20150521144552.GD18164@localhost> (sfid-20150521_164650_773598_C1E02536)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
 <20150520164613.GD10473@localhost>
 <20150521044104.GH22632@kroah.com>
 <20150521054101.GA15037@localhost>
 <20150521061453.GC30864@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150521061453.GC30864@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-05-20 23:14:53, Greg Kroah-Hartman wrote:
> 
> Ok, but how do we know "where"?  Who is going to start signing and attesting 
> to the validity of all of the firmware images in the linux-firmware tree 
> suddenly?  Why is it the kernel's job to attest this "where"?  Shouldn't your 
> distro/manufacturer be doing that as part of their "put this file on this 
> disk" responsibilities (i.e. the package manager?)

I did not say the kernel should care about signatures.  This is entirely user's
choice.  You care about authenticity, you require signature and verify it
against "known good" certificate. s/you/distro/

I'm just saying that it would be nice to have this feature in case somebody need 
it.  Luckily IMA has this functionality, although you'll have to work hard to 
get to use it. :)

> What is verifying a firmware image signature in the kernel attesting that 
> isn't already known in userspace?

The kernel is a lot better place to keep certificates and keys safe, compared to 
userland.


		Petko
