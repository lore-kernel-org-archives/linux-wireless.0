Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793222804;
	b=d5yDB0kx8lC/IBlrAyOynwFngz3YmkOcm2fYHAERK1q2/vMtd0K+VXo4ARR3TObtAKUO
	 otaXgnq3oalPMiJuzd81HeRyX8tysIiNqeOAF54xTszqt4WU6EdObEKsUdSQy25SyMzPn
	 dNydyXLSuKKVZ6eSnU/gCLFVT9iKDKkp6y3RvGeFR7vBvnnCEBeQPOR4JP41BNgHQWO81
	 t7VXlvB6yR1Rb3sn9gJtg4JqX/avKMLlu9tv5HDtLSVkR9VFRSpuH+ctgz+s0Gyosnihg
	 ep7VJv4myRrV1Aqd8rgeCDktD0Uwg3p0FPeFQG+DBzZTekN87pBeGoAF7qQ9lKnebcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793222804;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Wr6huVliPuTwn/RnsYqEi7OKP7UQwWoSJKJlRfpPkiw=;
	b=hy3NrnKYjOlUKKFfQvYu6rvnz8sJpdwni86hPsg1z6kcybQWYx1A/7tudG3ILAFo0uR7
	 vNrL7rxWCcOQc1Orv+aRe7vY6uXS6DbnYGuVmDzUbjvNp6IIjAmV/N7CNXWzR7fja4miT
	 hSvFfcXI6TACi0HMIX4aYnXWoRILgzfhJSrvUH/MCarcmjxuKTnTJwf/XjrIKXDaRoDzh
	 tbk+LrLcpUl3Eiay+U3H/CFjjsnDWe52zwG6pG9xJInPuHtBT9XY+P9zCx0NWYUsudOyT
	 ChDKECnaCcceHh08iNT3ZZsNVRyEfY28dlGj+IeMyv8YGDoFSAguvabiRErcaa424UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZtIycFHV;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51266606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 21:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51266606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZtIycFHV
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so11051285e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793222803; x=1793827603; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wr6huVliPuTwn/RnsYqEi7OKP7UQwWoSJKJlRfpPkiw=;
        b=ZtIycFHV0jLNlUSV42BiIC3bIM0WSdA6zm3MygOgBcKIasoowZ3RO4pFMRauUESEWe
         dIvqum63LQHNpqcqeoA9q4FwXvYou39hu6+jqpskbfNVCK2m+5MLwBziHEEv2r/9sJFE
         9Babq0PN1qGw/7+KXe1jR5NWisvXwMRsCdEF22t5a2mOipxyc7odxQx5jj5p7ye4Qorz
         kXUiPadR0bKpXF4C0EWgzCqi1xBuMP3I+AqDmlsXdyfVUezedsMydU+oaRXdvzSckk20
         Rf9uCh6bhhbI+bdJeQZEBup6mwuGjEBZGKs6O1poeC+c90jgaDZ1DLGftCjJCOGUIxU2
         LpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222803; x=1793827603;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wr6huVliPuTwn/RnsYqEi7OKP7UQwWoSJKJlRfpPkiw=;
        b=H/JDGDCZYtnwpMCrjkCPjfoB2dytgHrCfg8ZWnjmxmDD6E9BxTad8Sia4q9pb/RlmR
         0qG5IQtQpCFBcKeDyDP7N2m5kF88Pb7GGeteGIS9DrjGE1VKgXfHMebGpAgorRRmYG3d
         5B1SQtT+75UbYxI41HdELji9lw60VfktIHAaSipmkarjZ6uKFMruWaT+8f4MvWT62E+9
         ptIMMcQBwA+bXtFguk+ZeurSBuE6B/Ieg63DMkLMHqf21wPwnSzIb3FwYOpOE1RZUT87
         5kuTS0MdoGR1c7w9mDQFhKFoltzdtxOoZCGA8MLWEMrh855CCBd4XzcHugr7M4rPOUTC
         J6ng==
X-Forwarded-Encrypted: i=1; AKwUvBxjqw9kRgRiCvOMUasTMDi2tZsgAlxYDeJ7d143WT09MYM1bwYKMTLl+v2mG1VkGWjeoDb/mWHcHqiSeUJGvQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIDsbLYmCtnLWovox6mP22CM9kJ1XfvaWY4+NmoZ2hpTN31q+50
	zM/KqZ3CWypIC7lnpvLL/W51qb81ZztBroGDKRTDX3hqaI8UK6r1pBTd
