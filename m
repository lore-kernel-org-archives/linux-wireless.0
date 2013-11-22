Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from farad.et-inf.fho-emden.de ([139.13.80.1]:48751 "EHLO
	farad.et-inf.fho-emden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3KVJaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 04:30:14 -0500
Date: Fri, 22 Nov 2013 10:30:07 +0100
From: Mark Kettner <mkettn@technik-emden.de>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: WPA_Supplicant: no unicast with wpa encryption
Message-ID: <20131122103007.67e81f97@mke-x61t> (sfid-20131122_103021_001922_6EDBB719)
In-Reply-To: <201311151612.50894.sw@simonwunderlich.de>
References: <20131115101803.66967a4e@mke-x61t>
	<5285EC8C.3050708@lri.fr>
	<20131115141635.663e48d7@mke-x61t>
	<201311151612.50894.sw@simonwunderlich.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
the update was quite a hassle, but now everything works fine, many
thanks.

-Mark

On Fri, 15 Nov 2013 16:12:50 +0100 Simon Wunderlich
<sw@simonwunderlich.de> wrote:
> Mark,
> 
> > On Fri, 15 Nov 2013 10:42:36 +0100 Nicolas Cavallari
> > 
> > <Nicolas.Cavallari@lri.fr> wrote:
> > > > […]
> > > 
> > > WPA-NONE is not true WPA. Support for it was broken in
> > > wpasupplicant for a long time, and the kernel does not support it
> > > anymore. Use IBSS RSN instead :
> > > 
> > > proto=RSN
> > > key_mgmt=WPA-PSK
> > > pairwise=CCMP
> > > group=CCMP
> > > 
> > > > and the /etc/network/interfaces like this:
> > > > auto lo
> > > > 
> > > > iface lo inet loopback
> > > > iface eth0 inet dhcp
> > > > 
> > > > allow-hotplug wlan0
> > > > iface wlan0 inet static
> > > > 
> > > >     address 192.168.13.37
> > > >     netmask 255.255.255.255
> > > >     
> > > >     # Load WPA-Supplicant for WPA in Ad-Hoc Mode
> > > >     wpa-driver wext
> > > 
> > > wext is deprecated, use nl80211 instead.
> > 
> > thanks for your reply.
> > 
> > I am now using the driver nl80211 and everything works again. But
> > if I apply the changes to the wpa_supplicant configuration I'm
> > getting these errors http://pastebin.com/GYW0mng2 in a endless loop.
> 
> you might need a recent version of wpa_supplicant as well - AFAIK
> v2.0 or higher. If that is already installed, please let us know your
> kernel version and wpa_supplicant version.
> 
> Cheers,
>     Simon
