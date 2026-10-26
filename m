Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793054519;
	b=DGaSKlVkoLSdl1K42mgEE4cpOlnDVCdVJ/sh6rZoA97d+V1HNUt/Or6jUVLjNo9jhlfq
	 VviL2ybzTsb+Qf64GPTbeKAS+/v9UUR8X25ICDXuNvgV3nbub1Soy+A/PgkHI4XQ3qXbk
	 FGlY3/eDih2i4OHTKAQ79r1ig3gH3/p8aqALyl7ykw2KquQMeyj1A2Jp9Smf/9J3Ts1Cx
	 dN6q1EVskOv5YyB7JlErb/wZcPt2CCpHaS7Ws/t5s1wxjoPQ6eo8KI+yAV7/17cnxWNHb
	 7svplG+ORqupzbvYN5onsjD5JBNKPZs9p0lyEYceykQtv9U0B2/+eaKjD7+i8VK6rPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793054519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=9TJ2uWGQA28B7/IVLdQOUeh7B2n+/HiF9b/pWpbRQp8=;
	b=gielRsrfjIXTb72lvZTlWVovIJl2y+ltMO0loLvBiTiXa4Vct66XW4E3/X+wS+Vc6uA9
	 VeR9IMpF+f+coVk4TugWsNapxkzvkyV8K91pFkG1k/AxfQstN96YEEI6DAUiSjXOJZgeK
	 idtFGetHi5JnvsBUItNOCtZ1waeiqKeuP7QJ3eoAbQ90sVvr81NObdVghB5BrMLEem5Fx
	 2Xh2k60SDShAP6jpzJVhVK1Oxp2C3mnCvG1ORkGWmRGIziYqmkzTO+gXVU/U78ZLqM6tG
	 1FCKwEmI+7zITaqLCy24U5xm/Kr9gcMklASaycdwINljUJ87qU9inNGRe1v0DeB8Wkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sTR+N0rG;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23B7606A31E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A23B7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sTR+N0rG
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so15254715e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793054517; x=1793659317; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9TJ2uWGQA28B7/IVLdQOUeh7B2n+/HiF9b/pWpbRQp8=;
        b=sTR+N0rG1eZuvFqHfBbcpGz3dtTjerA5lXe1bEMttgS8nsv33ERnGeZnDqeMZfzc9d
         tlbLJUgj2VgJ7Sk7V5qzTyGTFywijunoRW6dxp2pekNeJuohvkWkMkqZFvLlfVRWHRn2
         YwCSMBl6E1CJsaBedBHyfbkKfvX6molQ5dK8Jd23ohTYLxQVhmIGc+7SaBzM9pjJTjzV
         PctpyRgTvTIv7NIYQYiklT1HTHeE789laPiMiOf54QF66H0e1VFNmZXKSDeWW7MfvKD6
         1uCsAXegaBbTd72u70LFKABs2/C3Hn2JYGBq8zcglgUUmRWKdNNYLxaKwCGehtRzvbr9
         tJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054517; x=1793659317;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9TJ2uWGQA28B7/IVLdQOUeh7B2n+/HiF9b/pWpbRQp8=;
        b=HZGUlz5XLf2FUXVulINUvZ7TsUcHCAN9VR1KyyhxEUNUR53U3wf07/vjd+sCN2M/II
         L0p/BAw8A3Qyuap1cmf5hXQVXph62m57HuykABm8ih5klcBQ7TvB2Kbpz9KTurl+57de
         QQwqa39AwGdKaWJ+SDS5DyWup5TVgMqYwhTMLIg7a193pI14KKrtAVZqFG2AvrsBK5tR
         fao+8HTyPy6T/Qc9MCAS0W2lfOFdYarq2HXKG08sgGCUy46DXj7Bn9HOy0z24B7kc/5d
         KfWaqTF+gcReeTM0ZFRC9ccIxTjpqddWEdwd8tAmbOhLIG5c8/K9p7Ou4AtMlaE2l2aT
         bskQ==
X-Forwarded-Encrypted: i=1; AKwUvBwub0/kPttY7d7x0j99OMBcqmDipeSA2TJIGYAoZyTmLwOos7MlHNDbC+GqZ5lETCdF8gTtJtmb2EVIxajEFw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLDIGcAPKska3cDKuECa5Q3USZVyqOB6ajC58a9GQnWlQDEFDPD
	sVgAtipJAoSA+d5IbOp/4IFGd7BHNxT0gGqDVNLzIuv+L65zVUT48I8J
