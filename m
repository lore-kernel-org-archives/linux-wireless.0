Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 64.mail-out.ovh.net ([91.121.185.65]:53544 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750790Ab0CAGrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 01:47:16 -0500
Message-ID: <4B8B62EE.7000802@free.fr>
Date: Mon, 01 Mar 2010 07:47:10 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Derek Smithies <derek@indranet.co.nz>
CC: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: Fix 64 bits TSF reading.
References: <4B8AE8F1.40006@free.fr> <1267394932-11038-1-git-send-email-benoit.papillault@free.fr> <alpine.DEB.2.00.1003011457470.20218@kauri.acheron.indranet.co.nz>
In-Reply-To: <alpine.DEB.2.00.1003011457470.20218@kauri.acheron.indranet.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Derek Smithies a écrit :
>
> Hi,
>  No, canot support this.
>
> What happens if there is an interrupt immediately after the first two 
> reads - before the test on tsf_lower? - and thisinterrupt lasts longer 
> than 100us ? Most often, this is ok - until the interrupt happens at 
> the wrong time.
>
> OR, there is a TSF merge event after the tsf_upper has been read, but 
> before the tsf_lower has been read? The tsf merge (which is done by 
> the hardware), adjusted both the high and low registers.
>
> Derek.

Hi Derek,

You are indeed right. This was a first step, but like you mentioned, it  
does not handle every cases, so let's forget it.

Regards,
Benoit

> On Sun, 28 Feb 2010, Benoit Papillault wrote:
>
>> +
>> +    tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
>> +    tsf_lower = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
>> +
>> +    if (tsf_lower < 100)
>> +        tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
>> +
>>     ATH5K_TRACE(ah->ah_sc);
>>
>> -    return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
>> +    return (((u64)tsf_upper << 32) | tsf_lower);
>> }
>>
>> /**
>>
>

