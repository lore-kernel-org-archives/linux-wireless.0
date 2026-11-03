Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714357;
	b=kVTkpHEaiNLYs/f3Q5tzBLSmf5Xywz2B+9nr3CeBLc3kqaHHB3GeWhJZL29c5OKV8UNn
	 LIucHiGX7bCODNn7AzwYtVHfwznlINQOibOpJdGOODkboQcqdKceasNIbjW63+jC6Ynt3
	 pRCIYD6mMNN9KoR28pAW5Rup4k2N2KaiKptcJ/N33vj3pmRJe6pd4Crv8h1hjOv6ZO8w0
	 csTnBAqw3tNRF3RSzAPtJyzbOq/Nbb/2fgOUm0tZtkEIGob77gRDfz5ppkBb+bFJgCTkt
	 3WdUkSwcJL+5ASC6T0dp6xPeexSrd6lJQPaHKAE3ZhdJwD7yR6h/G0bENitPzMoHSuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714357;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=cvUJ5Fu74/yRvPGwst9m0ry7+LODDEe2Sn2iPk6DIvU=;
	b=Ly1AKP9PvCh4ckhDssxqtFKgYx9pBftg8hzBqyagmF8/7hsrfTrEBfJNuzkUHtiJBDgG
	 VXujF0Gyc+cKOUBlbORqJJl8IzzPdCSCJCerIs1hPrH6jxUCasjO+mnA3HnEHqyloMmKZ
	 fX2QpBJopqeptnGDJdhWFiZnJSF3MwVHL/ZSL8eNIqvCaLxB5Ri2m7DvGa7dH7Msz43nG
	 MKcHx3pYcXNJIshUU4qjdULjAkWVFPhFOaj+ZOQl41uSdo95ouom78Nums5XDnPrCW9/w
	 0Jxp40LM2XvI4E2EXlk6iup10J8kthFEa/KYETb+TzEFGwoRBiSZmqDBAfLM3tfwGAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EqGmpEv6;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62008606A328
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62008606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EqGmpEv6
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so484684a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714357; x=1794319157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cvUJ5Fu74/yRvPGwst9m0ry7+LODDEe2Sn2iPk6DIvU=;
        b=dVxkvHX7gq9pYKn9Eq9PlbcbrfkdiKr4wMxarrF6GlxzpXX60ZZ4HIvOQ69W3q7Gjx
         hCOySvb1ukKlPeqQODAnNJccyIzQZNaGzIekyQ9zX8KndglWfTTKWbmzA5F0oIf6+XjQ
         BL/op8Oe0oJNqKNIyrMgdIySik0XBK92/K4jbHHRZQcNXen9rfjH9SvkaszdaJlIbEnc
         3Jygb8f0WW/xG5bSW2c4mlWPvtdru8UvPX3CamMflbmhPESI4J6RJ4e55e4FpLf8DjHU
         fWvRWTcl8epokBjt4krMCWjzkbMKndxf4co4JZnnQAlVuDJYHTo5Rmb5p5wjhpBSRZ/C
         wEPA==
X-Forwarded-Encrypted: i=1; AKwUvBw1JnzznP48et5FawY4udyY0Mpb66RyAmUz1Tj8r9ZrDErFog2z+HBZ4/KgFKXi5EMIDVbyynbTT9NT00MU+w==@vger.kernel.org
X-Gm-Message-State: APuU4Z/5YgoIShJ9wGb/5NUNJtc+odYJk7Noee5+N2HobGqxkLbuBvTz
	CVLO1DMx2x7+mHYK6Tuxchyhfo7SWl3hcolx6W02N8OgTsksZoqlFYPGGnBWwymZRjbTovjZ7Sa
	RpxF27PatocGLvuyiC/iMvMHMFuHQ5XQhvZsArFl8SpwmnCkBOqwYIbtBCY3+thM/L0PXOcORBq
	Skiq7OQ08fpbTauBsud3ygnlSJ2xgEcaL4uNxiKZ+TUajBsOsynxwleC1b1uaVK3nHTXk5oQ0wu
	X/8FNNbfbiUrlKnrOPbyfIv6EaK
