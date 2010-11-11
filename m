Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43695 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0KKSCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 13:02:20 -0500
Received: by fxm16 with SMTP id 16so1558406fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 10:02:19 -0800 (PST)
Message-ID: <4CDC2FCF.9020902@lwfinger.net>
Date: Thu, 11 Nov 2010 12:02:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix compile on ARM architecture
References: <4cdc2b80.RuMMb1PuVmklU3JJ%Larry.Finger@lwfinger.net> <4CDC2C80.6030807@arndnet.de>
In-Reply-To: <4CDC2C80.6030807@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 11:48 AM, Arnd Hannemann wrote:
> Am 11.11.2010 18:44, schrieb Larry Finger:
>> From: Arnd Hannemann <arnd@arndnet.de>
>>
>> When b43legacy is compiled on the arm platform, the following errors are seen:
>>
>>   CC [M]  drivers/net/wireless/b43legacy/xmit.o
>> In file included from include/net/dst.h:11,
>> from drivers/net/wireless/b43legacy/xmit.c:31:
>> include/net/dst_ops.h:28: error: expected ':', ',', ';', '}' or '__attribute__'
>>    before '____cacheline_aligned_in_smp'
>> include/net/dst_ops.h: In function 'dst_entries_get_fast':
>> include/net/dst_ops.h:33: error: 'struct dst_ops' has no member named
>>    'pcpuc_entries'
>> include/net/dst_ops.h: In function 'dst_entries_get_slow':
>> include/net/dst_ops.h:41: error: 'struct dst_ops' has no member named
>>    'pcpuc_entries'
>> include/net/dst_ops.h: In function 'dst_entries_add':
>> include/net/dst_ops.h:49: error: 'struct dst_ops' has no member named
>>    'pcpuc_entries'
>> include/net/dst_ops.h: In function 'dst_entries_init':
>> include/net/dst_ops.h:55: error: 'struct dst_ops' has no member named
>>    'pcpuc_entries'
>> include/net/dst_ops.h: In function 'dst_entries_destroy':
>> include/net/dst_ops.h:60: error: 'struct dst_ops' has no member named
>>    'pcpuc_entries'
>> make[4]: *** [drivers/net/wireless/b43legacy/xmit.o] Error 1
>> make[3]: *** [drivers/net/wireless/b43legacy] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>>
>> The cause is a missing include of <linux/cache.h>, which is present for
>> i386 and x86_64 architectures, but not for arm.
>>
>> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@kernel.org>
>> ---
>>
>> John,
>>
>> Once I get the ability to cross-compile ARM architecture, I will check to
>> see if the equivalent patch is needed for b43.
> 
> b43 compiles fine for me for the same target.
> 
> Thanks,
> Arnd
> 
>>
>> Larry
>> ---
>>
>> Index: linux-2.6/include/net/dst_ops.h
>> ===================================================================
>> --- linux-2.6.orig/include/net/dst_ops.h
>> +++ linux-2.6/include/net/dst_ops.h
>> @@ -2,6 +2,7 @@
>>  #define _NET_DST_OPS_H
>>  #include <linux/types.h>
>>  #include <linux/percpu_counter.h>
>> +#include <linux/cache.h>
>>  
>>  struct dst_entry;
>>  struct kmem_cachep;

After I sent this, it occurs to me that the extra include might be in
b43legacy/xmit.c, not in include/dst_ops.h. Any thoughts and or suggestions? If
that is the case, then b43 would likely break too.

Larry
