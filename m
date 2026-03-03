Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B82E54774
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 02:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772503983; cv=none; b=l8782c786rrGgYTzMqc4h1W8IGn4EL8NiHzOJQREOBRNVpG64KoMlVBYQ8SurcD/zVBQzGLDHghO3am7Dfk3P/ijkhkX4XH8vzaUkyTagvsDc4dkaeuRCM06QuTnf0MVd5vzURr4lpSPzC/+vw7lhSgAoiSpPQzENJhymqebXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772503983; c=relaxed/simple;
	bh=zGrKcF+FZ3a9gP5FE29IhV0AzHm2cay7xHfONtSK+Tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVOzEBFkHefrinCqh4X9B2WdCqeFeVUDgP3mOw/i49SiG67nZc1JWdB/DbmmhjIqy9voIAC+zqykEyLHOIG47qxCL1ntDzZ2zIQdc6MN9M4LX6WA4BqOI44H7zy94wKlOVFqVLrP4wc2LNrnZiJSOZiGHqopjZp16cxGpyBuHKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b=ekGlnn2L; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b="ekGlnn2L"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8272c559597so5079572b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2026 18:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20230601.gappssmtp.com; s=20230601; t=1772503982; x=1773108782; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dnL+b68np6Bmp1zLluqsJuYJUKSJqgjCE5y21yIKQLM=;
        b=ekGlnn2LthEbDtwW1QpXIX9U6nY80z7jf1VP8Rzs9HsrS8Q5ihfu1JVaaCBkWHFFAR
         h2B164g3VFqD7eSTqe9K+ODsrbk0i1zI42h09983X65D3z9F2CDh2/89YDMzMM5vUVEM
         2q9bzBw3mnV2keYW6Qt1Sc3K3heSihsVyhuuMYHhdwOEMTBMdsrfPQY4Frv4AMrOvoOE
         W1Nkk7LvIBrl/flJtOxeIDw9pIuAtel1uWwNx0YaBKCdMEO8wyAT+Qdf3c8LZq34iyUY
         Zfsp/O4666rTQrVBNDgCXLbHzOsLZOlALS//ZPkwjysINmVvnqCootMMKoqbZYUuirS2
         VBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772503982; x=1773108782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dnL+b68np6Bmp1zLluqsJuYJUKSJqgjCE5y21yIKQLM=;
        b=HYgQba7qsN2axbx32pE6A+Qtcde6yHJOhMDvN0ELsSy7/5tC50b6Tjiu1xBrsl8PJ8
         jPQz+gaoDkmaGxjbwyt9RdUUJGSyp57gmYj7SynlneJdFY4CwD3uIA0unzEoQUL+Tuxw
         +B0ic7pIwffI2xHvHIE0m5YiZ0QboFopD06D5lVYA6ztosDkSXWQUs5QhKRiCTaRnbl/
         ech59P+ekSOD2Tl4cUZxpGuMqmL/bixyhR2zb7zKeDaFDVe+vJkKMx3McwOHNaDJq3OF
         LZXfqx8STbrGXp/RZYqW8AifzzCUFuL4tkvUNBitvJtstp1iZTiavFEo1TkbR6t+ICtn
         spWA==
X-Gm-Message-State: AOJu0Yyy/6Jld1h0I3Itbr9I4uFAfgN8W0f/BDQgQT4UbMMKyt8lqWSj
	TH/Sfs7/iLTQ3ANvLpWLMvfLXYgoed9BqZMuGF2ATmy4EoncVNc+rcEq5RYYLVXM/I0=
X-Gm-Gg: ATEYQzyp662sFQmdxGY61Vw5zYtOjgDup52Ci4nYYWPAW1fp0wqnUhvcVr7NTE6zCs+
	rQnFGKO7SwQ+OXynxTe4Ftt8qXZ79F4z4pkgYwlUsjzZsD1S3p89dYSVeR8DVogTTV30ozODGm7
	/+aGdVgxiqiV+xxIIFiFWYytp3u0luYU7RssWOfDziavUYaFoV3w6V9+coT9BQDcnY0U7mktBm4
	RM0VkShBkWaqaFZF3k6dMEXXOZ2P/y49mqIFgfbZRbBTovK9PInuyhin3pB8KPoU8qh8dIbO1ra
	+Z1HrdRVCJIUB/jwlYucW30mHDQFrIrjt95ApDXRHVJwvGgFLXe6oSkwoPdA3PSioP9Uk/rbHmG
	Mx3i7U+swOwcjUmqxj0ck5yjv+T5MI8tBtJgWbb2BK1+seIJwSdrfhprS95RvIHgGpx0knhYbn3
	oqCgKr085rpFy+Xm+vjrQH9IG2SedaZRFTg1L4IbvWXbItpmaXllQKXuLXI7uH2Ka5IAQi1RGxQ
	hJn9RfJuRldYUhXE8tF4cg=
X-Received: by 2002:a05:6a00:4fc5:b0:81f:eb35:69ef with SMTP id d2e1a72fcca58-8274d9f43c9mr14986260b3a.40.1772503981829;
        Mon, 02 Mar 2026 18:13:01 -0800 (PST)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff350asm13619428b3a.35.2026.03.02.18.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 18:13:01 -0800 (PST)
Date: Tue, 3 Mar 2026 13:12:58 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: bot results missing in patchwork
Message-ID: <gyknl3egpibklu52jcunn3jdzqkcd6zv765jgxnezzcxs2xqq2@rip2yhlyfjdy>
References: <2edc78e3581a11c18189b1ac5ee95b0600586f82.camel@sipsolutions.net>
 <a3e5e4a8a8d147e4b77b02b479844f4a9c0cbd8d.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3e5e4a8a8d147e4b77b02b479844f4a9c0cbd8d.camel@sipsolutions.net>

On Thu, Feb 05, 2026 at 05:32:43PM +0100, Johannes Berg wrote:
> On Thu, 2026-02-05 at 11:28 +0100, Johannes Berg wrote:
> > Hi,
> > 
> > Just noticed now that evidently when I did some server shuffling
> > yesterday I lost the job that uploads the results to patchwork...
> > 
> > I can't fix it right now, so for now just wanted to say that it's
> > missing and that I'm aware. I'll get it fixed soon.
> 
> Should be good now. And because I mixed up the new config and made it
> link to https://..., I actually gave it a key and certificate now so
> that actually works.

You are probably aware - but looks like the bot is broken again since
around the ~24th.

lachlan
