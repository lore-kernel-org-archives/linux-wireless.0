Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36098 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753249AbeBUJjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 04:39:45 -0500
Received: by mail-ot0-f196.google.com with SMTP id b15so867754otf.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 01:39:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A8D36B7.1010201@broadcom.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com>
From: Daniel Drake <drake@endlessm.com>
Date: Wed, 21 Feb 2018 12:39:43 +0300
Message-ID: <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com> (sfid-20180221_103950_216120_1B0F1ED6)
Subject: Re: brcmfmac signal/interference issues
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Wed, Feb 21, 2018 at 12:07 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On 2/21/2018 9:14 AM, Daniel Drake wrote:
>>
>> Hi,
>>
>> We're working with the Weibu F3C MiniPC which includes BCM43455 SDIO
>> wifi chip 0x004345(17221) rev 0x000006 (AP6255 module).
>>
>> We are seeing a strange issue where usually within an hour of usage,
>> the wifi connection becomes so unstable and lossy that it is unusable.
>> While investigating this my standard test is to send ICMP pings to the
>> IP address of the local access point. Normally the latency is 5-10ms,
>> but when this problem is seen it will go to 500ms and then increase up
>> towards 20s before completely timing out.
>>
>> Sometimes it is possible to induce the problem on-demand by stressing
>> some combination of CPU, disk and/or USB. At this point, ping reply
>> latency increases from ~5ms to 500ms+ before increasing even further.
>> Killing the stress test, the pings immediately return to normal. This
>> is not concrete though - I also seem to have a lot of luck hitting the
>> problem in the morning when booting up the computer from stone cold
>> state, while it is idle.
>>
>> When the problem is being reproduced (ping times are high or get no
>> response), touching the exposed metal on the antenna connector with my
>> finger makes ping times return to normal. Touching it with a piece of
>> plastic does not have the same effect - so it is some effect of body
>> capacitance or similar. Also, disconnecting the antenna makes ping
>> times return to normal, although outside of the simple pings,
>> bandwidth is much reduced.
>>
>> Additionally, when the problem is being reproduced, if I move the
>> antenna outside of the case, ping times return to normal. When I move
>> the antenna back into the miniPC case vicinity, it goes slow and lossy
>> again.
>>
>> I have used a separate monitoring station with wireshark to look at
>> the 802.11 traffic while this is happening. When the problem is
>> reproduced, the miniPC is mostly unable to TX anything, and the AP
>> sends frames and retries them but with no ACK visible from the miniPC.
>> Immediately when I touch the antenna connector with my finger, tx
>> frames from the miniPC appear and the conversation comes back to life.
>>
>> Running Linux 4.15 but we believe all versions are affected.
>>
>> This very much sounds like a hardware issue, but here is where things
>> get interesting: Windows 10 on the same unit has no such problem.
>>
>> I set up 2 units side by side - one running Windows 10 and the other
>> running Linux, connected to the same AP. The top part of the MiniPC
>> case has been removed so I can see the motherboard. I free up the
>> antennas from the MiniPC casing and they are on a relatively long
>> cable, so they can be freely moved around in this test, allowing me to
>> dangle the antenna into the vicinity of the neighbouring unit miniPC
>> case.
>>
>> If I place both antenna terminals inside the Linux MiniPC case, the
>> Linux pings are bad but the Windows pings are fine.
>>
>> If I place both antenna terminals inside the Windows MiniPC case, it
>> is the same: Linux pings are bad, but the Windows pings are fine.
>>
>> And when the Linux antenna is placed outside of both cases, the Linux
>> pings are fine. I've repeated these tests a handful of times in quick
>> succession to make sure that I'm not going crazy and that this is not
>> a case of the problem intermittency causing misleading results. These
>> findings appear very solid.
>>
>> This suggests that regardless of the running OS, the MiniPC produces
>> some kind of interference that intermittently has an extremely
>> detrimental effect on wifi signal when you are running Linux. However,
>> Windows is somehow immune to this.
>>
>> Any ideas for how to continue debugging this? How can we make the
>> Linux driver immune to this interference like the windows one is?
>
>
> Hi Daniel,
>
> Thanks. I forwarded your detailed report. My first hunch would be the nvram file used. Are you using the same nvram file on Linux as the one on Windows? If not can you compare them or better just sent them.


Thanks for looking into this. Here is the brcmfmac43455-sdio.txt file
we are using:
https://gist.github.com/dsd/d7ee3caa6dfd77f0bcd16cf272b20298
This is identical to the 4345r6nvram.txt file from windows.

Daniel
