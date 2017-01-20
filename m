Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36414 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbdATL0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 06:26:52 -0500
Received: by mail-lf0-f65.google.com with SMTP id h65so8237191lfi.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 03:26:52 -0800 (PST)
Subject: Re: [PATCH RFC 2/2] brcmfmac: add brcmf_err_pub macro for better
 error messages
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170118142703.9824-1-zajec5@gmail.com>
 <20170118142703.9824-2-zajec5@gmail.com>
 <8819000f-f70f-e8b3-ca52-eebf10a431ac@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <e67a5583-8a1b-b370-5dcb-8717197542fb@gmail.com> (sfid-20170120_122656_822893_C0E1E180)
Date: Fri, 20 Jan 2017 12:17:47 +0100
MIME-Version: 1.0
In-Reply-To: <8819000f-f70f-e8b3-ca52-eebf10a431ac@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2017 11:26 AM, Arend Van Spriel wrote:
> On 18-1-2017 15:27, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> This macro accepts an extra argument of struct brcmf_pub pointer. It
>> allows referencing struct device and printing error using dev_err. This
>> is very useful on devices with more than one wireless card suppored by
>> brcmfmac. Thanks for dev_err it's possible to identify device that error
>> is related to.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>> I could convert few more brcmf_err calls to this new brcmf_err_pub but I don't
>> want to spent too much time on this in case someone has a better idea.
>>
>> If you do, comment! :)
>
> I do not, but still comment ;-). Like the idea. Was on our list because
> it is damn convenient when testing on router with multiple devices. I
> would prefer to replace the existing brcmf_err() rather than introducing
> a new one and would like to do the same for brcmf_dbg(). However, not
> all call sites have a struct brcmf_pub instance available. Everywhere
> before completing brcmf_attach() that is.

I decided to try new macro because:
1) I was too lazy to convert all calls at once
2) I could stick to brcmf_err when struct brcmf_pub isn't available yet

In theory we could pass NULL to dev_err, I'd result in something like:
[   14.746754] (NULL device *): brcmf_c_preinit_dcmds: Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269

Unfortunately AFAIK it's not possible to handle
brcmf_err(NULL "Foo\n");
calls while keeping brcmf_err a macro.

I was thinking about something like:
#define brcmf_err(pub, fmt, ...)					\
	do {								\
		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
			dev_err(pub ? pub->bus_if->dev : NULL,		\
				"%s: " fmt, __func__,			\
				##__VA_ARGS__);				\
	} while (0)

but this wouldn't compile because for brcmf_err(NULL "Foo\n"); it would roll
out to:
dev_err(NULL ? NULL->bus_if->dev : NULL, "Foo\n");

I *can* support brcmf_err(NULL "Foo\n"); calls if I change brcmf_err from
macro to a function (inline probably). Do you think it's a good idea?
