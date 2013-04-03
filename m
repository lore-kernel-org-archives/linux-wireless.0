Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966Ab3DCNnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:43:01 -0400
Message-ID: <1364996574.8351.43.camel@jlt4.sipsolutions.net> (sfid-20130403_154305_560059_1158F383)
Subject: Re: mac80211_hwsim driver attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Date: Wed, 03 Apr 2013 15:42:54 +0200
In-Reply-To: <20130403133802.GK2960@piware.de>
References: <20130403133802.GK2960@piware.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 13:38 +0000, Martin Pitt wrote:
> Hello John, hello Johannes,
> 
> first, many thanks for this great mac80211_hwsim module! I am
> currently working on automatic test cases for the Linux network stack
> (wpa_supplicant, dhclient, NetworkManager, etc.), and this is of great
> help.
> 
> One issue is that NetworkManager does not get along with these
> simulated interfaces:
> 
> NetworkManager[24027]: <warn> /sys/devices/virtual/mac80211_hwsim/hwsim0/net/wlan1: couldn't determine device driver; ignoring...
> 
> It calls udev_device_get_driver() on the net device (wlan0) (and
> failing that, on its parent), but that fails because hwsim doesn't
> have a driver attribute. My real intel wifi does:
> 
> lrwxrwxrwx 1 root root 0 Apr  3 06:19 /sys/class/net/wlan0/device/driver -> ../../../../bus/pci/drivers/iwlwifi
> 
> But /sys/class/net/wlan1/device/ only has the default "uevent" and
> subsystem link.
> 
> Other drivers call something like pci_register_driver() or
> usb_register(), I figure those will register the driver symlink in
> sysfs? But admittedly I'm a kernel n00b, so I'd appreciate a hint
> where to look for.
> 
> Thank you in advance!
> 
> Martin


