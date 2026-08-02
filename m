Received: from mail-oa1-f97.google.com (mail-oa1-f97.google.com [209.85.160.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD7390603
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659962; cv=none; b=biYKfn+hlzu6YjUhRw6lTpYfAYaPc2oxyu6IcDFk0rMBsu/9AMZ2scdPokaL+ZtRrrWLL6dfhxTidZCyvae4ETFKMAvbfzZc8aVRUHH3KmzadHwj+iLM1Z2yx2LWwPOXB2Ke+O17aUz7fPfHU1+G8jAW0Lu5dtE1lwZMPfXIcAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659962; c=relaxed/simple;
	bh=a8ofd41JnpFBwTjDBoMfI57jlMXgC5Ho/1LsoAdjqgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD30zOrjmBQ0Gj/oz48hl17f5z7pXT3yHMHpfBDakAYBkRc4lUh58TsXCLusdAjqBsGY/mZdCILsdexTxKouqFXv/Twa3GG712czHwmHzbl4upsVpZBOMvOgspgHJ/Oer/wvY9O6a/Gi4Iz1+CTqL0UIyPkPvM2Amm7oxg6j/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ghZWMDsD; arc=none smtp.client-ip=209.85.160.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ghZWMDsD"
Received: by mail-oa1-f97.google.com with SMTP id 586e51a60fabf-44cd237446cso1677969fac.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659958; x=1786264758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lR3bhmlqcQbP7TXCmWl9MzUNxiTSwB/0YI3MWW/Lfsk=;
        b=qyOA3dQj9j5Nx4T1SnTeJdvxSovKoD2QYWK67oFWM+jXOnD/f2W6xxjUsVehtejNXu
         BLhjJyr6LEYzyeeTXlkfB4AEsE+NZEzQetFEOZ6wqzhGg+wd6fLZs52gv4OKMl1c5vmw
         VfjSOGHa9oOBc3Z38JCtKfAhEyVzvTOIs1kCAMq7dfT1zx74/59zt96aOZ9/Z3OkbwZq
         Rn7ESmEd0D3SqpPqcu6RwGe7M5C23yB20EpRJmJFyZ9ReLNL3FGzYrI8kKb2VH0bUTlt
         ey63/cFUWicCldvE9ZII9WI4dha3D/tONxlCgyUvxPsiTTnrC167wQ5uDh54AiGcuemm
         bXeA==
X-Gm-Message-State: AOJu0Yw5wI+qJgvvI9jXfdNtirIFQTKxYT3EBxd1G2PDF5jFuloHQIqA
	UZhxKPqPeEb17k9xNbbNg2Mzd4AOz/BVBqSFAQf2q1R/UdysvmixPHSB6c+m1kQytkcZtDJ2UB7
	aNnW+DnlnZQkB3OVczH1dNnHC6AiuUWinFDKfYf1ulutSvE5eACV69iTRNBEzgImldopVNGKn6E
	FxgB1ZeJ0GCQmJRmqIMUVZdr/XrYWSWGfDZxzDN7cDFb9BA5g0BpdLXRAxYTnaAESBEUsAXXOUP
	QMLQaBbcgGnk+TujRv+kDhzUjXx
X-Gm-Gg: AR+sD11pNQK6A3PD88JkUSHMSk44HMJyW7npD9SNFj4rA71QiEv+JHB7jhm4IY/sFYV
	VOyhixGkfOTavRiJHcw5fyHMqte0fdplYjzct2jahapxQNUVnJRhm+YhRtgxYSTwDQDgDV2QFQY
	8owKNMGVcITximxPoGZbDNUbk3sqlQhYXdvVKXbcx46IsZPSxMXh0UB2oFpOR/uVENCy827xQ5L
	XUYVohyEk+AZ5v0RFOFDuvUMXPEfy5waHvMRWdGzag1C1rJ/RyEkh8qZCFMauAuAF+xeDpqyP6B
	c3XOS5jYG6dDw98GcHuC0hVvdby4TnCdh3axJnLGDTpKwNzDY2xaAhkbJZ325hxnVklsdAh3/3z
	chMW1JcXe3NRd000XIf/P3utn3wV2FXaz7gaFfy9orbdAO4C6EzMlc0XuDjoCJgp8C2l+6Kt8Cv
	6fmOXPjCqDnzG+A856O4wG+XYK4ZGfToPTdk4EEO4=
X-Received: by 2002:a05:6820:a28f:10b0:6ae:3e1b:2e4a with SMTP id 006d021491bc7-6ae433b04d7mr7185419eaf.18.1785659957883;
        Sun, 02 Aug 2026 01:39:17 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6ae39d5b461sm201297eaf.3.2026.08.02.01.39.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:17 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8fdace20927so22892136d6.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659957; x=1786264757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lR3bhmlqcQbP7TXCmWl9MzUNxiTSwB/0YI3MWW/Lfsk=;
        b=ghZWMDsDeOjPOOgr5PHNqE9ETn5nQ/54xj6btUDhL2P3mdtBx9rLm32dUwy2Q68vuc
         t6x4RYUQSyRFEay4RblOLbhG4NMnuHkMg30oG9m10dtW0DQ11E7vXfRMuBGGyjkV/xg0
         v4y/7QXJhd5haISCTmH3PbAbPpbB3jdoVUFXM=
X-Received: by 2002:a05:6214:3286:b0:8ee:b05c:596d with SMTP id 6a1803df08f44-9084967def8mr138780416d6.22.1785659956938;
        Sun, 02 Aug 2026 01:39:16 -0700 (PDT)
X-Received: by 2002:a05:6214:3286:b0:8ee:b05c:596d with SMTP id 6a1803df08f44-9084967def8mr138780166d6.22.1785659956516;
        Sun, 02 Aug 2026 01:39:16 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:15 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Can Peng <pengcan@kylinos.cn>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Sun,  2 Aug 2026 10:39:01 +0200
Message-ID: <20260802083905.3819981-4-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724092530.674624-1-pengcan@kylinos.cn>
References: <20260724092530.674624-1-pengcan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 24 Jul 2026 17:25:30 +0800, Can Peng <pengcan@kylinos.cn> wrote:
> brcmf_msgbuf_init_pktids() takes the DMA direction from its callers,
> but never stores it in the packet ID state.  Since the state is zeroed,
> pktids->direction remains DMA_BIDIRECTIONAL for both the TX and RX
> packet ID pools.
>
> All msgbuf packet ID map and unmap paths use pktids->direction.  As a
> result, TX buffers requested with DMA_TO_DEVICE and RX buffers requested
> with DMA_FROM_DEVICE are mapped and unmapped as DMA_BIDIRECTIONAL
> instead.
>
> Store the caller-provided direction when initializing the packet ID
> state.
>
> Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Can Peng <pengcan@kylinos.cn>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