X-Gm-Gg: AYBFou21oE9oQd3E0xEfqOsnOTTEoeOsySJPARr03cvBB8RKzbsEGuP4HScWGMchbTM
	q5ygGzRBbx6OyVIynVQu/LKBjMp+W2EVGoJUKGBIVmDTNh0G60kZyJ4kIiFQUlfyfAcBpK/cp7y
	NKhNjzbNLyf8zxIv79glbh7qvQnmfBfy7KC/zTa41G0m90zSU79i9gZX+TFncNIauZtD997g5n4
	ZEvpg93zWYKwJ++VCPqhbD7LjLsQo4uu+GzJhBga2AICfBERZzt/dKEKeVYL3OGMseyjge8I+DP
	NdZcypwwzuAeFjdDO849w4QtV8s5NA7LV49bo+I+UYyXUlw48f0ZHgL5ErOQ3Vao3Fcoh/IYOlA
	Vg5QhEm5Ing2Bo8Cjd0PZVStObN4+5h7MTFMhsUyPUhXBeHn5svEIJ5PQkpBGihP0mXLvwyy22s
	wwzdhFZ3vSVfhzqFTtCG4IU92xYmtnQA7utnVPIZtVLTpInKf/UDcH9rislGMe8Y3TKVYsbUBJ/
	8KB7V9XvgcGeRWLE0Mqbm/RUVxdB/GnaSnA1AeI5fq/kPquMW414ubtKzhbC5cQTK/CfnOUVl8n
	X80K8HBfYYkaHX2QfgSxUe1d7hswGBzh1+hR8lk71HuqvDQazTigoQF1Hd2KHaauFHCzC0IvU1h
	K2RpGHg==
X-Received: by 2002:a05:600c:4e87:b0:4a1:f7f4:7cf2 with SMTP id 5b1f17b1804b1-4a35acaa046mr152446335e9.17.1793054516772;
        Mon, 26 Oct 2026 15:41:56 -0700 (PDT)
Received: from shift.daheim (p200300d5ff07190050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:1900:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a55e99fsm228800335e9.4.2026.10.26.15.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:41:54 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xLTO3-00000000SgX-3CYi;
	Mon, 26 Oct 2026 23:41:54 +0100
Message-ID: <7a52a44b-d674-4469-bc77-35a5a648472d@gmail.com>
Date: Mon, 26 Oct 2026 23:41:53 +0100
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless 3/3] wifi: p54: fix IE parsing loop bounds check
To: Johannes Berg <johannes@sipsolutions.net>,
 Tristan Madani <tristmd@gmail.com>, Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Tristan Madani <tristan@talencesecurity.com>
References: <20261026112151.2515228-1-tristmd@gmail.com>
 <20261026112151.2515228-3-tristmd@gmail.com>
 <9658b549be7c1c0f1637699b8b61960d2101dfca.camel@sipsolutions.net>
Content-Language: de-DE, en-US
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <9658b549be7c1c0f1637699b8b61960d2101dfca.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 12:45 PM, Johannes Berg wrote:
> On Mon, 2026-10-26 at 11:21 +0000, Tristan Madani wrote:
>> From: Tristan Madani <tristan@talencesecurity.com>
>>
>> p54_find_ie() iterates over information elements using a loop condition
>> of while (pos < end). When only one byte remains (pos == end - 1),
>> the loop body accesses pos[1] which reads one byte beyond the validated
>> buffer boundary. The read happens in the bounds check expression
>> pos + 2 + pos[1] > end before the result of that check can prevent
>> the access.
>>
>> Fix by tightening the loop condition to while (pos + 2 <= end),
>> which ensures that at least the IE id (pos[0]) and length (pos[1])
>> bytes are within bounds before any access.
>>
>> Fixes: 0ac0d6cedf611 ("p54: Move mac80211 glue code")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
>> ---
>>   drivers/net/wireless/intersil/p54/main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
>> index 57a62108cbc35..16614f65dfa5f 100644
>> --- a/drivers/net/wireless/intersil/p54/main.c
>> +++ b/drivers/net/wireless/intersil/p54/main.c
>> @@ -81,7 +81,7 @@ u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
> 
> We'd probably be better off just replacing that whole function with one
> of the real search functions or iteration macros?
> yeah, I think carl9170 probably can just straight up use cfg80211_find_ie.

But p54 needs to edit the beacon and the memmove the (found) TIM element
to the end of the beacon and modify it a bit of tim in p54_beacon_format_ie_tim.
The problem here is that the helpers are all casting to const. So this will
look "funny" via to "uncast" const. Unless you meant something else?

As for what to expect if something read past the end? Well, p54 works on skbs. So past the
"end" in p54_beacon_format_ie_tim() would either be extra tailroom then padding or the start
of skb_shared_info (u8 flags) I think? In case of p54_pspoll_workaround(), after the "end",
there will be the FCS (32-bit checksum) - at least on real hardware) and then padding or
the start of skb_shared_info.

For rt2xx: not sure. But the existing use cfg80211_find_ie in rtw89_core_cancel_6ghz_probe_tx()
and rtw89_core_cancel_6ghz_probe_tx() looks suspecious.
Because from what I gleamed, both just pass "skb->len" as then len parameter. But shouldn't
that be subtracted by the offsetof mgmt->u.beacon.variable? Because cfg80211_find_ie thinks
len starts from the "ies"? I can't tell right now as I'm sick and need to go back to bed.
This all could either be a fever dream an be true/half-true or completely wrong. So I have to
ask in advance: Please don't take this all too seriously.

Cheers,
Christian

PS: Is there also a patch for rtl_find_ie (isn't that pretty much the same as all the others?)
