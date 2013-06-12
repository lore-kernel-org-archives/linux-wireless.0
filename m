Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3FLLuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 07:50:23 -0400
Message-ID: <1371037816.8601.13.camel@jlt4.sipsolutions.net> (sfid-20130612_135029_092653_B4030FFF)
Subject: Re: [QUERY] Intel Centrino Wireless-N 100 modules vs built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Warne <nick@linicks.net>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Jun 2013 13:50:16 +0200
In-Reply-To: <20130612112326.GA10313@sauron> (sfid-20130612_133412_709863_242F03A2)
References: <20130612112326.GA10313@sauron>
	 (sfid-20130612_133412_709863_242F03A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick,

> Device Drivers->Network Device Support->Wireless LAN
> 
> <M>   Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi)
> -M-   Intel Wireless WiFi DVM Firmware support
> 
> all is hucky dory.  But if I build-in these drivers into kernel (<*>), on boot dmesg reports:
> 
> [2.347954] iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-100-5.ucode' failed.
> [2.351885] iwlwifi 0000:05:00.0: no suitable firmware found!
> 
> Am I missing something here - I don't quite understand why this happens?

The driver has to request firmware when the device is bound to it, so it
can then register correctly with mac80211. Newer versions of udev don't
respond negatively if they don't have the firmware while running from
initrd/initramfs, and will leave the driver's request pending to be
answered once the real filesystem is mounted. You seem to not be running
a version of udev with this logic.

To work around it, you could include the firmware in the
initrd/initramfs.

Alternatively, you could unbind/re-bind the driver after the system has
full booted, like this:

# echo 0000:05:00.0 > /sys/module/iwlwifi/drivers/pci\:iwlwifi/unbind
# echo 0000:05:00.0 > /sys/module/iwlwifi/drivers/pci\:iwlwifi/bind

This will force it to attempt to load the firmware from disk again.

johannes

