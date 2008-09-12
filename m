Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:46272 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbYILSwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 14:52:53 -0400
Message-ID: <48CABA84.2060404@lwfinger.net> (sfid-20080912_205257_642337_3C25CE51)
Date: Fri, 12 Sep 2008 13:52:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] p54: Fix sparse warnings
References: <48cab1e3.m0lac7LoL3DFxIu6%Larry.Finger@lwfinger.net> <200809122036.03553.mb@bu3sch.de>
In-Reply-To: <200809122036.03553.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Friday 12 September 2008 20:16:03 Larry Finger wrote:
>>  struct bootrec {
>>  	__le32 code;
>>  	__le32 len;
>> -	u32 data[0];
>> +	/* Most references to the data section that follows are for u32
>> +	 * quantities; however, one is for an le16 quantity. The union
>> +	 * below avoids a cast and makes the usage clearer. */
>> +	union {
>> +		u32 data[0];
>> +		__le16 data16[0];
>> +	};
>>  } __attribute__((packed));
> 
> I suggest you change
> 	u32 data[0];
> to
> 	__le32 data_le32[0];
> and also add
> 	__be32 data_be32[0];
> to the union. This avoids another few casts.
> (Maybe you don't even need the __le32 variant. I didn't check all the code).

No, it won't avoid any casts. The program uses the data area 7 times 
in native-cpu order, once as be32, and once in little-endian order 
(the one that was fixed by the union).

I will add the packed attribute as suggested in your other email.

Thanks for the review,

Larry
