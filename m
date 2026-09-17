Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BED2547064
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 18:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670214; cv=none; b=S7DCBw+V9WOI0ZV30jh1qqu9GFIacX1qBtKtkAyHd/2rIHEzeifjpVndZ521rxoYrKQgAt5XhIFOg3cN5z/rc1uRbQyc/I8bqhIeZF8OWapcs5w4P+qVaSUAzBFgoKeSRmaYuP8eVmGSOHq8CLqVzgbZBvetHVnylvJosw7XqKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670214; c=relaxed/simple;
	bh=caATsSuAuq2aB44GhAF/V9le3Dn8YHGPjHe1Ff7AOMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpcwY59eZrMwjKnO1ejWo0mJwHj6MheUpbDHRB4pufphVWWf5h+ePiGjncOfbsvTThwfwaPUvr+4GVVw786AsIvGOHeB9nQY9/Xbb2ej1jpYJ/ewMwugsJmjLB2wfCu+rkSpf9++pquHA3HreeVRhZEHtIF8CCIOUfoHPkyQNic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GTYjZR8q; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTYjZR8q"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so850509f8f.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 11:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789670211; x=1790275011; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s8s7qxmENw9kYXUuBikAZMey2aL1SDehVWrjoore8yU=;
        b=GTYjZR8qOkzmmludZ3dQWdvbYJ3415eo6hS1iAt4prRPsS7clzNv2cn+gXrQfcW1Pa
         deN3rHGWt31asBuQ1Lvve26hzPHHgjAE5H8MQXSxqYtLBmxcug1drPbX/8T21OUPQNxU
         C7aiFaEsAOh7b3eqeftp3OL4i6WuQg8QwDYwXyvL7TvYk4nX2Zw0N9MLwXvXLD9LWkt8
         fbPLLZ/ouPfL4VSltNU8pd0PuPhDDZTZGG6Y5e9XAQsABEt9f54fxbC3J5emcQ3TLAYB
         qWUMk7rzd+8mKdynrwzUtu1VdqUBnMN3sN25QV2hznbvbusfU/pswhSi8DJH9VtvV3kw
         Ycwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789670211; x=1790275011;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s8s7qxmENw9kYXUuBikAZMey2aL1SDehVWrjoore8yU=;
        b=gUPgssgy/4AhmahoGJhIE+Fu1QKlzCyKk5gHYRxIxTsrV8MYTiemG4Vj7Pv/AxzP+0
         IzKoNY4Kakl9cPX9lAiQdbHy7XPkrxR3Xbtkgt1M76BOc+xSNkELwwNcZvbNflyGDTrd
         Y0Lv84Sg4h7p77b7QiLy0QHUZJzhBqD4S6guSEvd8B9K1niHFyV3imzuAyzgMHrSTNP+
         pfDv+8b28NrzPAHH9dilVFES9mszRtv0f3uSJED8HbpSYxNwZ0k8TeZZfurR3PXKHF2p
         UvSnksD02ETsAZumh/sScdLfo0hjKE+zJLltP2P8b/ra/kukfa0QPoCeOUC2aZZRefmu
         KCiw==
X-Forwarded-Encrypted: i=1; AKwUvBxu6KWjbJETCVDM5kuhCIemDy9ybLyzXhQt5VzHOu6eMYqlmDe6+4J1WyLJeSiPpnjlayWGs8IXzRFp65543g==@vger.kernel.org
X-Gm-Message-State: AFuF++nXk832YlKgMt8p4ZWRNxOXxjk8ze00vF6ZiPH4w36OcdEaTuaj
	qHMO3fiaZB4Q/Y0/Ti+MSzDaBZBnPV4VSOjZWMxH5lfJXSC/Sg+y99WS
X-Gm-Gg: AYBFou2JTiGNok48JY25BaZ8J3NrjiNsbdi19Cuyhy1Tul42DUpZWG5YQp26I86jWkq
	HKy+QVhyUUSXfv21eal2uLPZG5pY3fRD0+FQcFZWiUzA4Mjwv+687jr2flwXLej0PhEjhuMmDMN
	hLB7c7AkKB+RXW/AbmHPZW/zMLveNPviLBzEE05og9nuCM5P4ULhR9ivmEV/KfigvPtyYXCaAM1
	BHhHEPisgmbv2WAOd7dSWLjev9NbJjDKUW4rvoAiT0SEWf56eIMrNgf1VLFaqgiLC2EoBGdAGRF
	ZszZfCBZiVdLLyKuGIhvxypYyRVVMzUYuFPGYDUfYFrY0JFWPnAILrkHkPC0URp29E5Q5b5qmPp
	4FoHOXLjDmxcoqM0YDpYQWgjoGD+LcdfuxR78Gv07EW10APLO9nxAo0CxeZ/OwCwqI16vFKBZRs
	smVVyhEciw6geF11SI4dc8JQhwLaDALEu3I/NQ7jYjDok+9BINU971NmwNv2dJNmUpRaXVaG9tR
	bhD9nTDw4xoGfJ+1BtKMA+LlM/wYyQWJsYyR0GlElRHkIcs6PmYyjYud4T3VirPdggsi71PH3oL
	bA==
X-Received: by 2002:a05:6000:41da:b0:487:1470:52d9 with SMTP id ffacd0b85a97d-48714705333mr4848198f8f.3.1789670210474;
        Thu, 17 Sep 2026 11:36:50 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fa7dsm17395323f8f.8.2026.09.17.11.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 11:36:49 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x7Gx3-00000002J1F-1beC;
	Thu, 17 Sep 2026 20:36:48 +0200
Message-ID: <eb118dd6-94b6-4b08-b237-b1e08206ab6f@gmail.com>
Date: Thu, 17 Sep 2026 20:36:48 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: p54: remove redundant length check in
 p54_find_ie()
To: Wang Yan <wangyan01@kylinos.cn>
Cc: johannes.berg@intel.com, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, linville@tuxdriver.com, zilin@seu.edu.cn
References: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
 <20260907024941.302630-1-wangyan01@kylinos.cn>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260907024941.302630-1-wangyan01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 4:49 AM, Wang Yan wrote:
> The check in the while loop condition and the bounds check within the
> loop body guarantee that "pos" is never returned unless the IE is still
> within skb->len.
> 
> Additionally, sizeof(mgmt) evaluates to the pointer size rather than
> the actual management frame header size, making the check incorrect as
> well.
> 
> Therefore, removing the redundant check is the right fix.
> 
> Fixes: e5ea92a7528d ("p54: AP & Ad-hoc testing")
> Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/intersil/p54/main.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index 57a62108cbc3..8f921dc4ecd3 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -76,9 +76,6 @@ u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
>   	struct ieee80211_mgmt *mgmt = (void *)skb->data;
>   	u8 *pos, *end;
>   
> -	if (skb->len <= sizeof(mgmt))
> -		return NULL;
> -
>   	pos = (u8 *)mgmt->u.beacon.variable;
>   	end = skb->data + skb->len;
>   	while (pos < end) {

