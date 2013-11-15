Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from farad.et-inf.fho-emden.de ([139.13.80.1]:44305 "EHLO
	farad.et-inf.fho-emden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3KONQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 08:16:45 -0500
Date: Fri, 15 Nov 2013 14:16:35 +0100
From: Mark Kettner <mkettn@technik-emden.de>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WPA_Supplicant: no unicast with wpa encryption
Message-ID: <20131115141635.663e48d7@mke-x61t> (sfid-20131115_141651_722116_710C0623)
In-Reply-To: <5285EC8C.3050708@lri.fr>
References: <20131115101803.66967a4e@mke-x61t>
	<5285EC8C.3050708@lri.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 15 Nov 2013 10:42:36 +0100 Nicolas Cavallari
<Nicolas.Cavallari@lri.fr> wrote:
> > […] 
> WPA-NONE is not true WPA. Support for it was broken in wpasupplicant
> for a long time, and the kernel does not support it anymore. Use IBSS
> RSN instead :
> 
> proto=RSN
> key_mgmt=WPA-PSK
> pairwise=CCMP
> group=CCMP
> 
> > and the /etc/network/interfaces like this:
> > auto lo
> > 
> > iface lo inet loopback
> > iface eth0 inet dhcp
> > 
> > allow-hotplug wlan0
> > iface wlan0 inet static
> >     address 192.168.13.37
> >     netmask 255.255.255.255
> > 
> >     # Load WPA-Supplicant for WPA in Ad-Hoc Mode
> >     wpa-driver wext
> 
> wext is deprecated, use nl80211 instead.

thanks for your reply.

I am now using the driver nl80211 and everything works again. But if I
apply the changes to the wpa_supplicant configuration I'm getting these
errors http://pastebin.com/GYW0mng2 in a endless loop.


- Mark
