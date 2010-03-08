Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:48886 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755532Ab0CHVom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 16:44:42 -0500
Message-ID: <4B956FC5.40202@free.fr>
Date: Mon, 08 Mar 2010 22:44:37 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix 64 bits TSF reading.
References: <4B8AE8F1.40006@free.fr>	 <1267394932-11038-1-git-send-email-benoit.papillault@free.fr> <1268036228.3819.19.camel@jlt3.sipsolutions.net>
In-Reply-To: <1268036228.3819.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Sun, 2010-02-28 at 23:08 +0100, Benoit Papillault wrote:
>
>   
>> -	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
>> +	u32 tsf_lower, tsf_upper;
>> +
>> +	/*
>> +	 * While reading TSF upper and then lower part, the clock is still
>> +	 * counting so the lower part can rollover just after reading the
>> +	 * upper part. In this case, we expect the lower part to be quite
>> +	 * small (let's say less than 100us) and we would just need to read
>> +	 * the upper part again to get the correct value.
>> +	 *
>> +	 * Tested on AR2425 (AR5001)
>> +	 */
>> +
>> +	tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
>> +	tsf_lower = ath5k_hw_reg_read(ah, AR5K_TSF_L32);
>> +
>> +	if (tsf_lower < 100)
>> +		tsf_upper = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
>>     
>
> You would typically do
>
> do {
>    read upper 1
>    read lower
>    read upper 2
> } while (upper 1 != upper 2)
>
> or so but that obviously incurs another read in most cases.
>
> johannes
>
>   
Indeed. I'll redo the patch. Derek has convinced me that accuracy is 
sometimes more important than few register reads. So forget this patch.

Regards,
Benoit

