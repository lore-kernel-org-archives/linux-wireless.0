Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:33566 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbdILPEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 11:04:53 -0400
Received: by mail-yw0-f171.google.com with SMTP id s62so28854893ywg.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 08:04:53 -0700 (PDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com. [209.85.223.172])
        by smtp.gmail.com with ESMTPSA id m76sm3994911ywd.10.2017.09.12.08.04.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Sep 2017 08:04:51 -0700 (PDT)
Received: by mail-io0-f172.google.com with SMTP id v36so35990192ioi.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 08:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0960e44e-baa7-ac36-4906-cb2d0a39ac3e@broadcom.com>
References: <20170908191342.28053-1-cernekee@chromium.org> <20170908191342.28053-4-cernekee@chromium.org>
 <CAKUbbx+=VpRC0nek=431yxjooun56hb6svSwRjH_faBhdEPf=g@mail.gmail.com> <0960e44e-baa7-ac36-4906-cb2d0a39ac3e@broadcom.com>
From: Kevin Cernekee <cernekee@chromium.org>
Date: Tue, 12 Sep 2017 08:04:30 -0700
Message-ID: <CAJzqFta2+4=AKFPRkzi=da2hsYo3RxDXzUmv7eU9VS-416VK-A@mail.gmail.com> (sfid-20170912_170457_005951_657B3CB0)
Subject: Re: [PATCH 3/3] brcmfmac: Add check for short event packets
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Mattias Nissler <mnissler@chromium.org>,
        Franky Lin <franky.lin@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 11, 2017 at 12:09 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>> index 5aabdc9ed7e0..4cad1f0d2a82 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>>> @@ -429,7 +429,8 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
>>>          if (code != BRCMF_E_IF && !fweh->evt_handler[code])
>>>                  return;
>>>
>>> -       if (datalen > BRCMF_DCMD_MAXLEN)
>>> +       if (datalen > BRCMF_DCMD_MAXLEN ||
>>> +           datalen + sizeof(*event_packet) < packet_len)
>>
>>
>> Shouldn't this check be larger-than, i.e. we need the packet to be at
>> least sizeof(*event_packet) + its payload size?
>
> That depends on how you formulate the requirement. packet_len here is the
> length for the received skbuff. The event message (= sizeof(*event_packet))
> and its variable payload (= datalen) shall not exceed length of received
> skbuff (= packet_len).

Or should it be an exact match, i.e. datalen + sizeof(*event_packet)
!= packet_len

What did Franky's version of the check look like?

If Broadcom has a test suite that tries different event types and
notices if events are getting unexpectedly dropped, that would be
helpful in validating the change.  I would be wary of pushing this to
-stable until we know the check is 100% correct.
