Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59486 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab3HLQYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 12:24:33 -0400
Message-ID: <52090C37.2000103@hauke-m.de> (sfid-20130812_182436_262877_6EC1B18B)
Date: Mon, 12 Aug 2013 18:24:23 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: linux-wireless@vger.kernel.org, mcgrof@kernel.org,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Subject: Re: [PATCH] backports: rename some mem functions to not break custom
 kernels
References: <1375865563-1196-1-git-send-email-arik@wizery.com> <5202D173.4050408@hauke-m.de> <CA+XVXfdAUZGj7FjfRUxT2noa1b35xk1vn0bdcO70Vic6h9yXcg@mail.gmail.com>
In-Reply-To: <CA+XVXfdAUZGj7FjfRUxT2noa1b35xk1vn0bdcO70Vic6h9yXcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2013 08:45 AM, Arik Nemtsov wrote:
> On Thu, Aug 8, 2013 at 2:00 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> Please add backports mailing list ( backports@vger.kernel.org ) next time.
> 
> Ok. Thanks.
> 
> 
>>> diff --git a/backport/backport-include/asm/mtrr.h b/backport/backport-include/asm/mtrr.h
>>> index cf0f6fd..c5760b4 100644
>>> --- a/backport/backport-include/asm/mtrr.h
>>> +++ b/backport/backport-include/asm/mtrr.h
>>> @@ -7,14 +7,17 @@
>>>   * The following functions are for use by other drivers that cannot use
>>>   * arch_phys_wc_add and arch_phys_wc_del.
>>>   */
>>> +#ifndef phys_wc_to_mtrr_index
>>>  #ifdef CONFIG_MTRR
>>> -extern int phys_wc_to_mtrr_index(int handle);
>>> +extern int backport_phys_wc_to_mtrr_index(int handle);
>>>  #else
>>> -static inline int phys_wc_to_mtrr_index(int handle)
>>> +static inline int backport_phys_wc_to_mtrr_index(int handle)
>>>  {
>>>       return -1;
>>>  }
>>>  #endif /* CONFIG_MTRR */
>>> +#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)
>>
>> You should put this line before the #ifndef phy_.... and then you do not
>> have to use backport_phys_wc_to_mtrr_index with the prefix anywhere in
>> backports. This also applies for the other places where you manually add
>> backport_.
> 
> The case I'm trying to un-break here is one where the symbol is
> defined by the kernel, even though it's not supposed to. This can
> happen if someone cherry-picks patches containing this symbol into
> their kernel.
> The backported driver is better off using the kernel symbol in that
> case I guess?
> 
> Arik
Hi Arik,

adding the LINUX_BACKPORT() line should be enough to rename it
everywhere in backprots, so you do not have to modify
backport/compat/backport-3.11.c or manually add the prefix anywhere else.

Could you try if this fixes your problems with phys_wc_to_mtrr_index:

 ...
+#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)
 #ifdef CONFIG_MTRR
 extern int phys_wc_to_mtrr_index(int handle);
 #else
 static inline int phys_wc_to_mtrr_index(int handle)
 {
 	return -1;
 }
 #endif /* CONFIG_MTRR */

