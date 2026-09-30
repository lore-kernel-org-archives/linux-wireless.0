Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31573E7BC4
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804813; cv=none; b=Yve9fg23tjf51DfIkC+YZpTlrVK/Ty2Lo01YIQl5k4428/xmIdoMshg/j1DkGKuQh8aVmWgmfZGKjSsZQH0aD/Wly0QaoPRNuGuY5B1dC5oDkTvqNuePU/WLMUMCf9LGo8ZPXnnTFN7K9Ww4XVesaVADatJfZ6NA9tDooZnPn+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804813; c=relaxed/simple;
	bh=4vB5pZ+vDsOwv7LEsW5BbV0+5k8Loaeqo9BFNQkcgj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2OXv8VkbYKEt4D1cO1OTr2UQaAAdaXZHtMMUR9o3WMT8m1HN1J+kUh+v4YLUpZU/5H0gYEcPN1Apzm0r8TJENmlhL+SHbE3vtq7585NlEzMN0Rc1iKRUvbfBn6r1YMV/VU2nT89fI6p4ZZRiRL/5O4jvr0+xDu0CHV8+4ygtPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zelnj7jD; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zelnj7jD"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so44501965e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790804810; x=1791409610; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o8F0B9o5+5M0c+UxYik91VjRVJghzAaWSkO19sfhWyU=;
        b=Zelnj7jDysImilWjrq+TyjX8Zey9LXjwNIRrE1uzr9VGCWxJd6hUkpqc6qTLKUpjZa
         ixwFOKzDVMoNOE1LdBsYi2sqjhnIW4pzake+LzOBpPNQ80Tgwnp2cHzzgKwAx6b5wWjZ
         9ySbvUn0UYtv9m+zcgU0WncM5rgjfYeVeqq+X5GkCRpMfGWU5k8g550O+lYCsZXMBF5n
         IIbhXisA+T7Ax9BGLZnpRWVVn3gXa8GcKOfyDZRSEo5OU5FLZ/ggu65qNNMLqTppfcrw
         zsBWAXI0FgaQS7K/gaz67NbUmXHisq7K4tpfa/3RTYn713UTzWW1Yop5zqt2A/YJ7gBx
         nE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790804810; x=1791409610;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o8F0B9o5+5M0c+UxYik91VjRVJghzAaWSkO19sfhWyU=;
        b=SbObcd/8Upkjo/8PQOQCnnyUOgV1PX3Ea4kntOM995v3/m21Ii4/HNACyqKVVNEJzP
         Kbd5PQI+zqKm30WGtyyuZX31P+Zl3ikc0M2cyNcjVvxOp2B8vstERD+bKv1UoCAsGpSC
         EwpmGO8nMn3adXEKJVIKC3sk+j7Wg19WEspQNEl8DG0mBW824jnoUmObYjZsHY2bOspx
         QcRC4bTEggK0rOIWEKVkSAvXFvQWM2BiEWMmK6S6qS/8L0SaOAn3PdWDTsnNlEXbq2cO
         p5hUjC2mBU4a9oLAug/1q7h5yN66pEo/YyphQoKuFTo8Q16i82qIn9HSk7yjbQEbgjpr
         Rs6w==
X-Gm-Message-State: AFuF++ntFzvGqaK2y+L9x543uqJZrT84S2WNKWXra1W4I0CCgcDe1sK3
	SO/ZglzAlHDJaQvdIcbhWvadVRUIfDPp2AZD7mHPS2AvDBdDfU2xbIeU
