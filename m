Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793949838;
	b=DJMu38TL/5vRZSx0kECWzfuuS7nxie72+xxWiBkTsjNjFHyzjool5aKEFwZ8vCDOURQP
	 TBAUVav4JU/dtJ/zX1aUo2BMy1+59Hgw8CGeOQkiStZJe/tT2corHrfE+NhdQMqp3tN5D
	 WD8L2AKk3v3otBcl7Xj8qGtWu1hV0jmVanrCE0c5S0jRe5MSoapWaNIB7Z+7FqXYBp+qb
	 L8k4aYZht33JrtvdTRAtG41X2l29VCmvMKEEQgbDa8HlEq+4HxwLMb1iAJXgfT1BycJm5
	 eCvYHL0v8TQfyUHJhJhySS/7G44c5OYluilu5WdRO/sOOHZo7lHAFVoGLZvQE4wqrLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793949838;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=k2EplvRwM4fdMHrYTa+fzXRugWdJl7U+3Rcc9nf4IqI=;
	b=pNc0yQqkp5yYlai8oHh++kB+kjQfwpotxVTS0Fgs/pvNtnvYwCli1kzDmv/OWJIKruDv
	 E/Ov+m+lR91nH5HCYTODZ5o5vlfUPo005iGPVzieLWxSUHp/thMoHqh1fyt6Ds9dJFeTb
	 4Duly8Dic49JRPT2OEAt31uywBoCb3jOzwZBBZnWbUt9hlG7hKuqfkL9i4BlRuiqUzPSy
	 G0iGPnkXDSDjFovzXaQYv0lbBBntvMw827C/71DxnxpsJiEgNV5gFmp80mJdb5itelD3+
	 F/htAue3UiS/8uus62rNJf3zFj595tzKD6GdVo1lLneN67RvURtsUwFtEBCQTqsAD6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b="GLWf/+CO";
	arc=none smtp.remote-ip=62.149.158.117
Received: from smtpcmd03117.aruba.it (smtpcmd03117.aruba.it [62.149.158.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4660606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:23:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4660606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=GLWf/+CO
Received: from localhost ([87.16.49.252])
	by Aruba SMTP with ESMTPSA
	id PEIdxwhc807TYPEIdxOTvt; Fri, 06 Nov 2026 08:23:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793949827; bh=6SbqUfL5hMXbpyxVRRztlA9PDvpV/5i8dOmiY2Sb63k=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=GLWf/+COFJnmPR3Ai8RSAG55g1H3E3rGQ5zJSuQXWoxR2QZLjlL6xpApmfnuVOu6j
	 NjzRbIEibtgyEhi0k1cwdAKIvx2n2VipcI+RXqHtchSYp8BxITQp9/oKtjvWDVzjBE
	 LdSOy3SCHO5BQuqPcYRnHoB7Lkr1450+7/90lim3uZkYCI5ttfKrTkzf/4R112WRbf
	 Z+kIfmshYqwlx9uWnWnlotlmTnSlGeOseoW/tvXsi5MJZsK2r7n1jUAYjD8/rjdPs9
	 oCIEhGi18udptG/VPJjmrly06ieOl0OoYtxJTGD+8kPGjH0+2Wk0lhdGqP1Gtbu8t6
	 fvOhpe7No317w==
Date: Fri, 6 Nov 2026 08:23:39 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Luca Casati <luk00casati@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
 arend.vanspriel@broadcom.com, b43-dev@lists.infradead.org
Subject: Re: [PATCH wireless-next 0/5] b43: N-PHY: fix calibrations on rev7+
 (BCM43228)
Message-ID: <20261106082339.0000398a@mythread.it>
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfIxpaP4UX8RgonJ88qN159lSQCkT3Zyw+Hd1oaxICobfLx8zkyq2hxPpBs7UzlnWdAdQqVasoKE7Xi2D5SDzRHFZ/FXx1tsqnz7yXzvpHFLyr5swliXH
 H+PJvXRhjyPaOhZA3/UR+BwCNvvar9nlnErVEIQsbgpHkr3CvxD/wjrEe+mZ7K4e1tKSFtN/R9oimVbkd5mx1ggJGKpYZDkn6P+6JwYySGcqYUeHm70rG91K
 y/IN/UQmEjiBT9YmIAOcbnDLIz6eXcha58zKbLlaYa+UXxGOR/p710VIENkOwRcdBrs98q74EE4OZvmHrnuaQDLvomGL9rXma//2FEhjsSJem+Im6Rl3v770
 7AgMyaEq

Il giorno Mon, 26 Oct 2026 19:15:38 +0100
Luca Casati <luk00casati@gmail.com> ha scritto:

> On a BCM43228 (14e4:4359, N-PHY rev 16, radio 2057 rev 9) b43
> associates but transmits poorly: high retry counts and low rates.
> Comparing mmiotraces of b43 and the proprietary wl driver
> (6.30.223.271) on the same card, together with brcmsmac, turned up
> several bugs in the N-PHY calibration code:
> 
>  1. The TX tone sample table was loaded as all zeros, so every
>     tone-based calibration ran without a signal.
>  2. TX IQ/LO calibration: inverted busy poll, reversed final copy,
>     and missing rev7+ cleanup that left TX dead after a cal.
>  3. RSSI calibration: wrong VCM written on rev7+, wrong distance
>     formula, wrong rounding of negative offsets.
>  4. 2057 RC calibration: the first run was polled before it started,
>     leaving SCAP at 0 and the TX low-pass filter detuned.
>  5. A missing field in the rev7 TX_PU RF override.
> 
> After these, the register writes for the cals match wl's on this card.
> 
> Patches 4 and 5 and the cleanup parts of patch 2 only affect rev7+.
> Patch 1, the poll and final-copy fixes in patch 2, and the
> distance/rounding fixes in patch 3 also change code that runs on older
> N-PHYs (rev3+); I could only test rev 16, so testing on other N-PHY
> cards would be welcome.
> 
> Tested on the BCM43228 only (2.4 GHz, 11g/HT20), on v7.0; the series
> also applies to wireless-next. Throughput to the internet went from
> about 5.7/4.1 to 11.1/5.2 Mbit/s down/up, with fewer TX retries. That
> number is limited by the line and noisy, so take it as a rough
> indication; wl reaches 21-32 Mbit/s down on the same setup, so there
> is more to do (PAPD and TX power control on rev7+).
> 
> Comments and changelogs refer to wl where the fix was checked against
> its register writes. If citing the proprietary driver is not
> acceptable here, I am happy to reword them.
> 
> The bugs were found and the fixes drafted with the help of an AI
> coding assistant (Claude Opus 5.5), working from the mmiotrace diffs
> between b43 and wl and from brcmsmac. I reviewed and tested every
> patch on the hardware above.
> 
> Luca Casati (5):
>   b43: N-PHY: fix the TX tone sample table
>   b43: N-PHY: fix TX IQ/LO calibration
>   b43: N-PHY: fix rev3+ RSSI calibration
>   b43: N-PHY: wait for the first 2057 RC calibration run
>   b43: N-PHY: add the missing override to the rev7 TX_PU command
> 
>  drivers/net/wireless/broadcom/b43/phy_n.c | 120
> +++++++++++++++++++--- 1 file changed, 106 insertions(+), 14
> deletions(-)
> 
> 
> base-commit: 028ef9c96e96197026887c0f092424679298aae8

Can you link the mmio trace somewhere?
Usually a mmio trace is in the order of thousands of operations, so
telling something come from a mmio trace is not very useful, but if you
link and point to the group of operations that validate your point the
discussion is easier.

Alessio
