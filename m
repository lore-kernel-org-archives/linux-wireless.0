Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41827 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1JNQaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 12:30:03 -0400
Received: by gyb13 with SMTP id 13so1287740gyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 09:30:03 -0700 (PDT)
Message-ID: <4E986392.7020008@lwfinger.net> (sfid-20111014_183012_489581_467A16FE)
Date: Fri, 14 Oct 2011 11:30:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net> <20111014111103.5658d4aa@mj>
In-Reply-To: <20111014111103.5658d4aa@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2011 10:11 AM, Pavel Roskin wrote:
> On Sat, 08 Oct 2011 17:28:42 -0500
> Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>
>> +static inline void htol16_buf(u16 *buf, unsigned int size)
>> +{
>> +	size /= 2;
>> +	while (size--)
>> +		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>>   }
>
> I'm not not sure compilers would optimize it out on little-endian
> systems.  Perhaps you want a define that uses this code on
> big-endian systems and does nothing on little endian systems.
>
> Also, it would be nice to have a compile-time check that size is even.
> Or maybe size should be the number of 16-bit words, but then it would be
> better to call the argument "count" or something like that.

The patch was dropped. Even so, as this routine is found in brcmsmac, your 
comments warrant further discussion.

I am pretty sure that the compiler would optimize out the entire htol16_buf 
routine. After substitution for cpu_to_le16() on a little-endian system, the 
statement in the while loop becomes '*(buf + size) = *(buf + size)', which is 
certainly optimized away, as will the now empty while loop. The entire routine 
is reduced to 'size /= 2'. As this will have no effect on the external world, it 
will also be dropped leaving an empty htol16_buf(). I don't think any "#ifdef 
__BIG_ENDIAN ... #endif" statements are needed.

Your suggestion that the argument be renamed is good, but there is no need to 
check for an even number as the data in question come from 16-bit reads of the
SPROM on the b43 device. That number of 16-bit quantities was multiplied by 2 to 
get the byte count before calling this routine. Of course, the routine should 
have been passed the number of 16-bit words, not the byte count. My second 
version would have done this.

Larry
