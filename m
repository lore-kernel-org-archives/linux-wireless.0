Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4315 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2K2R7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 12:59:55 -0500
Message-ID: <50B7A292.60002@broadcom.com> (sfid-20121129_185958_466090_B9E42B15)
Date: Thu, 29 Nov 2012 18:59:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: Re: [PATCH 05/11] brcmsmac: hardware info in debugfs
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
 <1354135454-7035-6-git-send-email-arend@broadcom.com>
 <20121129170833.GE29726@thinkpad-t410>
In-Reply-To: <20121129170833.GE29726@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2012 06:08 PM, Seth Forshee wrote:
> On Wed, Nov 28, 2012 at 09:44:08PM +0100, Arend van Spriel wrote:
>> From: Piotr Haber <phaber@broadcom.com>
>>
>> Put basic information about hardware in debugfs.
>>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Arend van Spriel <arend@broadcom.com>
>> Signed-off-by: Piotr Haber <phaber@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>  drivers/net/wireless/brcm80211/brcmsmac/debug.c    |  112 ++++++++++++++++++++
>>  drivers/net/wireless/brcm80211/brcmsmac/debug.h    |   23 ++++
>>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    8 +-
>>  drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 +
>>  4 files changed, 143 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>> index 6ba4136..07e6b88 100644
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>> @@ -1,8 +1,120 @@
>> +/*
>> + * Copyright (c) 2012 Broadcom Corporation
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for any
>> + * purpose with or without fee is hereby granted, provided that the above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
>> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
>> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
> 
> Sorry for being slow in responding about the license issue. As far as
> we're concerned this is fine, both here and in debug.h. Please do add
> our copyright notice as well:
> 
>  Copyright (c) 2012 Canonical Ltd.
> 
> Or if John's already applied them I can send a separate patch. Regarding
> the license notice:
> 
> Acked-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Thanks,
> Seth

John,

Do you want me to resubmit this patch with the added copyright notice or
can you take care of it?

Gr. AvS

>> +#include <linux/debugfs.h>
>> +#include <linux/if_ether.h>
>> +#include <linux/if.h>
>>  #include <linux/net.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/ieee80211.h>
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +#include <net/mac80211.h>


