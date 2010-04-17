Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:59406 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750827Ab0DQNeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 09:34:44 -0400
Message-ID: <4BC9B75E.9070005@free.fr>
Date: Sat, 17 Apr 2010 15:27:58 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] ath5k/ath9k: Fix 64 bits TSF reads
References: <1271369246-6892-1-git-send-email-benoit.papillault@free.fr> <1271452384.16507.16.camel@mj>
In-Reply-To: <1271452384.16507.16.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin a écrit :
> On Fri, 2010-04-16 at 00:07 +0200, Benoit Papillault wrote:
>
>   
>> It follows the logic mentionned by Derek, with only 2 register reads
>> needed at each additional steps instead of 3 (the minimum number of
>> register reads is still 3).
>>     
>
> I would prefer an approach whereas tsf_upper2 or tsf_upper1 is chosen
> based on whether tsf_lower is more or less than 0x80000000 if
> (tsf_upper2 - tsf_upper1) is 1.  If the difference is not 0 or 1, either
> the hardware is broken or the kernel was stuck for so long (71 minutes!)
> that getting the exact tsf should be the least worry.  That's when
> WARN_ON would be appropriate.
>
> The problem with overengineered code is that it doesn't break when it's
> better to break and expose the problem :-)
>
> But it's just a suggestion, not a NACK.  It's better to have some fix
> than no fix at all.
>  
>   
Hello Pavel,

You are considering rollover here, but the TSF can make big jumps as 
well (in case of IBSS merges). This later case can only be handled by 
the above code, to my knowledge. I am seeking consistency first and 
optimization next, not the opposite.

We can even consider the case where only the lower TSF has made a small 
jump before reading the higher part and the lower part. However, such 
case cannot be distinguished from a normal case and the resulting value 
will be consistent anyway (since the higher part has not changed).

In the case where tsf_upper2 = tsf_upper1 + 1, this can happen when a 
rollover occurs. It could also happens in case of IBSS merge, in which 
case, your logic won't work. Let's take an example:

real TSF 0x00000001-ffffffc0 => tsf_upper1 = 1
--- rollover ---
real TSF 0x00000001-ffffffc8 => tsf_lower = 0xffffffc8
real TSF 0x00000002-00000008 => tsf_upper2 = 2

In this case, we assume that TSF = 0x00000001-ffffffc8 (since 0xffffffc8 
 > 0x80000000).

real TSF 0x00000001-10000009 => tsf_upper1 = 1
--- HW IBSS merge ---
real TSF 0x00000002-ffffffc8 => tsf_lower = 0xffffffc8
real TSF 0x00000002-ffffffd0 => tsf_upper2 = 2

In this case, we assume that TSF = 0x00000001-ffffffc8 ... which is wrong!

Did I miss something?

Regards,
Benoit

