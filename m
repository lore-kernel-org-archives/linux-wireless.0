Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3019 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1JOI1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 04:27:24 -0400
Message-ID: <4E9943D5.1060607@broadcom.com> (sfid-20111015_102740_791159_84DC415E)
Date: Sat, 15 Oct 2011 10:27:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Pavel Roskin" <proski@gnu.org>,
	"John W Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
 <20111014111103.5658d4aa@mj> <4E986392.7020008@lwfinger.net>
In-Reply-To: <4E986392.7020008@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2011 06:30 PM, Larry Finger wrote:
> On 10/14/2011 10:11 AM, Pavel Roskin wrote:
>> On Sat, 08 Oct 2011 17:28:42 -0500
>> Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>
>>> +static inline void htol16_buf(u16 *buf, unsigned int size)
>>> +{
>>> +	size /= 2;
>>> +	while (size--)
>>> +		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>>>   }
>>
>> I'm not not sure compilers would optimize it out on little-endian
>> systems.  Perhaps you want a define that uses this code on
>> big-endian systems and does nothing on little endian systems.
>>
>> Also, it would be nice to have a compile-time check that size is even.
>> Or maybe size should be the number of 16-bit words, but then it would be
>> better to call the argument "count" or something like that.
> 
> The patch was dropped. Even so, as this routine is found in brcmsmac, your 
> comments warrant further discussion.

Following the thread over here ;-)

> I am pretty sure that the compiler would optimize out the entire htol16_buf 
> routine. After substitution for cpu_to_le16() on a little-endian system, the 
> statement in the while loop becomes '*(buf + size) = *(buf + size)', which is 
> certainly optimized away, as will the now empty while loop. The entire routine 
> is reduced to 'size /= 2'. As this will have no effect on the external world, it 
> will also be dropped leaving an empty htol16_buf(). I don't think any "#ifdef 
> __BIG_ENDIAN ... #endif" statements are needed.

Agree.

> Your suggestion that the argument be renamed is good, but there is no need to 
> check for an even number as the data in question come from 16-bit reads of the
> SPROM on the b43 device. That number of 16-bit quantities was multiplied by 2 to 
> get the byte count before calling this routine. Of course, the routine should 
> have been passed the number of 16-bit words, not the byte count. My second 
> version would have done this.
> 
> Larry

Feedback on the renaming is indeed valid. Passing the word count is
better here. For brcmsmac I plan to fill the buffer using 8-bit reads
from SPROM, verify the crc8, and perform the endianess conversion from
le16 to cpu when crc is ok (actually under review internally).

Gr. AvS

