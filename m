Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611AA4156DF
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140275; cv=none; b=l29ss0aIE4a4AZrVDtoE2KqcAxt3vOnGYaRe2ef0mjbQkzRKPfc/Cr/qG8K0TzwMy//D7d+Fbh4s95ijWBaFt2CugZyqCMWmgtQf/rnaAxo9IAxm5sQdxBHjFD3thpRHvYV9hhHVvfYZYdy8iNGM//Ko7nYuxFnQyf3dW2QbiNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140275; c=relaxed/simple;
	bh=sylCtSF2MlCfq1b39cak/n9U1b8c8EdsoicVmdhuVhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKvxksCG8TsUJ95UmkHN7s5by40+k3gMeKflQrqPlzEdJ/Sh1mjzhGXZaZYM9Oub/KeQOx4FUWizd1GqeZG8dBFQAwaRqVQT4UXmqXoSqvyUPp1DSvM8/kTbewNUqTsjPczP5Cn+Ha5VVzl0UQbopGKuGFxoCVwMfiBLxcnfo3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=hkDBI41l; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="hkDBI41l"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85a4329731cso324949b3a.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 22:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1790140273; x=1790745073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JoQb5pHgIxz8ZF+3NPp5p/PXUFzw+s+TYUg7wlblHUk=;
        b=hkDBI41lKKn9Chq2Iu1D8GJJOw74FzWgCNOSY/PdPITZrLZW3xjObUtCtGJVBFqRwH
         3XD2dF+/NzqHHzaYWeAiDhzGHY+ZlJiXZQeOsq9BkjwrowcGGP330es8AI3561KX60RB
         wtT7Wofg4Xh5hu7ZDx7vwnlaLKvOUM0HIIZxfStpse6UaYabApX9mD7JRM9q/szrrNOG
         Ic+8LeRz3MG5la3F3w7btJy3RaFEuomDNqSatmG/WopYCzwhrBqChSYJ4QQ2kpRS4zFK
         gMxOxFFO1dn18enx2GC5ISkwmKNAO0nyUxZtmXy5wQR3tE+/e+R45b8dvfrB+PWCR18F
         L0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790140273; x=1790745073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JoQb5pHgIxz8ZF+3NPp5p/PXUFzw+s+TYUg7wlblHUk=;
        b=HQOD9HxmMtOkzae5f9DqzMDmJwrJ0lTlUGd3vm0QWhBF3snmZfT7Wn8UF9O69j+rD4
         +eW/loAiR0r0jQ7J7tJ89It2U9zi0uibOJv0V4mOfD3QMVbNbOok43u1F7s9FeY3Zxhh
         mN+ah2i/XyHnbshY8bf2E99uj8u0UlAZXrJ9OCPtOiuP/MGgjlwj79SDS3c8zhUnws2J
         eVePdkZyk+pBjMoXMLj7OnkkxTJlD1Xdv/qMy6gFKSJlYtSP4qkweGcCmL2Lkbud7rNF
         YAcJHRL/109qOlTDOhnLhyQhKgrpTmwUCZ35G9xA1507IY1bKo94xwXF5c0NEpaZMiX/
         8c3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzoHCBM2Tkmo5D1j4MKSCakNAZ051oI24J+la+DAr8PBCH0NSRyuCKark0wY7BFDte4YGVhRCbHdznx+TAaIA==@vger.kernel.org
X-Gm-Message-State: AFuF++kwtZ4wsqVDuWwvZi4z3on880eKe1KV+2oaGTyabR2qDMzkyUeh
	3dEVDYpfc5y1wtGDllSJMmGv4MU2bVCGP/dEGjxgNSpu5x+cAc91zJXO7WsVlPnz8vo=
X-Gm-Gg: AYBFou1MbkJ2mdkZ3dmew0qZmuqa6/6HaJ9X9MnOA8rQDZ2iO5nIBBtzmzyhOEDDwiA
	RLlVSAXEYrV7JcrBNJOOdv69mLVgSza0KcXCM4GhFA9bSB94+VCg7mTkPtMS8LRls+KC4ViahT1
	tpGJ/sCT7RRP62Q1CiTP3IUCTc5iAstXiAMrNOkNSqaaSanFGywiqE6R65K4I2mi8pPQAygGMZk
	aP/SjCGQoyNfkMPyYStPNxOEkr1UWRVsS/G68HQpVG+KSa6q3461eOrh+skplJDY5D6XLV++HH5
	413p15GIUJnHBezd3XjSzLzgo0xsxohz866wO85HZKw2KSqq1jVV3yTl4HTCl0FBxxrGwvQFAeO
	VpT17iA2GreNk4HxJXUWu1+5M12LJgNk11Ph3gznJfxGMZ2q0HDqFIjn+7g4+sp/cgzOQtgHT2V
	ARyx4kczJRj1vEfcpFu6mUddrJ+weRa9iMTMwH8WEKIrJBxC8I6f53Z6idaDsV9zLWVfeIvsoF5
	znaq6osUMmxqYrSD6ZvaVGlbAPq1eyar2JKAG0FAKw+vdeEZZWwDXOcAGQPtSMRBsgwdW8=
X-Received: by 2002:a05:6a00:761a:b0:87d:3894:197d with SMTP id d2e1a72fcca58-87d3894223amr1197529b3a.40.1790140273603;
        Tue, 22 Sep 2026 22:11:13 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1cfc0a05sm693810b3a.10.2026.09.22.22.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 22:11:13 -0700 (PDT)
Date: Wed, 23 Sep 2026 15:11:10 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Justin Stitt <justinstitt@google.com>, 
	Bryam Vargas <hexlabsecurity@proton.me>, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	llvm@lists.linux.dev, codemender-patching+linux@google.com, johannes@sipsolutions.net, 
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: ieee80211: annotate struct s1g_tim_enc_block with
 __counted_by_ptr
Message-ID: <lia5ezt3tyf6vcpe742sel3vz4w2fuxva25uxgnztc7rkftk56@4qrkx22hmx5v>
References: <20260923045233.2579591-1-morbo@google.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923045233.2579591-1-morbo@google.com>

+CC Johannes

On Wed, Sep 23, 2026 at 04:52:33AM +0000, Bill Wendling wrote:
> The GCC and Clang compilers support the "__counted_by_ptr" attribute on
> pointer fields to associate them with an element count in the same
> struct. This enables KASAN and UBSan bounds checking to detect
> out-of-bounds accesses to the pointer.
> 
> In "include/linux/ieee80211-s1g.h", "struct s1g_tim_enc_block" has a
> pointer member "ptr" of type "const u8 *" whose size is described by the
> "len" member, which is correctly populated with the size of the buffer
> before any pointer dereferences.
> 
> Cc: codemender-patching+linux@google.com
> Assisted-by: LLM
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  include/linux/ieee80211-s1g.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/ieee80211-s1g.h b/include/linux/ieee80211-s1g.h
> index 3f9626ad3d97..8f6107782c38 100644
> --- a/include/linux/ieee80211-s1g.h
> +++ b/include/linux/ieee80211-s1g.h
> @@ -349,7 +349,7 @@ struct s1g_tim_aid {
>  struct s1g_tim_enc_block {
>  	u8 enc_mode;
>  	bool inverse;
> -	const u8 *ptr;
> +	const u8 *ptr __counted_by_ptr(len);
>  	u8 len;

Sure

Reviewed-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
