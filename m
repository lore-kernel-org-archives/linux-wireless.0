Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D66F201278
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 22:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791932243; cv=pass; b=d4DKK6uo+XzA2rR3oxsozp7wDkAAh6CUBpeqNhTSQ3CBrUaWIn9Wxo+HLEOa1xs80nUFK2B5fwzU4tszRR4ZDRUC25wbgxo3dfvTFnMOF/NLttdcNbORhWhPnWSSb9/pvNz+Y9PZdEqZOGYKiE/pOkCutXK9n+PMyYwsIUp7zq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791932243; c=relaxed/simple;
	bh=uX5yLfhSFHtOGX4a7Azn9QZQsopUM+sBaevj4rp2hjY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cFGm5Ah/hc9pWazvcfAOmXzUdDy5i15+wW5k1nwWXYXwwSGuqadwUDzto5kOTev3ygtVSPluesRsSGeTOy2MQwz82N4/673qeV1XCZCi96IjcUO3yWZKrLiap40olKx/s1Iv2qqwwa2yJRGq/I8kpQhav3sS2gheWvop4NRtIWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5d5UmZ9; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5d5UmZ9"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso7200877a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 15:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791932240; cv=none;
        d=google.com; s=arc-20260327;
        b=rzU7byw5YF34g5BGGPEB4fQkQZ9ywWV257TgyMyNAwUmn96koAYfuGfxnA9CuOEvTW
         5SXecsxYV1yvHnAIkRzQcFjuhbw0HxJU2o3TYXnEJp8yss12MZnBT9cTs+hROkKnRH2D
         px6JimZv0cIiSMKFYa3SA3tlxdeZGgqJQ6L0s4nrmgyfRqMYr7JMl4g4ShFKY+pchD/T
         mlBBLodtRY5STUZ3Dep1iWbWZxYd8NsLBHE0Ia9PcKmjoJGSY8/k+nznIo948Y0Lp3at
         ADxFmk1oM9gHhInEyFyTKdnhH/ig+zi5vTWHwmphQj4+enS9qIoQ5/UNmHSqF1Ndhj6b
         /vkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QFbc5zfO+ObMOre/yDc/Xu9h9BlesWAQjbdtJOd31Gw=;
        fh=FwBb2Z7EvSGV5Rlx5rvoQ2u9s28ypfMfJVrSKu5UAww=;
        b=meGeCmlEW/7vnsWiXM9B0F/XxeQ59uvQeWGatGKo1MNqecna2Zrjsyi+5vbr/bKz1+
         /JwU2C7DcS4RFlywVXpft23jY8ok9ZS+PXCQB0HyH+k9XvG3UXIxh6ydVOgzWGeGqBuM
         VKIxQPbwER9jrEpFaWWUmVpwZavxCDjFvp47/Vlg4EUtYD2vj4KMaVTJj1SpTJcSADyE
         eHFuYKzWxq9EiGfx4ag9IcJksKDNeEVx/F7h59vyHFJ/2DlrJc9Dab3l+7l03ZvT/FiT
         eOUggcAlXLsRnMLO0No7+f7ktqLoX/0xppzLvL4OWd0MnQhDmZoWDbwd/V4uYLzJ57uf
         df5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791932240; x=1792537040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QFbc5zfO+ObMOre/yDc/Xu9h9BlesWAQjbdtJOd31Gw=;
        b=K5d5UmZ940TmPXzYbNnV9A5CAqkDZ79wICgpQcunIvZFEByadnk70E6msil8v3e2u3
         uFYaUASeG/hltztCKuATLEV9/GccjCMCYS8z95B4cMtbr2yU77EsLoCa29DBwz1h04Or
         gJ2SR3IunaZDXCYKGiR7wwmKjoi3d4Ia4Fq4KAYmDmZmLK0EMPPAEsN1mAfWx27dR+bh
         k2THprRDHyDH2BuHW4mso+1W05OTWHGdGnweExOpH7BouAEMRwdbHVaARpXiHVjRv9Wu
         MQw+yHXauwow2USsRrM8nEZ6q6u9SWC+jrrGheO5eZCt9Kr6S2ggFsH60rMN9PDyCWv0
         m+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791932240; x=1792537040;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QFbc5zfO+ObMOre/yDc/Xu9h9BlesWAQjbdtJOd31Gw=;
        b=hcKf8mPrGgsWuk7y1JVtMWZZWE/bHp6W3kwvnHxcmgdbV1udNpcNuiCYICD8+uclZq
         Kov50a+RUM86vDn0DZUsqCcaBQK3eKuVtrwihqF/Vmss3Cw2gFY3U5jkQikXObwDxmNb
         362+gTq1FgBQhgD7utaYU2FluB2l+ALtNSqaUVxrozl+rfczy41VmwE1C4R2qv9vRFD8
         b8kPOJwak+/VXbG6T6P2za3dPekEg9OkAniHwSAM/DsJ0iY9GHHMxEQz3O6/J7xHjAuZ
         wIgg5keUsPuwgFloxVmId4KGjPzt/AdxcmKCn6nnz1fMaa3iVWKxR0iBLMus6l0FxtqO
         0ScQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1qd5Enupq+AaC992u9IlEMsk9MwKfmtngkBu1IsrCXGOoT95l406ve2ylbJFpivItIFJHn3WDV6c7S+4dyw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJi7vNZKbkpJQtOskGuPrvrpTK4b7CM1Axp95sGLGX7GM/c6een
	68MPoaaS+Dncf/YuPNTwXA64620svwJX4bk/ExYzoac992P/upDwHVhoOeLH5eSnHsTxAPx1enz
	u+0OXyCzgC9nB5pb2XYH4g+l/YcAHH2s=
