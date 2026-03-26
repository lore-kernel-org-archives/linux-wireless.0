Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4272F12B3;
	Thu, 26 Mar 2026 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774533811; cv=none; b=l1ZRTQLhiVlVaz+LoOe43lu3AenZYpC36SqTOdw+pScg6NKzG8nRMACM8/Vp943Vji6pcrHHQeFupYawwaNfd5704rDj420aAZv4+khaM8q9gDOEzg4ZHk7iNM+IdbnHNUfjsetikJnuMNUmdhr8K06d8S93e/aoQhRP0cxBlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774533811; c=relaxed/simple;
	bh=dkjZs7WKD/WSTNflqzehy3i+/gd5KrtTWk6FaK4d2QU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Tp24f/gkQSuRp1lDcxZatAAkKVBJtPzFUh7v3L5TS5g/BHNCzjWrShahZafcWn0WNmRGoZqWz+8kZHtKuuhD5df8HnHZCasLniXqFa0+Gj2ZutXTZa/6FLvCCY5GvLtVUM2ZsOECS+1b8gQReHU77rMfAwreOcG3d5eNw9y1Hk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=ZLSd5s8B; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="ZLSd5s8B"
Message-ID: <4a04d4bd-969e-4804-b938-cda8c0a626b6@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774533805;
	bh=dkjZs7WKD/WSTNflqzehy3i+/gd5KrtTWk6FaK4d2QU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=ZLSd5s8BdQiW9ocJjlKnLqH32gFxNFAOO5OIbBvOxlv1Zk3WFgq+EpGIoDQ21dKd1
	 sPWfR7l2Eph+/s0n9YTDOJvIxR2QnkybNVD0aRjrD7Jhj+bMXAeg6M8Xb8igIPeq9C
	 lrMZsbUdJOmdU9lpoRZ674Lx9vmrUslRFJ45td1I=
Date: Thu, 26 Mar 2026 15:03:24 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
Subject: Re: [PATCH v5 8/9] dt-bindings: net: wireless: brcm: Add compatible
 for bcm43752
To: Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
 Conor Dooley <conor.dooley@microchip.com>,
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>,
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
 Johannes Berg <johannes@sipsolutions.net>, van Spriel <arend@broadcom.com>
References: <20260326-add-emmc-t7-vim4-v5-0-d3f182b48e9d@aliel.fr>
 <20260326-add-emmc-t7-vim4-v5-8-d3f182b48e9d@aliel.fr>
 <9bc23f1e-1cf3-43d1-935a-c4738d576c29@linaro.org>
Content-Language: en-US
In-Reply-To: <9bc23f1e-1cf3-43d1-935a-c4738d576c29@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/26/26 1:55 PM, Neil Armstrong wrote:
> On 3/26/26 10:59, Ronald Claveau wrote:
>> Add bcm43752 compatible with its bcm4329 compatible fallback.
>>
>> Acked-by: Conor Dooley <conor.dooley@microchip.com>
>> Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
>> ---
>>   Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-
>> fmac.yaml | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/
>> brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/
>> wireless/brcm,bcm4329-fmac.yaml
>> index 3be7576787644..81fd3e37452a6 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-
>> fmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-
>> fmac.yaml
>> @@ -42,6 +42,7 @@ properties:
>>                 - brcm,bcm4356-fmac
>>                 - brcm,bcm4359-fmac
>>                 - brcm,bcm4366-fmac
>> +              - brcm,bcm43752-fmac
>>                 - cypress,cyw4373-fmac
>>                 - cypress,cyw43012-fmac
>>                 - infineon,cyw43439-fmac
>>
> 
> I'll apply all the other DT patches, please send this one alone with the
> [PATCH net-next] prefix so it gets picked by the wireless/net people.
> 
> Thanks,
> Neil

I'm on it, thank you.

-- 
Best regards,
Ronald
