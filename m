Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36243 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934096AbeFVS7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:59:41 -0400
Received: by mail-qt0-f180.google.com with SMTP id o9-v6so6845040qtp.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2018 11:59:40 -0700 (PDT)
Subject: Re: [PATCH V3 0/2] brcmfmac: initial work for adding monitor mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180619154809.25698-1-zajec5@gmail.com>
 <5B2960FD.9010604@broadcom.com> <779e159dc406dc16b004798756f6ee23@milecki.pl>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B2D4717.4000509@broadcom.com> (sfid-20180622_205945_493022_5054BA80)
Date: Fri, 22 Jun 2018 20:59:35 +0200
MIME-Version: 1.0
In-Reply-To: <779e159dc406dc16b004798756f6ee23@milecki.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 10:25 PM, Rafał Miłecki wrote:
> On 2018-06-19 22:01, Arend van Spriel wrote:
>> On 6/19/2018 5:48 PM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> After a bit long discussions in various e-mail threads I'm coming with
>>> this simple & small patchset. It isn't complete support for monitor mode
>>> but just a pair of preparing patches that should be clear & well
>>> discussed by now to make them acceptable.
>>>
>>> The main missing bit is code setting MONITOR_FMT_RADIOTAP which I expect
>>> Arend to handle soon, as he already has a patch using "sta_monitor"
>>> iovar for that. Then we have to discuss a flag for marking firmwares
>>> which are capable for tagging monitor frames.
>>>
>>> While still incomplete, I believe that with my previous patches, we can
>>> agree this is a good direction.
>>>
>>> Arend: if you find these 2 patches OK, could you ack them, to make it
>>> clear for Kalle if they look OK now (or not yet)? I'd be great if you
>>> could sent your "sta_monitor" work on top of this.
>>
>> I acked them and I will submit my changes later. Either after these
>> are applied or simply indicate the dependency.
>>
>> Now as for where we are with this. With what we have here we know
>> firmware can monitor packets with and without radiotap. However, we do
>> not have an indication whether firmware can transport these monitor
>> packets to the host. What I need to look into next is whether the
>> 802.11 flag in msgbuf is linked to a particular version of the
>> protocol, but we may need to resort to the fwid table.
>
> Being able to detect if firmware tags monitor packets would be great.

The 802.11 tag as opposed the 802.3 tag is specified in the PCIe host 
interface spec. The brcmfmac driver support rev 5 and 6 of that spec and 
both specify the tags. I did some digging and I believe it is safe to 
say that firmware that includes the "monitor" tag in the "cap" iovar 
does support these packets tags as well. Unfortunately, the 
BRCMF_C_MONITOR command support does not guarantee. So I just sent a 
patch to remove the fall-back mechanism for detecting monitor mode support.

Regards,
Arend
