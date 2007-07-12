Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:53483 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbXGLIQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 04:16:11 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1I8tqo-0006XL-TG
	for linux-wireless@vger.kernel.org; Thu, 12 Jul 2007 04:16:38 -0400
Subject: at76_usb - fourth submission attempt
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: Guido Guenther <agx@sigxcpu.org>,
	at76c503a-develop@lists.berlios.de
Content-Type: text/plain
Date: Thu, 12 Jul 2007 04:16:06 -0400
Message-Id: <1184228166.2377.31.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'd like to submit at76_usb driver for inclusion into the kernel.

The driver's temporary repository is located at
http://git.80211libre.org/at76_usb.git/

To compile the driver standalone, just run "make" and "make install".
To integrate the driver into the kernel, apply kernel_patch.diff to the
kernel with -p1 option, then copy at76_usb*.[ch] to drivers/net/wireless

For the driver to work, please download the firmware from
http://developer.berlios.de/projects/at76c503a/

This is the fourth submission attempt.  Three previous attempts were
made by Guido Guenther, and generated a lot of useful feedback.  I
believe all the recommendations have been accepted.

The driver went through a massive cleanup, but I realize that a lot of
work still needs to be done.  I think the process will be more effective
if more people take a look at the code.  New eyes will see new flaws.

The biggest change that has not been done is conversion to mac80211.  I
believe it's possible, but I don't expect it to happen overnight.  Until
then, at76_usb uses its own implementation of 802.11 protocol.  I'm not
going to polish it, but I tried to clean up the code to the point that
it can be easily understood.

If possible, I'd like the driver to be in Linux 2.6.23.  That would
rejuvenate the interest to the driver, and hopefully it might attract
new contributors.  I think at76_usb is quite on the par with other
non-mac80211 drivers currently in Linux (although I do realize that it's
a poor excuse).

I'll do my best to convert the driver to mac80211.  I think it would be
OK to replace the driver with the mac80211 version later, e.g. in Linux
2.6.24.  There are parts of the driver that don't deal with 802.11 layer
(e.g. firmware download and MIBs), and it would be great if they receive
some good testing in the meantime.

In any case, I'll appreciate any comments regarding the code.

It's my first driver submission ever, so please don't hesitate to tell
me if I'm doing anything wrong.

-- 
Regards,
Pavel Roskin

