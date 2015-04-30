Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37889 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbbD3GBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 02:01:25 -0400
Received: by wiun10 with SMTP id n10so5201133wiu.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 23:01:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKLmikOSs-1x5dbDtRtgim-_nsFfX-6xd=WZArYfwnOS1ULP3A@mail.gmail.com>
References: <CAKLmikOSs-1x5dbDtRtgim-_nsFfX-6xd=WZArYfwnOS1ULP3A@mail.gmail.com>
Date: Thu, 30 Apr 2015 08:01:24 +0200
Message-ID: <CA+BoTQmkqM5SpOxudSzuXL=oMp39Uu3TgUc17aXFs8aFqJM+aw@mail.gmail.com> (sfid-20150430_080129_298201_84C00C39)
Subject: Re: Regression with iw set bitrates
From: Michal Kazior <michal.kazior@tieto.com>
To: Mitar <mmitar@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 April 2015 at 11:43, Mitar <mmitar@gmail.com> wrote:
> Hi!
>
> On OpenWrt, between these versions:
>
> https://dev.openwrt.org/log/branches/barrier_breaker?action=stop_on_copy&mode=stop_on_copy&rev=44952&stop_rev=42475&limit=200&mail_addr=&mail_addr_confirm=
>
> there was a regression in how iw set bitrates operate. Because I
> suspect it is an upstream issue, I am reporting it here.
>
> With previous version of our firmware image, I was using the
> /etc/hotplug.d/iface/30-bitrates script you can see in this file:
>
> https://github.com/cloyne/network/blob/349297c8bfd115aa68e3b8c47bb3a7197f1e777f/unifi/README.md
>
> The goal was to limit on all 2.4 GHz interfaces bitrates to G standard
> and higher, removing all legacy stuff.
>
> It seems it worked. But with an upgrade to the new firmware image,
> this script started misbehaving and high-end WiFi devices were able to
> connect only with MSC 0. I determined that the issue is in the
> following command:
>
> iw wlan0 set bitrates legacy-2.4 6 9 12 18 24 36 48 54 ht-mcs-2.4 lgi-2.4
>
> With this command in effect, my client has in station dump the
> following bitrates:
>
> tx bitrate:    6.5 MBit/s MCS 0
> rx bitrate:    216.7 MBit/s MCS 23 short GI

With the above command you basically disable HT rates since you say
"ht-mcs-2.4" but specify no MCS indexes to use.


> If I change the command to:
>
> iw wlan0 set bitrates legacy-2.4 6 9 12 18 24 36 48 54
>
> tx bitrate:    195.0 MBit/s MCS 23
> rx bitrate:    216.7 MBit/s MCS 23 short GI

In this you effectively disable CCK (11b) rates and leave OFDM (11g),
and you leave HT rates untouched (i.e. allow HT to be used).


>
> Which is the expected bitrate.
>
> If I run only:
>
> iw wlan0 set bitrates ht-mcs-2.4
>
> tx bitrate:    11.0 MBit/s
> rx bitrate:    117.0 MBit/s MCS 20
>
> This goes against the documentation which is saying that this should
> reset bitrates masks to normal:
>
> https://wireless.wiki.kernel.org/en/users/documentation/iw#modifying_tx_ht_mcs_bitrates

It seems the docs err on this.

To reset bitrates to normal you need to issue:

  iw wlanX set bitrates

(no arguments follow)


> Maybe I am not using the command correctly. In general it is unclear
> what should be correct behavior here. I also opened a SuperUser
> question:
>
> http://superuser.com/questions/881025/limiting-low-bitrates-with-iw-on-ath9k
>
> So maybe clearer documentation would make it easier to know what is
> the correct command? So, what is current (and hopefully future proof)
> command to not allow legacy bitrates, but to allow any other (which
> would work also on future devices without having to modify the list of
> allowed MCS when they are added)?

I don't recall bitrates command ever changed behaviour. Apparently the
docs were always incorrect I guess?


Michał
