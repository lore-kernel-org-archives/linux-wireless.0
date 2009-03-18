Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34683 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752640AbZCRMA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 08:00:59 -0400
Message-ID: <49C0E276.5060809@gmx.net> (sfid-20090318_130102_502795_FA4D61A2)
Date: Wed, 18 Mar 2009 13:00:54 +0100
From: elektra <onelektra@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Ruggedized adhoc mode for large scale layer 3 mesh networks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Community networking initiatives (like Freifunk/Funkfeuer and many
others in developing countries like Air Jaldi in India) are running now
large scale layer 3 meshes (up to 800 mesh nodes in a single IBSS cell).
A problem has always been the stability of the ad-hoc mode in large
ad-hoc cells. Typical problems are steady TSF timestamp skews, MAC timer
skews and subsequent lockups, failed or endlessly repeating IBSS merges
to the same cell and hence IBSS cell-splits.

Currently there is only one open-source driver (not entirely open-source
because of the binary HAL blob) which is up to the challenge of such
networks - Madwifi (Not the vanilla code from madwifi-project.org, but
the patched Madwifi from OpenWRT Kamikaze maintained by OpenWRT
developer Felix Fietkau).

It would be great to have a few drivers in the kernel that are up to the
challenge, too. Hence this is a feature request. Let me explain what has
been done to Madwifi to cope with the problems.

Madwifi can be forced to bypass IBSS merges and stick to a certain
IBSS-ID by issuing a command like:

iwconfig athX ap 02:CA:FF:EE:BA:BE

This was not sufficient to fix stability problems with Madwifi, as TSF
time stamp skews were still messing up a hardware timer related to the
ATIM window which caused stuck beacons/stuck transmit queues. The
workaround for Atheros was to switch the hardware into AP mode so it
doesn't try to adjust its hardware timers to TSF time stamps. Hence
beacons have to be generated in software which is not precise enough.
(IMHO TSF time stamps are pretty much superfluous in adhoc mode because
I guess we can savely forget about power saving mechanisms in a large
scale mesh cloud anyway, I propose to deliberately let software
generated beacons lag behind the TSF time stamps in order to avoid
confusing other ad-hoc peers)

If someone wants to experiment with Madwifi in this mode, create the
adhoc VAP with the "nosbeacon" option. (Example: wlanconfig ath0 create
wlandev wifi0 wlanmode adhoc nosbeacon)

So these wireless mesh communities have at least one perfectly working
solution for wireless interfaces for Atheros SoC/PCI/PCI-E devices(
well, almost perfect because of the timer precision issues). It would be
great if ath5k and ath9k could be used in the same way, too.

We are lacking support for at least one USB chipset as well.
Zydas/Atheros 5007UG would be great. USB would open up the opportunity
to connect desktop PCs to mesh networks at low cost / build cheap mesh
supernodes (routers with more than two wireless interfaces). It would be
awesome to use USB devices, because USB dongles could be easily built
into the antennas and save the cost and RF losses of expensive
pigtails/RF-plugs/RF-cables. Interfaces usually placed in close
proximity on one motherboard and thus all interfering with each other
could be seperated up to 10 meters away from each other.

Antenna/USB-WLAN<--------------5m USB cable -------------> Router
<--------------- 5m USB cable -------------> USB-WLAN/Antenna


Cheers,

Elektra





