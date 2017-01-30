Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34489 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751822AbdA3Q4X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 11:56:23 -0500
Received: by mail-qk0-f171.google.com with SMTP id l126so2647921qkc.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 08:56:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87lgtsjz6o.fsf@toke.dk>
References: <HE1PR0701MB1803E46BC8EC38D682361523FC4B0@HE1PR0701MB1803.eurprd07.prod.outlook.com>
 <87lgtsjz6o.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 30 Jan 2017 08:49:30 -0800
Message-ID: <CAA93jw5w6MaegbE+n9=-+F59vXTjEFGOH94Q=XYxiAqFKHeVfw@mail.gmail.com> (sfid-20170130_175927_292910_977A55AD)
Subject: Re: Packet throughput (and those iperf data rate) with mac80211/ath9k
 is 20% worse than net80211/madwifi
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Klaus Kinski <jpo234@outlook.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2017 at 8:17 AM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@tok=
e.dk> wrote:
> Klaus Kinski <jpo234-1ViLX0X+lBKELgA04lAiVw@public.gmane.org> writes:
>
>> Hello all,
>>
>> this is a blast from the past, but something that still bothers me.
>> I have two systems with Atheros/QCA cards:
>>
>> System A:
>>   OS and driver: Linux 3.18.36 with last Madwifi/sample code from trunk
>>
>>   WLAN card: AR5413 (Senao EMP-8602 PLUS-S)
>>
>> System B:
>>   OS and driver: Linux 3.18.36 with mac80211/minstrel and ath9k from bac=
kports-4.2
>>
>>   WLAN card: AR9280 (Compex WLE200NX)
>>
>> While doing the performance measurements both systems are connected to a=
 reference system
>>
>> with a HF cable, so there should be no outside influences.
>>
>> Both systems are running in 802.11a mode on channel 40.
>> The following table shows 802.11 data packets sent from system A and B g=
enerated by
>>
>> iperf in UDP mode over a 2s interval:
>
> What version of iperf, and configured to which rate? Some versions of
> iperf will send its traffic in very large bursts (see
> http://burntchrome.blogspot.se/2016/09/iperf3-and-microbursts.html?m=3D1)
> which could cause the queue inside ath9k to overflow (it is only 123
> packets pre-4.10).
>
> Did you try the latest mac80211/ath9k from 4.10? The queueing structure
> changed dramatically, which would impact this, at least if it's a queue
> overflow problem...

Packet captures would be helpful. Aircaps, if possible, also.

> -Toke



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
