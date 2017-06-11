Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34584 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbdFKIIu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Jun 2017 04:08:50 -0400
Received: by mail-wr0-f180.google.com with SMTP id g76so67535053wrd.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jun 2017 01:08:50 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
To: Peter Housel <housel@acm.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Christian Daudt <csd@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <CA+8PC_e8HdkBw4DfGUPO0BbM-W5wftK=i6_vjwFTmS7=axyFUw@mail.gmail.com>
 <1496442569-11307-1-git-send-email-housel@acm.org>
 <CAHp75VcfK5V42vzsh=L+CnX2ZnF=8UORbOf+f2WfmcNH1DbAsw@mail.gmail.com>
 <801f5209-f5a0-7414-f8f4-1500178a680b@broadcom.com>
 <705684CB-D155-45DC-8146-157A536F9FBA@acm.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c4eeec0f-720d-76de-b6d9-68c882450f6f@broadcom.com> (sfid-20170611_100939_255346_837CD8AE)
Date: Sun, 11 Jun 2017 10:08:47 +0200
MIME-Version: 1.0
In-Reply-To: <705684CB-D155-45DC-8146-157A536F9FBA@acm.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-06-17 02:18, Peter Housel wrote:
> 
>> On Jun 10, 2017, at 12:27 PM, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>>
>> On 03-06-17 17:36, Andy Shevchenko wrote:
>>> On Sat, Jun 3, 2017 at 1:29 AM, Peter S. Housel <housel@acm.org> wrote:
>>>> An earlier change to this function (3bdae810721b) fixed a leak in the
>>>> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
>>>> glom_skb buffer, used for emulating a scattering read, is never used
>>>> or referenced after its contents are copied into the destination
>>>> buffers, and therefore always needs to be freed by the end of the
>>>> function.
>>
>> [snip]
>>
>>>> +                       skb_queue_walk(pktq, skb) {
>>>> +                               memcpy(skb->data, glom_skb->data, skb->len);
>>>> +                               skb_pull(glom_skb, skb->len);
>>>> +                       }
>>>>                }
>>>
>>>> +               brcmu_pkt_buf_free_skb(glom_skb);
>>>
>>> Can we just add this one line instead or I'm missing something?
>>
>> I guess. We don't want to walk the packet queue if glom_skb is not
>> carrying data due to brcmf_sdiod_buffrw() failure.
>>
>> So I would go with the patch below as brcmu_pkt_buf_free_skb() simply
>> ignores null pointer.
> 
> I’m fine with this, or indeed most of the other proposed solutions. The important thing is that the leak is fixed; in the driver's current state I was able to run our wearable device out of memory in just over 20 seconds running iperf.

Sure. The reason behind the suggestion from Franky was to get rid of the
label inside branch and I agree with that. To address Andy's comment I
think my proposal should tackle that.

Just out of curiosity, we added the broken-sg-support thing for OMAP
platform. So what platform/mmc-host are you using. I try to keep an
overview where this workaround is needed.

Regards,
Arend
