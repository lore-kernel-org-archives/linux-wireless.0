Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40949 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZBLCMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 21:12:35 -0500
Message-ID: <49938557.60907@candelatech.com> (sfid-20090212_031257_948278_6C6297D4)
Date: Wed, 11 Feb 2009 18:11:35 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: RUMI Szabolcs <rumi_ml@rtfm.hu>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	Matteo Brusa <matteo.brusa@kaasa.com>
Subject: Re: ath5k master (AP) mode
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>	 <1226530010.15173.0.camel@dv>	 <20081113004632.d8d821c5.rumi_ml@rtfm.hu>	 <20081113181155.c556bde1.rumi_ml@rtfm.hu>	 <1226598550.5839.3.camel@johannes.berg>	 <20081113235928.3ed79ff6.rumi_ml@rtfm.hu>	 <40f31dec0811131507x7449112cy5746d28c848a2146@mail.gmail.com>	 <20081114111559.56530874.rumi_ml@rtfm.hu>	 <20090210131418.9c3408a9.rumi_ml@rtfm.hu> <40f31dec0902111349q222bce42y50345dafe244b267@mail.gmail.com>
In-Reply-To: <40f31dec0902111349q222bce42y50345dafe244b267@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:

> The only reason we haven't enabled AP support yet is that it didn't
> work on some devices and we need to make more tests to be sure that
> it's ok.

I found a blog entry from Jiri saying he had it working on the AR5212,
but I'm unable to reproduce his luck.  I only added the patch to enable
AP mode, assuming the rest are already in the wireless-testing tree.

My NIC:
16:00.0 Ethernet controller: Atheros Communications, Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)

As long as I leave channel=0, I don't see any obvious errors when I start hostapd,
but I don't see any APs show up on a friend's Vista system (or my G1).  If I try
to set a channel (channel=1, for instance), then it fails to set the channel and aborts.

I haven't used hostapd before, so I could be messing that up somehow.  I'm trying
the latest git snapshot as of today, and the libnl-1.1


Here is my hostapd startup, in case it helps:

[root@ibmt60w-1 hostapd]# ./hostapd -d hostapd_ath5k.conf
Configuration file: hostapd_ath5k.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 10596688
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
wlan1: IEEE 802.11 Fetching hardware channel/rate support not supported.
Flushing old station entries
Deauthenticate all stations
Using interface wlan1 with hwaddr 00:0b:6b:20:88:75 and ssid 'ben-ath5k'
wlan1: Setup of interface done.
MGMT (TX callback) ACK
MGMT (TX callback) ACK
mgmt::proberesp cb
MGMT (TX callback) ACK
mgmt::proberesp cb

I see these in the kernel logs, as well:
Feb 11 17:55:23 ibmt60w-1 kernel: ath5k phy1: beacon queue 7 didn't stop?
Feb 11 17:56:27 ibmt60w-1 kernel:last message repeated 74 times
[root@ibmt60w-1 ~]#


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

