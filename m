Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linicks.net ([87.127.191.50]:48649 "EHLO mail.linicks.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3FLMAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 08:00:09 -0400
Date: Wed, 12 Jun 2013 13:00:08 +0100
From: Nick Warne <nick@linicks.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [QUERY] Intel Centrino Wireless-N 100 modules vs built-in
Message-ID: <20130612120008.GA10459@sauron> (sfid-20130612_140013_799460_B5310742)
References: <20130612112326.GA10313@sauron>
 <1371037816.8601.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371037816.8601.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, Jun 12, 2013 at 01:50:16PM +0200, Johannes Berg wrote:
> Nick,
> 
> > Device Drivers->Network Device Support->Wireless LAN
> > 
> > <M>   Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi)
> > -M-   Intel Wireless WiFi DVM Firmware support
> > 
> > all is hucky dory.  But if I build-in these drivers into kernel (<*>), on boot dmesg reports:
> > 
> > [2.347954] iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-100-5.ucode' failed.
> > [2.351885] iwlwifi 0000:05:00.0: no suitable firmware found!
> > 
> > Am I missing something here - I don't quite understand why this happens?
> 
> The driver has to request firmware when the device is bound to it, so it
> can then register correctly with mac80211. Newer versions of udev don't
> respond negatively if they don't have the firmware while running from
> initrd/initramfs, and will leave the driver's request pending to be
> answered once the real filesystem is mounted. You seem to not be running
> a version of udev with this logic.
> 
> To work around it, you could include the firmware in the
> initrd/initramfs.
> 
> Alternatively, you could unbind/re-bind the driver after the system has
> full booted, like this:
> 
> # echo 0000:05:00.0 > /sys/module/iwlwifi/drivers/pci\:iwlwifi/unbind
> # echo 0000:05:00.0 > /sys/module/iwlwifi/drivers/pci\:iwlwifi/bind
> 
> This will force it to attempt to load the firmware from disk again.

Thank you very much for a comprehensive reply.

I am using Linux-Mint on this machines, so at the moment am using the 'debian fakeroot make-kpkg...' stuff, so the build is dumbed down for the user ('tis easy on my Slackware box!).

So, reading what you said, I think I will leave 'as is'.

Again, thank you for the reply, and 'sorry for the noise!'

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
