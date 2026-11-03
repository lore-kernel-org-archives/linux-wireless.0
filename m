Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714390;
	b=omCeNR9VNUw0sVH5KjaW5/SgCrTXdNNKp0a+M7EjYfxOOVt379oKe4C5zbPpirjouubj
	 /KhsdBqdDIMfM+wL7G9QPOYwFOpeK/l7HqC8JwiGsoWt5v0ISEBMxpp8lbaSQDCdppIg7
	 J7gk9C358ehiZhoHnOFK7Nrzdr5zypiK0QAHzyXABvSm0Ft8p5xG8O1k/LStotm8av6Fa
	 j7UyZYt0UBIDDohnHvyEuYxoeKHVvlr9OR14zntR20l4uC0Ma6S6h4czF864too2Ii2/2
	 rXMBXxs/XcikgvyozmwKNvcmWyJH+pFyZByVHC0VkoWbPC66qIaIdgnhBQwQ/j94wuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714390;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=BPfwhnSKhhImT2MSjvVFfyGTbJZ+CXv0gKlK5lwoVaI=;
	b=fvS65hd82HKKtPUW7RYyICv66uO2eLFfjLcp7vae3gqHwj3inNcKptnAe2FtJOTJfyRc
	 roItwdYKrhdES59jTBrMrwujLmqXMlbHpAsyGku9MQn5MZmxg5ZfeoO81fIedFKeyzWUQ
	 L+WjxznMjvBx1IPIxhE2vrGa5FRc78VSbTkq63HhTgMeCsYVFitALzUE3lXnfmRRX9oKB
	 xW4sx6dXxfqG8mjBgTYinnCDQn2cFukxEfhjfITkyZemUNjY1ht5NwCGXk8actezbkoIJ
	 l4UDGCzMympC1LBoAh5uabUvA3YzorZsdQdTkuECfFfAzupM25evRJKFfl8EWbYwjZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Eks7S/An";
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049F7608360D
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 049F7608360D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Eks7S/An
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ae7626d14aso2279213a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714389; x=1794319189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPfwhnSKhhImT2MSjvVFfyGTbJZ+CXv0gKlK5lwoVaI=;
        b=IvCiWmpnItD0tjQ+kIlVmpXtX4uOtnv/K+EY9YXfNqvJs0sDWObKNGm8NbV/Nszeu5
         IvYPhnHL9TASMA5Ncv4zgtYO21QTH++nAH6lhSdsJsKE26R4MoeKAAYPh9m9Buts6NlL
         eZ/YZ4Etp4d9CCQ0DywfjHp4Qss4bKVrPFY4v3+dCOuI+WKrsNuI0rl+q3Ub71kSr2OW
         1IC0CB5hw11CLal6+5hibTEsyoi8ntr8D8jxJfiMkEyvgMq+COLQpsqPJ6ceASS1SaID
         Nr+9oxeLroWd3fRnNRntxV/kKARy9pkyX5UtUQmJ5fxMPTJzh0Ep+vZTMo4i3WWxo4Q0
         sEGg==
X-Forwarded-Encrypted: i=1; AKwUvBxClNINKppZ0qPVMXkEPVsw0ZtGCrCQqjgbAznxwJ4Be1QySIY/yWiW4sYGCQDNP/37fVF978otn+Awni4j7w==@vger.kernel.org
X-Gm-Message-State: APuU4Z+JQpn11M4vYxyvMySDbaLMUKzC+eMmt2OyOgbOB54mtganJRum
	2lEVMtPYo/HnA7GP1d/YtksluwkeJrrEbvUslyVFWShSYoFUdIPCwvYp7j/FzzMYXxhOUwkvPIx
	YCw80aG10tP7AwPpoEOt/AlVQJniN1144MCRZUaPCbmzYH6mbkj4j4qJYvxRS1p1HTFpHFX42rZ
	iLFPe2yYmu7/96Xq/VpoAy+eYs+hf0ZlNW1OV9WyVMrQFc3cvk2YXrqLTddnZJXf0w7d2b/I2Gw
	U35knf62rvi0SQk/QudTav4snCS
