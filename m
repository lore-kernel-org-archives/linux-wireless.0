Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:43666 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdILTQr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 15:16:47 -0400
Received: by mail-wm0-f51.google.com with SMTP id a137so2149885wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 12:16:47 -0700 (PDT)
Subject: Re: [PATCH 3/3] brcmfmac: Add check for short event packets
To: Kevin Cernekee <cernekee@chromium.org>
Cc: Mattias Nissler <mnissler@chromium.org>,
        Franky Lin <franky.lin@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org
References: <20170908191342.28053-1-cernekee@chromium.org>
 <20170908191342.28053-4-cernekee@chromium.org>
 <CAKUbbx+=VpRC0nek=431yxjooun56hb6svSwRjH_faBhdEPf=g@mail.gmail.com>
 <0960e44e-baa7-ac36-4906-cb2d0a39ac3e@broadcom.com>
 <CAJzqFta2+4=AKFPRkzi=da2hsYo3RxDXzUmv7eU9VS-416VK-A@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <370e7851-f57b-4cf8-51b0-1746a74415fe@broadcom.com> (sfid-20170912_211651_381998_EF45F78E)
Date: Tue, 12 Sep 2017 21:16:42 +0200
MIME-Version: 1.0
In-Reply-To: <CAJzqFta2+4=AKFPRkzi=da2hsYo3RxDXzUmv7eU9VS-416VK-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-09-17 17:04, Kevin Cernekee wrote:
> On Mon, Sep 11, 2017 at 12:09 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>>> index 5aabdc9ed7e0..4cad1f0d2a82 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>>> @@ -429,7 +429,8 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
>>>>           if (code != BRCMF_E_IF && !fweh->evt_handler[code])
>>>>                   return;
>>>>
>>>> -       if (datalen > BRCMF_DCMD_MAXLEN)
>>>> +       if (datalen > BRCMF_DCMD_MAXLEN ||
>>>> +           datalen + sizeof(*event_packet) < packet_len)
>>>
>>>
>>> Shouldn't this check be larger-than, i.e. we need the packet to be at
>>> least sizeof(*event_packet) + its payload size?
>>
>> That depends on how you formulate the requirement. packet_len here is the
>> length for the received skbuff. The event message (= sizeof(*event_packet))
>> and its variable payload (= datalen) shall not exceed length of received
>> skbuff (= packet_len).
> 
> Or should it be an exact match, i.e. datalen + sizeof(*event_packet)
> != packet_len

Checking for exact match might not work, because the skbuff length could 
differ because of host interface alignment requirements.

> What did Franky's version of the check look like?

the check Franky had was:

	datalen > packet_len - sizeof(*event_packet)

> If Broadcom has a test suite that tries different event types and
> notices if events are getting unexpectedly dropped, that would be
> helpful in validating the change.  I would be wary of pushing this to
> -stable until we know the check is 100% correct.

Agree. I quickly browsed through our collection of tests in our test 
framework, but found none covering this.

Regards,
Arend
