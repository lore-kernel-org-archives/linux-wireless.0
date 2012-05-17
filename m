Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761466Ab2EQRbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 13:31:50 -0400
Date: Thu, 17 May 2012 10:31:50 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Hansjoerg Lipp <hjlipp@web.de>,
	linux-bluetooth@vger.kernel.org,
	gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Subject: Re: [RFC 13/13] USB: Disable hub-initiated LPM for comms devices.
Message-ID: <20120517173150.GE4967@xanatos> (sfid-20120517_193159_697085_F8150A1D)
References: <cover.1337203535.git.sarah.a.sharp@linux.intel.com>
 <3c634afbbe15598cdcbf77bb9393d22ad4bfa373.1337203535.git.sarah.a.sharp@linux.intel.com>
 <4FB53054.9070309@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB53054.9070309@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 17, 2012 at 07:07:32PM +0200, Tilman Schmidt wrote:
> Am 16.05.2012 23:55, schrieb Sarah Sharp:
> > Set the disable_hub_initiated_lpm flag for for all USB communications
> > drivers.  I know there aren't currently any USB 3.0 devices that
> > implement these class specifications, but we should be ready if they do.
> 
> I follow the argument for class drivers. But this patch also
> modifies drivers for specific existing USB 2.0 only devices
> which are unlikely to ever grow USB 3.0 support, such as the
> Gigaset ISDN driver:
> 
> >  drivers/isdn/gigaset/bas-gigaset.c            |    1 +
> >  drivers/isdn/gigaset/usb-gigaset.c            |    1 +

Is there a particular reason why you think that driver is unlikely to
ever get USB 3.0 support?  I pretty much grabbed any USB driver that
looked like a communications driver without looking too closely at the
code.

> What is the interest of setting the disable_hub_initiated_lpm
> flag for these?

It's partially to lay the foundation for anyone who wants to make a USB
3.0 communications driver in the future.  They're likely to start from
some USB 2.0 class driver, and copy a lot of code.  If they notice that
flag is set in all the USB communications class drivers, they're likely
to set it as well.

I'm not quite sure where the best place to provide documentation on the
flag is.  I've added the kernel doc comments to the structure, but maybe
it needs to be documented somewhere in Documentation/usb/?

Sarah Sharp
