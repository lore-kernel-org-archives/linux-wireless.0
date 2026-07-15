Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CAC442FA0
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140417; cv=none; b=YUpbd5um1cNOW44dUy9IqklcKAk3+4V4bVo3Jy2WeVFo73Q82qJMfJ965fmGS0JrmHOPw6rgl4L2laVfSxG9PHpToPkhicF6zQHoBnPfq/g6D/Lcc+VgPAuPWV/vQGx1t4DfdubcVmGYClql76h1HEqHyDAXMKfPqBUmdzwG4eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140417; c=relaxed/simple;
	bh=XPEkn4UlRz2dBihu6PB98HoFP+K8ePsRHX8aeHWJM/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efLHJgQD0zzcfg+wWH6rq62mpbPNpUmgnNDgxmuRydRz570vFsMCOkVQ+sUPokl+ZVSebhFCjqkZhvI3ArqVDqDRvIOxdi1izxgBXS94ulHKaJykJbW0KugP5tL/I7V+JNaoPcg8gdSPVrOWyVli5xb62vkeavyPU+KW9RUj82M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=ytJDqFeH; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="ytJDqFeH"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4953ddae026so6725645e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 11:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1784140408; x=1784745208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPEkn4UlRz2dBihu6PB98HoFP+K8ePsRHX8aeHWJM/E=;
        b=ytJDqFeH+q5IEcTy49Y3tR0LwCGhosOffAcQx9mVenclQURFU8FkH8gTJJE/HEoVC/
         wKW5hWcc6RFdWvshZJuTyitlKOmgClPEdrMEsIYZWoKJLflTOCdZg3xnenMS99eLKf+w
         AfkLbVMZz4mPACbjvoE7cE5iw7AWb0vOqJY+yq1HVdKeGKuHVzIdnqdCGjp4bGUDTVJe
         GQrS2wOwWRT9KCeWaQSU2HjBtjKuxekuMFSf1pt8x2p4gEv992Wn8MaQdgZ0df271DVh
         V2X/tn9EiPY9pqhlXnZ/Vuai+0kohKbGdWaHnc1ovGH1dR5hVSPA4N1sQyjpX2fAz2Em
         qMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784140408; x=1784745208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPEkn4UlRz2dBihu6PB98HoFP+K8ePsRHX8aeHWJM/E=;
        b=W6JjHi8/Mc8GUN1cJ8SpIThZ9B4CJP5Mwfyw1e2yDuXwHdV1YFxzxakGsYZSzotTtc
         wHDfUvhZMCvXkyaOcKwTPw60KtH8YeixP3olEQg8rA8lGqT+OuZHRQvt3Luu21CMX6u+
         k6icGOt1fBFfkQSWdsuUsZLLqFWEsNvnoMDz+7ury10BSeIkqj2YNX4X/UQgE17Qr7U9
         50ERoMMLQBFdgGzCzz2AY1Lr/lBEaPReh/FXBeMO3pEqZkl0GtMvQxhQ1oEc2MjyvPrM
         iSt25VlBl22XWyp0c0E1etD+t73W8EOWHx6mpaGSAQHRtyDB5YvE3PXq72VokUQaKFwE
         wkjg==
X-Forwarded-Encrypted: i=1; AHgh+Ro1dW6qGujso8i01lPEa3sj8KfHky+BQi48UvqdScGkDnVvevjxAyj+zRA3oVhfHMxBeyjJo1SYJEw2ySfuzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxM8ywa3rpqeSuZAgfvPXtpczifY6t8gvDaZ1fsBNDDrxBacbGd
	tUg8gHRPYEUgvF2tvqVVxZZNuhe+ZKWluHOuElBtsFL6xD6rlrAS2oIRtyMg8UBWLzM0
X-Gm-Gg: AfdE7cnyOd3RZ23zWQVGCN1ymdR3ldPDpBYAPeYpmQOG4u2RbYfqM4EYtYBTBMtpguL
	T6o0TE+w6sqA1bjmTS7PfRxHv7KQtcfm2m5dk20hqgJvK/XWpei1c022RKUbSJNnRjYkkJcytzq
	0i5QxmurOAapXQvJiCd6Yt+ys3jWf7Kb9dKtV9w6HS246NQqx9XHybsmkaaBXduEO5C63KkqvW6
	yODyhbtwUW1PdRr/Yqx/+sGljQUAjP3LMWsG1+Ma7LB9lUVLtCtreoV9uIjIYepN05K76/J3hu4
	N2sZQs5NDQ+k151AKadk5q8aXow6CIXGty99V82ZOkl2G5XlyOe42e6WCQK+Us84rMhP6ePfcYZ
	PESHj7FTp5kckU0DTK0GD8XRClp/pQnRD9qNDjs4JvbtPD17xPP7CcRLOtNOVyA5ifh1d5LHb5f
	rvEfkwa0mEapKjrKiMjvBamNJVmJ7Qp6U4hLV4yoRf9b4cFjXvJymtlGzDHNzEctNYYTtVJC2NR
	eBSTRQ7OZXOl0D9tM6lnw+C8IZEAh49mpb8alATBwE7sw==
X-Received: by 2002:a05:600c:45c3:b0:495:3e08:ad19 with SMTP id 5b1f17b1804b1-4953e08adb6mr33169345e9.9.1784140407405;
        Wed, 15 Jul 2026 11:33:27 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e93295sm1302175e9.10.2026.07.15.11.33.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Jul 2026 11:33:26 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Brian Norris <briannorris@chromium.org>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: validate HT/VHT capability and operation IE lengths
Date: Wed, 15 Jul 2026 20:33:25 +0200
Message-ID: <20260715183325.45521-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715163458.GA149147@francesco-nb>
References: <20260715163458.GA149147@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> My advise would be to do the same we are already doing, and unless I am
> wrong, it means that we skip the whole frame if a corruption is detected.

Makes sense, I'll switch these to -EINVAL and send a v2. Thanks.

-Doruk
