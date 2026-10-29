Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307625;
	b=JwB330CSuCWzaGQqJJyawehYaoC6fJ/A4eei2wxDz2nlDGnZhxWa/9tVGwB0heWSu5Kh
	 /wqLRgJjQOU99LnBAAwZFWwDNGvHyflaRihvVZiCYQ3TAWFSzocdY5XxfU4nfhqDfHZJJ
	 E3B46kKSW9yWrtkF2EFiLkNlDuI0jyZaXA3cL79EAZ74ZiFdGnKBYxs9FzzhZtXKAMa33
	 jAvErQJAEa2NBuPHZt23LSooCHAM3aC2i1YAL+odgCLEK8g9t44vZKvYetelGitKOwglo
	 YOht1MLGFV09OetlvrMG8/sne+bXDyc3OHYDfu0Fx+MdjvORGXoFbzom1HdzCCMBiCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307625;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=aprmYdiozzAx8tGrwQpj/U9AteiwUsuAkZr+kNAxrDc=;
	b=ea6GKkbshRcoC0plQ7AO4Q/iOTbNGMvSqtAOr3ACEGJjRrhUlvCU00laCLsO10E1DTn0
	 FcCu4PjLMlgbrud9qtnxempbnelJwC55vkw0JFtl2Osh5FsFA7vkyYAY9iqn1fgjH6mRt
	 5hV2fIy/parWgshfej+iAythEmcZhwM7+VyxsTNLqUmIaocHem8IlN1PqZvXKb+QyJkBS
	 VpHvnRRr1UIiRM2OeYNPHRk/b6tJ2n0+XzgnqxVEDMGafMuXn83mNJhWztwJxrgdUOboZ
	 P2o1QOjkZmua2/ZLJ7FhQKmDIymjJB71+5wSJBKyzPfSg4CWDGHzebpiy0WKmWZTk+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UsliTpIM;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D600A606A325
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 21:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D600A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UsliTpIM
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so19616625e9.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 14:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793307623; x=1793912423; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aprmYdiozzAx8tGrwQpj/U9AteiwUsuAkZr+kNAxrDc=;
        b=UsliTpIMiOFd6lxZgjF33ygScNDhsUlz0nYruL6Pi0Ol4HsmBa510IQ+b8lv+4bMQN
         V6v95nzkx5X+zSwbT1nxtQLTa9UpNtoVUb1TQe1gXI4w0Ia+0+k6XO5GCwH+QaIa6Q6A
         15wXDW851IlNCqDT3znHI15IkDE2RxXh8vShL41siPHkDsS2peYSp/QqnVDhPJJMyYzS
         DF7mpWR5LMrb0DL2sRSWr1JCMQTQdVhiHrv7RQsqGacm4x2s7/Me0noREp8a++PQxQno
         tC6OV9/qrBP8Ngi26O/2XAci4mpzytoa0bNt95Ad7TRmv9+JxzHJWS9OJ5Ve6NFIC1tP
         hb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793307623; x=1793912423;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aprmYdiozzAx8tGrwQpj/U9AteiwUsuAkZr+kNAxrDc=;
        b=kbYX1lvQQmtq9qfdkZzevz2VetEChfKYoOOpWaGpYDy9TuuAdoCGt+3UYiHaAOBBA4
         YP4g5hM3bNWzhxmPT+QYzqV+FACB6+sxgdpcXR/NdrfexYNAt2i0SiCHFjVM6EsnJS5p
         2zwL+GI9R1WmyUsqI5lYPtlD9xG8DHH0zfofp462yCYznJ5Ssp+jJufIkAwp1McYR83e
         HkF3NVjuAxH3VB2dIE08OomleQZeiqjApPRmzgTCkZgLZ7Zh8xlXKVi+d5Y0avcY3NSo
         g/WcNigf8OcYq5s+gUfvpEiSDzKTQoI1ZUuIc1QXUgxXEPxMUxycCQZmkyxN5MdVl2NJ
         lxNQ==
X-Forwarded-Encrypted: i=1; AKwUvByVyTdhtKGscCvSKQGhHzTHt4kqks+VMBJxGU/BWthfUncKFdRjW8jU+lLssWG4avFI8P/LkxQKhBo4YdboRA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLBVX1o9dyTthmyByC3vkHgsyE2tBs1rqRyjY3bUNg0H+L8gMBH
	dp52fwWftHp8BJcx+gMSLPwFP0URxW1muvc1P0Sm+ZpZHkCCQk6V9xFj
