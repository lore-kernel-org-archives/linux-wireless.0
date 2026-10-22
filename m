Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655102;
	b=aD0Wj0ahOMsKArjqMvMYJ4xrLffFShkHeO9jgL5VwfWhzkb8TauVcYbTLpkcGyoIajki
	 4LUrz1KTdHJbNg3XALDhPOw+xkb+XGowk6fJivZkx6ikk7zR7h4YEAHEPZadOO97mQeCo
	 Xme5NDreP1brCmtRrTP1+xFWaKUmzRegIpPqwZi7FGztoTeH3Lh4EVy72KKzQGRShgHXg
	 jFkEvlIGEZ4LUonRrXoLJtut8/vM2nlzEb9XtnUVxJxSY4xgKaBVFQjYt7nATv8Vm3tkr
	 xigbTb8WrGXXuEG0wVdXjDSQPOThXU+qsqb6XpBZh+9ymzYa39IQzP54vQZ3CeVea7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655102;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=smBeIOz6NkG1jWU580xjUrdeHClJDdyW6/BAJvH47mo=;
	b=jqvtp54pfzwe9GLyfU09SgXw0Hmyvt9SXVz8fGKFho1E7ALpjorYxv+QzNc9H5t7Jbuf
	 YoQ2r91jLyMfQll/2dmnROnagY1aBzZtgD+kgszkq6NOEKBJ0jezJE8RNrRDT03GHUgi0
	 vIV1X27+G76PgJKChrw76RAx5id0PRV8pmGxucHksYSAAefqP3yTmI4+saQzqys+LjbWr
	 b1GjRHmmM5gX74w+e5u+m+kyWmNB5clwRVkty5lhUeGJ0lsnFYjG4L8do/FXO6I643enV
	 zqQIEw1hBBNQsAYoGC/8gpvTrbBxaCnVLElgPRHeItjRqu4qWwhCwv2ecK7JoJZGXpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eX6BfiDr;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1915606A321
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 07:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1915606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=eX6BfiDr
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b0584ad71so1046269f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 00:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792655100; x=1793259900; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=smBeIOz6NkG1jWU580xjUrdeHClJDdyW6/BAJvH47mo=;
        b=eX6BfiDruBiLbLZBcpteYeJVqVC98lz+f5/KVbddb5eNPfLQ6yJkrOjpPUAd2v9YNp
         XOPFqizz89CXH6creH6Z54YeYSBMElaim2KoNKbixrdnYzc31Bza3ODZv8VOgkj+RrMo
         /loiFPXe4sZPTbXLeLV6OC1abeF1CfDI+nOxthYAoLodAAHiV8yT+bjI9gOH4Hj1TGKl
         sVV01bcfla9f8m/K4jJGTs0IyB6I5KYP1Rd3PrFaPzbBtH2bOZi21cqGN3Fiz50saBXr
         lepd/eqVnLWmDrnbs342BYb7NE6cjmuwpLbHmgH7c6GJNOvA9Wdxc5TOL/CTNjQQ/GlB
         nojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792655100; x=1793259900;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=smBeIOz6NkG1jWU580xjUrdeHClJDdyW6/BAJvH47mo=;
        b=R2AON1pTQVV9WG5DRepF2NteqGlhr0HCz4fMs6vIGzJCHJBGwGEUpeGY8fus73SD3g
         vvO8HwWeRV/RYP4E2ec6KfAEPDWhSYOF6+1iZO/jfEybejcJtteGJiKIv1s9x3d0xUiA
         yX5yxYa9YkLH5eO4SrB+ts5Vj4GV1Lj51UO2QzJJ0n7w4juf8MiiNPbRujsogC9y7wFw
         FeeKoPJCHEC3e0iHtZipaH9Ma4Nh62klpQyu90dCfnH4teDFXeFnnmzPZOTNfTruPz0n
         D2x/zssphX3Z+n/vcIaqymDxl6/7lqv9XdM9TeDAPp5cyHEKTvvu5D+KSgUXTFBZK5qd
         p33Q==
X-Forwarded-Encrypted: i=1; AKwUvBylt5iSlDupr6EqdwYR79njkxhkaIUQ+ISmcgDbm90i9srliruy74WVwJnjPyJTMz32avfnDcTV+NyO+TLzSA==@vger.kernel.org
X-Gm-Message-State: AFq9FYInd43FWS/z2+PYfb891ro6VM1wqpIKV7BsqPQuxoGIqleRpMv6
	9Mfg6/RmURM96+UMnSHKNJ/VhSl2OTRmoPNldsE1r4mzsNg/cJUc3PdE
X-Gm-Gg: AYBFou0lrqCbwb+jfY8z6j2DKFGyJZcrPMOkQnjnXH/qs9TFqQSWqkfH+mP853XwjOg
	1HqyJFotxa+J8RdiM/4vE5NuUqOn2g083ohEHwQ5LpFKS3tyNxSgr5/1s1/NREY9I8XFdJLhdVc
	V6uFnczNZmHsmlCFai+X9EslOcQicDECzcWGWFDhofsVK4bWWcWrfgkt8RTh7MBumjgNlPyFBk0
	5HbktqdUDhU7MMEGQDZdLCgZnGBaudf8ZgD1UVHwwOzs7sSUsw59z9IcIBe1q70VgMwox8bNWNb
	6j++sb+faKBYjwVmiM6YMD9IQyWD9ZzyoH3fb2zB9cAmagIkwz675Dkul/ZJAKmEm3U2UQkWx04
	paMlCEiWWOsucDqE44gqAWcAIu2cjMvfuN2ZWdghcnM60b2/N3Rjh9oEKF79speo4Gz1c8/lchu
	75a/QlExiDCfvs8NI0VGONbDsxW5NOwCzmSB8koYig1D8GQYXVbCMYjYrgPqSaDq8uRLSk3qOc0
	gOmWBrzk6O+fYQ2YkR1OZdMtgBlsbDHdGPHSnTkR35vVuWAFQjTEPqpV8+aITZV3wfyMYnyfMqr
	HgMjQZsw+pQjZ4x9yLcW2xhOKLV835nDnc8=
X-Received: by 2002:a05:6000:420c:b0:48e:888:36b4 with SMTP id ffacd0b85a97d-48e2649d7acmr8838160f8f.9.1792655099919;
        Thu, 22 Oct 2026 00:44:59 -0700 (PDT)
Received: from ubuntu-testserver01.home (80.49.46.208.ipv4.supernova.orange.pl. [80.49.46.208])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2584afe1sm12084605f8f.56.2026.10.22.00.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 00:44:59 -0700 (PDT)
From: Viktor Pashaiev <w.paszajew@gmail.com>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Deren Wu <deren.wu@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Viktor Pashaiev <w.paszajew@gmail.com>, linux-wireless@vger.kernel.org,
 linux-mediatek@lists.infradead.org
Subject: Re: [PATCH wireless] wifi: mt76: usb: keep the tx worker parked
 through a reset or teardown
In-Reply-To: <20261021233935.748017-1-lucid_duck@justthetip.ca>
References: <20261021233935.748017-1-lucid_duck@justthetip.ca>
Date: Thu, 22 Oct 2026 09:44:58 +0200
Message-ID: <179265509844.119209.13611344830854882043@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Yeah, fixing this inside stop_tx is much cleaner than my disconnect workaroun=
d. Checked the stop_tx call paths across mt76 and the worker state handling t=
hrough reset and teardown - looks solid. Built the modules against 7.3 withou=
t any warnings.

Reviewed-by: Viktor Pashaiev <w.paszajew@gmail.com>
