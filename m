Received: from mail-wr2-f28.google.com (mail-wr2-f28.google.com [74.125.225.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E024F4CF3
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175802; cv=none; b=DaQRaeJ1znm6kUZducT5viByos0IFSh0JLn6G8+uxp5k1LwiPaDFFUhDGdTmm1xD0wzY9kJXGwlhcUeFh/R0QncDramlpnWhz+B6EGI9HYBfe4U9khZIvGkVmRKdxOOUtSh7IjOJnvqdZ+1YpuzB8GLCJUVdP3ApHr28Rn6EQvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175802; c=relaxed/simple;
	bh=uLhhVUN6ngd8j2x1y2bu0WRlPkyjSAYqqJNC1LceToc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Emvlaw/mYquJs/82CVpReMwQ8VBc0Yqirnt71tc+Ua0rxc8zuE5kD+8YKMmemx9imt8uj8hn0PkOTcCkJEjrOQSbCxl9PLcIED/B/xJcS+9z5ZsJMVwkyGIirCkNxiWuFGf1LbL4sN+8L7tglXY7kYxG+h3epQ3MxO2pLJBr9qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NN+XrPso; arc=none smtp.client-ip=74.125.225.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NN+XrPso"
Received: by mail-wr2-f28.google.com with SMTP id ffacd0b85a97d-485b1d2874aso875206f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790175796; x=1790780596; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FplGfmQH7NVN/0KzB9B8C7XnxdnkI3i8bSndgLklG+k=;
        b=NN+XrPsosLDe0xzoOtpb9qBCvoQN042ei2OAuf42x99eBS6Z0BTd8Xd+LVOseczEB8
         EbVg8qBayhEpnE7Mlu+6g82eYPBdx2LARGGY35wADMfMA24meVReq/NkqkLbrj18pxRH
         kf6qA2PLoeWs04e66QxsH5MLOQkr/ry+Z9SdvjHthJUrFJgNQjTtlLnJn0Ge9Q3IEAIK
         aPsz6C9sasD5oa8BQicEzwbi1gUralMmPlJam1+X/D45hECATuvSM6tRgNDQHJfnWhUj
         vlpfCnAStzJAc/tM6Zw87t6pdEVbCUCXnzrWSsqG8Pz9LPC82AE7LEwT/RehFnld28W6
         C9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790175796; x=1790780596;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FplGfmQH7NVN/0KzB9B8C7XnxdnkI3i8bSndgLklG+k=;
        b=epgPCGgMYjplNbweyV9BDnmHqweoxiFufhSz+vyaK3VQP7SZpHeING6PeyBXEGfs8b
         vPklSBDBhl7jqDNRSiC8rr7df3aw8irRjvCxUTugCVg9lAkf+8JYiZBIgYMZrqVvnGvf
         KCjfjjOdilsrhbFGCWPiKuZmPURm/k8rTvvF5Bmc9CFRNTVwnorRf80L3xSKRNuXX0Hk
         4FZpUfaQAnC6+DLxtKXOE0YxkFv6lnTe0FUHQxIgIZ4e7gCgPJ4tTyqhGl2yrdHUwDuo
         N2zM2TYNM6JwcrOXvN6O6o++Sp6A2DrrqRu+9MpHDEh/jdR4033WqSwfFUXqeye+eDPn
         aGyg==
X-Gm-Message-State: AFuF++kLD1iTSgHcNakGVYa5TQo/2ju8wkURykjEPUu5f1Ajc2pGYakp
	zWCjcJqGZnw0gRrqqLsuyzN/qUq97VdTEHLJMQzqKTUrZOzDslP+3hRGHy5s1g==
X-Gm-Gg: AYBFou3zLyasyiWRWtiTessBzW/S3QK8Pjbff+yU7x3bTlCR9Azye0ihvZziuzDkazv
	Wugj9o6N2XLqUW0MjddXYnfH/1nUnxG7UjwPQiYuCCgRaSQzbYy5/6wbfHfSPrPmauiEoZe5Yv2
	UXD4+drcCUJBtoCHKCL2NNa2+FTVyfpx3ybjRQPFD58LlWSOwwhPyKdlQ4/YMqfZvcKYB1vA3bd
	Wzkj7B3Uv/L6nLR/oKqDiVfJS262R9ddv+oS44o6OPA1H4QGt+QxX9saxa1wM1KnYpwykXvgzPO
	6Vb7or3iKpoHwT1J+OMaWcBXt/TviCiBW+b586oO2iODFCYXOg/S+qJeDaU2a5XcK/ibPk2tYEa
	M4FOQkDO3s+M8WkSyvFPDwwxpkx9Z4v4LcZVeRYOdJYFL3XNOxVcWAuglpJZN+f4lu4e4yC5dbo
	N7rWH50MIw9iC/1Xkb7ShD7OjNvbX0SX1AhiMgVQA/OmNAg/yWdNOYw47Z1Xe14zdtQp0NV+dHw
	BVi6A==
X-Received: by 2002:a05:6000:1447:b0:487:27f9:83e with SMTP id ffacd0b85a97d-4886709d6d8mr5046351f8f.51.1790175796488;
        Wed, 23 Sep 2026 08:03:16 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488688893a0sm7826780f8f.32.2026.09.23.08.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 08:03:15 -0700 (PDT)
Message-ID: <96f122e7-2004-43d6-917d-a07027f568a4@gmail.com>
Date: Wed, 23 Sep 2026 18:03:13 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: extend the TX report timeout to
 RTL8822BU
To: Ping-Ke Shih <pkshih@realtek.com>,
 Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260921165343.8131-1-pepe.schlehofer@gmail.com>
 <4c000f11b23c4920b052e8513ad28345@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <4c000f11b23c4920b052e8513ad28345@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/09/2026 05:03, Ping-Ke Shih wrote:
> Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:
>> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
>> index 4e110a457..55d7923e1 100644
>> --- a/drivers/net/wireless/realtek/rtw88/tx.c
>> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
>> @@ -208,7 +208,8 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
>>         __skb_queue_tail(&tx_report->queue, skb);
>>         spin_unlock_irqrestore(&tx_report->q_lock, flags);
>>
>> -       if ((rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
>> +       if (((rtwdev->chip->id == RTW_CHIP_TYPE_8723D ||
>> +             rtwdev->chip->id == RTW_CHIP_TYPE_8822B) &&
>>              rtwdev->hci.type == RTW_HCI_TYPE_USB) ||
> 
> Hi Bitterblue,
> 
> It seems like more and more USB chips need this, let's enlarge timeout time
> for all USB devices. Do you have any concern? Need your input.
> 

It seems fine to me.

>>             rtw_is_8723bs(rtwdev))
> 
> Also, considering SDIO chips, should we keep original timeout for PCI only?
> 

This too.

>>                 timeout = msecs_to_jiffies(2500);
>>
>> base-commit: 73e3b1c94c7d5b4a113e7cbb42665dc2fe3b9d78
>> --
>> 2.54.0 (Apple Git-157)
> 

