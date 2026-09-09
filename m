Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E7A472557
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 08:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942856; cv=none; b=EKZqSwLAsvIQ/IoBqWnur+nU0o2l6aQ6PXOOdclw+j9xDUsYGwIoQWzjd7InmhvbdhxnPFvQutJQwSPEM6YYFc2euXxcen/AEycpLNTF4RVNe9b3NZ75YwN+VgTXtIU3CYAjJ17mdN6dGUUqDsjyI6igaYjEZAo3m94AtsGMcYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942856; c=relaxed/simple;
	bh=qU7mEn0u8AgK07fk5azTrryDxuwTOWgwZcaobMfHW3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KW+QSjlNd1uu9AwL8k9yHuILuPGML+H8RN8u0M7ezzuYO4zP5eY3VFdYroOMCWJZfCMqJewAzJOdWHT6BC1Wn/Flj7wmkIx/PThLNhfMCcfd0ohyTjx+KrZzublVy2Hu8xF0Qk7/OBh9YsRQOtO/lDOfl0/okAEJrYynV0BQKe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hlbU8uFU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jHPRiE36; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hlbU8uFU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHPRiE36"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788942853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Ke1uJDRgBBEgE0NTHheCAK/xenfRx2mSk03niNEklQ=;
	b=hlbU8uFU7wXdfTmZsIcmo5kekW2TMzWljT8U0bESrWEJU0WSm9oXzZU2BM7KMxTAE4WHte
	GVvS6SUPwW8q1K5vr27/LZ6RJ0vKQDI0amgr8U97ygNG/s5/SKXTOTNsV7KBXe/44l/2yS
	L1OdmEEx6LInUtohowYQbJ+KOcH0klg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-R-iO51DWNnCOLgRBWLpc_g-1; Wed, 09 Sep 2026 04:34:12 -0400
X-MC-Unique: R-iO51DWNnCOLgRBWLpc_g-1
X-Mimecast-MFC-AGG-ID: R-iO51DWNnCOLgRBWLpc_g_1788942851
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4994aebe932so73147335e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 01:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788942851; x=1789547651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Ke1uJDRgBBEgE0NTHheCAK/xenfRx2mSk03niNEklQ=;
        b=jHPRiE36hwbRcjO0ekg34epvukuyLb0ndP2ZDEqel+FU0QzdcHP0sVuWI5lrYABz2h
         ijP8h3VI/6X4c4AzgTPaee/CZc4MCLsG7guXiy8R8JPuxs39Ned43+qDY2ZwG923VXyh
         m3gtTFtlVVXdR/jTTifz5wVvyDyKW9yeluUZqvqWb025OufQ5CNEpsvgbEdTBrT58tuR
         6OUcPk+PpMGL5wm7/PZZTZYL51Iif3hbNn4cxzMcF7ozH1Oc6V9VWiAoMYgbcuJ6PBZq
         lhSXd6lekpVnDEaJKvs9uZCNwdeHvgsmONz5viF9gBrfrv0nHIS8OoyVLGWPH+NpGeJk
         K5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942851; x=1789547651;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Ke1uJDRgBBEgE0NTHheCAK/xenfRx2mSk03niNEklQ=;
        b=CvTFYTrhrCzI2ckqLzxgb8LT+gg8uTb3+Xv7qZHaBLQJEaipKePZYuMl3wHrSeYe+Y
         G0fbVskYcZZHAFEKK5A7c9oLIwRlIWlRs4FeRl8RuwqcezU8l/Box8uENsdkY2f2+nFU
         3HctChVMzonWZRcxG+Hd0nABK1YujvuLOSAWuUyt/kJtobQCA+veNr8UJ0StNC9x6HV1
         e1g7xKYdOg57Xk8QUdhpzuY2bd3qzIjR/6RSxWINp0HmeegTEHwgoj/a0rxCa+gT5o4s
         VmQtwzNKv8jGAw3RQUAnjlQRZScW7NXrlvCtzl3dJGuAcw8eblsC6Mv7tKhUmp7xGlqA
         OrzQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8T1MMYGq6cqREzG036NrmBzte40q8acfsMMDwe/E0z2IF4PlmcWX1n2TBDKMS0G/di3EPPMqBn9bNzcKzbg==@vger.kernel.org
X-Gm-Message-State: AFuF++kQQ9sEqLvI9js97JmwIMCjl7Honjt4joNAGxKxBR6LQDOtONjU
	YnWFSQGUqsYT/cPs7oeZhPvS29d2gMEwhLmUfHUXMYNEWNodBY71to8K+zV3bipO+gOwPlCnH/o
	55Q0t3mgamSkQqtix1SmoJzeaKdpACd9wsyCT1pshBH1sipdY43MWtH3/EUe+jYxI6C+6
