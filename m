Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6C82EF653
	for <linux-wireless@vger.kernel.org>; Tue,  7 Apr 2026 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554990; cv=none; b=baHykOoR47ezHa+PkHPWzok9q++ava1voLy/XkYgUzBw2VhvXaRfQEXxIq6eT/TPKhSiJIVggHUj0CVzS7YLmZfdUhccek6AqivGYticK6SODex7Zj3nMwh3XsyHbkZfxuj9lGSQ341iNLuXMrGehnkMy3VGlLty0b9jO6GnAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554990; c=relaxed/simple;
	bh=rXk1vrh5RPO5wjshHZTTub1t/tM8ewfb9YcKvn+zw+s=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=dJHdHtv8F6MgUIK35Vhink3BSWtsYlpV74gZdQ1nydm7zhMoSY/dJ4eyawsL8C2CeAub5XR1W0R9gfP2rIqRbyuB6BY5vr082/DgqWY/tJkVE4GFngkLWsZ9dr9IU96F8AJ8a0N46Fnub/OQxznAQ5eF7GEUH2YvQ6brcEBZQ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nG6B8tdI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nG6B8tdI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfe71e5d3so4237553f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2026 02:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775554987; x=1776159787; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHAjC1BSiOb814N0275KqQhW8j+aFugf5PShJf7FEDg=;
        b=nG6B8tdIEhUNh/F1iVbHkNQSE5fxCArFV/xCQPMImydUt/3zr6KqYlptc13uOQjkXn
         Iqm2eykPGtPJm7bbfE/5pIk4pPUqvz8FnpmuJuJZUwiVkMfWj03qCRGuWJbdZbtTHSys
         SlIsFO8THioap+e+VKZR/sXkH/XsBynCDmowtpMzDq0bkGMCQ+YHJxhMIerbJcGMu0aB
         W0nB0asKKC+LCMGDeoFKInzYrSlFY57d7BVwQh83WENRzhMaInFYbj4a9yPr+lVWxvzL
         mjd3JzaTvfud6ClzgrxRzExEFTfJyEi9LbjK5KptFUBTQb9C/fDE28jYOziSEv2y3Erm
         YBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775554987; x=1776159787;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FHAjC1BSiOb814N0275KqQhW8j+aFugf5PShJf7FEDg=;
        b=SNmfgR78vS8IU7joimxq75hGt92xRNtxuHrqeNonVJUfgt3VgDGVUuG6U3UuE7k6PD
         67nnu8BdT35DBWisOkH+xO5mw7UlgMX5hvUanaq7wyxQ3FVPmZNC5TO3zxMv3SE44TNZ
         S4rcXClJQuUFQcamw8/LitABQwrLkYkD+YwVaU6lwuagKomOe3LWxOB9JixAL9BgN/Va
         nvZ18Ns8/ZstdARUYQkn96EKKevmYMzm4MpDU1Rlnq5eQaJUVSUNvS5ohhFO3UXADA11
         UdlXGbdgAYS5wa6+aU17aodmLKH4U+or4BzgLWec1TqtMAKmTw+rY2IxLCRY+ZER9zxG
         vc4Q==
X-Gm-Message-State: AOJu0Yy/sUWJjB3ooN1yjXyIFq9UAsVn+vud14LaYf4LXLYDbEnaJlSA
	kpBlZOxk5zfSTHlUVQOw9AHmAEaQOAJ/HKN3lAaRRi5c1ACD4BqwF66d
X-Gm-Gg: AeBDieustDJPwiQeiFP6ePUQHYztha3eYqcj+k7tyLVYD1bvuHF5NJoPVbaRJoBQ8zq
	K7EPRzktkOk8yngcANzVyXJ9TzGSKPtFklHJ+KJ39dIaq5MbG7vWULIJq2FGj9zjIisdkg0kv+V
	82VJqM+XCt23F4qGjrkmimEzStZD9W7LLRNAup4UY9DnEP5tYfY2ipNk/ueM0ERN+0VYERWiIEg
	yRFHQFTVKVXFhkOY0vUN+fbBdAe4+ZCqRTx1s8Ek4cSbfB5tKIahfqss8MHtAqTFFLEn7Ihe4jN
	DhS14nyB2i2pqYR1Tzd5VIACddPN4NyNUKpwu+D+2OX84jXXx13Jt7y9GlIfc2lPzb5iMG2g0Lg
	ePdR6o6t/PdoWEpgeaqM5x6zd9WlyKavRARAM0U8WZPsG3ZSZo8XYHz8yfB4ZeYfDl1neuW3QZr
	BU5SUHPjbudUV0hQSE0zJ3MXTUTtXcXfPdcrzzur5FLg==
