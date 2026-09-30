Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14154F7CC3
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790777633; cv=pass; b=J0LAuGxOaXWoQ5crjN0OIHthBg8mIXLOX/Qw72PKu0LfEAjEcNFnXNA/4LDhgx3VwBcf6xYIgjui2rfFfBcKzsmpE1cit+FawRdOJP/xyG1AGVCUfCu+DpbJSy3cZWuwmGaQW3PZW+5riCpJyadRSgVa3ItDzI+WGu+uZVKM6Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790777633; c=relaxed/simple;
	bh=ouiP/s84DTBB3CgCBBKgMRlCvmNQLtc3ruMbeozhkFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNQrevl7JRgioBOLsnTG3U6XU0uRAX12+UJsf5V7kCHPSR3pQDXr6j4D8Z/eA+H1v5Kg24kmAvoUhDiW0dcW/E0yMxcBsxUUYt784DHMhMskAxbA37BmA09LhIB0sbzqoAMmq0TkdFxBzCbLr6HlB2W370e0u5qaWySD5g9aOGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HU3JuVoh; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HU3JuVoh"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba390408cdso1496487e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:13:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790777623; cv=none;
        d=google.com; s=arc-20260327;
        b=Ym4tNEx48pe+BmkGd2YTfCfbeup7GSD4VsGE46df7GEIB1uONXIIKGe0uDLQ9NA8pt
         7IOOqOe7yC128xB0cxDXLpRGr53/QobEwWGBRv4mCFU8qSenJNHFo55o+uoy+7BSWJEh
         ouKGril2R46xZKK7o4wqy+l4AKMEymSufd7l8ZdZAv8L7umWbipY6WNdBMfjfU68GzBM
         g+C8b2dh8vhlKZHFeFekOkpeCFvqkLuTZj4jwpLF1hb3QhvzrSYXAcQOFsl53RgSF8/u
         VTXjJAroNAVkfgduIPs35fcQNfLL70h7s2iyjztjdwuYGxfxnNiAvBsZdFExPEUFZnyI
         JTjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ouiP/s84DTBB3CgCBBKgMRlCvmNQLtc3ruMbeozhkFE=;
        fh=pFFJZdh6vwPk0kUmeCmc6y1jmwfEEEKhAT0Y2sQWgKg=;
        b=K9Wzq0RtYzRWPhYc9rLoYQwJBczmmAupGggViDgVMtr87ATpj7QpHArKZsgD9ZF2cr
         +LgxXUrwx/e5fBlv4KxD4vJVPEagR9e1I69Jr+kGqBTHkeuso/yGzmVaTMhljcguj8ED
         3bXeBy7nqW5M0eFq6p8f5UnLTF4L6xfJIFkPJnmGfSCxJeM+rKk7+BIFjUJrBZOVBwDF
         P7U3EZw/j+lnLOHlUrA0xThOlzoTyZDF5YTJxEgAUY4yeaesopl2Dr6PdD3r4xjG5UXR
         ZZVTYF4QRNlhm/vYzRWGw0ZINJ53MLsP8/5CCEWRS/BKLFXUi1j1hP+lcVaJro9W6evO
         kKvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790777623; x=1791382423; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ouiP/s84DTBB3CgCBBKgMRlCvmNQLtc3ruMbeozhkFE=;
        b=HU3JuVohcapnkuT8TmF6+QOx52bOpVZAIps9S3IPbbRkpGnKxCBUKjQ5SbyfqArTOW
         C3tBoIfVqFT/Zgk16U6c8b5ZL0PdV+DKRu03OKT53E4v3wwsuH+s99FpvD05bMUSMQWK
         r1HS4HOk5yHhzYyqNRbXvHUzAKpAr76Jd+aOjvdcjzfvK+GogJC9lRbg5lmmEU5tWvcC
         4g5bKAZP/3taB8vETUKvANeLgTnSf7S3LuSfWVqbTR/3OlYDZ0+UGhkOoK5S1JGyXaVb
         gr4DU4amAbBsMRTFQcDr6truIB2LF7VRMohFAcHkSR8Cgbrdma5dDhj+HmILILEUiNCF
         FVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777623; x=1791382423;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ouiP/s84DTBB3CgCBBKgMRlCvmNQLtc3ruMbeozhkFE=;
        b=r9DMtGK5riaYYd6nhQeXZoWfTOBsd0w8mm+0e97sBKLm4hUSePioZXLG75EGjhsqr9
         TumFrAHdrz5JqqFGWMIlRV7nQYGt4NAkCQ3imIvfIgCq2pi11XJVpiptT8X8ygZ/J7ax
         PXrpzc/Yk0DNZbN31PvoU+qZaLoFJA0exeEI7YV9/EOUZxlKnvPTKL9GhDrxzAmYNoJc
         ry4SaKAWiy4tHpajJ+KdaadTYbH+f1E64dBEX7BvgOm2jpe3BctlhC56r39HD4PGvKh5
         h9xC692p722OUiyUbBPBvVDByESLXk3rwxAts8Gd7kjrENAczttSqWRrI6Bm2NXtF4cP
         RZnw==
