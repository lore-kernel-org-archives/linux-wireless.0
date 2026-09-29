Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC457513554
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 11:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790681324; cv=none; b=CHlAIvxTJ3Xz7s+gmdS1APA3StLhevJ52TG1u5IJEktsgt8lVaZhebOQttZW0uI1e+wl8L7TG7tSrLCGTzS2UWJPwMjJ4NHE/e27ohMMtirp6YqcU8iUOLsQ9THGm4zJk6ZFPhJ8qwL9Uzb0GcHfFxJ/6rua0k6u5XTBWHwEY90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790681324; c=relaxed/simple;
	bh=ZBa3gaUTaTOyPuN/5ooC6LTU4/MdZhzDpQ3MTFuSS2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShigzLwuSdGheXYcueB6ytiruEuj7skWVmQIRRwAO3rqDbDh58KUdrBk2CUA+201Fcrv8TWVXF/czEtIlU0TfCjhWudAnI9AIpAF/P557B9Qk8o5TcHGU2MdPGKy/Ytuy/q8VNmRU1ToefMeH3EYqBT4DGyBRSAq1aQgP27IiV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqYCwuKd; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqYCwuKd"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so25677675e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 04:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790681321; x=1791286121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pV97q4mybuw1DI03bfEUmgOfqE6zUAQHLrZA1UwEz5s=;
        b=XqYCwuKdjA56DCpW1V4ZPw4gLLoP96ECM8RJ4YbHAajpmIWGbsIFZGEvV6MgAgDq0d
         5KPxbzaDA8JC93xCNnWJvfNc4l0NN6w8wQQEwFRNV5/17fft7wz5vVzIn6YcJbCjf59U
         /w1yRhNNgThYxxJX08cXl5OZza4y642ysewJE4wVyMVuMfCJHv4S6gc/p+fSruxQULZW
         aACuM3W8/OwbH+8dO2F9kMf+oiYnEdzWkQNPo3HXf4evN2xnkDQ1dxDgXZQtQ9ASDXna
         dZBOGdSaOoPstPwIWzhvpoIiif2QnGE+FuXPIHcmHBHDUmEi5hp8260R61YqKSn59Gt2
         Jbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790681321; x=1791286121;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pV97q4mybuw1DI03bfEUmgOfqE6zUAQHLrZA1UwEz5s=;
        b=j7xDgnAGSH3/ZBNA3pWe95qSLG/LHxnKR9kljvzjbw7w3rw5Hjs4S1q6p/jAv1NpVO
         j7VV11yljGQG05z5GXCVPliDGpz69CRxv77dtF5dDOyIopLV9qEtyRCKqwS/bosD/RWO
         y9d2gkxEdFF00jlGZ6V/F63p28vNwUUtjzIZYL655LSbFZiyLPcAqQPtuMz34UsZ9f/R
         T/tUsFxnA8LW7gAcXIMdoahWQOacH13yQwY6rlv0d7oqYpw4e8sCTI5hnzxwr3HlBDnS
         uZMkun8xNSOZIrWV8DVrmPtUT7K7+R7w3C+LL0iCSGgkO06jvA5YLVXfK2QgkKj2iBZ7
         eyNQ==
X-Gm-Message-State: AFuF++nV7qazgCWd3c4sS4F8LLZ+T4Sn03iC4YyXJYBMUefW0Vyg/Xd8
	q2Ub+fmWPS53vnhAzn2YOOnQOX4rZ988w10z8C6Xdmj8rbPodMJy9A4g
X-Gm-Gg: AYBFou2ESzp3fkmbTpi0JEnpS2IALvepcahTHojRnRfnf4/r5jExvNEIkb5pXNxEqRW
	GOY2FBjE2rC/Xzu9Bf9SjtWhNbqOvwesNlZghHHEaA/dgWnLvEXmCCKEyg/U1jw0d7/TZCvBSxR
	pydO6WXHkDjyQUPjU6Ct48m6omHYvCcfMPb3LI7sSRG1xCbzzQY1aiM0I4AZjNHGPFrld12Zv/P
	UTQHRsrbqwt33EecrVU9UQw+F9KGPSDfCbqTtLr1ZoSFy/Gn5HDnutXd+IvRF6HrKFJ3RTOwxre
	O2EsVTSxdYBrpbfRB5HM6HBfElQkHwXdpNeQDQuGbQPdfLbAG0BcfFZithO8WPKWuibFU2hSxG1
	UTUVf3s6dvIm5d+xa1ToI/oAWIbeSFzWr8ARTy+ql9MqJVh+DV/f5OZe3iZFltmtGSpGM70NaFl
	TxsVFaroi86tV8lv6IPDrPCT5HcCbxe8z6y5ev5z+qbiikGAjityaJYgPMPyR7nY/F
X-Received: by 2002:a05:600c:138f:b0:49f:cbf3:551c with SMTP id 5b1f17b1804b1-49fe66cc5camr263078945e9.12.1790681320689;
        Tue, 29 Sep 2026 04:28:40 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af5056b1bsm3312755f8f.17.2026.09.29.04.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 04:28:40 -0700 (PDT)
Message-ID: <c5f27f7f-6536-4a22-87d8-4f5def76177c@gmail.com>
Date: Tue, 29 Sep 2026 14:28:38 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-4-luka.gejak@linux.dev>
 <6ad11268-9f09-4618-8b44-ab0744cf0a52@gmail.com>
 <a978a803-a641-4af4-b38b-f3c9b423ef63@gmail.com>
 <70785221599240049a8747750b6cf0369f8368d5@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <70785221599240049a8747750b6cf0369f8368d5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/09/2026 13:13, Luka Gejak wrote:
> September 27, 2026 at 19:29, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mailto:rtl8821cerfe2@gmail.com?to=%22Bitterblue%20Smith%22%20%3Crtl8821cerfe2%40gmail.com%3E > wrote:
> 
> 
>>
>> On 27/09/2026 18:21, Bitterblue Smith wrote:
>>
>>>
>>> On 24/09/2026 00:35, Luka Gejak wrote:
>>>
> 
>>>> +	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO) {
>>>> +		rtw_write16_set(rtwdev, REG_PWR_DATA,
>>>> +				BIT_EEPRPAD_RFE_CTRL_EN);
>>>> +
>>>> +		/*
>>>> +		 * rtw_mac_power_on() sets PAD mux bits this chip must not have;
>>>> +		 * restore the SDIO PAD mux before RF and coex setup.
>>>> +		 */
> 
>> By the way, rtw_mac_power_on() doesn't touch REG_PAD_CTRL1
>> for this chip.
> 
> It does, through rtw_mac_pre_system_cfg(), which rtw_mac_power_on() calls
> at mac.c:382. At mac.c:111 that function reads REG_PAD_CTRL1, ORs in
> BIT_PAPE_WLBT_SEL and BIT_LNAON_WLBT_SEL and writes it back, for every
> HCI type including SDIO. So the bits are set during power on and the SDIO
> PAD mux has to have them cleared, which is what rtw8723b_sdio_restore_pad_ctrl()
> does. The comment in rtw8723b_post_enable_flow() names that function and the
> two bits now.

That code is not reachable with this chip.

> 
> Best regards,
> Luka Gejak

