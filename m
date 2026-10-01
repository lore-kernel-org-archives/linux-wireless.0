Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC752CCD2
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790877508; cv=none; b=g89WRRna86BzW/6cxtowXgLO0wQsQQfUkzkTPAmtkZNMTD7ZByQkI4EjWH+QwbnFsGLtriWw7zKFekK03DHDAjz4PHfi2Dd7D0NiFCTiDTWWWNtgLbcGcmDK5RRXtuHNMRNe1j8iy8RaFOn4kH/HQUUiHceyGl3G8dzpQClQjnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790877508; c=relaxed/simple;
	bh=aYQwvqesRITkn45GdErRdgxTXT5bGX6VC0HwWes1Xjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qENF1avzsiZatcE1SrB5ufOb/k7zSQfNf/si+ubU//Q5V2JKdrz2ZCun+I2vX4vTYhcsJfegm0L+aYcJaON00YNE2GV2XxcBeYTdzuv1yUqpK4n9MxrIUPg1R9Swfqp90+UzWnJi8HmBHtIf0T1iRuNnOmq9fVqF4Js4F2tvN3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ryYX2GGM; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ryYX2GGM"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6c0fce17so37723005e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 10:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790877495; x=1791482295; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aifPKr+BaJCTqJnaa9j6E+AJWrwxGoIiSlLrPBRLwXc=;
        b=ryYX2GGMHy/SXEhgYB12vuHDL8NzTlrFsNo1maCGkXRM+jwVmzMBS2ZWEtL79K3brk
         9nBkTudEiqvHE33GQc26jOCPOw9QyvaSstWd8gSwYCmHogz+yvw0MMP3LfiQKoYqiHEI
         tKRnE6Q0hA6ocl3FTbP08HLSOddIvyEHwGwW4foaXlS8ueTuEvYDaHm0W5jMTXf/qDcx
         p3Yy0yCq7kZuooiOAvntBZhO6fxr/QQbvKg/DoQeZPnodO5nFacMVJub4mhp1DmRg+Az
         rvpfjBSmRcOaleN7uGfp8On6WQ42nB4ahF1CZklVr/L2Olg7JTDk3rEweszZ3Tz2uD9b
         uSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790877495; x=1791482295;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aifPKr+BaJCTqJnaa9j6E+AJWrwxGoIiSlLrPBRLwXc=;
        b=gG4h2SzuSHinAK1qwWLX5LKrLvKjLmUJXzF/C20yrWBGFj8pe4FR4wvvL0Ay/gozAs
         EkaqWGua1PHTX4dkEz2oaRGCg4FNXSifQT0cIeoTgJPUnD9tz0WzslSGdMsBwbhCVThh
         iJncGBTeKrH+oSolJtaJZvxsCt6rGLn+kYFHAqgtPOP24z8wQ7nGqubQTQmqIBgUTw7a
         nbUMye1naUAacT29WWwJSSxK/20dwW4v+l/UvVFFVL9LJalic5aL3HIqHcARqUH0sdIQ
         KIbUDMdl4UXpcjlwmEG5OVEMBfGHZaj8MT6czbBW8+xJ32wmb5okpYm+E5uj4VkSNOWk
         aQGQ==
X-Gm-Message-State: AFuF++mGiD8GmQP4PCn2vNilhEBtIF2PbpGn32zynyYcyT2opQ1mgvrI
	3ki8fOPm/1vv5vo9w+ygRbeQNILf5Gn6jHS02vSCgbMd39EYLwkdtbPi
X-Gm-Gg: AYBFou3DzMnlaS0av3DraDoeBF8W6vIXh5zrs2bLj2fZrwa6CBoEN/Bj9cd8ym443Hb
	H4PazxG5MZNRM4SB6pjPK7mALRRsc2YGMbfPZsy+cH+DyKoYx6hqvs6GV5UNJBoStxKBDmNDqpe
	Um/RN81Bxe5rjBRXQZPhZOq8ajrT8FW1Pj8NNSZ1Q8phyYa6HsPY5vu4RPBFJ14PV9wcV7D6aNI
	nO/jMSMkRZebj48ujbD6ByktIxxh+CsSY3vN/6qrF1pCv17YCJgXpLq81RXOp4pu/fCstrHHBMv
	6WdAFPFCvJXmWWzVbUW+tIiTMynCwlbWYJXDVsBxjDhL55ep9QgaAbVzIacuYGzkQ9Bw7ky9+9A
	f4H1LaECNQfu8nPZTAlwufbRUutctBOGzjs1lh5smSL2gM68Q+bqhR00I/wW/pYv1lNdsJrkl04
	VsO3K4SzAGauJePmq/nChw41oQ9IZEbZh9qywTs1vpXkAd/BN84jpg5hl0myMMPGF5GST8Dkk3B
	528Myd2yiIpJMNeh+EJhQIizCsAUbMtt/SBVUpY72nSV+SI0B4tp74LGXFIO1fNbBvxuzsoPGU9
	BQ==
X-Received: by 2002:a05:600c:34c7:b0:49e:7862:c09e with SMTP id 5b1f17b1804b1-4a0276b5cdemr6573155e9.14.1790877494854;
        Thu, 01 Oct 2026 10:58:14 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027740a2fsm8098545e9.13.2026.10.01.10.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 10:58:14 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xCL0x-00000000Jg3-0F0L;
	Thu, 01 Oct 2026 19:58:13 +0200
Message-ID: <e550f231-87cd-4220-a17e-d0288516ef9e@gmail.com>
Date: Thu, 1 Oct 2026 19:58:13 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] wifi: carl9170: NUL terminate string in debugfs
To: Dan Carpenter <error27@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <cover.1790839793.git.error27@gmail.com>
 <674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com>
Content-Language: de-DE, en-US
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/26 9:37 AM, Dan Carpenter wrote:
> The "buf" buffer comes from the user.  We use it to store a number or
> two so it doesn't need to be large.  It gets passed to sscanf() in the
> write functions such as carl9170_debugfs_erp_write().  Ensure that
> buffer is NUL terminated.
> 
> This is debugfs so it's root only.

Sure.
> 
> Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/ath/carl9170/debug.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
> index 0498df2a2160..bc6c8e0b1d16 100644
> --- a/drivers/net/wireless/ath/carl9170/debug.c
> +++ b/drivers/net/wireless/ath/carl9170/debug.c
> @@ -119,7 +119,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
>   	if (!count)
>   		return 0;
>   
> -	if (count > PAGE_SIZE)
> +	if (count >= PAGE_SIZE)
heh. It's unnecessary to change this for the max. two numbers we get.
But I'm curious if this is a change that an AI tool added?

But yeah, it's still fine.

>   		return -E2BIG;
>   
>   	ar = file->private_data;
> @@ -131,7 +131,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
>   	if (!dfops->write)
>   		return -ENOSYS;
>   
> -	buf = vmalloc(count);
> +	buf = vmalloc(count + 1);

I think there's also a vzalloc...

>   	if (!buf)
>   		return -ENOMEM;
>   
> @@ -139,6 +139,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
>   		err = -EFAULT;
>   		goto out_free;
>   	}
> +	buf[count] = '\0';
which would eliminate that. But yeah, this is fine as well.

>   
>   	if (mutex_trylock(&ar->mutex) == 0) {
>   		err = -EAGAIN;

