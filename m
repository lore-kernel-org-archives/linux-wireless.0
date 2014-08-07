Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45117 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaHGRpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 13:45:06 -0400
Message-ID: <53E3BB1D.10807@candelatech.com> (sfid-20140807_194511_271894_4021F09B)
Date: Thu, 07 Aug 2014 10:45:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <6460230.VGl66UFULp@debian64> <53E16436.2020706@candelatech.com> <1875618.ePecsgGYZf@blech>
In-Reply-To: <1875618.ePecsgGYZf@blech>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/07/2014 07:05 AM, Christian Lamparter wrote:

> The high overhead (math_state_restore and fpu_save_init) are caused by 
> the way ccm.c interacts with the aesni implementation when calculating
> the MAC [1] (in compute_mac). 
> 
>>    [ ... ]
>> 	/* now encrypt rest of data */
>> 	while (datalen >= 16) {
>> 		crypto_xor(odata, data, bs);
>> 		crypto_cipher_encrypt_one(tfm, odata, odata);
>>
>> 		datalen -= 16;
>> 		data += 16;
>> 	}
>>   [...]
> 
> crypto_cipher_encrypt_one is a wrapper which in your case calls 
> aesni's aes_encrypt [2].
> 
> And aes_encrypt looks like this: 
> 
>> 	[...]
>> 	kernel_fpu_begin();
>> 	aesni_enc(ctx, dst, src); <-- this is where it goes to _aesni_enc1
>> 	kernel_fpu_end();
>> 	[...] 
> 
> Or: for every 16 Bytes of payload there is one fpu context save and
> restore... ouch!

I have never messed with this kind of stuff...

Any idea if it would work to put the fpu_begin/end a bit higher and do all those 16 byte
chunks in a batch without messing with the FPU for each chunk?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