X-Forwarded-Encrypted: i=1; AKwUvBzpo8fi65kMoLbbGr6WB1zM4S5FM0xlHZMdBQx9aY1w0k/cTNyPFEXahJzWmBpnXDoyQ5AhqIRjmRzCd/p4aA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJxNDU5WBV2kmL9zq3E95yN/LxGBEVmavUqiPSL8TQCmwW57kWz
	MrhFRQyNoup5zZ8s0jHhjypmI5tTGK3tlNf20Y9t1+CfRZ2AdrYv++DPUvobbxBCXp7yIlqkcQ7
	Pu4jj24Np0jIny1Jq/kl87vLEj9D+7mc=
X-Gm-Gg: AYBFou33sVpmszDKK10yybs5DfbW1i9iS+I4ySN7aq4YcToU0T4X7jCu5QfnaOh6K+M
	6mxNHGOUSWoVWP5jGaVjqK4pnoYXzc7IXgPoqoYYYHuxk/o9bU/38aQ/CdFP0gxYuAnQ6w6apQS
	3RySprEM24QPsxRF2fRdUCgdZ6TSnBDHGSMjtlIYrx1PAWq1dPLqn2cPzMN/2UvGzquWuGKvkR3
	w6Dp21DMcaD1tYNsGZtCBqJOF902+piBtrMo/WHoHKZ/vZYYblGDgFXfq85XdwWyGY+pPnuekRT
	Qgz/nR4GaonfCjdwcp3OLobAuuslJoaUbGu9k50Qr53ag/3+sEeo2kplsiK9fROR4vwj3Fgu8Yg
	Y0vzPW6yuQZqr1MsO4U0vjsuYtwOWkiiTfCSzN0CCU1zM
X-Received: by 2002:a05:6512:6884:10b0:5b8:f472:2e66 with SMTP id
 2adb3069b0e04-5ba405e9177mr509267e87.25.1790777623133; Wed, 30 Sep 2026
 07:13:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
 <20260930112842.21323-3-sigefriedhyy@gmail.com> <235a33c2-7138-4815-820d-793568757d95@6wind.com>
 <CA+7S2v+VaVYksOpuUKzo+DoWZ97M_XKvnMr8cCcgwTkrOxsvEw@mail.gmail.com> <7d8f1378-d5a6-4a87-82cd-98eb794f85f2@6wind.com>
In-Reply-To: <7d8f1378-d5a6-4a87-82cd-98eb794f85f2@6wind.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Wed, 30 Sep 2026 23:13:39 +0900
X-Gm-Features: AclHuK-ds-pquglK1wdrfnVLrVe9lO-XLy96JgNFg8PNJqutvY6kezkk22pc8Pg
Message-ID: <CA+7S2v+hEK09FDv4jLrp3yGLxeFMde0j3FJ-TBytLxQ1Uoq=dQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/6] net: change netdev_hw_addr_list count
 through helpers
To: nicolas.dichtel@6wind.com
Cc: Ajay Singh <ajay.kathat@microchip.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Ido Schimmel <idosch@nvidia.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Jakub Kicinski <kuba@kernel.org>, 
	Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>, 
	Kory Maincent <kory.maincent@bootlin.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Nikolaos Gkarlis <nickgarlis@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Thanks. FYI, please don't top post:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n336

Thanks for the reminder, will be more careful next time.
