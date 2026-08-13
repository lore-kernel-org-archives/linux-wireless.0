Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BA0381B01
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786646085; cv=none; b=EmJqV9AKGsILFX5OwKopYOAKVKSg7j6izLFAirGrB3JbKajc+FcWx4CW2bpZeBS6k3ly2EXZk1llKduOuh5YOzvf9VvN1Sy5cuRNP4nm3t41Ihn4i5/r2F3gxnELA9N740DL7PLGwOztEXl6CQrglfqPyQL8E5fGYUw8lyrRZ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786646085; c=relaxed/simple;
	bh=DHFZ2TaJOgchJ5PIo/X8b3TeXaT3TPk70S1lgfWB3Xw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GoT8p0FQDaqVpqUSrIbPgpFc4m6kA2PPPou8bBVqbTX+JNOmYRxYyyfvrSAA+fQ5Qz/K7IQjNZysEJ12Yf+UbvRI+p/RYYVtX5Jm1jOlmnf1sCjNWPN6cN798uVAo0EFo/P/nQhEFAKQUtvD8tOTzikbBSFPuOUoImuMeDOT77Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SBPNCcEY; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBPNCcEY"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so2167175e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 11:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786646083; x=1787250883; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VhF0Xbpe0vf9q5WFf1uUEKSaWLORxrvQ33nYU/aKtAk=;
        b=SBPNCcEY1l/Xq7vpa1sHnjpCP6mRoPhbeoQz8QJH3aGStEU/7uhzykMss3B5G1QnV7
         4BKCbPJ2cmMFDWSDqCCsw9nJb7VBH7UbyPgsvF0nrqsaJjsYN6T9kyeHbBcD9tzakXKF
         rEg9rRYqIzg59oKC2T2TSGCZKDvBnSsTQmHbONuHReCAkYJO6bNTXh65hmgFAOwkD5KM
         8qvb3680swrschS0m9+Q0WWs1Hdlsz0akansQjqRbwNIaY4FCYOhJ2uzs4QLloAiLtU6
         wHmADzlDdrEJ2/xMgAeghqo0BLbsfdPDOY0dIeFVo29sGUmwo5ft9lPs8e4azKCf2+KB
         GfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786646083; x=1787250883;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VhF0Xbpe0vf9q5WFf1uUEKSaWLORxrvQ33nYU/aKtAk=;
        b=oG8G0KPr/iXaibdZsnnS/3jAeuLqlHsy0wRrrIFkArqd6Sy+1M5TLtH/izBo4NW62K
         LYmmTDTjz8pyS7Fds5gTubdGMvL/xJxpHKXN4/cS9pzwpwvcfsB5aZlU3NvgccsLd1ao
         PeHqiEzB9Rn9AcDq8askdQOOEpKMs+i2uk8NmBELcK5ZLZ5Dr4n/jPxT/8sbNxGERABz
         ote7Mulbe/p79Ow+gsVFxblcJ0KAxv25RuAQIqbHctLLKIKtG7Y7gLvBK56Putid1daf
         B0CTrNra3cfc8dwf7rOLdt4CGkj21j46lE/okiiMOvJgI4G+TDucCUPVYZ3v1WJUVzwx
         yobg==
X-Forwarded-Encrypted: i=1; AHgh+RpsHtL/knN2TmFf5VVweipD1sx4bts1RfjDnv4XdKwYWZSsjwDwhxDyFQ8voIGTFVy5RJXgxAUahcYnbqfNfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YypqMLCD1ZrorwLCM/DoEjQ4eFy3q4jtXHRkQa8bnvkB2Or11tQ
	rsdPiYVb7rrbgKbP6x7fCgR3FAA65QlHrCrbW4mDErkudPyu+yOX9PA3