X-Gm-Gg: AYBFou16EKxcdhdFq0Gkn0MVDu1xmgD91tV/VgSk96PIGBJLi5vcgwu+EK6wklHSKRq
	Yg8RQCFthzg0YomUMgJNq0nvwhM7PdH5KSGu/hIl1U8Fjwp6Ne5pUXFRp9jANi5Zu4B9d12/VnH
	pdybLRgP3Xa5SPbpucIwUiiVwkNEN4QWH6VZ0rsXroff7wcP4ZqeAKntjnPmVTfjtnxWVwyv+/3
	Mcy8chHk+DD5m8QwVTkHwam3q5n4mRKD6ICdnY85eFpjVahiR/Xg1FooR3t2nnrper2YuD7066k
	4NSAg2kGhecRF/J2vrAOdoQVKxbXyATi3zf8WWZht0vIQvdUz/NZGTqVsOGo469a9SJHHZQgasI
	3TlTeKgz36gOYZq6CACn/3m25X7ZFjzDrvuwDtIkhyYTk6D9jVSZRtbZtzCTmy084HticexfIkt
	cbfRAu8IJSeS6FX+ZJc2RfvVzOkawlGSrtEdyCQxvtKk3sBEfwfdBp3AfqmNUj1SFNSGe3MHjm0
	CPSmA0JzAyVxp4hLnSi0BX6sjhHvsB46+t/HrWJ2fcFfnn5GNlU2yak2bjLdeWF42rx4Bc98W4y
	e/+iFT3f/73xeOtoVbq/xK3n9MJK0KxJ/XFP
X-Received: by 2002:a05:600c:4e86:b0:4aa:9ef:5c81 with SMTP id 5b1f17b1804b1-4aa09ef5c8amr55005525e9.13.1793222802576;
        Wed, 28 Oct 2026 14:26:42 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94fce50a8sm57446595e9.4.2026.10.28.14.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:26:42 -0700 (PDT)
Message-ID: <00aa3f2f-001f-4368-9d00-fccbc53869b1@gmail.com>
Date: Wed, 28 Oct 2026 23:26:40 +0200
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
Subject: Re: [PATCH rtw-next 3/5] wifi: rtw88: pci: Introduce struct
 rtw_pci_gen
To: Luka Gejak <luka.gejak@linux.dev>, linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <fc308de1-a470-4890-a86a-d8936e093bd5@gmail.com>
 <3a8cd96e14c643837676fcee1d85c720b54f5377@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <3a8cd96e14c643837676fcee1d85c720b54f5377@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/10/2026 11:41, Luka Gejak wrote:
> October 24, 2026 at 1:01 AM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com> wrote:
> 
>>
>> Move a few functions into a new struct rtw_pci_gen in order to add
>> support for RTL8821AE and RTL8812AE. That is an older generation of
>> chips which handle the PCI communications differently.
>>
>> Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
>> ---
>>  [...]
> 
>>       rx_ring->r.head = head;
>> +     rx_ring->r.dma = dma;
>> +     rx_ring->r.len = len;
>> +     rx_ring->r.desc_size = desc_size;
>> +     rx_ring->r.wp = 0;
>> +     rx_ring->r.rp = 0;
> 
> In my opinion the commit message should mention why these were moved
> before the loop.
> 

Right, that's because rtw_pci_old_reset_rx_desc() needs the ring
length too.

> [...]
> 
>>  {
>> +     struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
>> +     const struct rtw_pci_gen *pci_gen = rtwpci->gen;
>> +
>>       u8 q;
> 
> The blank line before u8 q can go, so the declarations stay together.
> 

I didn't notice that.

> [...]
> 
>>  int rtw_pci_probe(struct pci_dev *pdev,
>>                 const struct pci_device_id *id)
>>  {
>> +     struct rtw_pci_info *pci_info = (struct rtw_pci_info *)id->driver_data;
> 
> I think this should be a const pointer, since the pci_info tables are
> const.

Sounds good. Although that line gets very long.

> 
> Best regards,
> Luka Gejak

