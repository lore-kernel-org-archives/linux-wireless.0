Received: from mail-lr2-f30.google.com (mail-lr2-f30.google.com [74.125.230.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D753B14C0
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789628793; cv=none; b=KQ50NafHUXSfNxybkYbKhaZQBbqyhBZmNhVjIoNkah7PD9/XVu/nhorQA7rVLiEkEjgsUjhCOxhZFTV1WTlauuSCTKcVs9UuDdvSVrU8NQpjmX3sKB5d2M2ar+veRp7lBt9T5iHNjAEljHEeiIPc4/M0pK9ACZdmF9YQqBUqH6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789628793; c=relaxed/simple;
	bh=Huy0vpOdb+xU+xq2T8HxWv7xnUhU8w5frVPeuscTGJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qULBimyKIAHHXTz9IwSYzRwkZ4bG6nApOjcqCLtGCgZEGZKvMjTgnDKwd/OBo/NKxaGSJPIaUjD2Ki/j8ZHOu4uCxHCiX9BSk2UrNdVv+eitJ7gT+xIx8MknNWV8QzUU3oH/CAfDBIVzUlSpOQe4fUX8IpjZnEj2wKlpWDeSl34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIJnAPXd; arc=none smtp.client-ip=74.125.230.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIJnAPXd"
Received: by mail-lr2-f30.google.com with SMTP id 38308e7fff4ca-3a318299b38so4959631fa.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 00:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789628789; x=1790233589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xS2ROdM3t9ezFwrSV2+IwOwSp+lNFHCFMXSmUbeDh1M=;
        b=jIJnAPXdg8fNb1f7n0oAXRYhwWKpTW6aJQ1CwQy51Z2bfbTd1F7JaJpcHlnbm3RJkj
         6xvqcpdU2PW66rd0krtIlZZCiggmbQbr4YJul442m7h8M2ymm9B+nukCvdp04azr9Sbx
         7GZa3ZTdbIQ6BdmXI5L2zS6abuBjSNkhnOSzbOFdVlxDLOpIDKWafF/C0KeVNzNlzv+Y
         KMYhtj9REJjoMtA4yHj5lEppsqEKt9Pcr3X6xDR7VfqtNcTBHX7yjt0/+U1r5JqiaxId
         KTrShbSJIxrxiGyQt0ie/xJ+w7u8B4rXr+mXIisk4TfgAMtExg5anGuyc312RQLmb/io
         M+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628789; x=1790233589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xS2ROdM3t9ezFwrSV2+IwOwSp+lNFHCFMXSmUbeDh1M=;
        b=fSgG95yVXWtQIaCYi/0UC2FkMauHCu+MjM7pDHRW4IVZJwMFTzNuQ/QPgYggAcM/nx
         RQS6iTxBNpOVgGMGx0bt94YCFeyAEJDEKfU1wJobvIkL3VJMrQmtMP9JQkuOodonO6KH
         8VRh0SAar8iRIoRCg4ue0zZFKgeB+4Uy3ADMoJajHmL/YTNK7kkybJXpNKe9bHFIMuTM
         JSq240ypXgNQGGJfn89PbVnzEVsJatxEAUOCrzBZZxXKWH+PKY/9rDXkAMWufN1trBdL
         Tsl+PUZ6mMifuHfHirJgWaUZuElUq4j3ZO/qnpUxkcGpwDcSCqKxwvASrXh8elqrlojT
         icpw==
X-Gm-Message-State: AFuF++kLYMipZlpt59hJOgCFjvw2w9X8uSE36Sk4paAzDKNDaX4o+7eL
	jjblK6mgcKsDk+fMLJXw4EqOsRTsy3XKZXk0YZYWzNyA/UOo78c4s1Aa
X-Gm-Gg: AYBFou0tyi6PAcBmNE6M9dHTgC+SlUbRm9FZFf9OIWYzObxWpkysC7Km0841OALzta5
	rYy8a70NOTPdeNdC0nBFNCNhQ4hrZrgFed4gDCS+e9G3IfN4fb+73VPwPHM7+tJqA4r9OPaXTER
	jLD4B7uf3CDDW8SwTFiHFAhCf3+zNzObCcvBnd4608yOpEcUD+ijE1LV/z+UbPM0u0EQh74+UDM
	2qDpl3BXgarle0l2+K924MjNjvo1XqwoduoqwGWy4zDdsQX2yVxX/QKKkZeZNnXY0YWxOxyP7Jf
	Uy/9FRZzYLBGNkVsddfBneKbL1Pbp0noVof09NOddAKSQC9lk2BJesNDGApzl2qYUWkW5PsRueH
	b+OoNw0nIGR8vP7Xm9Evdmlg0if5lkwDMDvjYP8RFoZiS4kjLaHxFYBP5D7ZiDxCid8IMHYFAqK
	dqV7QuBa3x1eMQdsFmW0sJwvii2f1tl4yiEWmHO+Q75bt38726+5lsRgXcrsrZwlqVAEd9DJGCd
	QzZdzAdWRFEmPnk
X-Received: by 2002:a2e:a595:0:b0:3a3:7680:67f5 with SMTP id 38308e7fff4ca-3a5dca03e98mr9854301fa.20.1789628788951;
        Thu, 17 Sep 2026 00:06:28 -0700 (PDT)
Received: from localhost.localdomain ([94.29.126.47])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a5dafdca36sm12946991fa.35.2026.09.17.00.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 00:06:28 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: Re: rtw89: BT connect state differs between scoreboard and bt_info on RTL8851B
Date: Thu, 17 Sep 2026 10:06:09 +0300
Message-ID: <20260917070609.11949-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <776cd43f75f14571943462bd5fc6cb64@realtek.com>
References: <20260915122625.6341-1-skokovmaksimevg@gmail.com> <20260915123718.7239-1-skokovmaksimevg@gmail.com> <25270f2066784a02806daa352643be53@realtek.com> <20260916053228.10042-1-skokovmaksimevg@gmail.com> <776cd43f75f14571943462bd5fc6cb64@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> To be clear. The problem you encountered was failed to connect an AP, or
> this was newly introduced by the patch I shared?

Not introduced by the patch. It predates it by a day.

On 15 September, with an unmodified driver, the same machine logged 21
"authentication timed out" and one 4WAY_HANDSHAKE_TIMEOUT in a single
boot, with an A2DP sink connected and playing:

  wlp2s0: authentication with 02:0c:43:16:60:e8 timed out
  wlp2s0: deauthenticated from b2:39:56:12:24:f0 (Reason: 15=4WAY_HANDSHAKE_TIMEOUT)

It follows the audio, not the driver build. With the sink stopped,
association completes in a few seconds on both the patched and the
unpatched module; while it plays, the interface stays in STA mode
retrying. That is the coexistence behaviour from the first mail in this
thread. I mentioned it in the last one only to describe the conditions of
the sampling, not as a regression.

> The BTC_BSCB_BT_CONNECT should be set by BT firmware. The internal BT
> expert is helping to dig the cause.

Understood. In case it is relevant to what they find, btc_info here
reports the BT side as

  [coex_version] : BT_FW_coex:0(Mismatch, desired:7)
  [sub_module]   : BT_FW:0x0(patch)

while the mailbox itself works, mailbox_avl:Y and raw_data updating.

I can run any test build you want on RTL8851BE.
