Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38398 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab0KJV6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:58:42 -0500
Received: by gyh4 with SMTP id 4so795735gyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 13:58:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101110215344.GD4667@tux>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
	<1289355626-25373-5-git-send-email-lacombar@gmail.com>
	<20101110215344.GD4667@tux>
Date: Wed, 10 Nov 2010 16:58:40 -0500
Message-ID: <AANLkTikxg3hab+r-b2F2F2-XSW9uQiLuMEhVRMr4C33C@mail.gmail.com>
Subject: Re: [PATCH 04/44] compat/2.6.18: add compat inline for netdev_alloc_skb()
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Nov 10, 2010 at 4:53 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Nov 09, 2010 at 06:19:46PM -0800, Arnaud Lacombe wrote:
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  include/linux/compat-2.6.18.h |   21 +++++++++++++++++++++
>>  1 files changed, 21 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/compat-2.6.18.h b/include/linux/compat-2.6.18.h
>> index a45cfc7..4a7034a 100644
>> --- a/include/linux/compat-2.6.18.h
>> +++ b/include/linux/compat-2.6.18.h
>> @@ -6,8 +6,29 @@
>>  /* Compat work for 2.6.18 */
>>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
>>
>> +#include <linux/gfp.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/skbuff.h>
>> +
>>  #define roundup(x, y)        ((((x) + ((y) - 1)) / (y)) * (y))
>>
>> +#ifndef NET_SKB_PAD
>> +#define NET_SKB_PAD  16
>
> Why are you adding the ifndef for NET_SKB_PAD if you know you already added it
> for 2.6.17 on your patch 2/44 ?
>
I should have lost a track when I made that change, it correctly
appeared in 2.6.17. My mistake :)

 - Arnaud
