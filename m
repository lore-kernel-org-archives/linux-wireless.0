Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35881 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3HHGpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 02:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <5202D173.4050408@hauke-m.de>
References: <1375865563-1196-1-git-send-email-arik@wizery.com> <5202D173.4050408@hauke-m.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 8 Aug 2013 09:45:17 +0300
Message-ID: <CA+XVXfdAUZGj7FjfRUxT2noa1b35xk1vn0bdcO70Vic6h9yXcg@mail.gmail.com> (sfid-20130808_084537_541460_A00A6F46)
Subject: Re: [PATCH] backports: rename some mem functions to not break custom kernels
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 8, 2013 at 2:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Please add backports mailing list ( backports@vger.kernel.org ) next time.

Ok. Thanks.


>> diff --git a/backport/backport-include/asm/mtrr.h b/backport/backport-include/asm/mtrr.h
>> index cf0f6fd..c5760b4 100644
>> --- a/backport/backport-include/asm/mtrr.h
>> +++ b/backport/backport-include/asm/mtrr.h
>> @@ -7,14 +7,17 @@
>>   * The following functions are for use by other drivers that cannot use
>>   * arch_phys_wc_add and arch_phys_wc_del.
>>   */
>> +#ifndef phys_wc_to_mtrr_index
>>  #ifdef CONFIG_MTRR
>> -extern int phys_wc_to_mtrr_index(int handle);
>> +extern int backport_phys_wc_to_mtrr_index(int handle);
>>  #else
>> -static inline int phys_wc_to_mtrr_index(int handle)
>> +static inline int backport_phys_wc_to_mtrr_index(int handle)
>>  {
>>       return -1;
>>  }
>>  #endif /* CONFIG_MTRR */
>> +#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)
>
> You should put this line before the #ifndef phy_.... and then you do not
> have to use backport_phys_wc_to_mtrr_index with the prefix anywhere in
> backports. This also applies for the other places where you manually add
> backport_.

The case I'm trying to un-break here is one where the symbol is
defined by the kernel, even though it's not supposed to. This can
happen if someone cherry-picks patches containing this symbol into
their kernel.
The backported driver is better off using the kernel symbol in that
case I guess?

Arik
