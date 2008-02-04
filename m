Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58517 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754117AbYBDTc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 14:32:58 -0500
Subject: b43 doesn't reset hardware when loaded/unloaded [severity: minor]
From: Thomas Ilnseher <illth@gmx.de>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 04 Feb 2008 20:32:55 +0100
Message-Id: <1202153575.8270.7.camel@note.localnet> (sfid-20080204_193304_190617_7263942E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I upgraded my kernel to 2.6.24, and
so I also upgraded from bcm43xx to b43.

There used to be a problem with bcm43xx that after 
resuming from Supend-To-Ram, wireless didn't work anymore.

This however could be fixed with bcm43xx using the following 
sequence:

killall dhcpcd
killall wpa_supplicant
ifconfig wlan0 down #nb: the if was renamed from eth1 to wlan0 via udev
rmmod bcm43xx
modprobe bcm43xx
ifconfig wlan0 up
wpa_supplicant -iwlan0 -Dwext -c/etc/wpa_supplicant/wpa_supplicant.conf\
-B -P/var/run/wpa_supplicant.pid
dhcpcd wlan0

It doesn't work with b43. (of course replacing bcm43xx with b43).
I *assume* that the core isn't completely reseted on insmod'ing.

regards,
tom

PS: keep the good work!
also, tux-on-ice works, so this is just a minor annoyance.

-- 
Thomas Ilnseher <illth@gmx.de>

