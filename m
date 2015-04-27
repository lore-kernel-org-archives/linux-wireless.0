Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37198 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbD0JnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 05:43:01 -0400
Received: by igblo3 with SMTP id lo3so56513583igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2015 02:43:00 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Apr 2015 02:43:00 -0700
Message-ID: <CAKLmikOSs-1x5dbDtRtgim-_nsFfX-6xd=WZArYfwnOS1ULP3A@mail.gmail.com> (sfid-20150427_114305_261571_7289A851)
Subject: Regression with iw set bitrates
From: Mitar <mmitar@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On OpenWrt, between these versions:

https://dev.openwrt.org/log/branches/barrier_breaker?action=stop_on_copy&mode=stop_on_copy&rev=44952&stop_rev=42475&limit=200&mail_addr=&mail_addr_confirm=

there was a regression in how iw set bitrates operate. Because I
suspect it is an upstream issue, I am reporting it here.

With previous version of our firmware image, I was using the
/etc/hotplug.d/iface/30-bitrates script you can see in this file:

https://github.com/cloyne/network/blob/349297c8bfd115aa68e3b8c47bb3a7197f1e777f/unifi/README.md

The goal was to limit on all 2.4 GHz interfaces bitrates to G standard
and higher, removing all legacy stuff.

It seems it worked. But with an upgrade to the new firmware image,
this script started misbehaving and high-end WiFi devices were able to
connect only with MSC 0. I determined that the issue is in the
following command:

iw wlan0 set bitrates legacy-2.4 6 9 12 18 24 36 48 54 ht-mcs-2.4 lgi-2.4

With this command in effect, my client has in station dump the
following bitrates:

tx bitrate:    6.5 MBit/s MCS 0
rx bitrate:    216.7 MBit/s MCS 23 short GI

If I change the command to:

iw wlan0 set bitrates legacy-2.4 6 9 12 18 24 36 48 54

tx bitrate:    195.0 MBit/s MCS 23
rx bitrate:    216.7 MBit/s MCS 23 short GI

Which is the expected bitrate.

If I run only:

iw wlan0 set bitrates ht-mcs-2.4

tx bitrate:    11.0 MBit/s
rx bitrate:    117.0 MBit/s MCS 20

This goes against the documentation which is saying that this should
reset bitrates masks to normal:

https://wireless.wiki.kernel.org/en/users/documentation/iw#modifying_tx_ht_mcs_bitrates

Maybe I am not using the command correctly. In general it is unclear
what should be correct behavior here. I also opened a SuperUser
question:

http://superuser.com/questions/881025/limiting-low-bitrates-with-iw-on-ath9k

So maybe clearer documentation would make it easier to know what is
the correct command? So, what is current (and hopefully future proof)
command to not allow legacy bitrates, but to allow any other (which
would work also on future devices without having to modify the list of
allowed MCS when they are added)?

iw --version
iw version 3.15

kmod-ath - 3.10.49+2014-05-22-1
kmod-ath9k - 3.10.49+2014-05-22-1
kmod-ath9k-common - 3.10.49+2014-05-22-1
kmod-cfg80211 - 3.10.49+2014-05-22-1
kmod-mac80211 - 3.10.49+2014-05-22-1
wireless-info - 0.1-1
wireless-tools - 29-5


Mitar

-- 
http://mitar.tnode.com/
https://twitter.com/mitar_m
