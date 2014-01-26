Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65161 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaAZOhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 09:37:38 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so5505255obc.11
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jan 2014 06:37:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com>
References: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com>
Date: Sun, 26 Jan 2014 15:37:37 +0100
Message-ID: <CACna6ryDakV+oo6pW1BN5rcDPqR9=1khUHtYqmtTf85JR5x2Lg@mail.gmail.com> (sfid-20140126_153740_663759_6A0F67EA)
Subject: Re: Scanning regression since "cfg80211: use DS or HT operation IEs
 to determine BSS channel"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/26 Rafał Miłecki <zajec5@gmail.com>:
> I've just finished bisecting wireless scanning regression I'm
> experiencing with my 14e4:432b (BCM4322) and b43 driver.
>
> The problem is getting my network visible in scanning results (iw dev
> wlan0 scan). I've to repeat scanning dozens of time to notice my AP.
> It's also well visible when using wpa_supplicant. It takes from 20s to
> 100s before I get the "Trying to authenticate with".
> The performance however is not affected. Once I connect to my network,
> I can transmit (tested with iperf) with stable 21.5Mb/s which is just
> great for 802.11g.
>
> After going back to the kernel before that commit it takes
> wpa_supplicant less than 2 seconds to connect to my WiFi network.
>
> My network is at channel 13, I still have to verify if it matters.
>
> Any thought about that?
>
>
> The first bad commit (I've verified manually after bisecting) appears to be:
>
> 0172bb75073e11a5aa9d8a953bdaefb8709f00c8 is the first bad commit
> commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Nov 23 14:23:30 2012 +0100
>
>     cfg80211: use DS or HT operation IEs to determine BSS channel

This has been finally fixed in 64e5acb09ca6b50c97299cff9ef51299470b29f2 [0].

[0] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=64e5acb09ca6b50c97299cff9ef51299470b29f2
