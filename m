Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73863BFAC0
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 11:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543813; cv=pass; b=MD4bb4ghwVvL37uaVkGXwie12Wrx9ypvp1d7q2IgMEuuS2VPyC7l7Vy9r25thxZkQ2KJJdunfgv0EC39Dd9Ch/Wez2D1JdvsYlv1PLRYulZpB61nNLJFrmPi9hqovU5wk8+jch53JZcZi75LWUO4wzBiLSJGdFtrgvbIjcjvQxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543813; c=relaxed/simple;
	bh=ZUHUFUY4NzCCSaGiOWXxAvH4BZ6AxctNDD8n2CNZFRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AaHDB97rE7jbF7ubXA7K07n/6NmBjbuLOvDPzTNx8oJZW95GZT2BLUJI/UtSGxspqGcv1tAfYTgqxkIT4EQv6gBBbkjfgRXEt5R+FYUak+7ap+/023OiESXsWc9hbj8JnYHiFse4iVERCtVyU9NGAmgFZmd6hWAK/vddDtP9CkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KuUL5fxc; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuUL5fxc"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c9995ca60so1662908d50.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 04:03:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791543804; cv=none;
        d=google.com; s=arc-20260327;
        b=FApciWhIjE5vxDfS4Ml83GQmAEKDn2Q9pTm6g5Bqh2ERJhAudfx4c+FqjR727AvZfe
         7uAUkmayypv189mxruaUU7T2qAJRKoE9//Ey/rvQDmNrNH4naVJUTJAnFzzaBKlssdAH
         BtVsV1dw5ekGMgpnVAOjUEtQqiFTEMMoF/SolpKrwxiSQbTynKr6XWzScsdfRYv12Uc6
         8+qzYWrqBsnnMn1UdnQ+cNC2eWwErSq63KTmoaZEO5eD2kww/D6Mx19Wh9RUUqsNsX8B
         k88GVfGe4bMHFmDs7Rfx8zeJEbeZv7BoMHGX/rbZ4HE4A3P1hPOSe0K+IekuDgVnQh0h
         Cxdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZUHUFUY4NzCCSaGiOWXxAvH4BZ6AxctNDD8n2CNZFRI=;
        fh=+dR4G9hLPHKlT+drFZxXc4C3RYYoLiZqH4FnVQ90ENY=;
        b=Je37xmIBXtIxGvVH4mc5vADcOebuWJgNvhm9hcdTmKqes9TiBK5K5TJz4K+DAdzERg
         2jfIFHJEImAVaglk2kHtDdGll6OoHxcl/k7QtFSHRgAZet3aetVtOKWAVphwqf/9Vnl3
         K/IQXNYBqONRgQq36NdB82Mtm9peMzAXPaYbsACNBulFRzt1BPVBXcrjHtMPrnjkQewz
         pcUzNSeawNykHer0I9p5lJBCXnsUULK9NMaQNbwyr8lCzGc4S0QvuSJZRSoZqnSOizoY
         yM02WvxPivQRJD9jYNT/AMn+GMfFPySST2xfyfK6AVzP+nqG76LtbOulIeXr5CQQ8sgf
         ZY5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791543804; x=1792148604; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZUHUFUY4NzCCSaGiOWXxAvH4BZ6AxctNDD8n2CNZFRI=;
        b=KuUL5fxcykoiJ60B8sE2/Jbh6gWDbrZrzlgAI16aEdAYiHXTwPtG0OeuyypciRxLc/
         fvohI8XzxJ9ZGZaTW3uo/5AOCAFcuG7wMvItpSUqyEhN/o52U4CJWjayVt7QR/ctW905
         VtE8GbS0xCdRuWJXZAPPByczERNlI5jQGiGdNGAVEOuNhdQLBsuXdvPIk8e7xorCCSMm
         Aj/pCYukXwLCXX4MeZW6B2B35mr9ndtxZMhB0mrnMRxMVS/MucFWrIBreDMMw1GV7SSO
         4Rxxc3xED2jJO9ru4elLVFlcvvfUNiBgD6z7HcC6C/PGGFaibNFc6qmYNb83RfCiMELb
         DYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791543804; x=1792148604;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZUHUFUY4NzCCSaGiOWXxAvH4BZ6AxctNDD8n2CNZFRI=;
        b=Kk2HEtOiIbVYk5BwnbAJfdOFGO667/rQFpG7naVEq8kcSLzW2xAChyUyNzWnXmqYSz
         tItpqOfDidJ66UcT2q7iN8SjQ2sJlVugxIKe0FkYzGA8fkv/MPy9s6TZS4VqDrHT/yvb
         8ZGYrvFVLaGlHzUE2tyDg4n247hcSxKKHnKdzdXDfKiW++OFjebP4y7buXRlzjxvr7H1
         iuE7Qrm5/ID4rm7i85yfWDw8oEyDlShJuwaLRJbP8lToXkOq4orElrwkPFngTqyK2icG
         EtuAND8eZPgRYpIERI7jZXi/oQux15RzWYdtoSYfwTQN5Md1Qkj5vHpOamQgl/dwfxYw
         Gu5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwI0snkuCrbonsdKqM6Z9PSGo3yNGS2mFUDezdIQQiNgUd36akekK8mo7t0bcKLBo/xsT5yhQxDJiGFjdCA+Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/tP0lZHimErxhLt65Q9MZm+4PSvZz+otL/QiYIRFanZTJvRhJ
	2KBre4fHRPJFAL4PwjakL/SBsV7mIaEjyIqfHrm2fWjFK7dfoiKwnui6qXTslzJwBw4aAdfBiuN
	vnH3Bt1W1u27+1MWFX1WLeDhtiPet0OI=
