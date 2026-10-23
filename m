Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.203.120.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786515;
	b=Dyo0RYe/oha3OHxlHK1FnlNg1WFlxpE7zGniCH1/yrUbrKfP8idTT6KD7Cll4Scnuc69
	 qx/s3z8prP/lFLGs9QVSrSVJxmJPo7d/rEofkJZ1MAznccL1NswwKvbQgKo+JU22olJl6
	 buwY1xYsFiSVe+4k1GhceO+UkUn2EPnP0ISxf7l+s2RS9fOT6/+jgi59J8BqXP8p0d2KF
	 MbDbY8uwkHr0Yr6Qd5R9kL4I5ELIkJ4+JSjpWOnhw7inqmFV8t12/An5nC0fdgLreBbbu
	 1hE7FGuW0Yf+yF2uk6hZQMe4g1uDtKAU43RGo13/jfpQZhG77t+g8ewGu/s8GTTFZxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786515;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type;
	bh=m/PMCHPO/jr5fAoLR41c5oEssMjic1/6mLM+L0/ZmP4=;
	b=zS8zecnPBgYxr12i2xLwtBW1YqpN+RoKuyDz5ASM99vUXhbHd39dobZx8bhzy1Npi4LW
	 cFQY9yTG4QuBSRTjzK64/fvpe0OuIT9ZUdLnmQajw+yOTiwIGolb3n1psHaCyiCFwrYJc
	 SJFSOXaJ+G3wNnFhNGtU0yk3UGih8F2wKjEtp1TRQTtJoJn6WLSfF4Z6dNwGn7sDSR96a
	 u1+gKfzGr6pGEx1p0AhWdfKBDYWpzna5W6RwByQvX3Ve/HB1bzVT1y7Yjp2omCWiBkc+E
	 zF6jGSHPWkX96FmqkN8+gV1yzbKMQavWgi6biXXUBmr6JaVXEL4EKJsgRqsoyaVtECA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bues.ch;
	spf=pass smtp.mailfrom=bues.ch;
	dkim=pass header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=faQCOktY;
	arc=none smtp.remote-ip=116.203.120.240
Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB105606A31A;
	Fri, 23 Oct 2026 20:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB105606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=faQCOktY
Date: Fri, 23 Oct 2026 22:14:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1792786506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m/PMCHPO/jr5fAoLR41c5oEssMjic1/6mLM+L0/ZmP4=;
	b=faQCOktYlanW4afHud0z/jvY8YQ3Tmv0i2ALoSWK2H8If1W+1uJVT7tGEiHoYVYqK1RBO+
	rR1YQhmJtJ3NVUphzwW1X76OekfXWPY9+Z1BNPZrrNHb1S1c6Mw0NJKrryPE8ctkXF5mWB
	DMV8mOk7hWmENQPPj2am++9RrEU4+yAdDU/BvkAD/1Vv4FoKApUnQERaY6Tw2PfoiD4+8p
	MIasi1nbRa5Jb0kImelCHnxPQidwk3gbnyQA1gESF5Hqos0eM73UsMGgHSyJuu70pjBNFG
	pY8Nj/XLzX/Iz1h5LYjTnShAocH6ZJoBLNy4ipiyj4bZrrQ6P3HlVr8lgNavQg==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org (open
 list:B43 WIRELESS DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH wireless] wifi: b43: map the RX buffers
 DMA_BIDIRECTIONAL
Message-ID: <20261023221424.2722795e@barney>
In-Reply-To: <20261023190653.70741-1-rosenp@gmail.com>
References: <20261023190653.70741-1-rosenp@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EtGF2lcPb61ELDgqh=HK/KQ";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/EtGF2lcPb61ELDgqh=HK/KQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Quite honestly, to me this looks like a lot of AI slop is sent to b43 these=
 days.
Can you please slow down your submissions so that actual people get a chanc=
e to review the stuff?
Thanks!

--=20
Michael B=C3=BCsch
https://bues.ch/


On Fri, 23 Oct 2026 12:06:53 -0700
Rosen Penev <rosenp@gmail.com> wrote:

