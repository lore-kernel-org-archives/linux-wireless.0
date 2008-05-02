Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:22233 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYEBIdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 04:33:23 -0400
Received: by py-out-1112.google.com with SMTP id u52so2145368pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 01:33:22 -0700 (PDT)
Message-ID: <ac542ca00805020133n7cf550f6k39998a23017e5843@mail.gmail.com> (sfid-20080502_103304_421484_0596D8EE)
Date: Fri, 2 May 2008 10:33:22 +0200
From: "Francis Galiegue" <fgaliegue@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: BCM4308 rev 3 owner, willing to help (want to make an access point)
In-Reply-To: <ac542ca00804301418k5d74476fnd4ed6f342f82bffa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ac542ca00804280404h20db4b1cn56a2c5fefc119760@mail.gmail.com>
	 <4816D790.50302@gmail.com>
	 <41960ccf0804290113k33e322f0se045d47bc654b90@mail.gmail.com>
	 <ac542ca00804301418k5d74476fnd4ed6f342f82bffa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/4/30 Francis Galiegue <fgaliegue@gmail.com>:
>
>  OK, I got it all working with:
>
>  - wireless-testing kernel,
>  - libnl 1.1,
>  - git master branch of hostapd.
>
>  But I cannot do WPA, only "clear text".
>
>  The thing is, my wlan interface is part of a bridge, and the bridge =
is
>  set up as:
>
>  brctl addif br0 eth0
>  brctl addif br0 wlan0
>
>  where wlan0 is the b43. I know nada about WPA, but can this have an
>  influence? The MAC address of the bridge is the one of the Ethernet
>  card, not the wireless one, and I specified wlan0 in hostapd.conf as
>  the interface to grab...
>

It looks like the bridge makes hostapd (well, WPA at least) unhappy.

If the b43 is not in a bridge, WPA works... Is that a hostapd problem o=
nly?

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