X-Gm-Gg: AYBFou1VsGiPun3LrLhvrZR/lUfO+pU5zu3nZ4xvHclvNvc21syX38F9uVD5sVP0PO1
	Ff8cx8KrQDCmM3A9PlIeP3/5qIlR957odqEUvQ62wnXHa1kYvjAUWmlLMjml/BP++M2P4x3BQbJ
	YlqOH+kWVxizkIbpy5Csw8aKJtjzWNDbyAMZ84LgwE5aOQlqZumkUrsuVXQRWKe2NpfPO1Y2hHm
	Snsmw4incijTwBoSpX69TfrmN0W8PIKrgzIFzPgkKMYnDXazGs0q3A8uEKBViSpesgrtq2OwO4y
	zlKIEYLHrZactzmcUkDWiP9Y4NTvM0/BYhba41jTCFsTPkhNFdDYF1Rotw67+FkgwPw=
X-Received: by 2002:a53:d013:0:b0:677:c030:7d9 with SMTP id
 956f58d0204a3-679368f9972mr341121d50.27.1791543804412; Fri, 09 Oct 2026
 04:03:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791408913.git.agent00791@gmail.com> <ccca0d5d087b862c3b41ab4d3c5849ca0dc2d32b.1791408913.git.agent00791@gmail.com>
 <e7181ed6-e14d-4fcd-a834-1ad07011b8d9@oss.qualcomm.com>
In-Reply-To: <e7181ed6-e14d-4fcd-a834-1ad07011b8d9@oss.qualcomm.com>
From: Nickolay Semendyaev <agent00791@gmail.com>
Date: Fri, 9 Oct 2026 17:03:13 +0600
X-Gm-Features: AclHuK8Wikn7f6BbrOGjigvQe4AyKjf4N1MfzwAWxqJ2Qv9Kxz-sdkvuemaMgOo
Message-ID: <CAOC=wvYtQ2ud-0F_YPV8pEP03LRZmDe02dwVJNMywa1X4OFF2g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] wifi: ath12k: make external IRQ control idempotent
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	jjohnson@kernel.org, wabsie@gmail.com
Content-Type: text/plain; charset="UTF-8"

> first of all, did you see any issues with current code?

I didn't reproduce a separate IRQ issue. What I saw on QCN9274 was
memory growing until OOM. I added this patch because patch 2 calls
ath12k_hif_irq_disable() again before freeing the RXDMA buffers.

> PCI already has a semantically correct and atomic state bit for exactly
> this, ATH12K_FLAG_EXT_IRQ_ENABLED, why not just use it?

You're right, napi_enabled is the wrong guard here. PCI already handles
repeated disables, so I'll drop those changes.

> As for AHB, can we also use ATH12K_FLAG_EXT_IRQ_ENABLED?

Yes, I'll use that flag for AHB in v3.