X-Gm-Gg: AYBFou3HFHTffP1gYafjwGpJxRWYLiPJJbSGPUwmqwzfMG6OoSbgMRMFGHUqH/AvG7s
	kHXUlWEOl46LLLdw5mWQrEy8otYrMxXZpgPo5WfpoWFzo2oFibcGtLo/IcVU9CtTfU/8P4j2+20
	W3S533HVimjebSlUP65mDEgT9jbLGhRXrr/oBtwBCnSdtMM/Ro2iT7QwO+O3y/umSLSxS+Fxegg
	X8hFrWGtFkRlAT4zhSw29VeGWdjEv0I7HqeWGOfGPKMiBLs2Fdj8iXeYTx11v/To8+p1P4j17gg
	AxFHoF+caHGIoooYX+tIj9XLfjvRHI99G8QcFQmGb+wTGV3b30qbb58w9FuGO0Gwizh4CtXNb3s
	a3w3MpooS6eIRiEJdQy0DSTvVn76GzXWURVapMQ2aPDujNklhLL8c3J6muZMDwobl62Ppnfun5c
	3GDxie6j8qWhMVpWNr81PDSVVooJAmrgx+l0I223f1OK7KlOj3Rg52l2nv6dvnAdhhAvTCJAMI2
	oVnUg==
X-Received: by 2002:a05:600c:4f56:b0:49e:74b6:740f with SMTP id 5b1f17b1804b1-4a01b0079cdmr60549185e9.17.1790804809753;
        Wed, 30 Sep 2026 14:46:49 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f99a96fsm14092065e9.13.2026.09.30.14.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 14:46:49 -0700 (PDT)
Message-ID: <0f32b66a-c5fe-407a-92ff-387c3fe39e64@gmail.com>
Date: Thu, 1 Oct 2026 00:46:47 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 rtw-next 2/7] wifi: rtw88: assign the RCR per chip in
 rtw_core_init
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-3-luka.gejak@linux.dev>
 <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>
 <3c53130d1d4738a9b3173806264fc1d0b5682072@linux.dev>
 <a6ea2df9-b2c9-4417-ade4-f3947f36d139@gmail.com>
 <5b31fdb4474eea9b9403fc6ff466994b62a79fd3@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <5b31fdb4474eea9b9403fc6ff466994b62a79fd3@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/10/2026 00:29, Luka Gejak wrote:
> September 30, 2026 at 23:27, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mailto:rtl8821cerfe2@gmail.com?to=%22Bitterblue%20Smith%22%20%3Crtl8821cerfe2%40gmail.com%3E > wrote:
> 
> 
>>
>> On 30/09/2026 23:36, Luka Gejak wrote:
>>
>>>
>>> September 30, 2026 at 20:03, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mailto:rtl8821cerfe2@gmail.com?to=%22Bitterblue%20Smith%22%20%3Crtl8821cerfe2%40gmail.com%3E > wrote:
>>>  
>>>  
>>>
>>>>
>>>> On 30/09/2026 12:15, Luka Gejak wrote:
>>>>
>>>  The receive control word is the same for every chip today. The generic
>>>  default is written in rtw_core_init(), so a chip that needs a different
>>>  value has to overwrite it afterwards, in its own init path, far away
>>>  from where the default is decided.
>>>
>>>>
>>>> I still don't understand why RTL8723B(S) would need a different value.
>>>>
>>>  
>>>  Because 0x700060ce is what the vendor driver leaves in REG_RCR for this
>>>  chip, and it is what rtw8723x_mac_init() already writes for it. I have
>>>  both from tracing this card: a register dump at the end of
>>>  rtl8723bs_hal_init prints RCR=0x700060ce, and the same dump in rtw88
>>>  matched it field for field.
>>>  
>>>  The default is a different filter. It sets BIT_PKTCTL_DLEN, which the
>>>  8723B vendor HAL and rtlwifi's rtl8723be never set, and it clears
>>>  BIT_AMF, BIT_CBSSID_DATA and BIT_CBSSID_BCN, which the vendor value
>>>  sets. Four bits in total.
>>>
>> It will work fine...
>>
> 
> Want me to drop the patch?

Yes. If you check the vendor drivers for the other chips,
they're all in the same situation.

> 
>>>
>>> That value does not survive rtw_core_start(), which writes REG_RCR from
>>>  hal.rcr after power_on. The field is what keeps it. BIT_APP_FCS is the only
>>>  bit added on top, because rtw88 advertises RX_INCLUDES_FCS.
>>>  
>>>  Best regards,
>>>  Luka Gejak
>>>
>>

