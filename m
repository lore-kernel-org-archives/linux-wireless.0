Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AAA47C105
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630185; cv=pass; b=JQoAEizoy6lpQAbX2jTdwioHyFJV7akhbz3Vxx1Xoz/Dj/SX4PQtQYH0ykBhJKO5iudic+gT4J2iqRBZ4U+7HHh8euwcrSHUmFjFzP6M7zzpfS7kI2ivbdDTEaIoj1QmEaWJFzvqLXfBFI8/PeKE1341A3XbOyKZkeMjO2UBjsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630185; c=relaxed/simple;
	bh=X3UbFhQzAa0Mw9xO9LHhTOOuDgL3VifHPJjvSa1lfcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mt5hUP1ebesp8C8KSzr95LCv4sSAcs2WKTc+Yo5csdMGMKRC7xeSIm7kzobNpuLF3v2dG5m1uE2I8MSPhu6yNTXobHuSyMfW96yMJH18U+sk6g2eoTUUnx0hn+Y4WDEFwMwl8DpDiURP20VWLcZkdnf4n27I+io5qD2bl+y50XE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=cxNQd89N; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="cxNQd89N"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f15cfdso424375e87.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 00:29:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789630177; cv=none;
        d=google.com; s=arc-20260327;
        b=ZDADlY1loRS8KIyJie8c83qsARn9lD+dEMIwToqER6X2z2yn3adVMGwR/F6oA1IoIy
         pY+eHxncqGUpbjTqssMJHCi3N63KC7cBqOMTNjaYSasxC6jTJrxDQwCYPKfFgneT7T+i
         D429xQ3XM/Lq3wXcG0Z99DAMTHNWeOopCtwo1R34IHzEMprerQbY0TBx5GLXzWLg0Cjr
         a8eqknaCsCT17WW+ItRWVaCtJG8bwXnZn5Hs/PhLVGb2mPqhvQIuDnrvVvj8GxjYVCqS
         mzSQbTVUrG3tYESYZl2KK5IRsQlgkbw13iUjHAWNsu7S/P9fkhI+m9F2jH7t0SZmkD8o
         BKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X3UbFhQzAa0Mw9xO9LHhTOOuDgL3VifHPJjvSa1lfcg=;
        fh=MhtQkZecYlWmxg3DBRqEiMKK1vmKtO5bFPrMDotOrCs=;
        b=QsQxPCA05MvqD0zf0WaRqfuPBBgyH8yV6wjTdGn0dfA5rMJRFdJPamT1ulubK0Hd41
         QuFGLGjoJe9m9BR9JTBy8ccCP/ylzbyr7w2EilJVQ2vwZFR6DndHJxM85P22i7tH2uJn
         2ZysrDyJ73/dZhk/5oMdzKXxNqPK9rwnARAxs5dTh/ZCA1Db1/N6FNDfZpXJpq7JDjHb
         UuZev4Gzt7ZX1aCG99F3W8cVS3xKnf6KbtKSIh1q75REdPlsx6V30Hyfwvkr6HT/F4XN
         PL4TZr3SUvpbdJ2pnQ+hGUKpnF5RmnJhWDPgIFm+jSdXR9gsUBH2EIUFMzZwyZQjdoyj
         u/Xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789630177; x=1790234977; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X3UbFhQzAa0Mw9xO9LHhTOOuDgL3VifHPJjvSa1lfcg=;
        b=cxNQd89NvK+k3yIjLO1S9ZnG5qaOMDvvaBihJjHm1piYUN+TJ9J4hZoJDCu/jN4BH1
         MGzz4e3nC3Jl3GpJCsYFygqtbDkK5RuivAzm5HhiEqqColzXOTVe2Y/XBxCsb4EDeVLg
         5CMREmOaTTN/FXt9Rnk5dwC8pq0H+B0Sf31Ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789630177; x=1790234977;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=X3UbFhQzAa0Mw9xO9LHhTOOuDgL3VifHPJjvSa1lfcg=;
        b=YgIE7F28qaYjKbcJ6GSM8Jb/u6n5ZgpL2AaRS+yC40DX6asU71y/ycn0gSDKHxgZSk
         GGLDBHLfBFUVpKIm9dU1HX9yci/dbNNnf6tgOEJYuKgYKr1RUMrjey7+VVwC8D+pOpBS
         97J1FZQXEi2oFsnQmP8PR4O9qC89FO9dzmNnyYnqpJAOZWrZ/ChV5eJ2keXlu5keAMJE
         YfjIvWl1Y9JXWoMdrPsKPIQ+JmYlVtnZe9ha+YePyBwLy4Ut3E+m5KpYnNnaDWD5pngq
         qPUwc22omAYCewBUfkY4p7QFoNbuyNDfM5PdU//ZBNM1ruTpvAN/U3SMTTpzc58xST9v
         nIBA==
