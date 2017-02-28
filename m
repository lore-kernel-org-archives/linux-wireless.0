Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35462 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdB1K0z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 05:26:55 -0500
Received: by mail-lf0-f52.google.com with SMTP id z127so3528736lfa.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 02:25:21 -0800 (PST)
Subject: Re: [PATCH 4.12] brcmfmac: get rid of brcmf_txflowblock helper
 function
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170227120606.15506-1-zajec5@gmail.com>
 <89be1d04-640e-bd59-77d9-13ddde9979bb@broadcom.com>
 <CACna6rycudavYsCnbTVtDb+w8SvXvXJo7qyx9oW9xNCY2AtqNw@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c216ad04-8443-7606-04ce-50de678d9392@broadcom.com> (sfid-20170228_112659_957138_3BF39228)
Date: Tue, 28 Feb 2017 11:16:44 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rycudavYsCnbTVtDb+w8SvXvXJo7qyx9oW9xNCY2AtqNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-2-2017 11:00, Rafał Miłecki wrote:
> On 28 February 2017 at 10:50, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 27-2-2017 13:06, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This helper function is pretty trivial and we can easily do without it.
>>> What's important though it's one of FWS (Firmware Signalling)
>>> dependencies in core.c. The plan is to make FWS required by BCDC only so
>>> we don't have to use/compile it when using msgbuf.
>>
>> This is the same discussion as before. Our driver design really wants to
>> keep bus-specific code separated from common code. Adding more and more
>> include statements is breaking that design. Whether or not that
>> resembles the way other drivers do it is not really a consideration. So
>> I would rather like to see patches that improve that separation.
>>
>> I will see if I can publish the design summary on our wiki page.
> 
> You may not like this solution, but if so, please suggest another one.
> Then we can discuss two of them & find a final one.
> 
> As you see I'm trying to drop fws dependency from core.c. It's what
> was very roughly discussed in:
> brcmfmac: initialize fws(ignal) for BCDC protocol only
> https://patchwork.kernel.org/patch/9349301/
> 
> My guess if you have another patch for this, but since you didn't
> manage to release it since September, I'd really like to move things
> forward somehow.

Franky has taken it on his shoulders, but it seems to have slipped under
the rug. Maybe he can chime in.

Regards,
Arend
