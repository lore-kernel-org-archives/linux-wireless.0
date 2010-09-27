Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:55701 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372Ab0I0XX6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 19:23:58 -0400
Date: Tue, 28 Sep 2010 01:23:57 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A few questions about modifications in carl9170
Message-ID: <20100927232357.GA5869@qubit.lri.fr>
References: <20100927132957.GA2977@qubit.lri.fr>
 <201009271737.16603.chunkeey@googlemail.com>
 <20100927160557.GA5121@qubit.lri.fr>
 <201009271936.22261.chunkeey@googlemail.com>
 <20100927230137.GA5702@qubit.lri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100927230137.GA5702@qubit.lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 01:01:37AM +0200, thus spake Ignacy Gawedzki:
> Yeah, sorry for the vagueness, I promise I'll grab as much info as possible
> upon next encounter of such a thing.  As I remember it, it's mainly a matter
> of the module getting suck somehow (and attempts to unload it getting stuck as
> well) and the card not being detected upon subsequent insertions anymore.

And while writing that email, I left the card plugged in the USB socket.  In
the meantime, I got the following:

  usb 5-1: no command feedback received (-110).
  carl9170 cmd: 08 01 00 00 04 40 1d 00 00 00 00 00              .....@......
  usb 5-1: restart device (6)
  ieee80211 phy1: writing reg 0x1d4004 (val 0x0) failed (-110)
  usb 5-1: device restarted successfully.

Then when I unplugged it:

  usb 5-1: USB disconnect, address 11

And finally upon modprobe -r carl9170:

  usbcore: deregistering interface driver carl9170

And now modprobe is stuck in D+. :/

I now wonder how that could possibly be due to my modifications in the driver
and mac80211 (in a nutshell: retrieve the measurement per frame from the FW
and collect it into a stats structure in the sta descriptor, which is later
retrieved from userspace through netlink).  I'll try without these and report
back if that still happens.

Thanks again.

Ignacy

-- 
:wq!
