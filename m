Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34844 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdATLiB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 06:38:01 -0500
Received: by mail-pg0-f42.google.com with SMTP id 194so23193541pgd.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 03:38:01 -0800 (PST)
Subject: Re: [PATCH RFC 2/2] brcmfmac: add brcmf_err_pub macro for better
 error messages
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170118142703.9824-1-zajec5@gmail.com>
 <20170118142703.9824-2-zajec5@gmail.com>
 <8819000f-f70f-e8b3-ca52-eebf10a431ac@broadcom.com>
 <e67a5583-8a1b-b370-5dcb-8717197542fb@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <668216db-8834-02e6-1b7c-9fbd05eeaf68@broadcom.com> (sfid-20170120_123805_115249_28759A46)
Date: Fri, 20 Jan 2017 12:37:54 +0100
MIME-Version: 1.0
In-Reply-To: <e67a5583-8a1b-b370-5dcb-8717197542fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-1-2017 12:17, Rafał Miłecki wrote:
> On 01/20/2017 11:26 AM, Arend Van Spriel wrote:
>> On 18-1-2017 15:27, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This macro accepts an extra argument of struct brcmf_pub pointer. It
>>> allows referencing struct device and printing error using dev_err. This
>>> is very useful on devices with more than one wireless card suppored by
>>> brcmfmac. Thanks for dev_err it's possible to identify device that error
>>> is related to.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>> I could convert few more brcmf_err calls to this new brcmf_err_pub
>>> but I don't
>>> want to spent too much time on this in case someone has a better idea.
>>>
>>> If you do, comment! :)
>>
>> I do not, but still comment ;-). Like the idea. Was on our list because
>> it is damn convenient when testing on router with multiple devices. I
>> would prefer to replace the existing brcmf_err() rather than introducing
>> a new one and would like to do the same for brcmf_dbg(). However, not
>> all call sites have a struct brcmf_pub instance available. Everywhere
>> before completing brcmf_attach() that is.
> 
> I decided to try new macro because:
> 1) I was too lazy to convert all calls at once
> 2) I could stick to brcmf_err when struct brcmf_pub isn't available yet
> 
> In theory we could pass NULL to dev_err, I'd result in something like:
> [   14.746754] (NULL device *): brcmf_c_preinit_dcmds: Firmware version
> = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
> 
> Unfortunately AFAIK it's not possible to handle
> brcmf_err(NULL "Foo\n");
> calls while keeping brcmf_err a macro.
> 
> I was thinking about something like:
> #define brcmf_err(pub, fmt, ...)                    \
>     do {                                \
>         if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())    \
>             dev_err(pub ? pub->bus_if->dev : NULL,        \
>                 "%s: " fmt, __func__,            \
>                 ##__VA_ARGS__);                \
>     } while (0)
> 
> but this wouldn't compile because for brcmf_err(NULL "Foo\n"); it would
> roll
> out to:
> dev_err(NULL ? NULL->bus_if->dev : NULL, "Foo\n");
> 
> I *can* support brcmf_err(NULL "Foo\n"); calls if I change brcmf_err from
> macro to a function (inline probably). Do you think it's a good idea?

I was wondering if brcmf_err(ptr, "bla\n") could determine the pointer
type and accept 'struct device *' and 'struct brcmf_pub *'. I think we
always have a struct device pointer. Only in brcmf_module_init() we do not.

Regards,
Arend
