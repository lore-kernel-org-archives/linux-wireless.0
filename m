Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.155.164
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793950673;
	b=5XcVF3iaj3GrrDutxFhWyYQG0zBYJdh4ZaFmRWhGSzvCs12VvG9wdPOoLSxFRYchuAps
	 l4XbxRRwpZSkMnx6kbdpEQ/K679zZXw/BopTnVO3MKHTTTv98HXLQnQriXoGbsNtRBSER
	 s7Uo4Kfec6Cg1M/ABqeL526GqSn/ZhAHkDcew6El3hnlpVITmKnv/1EBTTYDch/oAYvB0
	 Af6yDcDiYKddbpJ+ZueDzMipmySPzPQFhvul0+ACraAPz4RmA3g6kSSX+Yq/iyoIbhku+
	 iFG+bFRPrzNkKCTgNEl9uDvD7PWDoJ9yc4nVRcOyMTu7PkjptuKYMLEZIeHemeTxoDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950673;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=AXj+GOg5w68PUtm7k5ZRDyLb7F9+wUb94LES03vSX4E=;
	b=BOoE8guh/feRgwdmj3nM3s7rSHpX6eOPmzKKqSpOVMy4PZ4kzGzkD63s2/Kl6qgGf+ex
	 ILndsO9qrMt67aCJQqrwZ1GMdzYatA67TFkpvihadrqfExyTVgae4KqQhDZV7SNtI6BOW
	 MeDiXSRDSDAnnUM+jBCjcvwNuYnBGLSGHusOq7aP4r6sXxRDVdvZCsFMB81B2DSDIW0Co
	 PHHXaPtJ40CijWX9QYfAtXxZTot3t2loUF938Ca/Nt46xI1JW3nQBZZ6h0/PViQjAqrZy
	 r9/hSYY41W5JS/Z873ALn7Njlxlo5WzIcbwRTC+vYmPpBWPks8OL2bJhLdNnfjMQbrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=W5FpLjtm;
	arc=none smtp.remote-ip=62.149.155.164
Received: from smtpdh20-1.aruba.it (smtpdh20-1.aruba.it [62.149.155.164])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54564606A33C
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54564606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=W5FpLjtm
Received: from localhost ([87.16.49.252])
	by Aruba SMTP with ESMTPSA
	id PEW7xsYn9YWYhPEW8xWt0E; Fri, 06 Nov 2026 08:37:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793950664; bh=lrhMqVkvC2l9wTfLx9KxlyC0W3KVM5fsim8Tnpe93nE=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=W5FpLjtm5zrQDqnWOu7zCbMVr+T/v6F4x0hIuONyVIcOMIDQeoVshEcVF4LmKG3V8
	 JcO7fjZn/nSL6mHK2G573RIVYREf7qvEMFvs2kZ0iXjM3KZqpYXtA28ZS7t+JlJUWF
	 Q5fxXX2br31T1pqTRd4ngAl8fNisNFz0f/DBZjG/cFSAY3pmxPtbhQdWnJ6gByydBU
	 7B3sktTzYdOvo+vLF9UDdIXMmlX9dqT8ZB7ucU3mqBst6NgecER4lpEe3FLWtF7kky
	 bnoaAGawjMsRb9b8KGioiIYQ9F6y7Ny9NEeStaylTl9J2Ctlzl7OyKfcAFTZ5UVA/u
	 HaFhg7RsH/YMg==
Date: Fri, 6 Nov 2026 08:37:36 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Luca Casati <luk00casati@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
 arend.vanspriel@broadcom.com, b43-dev@lists.infradead.org
Subject: Re: [PATCH wireless-next 1/5] b43: N-PHY: fix the TX tone sample
 table
