Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.155.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793129068;
	b=a3SZhJxiTekV1nznRZgGUbVKMW1Xje0f9v7q1tW5xrNXrnwf5o63TqddwhgTGE/m79bh
	 M50o0dgm7A2CfMEvDx2V5/0KpJ0zEA0QE0Bt3zs9l26LUTwOuyfZy0iRCJiTM9a3XRwyc
	 Acm2Y2klt3QuqNpurjU80bQLCzi7AAdtKoMvpuBwVdR6pLByb96I6xrkjkSobLKi6V1WL
	 IqDy07Ryb05k/EDkuwk6c9uWI01OzrX5nPA7u1bMbo8dersMZwglEzpXRbR0zR6nms/i1
	 m534Pr4dtF32817St0+9SI33/1r1lERT62ETemejt8jy3R6dhCteKWsejulrzgsqNcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793129068;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=r3HUfgAq+xH9Y5LBICd6HSFWui1L4PioHHr8T5utxG0=;
	b=t22BeceKYq2pSRfpEr3N2l4BubgXwEAsBqy8wRh2HS8i2/aoWl7TpVvbofiLSmA2XEza
	 chuYI+hIN5bIA2FN/QO0yycnDZKf7dUsBk86uxlEax+p+nHxVEJNA83taxO9sgW+eihg7
	 tgDzcTU7x/C8XN7zDHvF+Vn+XvkodwZcW5GDu6G5/9MoGlxMOw3KbZuUmJps8BXD8cmzX
	 MSr4ZxjGYY6wSqMty0o4k8SwECV92qNLmPeHoI636C3n2EfRpuHiLVJfAhYQ7HZz5ZU8s
	 V2Zg9QLVDpPVfaE/X5Cq+fg1BwhaD2ZCIF/HBEY/ARuYDlsvKQwzHEs205d0Z+lOXig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=KUeTccpo;
	arc=none smtp.remote-ip=62.149.155.149
