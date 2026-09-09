Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319A0391855
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976487; cv=none; b=UlO90yly+BpUGH5SBDFj0JJOCxXbjS4Pz4Y6knQE3WsTaAo5vHTe0T+I3FVUxgncFNeZl2/cWie+jbqBU73oBXL0GiieIa5zHoglcvVC3UEb/IBKXcXy44H/S/WH0q6a7Z5yJ94SYTCQNfqXi4/SM4hSDQXThFjCsW/2fHUpeYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976487; c=relaxed/simple;
	bh=qbARFKFwxmK0/TY323uLALDd5T986WO0kzOvpSXtMP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BGUJoNTbBfsHznMp/rNopGahO6OYW/B9pdtvAfdnL62mJH4XbpDf4lHYhd5kRO37R9gfCOSDManFq/DBiYIN9KJoOxJpntWexm7+7H7Q1DEV3FgicEUDjz06l5L6LWok20a3X0FMuJ6L2fmzy6FzdbdknaBzZlx7/oxVO56yqoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJisqW9U; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJisqW9U"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso65099555e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 10:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788976483; x=1789581283; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qbARFKFwxmK0/TY323uLALDd5T986WO0kzOvpSXtMP4=;
        b=iJisqW9Uw8hYuwmT9anqkPvyyuA7aTbvarqAcb4TuWi3NERR0KxiM0VcKO49XB9cvW
         oD6cZqUGDsOhykvxBwvxSdbyoU10UqDfgsDy3T78u7zA7HdQx+Vyjap1bgal20qnd+9U
         ZWBiRPHUPSWRT30rlsUzFRneiVlpFaSejdCjibxzMaW5L1xPh1uQOg1N3TKeuh12gaSq
         hk66z6mDNMM9+ePRXmxuD8pt696Y+gJPNsbAI0Jh1yGUEBoc6lfM36Olc4tS/EjFKwoT
         ZSMGpIn4YCT7+cybduONu58jQzitr4Gufgasy0jKfAF35pxGjnMShRQR/DWMAK6s9ZjS
         QR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976483; x=1789581283;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qbARFKFwxmK0/TY323uLALDd5T986WO0kzOvpSXtMP4=;
        b=WtaOqfkPARMAkrp1/cmwKBCEGWRX221c5qljgXFHMv/T2WVZid8QsIxmgYzRjmNpvk
         TaH6HBvEnXJk8yN0ZVJnlRQ8fqkAlBI78Lt3SQC8pxDRtjDoQB6AFzOL34T9j+EK9+qx
         BQ++NGvUlvvH5gAghdkWaAQYwekaXqmQNq6Pk4lYXBBjOD8ewYz+iTKEWjmAiATqEYgg
         vgDohb7ChnvGATHZAgybwXO+FYU6unIFzih4MpSXuBOkA3kt9mXq0ZH8Yb52F0Tb7kqd
         V/Xop3FF0e+8h74DG+4LHjyuqpYn/1IrOkQri/9QvWP7rcbUSfiOTqKIB7CGiOIuImtK
         MwuQ==
X-Forwarded-Encrypted: i=1; AKwUvByxDwOi3dhktMSWzmHHQ005bVf8Ar0uF5oBZrPDU9C5Sbj8qpCnqD3nvjIL+19ceaDvET6U7fLKdknjzEeEmg==@vger.kernel.org
X-Gm-Message-State: AFuF++nGPz0W+Kf8uzXWIWyyezgcpvfnAHL3f435pZjHy/xiGfPtQfQC
	FuVsLQHZTdh6SYjLGsshG8xAk7G7jZcXrU1HspeMemOUxOyxjT5z8kuO
X-Gm-Gg: AYBFou0SYGqem/VbZlHD7Cj75lkwUpg4I3OjMkProTN/gXBoqz8xmTsMwPIPpHjrMuA
	ipyvOIvg6eMVnDh22ajv1zazOc+WWmKsFix/PT1GLyCytIR/dxDPpBjVHMVOUt/Fso8TZwV4mEg
	jTEY0/G0Q2SSuKIYLfXQyWqEskjNPT+s6KWKdZr2GIffjI+VH08fTnzebmloJLIMcUFziaEpKQk
	prb+OVuXosyxJdsb1WAl93VF5vOG1hl7t8PfNZkr9LJnL98BPeZORdYey7vNMXw+PNoMbh2vFuq
	wlLkucYbC7vA5JgdhdQoe2KUgEuKRWzM63RU7/ufFRMjIKWernHJhz6JbLRlnY3IALVvzlzdP/M
	6qBNYg4MGolqCJmU+wA/1GiL42C+8eBycQzAz3V1OCrnAGFcEk/pZE/QfnsaUt4wA/EOKj9b50o
	9RgqD+y5IKX78aQHwSyAKPEY+ycgqYyo6Zdzgp/UZyU/O3v797nBZVFuKh/Wnq6ac3ajcPIFgtv
	M4wlYZx
X-Received: by 2002:a05:600c:c4a7:b0:49c:df2b:15fc with SMTP id 5b1f17b1804b1-49cf823d0dcmr384553405e9.8.1788976482378;
        Wed, 09 Sep 2026 10:54:42 -0700 (PDT)
Received: from [192.168.18.21] ([46.197.185.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c2985dsm10257985e9.6.2026.09.09.10.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 10:54:41 -0700 (PDT)
Message-ID: <40adf541-2228-49d8-8a7a-14232f283d6c@gmail.com>
Date: Wed, 9 Sep 2026 20:54:40 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
To: Ben Greear <greearb@candelatech.com>, linux-wireless@vger.kernel.org
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
 <20260906002657.620076-1-omermetekaya0@gmail.com>
 <20260906002657.620076-2-omermetekaya0@gmail.com>
 <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
 <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
 <dce34788-a6fb-b2e0-4657-aab3843111b6@candelatech.com>
 <faf385e5-5fe7-4b66-bd06-e5f9a88d12ba@gmail.com>
 <bbb382ee-9ada-f060-9128-c2cb6e5f524c@candelatech.com>
 <35a68705-0bcf-4b65-9c0b-050c0344f985@gmail.com>
 <98829360-4d7c-4faa-8fac-63dbe32c0df3@candelatech.com>
Content-Language: en-US
From: =?UTF-8?Q?=C3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>
In-Reply-To: <98829360-4d7c-4faa-8fac-63dbe32c0df3@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/9/26 02:40, Ben Greear wrote:
> If you decide to post more fixes for random syscaller stuff, at least
> link the
> source material so one can take a look at the larger picture.

Agreed, thank you for your suggestion.

Good days!

Regards,
Ömer Mete

