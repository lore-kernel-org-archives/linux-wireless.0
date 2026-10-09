Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72B24E2F35
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 11:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791546671; cv=none; b=mySI5rmk2tmlhyoU+nqDXVr8YWDRlrXlx5pEIFbPYS+omTILui5JbXRYZsYKJetdij9lJzIIJcCWwRA/omFW/TgiU6fnPJzAzX1qTuV5eVIQ3Jskjr9T3JdfXVLABT0opertq2dk3XqQ7P/sV7wj3XAkRMeEZOVSco3JEaw707Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791546671; c=relaxed/simple;
	bh=+9VzHvUO+JK+X+9EZspf1HzY5BaMn/HduNK7JOTMGiM=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=nHQ/t2MIv01ta/tQza6q/aPa/HteO8dzLsf7rBbQPlVLWaTEQ8D1mGOFFrM9VoLkUjaw2QxeuNjIJ5/43xr9CiaWWw7h+S0LCeif4ZATD8iWhKYBC/i7E91eQz56H/ASlHJ/4eVbF/1L/4Zm2fIg+lbG6TxHFqeTqQRaVgS4Hc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oD6LxpIt; arc=none smtp.client-ip=95.215.58.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oD6LxpIt"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+9VzHvUO+JK+X+9EZspf1HzY5BaMn/HduNK7JOTMGiM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791546658; v=1; x=1792151458;
 b=oD6LxpItmr1/xsa/uKeyHhVj4hsrlbuGhjMRfDI1bodiOqZIAcqpNjhWiBSS2S0HzLJTC8cO
 vWcDOO6bGAE9v8//mONMjGyGZPtc/MFbbvcosB4OO7wYP8slygoDv6+QsULeOKxtuFSk4cXtOsf
 98tt5VuH4YBywATUdh6JePno=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ab5c969723dbd39a;
	Fri, 09 Oct 2026 11:50:41 +0000
X-Mizu-Trace-ID: ab5c969723dbd39a
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Oct 2026 13:50:36 +0200
Message-Id: <DM0AA2YBXFI2.HD7B6PLDQ8FU@linux.dev>
To: "Hungyu Lin" <dennylin0707@gmail.com>, <pkshih@realtek.com>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <pchelkin@ispras.ru>, <mihaildimoski@gmail.com>,
 <tristan@talencesecurity.com>, <rtl8821cerfe2@gmail.com>,
 <dawei.feng@seu.edu.cn>, <learn.rahul.rai@gmail.com>,
 <branislav.klocok@orava.sk>, <timlee@realtek.com>, <kvalo@kernel.org>,
 <briannorris@chromium.org>, <yhchuang@realtek.com>, <sgruszka@redhat.com>
Subject: Re: [PATCH] wifi: rtw88: pci: preserve the RX ring DMA address on
 cleanup
From: "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20261009032339.31786-1-dennylin0707@gmail.com>
In-Reply-To: <20261009032339.31786-1-dennylin0707@gmail.com>

On Fri Oct 9, 2026 at 5:23 AM CEST, Hungyu Lin wrote:
> rtw_pci_init_rx_ring() stores the coherent ring DMA address in dma, but
> reuses it for RX buffer DMA addresses during error cleanup. If
> initialization fails after at least one buffer has been mapped,
> dma_free_coherent() receives the last buffer's DMA address instead of
> the ring's.
>
> Use a separate variable for the buffer DMA addresses so the ring is
> freed with the address returned by dma_alloc_coherent().
>
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index 66d2e5f51444..10147375f3b2 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -298,11 +298,13 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtw=
dev,
> =20
>  err_out:
>  	for (i =3D 0; i < allocated; i++) {
> +		dma_addr_t buf_dma;
> +
>  		skb =3D rx_ring->buf[i];
>  		if (!skb)
>  			continue;
> -		dma =3D *((dma_addr_t *)skb->cb);
> -		dma_unmap_single(&pdev->dev, dma, buf_sz, DMA_FROM_DEVICE);
> +		buf_dma =3D *((dma_addr_t *)skb->cb);
> +		dma_unmap_single(&pdev->dev, buf_dma, buf_sz, DMA_FROM_DEVICE);
>  		dev_kfree_skb_any(skb);
>  		rx_ring->buf[i] =3D NULL;
>  	}

This patch should cc stable so it gets backported. Besides that it
looks good to me. Ping-Ke maybe you can add Cc: stable@vger.kernel.org
when applying to your tree?

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
