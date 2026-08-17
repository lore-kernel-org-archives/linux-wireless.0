Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D9243E079
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980299; cv=none; b=aaAiwWZwxFDyDrzEmd7QGQ86Yg345S5g17fV46epqmiH5OQ9E4dPegT9gXqMT55SIglGLDGDH3NYbDcFsQtp592glChXT8BwObjaLnOrKvm7BRSM9QUqPn6m9SEDlJOo7Rif/KfOVzrjmrS17kRMI2eWXhgbiZIZDGVOayZid1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980299; c=relaxed/simple;
	bh=ymnGzJSiTE8B12J4r4Wa7SDIJa77aCJcM2b5gs/7mug=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qMionwEXERIYuze3ZcxFBtPQAR4zTxem0c6Bd76oQ7K35s4KtZMrlH61yyx+KJQqG+QGE6KN5248lTenx274oMuQhriIUbA9EJXDaDqkKXLqLXur32GfuBgvH5+VNnv4I89OGCZYf9l5McurOsgA6X6AonTKIMrVNcXlskwyKag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0KO1Qy5; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0KO1Qy5"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49978908b35so27559455e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786980296; x=1787585096; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=96u/Pec4sBv6AYxfOAghL9e3mcqgiy3uS+ZPQ6F/+ho=;
        b=L0KO1Qy5RLV++tXy7ANHp+7kNF/BEFh9WHJcPyWUgxwTR8CeDpuvUCPbMpbmCa1usO
         Krsyq5IOCDGm/zQlXm3s1vxAdzIDBHCnAVFl/kQk3wVQv6oxz0gj9yuizmwD8QQY9Qmh
         sP2hDgd6QGdMjWFjFX/Pa7JO48NQsHoasJXzPet0tHmvUPJQJokEAhLMcgrQB6iCmy+Z
         c5PGEkle+zlcTKrhxfqz/SjGR2bwb994tOWgZCYszEXqy/A4NA712o7w7U53aQ/zCzYi
         cqMq/rDSrxhu76/PG6DzdFo9YpbTkiBcCq9DgO2A1uDOa1TOsrA2uVhZg7YMXcn8CEM2
         YhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786980296; x=1787585096;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=96u/Pec4sBv6AYxfOAghL9e3mcqgiy3uS+ZPQ6F/+ho=;
        b=h1JAWqxzakZ4+Ni9jjrpCHWMTweUglbwxwaLytTsWEoAgfQsuxt7qigXNFty7ezOqz
         IxpUE/q0YEVOhchx0Lns3D/iP7jtGzhePpGdbBYds1w/hvXM0WcDGWjvIAJYzmP8oXZG
         Th4heTLYTggDzNbb1THeq7Ly7nLUIP2lzwiLhiGy/xn16c8i2BmARff2L2aj3NZil12y
         NF1M5bRfr0aYw2BorRN63dF47cORL5PMio3kSz8Ne4rFaCw9LOKOtBkFWszSR3vHt/+d
         V4qTkucBehKeahNWW1lKY8l3eDZugC9WI5vNqwB4Fq+5brSgtmLgY5M1Ia0HjyTdM6pn
         pAag==
X-Forwarded-Encrypted: i=1; AHgh+RoOHJnIsGIoJiv0R9RtQoJo4qzxZaN3XvIQyDsAXaw872O7BjzZ7pi9bgUnHAS0V2yow+El1SsVxbUKY3CG0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiVL/H4P+ghcxaCSW/OXbrTdrihFMuyRvzjUCL0arpO7zsrHGM
	kMjs2mILBMkeDXFHU5j3tH0KyeVxiE4gBCWenp/uQm3Tja3U3U+jj99yfCszJw==
X-Gm-Gg: AR+sD1239/dA8lif2W7IJ/l9R2wAHccr1sPVTqMR3MvkFphB2pQY2dDke71uqLy/S/N
	wEVXDYEuBofsoAzkxVqI3GzRGYO+3A3lQLv9plXkUKObwrZe3nwonuS9RcIIg8bn1vfjMhcPyvk
	34fPhLYRcwRCcoANLytA0vra+gLhmvwaR+dwa6LJbXthmvs8SXycJpu/7KFGcE24++ejSpJgdWN
	9WTzR6xWJIK+3ILxgJbTX6lcgI2XFzRo/sJ7Pworv2LIxz/wkXy8FUaS3Ojn7opxXO2/VifkE3B
	DhqAltsbs4nn3UvOphUDR9KrCDa9G8seL4uzNrns9mNKJRyqc5brcqc8YGwiN45pWwLCVFos+fk
	iG2Tlc25NL8vHhMBa6uwG5VXzGX2cqZJDwkH4kPfUXVhMwPzsFfqH83K8XM7FJPbngF9MpGjOCN
	rQZS8PHC08viaAaLkGGYZK/pXHU3Fd1GxDNgL+XrEPEsIS07dDRU9SLqrnmJzM9sJ+keLNLg==
X-Received: by 2002:a05:600c:3596:b0:499:8ed2:8234 with SMTP id 5b1f17b1804b1-4998ed286c1mr301714455e9.0.1786980295750;
        Mon, 17 Aug 2026 08:24:55 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996109652sm199565975e9.4.2026.08.17.08.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 08:24:55 -0700 (PDT)
Message-ID: <7fb431e3-2c7d-407f-916c-108d718ba891@gmail.com>
Date: Mon, 17 Aug 2026 18:24:53 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw89: usb: Avoid crash with dynamically
 added device ID
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <eb6870f7-79f0-4fa8-9148-5e48366d6672@gmail.com>
 <84fa3f2903224073a3c5a9514d3f082a@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <84fa3f2903224073a3c5a9514d3f082a@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/08/2026 06:38, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> Adding a device ID via sysfs causes a crash when the device is plugged
>> in, because the driver_info pointer is null.
> 
> I don't know about this before. Does it looks like?
> 
>    echo "1234 5678" | sudo tee /sys/bus/usb/drivers/my_driver/new_id
> 

Yes, like that. A few people have tried to use it recently to test new
devices and got crashes.

>>
>> Add a wrapper around rtw89_usb_probe() in each driver to check if
>> driver_info is null and provide a reasonable default value for it.
>>
>> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> 
> I'd give my acked-by in advance. But you still can consider my opinion below.
> 
>> ---
>> The PCI side has the same problem, but new device IDs are a lot less
>> likely there.
> 
> Thanks for the info.
> 
> [...]
> 
>> +static int rtw8851bu_probe(struct usb_interface *intf,
>> +                          const struct usb_device_id *id)
>> +{
>> +       const struct rtw89_driver_info *info;
>> +
>> +       if (id->driver_info)
>> +               info = (const struct rtw89_driver_info *)id->driver_info;
>> +       else
>> +               info = &rtw89_8851bu_info;
>> +
>> +       return rtw89_usb_probe(intf, info);
>> +}
>> +
> 
> If you want to simply specific probe(), here might be 
> 
> static int rtw8851bu_probe(struct usb_interface *intf,
>                            const struct usb_device_id *id)
> {
>         return rtw89_usb_probe(intf, id, &rtw89_8851bu_info);
> }
> 
> Then
> 
> int rtw89_usb_probe(struct usb_interface *intf,
>                     const struct usb_device_id *id,
>                     const struct rtw89_driver_info *default_info)
> {
>         ...
> 
>         info = (const struct rtw89_driver_info *)id->driver_info;
>         if (!info)
>                 info = default_info;
> }
> 
> 

Ah, yes, that is better.