> b43 poisons each RX buffer before it hands it to the device, and drops
> a buffer that still carries the poison, as the device sometimes skips
> one. The RX buffers are mapped and synced DMA_FROM_DEVICE. On a
> non-coherent CPU like the BCM4716 or the BCM4708, the map and the sync
> for the device then only invalidate the cache, so the poison written
> just before never reaches memory. A skipped buffer is read as whatever
> the memory held before, for a recycled buffer the data of its previous
> use: garbage frames, or a length that sends dma_rx() into its path for
> frames spanning several buffers.
>=20
> Map, sync and unmap the RX buffers DMA_BIDIRECTIONAL, so that the
> poison is written back before the device gets the buffer.
>=20
> Reported on a Netgear R6400 (BCM4708, BCM4331).
>=20
> Fixes: cf68636a9773 ("b43: Refresh RX poison on buffer recycling")
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/dma.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wirele=
ss/broadcom/b43/dma.c
> index 05da6987a845..c8585c6dff37 100644
> --- a/drivers/net/wireless/broadcom/b43/dma.c
> +++ b/drivers/net/wireless/broadcom/b43/dma.c
> @@ -353,8 +353,14 @@ static inline
>  		dmaaddr =3D dma_map_single(ring->dev->dev->dma_dev,
>  					 buf, len, DMA_TO_DEVICE);
>  	} else {
> +		/*
> +		 * Not DMA_FROM_DEVICE: on a non-coherent CPU, the map and
> +		 * the sync for the device would then only invalidate the
> +		 * cache, and the poison of b43_poison_rx_buffer() would
> +		 * never reach memory.
> +		 */
>  		dmaaddr =3D dma_map_single(ring->dev->dev->dma_dev,
> -					 buf, len, DMA_FROM_DEVICE);
> +					 buf, len, DMA_BIDIRECTIONAL);
>  	}
> =20
>  	return dmaaddr;
> @@ -369,7 +375,7 @@ static inline
>  				 addr, len, DMA_TO_DEVICE);
>  	} else {
>  		dma_unmap_single(ring->dev->dev->dma_dev,
> -				 addr, len, DMA_FROM_DEVICE);
> +				 addr, len, DMA_BIDIRECTIONAL);
>  	}
>  }
> =20
> @@ -379,7 +385,7 @@ static inline
>  {
>  	B43_WARN_ON(ring->tx);
>  	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
> -				    addr, len, DMA_FROM_DEVICE);
> +				    addr, len, DMA_BIDIRECTIONAL);
>  }
> =20
>  static inline
> @@ -388,7 +394,7 @@ static inline
>  {
>  	B43_WARN_ON(ring->tx);
>  	dma_sync_single_for_device(ring->dev->dev->dma_dev,
> -				   addr, len, DMA_FROM_DEVICE);
> +				   addr, len, DMA_BIDIRECTIONAL);
>  }
> =20
>  static inline



--Sig_/EtGF2lcPb61ELDgqh=HK/KQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmrbwCAACgkQ9TK+HZCN
iw5vLA/8DgP3NmxzLRRtxhfbKFM0SPl36d7r97iUfi3lnPyV2HiDvZR6R2AIK7V8
FmSgoLZTk73e29ildUC5bzampS/b2Ds220dSxNNvEE1dkwxjatPNQvR69GnRnitu
Jtzg51WaJxm4CSzOxEpaB+IZbpoW+hC+7hNFZh5gflkfXjocPa14o/mCK3sWZyvv
kSHXf32dRPZpz4S92feA8Ll88QvfaNRpLpWNu6AyoFYXFxn6CYOkYq7bbidcNCYz
43zatonqNJ/WhjlZ/94XYTqjCFazz4+htEF6Ztp4u5xExX8eWz8eJzhq34gvd5nW
bd20jVnC6A8Away6q81wD5wtFal2Fa5mpyy6F8YVjSrAW6NmE+x6h/op0a1l0Vw1
N1j+aibPst8NJhXQ9+h4KfDEh5t4nVohpaTEia4wzNZOtQPEYoUyzK2mh0/KiQbc
1xOHEXcjkIsZ0RlzEQ3YDNqM9m7Q9t2HS4hrwfMGdWlW0TxmhbIEBSQHhySQmtvF
TEI4fTeTW8Xg5x+U2hdU4hkv+Knq5AAavykNBU9Clg+jqhq3OZIbsEY3x+kuJafJ
W0wzJNi4cPwQDs4q5lJOki++s6u5fC3wWmgOomzJYmMxEDmYcgr2VmdyrvNQeTu7
H6OsBVVrPQ9942VwW6LzuLyERgFScOOx4UYEPCMqfBHbnPSWQrs=
=nu7c
-----END PGP SIGNATURE-----

--Sig_/EtGF2lcPb61ELDgqh=HK/KQ--
