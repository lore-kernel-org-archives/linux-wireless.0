Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.248]:10683 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756063AbYD2INw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 04:13:52 -0400
Received: by rv-out-0506.google.com with SMTP id k29so3153992rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2008 01:13:51 -0700 (PDT)
Message-ID: <41960ccf0804290113k33e322f0se045d47bc654b90@mail.gmail.com> (sfid-20080429_101410_411054_48658439)
Date: Tue, 29 Apr 2008 10:13:51 +0200
From: "Lorenzo Nava" <navalorenx@gmail.com>
To: "Francis Galiegue" <fgaliegue@gmail.com>
Subject: Re: BCM4308 rev 3 owner, willing to help (want to make an access point)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4816D790.50302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ac542ca00804280404h20db4b1cn56a2c5fefc119760@mail.gmail.com>
	 <4816D790.50302@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francis Galiegue wrote:

> I've started reading documentation on wireless.kernel.org, and don't
> understand much of it (nl80211, mac80211, cfg80211... Many things to
> learn about).
>
> Right now I'm stuck at the "setting the card to master mode": iwconfig
> wlan0 mode master returns "Invalid argument". The card works fine with
> other modes though.
>

If you look for the thread "Does mac80211 support ap mode" in the
mailing list archive you can find some infos.
You have to download the patch "allow-ap-vlan-mode.patch" that you can
find at http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
Then you have to install hostapd (version 0.6.3) with nl80211 driver
(you can find all the informations that you need in the hostapd site).
At the moment you can't enable master mode with iwconfig, you can do
it only with hostapd.


Now here is my problem: I have a BCM4306 (b43 driver) with kernel
2.6.25-rc9 and hostapd-0.6.3 installed. I tested the card performance
with a simple test. The configuration of the network for the test was:
an access point (my computer with BCM4306) and 2 clients (both using
b43 driver). I used no encryption and work with 11M rate.
I sent a CBR traffic (11M) from the 2 clients to the access point.
When I started transmit packets from clients they disconnected from
the AP until I didn't stop the transmission. Hostapd print this
message that I've never seen before:
 _Failed to set beacon head/tail_

The problem is related to hostapd? Maybe when the AP processes a lot
of traffic it was unable to generate beacons correctly?

As the final goal of the experiment was to try 80211e performance, I
tried the ad-hoc network mode, but I saw that the stations don't use
qos support. Can I use qos with ad-hoc network?

 Thank you

 regards