X-Gm-Gg: AYBFou0zluXvtDdqzfDOhL8r6NrHowuoyg6Ul/jTX/WbssK431uThT2wpNr6VWKlvMN
	GHTwX7m87x3DOj36LUja/CDvn49aRwqqsGS9bmm0DRGlZTeSrOAeP3cD7d9wc3rlDG21yndsUgk
	f23h3e+YNz5dV4boXltR4J+/PH6Znw+rjhfKh9gHSXY2begpTEi85XQtw/S3yvzVjCia0sqYSpA
	cLNPc3bIW5SMETx/8qkNIWvan0224njvq6272wMah2j3OfkQgxYRnBCLuPuxdB39E6QKP8AFJcC
	32rU3sNHWlmXEHzcvS09UhQGMo41fKGs49G1vYC+qxFMm+6dlzhPfX7e9InBut8Sn+h/s2ggLm1
	z1TqGmQqd4Dhy4kC9dssc1ef7QOAk5QI1x18asagoCgrWQXVwYTQyqSPNfskkc0y2nxLdeMqrmv
	Mqj/EPXqFf5VH7B1BHwZvSmWIGsGmpJLkcQEDA/QTTnTtB0QkXlF6zn+jfqjTRYozoe7veeKs8J
	ukQOYyUxHm+eSCVCF/Pt82GKOQN2kww8TvOFV00PZAjVy540mrZrUtcrZWCC9nE+rmr1xnx3eHi
	N/T41iuPqiT41DpmXy61sCZFrEOLg9cYF6CX
X-Received: by 2002:a05:600c:3547:b0:4a5:cfc:1e95 with SMTP id 5b1f17b1804b1-4ac182dbb5emr2996695e9.33.1793307623068;
        Thu, 29 Oct 2026 14:00:23 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf5b27e46sm16412655e9.3.2026.10.29.14.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 14:00:22 -0700 (PDT)
Message-ID: <ca4921aa-c8aa-4f88-880a-bc717aa103d4@gmail.com>
Date: Thu, 29 Oct 2026 23:00:20 +0200
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
Subject: Re: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
 <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/10/2026 02:51, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> On 27/10/2026 03:52, Ping-Ke Shih wrote:
>>> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>>>> This series extends rtw88_pci to support an older design, like
>>>> RTL8821AE, RTL8812AE, RTL8723BE, etc.
>>>
>>> The older design is own-bit ring, and the new is read/write index ring
>>> with buffer descriptor. Can we use 'own-bit' instead of 'old' as the file
>>> name ?
>>>
>>
>> Sure, the file name is not a problem. What about the code? All the functions
>> in pci_old.c are prefixed with "rtw_pci_old", and there is rtw_pci_gen_old
>> and rtw_pci_gen_new. Should I rename all of these?
> 
> I'd prefer having consistent suffix as file name, but I have no good idea
> for the suffix. Maybe, '_ob' means 'own-bit ring'?
> 

That works for me.

Maybe I will leave the renaming for the last version of the patches,
to avoid mixing it with the other changes.

>>>> rtw88 is not without problems, but in my experience it's more reliable
>>>> with these two chips. In the 6-8 months I used this code, I observed
>>>> these problems with rtw88:
>>>>
>>>>  * The top speed is a bit lower: ~220 Mbps instead of ~300 Mbps. In the
>>>>    case of TX, the difference is due to the EDCA parameters. rtw88 uses
>>>>    the ones from mac80211 (rtw_conf_tx()), whereas rtlwifi uses its own
>>>>    "turbo" values when there are not too many non-BE packets
>>>>    (rtl8821ae_dm_check_edca_turbo()). Not sure why the RX speed is
>>>>    lower.
>>>
>>> Maybe you can try to compare them by VO or VI packets?
>>>
>>
>> Do you mean for the TX speed comparison?
> 
> Yes.
> 

I just used the turbo value 0x5ea42b from rtlwifi. With that the rtw88 TX
speed matches rtlwifi.

>>>>
>>>>    It uses RX descriptor number 511, then number 0, then it doesn't
>>>>    want to use number 1 for "a while". It raises IMR_RDU once or twice,
>>>>    and only then it moves on to number 1, 2...
>>>>
>>>>    Usually when it raises IMR_RDU there are 510 or 511 RX descriptors
>>>>    available (out of 512), so it has no excuse.
>>>>
>>>>    Once it has raised IMR_RDU the RX speed doesn't exceed 70-100 Mbps
>>>>    anymore.
>>>
>>> If driver can receive packets on time, how does it raise ISR_RDU?
>>
>> It's a mystery for me.
>>
>>> Is RX interrupt triggered on time?
>>>
>>
>> I'm not sure how to check this. I assume it is triggered on time because
>> the ring was always nearly empty when it raised IMR_RDU.
> 
> If interrupt handler can handle (ignore) "empty" RX ring , it might be harmless
> to see raised IMR_RDU, right?

It is harmless in the sense that everything keeps working, just the RX
speed is low.