X-Gm-Message-State: AFuF++l0RQDUp49rSEYAx4yLUF5TADOWvvg2K0v6ZUFhQ1OAJ76kc0jB
	eHFqEyIl0xR/VaaqjjmuaALbLUD6o7RmvuLg6UcY6oGH+uDbcYOBzhgNd3dzm3fSL5ts2Uy3ThZ
	euj2saR/dbYIPzbcbWCiE10qto9y2WhsZbLqL6qco1g==
X-Gm-Gg: AYBFou0Dq5GsL3vFyMcfG1zvH/irAzndrlPyehDMKTLopJ+jmtq09XKW6g1x2AauJbL
	NQivvyIzuMfebg555mpFWfpbkJDdOUxN9qMAmL8WxpYnt1NhgWR+mPFrfZsCKW+4Lz5loZFBYbu
	CTWh3Jx6ql/9TE1i8yWNU+vRA5rMVltYaDJ+EgVqBj2LF8qHxAuoDA1V9H6zDxq23Vq1wqr0Zhp
	JjeRR0k41J8YJEha8EOKWC9bdKmQRlX2rEbOfScLaZE9k5yfDUToKhDxCxNo0QeaqDwcJiMIcoN
	Sqo1brXr1zSA3tFcXhbc3rI7D2JWNdY49PHq3v9YqawshwuN413cx38=
X-Received: by 2002:a05:6512:3da1:b0:5b6:4ae:d87 with SMTP id
 2adb3069b0e04-5b8b66214c5mr1564777e87.27.1789630177213; Thu, 17 Sep 2026
 00:29:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-3-f09c964e0b96@khu.ac.kr> <2b956e6e0c5945e596d5825ace0c6203@realtek.com>
In-Reply-To: <2b956e6e0c5945e596d5825ace0c6203@realtek.com>
From: =?UTF-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghOyekOqzte2VmeqzvA==?=
	=?UTF-8?B?KQ==?= <5mghybrid@khu.ac.kr>
Date: Thu, 17 Sep 2026 16:29:24 +0900
X-Gm-Features: AcwNN1Udp1Uc2lpIVknPTI_jVxQzzmyOYan5TRYTMh9qrixvJkqLEg9-rrQ_nxc
Message-ID: <CAH1Bc_ybPZtieaMkuUdbpv-STvJTqTxbFZgVbifNdbADt21C9Q@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 3/4] wifi: rtl8xxxu: preserve RX requests
 across recoverable transfer errors
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

Thanks for the review.

Yes, the additional delay is part of the reason for the separate retry
path. For v3, I'll merge the common queueing code into one helper with a
retry flag, so the locking, shutdown check and list insertion are shared.

I'd like to keep the retry list and delayed work separate from normal
pending requests, though. Putting failed requests directly on the normal
pending list can let normal completions bypass the error backoff, while
delaying the shared submission work can also delay replenishment of
normal RX requests. Keeping the two lists preserves the existing normal
RX scheduling while removing the duplicated queueing code.

For the Fixes tag, the issue is that a finite burst of completion errors
can shrink the RX URB pool until the remaining requests no longer reach
the resubmission threshold. RX can then remain stopped even after the
errors have ended. I'll make that failure mode more explicit in the
commit message and validate the revised path with fault injection for v3.

Thanks,
Wooseok
