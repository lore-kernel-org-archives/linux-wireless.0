Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58605 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab0KWCk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 21:40:29 -0500
Received: by qwc9 with SMTP id 9so1567302qwc.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 18:40:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=7ErFUgPOFaePh6GUP5rF18c=q5Gs6+GYvMiOK@mail.gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
	<1289355626-25373-29-git-send-email-lacombar@gmail.com>
	<20101110222448.GG4667@tux>
	<AANLkTikh2XJ1ONjD3PaYcw-yV9EkNZMX4Td3jAi9dGvs@mail.gmail.com>
	<AANLkTinWrnugirPczxp5dMwMTvYn_HOaPtVw88YqXEmZ@mail.gmail.com>
	<AANLkTin=WkXaP58UV8rREcYYxDw5xDfnqAEanEO0ETQY@mail.gmail.com>
	<AANLkTi=7ErFUgPOFaePh6GUP5rF18c=q5Gs6+GYvMiOK@mail.gmail.com>
Date: Mon, 22 Nov 2010 21:40:28 -0500
Message-ID: <AANLkTinoBSktYe-KSkMyVMeQhBEi60U1w_Okbd0VyzvX@mail.gmail.com>
Subject: Re: [PATCH 28/44] compat: avoid using `#include_next' directive in
 compat headers
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Nov 22, 2010 at 9:32 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Nov 22, 2010 at 6:19 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Hi,
>>
>> On Mon, Nov 22, 2010 at 1:09 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> On Sun, Nov 21, 2010 at 5:36 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>>> [...]
>>>> The compat headers should be at the end of the include list, so that
>>>> the kernel headers get included first, and the compat one will only be
>>>> when the kernel does not provide the header. This is the only sane way
>>>> to override kernel provided stuff. That said, there is certainly a
>>>> use-case I missed.
>>>
>>> Agreed, but you are missing the purpose of the trick used here.
>> certainly :)
>>
>>> The
>>> purpose of the include_next was so that we can name our own
>>> <linux/pm_qos_params.h> which is part of compat and these directories
>>> *will* get a priority over the kernel's so that way we can avoid
>>> ifdef'ing all includes for the same file on the upstream code.
>> I'm not sure to get what you mean by "we can avoid ifdef'ing all
>> includes for the same file on the upstream code", can you details ?
>
> Ah, that's right, you don't see or use compat-wireless likely. Ok, so
> what we do for backporting the 802.11 subsystem, Bluetooth and some
> Ethernet drivers is we take the stock upstream files, stuff them into
> a new directory, and then apply a series of patches to them to get the
> files to properly compile. The patches address all things that was not
> possible to backport through compat.git. Header file changes is one of
> the typical things we run into. If a new header file is added to newer
> kernels we can play a hack for older kernels and leave the code intact
> and introduce our own include/linux/foo.h through compat by prefering
> the local path over the kernel's path. If we're on newer kernels
> though include_next will go on the search path and find the kernel's
> own header file.
>
Is there any reason you want the compat's include directory to be
*before* the kernel include directory ? Because just considering this
issue, if the kernel include directory was seen first, this would not
arise, as the compat-provided header would just be a fallback.

 - Arnaud
