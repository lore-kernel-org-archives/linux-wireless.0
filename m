Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42433 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaB0QKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:10:23 -0500
Received: by mail-vc0-f174.google.com with SMTP id im17so2682779vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 08:10:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393517094.4648.3.camel@jlt4.sipsolutions.net>
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	<1393517094.4648.3.camel@jlt4.sipsolutions.net>
Date: Thu, 27 Feb 2014 11:10:22 -0500
Message-ID: <CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com> (sfid-20140227_171026_855715_9F31AB58)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Tim Nelson <tim.l.nelson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although it is a similar setup, no.  I am able to connect on ALL
radios but the AC radio's on the 3702's.  I encounter no bugs, no loss
of connection.  However, I NEVER connect to the AC radio on the AP.  I
know it works due to my Nexus 5 connecting to the AC radio
immediately.  If the 3702 saw that my adapter was AC capable, it would
use the AC radio and not the A/N.  Also, every other device with
wireless AC connects fine without issue, even the same laptop on it's
Windows 8 partition.

If it is AC capable, how do I get it to connect to the AC radio's on
the AP?  It is entirely possible it is something Cisco/Linux related
with how they communicate as well.

On Thu, Feb 27, 2014 at 11:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-02-27 at 10:14 -0500, Tim Nelson wrote:
>> I am currently running a mainline ubuntu 3.13.5 lowlatency kernel with
>> the lastest intel firmware:
>>
>> iwlwifi-7260-ucode-22.15.8.0.tgz
>>
>> Linux nix-tn 3.13.5-031305-lowlatency #201402221823 SMP PREEMPT Sat
>> Feb 22 23:51:31 UTC 2014 i686 i686 i686 GNU/Linux
>>
>> I am unable to connect to the wireless AC radios on my 3702
>> Lightweight AP that is connected to a Cisco 5508 controller.  On the
>> controller, I do see clients hitting the AC radios on the SSID.  I am
>> only connecting to the A/N radio however at 5ghz.
>>
>> Is AC truly supported currently?  I heard the patches for it would be
>> applied in 3.13 but when I do a iwconfig wlan0 I only see:
>> wlan0     IEEE 802.11abgn
>>
>> This leads me to believe that it's not actually supported yet.
>
> 11ac is definitely supported, since long before 3.13 in fact, though
> 11ac TX rates were only added later.
>
>> However, this could be something aesthetic with iwconfig.
>
> It's just the thing iwconfig reads not having been updated in forever...
>
> What kind of problem did you run into? We recently saw this bug pop up
> which might be what you're seeing:
> https://bugzilla.kernel.org/show_bug.cgi?id=70881
> There's a fix for that on the way.
>
> johannes
>