X-Gm-Gg: AYBFou1pSi1kG/VUU3M2VmEvDl89wHclpkbO71M/R4QpA9Ir9D4s/4VhX+5YyZS9uJa
	bCHixk6TO8xocXSyrpeXoJ9RSqh4eZuj+UJN8Rl9Ii8udJs5TQpra97svHfV7J01k9TJoV0AsNF
	4JyGexJZG4+pQAtdyC+bNiyN1vgUZFDWgN6JJJm3POAXmPOS+fXV8Ekym2rLNiXOs/0dK8gkyzC
	n/h5vPlrbwbmJAlLWn5wTXKya4wk61ygE2PIEOAAt/TX3djRXSQ8mdU2dal/N1Mqqodkfl9ftHx
	vNAFhY4//cC3D5bp3SAJcj3UfOeOzA5LWkjJDowZNUo64vYoXbZSa8b/2PiXkGbIu/lwMG+X77v
	iIZK6mDtQBDzwXasAZ5eORUpSlwYmDEpHbz7V6JSyTU4xHbfOUE/FgwcbY+xx/EsJmGGiCnKkNA
	yeYkUGO1+qpOrLbLNF0SxTutw2GauHypxfYDoeA9+N5K77KMrStK2zVWeRmS1SGzVnuA==
X-Received: by 2002:a05:6402:46cf:b0:6aa:8d3b:a70 with SMTP id
 4fb4d7f45d1cf-6b17c2b572bmr10322068a12.15.1791932239478; Tue, 13 Oct 2026
 15:57:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261009213156.109965-1-rosenp@gmail.com> <58b72ce94e373266537d5c0456772db69a8fd808.camel@sipsolutions.net>
In-Reply-To: <58b72ce94e373266537d5c0456772db69a8fd808.camel@sipsolutions.net>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 13 Oct 2026 15:57:07 -0700
X-Gm-Features: AclHuK-7v4grdJs6crA6dpzaj61POSwZjpa8dXYSW1ynd6F4b5DPbbXNwTc9QY4
Message-ID: <CAKxU2N8BRM7rBdPRMCQRFvOWas43Lmi5BoTsVxbsNvueqxjmPw@mail.gmail.com>
Subject: Re: [PATCH] bcma: use the SoC device for DMA on MIPS
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, f.fainelli@gmail.com, 
	Christoph Hellwig <hch@lst.de>, Linus Walleij <linusw@kernel.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, 
	Paul Burton <paulburton@kernel.org>, 
	"open list:BROADCOM SPECIFIC AMBA DRIVER (BCMA)" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 5:30=E2=80=AFAM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Fri, 2026-10-09 at 14:31 -0700, Rosen Penev wrote:
> > The MIPS BCM47xx code allocates a struct device for the SoC, sets a
> > 32-bit DMA mask on it and passes it to bcma in struct bcma_soc. bcma
> > never uses it: bus->dev stays NULL for the MIPS SoC host, so cores fall
> > back to doing DMA through their own struct device, whose
> > coherent_dma_mask is 0. Since
> > commit f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple =
noncoherent platforms")
> > coherent allocations then fail:
> >
> >   bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
> >   bgmac_bcma bcma0:2: Unable to alloc memory for DMA
> >   bgmac_bcma: probe of bcma0:2 failed with error -12
> >
> > Set bus->dev from the SoC device and do DMA through it, as the ARM SoC
> > host already does. Every SoC host now has a bus device, so drop the
> > fallback that pointed a core's dma_mask at its coherent_dma_mask.
> >
> > This addresses the review of the earlier postings: the cores' DMA masks
> > are no longer touched at all.
> >
> > Tested on an ASUS RT-N16 (BCM4718): bgmac probes and passes traffic.
> >
> > Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple =
noncoherent platforms")
> >
>
> That was in a MIPS tree, so perhaps this fix should be too? I don't
> really know what to do with it.
I thought it was weird as well. The last submission was sent to
wireless-next as well. FWIW I ran get_maintainers.pl
>
> johannes
