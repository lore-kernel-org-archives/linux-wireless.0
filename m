Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38246 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752729AbcKGOGh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Nov 2016 09:06:37 -0500
Message-ID: <58208A6A.5040307@candelatech.com> (sfid-20161107_150640_744640_9403083B)
Date: Mon, 07 Nov 2016 06:06:34 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Antunes <baantunes@gmail.com>
CC: yu-chieh kung <jay0607@gmail.com>,
        Mauro Mozzarelli <openwrt@ezplanet.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [OpenWrt-Devel] ATH10K VLAN firmware issue
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local> <566849DB.9040901@candelatech.com> <079401d132a6$7e7e2050$7b7a60f0$@acksys.fr> <CABUTiXWg3t5qK6O5ooDE+4=Xk3Msybs5mu9+tQm_Bb0wdSrfWQ@mail.gmail.com> <27f802e7-79c5-a17f-1883-88e62a6520ef@ezplanet.net> <CABUTiXUBfHB5RiZ8=ODzrK4-rCBJZ8QqZuZhMK_J7c7haFMEcw@mail.gmail.com> <CAGJdtRCKidEfDF7sc4BRGSfOTmcGJUJ4KZt0xU1vj4bGAnuu1Q@mail.gmail.com> <c58ffbe0-c305-3282-34e9-98814c6f0d14@candelatech.com> <68bd7ebd-b12a-5dbf-a267-5913127718a1@candelatech.com> <CABUTiXXvqQ=yrrK3wp0fck=Mcb0LSrE7_Jw6KisYOuADvo3sdQ@mail.gmail.com>
In-Reply-To: <CABUTiXXvqQ=yrrK3wp0fck=Mcb0LSrE7_Jw6KisYOuADvo3sdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2016 03:54 AM, Bruno Antunes wrote:
> On 4 November 2016 at 22:23, Ben Greear <greearb@candelatech.com> wrote:
>> The bug appears that vlan-tx-stripping is unconditionally enabled in
>> at least my firmware.  I have re-compiled w/out that flag set, and it
>> appears
>> to work for me.
>>
>> Please download this firmware, rename it firmware-2.bin, make sure you
>> remove/rename
>> any firmware-5.bin (etc) so mine will load, and see if that fixes your
>> problem.
>
> Thanks for the fast reply but it only solves "half"  the problem.
>
> Now the connection between the AP and the Sta can be secure and the
> driver doesn't need to be loaded in rawmode.
>
> Unfortunatly the the throughput is still bad.
>
> iperf3 -c 10.10.4.15
> Connecting to host 10.10.4.15, port 5201
> [  4] local 10.10.4.16 port 44893 connected to 10.10.4.15 port 5201
> [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> [  4]   0.00-1.01   sec  42.4 KBytes   345 Kbits/sec    6   1.41 KBytes
> [  4]   1.01-2.01   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> [  4]   2.01-3.01   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> [  4]   3.01-4.01   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  4]   4.01-5.01   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  4]   5.01-6.01   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  4]   6.01-7.01   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> [  4]   7.01-8.01   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  4]   8.01-9.01   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  4]   9.01-10.01  sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-10.01  sec  42.4 KBytes  34.7 Kbits/sec    9             sender
> [  4]   0.00-10.01  sec  0.00 Bytes  0.00 bits/sec                  receiver

You have a complex setup, so I think it would be best if you could break it into
simpler parts to test.

First, try just STA to AP, no vlans, and see if you get useful throughput.

Then try with VLANs

Then, try with WDS.

Then try with WDS and vlans.

In STA to AP mode with VLANs, it performed well for me.

Thanks,
Ben


>
> iperf Done.
>
>>
>> Please note that it is very likely you will have to use same MAC address
>> for the VLAN devices that the underlying station uses in order for this to
>> work.
>
> Can you please elaborate more?
> My setup  is the folowing.
> The connection between the AP and Sta is in WDS
> For the moment all devices are in the same VLAN.
>
> client1 --- SW1 ---- AP ...... Sta ---- SW2 --- client2
>
>
> Thanks,
> Bruno
>
>>
>> https://www.candelatech.com/downloads/tmp/firmware-2-full-community.bin
>>
>>
>> Thanks,
>> Ben
>>
>>
>>
>
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
