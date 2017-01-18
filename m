Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:34876 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbdARJm4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 04:42:56 -0500
Received: by mail-pg0-f47.google.com with SMTP id 194so3385878pgd.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 01:42:55 -0800 (PST)
Subject: Re: [PATCH 2/2] brcmfmac: move function declarations to proper
 headers
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170117163419.1184-1-zajec5@gmail.com>
 <20170117163419.1184-2-zajec5@gmail.com>
 <d1aca4b7-3493-5935-befb-af1b2dadc7d1@broadcom.com>
 <CACna6rz9_vxEvDs7OoWALxat0XSEW3E4V0idrjZWAbiSmQvRAw@mail.gmail.com>
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
Message-ID: <499ca32f-1d71-8aa0-d9c2-be2383583a63@broadcom.com> (sfid-20170118_104327_658005_C94A6E33)
Date: Wed, 18 Jan 2017 10:35:48 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rz9_vxEvDs7OoWALxat0XSEW3E4V0idrjZWAbiSmQvRAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-1-2017 10:06, Rafał Miłecki wrote:
> On 18 January 2017 at 09:58, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 17-1-2017 17:34, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> Function brcmf_c_set_joinpref_default is in common.c, so move it to the
>>> related header. All other (touched) ones are in core.c so take them out
>>> of the bus.h.
>>> I just needed to include bus.h to have enum brcmf_bus_state defined.
>>
>> I prefer to keep the bus api in separate include file so please leave
>> those. That leaves the move of brcmf_c_set_joinpref_default(). Please
>> send a v2 and consider it acked by me.
> 
> Oh, I just realized there isn't bus.c! Would that make sense to move
> these functions from core.c to new bus.c then?

I have no strong opinion about it. Right now it seems a bit overzealous,
but I have been considering adding counters/statistics on bus layer so
the amount of code may justify a separate source file.

Regards,
Arend
