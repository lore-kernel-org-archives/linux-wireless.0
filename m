Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64341 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab1DMQMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:30 -0400
Received: by bwz15 with SMTP id 15so703857bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 09:12:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <201104131214.53633.chunkeey@googlemail.com> <BANLkTikKvO6EvMrGtOCdYCO9_pdgUzPxyQ@mail.gmail.com>
 <201104131332.47029.chunkeey@googlemail.com> <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Wed, 13 Apr 2011 18:11:48 +0200
Message-ID: <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I turned off N i have this in log.
http://pastebin.com/raw.php?i=q0zKxUZn


And still 16 mbps.

2011/4/13 Damian Lesiuk <lesiuk@gmail.com>:
> tcpdump file
> http://uniwersytecka.dyndns.biz/~lesiuk/dump
>
> I had hostapd older than 0.7.3 but after upgrade there is the same problem.
> There is only one change. Windows 7 is displaying it as 75 mbps
> connection not 150 mbps (with the same config as with the older
> version) but I have still 16 mbps dl rate.
>
> I am using gentoo linux and I didn't compiled that driver manually. I
> have that driver from 3.6.38 kernel.
> I really want to make it work.
>
> What should I do? Will OS change help?
>
> 2011/4/13 Christian Lamparter <chunkeey@googlemail.com>:
>> On Wednesday 13 April 2011 12:51:58 Damian Lesiuk wrote:
>>> It doesn't solved my problem. Still max dl speed 16 mbps.
>> ok, so it could be something else... maybe it's a driver bug, maybe
>> something is outdated [avoid hostapd older than 0.7,3], or maybe
>> just a simple configuration problem [on either side]?
>>
>> you can't tell that by just looking at the low throughput figure.
>> Instead you probably have to capture the handshake between the
>> AP+client and look who's lying about their 11n capabilities.
>>
>> Luckily, all mac80211-based driver come with a nifty feature which
>> allows you to monitor any incoming/outgoing data. Just setup a
>> monitor interface.
>> <http://wireless.kernel.org/en/users/Documentation/iw#Adding_interfaces_with_iw>
>>
>> and start a sniffer. tcpdump/whireshark is more than enough.
>>
>>> btw, Can I use ath9k_htc with my Atheros 9170 in N master mode.
>> no, ar9170 is too old. ath9k_htc is exclusive driver for the
>> ar9271,ar701x+ar928x devices, which appeared in late 2009.
>>
>>> What about performance?
>> it's ok.
>>
>> Regards,
>>        Chr
>>
>
