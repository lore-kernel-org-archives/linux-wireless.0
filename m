Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55552 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0KWCTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 21:19:32 -0500
Received: by qyk12 with SMTP id 12so1121051qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 18:19:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinWrnugirPczxp5dMwMTvYn_HOaPtVw88YqXEmZ@mail.gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
	<1289355626-25373-29-git-send-email-lacombar@gmail.com>
	<20101110222448.GG4667@tux>
	<AANLkTikh2XJ1ONjD3PaYcw-yV9EkNZMX4Td3jAi9dGvs@mail.gmail.com>
	<AANLkTinWrnugirPczxp5dMwMTvYn_HOaPtVw88YqXEmZ@mail.gmail.com>
Date: Mon, 22 Nov 2010 21:19:30 -0500
Message-ID: <AANLkTin=WkXaP58UV8rREcYYxDw5xDfnqAEanEO0ETQY@mail.gmail.com>
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

On Mon, Nov 22, 2010 at 1:09 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sun, Nov 21, 2010 at 5:36 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> [...]
>> The compat headers should be at the end of the include list, so that
>> the kernel headers get included first, and the compat one will only be
>> when the kernel does not provide the header. This is the only sane way
>> to override kernel provided stuff. That said, there is certainly a
>> use-case I missed.
>
> Agreed, but you are missing the purpose of the trick used here.
certainly :)

> The
> purpose of the include_next was so that we can name our own
> <linux/pm_qos_params.h> which is part of compat and these directories
> *will* get a priority over the kernel's so that way we can avoid
> ifdef'ing all includes for the same file on the upstream code.
I'm not sure to get what you mean by "we can avoid ifdef'ing all
includes for the same file on the upstream code", can you details ?

> Without
> an include_next we'd simply skip including the kernel's own original
> header file.
>
I admit that I removed that part merely because I went loose on the
trigger that day. AFAIR, there was no technical point per-se, so I
would not mind omitting this patch.

 - Arnaud
