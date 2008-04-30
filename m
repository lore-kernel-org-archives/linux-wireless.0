Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:1714 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761762AbYD3VSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 17:18:38 -0400
Received: by py-out-1112.google.com with SMTP id u52so1074562pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 14:18:37 -0700 (PDT)
Message-ID: <ac542ca00804301418k5d74476fnd4ed6f342f82bffa@mail.gmail.com> (sfid-20080430_231828_745034_0AAAB2D0)
Date: Wed, 30 Apr 2008 23:18:36 +0200
From: "Francis Galiegue" <fgaliegue@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: BCM4308 rev 3 owner, willing to help (want to make an access point)
In-Reply-To: <41960ccf0804290113k33e322f0se045d47bc654b90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ac542ca00804280404h20db4b1cn56a2c5fefc119760@mail.gmail.com>
	 <4816D790.50302@gmail.com>
	 <41960ccf0804290113k33e322f0se045d47bc654b90@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/4/29 Lorenzo Nava <navalorenx@gmail.com>:
[...]
>
> If you look for the thread "Does mac80211 support ap mode" in the
>  mailing list archive you can find some infos.
>  You have to download the patch "allow-ap-vlan-mode.patch" that you c=
an
>  find at http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
>  Then you have to install hostapd (version 0.6.3) with nl80211 driver
>  (you can find all the informations that you need in the hostapd site=
).
>  At the moment you can't enable master mode with iwconfig, you can do
>  it only with hostapd.
>

OK, I got it all working with:

- wireless-testing kernel,
- libnl 1.1,
- git master branch of hostapd.

But I cannot do WPA, only "clear text".

The thing is, my wlan interface is part of a bridge, and the bridge is
set up as:

brctl addif br0 eth0
brctl addif br0 wlan0

where wlan0 is the b43. I know nada about WPA, but can this have an
influence? The MAC address of the bridge is the one of the Ethernet
card, not the wireless one, and I specified wlan0 in hostapd.conf as
the interface to grab...
--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=E9phane Faroult, in "The
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
