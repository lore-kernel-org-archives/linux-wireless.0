Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18278 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934238Ab0CKSZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 13:25:37 -0500
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
From: Pavel Roskin <proski@gnu.org>
To: Malte Gell <malte.gell@gmx.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201003110933.18581.malte.gell@gmx.de>
References: <201003040835.29387.malte.gell@gmx.de>
	 <201003110748.12919.malte.gell@gmx.de> <1268293219.2989.7.camel@mj>
	 <201003110933.18581.malte.gell@gmx.de>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 13:25:35 -0500
Message-Id: <1268331935.1915.19.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 09:33 +0100, Malte Gell wrote:
> Pavel Roskin <proski@gnu.org> wrote
> > Please post your .config file.  I guess you are missing something
> > obvious, like sysfs support or inotify.
> 
> Thanx, okay. It is attached. But to me it seems sysfs and inotify is there...

I compiled a kernel with your config on plain 2.6.33.  I'm using the
x86_64 architecture, so "make oldconfig" asked a few questions, but
nothing important.

I'm running that kernel with no problems.  The driver loads and works
fine.  Here's the output of udevadm monitor:

# udevadm monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[1268330587.328525] add      /module/ar9170usb (module)
UDEV  [1268330587.329955] add      /module/ar9170usb (module)
KERNEL[1268330588.565742] remove   /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0 (usb)
KERNEL[1268330588.565772] remove   /devices/pci0000:00/0000:00:1d.7/usb1/1-8 (usb)
KERNEL[1268330588.565987] add      /bus/usb/drivers/ar9170usb (drivers)
UDEV  [1268330588.567718] add      /bus/usb/drivers/ar9170usb (drivers)
UDEV  [1268330588.569497] remove   /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0 (usb)
UDEV  [1268330588.571498] remove   /devices/pci0000:00/0000:00:1d.7/usb1/1-8 (usb)
KERNEL[1268330589.868626] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8 (usb)
KERNEL[1268330589.869178] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0 (usb)
KERNEL[1268330591.158658] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/firmware/1-8 (firmware)
KERNEL[1268330591.161688] remove   /devices/pci0000:00/0000:00:1d.7/usb1/1-8/firmware/1-8 (firmware)
UDEV  [1268330591.162451] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/firmware/1-8 (firmware)
UDEV  [1268330591.163424] remove   /devices/pci0000:00/0000:00:1d.7/usb1/1-8/firmware/1-8 (firmware)
KERNEL[1268330591.736323] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/ieee80211/phy2 (ieee80211)
KERNEL[1268330591.736349] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/ieee80211/phy2/rfkill1 (rfkill)
KERNEL[1268330591.736503] change   /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/ieee80211/phy2/rfkill1 (rfkill)
KERNEL[1268330591.737446] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/net/wlan0 (net)
KERNEL[1268330591.740066] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/leds/ar9170-phy2::tx (leds)
UDEV  [1268330591.740094] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8 (usb)
KERNEL[1268330591.740105] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/leds/ar9170-phy2::assoc (leds)
UDEV  [1268330591.745693] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0 (usb)
UDEV  [1268330591.746816] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/leds/ar9170-phy2::assoc (leds)
UDEV  [1268330591.748185] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/leds/ar9170-phy2::tx (leds)
KERNEL[1268330591.751861] move     /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/net/wlan25 (net)
UDEV  [1268330591.768580] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/ieee80211/phy2 (ieee80211)
UDEV  [1268330591.771943] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/ieee80211/phy2/rfkill1 (rfkill)
UDEV  [1268330591.775586] change   /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/ieee80211/phy2/rfkill1 (rfkill)
UDEV  [1268330591.789582] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/net/wlan25 (net)
UDEV  [1268330591.799576] move     /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/net/wlan25 (net)


It looks like you get no USB events.  Also, the output looks
differently.  KERNEL events are called UEVENT in your log.

Maybe you could try another USB port, just in case?  I would probably
add debugging to the udev scripts to see what they are doing.  Maybe
there is an update for udev for your system?

Perhaps you should find another forum to ask questions about udev.  I
think the kernel is not a suspect anymore.

-- 
Regards,
Pavel Roskin
