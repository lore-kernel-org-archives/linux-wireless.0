Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47732 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1GDUMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 16:12:02 -0400
Received: by iwn6 with SMTP id 6so4679363iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 13:12:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107042202.27366.chunkeey@googlemail.com>
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com>
	<201107042202.27366.chunkeey@googlemail.com>
Date: Mon, 4 Jul 2011 22:11:59 +0200
Message-ID: <CAMJnVwm4Xp87pF7PHLP7vVqF-LYzsgeso7ZPzPwOC_39mwP_Kw@mail.gmail.com> (sfid-20110704_221207_272426_FC5CC3D3)
Subject: Re: carl9170: Problems setting up Virtual Interface
From: Alex <alex9434@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great! I now get an additional interface:
wlan1-wlan0 Link encap:Ethernet  HWaddr <deleted>
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

is this the one? Is the name wlan1-wlan0 that I should use to connect?

BTW: What is the interface?

mon.wlan0 Link encap:UNSPEC  HWaddr <deleted>
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3521 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:585952 (572.2 KiB)  TX bytes:0 (0.0 B)

On Mon, Jul 4, 2011 at 10:02 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday, July 04, 2011 09:46:46 PM Alex wrote:
>
>> I am using the carl9170 interface from the 2.6.39.2 kernel with the
>
>> newest carl9170 firmware. I have set-up an AP with hostapd. Everything
>
>> is working so far:
>
>>
>
>> root@box:~# ifconfig
>
>> mon.wlan0 Link encap:UNSPEC HWaddr <deleted>
>
>> UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
>
>> RX packets:27070 errors:0 dropped:0 overruns:0 frame:0
>
>> TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>
>> collisions:0 txqueuelen:1000
>
>> RX bytes:4583087 (4.3 MiB) TX bytes:0 (0.0 B)
>
>>
>
>> wlan0 Link encap:Ethernet HWaddr <deleted>
>
>> inet addr:192.168.80.1 Bcast:192.168.80.255 Mask:255.255.255.0
>
>> inet6 addr: fe80::76ea:3aff:fe8f:130c/64 Scope:Link
>
>> UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
>
>> RX packets:320 errors:0 dropped:1 overruns:0 frame:0
>
>> TX packets:231 errors:0 dropped:0 overruns:0 carrier:0
>
>> collisions:0 txqueuelen:1000
>
>> RX bytes:28815 (28.1 KiB) TX bytes:26887 (26.2 KiB)
>
>>
>
>> I am now trying to create an additional virtual intereface to connect
>
>> wireless to my router as described on:
>
>>
>
>> http://linuxwireless.org/en/users/Documentation/iw/vif/
>
>>
>
>> with
>
>> iw dev wlan0 interface add wlan1 type station
>
>>
>
>> However, ifconfig does not list the additional wlan1 interface.
>
> The virtual interface might not be listed because it can't be
>
> brought up since it shares the same mac with the main interface.
>
> so try "ifconfig -a" ?
>
> Regards,
>
> Chr
