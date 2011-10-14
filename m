Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2944 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab1JNPa7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:30:59 -0400
Message-ID: <4E985597.40201@broadcom.com> (sfid-20111014_173101_647665_391FB4BF)
Date: Fri, 14 Oct 2011 17:30:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Pavel Roskin" <proski@gnu.org>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
 <20111014111103.5658d4aa@mj>
In-Reply-To: <20111014111103.5658d4aa@mj>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2011 05:11 PM, Pavel Roskin wrote:
> On Sat, 08 Oct 2011 17:28:42 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> +static inline void htol16_buf(u16 *buf, unsigned int size)
>> +{
>> +	size /= 2;
>> +	while (size--)
>> +		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>>  }
> 
> I'm not not sure compilers would optimize it out on little-endian
> systems.  Perhaps you want a define that uses this code on
> big-endian systems and does nothing on little endian systems.
> 
> Also, it would be nice to have a compile-time check that size is even.
> Or maybe size should be the number of 16-bit words, but then it would be
> better to call the argument "count" or something like that.
> 

I think this patch was already dropped.

Gr. AvS

