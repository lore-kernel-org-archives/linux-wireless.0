Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40136 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765997Ab3DEK4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 06:56:55 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so3741077wgg.24
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 03:56:53 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Apr 2013 07:56:53 -0300
Message-ID: <CAJ6uix7giXd1oUEc1MYo7=nGEVPPOR8_MMmT5zY3AWFYPpi4=A@mail.gmail.com> (sfid-20130405_125717_052715_753891EE)
Subject: Problems with Intel 6200/iwlwifi, WEP, and HT/VHT
From: Leonardo Boiko <leoboiko@namakajiri.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm sorry if this isn't the right place to report this.

I'm having trouble associating with the AP.  The players are:
 - Intel 6200 [8086:4239] (built-in on a Thinkpad X201), iwlwifi,
kernel 3.9.0-rc4 (Debian wheezy)
 - Linksys WRT54G-TM AP running openwrt, Linux 3.3.8 mips, using WEP
(don't ask).

When I try to iwconfig it fails like this:
    wlan0: authenticate with 00:1c:10:3b:b5:a6
    wlan0: send auth to 00:1c:10:3b:b5:a6 (try 1/3)
    wlan0: send auth to 00:1c:10:3b:b5:a6 (try 2/3)
    wlan0: send auth to 00:1c:10:3b:b5:a6 (try 3/3)
    wlan0: authentication with 00:1c:10:3b:b5:a6 timed out
    wlan0: authenticate with 00:1c:10:3b:b5:a6
    wlan0: send auth to 00:1c:10:3b:b5:a6 (try 1/3)
    wlan0: 00:1c:10:3b:b5:a6 denied authentication (status 13)

Fiddling with parameters and such I found it would ~sometimes~ work,
unpredictably (signal quality is 60/70).  After a while I noticed I
could just leave a for loop running, & it would eventually connect.
It seems that, whenever it suceeds, it's preceded by this message:

    iwlwifi 0000:02:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
    wlan0: associate with 00:1c:10:3b:b5:a6 (try 1/3)
    wlan0: associate with 00:1c:10:3b:b5:a6 (try 2/3)
    wlan0: RX AssocResp from 00:1c:10:3b:b5:a6 (capab=0x411 status=0 aid=1)
    wlan0: associated
    IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

But I don't understand what triggers the VHT disable, or why it didn't
disable it from the start.
