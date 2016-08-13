Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36110 "EHLO
	mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcHMEk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2016 00:40:27 -0400
Received: by mail-ua0-f179.google.com with SMTP id 97so7598217uav.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 21:40:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471061519.3467.7.camel@perches.com>
References: <1471057200-58166-1-git-send-email-pgynther@google.com> <1471061519.3467.7.camel@perches.com>
From: Petri Gynther <pgynther@google.com>
Date: Fri, 12 Aug 2016 21:40:26 -0700
Message-ID: <CAGXr9JHXdQxObUJC_=4ZaJKmvFS+QygK8ytMtXCJJws62a8S7A@mail.gmail.com> (sfid-20160813_064043_249685_14D0C9E9)
Subject: Re: [PATCH 1/2] etherdevice: add is_zero_ether_addr_unaligned()
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	David Miller <davem@davemloft.net>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2016 at 9:11 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2016-08-12 at 19:59 -0700, Petri Gynther wrote:
>> Add a generic routine to test if possibly unaligned to u16
>> Ethernet address is a zero address.
> []
>> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> []
>> +static inline bool is_zero_ether_addr_unaligned(const u8 *addr)
>> +{
>> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>> +     return is_zero_ether_addr(addr);
>> +#else
>> +     return (addr[0] | addr[1] | addr[2] | addr[3] | addr[4] | addr[5]) == 0;
>> +#endif
>
> Because the return is bool, the == 0 is unnecessary.
>

But, we need to return true (1) when the bitwise OR result is zero.
Same logic as in is_zero_ether_addr().
