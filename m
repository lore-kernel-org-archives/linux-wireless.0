Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:48477 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3KOPMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 10:12:55 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Mark Kettner <mkettn@technik-emden.de>
Subject: Re: WPA_Supplicant: no unicast with wpa encryption
Date: Fri, 15 Nov 2013 16:12:50 +0100
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	linux-wireless@vger.kernel.org
References: <20131115101803.66967a4e@mke-x61t> <5285EC8C.3050708@lri.fr> <20131115141635.663e48d7@mke-x61t>
In-Reply-To: <20131115141635.663e48d7@mke-x61t>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201311151612.50894.sw@simonwunderlich.de> (sfid-20131115_161259_090532_1AD3F5F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mark,

> On Fri, 15 Nov 2013 10:42:36 +0100 Nicolas Cavallari
> 
> <Nicolas.Cavallari@lri.fr> wrote:
> > > […]
> > 
> > WPA-NONE is not true WPA. Support for it was broken in wpasupplicant
> > for a long time, and the kernel does not support it anymore. Use IBSS
> > RSN instead :
> > 
> > proto=RSN
> > key_mgmt=WPA-PSK
> > pairwise=CCMP
> > group=CCMP
> > 
> > > and the /etc/network/interfaces like this:
> > > auto lo
> > > 
> > > iface lo inet loopback
> > > iface eth0 inet dhcp
> > > 
> > > allow-hotplug wlan0
> > > iface wlan0 inet static
> > > 
> > >     address 192.168.13.37
> > >     netmask 255.255.255.255
> > >     
> > >     # Load WPA-Supplicant for WPA in Ad-Hoc Mode
> > >     wpa-driver wext
> > 
> > wext is deprecated, use nl80211 instead.
> 
> thanks for your reply.
> 
> I am now using the driver nl80211 and everything works again. But if I
> apply the changes to the wpa_supplicant configuration I'm getting these
> errors http://pastebin.com/GYW0mng2 in a endless loop.

you might need a recent version of wpa_supplicant as well - AFAIK v2.0 or 
higher. If that is already installed, please let us know your kernel version 
and wpa_supplicant version.

Cheers,
    Simon
