Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBD22EEE75;
	Tue, 13 Oct 2026 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894649; cv=none; b=qULfh7U2MGuhIbjM2NMy7CMyzF3CQfP+kCeI3uZnUS8QLCK+oTq3su63iVwXp9aSXA4Ugt8j0GHDlzyHDmDJEP8xTHdBC14v2KsZnAhr+uEvAaITepKYb4cAEc2TAnZ0wlm11PDOtTHKgAXS83kN58kPUb7Yje2IUkTAZyOZmOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894649; c=relaxed/simple;
	bh=3WsMpTD+wA/q9olafF8hadHopK8DU2OBpOWNoPWDiQ4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LtUE+vCtMpWcDzLUNtiNbwH51rWAxpx8JtUqXsjiILtWYkk4hIPTAEw/Q+liob9kGaIZulDwwwj+FMVTYTY/8UAtCTNBrdmHeXKZEyCSyJeCd5RQlLivykncgDHncxNKzC0oLzhNcHxnLVF6JmyOk+9NoyiwUHWbdfJKTD++Opg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=trhlqGVi; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="trhlqGVi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1wK0uQSCpix3a5ocO7Sr4x1sOf27Q8lFTd4I414cvj4=;
	t=1791894647; x=1793104247; b=trhlqGViNfI+DF15yXtV76pbY/8M8vrEoVQNBsSk/+VcDmm
	zoA5esh6e72TCiHn9MFTGGO5Hlv56YcAs9d5WqtQTeiTspIHIZpP0Lo7UwJrGyEjExdxuyO/Dz27L
	NhbK0uUKRsSS9QlRSxBJnfCAdDCVEZyUbGw4dKwCdhGQTM6179bdd3X67tsM6eYP5Q1f9zBlQcmo5
	NqmZS/mYjIgpM3nBknheLbuURUHaY4rSryzqcW7zSI9Kmy4v+X772od+5mABBa531f6dNqlepGmAZ
	9otcI4WhCy8EmzD8gyvZvByXnUB7FB/btQoU09DiLZDNjC0SwsObLljUUMShX8iA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGbeW-0000000HNPo-15ec;
	Tue, 13 Oct 2026 14:30:44 +0200
Message-ID: <58b72ce94e373266537d5c0456772db69a8fd808.camel@sipsolutions.net>
Subject: Re: [PATCH] bcma: use the SoC device for DMA on MIPS
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>, linux-kernel@vger.kernel.org, 
	f.fainelli@gmail.com, Christoph Hellwig <hch@lst.de>, Linus Walleij
	 <linusw@kernel.org>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Paul Burton
	 <paulburton@kernel.org>, "open list:BROADCOM SPECIFIC AMBA DRIVER (BCMA)"
	 <linux-wireless@vger.kernel.org>
Date: Tue, 13 Oct 2026 14:30:43 +0200
In-Reply-To: <20261009213156.109965-1-rosenp@gmail.com>
References: <20261009213156.109965-1-rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-10-09 at 14:31 -0700, Rosen Penev wrote:
> The MIPS BCM47xx code allocates a struct device for the SoC, sets a
> 32-bit DMA mask on it and passes it to bcma in struct bcma_soc. bcma
> never uses it: bus->dev stays NULL for the MIPS SoC host, so cores fall
> back to doing DMA through their own struct device, whose
> coherent_dma_mask is 0. Since
> commit f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple no=
ncoherent platforms")
> coherent allocations then fail:
>=20
>   bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
>   bgmac_bcma bcma0:2: Unable to alloc memory for DMA
>   bgmac_bcma: probe of bcma0:2 failed with error -12
>=20
> Set bus->dev from the SoC device and do DMA through it, as the ARM SoC
> host already does. Every SoC host now has a bus device, so drop the
> fallback that pointed a core's dma_mask at its coherent_dma_mask.
>=20
> This addresses the review of the earlier postings: the cores' DMA masks
> are no longer touched at all.
>=20
> Tested on an ASUS RT-N16 (BCM4718): bgmac probes and passes traffic.
>=20
> Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple no=
ncoherent platforms")
>=20

That was in a MIPS tree, so perhaps this fix should be too? I don't
really know what to do with it.

johannes
