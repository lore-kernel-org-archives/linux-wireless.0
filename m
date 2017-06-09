Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33901 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdFIKe1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 06:34:27 -0400
Received: by mail-wr0-f170.google.com with SMTP id g76so28560140wrd.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 03:34:26 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
 <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
 <1495099355.2553.1.camel@sipsolutions.net>
 <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
 <1495104012.2553.3.camel@sipsolutions.net>
 <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
 <1495189263.3274.4.camel@sipsolutions.net>
 <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com>
 <1495448886.2653.12.camel@sipsolutions.net>
 <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com>
 <1496050303.2467.3.camel@sipsolutions.net>
 <d41f58e9-b12e-9e52-a0fb-b674d278353b@broadcom.com>
 <1496999284.2424.7.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <92d6d845-acd1-078a-9121-ba6eb22fd6fd@broadcom.com> (sfid-20170609_123431_615241_49AA2CAA)
Date: Fri, 9 Jun 2017 12:34:23 +0200
MIME-Version: 1.0
In-Reply-To: <1496999284.2424.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 6/9/2017 11:08 AM, Johannes Berg wrote:
> Hi Arend,
> 
> Sorry about the delay.

No problem.

>>> Then you have to support NEW_KEY (AP case) and then using NEW_KEY
>>> to
>>> detect whether or not a wpa_s configuration option to not use
>>> offloaded
>>> 4-way-HS can be used will not work correctly.
>>>
>>> I don't really see that this is a sensible configuration, but I
>>> could
>>> imagine it existing if somebody "bolted on" AP functionality for a
>>> client-side chipset or something like that.
> 
>> So I want to get back to this as to assure we have the same
>> understanding. First off, the proposed offloads are STA-only.
> 
> Right. But we at least also want to have them for AP mode, which
> answers your below question.
> 
>> So if a
>> driver supports STA and AP mode and the 4-way-HS offload, we could
>> already have the case you describe here. So not really a "bolted on"
>> scenario I would say.
> 
> But if you say you don't have it in AP mode, or you didn't even think
> about it in AP mode yet, then I think you're right and the "bolted on"
> part doesn't really apply (*).

yup.

> However, this does mean that checking for NEW_KEY support _isn't_
> sufficient to understand whether or not the device also supports doing
> the 4-way-HS in the host, because the device might _not_ support that
> in client mode, yet implement NEW_KEY for AP mode, right?

Indeed. I did not state it explicitly, but that is also my understanding 
so not going to do that.

> In any case - I don't think this changes much my opinion. I think that
> newer wpa_s should always use the offload where available, and if
> there's a debug option to turn that off, and that debug option causes
> failures because the driver rejects the NEW_KEY command, rather than
> causing an up-front configuration failure because wpa_s knows that the
> NEW_KEY wouldn't be supported, then I don't think for a debug option
> that makes a big difference. For something that higher layers might
> need to set, it would make a difference - but that's not at stake here.

Not trying to change your opinion ;-). Just getting it all clear. As a 
matter of fact I already have my wpa_s use the offload without any 
debug/config option. As brcmfmac can use override to disable firmware 
features I also do not need such in wpa_s.

> (*) my line of thinking was that if you have the necessary state
> machine for client in the firmware, then it's not a huge step to also
> have it for AP, since you have the crypto primitives for it

Agree. However, in our firmware they are two modules that can be 
compiled in, ie. idsup and idauth.

Regards,
Arend