X-Gm-Gg: AYBFou3dVqkloVpL99IVr6Z0X7BGrxeWvC0kuXmUCtNHmDGBLCbQoawQPEjLvxMILWn
	pV3F2pZdN+pIRHCrnmYKNVcO0bZaGBygBkWYPkZ1JGS4xBPU4EQeWPk/F+ZvWnkMCPzP6nDciCc
	ED9Kg+GVdhqCbrOV0Aij5jQb8z/upHTYzzf3Ipyo3mfKBPrlOjJtaFx+AP0PQzbj/MLgpb5UxmN
	mjWWLyNTC6G1/s1tTWkXiWUNoMhaVMY6aI6aVdo52SmtlwpcT8ugjk4c0eHrdS5OALLl541snv+
	iNplw/XvffIfkfp7995/kfeaXTtfFxaDJsbjkM4Ble1eeeupGO29hAvneCnA0g30SLmIf9ZvQi9
	BJFQPv2Z9a2t1PY0jyvhHFjQarRuVL+2DgPa3oaJW13SNkJ0wMJmixueD8bQsgRVkptCMRAleKr
	SnygkAwtIm/Pf3Gi9mz0zKUk6660vGtr78qJgWs44=
X-Received: by 2002:a17:90b:1845:b0:3ab:8288:b8ce with SMTP id 98e67ed59e1d1-3ae8974d028mr6562359a91.24.1793714356584;
        Tue, 03 Nov 2026 05:59:16 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae881d509fsm4794424a91.5.2026.11.03.05.59.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:59:16 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a26fe9521so770085eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793714355; x=1794319155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cvUJ5Fu74/yRvPGwst9m0ry7+LODDEe2Sn2iPk6DIvU=;
        b=EqGmpEv6Uifhv7En22atUOes1uvdDqxZ6XccAiwoodEK0HrXblsV2WcYHL+WXzATLp
         vxJ+bkZOlBEr+zsp1KmM0vm3P4EwxJqb3B0a0tFd5nwUh0kmn9a/Eq7FWzAy7hBOAYPI
         pSQyxlGssdlApZ4g4TXfQwJeapvaxWZQnXDPA=
X-Forwarded-Encrypted: i=1; AKwUvBxdbSp1qY4Vn6t22Oqe5ugWO8n79X17OhdACbr7kFQqNf/l/NRwEecXtWI+LSmop6m6/oYp4XM+qVqJRxIjRw==@vger.kernel.org
X-Received: by 2002:a05:7022:7f0b:b0:1ad:1574:aa9d with SMTP id a92af1059eb24-1ad1574aab4mr16954565c88.0.1793714354608;
        Tue, 03 Nov 2026 05:59:14 -0800 (PST)
X-Received: by 2002:a05:7022:7f0b:b0:1ad:1574:aa9d with SMTP id a92af1059eb24-1ad1574aab4mr16954509c88.0.1793714353901;
        Tue, 03 Nov 2026 05:59:13 -0800 (PST)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac18458e07sm41658755c88.8.2026.11.03.05.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:59:11 -0800 (PST)
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
Subject: Re: [PATCH 02/13] wifi: brcmfmac: Match complete firmware capability names
Date: Tue,  3 Nov 2026 14:58:46 +0100
Message-ID: <20261103135856.3676311-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260925-brcm4388-submit-v1-2-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-2-b5cbc2cde2fb@gmail.com>
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

On Fri, 25 Sep 2026 23:43:37 +1000, Michael Reeves <michael.reeves077@gmail.com> wrote:
> From: Michael Reeves <michael.reeves077@gmail.com>
>
> BCM4388 firmware advertises "hp2p" without advertising "p2p". Substring
> matching incorrectly treats "hp2p" as P2P support, causing userspace to
> attempt Wi-Fi Direct interface creation that the firmware rejects.
>
> Match complete whitespace-separated capability names instead. Remove the
> trailing-space workarounds for SAE and FBT and reserve a terminating
> byte outside the firmware response buffer.
>
> Fixes: ec64241c9fd2 ("brcmfmac: obtain feature info using 'cap' firmware command")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.c   | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