X-Gm-Gg: AYBFou3Cv1iP0f1lAGBHL0CW9exvO/4eKPSpUbRPKYyn8XAIS20rOYcUZm02tSoF4Cx
	gMeAFWKIp8K2d+RcXPYilr5HGV5bmvpLL8o2Pa1EzfVw7eOwilCmGNgHBjxkvCxv3x3YXxpkD1K
	Qtb5nyQ12OE+IgJHZvR+m4O44XEOYjcmXkwn0xwkI7B6bzZx6FvRu5yqPMH8ONPcqzLZLb/Lsiv
	XJpqG0gRwS1sbo1+ocOvbQ7dzFd4q3nVpY9aV//3bE8uVmXac6LI/TMthN72UQVR937C8ysoPP1
	b8D0q4NCnu2eJymyEM4U3m8M7SKlid6jnW1iBXtEcbasPi4K0iLFICN0f8938tb2CuY6bDwMlC0
	8hZPosGFHHPhKquzRQQKgbKGRwb67QQ2quMH2FDPRm9l0UWYrO+tIjtbYPkPXDQ6vmOWhMQHYhw
	==
X-Received: by 2002:a05:600c:8b09:b0:499:b65e:49c9 with SMTP id 5b1f17b1804b1-49cf823f57fmr706253335e9.10.1788942851184;
        Wed, 09 Sep 2026 01:34:11 -0700 (PDT)
X-Received: by 2002:a05:600c:8b09:b0:499:b65e:49c9 with SMTP id 5b1f17b1804b1-49cf823f57fmr706252595e9.10.1788942850773;
        Wed, 09 Sep 2026 01:34:10 -0700 (PDT)
Received: from [192.168.188.218] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee6023edsm515379075e9.7.2026.09.09.01.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:34:09 -0700 (PDT)
Message-ID: <565fc245-0416-420d-a37f-630b7e7ec024@redhat.com>
Date: Wed, 9 Sep 2026 10:34:08 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Johannes Berg <johannes@sipsolutions.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
 <20260908125017.0fb226c5@kernel.org>
 <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
 <80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
 <20260908132004.29176fec@kernel.org>
 <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
 <e7089219-ed02-4288-a678-660a52289e61@oss.qualcomm.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <e7089219-ed02-4288-a678-660a52289e61@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/26 2:20 AM, Jeff Johnson wrote:
> On 9/8/2026 1:27 PM, Johannes Berg wrote:
>> On Tue, 2026-09-08 at 13:20 -0700, Jakub Kicinski wrote:
>>> On Tue, 08 Sep 2026 21:57:52 +0200 Johannes Berg wrote:
>>>> On Tue, 2026-09-08 at 21:51 +0200, Johannes Berg wrote:
>>>>> On Tue, 2026-09-08 at 12:50 -0700, Jakub Kicinski wrote:  
>>>>>> On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote:  
>>>>>> Why are you sending this To: core networking maintainers.
>>>>>> This is wireless code, what do we know.
>>>>>> Drop the core maintainers and netdev@ going forward please.  
>>>>>
>>>>> They have patch 1 but I already told them a long time ago that was
>>>>> completely broken, I don't know why this is happening ...  
>>>
>>> Ah, missed the skb extension. Obvious AI slop. Fun times.
>>
>> "Look Mom, I can push a button, I'm an engineer now!"
>>
>> Do we have rules? I'm currently refusing to read anything that has an AI
>> written commit message ... at the very least.
>>
>> While I was on vacation the AI sloperators were arguing with each other
>> on the wireless list:
>> https://lore.kernel.org/linux-wireless/20260827074442.826644@enxio.de/
>>
>> Can I ban those email addresses somehow?
> Apologies for the AI-like commit messages. Those are at my prompting since I
> want these patches to be understandable by folks who may not know or
> understand the underlying details of SMD roaming so I requested they contain
> enough detail that referencing the spec should not be necessary.
> 
> AFAIK none of this code is AI generated. But it has been AI reviewed
> internally by multiple models.
> 
> /jeff

FTR, in case you intend to continue this work, skb extensions are not
for free. In fact increasing it's size may cause regression for all
workloads using them, which in turn will likely be not be acceptable.

See:

https://lore.kernel.org/netdev/73331a07-46a3-4349-98b1-b388bcd783d0@redhat.com/

/P

