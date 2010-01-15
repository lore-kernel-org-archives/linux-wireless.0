Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:46611 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300Ab0AOMbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 07:31:06 -0500
Message-ID: <4B505B94.3020509@scram.de>
Date: Fri, 15 Jan 2010 13:12:04 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Daniel Schmitt <daniel@schmitt-united.de>
CC: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: PHY Transmission error and radio turned off with b43legacy
References: <51ab59276e22ee681f29560ebac67004.squirrel@unimail.uni-dortmund.de>
In-Reply-To: <51ab59276e22ee681f29560ebac67004.squirrel@unimail.uni-dortmund.de>
Content-Type: multipart/mixed;
 boundary="------------040800050600090409080307"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040800050600090409080307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Daniel Schmitt wrote:

> hostapd doesn't continue to work after controller is restarted.
> I also have the problem that the wlan0-interface shall not be upped with
> "ifconfig wlan0 0.0.0.0 up" before starting hostapd, otherwise no beacons
> will be send. The interface must be down before starting hostapd.
> If I terminate a not daemonized hostapd with CTRL+C and restart if without
> rmmod+modprobe b43legacy, no beacons are sent, too. And I cannot connect
> the AP.
> This happens with the bleeding-edge wireless drivers 2009-11-13.

I noticed the same on MN700 hardware running OpenWrt bleeding edge. The init scripts enable and 
disable wlan0 once before starting hostapd. Here, beacons are still being sent, but hostapd is 
unable to transmit any packet. When reloading b43legacy and starting hostapd manually it works, but 
only once.

The attached patch resolves the problem for me.

Thanks,
Jochen

--------------040800050600090409080307
Content-Type: text/x-patch;
 name="011-b43legacy_queues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="011-b43legacy_queues.patch"

--- compat-wireless-2010-01-11/drivers/net/wireless/b43legacy/main.c.orig	2010-01-14 12:14:39.000000000 +0100
+++ compat-wireless-2010-01-11/drivers/net/wireless/b43legacy/main.c	2010-01-14 12:14:52.000000000 +0100
@@ -2921,6 +2921,7 @@
 		goto out;
 	}
 	/* We are ready to run. */
+	ieee80211_wake_queues(dev->wl->hw);
 	b43legacy_set_status(dev, B43legacy_STAT_STARTED);
 
 	/* Start data flow (TX/RX) */

--------------040800050600090409080307--
