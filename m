Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35820 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbeCHPza (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:55:30 -0500
Received: by mail-wr0-f194.google.com with SMTP id l43so6176993wrc.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2018 07:55:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5AA114A9.8050801@broadcom.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com> <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
 <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com>
 <5A8FE4D9.80608@broadcom.com> <CAD8Lp44Q0=jS0gqnt1mMfjRe6sTx3Z7n9=iGvk3VFGK2549V7g@mail.gmail.com>
 <5AA114A9.8050801@broadcom.com>
From: Steve deRosier <derosier@gmail.com>
Date: Thu, 8 Mar 2018 07:54:48 -0800
Message-ID: <CALLGbRJU=YV4CC_T9dE8F64=D98d8xiy7HsRcO1T9UdhqWAigw@mail.gmail.com> (sfid-20180308_165534_143047_2BCA0DAA)
Subject: Re: brcmfmac signal/interference issues
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Daniel Drake <drake@endlessm.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2018 at 2:47 AM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/23/2018 2:49 PM, Daniel Drake wrote:
>>
>> On Fri, Feb 23, 2018 at 12:54 PM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>> Yup. Windows firmware talks NDIS. If you run 'strings 4345r6rtecdc.bin |
>>> tail -1' you can see the firmware build target and it likely has 'ndis'
>>> in
>>> it.
>
>
> Hi Daniel,
>
> Bit late response. Sorry.
>
>>
>> 43455c0-roml/sdio-ag-ndis-vista-pktfilter-d0c-pno-aoe-p2p-dhdoid-ndoe-gtkoe-mfp-proptxstatus-dmatxrc-keepalive-ap-ampduretry-pclose-txbf
>>
>> Yes, ndis. So no easy way to run the same firmware on the 2 OSes.
>
>
> Indeed. I could try building nearly same firmware target. Can you provide
> the firmware version as well.
>
> Now reading over your orignal email again:
>
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
>
> So it picks up something in the PC. Some sources of interference that I have
> seen before are USB3 and HDMI. Maybe try to shield those if present and see
> if that helps. The nvram contains sensitivity parameters, but as you stated
> you are using the same nvram for windows and linux for now we can rule it
> out for debugging the issue.
>

Hi Daniel,

I'll jump in here too...

Did you check the Bluetooth?  I don't know if this chip has it or if
it's an independent chip on this board, but if Linux is leaving it
powered up but not properly configured you could have issues. And in
some designs, the BT and WiFi will share a single antenna. Note that
I'm not saying you've configured BT to run, I'm actually suggesting
that the pin that enables it is on, but you might not be loading the
BT drivers and firmware and so the thing is just in a wonky
uninitialized state. Or you do have it enabled and should try turning
it off.  Either way.

And WiFi/BT coex has always been a bit of a problem (speaking
generally, I don't know the status with this particular chip) in
Linux. I see WiFi and BT interfering with each other frequently in my
testing setups with my dev boards. Often I can magically make problems
go away by simply pulling the enable line high (which is "off").

- Steve

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
