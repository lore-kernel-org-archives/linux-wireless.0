Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:53825 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754768AbeDCH2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:28:46 -0400
Received: by mail-wm0-f50.google.com with SMTP id p9so30890618wmc.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 00:28:46 -0700 (PDT)
Subject: Re: brcmfmac signal/interference issues
To: Daniel Drake <drake@endlessm.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com>
 <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
 <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com>
 <5A8FE4D9.80608@broadcom.com>
 <CAD8Lp44Q0=jS0gqnt1mMfjRe6sTx3Z7n9=iGvk3VFGK2549V7g@mail.gmail.com>
 <5AA114A9.8050801@broadcom.com>
 <CAD8Lp4713vwqFXiYK5fD+h_rTnMQCy-uCX54qn1m1+3o-+892g@mail.gmail.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, Wright Feng <wright.feng@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC32D2E.8070601@broadcom.com> (sfid-20180403_092850_894406_5439BEDC)
Date: Tue, 3 Apr 2018 09:28:46 +0200
MIME-Version: 1.0
In-Reply-To: <CAD8Lp4713vwqFXiYK5fD+h_rTnMQCy-uCX54qn1m1+3o-+892g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/28/2018 8:43 PM, Daniel Drake wrote:
> On Thu, Mar 8, 2018 at 4:47 AM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>> 43455c0-roml/sdio-ag-ndis-vista-pktfilter-d0c-pno-aoe-p2p-dhdoid-ndoe-gtkoe-mfp-proptxstatus-dmatxrc-keepalive-ap-ampduretry-pclose-txbf
>>>
>>> Yes, ndis. So no easy way to run the same firmware on the 2 OSes.
>>
>> Indeed. I could try building nearly same firmware target. Can you provide
>> the firmware version as well.
>
> Full string is:
> 43455c0-roml/sdio-ag-ndis-vista-pktfilter-d0c-pno-aoe-p2p-dhdoid-ndoe-gtkoe-mfp-proptxstatus-dmatxrc-keepalive-ap-ampduretry-pclose-txbf
> Version: 7.45.87.0 CRC: 7cb2470e Date: Thu 2016-04-21 22:31:44 PDT
> Ucode Ver: 1043.2070 FWID: 01-f68ec182
>
> If you could build that config but for Linux instead of ndis I would
> love to try it.
>
> Also, here is the string for the current one in linux-firmware:
> 43455c0-roml/sdio-ag-p2p-pno-aoe-pktfilter-keepalive-mchan-pktctx-proptxstatus-ampduhostreorder-lpc-pwropt-txbf-wnm-okc-ccx-ltecx-wfds-wl11u-mfp-tdls-ve
> Version: 7.45.18.0 CRC: d7226371 Date: Sun 2015-03-01 07:31:57 PST
> Ucode Ver: 1026.2 FWID: 01-6a2c8ad4
>
> I note that the Version and UcodeVer in the linux-firmware version are
> lower than the windows one. If it's possible to also rebuild the
> linux-firmware config but with those newer versions (or even the
> latest, if there is something newer), I will test that too.

Thanks for the version info. I will look if we could use similar version 
as window version, but typically they spin from different branches.

>> So it picks up something in the PC. Some sources of interference that I have
>> seen before are USB3 and HDMI. Maybe try to shield those if present and see
>> if that helps. The nvram contains sensitivity parameters, but as you stated
>> you are using the same nvram for windows and linux for now we can rule it
>> out for debugging the issue.
>
> Yeah, there are some options here which we can try to explore. What's
> still unknown though is why windows appears immune to this exact same
> interference. A software fix would be much more convenient... :)

Obviously ;-) And the immunity seems to justify that path.

Regards,
Arend