Message-ID: <20261106083736.00006add@mythread.it>
In-Reply-To: <20261026181543.77763-2-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
	<20261026181543.77763-2-luk00casati@gmail.com>
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
X-CMAE-Envelope: MS4xfKMMvZqQOwT4gbLw30XyDK0dIXXpytAPVVz+WpYfG98p64NbabkiO5Vx7R29rUy+zunnIfCV4QCnqn1uE1qt6ygKdF4J9qQYORa4+RvGw7NeE3jvLyH0
 wo7y8/68suKFFozWJSYhnEk8lanrJg6XNmwd/lgP7E5E450xW3b6p1WZxlwi9suADe5hwXY9IJeEzr3VWH2QP5RnkTkmTM05hfi+C4zh2QA3hSSW4zSu7sZ2
 6VkUcCrbwgIrja5mar8aN4L3TkdIQG3iKoein8Xi9HFxwKwqhe93WD7FjjRFO1tIhi96ZDN0AqL05TLWUPnGWCHo3iUxFy8vBGD+lFT1JyI8tksxH3A3BPfT
 IUZ56i4h

Il giorno Mon, 26 Oct 2026 19:15:39 +0100
Luca Casati <luk00casati@gmail.com> ha scritto:

> b43_nphy_load_samples() masked with (0x3FF << 10) instead of shifting
> the masked I value, and b43_nphy_gen_load_samples() fed
> cordic_calc_iq() a 16.16 fixed-point angle (CORDIC_FIXED() of a value
> already shifted by 16) held in a u16, while the function takes whole
> degrees. Together the sample table ended up all zeros, so every
> calibration that plays a test tone (TX IQ/LO, RX IQ) ran without a
> signal.
> 
> Compute the rotation in whole degrees as brcmsmac does and fix the
> precedence.
> 
> Tested on a BCM43228 (N-PHY rev 16, radio 2057 rev 9).
> 
> Found and fixed with the help of an AI coding assistant (Claude Opus
> 5.5), by comparing mmiotraces of b43 and wl on the same card.
> 
> Signed-off-by: Luca Casati <luk00casati@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c
> b/drivers/net/wireless/broadcom/b43/phy_n.c index
> bbc30cbad..66565c14e 100644 ---
> a/drivers/net/wireless/broadcom/b43/phy_n.c +++
> b/drivers/net/wireless/broadcom/b43/phy_n.c @@ -1515,7 +1515,7 @@
> static int b43_nphy_load_samples(struct b43_wldev *dev,
> b43_nphy_stay_in_carrier_search(dev, 1); 
>  	for (i = 0; i < len; i++) {
> -		data[i] = (samples[i].i & 0x3FF << 10);
> +		data[i] = (samples[i].i & 0x3FF) << 10;
>  		data[i] |= samples[i].q & 0x3FF;
>  	}
>  	b43_ntab_write_bulk(dev, B43_NTAB32(17, 0), len, data);
> @@ -1531,7 +1531,8 @@ static u16 b43_nphy_gen_load_samples(struct
> b43_wldev *dev, u32 freq, u16 max, bool test)
>  {
>  	int i;
> -	u16 bw, len, rot, angle;
> +	u16 bw, len;
> +	s32 rot, angle;		/* whole degrees, as
> cordic_calc_iq() wants */ struct cordic_iq *samples;
>  
>  	bw = b43_is_40mhz(dev) ? 40 : 20;
> @@ -1554,11 +1555,11 @@ static u16 b43_nphy_gen_load_samples(struct
> b43_wldev *dev, u32 freq, u16 max, b43err(dev->wl, "allocation for
> samples generation failed\n"); return 0;
>  	}
> -	rot = (((freq * 36) / bw) << 16) / 100;
> +	rot = ((freq * 36) / bw) / 100;
>  	angle = 0;
>  
>  	for (i = 0; i < len; i++) {
> -		samples[i] = cordic_calc_iq(CORDIC_FIXED(angle));
> +		samples[i] = cordic_calc_iq(angle);
>  		angle += rot;
>  		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
>  		samples[i].i = CORDIC_FLOAT(samples[i].i * max);

Drop the added comment, claude like to add random and useless comments
all over the code. Changing rot and angle type is not strictly needed,
but ok for consistency with brcmsmac.

The rest of the patch is good, i encountered the same problem.

Alessio