X-Gm-Gg: AYBFou3etnxWly90rEv65DxDJbwuduC4xCmgku7HuiusF4o2aClbTfrQp0plRPp4tQA
	TPYZa+5G2NDA7IpXXR4C/O/NjZpsllbMXzlZ7h4CPX/rdg1k0mdxCG3N1Al7vK2c8mkMO1mLDKm
	VN/KOxK7NJt6vCyvqFlhk13taRFtaLg6Aspk4oPj2TVCihhW/WcgJ1iQQGehZ4/9HPBwrKzvdAj
	mZ1JfQOl73NF8kDi1g84rELNjp/vcPZA3P9zQ4DQp1juV5JBC+qo6m/bqE4lSD5KoXnr9ATQbA4
	Qtyru0eDOmfbHAMHjTV9Gqe8lJy9PrxXnqUP7nesyZjmbQc+B8iv5gtM6D0ZBbXFK4mhaSjEvCR
	WXQW9MrBcIYxoyNRHsIwXf7wE3mISDnjFIJgTLZcd6TKoYw9NeEnCcIdlXsa0SwGUB87vNPOCCt
	1rGzZulxABXYSRT9mjt81GTNs6vc/4z+9/3NuQSUA=
X-Received: by 2002:a17:90b:2fcd:b0:3ac:a7ee:6780 with SMTP id 98e67ed59e1d1-3ae8986606fmr11586431a91.66.1793714389379;
        Tue, 03 Nov 2026 05:59:49 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07c4d7c5fsm1933570a91.0.2026.11.03.05.59.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:49 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35cbea41088so5668838eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714387; x=1794319187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BPfwhnSKhhImT2MSjvVFfyGTbJZ+CXv0gKlK5lwoVaI=;
        b=Eks7S/An1hyagSxN5dfkvPIOkwIavxcld/oFEZrgYcPjnme/MeuLwIl3b8Sp0Z0ric
         enUwWWNkH01zOHdfH9wPHpH+BtQt5wS1K+TCP2sHwyxpCoh/sdl9sC/qiPIWzA6IqGTd
         np9TxEOMd+p6ZUL+khP6LB9JldlJQoPXuJGgc=
X-Forwarded-Encrypted: i=1; AKwUvBzYjljqWj7CXJWu2ctiMGR9YIkNIbWinJZSJUMFR0+wBWPprXm9JgL49DxkqfBfKY+8KMYOtzVQmv/sP/Yc0g==@vger.kernel.org
X-Received: by 2002:a05:7022:b059:20b0:1ad:3402:733f with SMTP id a92af1059eb24-1ad3420f9a1mr19288284c88.44.1793714387437;
        Tue, 03 Nov 2026 05:59:47 -0800 (PST)
X-Received: by 2002:a05:7022:b059:20b0:1ad:3402:733f with SMTP id a92af1059eb24-1ad3420f9a1mr19288228c88.44.1793714386672;
        Tue, 03 Nov 2026 05:59:46 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:46 -0800 (PST)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Michael Reeves <michael.reeves077@gmail.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>,
	Janne Grunau <j@jannau.net>,
	linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 06/13] wifi: brcmfmac: Load signed PCIe firmware images
Date: Tue,  3 Nov 2026 14:58:53 +0100
Message-ID: <20261103135856.3676311-10-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-6-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-6-b5cbc2cde2fb@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 25 Sep 2026 23:43:41 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Hector Martin <marcan@marcan.st>
>
> Signed PCIe firmware needs a signature and a memory map describing the
> image, signature, verification status, and bootloader heap.
>
> Request an optional .sig file and write the signature and reverse-TLV
> metadata to device memory. Describe an aligned heap after the firmware
> image, keeping the metadata and end footer outside it. Require NVRAM for
> signed images and preserve their reset vector.
>
> Request the IRQ before starting firmware on chips that use signatures,
> while keeping ring processing disabled until initialization completes.
>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Hector Martin <marcan@marcan.st>
> Co-developed-by: Daniel Berlin <dberlin@dberlin.org>
> Signed-off-by: Daniel Berlin <dberlin@dberlin.org>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 267 ++++++++++++++++++---
>  1 file changed, 233 insertions(+), 34 deletions(-)
