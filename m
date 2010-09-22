Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59155 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0IVQxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 12:53:16 -0400
Message-ID: <4C9A346A.3050909@candelatech.com>
Date: Wed, 22 Sep 2010 09:52:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Andreas Schwab <schwab@linux-m68k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to get iw building on Fedora 8
References: <4C98DFB6.10902@candelatech.com> <m2wrqej2qk.fsf@igel.home> <4C991F25.1000102@candelatech.com> <20100921213451.GA29134@sig21.net>
In-Reply-To: <20100921213451.GA29134@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 02:34 PM, Johannes Stezenbach wrote:
> On Tue, Sep 21, 2010 at 02:09:57PM -0700, Ben Greear wrote:
>> On 09/21/2010 12:49 PM, Andreas Schwab wrote:
>>> Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>   writes:
>>>
>>>> I need this in order to get iw to build on Fedora 8.
>>>>
> ...
>>>> +#define  __USE_ISOC99
>>>
>>> This is wrong.  You must never define internal glibc macros.
>>
>> How about this then?
> ...
>> -                       tmpf = strtof(argv[i],&end);
>> +                       tmpf = strtod(argv[i],&end);
> ...
>> Seems you don't have to do anything clever to get strtod to work,
>> and I assume it should cast just fine.
>
> I think to use C99 features like strtof() you need to either
> add -std=c99 to CFLAGS, or #define _ISOC99_SOURCE
> (see /usr/include/features.h).

It seems using strtod would be simpler all around, and might work on
more compilers and even more ancient systems.

Thanks,
Ben

>
> HTH,
> Johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

