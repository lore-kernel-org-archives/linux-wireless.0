Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:46213 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdIKTJg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Sep 2017 15:09:36 -0400
Received: by mail-wm0-f47.google.com with SMTP id i189so47040138wmf.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Sep 2017 12:09:35 -0700 (PDT)
Subject: Re: [PATCH 3/3] brcmfmac: Add check for short event packets
To: Mattias Nissler <mnissler@chromium.org>,
        Kevin Cernekee <cernekee@chromium.org>
Cc: franky.lin@broadcom.com, brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org
References: <20170908191342.28053-1-cernekee@chromium.org>
 <20170908191342.28053-4-cernekee@chromium.org>
 <CAKUbbx+=VpRC0nek=431yxjooun56hb6svSwRjH_faBhdEPf=g@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0960e44e-baa7-ac36-4906-cb2d0a39ac3e@broadcom.com> (sfid-20170911_210939_920329_39A12ED8)
Date: Mon, 11 Sep 2017 21:09:32 +0200
MIME-Version: 1.0
In-Reply-To: <CAKUbbx+=VpRC0nek=431yxjooun56hb6svSwRjH_faBhdEPf=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-09-17 11:19, Mattias Nissler wrote:
> On Fri, Sep 8, 2017 at 9:13 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
>>
>> The length of the data in the received skb is currently passed into
>> brcmf_fweh_process_event() as packet_len, but this value is not checked.
>> event_packet should be followed by DATALEN bytes of additional event
>> data.  Ensure that the received packet actually contains at least
>> DATALEN bytes of additional data, to avoid copying uninitialized memory
>> into event->data.
>>
>> Suggested-by: Mattias Nissler <mnissler@chromium.org>
>> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>> index 5aabdc9ed7e0..4cad1f0d2a82 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
>> @@ -429,7 +429,8 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
>>          if (code != BRCMF_E_IF && !fweh->evt_handler[code])
>>                  return;
>>
>> -       if (datalen > BRCMF_DCMD_MAXLEN)
>> +       if (datalen > BRCMF_DCMD_MAXLEN ||
>> +           datalen + sizeof(*event_packet) < packet_len)
> 
> Shouldn't this check be larger-than, i.e. we need the packet to be at
> least sizeof(*event_packet) + its payload size?

That depends on how you formulate the requirement. packet_len here is 
the length for the received skbuff. The event message (= 
sizeof(*event_packet)) and its variable payload (= datalen) shall not 
exceed length of received skbuff (= packet_len).

Regards,
Arend
