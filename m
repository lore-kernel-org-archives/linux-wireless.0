Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45891 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab0GWX1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 19:27:15 -0400
Subject: Re: Wireless card on Debian squeeze
From: Pavel Roskin <proski@gnu.org>
To: Nicholas Syrotiuk <syrotiuk@manchester.ac.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C488BD9.8040809@manchester.ac.uk>
References: <4C488BD9.8040809@manchester.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 19:27:10 -0400
Message-ID: <1279927630.23722.24.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 19:20 +0100, Nicholas Syrotiuk wrote:
> Dear Linux Wireless users,
> 
> I'm having some trouble installing the correct driver on my laptop.  I'm 
> slightly confused about the revision numbering of my wireless hardware; 
> that is, I'm not sure if it's revision 2 or 3.
> 
> My kernel is: 2.6.32-5
> Relevant output from lspci is:
> 02:03.0 Network controller [0280]: Broadcom Corporation BCM4306 
> 802.11b/g Wireless LAN Controller [14e4:4320] (rev 02)
> 	Subsystem: Dell TrueMobile 1300 WLAN Mini-PCI Card [1028:0001]
> 	Flags: bus master, fast devsel, latency 32, IRQ 5
> 	Memory at fafee000 (32-bit, non-prefetchable) [size=8K]
> 	Kernel driver in use: b43-pci-bridge
> -----------------------------------------------
> 
> It looks like I need the b43legacy driver, which comes in a separate 
> Debian package called "firmware-b43legacy-installer."  When I install 
> this package, computer says: "Not supported card.  Use b43 firmware."
> 
> When I install b43 firmware, configure the interface and bring it up, 
> computer says: "Firmware file b43legacy/ucode4.fw not found or load failed."

I believe the drivers should be trusted since there they access the
actual hardware.  The above message is from b43legacy.  It must have
found the card, so the card needs b43legacy.

That means that firmware-b43legacy-installer is wrong.  I don't have
Debian handy, but I checked its source, and it should work for your
card.

That's the page:
http://packages.debian.org/sid/firmware-b43legacy-installer

And that's the source:
http://ftp.de.debian.org/debian/pool/contrib/b/b43-fwcutter/b43-fwcutter_013-2.debian.tar.gz

I ran your "lspci -n" output through the
firmware-b43legacy-installer.postinst script and it doesn't complain.

> So, I am slightly confounded.  However, it has occurred to me that I may 
> be getting the packages from the wrong source, which are currently:
> 
> deb http://debian.man.ac.uk/debian squeeze main
> deb http://ftp.us.debian.org/debian squeeze main contrib

Make sure your apt-get knows about the latest packages, that is run
"apt-get update".  Then try installing firmware-b43legacy-installer.

If it doesn't work, download the package from the above page and install
it with dpkg.  Alternatively, you could generate the firmware manually,
as described at http://linuxwireless.org/en/users/Drivers/b43

-- 
Regards,
Pavel Roskin