X-Received: by 2002:a5d:584b:0:b0:439:b791:f920 with SMTP id ffacd0b85a97d-43d2927fccdmr24084487f8f.17.1775554987110;
        Tue, 07 Apr 2026 02:43:07 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e56fesm46769190f8f.27.2026.04.07.02.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 02:43:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Apr 2026 11:43:06 +0200
Message-Id: <DHMTPO1TBBP7.TBGIZJFOBWZ3@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH ath-next v6] wifi: ath12k: avoid dynamic alloc when
 parsing wmi tb
From: "Nicolas Escande" <nico.escande@gmail.com>
To: "Rameshkumar Sundaram" <rameshkumar.sundaram@oss.qualcomm.com>, "Nicolas
 Escande" <nico.escande@gmail.com>, <ath12k@lists.infradead.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260403142841.1105780-1-nico.escande@gmail.com>
 <54887455-3ae5-4dc9-a0cf-80726a1d8465@oss.qualcomm.com>
In-Reply-To: <54887455-3ae5-4dc9-a0cf-80726a1d8465@oss.qualcomm.com>

On Sat Apr 4, 2026 at 11:48 AM CEST, Rameshkumar Sundaram wrote:
[...]
>> @@ -134,6 +136,10 @@ struct wmi_pdev_set_obss_bitmap_arg {
>>   	const char *label;
>>   };
>>  =20
>> +static DEFINE_MUTEX(ath12k_wmi_mutex);
>> +static refcount_t ath12k_wmi_refcount =3D REFCOUNT_INIT(0);
>> +static void __percpu *ath12k_wmi_tb =3D NULL;
>
> Checkpatch complains:
> drivers/net/wireless/ath/ath12k/wmi.c:141: do not initialise statics to N=
ULL
I forgot to run checkpatch on this one.
>
>> +
>>   static const struct ath12k_wmi_tlv_policy ath12k_wmi_tlv_policies[] =
=3D {
>>   	[WMI_TAG_ARRAY_BYTE] =3D { .min_len =3D 0 },
>>   	[WMI_TAG_ARRAY_UINT32] =3D { .min_len =3D 0 },
[...]
>> @@ -11239,3 +11150,28 @@ int ath12k_wmi_send_mlo_link_set_active_cmd(str=
uct ath12k_base *ab,
>>   	dev_kfree_skb(skb);
>>   	return ret;
>>   }
>> +
>> +int ath12k_wmi_alloc(void)
>> +{
>> +	guard(mutex)(&ath12k_wmi_mutex);
>> +
>> +	if (!ath12k_wmi_tb) {
>> +		ath12k_wmi_tb =3D __alloc_percpu(WMI_TAG_MAX * sizeof(void *),
>> +					       __alignof__(void *));
>> +		if (!ath12k_wmi_tb)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	refcount_inc(&ath12k_wmi_refcount);
>
> With ath12k_wmi_refcount initialized to zero, this will trigger addition=
=20
> on 0 - use-after-free warning in refcount.
Arf, that a bummer.
>
> We may have to do refcount_set(&ath12k_wmi_refcount, 1); on tb alloc.
>
It seems thats the best way to go forward indeed.
>
>> +	return 0;
>> +}
>> +
>> +void ath12k_wmi_free(void)
>> +{
>> +	guard(mutex)(&ath12k_wmi_mutex);
>> +
>> +	if (refcount_dec_and_test(&ath12k_wmi_refcount)) {
>> +		free_percpu(ath12k_wmi_tb);
>> +		ath12k_wmi_tb =3D NULL;
>> +	}
>> +}
