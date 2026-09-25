Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57FA3C1094
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346430; cv=none; b=EcSxqZWnpYKo8c6BjfgJX5wACsFOUk/cgoqAquiQIq0HwX9aP8e5NLz3GPOzcddC0nh50/TmNa68LKLDo6R1C4HyAVtkWT61Q6dpy89/Y1LwMsYMTefEG6uxIX7o8ATXgI29vcNcOtI81LYHZVJUrv1Cp3JIO1kDz0uAwcR2+m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346430; c=relaxed/simple;
	bh=UoAGtivm13Z/G+GS8buiXncWFubJT52dfckO7FwqDKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dG2nPktty6vkTuS5z6sjS4E18H5xd4EV7X5TTlaCR85PNk2eDphDF6pvXHmCcO9MEaQqWpFRJMWNrLa0j4tXGZjysLzr4T0PBQ/BOxo9TpexYRFVXRbign4MuumnpABLsUJIk4WtViD/d/6D/ncslHikNaqfSfgL7rkkkMcEdNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckvExvVG; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckvExvVG"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49fe8bf173aso5467445e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 07:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790346427; x=1790951227; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jO5beRzZsz868Jf5T9GMnrT2XrBUC24WMlTYLcF2ONY=;
        b=ckvExvVGxRsvHYnGnjo9H+vkbd8b1a6Xc/+gAu3l/Lst6KszXBrTB8EuUCGiZucjcm
         zEHwDdvbnG91nws8oA0DlS1DOBr891HDwrTVbsMML5B98XDrDeAcuFLBH93zoDtVdTSO
         uxSI4MdC2CS8m5NoeWvZsedFnm2+s7yC52HtlgQToBz1AJY14KXmXrIJBsJzjD8TCLpF
         rvkLDrhGbEmxTjM/QSyUvw8fBJOQ/0h6wwmomfr0WRkPLp/7uejf7YDtBJVqEDlYE2vy
         7uaiQuCk1f5dk7sSNN8XhjP71nVaSO8l4UedqsIHlABiK0SvK4aLe5QUnfwmCIiyQl/Y
         o/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790346427; x=1790951227;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jO5beRzZsz868Jf5T9GMnrT2XrBUC24WMlTYLcF2ONY=;
        b=lThM69gEp5fAQwGoIo1qYkZOkKlPNiDypp51gXDFWU0zwMdAGw4UZ7JYPlc5sEE8xu
         bdoGVL3+1rYe4isNMx3hGFJ7tGUH5zrrENciCKQkYBQSHyY9ieF+akmpgqRScET+c78q
         59+jPXlGGNrkFMLQCBmmo2C9juylzuVlip3aHxGk7aHKaI+Ry/YDCg/Sb9M8lz0z+MnS
         ROJ4sMszmF7dxyghJKewEO/Tf7xuyzT5QhgaI4BbZScSMVKo4Oo/EeTv64BpaLG3S46y
         u3NTvLJl3sbh0KsEnfVZA/jbuJbC3UH9daoGIZZCm9F015pzjfiBZkjvfMMhADHAJ0g9
         YGZg==
X-Gm-Message-State: AFuF++njK1sA55GGXP+ny2m+04iTft/spzeRqAJYxFfUgD2LngYEUxs/
	7w0xrRW69TyKd3k/IhYYfJKfqKvYnGNSLrei1SlYZTJsoCXxuxOAUsQ9eFbRzg==
X-Gm-Gg: AYBFou00Bq8BEtozUGniRZ6aVqfk2TYH3r+aYO63ykoYgaZXyhWVV8JBDDzlpE3pcd6
	T1rpvO6htVoSETf8FMHq1rphXEMrmAE63YMTFZvm395lJJpFe8CxTr44AJNt7Y8UCJlJmL9gxho
	tB5jwDXRlknLjgxN8gtHnkVRYYK3lYFSS8byZUxU9lAh+k11yiHHYr5QJOjzJS1bB+E3teRLG6t
	5BVS/gX9p6Ha9nRZJ3h78iodGKWWQvkB0IEgMPy3VdPhGPbJIQ+eALFLktnLv5Odbl+Zb66GkbM
	aUxufBphd9MJwc79tGh0i8Img6fNov0ZN0xcMAEKg/qSM2g8jx58ipswOspl6UPrP9sETpJwDV6
	gH0YHnWXpSNgHJn0FSSt9Vn27g9ZQdWNHRA5S/GGEQ7+hfKVNvcSiDThLbpvQbw8fB7gLwrxdtH
	w1lZLRRoWuR5sdqDgbKvtpRU87anu5YhzKPq7cpojbqW5TPGqQ8PKSgnirvs2Ry/JQQNMXKE2XO
	D9gew==
X-Received: by 2002:a05:600d:8643:10b0:49f:bb8a:b4ce with SMTP id 5b1f17b1804b1-49fe67bc26fmr77016705e9.28.1790346426809;
        Fri, 25 Sep 2026 07:27:06 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff43ad975sm59418545e9.13.2026.09.25.07.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 07:27:06 -0700 (PDT)
Message-ID: <cf974a83-e2f0-4315-913d-62759465fa5d@gmail.com>
Date: Fri, 25 Sep 2026 17:27:04 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-7-luka.gejak@linux.dev>
 <afb044e0aef8425880ddb24add9340ab@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <afb044e0aef8425880ddb24add9340ab@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/09/2026 04:24, Ping-Ke Shih wrote:
> Luka Gejak <luka.gejak@linux.dev> wrote:
>> Add Luka Gejak as the maintainer for the RTL8723B/RTL8723BS and
>> as designated reviewer for support in rtw88 subsystem.
>>
>> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
>> ---
>>  MAINTAINERS | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 0b42e898f4d8..7851cfcc9368 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -23007,6 +23007,13 @@ S:     Maintained
>>  F:     Documentation/devicetree/bindings/net/dsa/realtek.yaml
>>  F:     drivers/net/dsa/realtek/*
>>
>> +REALTEK RTL8723B WIRELESS DRIVER (rtw88)
>> +M:     Luka Gejak <luka.gejak@linux.dev>
>> +L:     linux-wireless@vger.kernel.org
>> +S:     Maintained
>> +F:     drivers/net/wireless/realtek/rtw88/rtw8723b*.c
>> +F:     drivers/net/wireless/realtek/rtw88/rtw8723b*.h
>> +
> 
> I think no need this entry.
> 
> Just with below 'R', the ./scripts/get_maintainer.pl with rtw88 patch can
> output your name, no?
> 
>>  REALTEK SPI-NAND
>>  M:     Chris Packham <chris.packham@alliedtelesis.co.nz>
>>  S:     Maintained
>> @@ -23027,6 +23034,7 @@ F:      drivers/net/wireless/realtek/rtlwifi/
>>
>>  REALTEK WIRELESS DRIVER (rtw88)
>>  M:     Ping-Ke Shih <pkshih@realtek.com>
>> +R:     Luka Gejak <luka.gejak@linux.dev>
>>  L:     linux-wireless@vger.kernel.org
>>  S:     Maintained
>>  T:     git https://github.com/pkshih/rtw.git
>> --
>> 2.55.0
> 
> By the way, your patch should tag rtw-next (i.e. [PATCH v5 rtw-next]).
> Otherwise, NIPA test your patches on wireless-next tree, reporting
> errors [1].
> 
> I don't know if someone is reading your patches. I'd skip v4.
> Please wait a while and send v5.

I'm reading it now. I should have some comments today or tomorrow.

> 
> [1] https://patchwork.kernel.org/user/todo/linux-wireless/?series=1172592

