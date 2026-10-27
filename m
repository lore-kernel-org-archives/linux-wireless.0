Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.155.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793128923;
	b=yUkKO8N9t38dC+gFE0rcGvz25Z6P9lbJ63Uzr5IvB4bFtbFEMY8o3kokPW/e3NK81M5m
	 HKfRYRe+zwnlKWeg3872R7KAqQyfIahiZHlwDbMsfmCmI1ffXG7MlalA3gjFLA+cjQ/ZY
	 5CLLwkguqK2A8/AUPnQVCj1iC5CtKrCZg62AkSKZWiAexfW5I/QmCSjTG2Ta0QbJx6inR
	 LkUx5W9UHx26vYc5+LhK+o1JJVY7p1ttpn6e70mcjwNP9WpeFrQfR6M1dFA4TXWkz+alT
	 0i0oR8CL7lfbMdzyyJ2G9A/xGHRcRRnVaijlfypNhuDD8Ht67plbVzW8gt2FXKN0yBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793128923;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=oSYkn3tPSYmfylFq1MY/pIePTVsMNstRYcijOc5Qkvw=;
	b=XiU0ZddpdOtP5HVUUmZFcDEHJXTd4I2euHde+9v/1io5uG15RL5WZNbIi21y5TZ9zlgO
	 Jit0fKPlZhmkGPUP4gmNPrBcbwCyTva+pROony+jaZJNKB+HxYNKqhGsvUcPcOUMEQrK6
	 Z0Uela+KRd29Sl73+T6p229ALXKe2PKxCFmoCn8f/4q0mFaUyL134c14+veSBX/sgoerB
	 HolOyeyH+Dohu6MGWYpriEpZc3S8QpeQFpG4ZM8iJbkIMhoiXpI9sNyoPNYHLAoj0Pk4/
	 C16yC7mK6sMdTyMk2Ay3pvdazf1tWHS6RpboMQQPaDGfR1q6duhd4VBcn9RWqpfeDLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=iGlFLHxb;
	arc=none smtp.remote-ip=62.149.155.149
Received: from smtpdh19-2.aruba.it (smtpdh19-2.aruba.it [62.149.155.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1D606A329
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54F1D606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=iGlFLHxb
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Lmk3xaK2cb24ZLmk3xQPmC; Tue, 27 Oct 2026 20:21:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793128913; bh=Vi4/zqksLzLeB6wIQLU71fV8r0YSVyXdWoKGQv4Ax6k=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=iGlFLHxb7YXu6Dx0YwciZwyu1sg3QOGj45bF7KG/yOHlgFQae02Ll9Q0yfODvhMJW
	 MIMt90nhgDbCWhn42dalW0HIQsTAZtbzxyv9la1hPprb9fnz7kDOaFqUREMpcFBvXz
	 yOT8tkdG6maUheuYPIHqhBeUHftK3wwPPlGPVCT1iSpoN6S6pkN41JSdoOs8ROxc/q
	 ErT9D2svgQ/3DWcQzf/lCtitvsqURbgeh7qaRykgDHS/EXPa9F3eONuT90sXJs4qDh
	 405O6P94HvG8MLbZxG9uw6wUawhIbjhQG5L8A1Fszd3GkbNnmXZeOPYMvVYQ6lFO9D
	 96BZg+Oydj+FQ==
Date: Tue, 27 Oct 2026 20:21:51 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Andreas Wendleder <gonsolo@gmail.com>
Cc: linux-wireless@vger.kernel.org, Johannes Berg
 <johannes@sipsolutions.net>, b43-dev@lists.infradead.org, Michael Buesch
 <m@bues.ch>, kvalo@kernel.org, julian.calaby@gmail.com,
 jpeisach@ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 1/2] wifi: b43: reprogram the MAC filter
 after an interface restart
Message-ID: <20261027202151.7dcdfe4e@fedora>
In-Reply-To: <20261014143225.82149-2-gonsolo@gmail.com>
References: <20261014143225.82149-1-gonsolo@gmail.com>
	<20261014143225.82149-2-gonsolo@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
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
X-CMAE-Envelope: MS4xfAJtmQEREgsDqnAdqzUz0Ej+Q3246vMJHzt7XggsLVazcZXJt5c57BKP8Eb6JrBUVfoYtC6eTXmQOchC3TvvktmJ/+mdDKuzZy4pLvL4JagZc3KzJmik
 36PXRoicnrhN2JUak6xmjCXGjVZ6LFRew37CJurIDTUeGchl2zu4TfK59N4bpcyh6YCoVGIf7A57uOEXzptP4aN88cpbQoHRWHcC8qrEgWz994QeQAA9mqKA
 VKFtoFzlVfohu4lRcBmPx3RAw+MlpXJiut8hsPd/5ps0xNYBmYuKZy38OY9kuZ8fgI81NSA3WPfFp+wNWHLH/uWyfKwUKqsmRFp9cAvxL15cLx3R/uwxbIi7
 gWBhr2TODuDiqonXPHfj47spYYQd64LtapU3b6MV0/Q/Ovrlm5itwkbEaMh+8sYZ55ofRpHLu38JcWy4I96wmrbAvM8CvfWqPdkyGNBQeTbzl9S6xpA=

Il giorno Wed, 14 Oct 2026 16:32:24 +0200
Andreas Wendleder <gonsolo@gmail.com> ha scritto:

> b43_op_start() clears wl->filter_flags, but mac80211 computes @changed
> for b43_op_configure_filter() against the flags it cached from the
> previous run. After a down/up it can report no change, so
> b43_adjust_opmode() is not called and MACCTL keeps the cleared filter.
> 
> Compare the requested flags with what the hardware was programmed with
> and add the difference to @changed.
> 
> Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/main.c
> b/drivers/net/wireless/broadcom/b43/main.c index 8f4aff3..57a5935
> 100644 --- a/drivers/net/wireless/broadcom/b43/main.c
> +++ b/drivers/net/wireless/broadcom/b43/main.c
> @@ -4318,6 +4318,14 @@ static void b43_op_configure_filter(struct
> ieee80211_hw *hw, FIF_OTHER_BSS |
>  		   FIF_BCN_PRBRESP_PROMISC;
>  
> +	/*
> +	 * b43_op_start() zeroes wl->filter_flags, but mac80211
> computes
> +	 * @changed against its own cached flags, so after an
> interface
> +	 * restart it reports no change and MACCTL kept the zeroed
> filter.
> +	 * Compare against what the hardware was actually programmed
> with.
> +	 */
> +	if (wl->filter_flags != *fflags)
> +		changed |= wl->filter_flags ^ *fflags;
>  	wl->filter_flags = *fflags;
>  
>  	if (changed && b43_status(dev) >= B43_STAT_INITIALIZED)

Tested on DSL 3580L, with 4352 chip on 5Ghz, the chip transmit and no
dma error arise. Without the patch the dma engine report an error on
the descriptor. Earlier in June i wrongly asserted that the DMA on AC
chips was needing 64 Kb segments, it was a wrong conclusion: going 64kb
did stop the error, but for the wrong reason.

Tested-by: Alessio Ferri <alessio.ferri@mythread.it>
