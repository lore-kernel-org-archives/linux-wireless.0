Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:16690 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZCGN4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 08:56:10 -0500
Received: by ey-out-2122.google.com with SMTP id 25so137927eya.37
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2009 05:56:06 -0800 (PST)
From: Florian Fainelli <florian@openwrt.org>
To: Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH 00/15] ath9k: Virtual interfaces and radios
Date: Sat, 7 Mar 2009 14:56:03 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20090303172325.437810138@atheros.com>
In-Reply-To: <20090303172325.437810138@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903071456.03827.florian@openwrt.org> (sfid-20090307_145621_148826_97936F4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni,

Le Tuesday 03 March 2009 18:23:25 Jouni Malinen, vous avez =C3=A9crit=C2=
=A0:
> When using virtual wiphys, the APs that the virtual interfaces are
> associated with do not need to be on the same channel. One of the
> wiphys could also be used with hostapd to bring up an AP. However, it
> should be noted that most client implementation do not exactly like
> the AP disappearing all the time, so using a virtual station interfac=
e
> on another channel at the same time may not be that good of an idea
> for most use cases now. This will hopefully improve somewhat with
> future optimizations.
>
>
> It would be useful to hear what others think about this sort of
> functionality and how this should be integrated with Linux, including
> the user space interface, applications managing the virtual interface
> functionality, and user interface that the end users would see. This
> is still quite an early step in the progress, but the goal here is to
> get this functionality into mature state and provide something that
> makes it easier to use wireless LAN in general for connecting devices
> in various scenarios. All feedback would be welcome!

I am only commenting from a user point of view this feature. This defin=
itively=20
is very useful since quite a lot of people stick to madwifi instead of =
using=20
ath5k or ath9k since there was not real support before this patch for v=
irtual=20
interfaces.

One thing that I did not like with wlanconfig and I would like not to f=
ind=20
with mac80211/cfg80211 is the incompatibility of some setups (i.e: AP s=
hould=20
be created first, STA interface later with nosbeacon), not sure this is=
=20
possible, but if it is, one should be able to add a virtual interface w=
ithout=20
knowing the state of the other interfaces before.

I really like the way we can create mesh point interfaces with iw, so t=
his=20
could be the user interface to configure virtual interfaces, say like t=
his :

iw dev wlan0 interface add sta0 type sta
iw dev wlan0 interface add ap0 type master

On a broader perspective, I really hope other drivers will become capab=
le of=20
supporting virtual interfaces as well.

Thank you for your work.
--=20
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