X-Gm-Gg: AR+sD12UgEmOmusBDROgdMd01VlQe0HVb3XjVlXbBKNGXRQJ612HoVv1LYTar3xYMQy
	zgnoJv01FL0elxFuozqVX+rrguHLFrFlGCTV+fj0ku0IMWaf9CRUHo+CT7ketX6EuQVOCymeZev
	tmHKTSCguvMKFHPX8lH3siW0mh0zzJ9dHylW3fRGSLKLtZpVRgTguei/BaCAhykQqIRN/jZjHyA
	1CWQZ1l4tdjyMLWd5WAZNv9TRyNUDHG8XwN+qrB83Yzd1pNz+QZQ1wxH77yEJIGw5gBuXVFP5eY
	Osq6m6g52VqHGwrbdO/ZQe8KbFDoyT2fRxBqjUrv7iQsgnpwCGM7daLJH8PWQTpdACWMTRzXYGi
	bYykBBfsCFI2jlUymTJpdssoZcOsAdT96eMmjcBWz+8zlJCsirVHHzXyAP3Peq7o5ByQk8QJocn
	/8xibkv+Q088RwFWlNga7QzacpCasn3XgJn3k35EIa6BxprmS92YVBpAqgF82cD/YB/WJKPQ==
X-Received: by 2002:a05:600c:6289:b0:499:84fe:ca8c with SMTP id 5b1f17b1804b1-499879332e1mr5414995e9.5.1786646082473;
        Thu, 13 Aug 2026 11:34:42 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2c46besm1159536f8f.31.2026.08.13.11.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 11:34:42 -0700 (PDT)
Message-ID: <12eaffd0-9d0f-44bd-8163-d05b6a3df611@gmail.com>
Date: Thu, 13 Aug 2026 21:34:39 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via
 the AC queues
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mehmet Fide <mehmet.fide@screeningeagle.com>
References: <4bb13bf2-8588-4235-a1ec-b82e6668c982@gmail.com>
 <20260813155252.2265589-1-mehmet.fide@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260813155252.2265589-1-mehmet.fide@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/08/2026 18:52, Mehmet Fide wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> Hello Bitterblue,
> 
>> I wonder if you can reproduce this problem with kernel 6.5? It looks
>> like commit 076f786a0ae1 ("wifi: rtw88: Fix AP mode incorrect DTIM
>> behavior") from 6.5 was supposed to fix the exact same problem.
>> This is also the commit which introduced the code you are now removing.
> 
> Thanks, I was not aware of that commit, and you are right that my patch
> reverts exactly the usb.c hunk of it; the MORE_DATA and HGQMD parts
> stay. I will say that in the commit message in a v2.
> 
> I did not run 6.5 and cannot easily on this hardware, the board support
> we run starts at 6.12. I do not think it would add information though:
> the code from 076f786a0ae1 is unchanged between 6.5 and the 6.12.103 I
> tested, and it was demonstrably engaged while the AP was wedged. In a
> register snapshot taken in that state REG_TCR reads 0x00303030, so
> BIT_TCR_UPDATE_HGQMD was set. Still, the high queue drained at about 14
> frames a second, roughly 3 frames per DTIM at beacon interval 100 and
> dtim_period 2, measured over minutes from the URB submit/complete
> counters, while several hundred frames sat queued. So at least on
> RTL8822BU the burst fetch does not happen even with that fix active.
> RTL8821CU behaves the same, measured today on the same bench with only
> the dongle swapped: stock fails the reconnect test 0/3 with the "error
> beacon valid" messages appearing, and passes 5/5 with none once the bmc
> routing is reverted. RTL8822BU is 0/5 stock and 10/10 with the revert.
> 
> I also think the two problems are different. 076f786a0ae1 addresses the
> hardware fetching one buffered packet per DTIM instead of the whole
> burst. What we hit is sustained inflow above any DTIM-paced outflow: on
> USB the high queue shares the single bulk-out endpoint and the page
> pool with the beacon and H2C queues, so once the pool is exhausted
> (measured: 14 of 1803 pages left) the beacon reserved-page download
> fails ("error beacon valid"), the TIM stops updating, and the firmware
> never releases the burst, which closes the loop and no station can
> associate again.
> 
> If you would rather keep the after-DTIM delivery for stations in power
> save, I am happy to test an alternative, for example routing bmc to the
> high queue only while a station is actually in PS, or a depth cap on
> the high queue. On this hardware the plain AC-queue routing is what I
> could verify.
> 
> Thanks,
> Mehmet

Could you check what the official driver is doing in the same situation?

https://github.com/morrownr/88x2bu-20210702
