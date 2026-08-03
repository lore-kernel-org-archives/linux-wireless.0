Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28DD30E821
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 05:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785734787; cv=none; b=hskpeArx3Tsorb6xi2rYPMi6JWjhVlUmqaB3kM6VwRu9Cs3WJcs1PCMuAEnidm2nw/67Iqn11DySo2dj092GI4Q5oYcFgBwH9lhZReYtBJt29TYBxd8W7Ld9OiMco1Tsd066AlQfqk7qXmKe30n7A5ATyVqjjQuhtVd1pNArtZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785734787; c=relaxed/simple;
	bh=1Axj3evUs+fJI5Lk8mlf9hrL49uOI7wvbE9J4XLS1cI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nc8VYCWSn3R3hwiWd0aKb4/FH54ASa97ofRk1iPpvuMVdfcQbwbmwGuotP7OpcuVVwji2p1+Aqk8xrCNkz7LvjkV8dDyh9QFa21ujiJBFmLe6KRp8L2vd5bEj/1wGKYi0GH7Du+NJlNf/uvX7Bx7T1VBYa8Es4/gzAdVsUQQ9l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=TrjbZ652; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="TrjbZ652"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbb973e6749so3290628a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 22:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1785734785; x=1786339585; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zoA3wdI8CRQix1KpPDuyCzVeCmR4ijChsDtDU5OD05I=;
        b=TrjbZ652ANHP8vSj7jcNRAhiZyx/9ACZFgrPKegPLcULoNkaBfdx32Esma/ZGgfX3h
         NhiWen906ThI8Gf8A2bAgxxQSRK2X9zEjMa5fJ/RTmf0q47C0NNYlIMIX2CRQ6nzoQ9z
         Vmh7/MEE6qc6RHFG2SOQA1pdO/o/zuRIA/CYDdSX2A6gU4l66o3IYFla3AWjcIJTL22D
         O68vZJeb4s7cKl261R0YiUZ1OI2W32Vzf9LxSghHokT83v2iRn6dtIqeZQASIlfdHn9s
         LSwMpPeD8flwBdcsz3L6d+Gdb4q1DncYo6O8hLCWB801cF/GbF0vley4Gw+qo3D36Yxp
         VQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785734785; x=1786339585;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zoA3wdI8CRQix1KpPDuyCzVeCmR4ijChsDtDU5OD05I=;
        b=SD3TyiOhtOHiAZp9pidiVsgbWnPoK/RbkdfAkvkv8PqLTrL6GGmR4beGduBlEoqlUE
         0m0RyELlIPx01jQKAsTb4x9fEs6GPYUUwVIiTqyP5wTFSykCjOjwR+Vm2drZJkrkWbFD
         JtEhTVCaiMq0abSrAxyzV82v+uW+zcL31laENBnTK9gh8Z1apNuA7KmwWdqMMrY9VwKX
         eNSVbG8JL595ken5VEUHo0RRwI1BZ45SOo+rob8Y0nMasEyVypgu2abToAyUdssyGn0E
         3X1Y9a5vEjuYlz1IkDBGWHerz7u30E1j3EoUQnPaeWOoTnvablmADV2D/R856jvxrRGR
         qy2g==
X-Gm-Message-State: AOJu0YybyUdg74/LyC/4AOpWvvmflOj1WbbzVPYZic7H6HMOiGomchZq
	xYm3TB8+1bMil+YQQRP2WtkrqoZ6p+M3dtHjJxjmK+wXEXPsTq1QCiE67DhbyvIisoCLyIb1+iw
	aR6Os+Dc=
X-Gm-Gg: AR+sD10OXsE7kKJAROUt2s62JoBYs0aAhSqkeFIrxYl9B+7oQmMy1vFnLslMGRjobgD
	LhfyzO4yH1OpWpGV+931QuC5HI2wf1h6NTeyNgqxrUqcFS6nqqMkEaFSmKh57CPf79w/JLsoqvl
	XVb9LzsfNvL/dMO2kGnDBwRVkydkONS1FG0h25q73hE47ud0ovZ43fbvDR0y02PE8UTUzu/O9tu
	6N/InYgfNmY+tMyJM5b7BzK2cKZuvAd9N9XMvGZCVIGtD1hlvyKHaYLWh+B0DadH+AqvnYvV0fA
	hyy7NtSyYSee3z+Pw24kx5LMbvwLAiJa88uIBeDjIEsLWnXT4/VqJvyLjXalqzJmMb9qhRZQ4ze
	+6/ccV7ENbSAf2tgyRO4Fz1KYBNJ7vCNfGkebcK24sJeshGdNs9zC49dt/9E7NTK6Rh6UP5rfbm
	rdmyNOpt8USEcHZ2Ys57gxMz+GEBnnv5yUNJsn2k3Qh9CjJhge/k0mNwUNNySErbJVrkiuf439k
	/RXICKZ2zWrDnhfJF1wygxbLX0iWw==
X-Received: by 2002:a05:6a21:9098:b0:3bf:b1d3:393e with SMTP id adf61e73a8af0-3c92a51aedamr9292025637.2.1785734785234;
        Sun, 02 Aug 2026 22:26:25 -0700 (PDT)
Received: from localhost ([60.227.217.136])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e29a126sm35669258eec.31.2026.08.02.22.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 22:26:24 -0700 (PDT)
Date: Mon, 3 Aug 2026 15:26:21 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, arien.judge@morsemicro.com, 
	dan.callaghan@morsemicro.com
Subject: Re: pull-request: mm81x-next-2026-07-31
Message-ID: <2uamaledjzr2qlvixwrnhrd532ugmbyeajpnljpjurj2tflld2@ak3ym3aalkn3>
References: <3wboegj7eyorursqi7gftc2s3jqtrfi5fv3k57eoqrr5arxmnh@2jextspacknp>
 <c0d041baca23377772791242ce0ef241aaba4112.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0d041baca23377772791242ce0ef241aaba4112.camel@sipsolutions.net>

> I guess signed would be nice, if you can arrange it, then I probably
> will check less ;-)

No problem, I will sort that out.

> It would definitely be good though if you actually created a tag object
> with a message, the message you had:
> 
> > ----------------------------------------------------------------
> > 
> > wifi: mm81x: updates - 2026-07-31
> > 
> > - Just a single fix for synchronously shutting down timers to prevent
> > a UaF.
> > 
> > ----------------------------------------------------------------
> 
> wasn't actually in the tag, or you pushed a different one, or something
> weird happened? 'git show' on your tag after fetching just shows the
> commit it points to.

Oops sorry, yea I created a lightweight tag. Will be sure to do a real
tag next time.

> Anyway I've pulled it and copied that into the merge, but a real tag
> message would automatically show up.

Thanks. Enjoy your holiday :).

lachlan