Received: from smtpdh19-2.aruba.it (smtpdh19-2.aruba.it [62.149.155.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E952606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E952606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=KUeTccpo
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id LmmWxaLrRb24ZLmmXxQQWF; Tue, 27 Oct 2026 20:24:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793129065; bh=79hy8iQP6nWklqYhGA5zjobTc6oRuzwgvP/0YcslbA0=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=KUeTccpoX/GoQD8/qErDUd4YG8SxuqgpYZF+0OtdYUUgW+rJCPvsO0FFvLiweA7Zj
	 zI4LPfiVH38ctMfnnZr82nyUWpeARn7lTawSTviOoQURjpxUxc7VNhWOuww6XbQRiS
	 1SzYG+DGNQ3ASzpQZYk9hZBTC2jBH5gp4BuRuQhXLb1xiYoLv3G4G/yqDnuPC4KWsQ
	 7KZdwO2NnruubG6zKG5nVFTpueNNtViqLF794+hHs/FmtOSwxgPKGQ2YLiZbeRrisf
	 FyYDAc/sbbWXavWSHe7gxScNx6+rN0E8Jkb6dixR3r+7jVlNc3oKv7zr6ec8o1kgRe
	 dWQtjtyPYrAIg==
Date: Tue, 27 Oct 2026 20:24:24 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Andreas Wendleder <gonsolo@gmail.com>
Cc: linux-wireless@vger.kernel.org, Johannes Berg
 <johannes@sipsolutions.net>, b43-dev@lists.infradead.org, Michael Buesch
 <m@bues.ch>, kvalo@kernel.org, julian.calaby@gmail.com,
 jpeisach@ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 2/2] wifi: b43: handle 64-bit DMA engines
 whose index registers hold bus addresses
Message-ID: <20261027202424.7ae292c7@fedora>
In-Reply-To: <20261014143225.82149-3-gonsolo@gmail.com>
References: <20261014143225.82149-1-gonsolo@gmail.com>
	<20261014143225.82149-3-gonsolo@gmail.com>
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
X-CMAE-Envelope: MS4xfEDVfa2k2vHsr2FJ84UmPrST14eURm7sd4rC7mgoKCTzHNJ9lY6NKC6h9KdP1yYEGp6GfbED8NxpNPwkqlkGg0X+aR5TeuV9l0K668FBFhqERYXuJPHU
 46jw+KYNqI/34CMJW54/5lK/WWbdYvbf13huCBhW9tym/Q4DkC/45qmCRinKz3YSPsmmVUzHta46H+tab/fI4vgOgJ4xKF3eE8pEu9i011o7QRWyvBWjg9k0
 FDwsblCHn2uZkqaB0d76l9TploKHu6vBQRR/Eb5g4dQrZI79GutiEt9i6ysbAAbEbtNaQKxbQZFjKrncoNpQixJIzphA4QU8Z/rLialxXU7HMq78dhMapg1S
 54S6AVmcyvAA8Q8QJ/8fX73u54iTJKOZZqpIN8QPoslUrxAvf2mpphOmvs3hWAfmfWNpXwCTEGukH7jA6da/c5S9Gnm7uSH2tEmWXkUGYZqXSGhZe3c=

Il giorno Wed, 14 Oct 2026 16:32:25 +0200
Andreas Wendleder <gonsolo@gmail.com> ha scritto:

> Newer 64-bit DMA engines (found on the core revisions of the BCM4352
> and BCM4360) accept ring addresses with low bits set and then use bus
> addresses, not offsets into the ring, in the index and status
> registers. They are detected as brcmsmac does it in
> _dma_descriptor_align(): write 0xff0 to TXRINGLO and see whether it
> sticks.
> 
> On such an engine keep the ring address in the new ring->ptr_base,
> add it when writing TXINDEX and RXINDEX and subtract it when reading
> RXSTATUS. The ring address registers have to be written before the
> control word enables the engine, and the hardware defaults of burst
> length, outstanding reads and prefetch control (the *CTL_KEEP masks)
> have to be preserved.
> 
> Engines that keep offsets behave as before.
> 
> Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/b43.h |  1 +
>  drivers/net/wireless/broadcom/b43/dma.c | 52
> +++++++++++++++++++------ drivers/net/wireless/broadcom/b43/dma.h |
> 3 ++ 3 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/b43.h
> b/drivers/net/wireless/broadcom/b43/b43.h index c0d8fc0..e1e8083
> 100644 --- a/drivers/net/wireless/broadcom/b43/b43.h
> +++ b/drivers/net/wireless/broadcom/b43/b43.h
> @@ -668,6 +668,7 @@ struct b43_dma {
>  	u32 translation; /* Routing bits */
>  	bool translation_in_low; /* Should translation bit go into
> low addr? */ bool parity; /* Check for parity */
> +	bool ptr_is_addr;
>  };
>  
>  struct b43_pio_txqueue;
> diff --git a/drivers/net/wireless/broadcom/b43/dma.c
> b/drivers/net/wireless/broadcom/b43/dma.c index 05da698..20d910a
> 100644 --- a/drivers/net/wireless/broadcom/b43/dma.c
> +++ b/drivers/net/wireless/broadcom/b43/dma.c
> @@ -212,7 +212,7 @@ static void op64_fill_descriptor(struct
> b43_dmaring *ring, 
>  static void op64_poke_tx(struct b43_dmaring *ring, int slot)
>  {
> -	b43_dma_write(ring, B43_DMA64_TXINDEX,
> +	b43_dma_write(ring, B43_DMA64_TXINDEX, ring->ptr_base +
>  		      (u32) (slot * sizeof(struct b43_dmadesc64)));
>  }
>  
> @@ -233,14 +233,15 @@ static int op64_get_current_rxslot(struct
> b43_dmaring *ring) u32 val;
>  
>  	val = b43_dma_read(ring, B43_DMA64_RXSTATUS);
> -	val &= B43_DMA64_RXSTATDPTR;
> +	val = ((val & B43_DMA64_RXSTATDPTR) - ring->ptr_base) &
> +	      B43_DMA64_RXSTATDPTR;
>  
>  	return (val / sizeof(struct b43_dmadesc64));
>  }
>  
>  static void op64_set_current_rxslot(struct b43_dmaring *ring, int
> slot) {
> -	b43_dma_write(ring, B43_DMA64_RXINDEX,
> +	b43_dma_write(ring, B43_DMA64_RXINDEX, ring->ptr_base +
>  		      (u32) (slot * sizeof(struct b43_dmadesc64)));
>  }
>  
> @@ -690,9 +691,19 @@ static int dmacontroller_setup(struct
> b43_dmaring *ring) & B43_DMA64_TXADDREXT_MASK;
>  			if (!parity)
>  				value |= B43_DMA64_TXPARITYDISABLE;
> -			b43_dma_write(ring, B43_DMA64_TXCTL, value);
> -			b43_dma_write(ring, B43_DMA64_TXRINGLO,
> addrlo);
> -			b43_dma_write(ring, B43_DMA64_TXRINGHI,
> addrhi);
> +			if (ring->dev->dma.ptr_is_addr) {
> +				ring->ptr_base =
> lower_32_bits(ring->dmabase);
> +				value |= b43_dma_read(ring,
> B43_DMA64_TXCTL) &
> +					 B43_DMA64_TXCTL_KEEP;
> +				b43_dma_write(ring,
> B43_DMA64_TXRINGLO, addrlo);
> +				b43_dma_write(ring,
> B43_DMA64_TXRINGHI, addrhi);
> +				b43_dma_write(ring, B43_DMA64_TXCTL,
> value);
> +			} else {
> +				ring->ptr_base = 0;
> +				b43_dma_write(ring, B43_DMA64_TXCTL,
> value);
> +				b43_dma_write(ring,
> B43_DMA64_TXRINGLO, addrlo);
> +				b43_dma_write(ring,
> B43_DMA64_TXRINGHI, addrhi);
> +			}
>  		} else {
>  			u32 ringbase = (u32) (ring->dmabase);
>  			addrext = b43_dma_address(&ring->dev->dma,
> ringbase, B43_DMA_ADDR_EXT); @@ -722,11 +733,21 @@ static int
> dmacontroller_setup(struct b43_dmaring *ring) &
> B43_DMA64_RXADDREXT_MASK; if (!parity)
>  				value |= B43_DMA64_RXPARITYDISABLE;
> -			b43_dma_write(ring, B43_DMA64_RXCTL, value);
> -			b43_dma_write(ring, B43_DMA64_RXRINGLO,
> addrlo);
> -			b43_dma_write(ring, B43_DMA64_RXRINGHI,
> addrhi);
> -			b43_dma_write(ring, B43_DMA64_RXINDEX,
> ring->nr_slots *
> -				      sizeof(struct b43_dmadesc64));
> +			if (ring->dev->dma.ptr_is_addr) {
> +				ring->ptr_base =
> lower_32_bits(ring->dmabase);
> +				value |= b43_dma_read(ring,
> B43_DMA64_RXCTL) &
> +					 B43_DMA64_RXCTL_KEEP;
> +				b43_dma_write(ring,
> B43_DMA64_RXRINGLO, addrlo);
> +				b43_dma_write(ring,
> B43_DMA64_RXRINGHI, addrhi);
> +				b43_dma_write(ring, B43_DMA64_RXCTL,
> value);
> +			} else {
> +				ring->ptr_base = 0;
> +				b43_dma_write(ring, B43_DMA64_RXCTL,
> value);
> +				b43_dma_write(ring,
> B43_DMA64_RXRINGLO, addrlo);
> +				b43_dma_write(ring,
> B43_DMA64_RXRINGHI, addrhi);
> +			}
> +			b43_dma_write(ring, B43_DMA64_RXINDEX,
> ring->ptr_base +
> +				      ring->nr_slots * sizeof(struct
> b43_dmadesc64)); } else {
>  			u32 ringbase = (u32) (ring->dmabase);
>  			addrext = b43_dma_address(&ring->dev->dma,
> ringbase, B43_DMA_ADDR_EXT); @@ -1080,6 +1101,15 @@ int
> b43_dma_init(struct b43_wldev *dev) dma->parity = false;
>  #endif
>  
> +	dma->ptr_is_addr = false;
> +	if (type == B43_DMA_64BIT) {
> +		u16 ringlo = b43_dmacontroller_base(type, 0) +
> B43_DMA64_TXRINGLO; +
> +		b43_write32(dev, ringlo, 0xff0);
> +		dma->ptr_is_addr = b43_read32(dev, ringlo) != 0;
> +		b43_write32(dev, ringlo, 0);
> +	}
> +
>  	err = -ENOMEM;
>  	/* setup TX DMA channels. */
>  	dma->tx_ring_AC_BK = b43_setup_dmaring(dev, 0, 1, type);
> diff --git a/drivers/net/wireless/broadcom/b43/dma.h
> b/drivers/net/wireless/broadcom/b43/dma.h index f9f65bb..eddc882
> 100644 --- a/drivers/net/wireless/broadcom/b43/dma.h
> +++ b/drivers/net/wireless/broadcom/b43/dma.h
> @@ -90,6 +90,7 @@ struct b43_dmadesc32 {
>  #define		B43_DMA64_TXPARITYDISABLE
> 0x00000800 #define		B43_DMA64_TXADDREXT_MASK
> 	0x00030000 #define
> B43_DMA64_TXADDREXT_SHIFT		16 +#define
> B43_DMA64_TXCTL_KEEP				0x03FC00C0
> #define B43_DMA64_TXINDEX				0x04 #define
> B43_DMA64_TXRINGLO				0x08 #define
> B43_DMA64_TXRINGHI				0x0C @@ -118,6
> +119,7 @@ struct b43_dmadesc32 { #define
> B43_DMA64_RXPARITYDISABLE		0x00000800 #define
> 	B43_DMA64_RXADDREXT_MASK		0x00030000
> #define		B43_DMA64_RXADDREXT_SHIFT		16
> +#define B43_DMA64_RXCTL_KEEP
> 0x03FC0000 #define B43_DMA64_RXINDEX
> 0x24 #define B43_DMA64_RXRINGLO				0x28
> #define B43_DMA64_RXRINGHI				0x2C @@
> -235,6 +237,7 @@ struct b43_dmaring { u8 *txhdr_cache;
>  	/* (Unadjusted) DMA base bus-address of the ring memory. */
>  	dma_addr_t dmabase;
> +	u32 ptr_base;
>  	/* Number of descriptor slots in the ring. */
>  	int nr_slots;
>  	/* Number of used descriptor slots. */

Tested on DSL 3580L, with 4352 chip on 5Ghz, the chip transmit and no
dma error arise. Without the patch the dma engine report an error on
the descriptor. Earlier in June i wrongly asserted that the DMA on AC
chips was needing 64 Kb segments, it was a wrong conclusion: going 64kb
did stop the error, but for the wrong reason.

Tested-by: Alessio Ferri <alessio.ferri@mythread.it>
