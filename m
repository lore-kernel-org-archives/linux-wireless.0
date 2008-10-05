Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:32847 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYJEGMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 02:12:55 -0400
Subject: Re: at76_usb driver status
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Greg KH <greg@kroah.com>, proski@gnu.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87y713y48r.fsf@nokia.com>
References: <20081002210742.GA27221@kroah.com>  <87y713y48r.fsf@nokia.com>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 08:13:09 +0200
Message-Id: <1223187189.11272.74.camel@violet.holtmann.net> (sfid-20081005_081328_492005_4FCE5FA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> > In my quest to suck drivers into drivers/staging/ I noticed that the
> > at76_usb driver is being shipped by both Fedora and Ubuntu in their
> > kernels.
> 
> Yes, that's the original at76_usb driver which has it's own 802.11
> stack. Pavel Rosking was the maintainer of that driver. Based on the
> feedback in linux-wireless I then started porting the driver to use
> mac80211. 
> 
> (Maybe I should have renamed the port to something else than at76_usb
> because having two different drivers with the same name creates
> confusion.)
> 
> > So I was wondering what the status of this driver is, and if I
> > could/should add it to drivers/staging/?
> 
> The original at76_usb is working quite well, but it's unacceptable for
> the mainline because we cannot have two 802.11 stacks in kernel.
> 
> I'm working to get the mac80211 port to mainline. But the port is
> still unstable, biggest problem being that firmware seems to crash
> when I associate to the same AP twice. I'm sure this is a bug in the
> port, I just haven't found it yet.
> 
> > If it's about to go into 2.6.28 then I'll hold off, but it would be
> > nice to know what the status is.
> 
> The mac80211 port is not ready for mainline yet, my aim is to get it
> ready during this year.
> 
> > Also, it looks like it is being developed in a git tree, where is that
> > tree?
> 
> The originial at76_usb git tree was here:
> 
> http://git.80211libre.org/at76_usb.git/
> 
> But it seems to be gone now. The current mac80211 port is in
> linux-wireless (in one patch) and the original history is here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-legacy.git at76
> 
> > And, did you merge the USB DFU code into the driver itself?
> 
> Yes, someone implemented it in driver.
> 
> > Having that kind of functionality in the USB core is fine with me if
> > you want me to add that portion there, no reason it needs to be
> > burried in individual drivers.
> 
> USB DFU is a standard? So it seems:
> 
> http://wiki.openmoko.org/wiki/USB_DFU
> 
> Heh, I didn't know this. I though it was some Atmel proprietary
> interface :)
> 
> I might be interested in getting DFU into USB core, because I would
> like to learn more about USB. But first I need to get at76_usb stable.

please be careful with this. I have seen so many broken or vendor
enhanced DFU stuff that it might be not a good idea to put it into the
USB core since it would be full of quirks.

I do have my own dfutool used for firmware flashing and the OpenMoko
project got their own dfu-util. Both in userspace.

Regards

Marcel


