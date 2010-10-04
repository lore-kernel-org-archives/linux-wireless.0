Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:47018 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab0JDJVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 05:21:05 -0400
Message-ID: <4CA997A3.7080409@scram.de>
Date: Mon, 04 Oct 2010 11:00:19 +0200
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Holger Schurig <holgerschurig@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Patch] iw: Implement set 4addr.
References: <1286041239-19169-1-git-send-email-jochen@scram.de> <201010040915.58549.holgerschurig@gmail.com>
In-Reply-To: <201010040915.58549.holgerschurig@gmail.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Hi Holger,

Am 04.10.2010 09:15, schrieb Holger Schurig:
>> +	"Set interface 4addr (WDS) mode.\n");
> Hi Jochen !
>
> Do you know if this feature can also be used to operate an Ethernet-Bridge on
> on a WLAN client?
>
> I'd like to get something like this going, with eth0|wlan0 as a bridge, so
> that any protocol/port on the "DEVICE" is reachable from the network:
>
> +--------+   +------------+   +----+   +---------+
> | DEVICE +---+ eth0|wlan0 +---+ AP +---+ network |
> +--------+   +------------+   +----+   +---------+
>                 Linux 2.6.x
>                 w/ mac80211
>

Yes, that's the idea behind this. I'm using an OpenWRT based WLAN router 
and a Debian client with the configuration below.

 From my tests, it looks like

- b43legacy runs OK in this mode (tested on MN700).
- ath9k has some issues with the promisc mode (if DEVICE talks to 
another AP client, the bridge might add the DEVICE MAC address to wlan0 
as soon as AP sends the frame originating from DEVICE to the AP client).
- iwlagn sometimes looses the connection after a hw scan. I'm currently 
wondering if this might be a problem of ath5k (my AP is a WGT634U) not 
ignoring PM frames in non-4addr frame format. Unfortunately, WGT634U 
builds are currently broken in OpenWRT, so I can't test more recent 
ath5k versions without major efforts.

Thanks,
Jochen

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet manual
     pre-up iw wlan0 set 4addr on

auto eth0
iface eth0 inet manual

auto br0
iface br0 inet dhcp
     bridge_ports wlan0 eth0
     bridge_fd 0
     bridge_stp off
     wpa-ssid <my ssid>
     wpa-psk <my password>
     wpa-bridge br0
     wpa-iface  wlan0

