Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24887 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYJEF5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 01:57:10 -0400
To: "Greg KH" <greg@kroah.com>
Cc: proski@gnu.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
References: <20081002210742.GA27221@kroah.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 05 Oct 2008 08:56:20 +0300
In-Reply-To: <20081002210742.GA27221@kroah.com> (ext Greg's message of "Thu\, 2 Oct 2008 14\:07\:42 -0700")
Message-ID: <87y713y48r.fsf@nokia.com> (sfid-20081005_075716_191945_A6DFA76C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> Hi,

Hello,

> In my quest to suck drivers into drivers/staging/ I noticed that the
> at76_usb driver is being shipped by both Fedora and Ubuntu in their
> kernels.

Yes, that's the original at76_usb driver which has it's own 802.11
stack. Pavel Rosking was the maintainer of that driver. Based on the
feedback in linux-wireless I then started porting the driver to use
mac80211. 

(Maybe I should have renamed the port to something else than at76_usb
because having two different drivers with the same name creates
confusion.)

> So I was wondering what the status of this driver is, and if I
> could/should add it to drivers/staging/?

The original at76_usb is working quite well, but it's unacceptable for
the mainline because we cannot have two 802.11 stacks in kernel.

I'm working to get the mac80211 port to mainline. But the port is
still unstable, biggest problem being that firmware seems to crash
when I associate to the same AP twice. I'm sure this is a bug in the
port, I just haven't found it yet.

> If it's about to go into 2.6.28 then I'll hold off, but it would be
> nice to know what the status is.

The mac80211 port is not ready for mainline yet, my aim is to get it
ready during this year.

> Also, it looks like it is being developed in a git tree, where is that
> tree?

The originial at76_usb git tree was here:

http://git.80211libre.org/at76_usb.git/

But it seems to be gone now. The current mac80211 port is in
linux-wireless (in one patch) and the original history is here:

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-legacy.git at76

> And, did you merge the USB DFU code into the driver itself?

Yes, someone implemented it in driver.

> Having that kind of functionality in the USB core is fine with me if
> you want me to add that portion there, no reason it needs to be
> burried in individual drivers.

USB DFU is a standard? So it seems:

http://wiki.openmoko.org/wiki/USB_DFU

Heh, I didn't know this. I though it was some Atmel proprietary
interface :)

I might be interested in getting DFU into USB core, because I would
like to learn more about USB. But first I need to get at76_usb stable.

-- 
Kalle Valo
