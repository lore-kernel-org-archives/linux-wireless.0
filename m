Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751011AbZDOVZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 17:25:40 -0400
Date: Wed, 15 Apr 2009 14:21:04 -0700
From: Greg KH <greg@kroah.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: dcbw@redhat.com, linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090415212103.GA5202@kroah.com> (sfid-20090415_232543_949847_39CD7E8F)
References: <49E632A1.1050605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49E632A1.1050605@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 09:16:49PM +0200, Xose Vazquez Perez wrote:
> Dan Williams wrote:
> 
> > The only fixes that drivers are getting in staging now are netdev_ops,
> > whitespace cleanups, and trivial fixes.  Nobody is actually rewriting
> > the Ralink or Via staging drivers to use mac80211, which is what's
> > needed for them to be merged.  Given that they are going nowhere, are
> 
> Only rtl8187se and wlan-ng don't have a mac80211 port.
> 
> mac80211 drivers:
> 
> agnx		-> http://git.sipsolutions.net/agnx.git
> at76_usb	-> replacement already in kernel.org code at drivers/net/wireless/at76c50x-usb.[ch]
> otus		-> replacement already in kernel.org code at drivers/net/wireless/ar9170/
> rt2860		-> rt2800pci.[ch] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
> rt2870		-> rt2800usb.[ch] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
> rt3070		-> rt2800usb.[ch] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
> rtl8187se	-> ???
> stlc45xx	-> replacement already in kernel.org code at drivers/net/wireless/p54/p54spi*
> winbond		-> http://code.google.com/p/winbondport/
> wlan-ng		-> ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/FAQ ???

Thanks for the summary.

Note, whenever a "real" wireless driver goes into the tree that
obsoletes any of the staging drivers, please let me know and I'll
instantly remove it.

Right now the otus code is staying because the ar9170 developers want it
to.

But what about at76_usb?  stlc45xx?  Do they now have workable drivers
to replace them in the tree today?  If so, _please_ let me know.


As for the other drivers, here's what I know:
	rtl8187se - a varient of rtl818x, someone just needs to do the
	work to add the proper parts to the existing driver.  I tried,
	and it wasn't obvious how to do this :(
	wlan-ng - this is being cleaned up by community members for
	eventual inclusion in the main tree.  It only supports a single
	type of USB device.
	winbond - community members are cleaning it up as well.

> I hope rt2800pci/usb to be included *ASAP*, because rt2800usb supports
> more than 1oo USB devices and rt2800pci is included in a lot of
> laptops(ask Torvalds [1] [2])
> 
> [1] http://marc.info/?l=linux-netdev&m=121799144422863&w=2
> [2] http://marc.info/?l=linux-kernel&m=123187052023831&w=2

That would be great to have in, what's keeping it from happening?

thanks,

greg k-h
