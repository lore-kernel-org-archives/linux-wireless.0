Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50943 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab0KVSJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:09:30 -0500
Received: by iwn38 with SMTP id 38so261746iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 10:09:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikh2XJ1ONjD3PaYcw-yV9EkNZMX4Td3jAi9dGvs@mail.gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
 <1289355626-25373-29-git-send-email-lacombar@gmail.com> <20101110222448.GG4667@tux>
 <AANLkTikh2XJ1ONjD3PaYcw-yV9EkNZMX4Td3jAi9dGvs@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 22 Nov 2010 10:09:10 -0800
Message-ID: <AANLkTinWrnugirPczxp5dMwMTvYn_HOaPtVw88YqXEmZ@mail.gmail.com>
Subject: Re: [PATCH 28/44] compat: avoid using `#include_next' directive in
 compat headers
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 5:36 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Wed, Nov 10, 2010 at 5:24 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Tue, Nov 09, 2010 at 06:20:10PM -0800, Arnaud Lacombe wrote:
>>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>>> ---
>>>  include/linux/pm_qos_params.h |    7 +++----
>>>  include/linux/tracepoint.h    |   14 +++++++-------
>>>  include/net/net_namespace.h   |   14 +++++++-------
>>>  include/trace/define_trace.h  |    5 -----
>>>  4 files changed, 17 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
>>> index e1f083c..8c69ab2 100644
>>> --- a/include/linux/pm_qos_params.h
>>> +++ b/include/linux/pm_qos_params.h
>>> @@ -1,8 +1,7 @@
>>>  #include <linux/version.h>
>>>
>>> -#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
>>> -#include_next <linux/pm_qos_params.h>
>>> -#else
>>> +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
>>> +
>>
>> But will the kernels' own pm_qos_params.h be included for kernels >= 2.6.25?
>>
> The compat headers should be at the end of the include list, so that
> the kernel headers get included first, and the compat one will only be
> when the kernel does not provide the header. This is the only sane way
> to override kernel provided stuff. That said, there is certainly a
> use-case I missed.

Agreed, but you are missing the purpose of the trick used here. The
purpose of the include_next was so that we can name our own
<linux/pm_qos_params.h> which is part of compat and these directories
*will* get a priority over the kernel's so that way we can avoid
ifdef'ing all includes for the same file on the upstream code. Without
an include_next we'd simply skip including the kernel's own original
header file.

  Luis
