Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754333;
	b=NPQ7TPj6Mqkg1QHJ0S2goffMnJKyjvDg17WL1349Qym79PJP8IZPxFAsdB6lpHji/7Nj
	 Z+WIllE3APvXBA8Ru8UYsvWsYFfXj0dMtVukWkJWrRLSnMuxu7gOWFop462rr7dNwB9I6
	 mHykRamtqp7sZUhCc0CDjTu+IWbA8qI6PtbrtybnbkCsh8gT7dmmothLmfxUB7K0QhDZ/
	 y3IM8ZmLWdIV3AQH0bO33r5o8lui3IHc4Jy3HjsXFYSlHV1lS4NyPfdb+5tFAUe86vo5M
	 3jv8OnQHk/sISwoDp1uMOYVGM/+sQc6H+0BaGn1lKUMFFT48/huGubO5Mb3xE96/pvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754333;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4eYMQUVemRNKeyNl32c8fCLUf4CNfhmVQc8I+lOfp6M=;
	b=tRljF4nR8GzaA9akO+Hi9yzCYZFd94JtuQfKtgbU9AXT1FkPKmwwv8GTgYzJwui8Fk1G
	 eg/CQAiYr/YhfrfNhO3djcwJR3TQxCeqXwmGxlXRi3nBDEfcH7ueNI8RJo/NlyAjV7F8v
	 O8KLvL0Y2vbWoR+UawJjhm2batg9uQ7ungyRTfiiFMTAnwXuk0E6hbYpFN/d0aqUflmkB
	 5wH54wf2X96rdomZNsshRJNRWoa79nb9cjjOT1Xc9TTBe6SK+Mq5Zt4EBOpAc/0v96QCP
	 YcMtIUwSgp2C1Hp6YTq3Pc2oVjv6poJBRSteh6lSWq22xvO+cypkyccj0kSqp8Mb7Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PMKa8YNe;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22072606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 11:18:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22072606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PMKa8YNe
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so2015395e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 04:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792754331; x=1793359131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4eYMQUVemRNKeyNl32c8fCLUf4CNfhmVQc8I+lOfp6M=;
        b=PMKa8YNeG/x9GDtr+H7jOlnlObm+YMkoNfSA4qLaIL1ByELUULiMRq4vGj1tj5EFCr
         2J8qG7QDI2N+njIgqfYZ7jqvMGen7m3ekoryaLIQ50+yRpGkfe9m7UaZaYfR0gSMbd9a
         PKeg1kDRe61CXL27nZnzXSnhwzZjYHSRlwU8GiL6CqnV9YI0+xs8rEnGOPMOMknnJK7A
         OdJpiO67ah/CwOT3eTD/GhR83zsNztfS5iPIIwzczu2vsIDUp1yglnHpfTYwaXwuj+L3
         xNyE/LhUwMFbMC1iY60dCgZUp5k0Qu/jzpEczBVrRKNEwTeREaSIjdAjJ5coXert/4+a
         dN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792754331; x=1793359131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4eYMQUVemRNKeyNl32c8fCLUf4CNfhmVQc8I+lOfp6M=;
        b=ENabphTQY4w/HAbTMPLJuETFB4oRHVIZJwOLaPYmEapXMFzRGrCKuFTkz1o7MWTQPt
         y7reqQit1jYVftwR9JEGzRy35yD8RBtjhkIoY9czxEwBbtvRlJQExjD+PCtdxegEHnu5
         tZMsK10qxXxheF2BUD7BfyyAMNDKp2uyO/6AhIumF6ka8biJ+/4TfPNH+ywxHAqqIhpA
         H/qVARxhpZPmBUmNlZkJAgrusEFCTqSon/xs9SfubNf+ultYxzN2yyntN8pcsHC+CxDx
         CzQhzOG1hCRzlMxAlMZpsOUPpbb7VsvNL++zCtCdx2uIfjobW8z6ypa39qnVycxzn7/9
         aiSg==
X-Gm-Message-State: AFq9FYJfK+Q4WgmzwLg7BLJK32J5BM/CHTcrVeXD/9jaxKTKLDC5zgNN
	WgGP9D51T3RGPrETbo28y9vC1bKVBeZwkN92gftBcWY09lzEzHoehcdGcF/png==
X-Gm-Gg: AYBFou3wBfHV80W9tbN4fG9eRej7V33QEO9TGIAOWPtaExjp8c5WpyBtJmmxzHofhIN
	dRLr1ytC1sRl3uMuqnr7sczMMR5hhauNhXura6Vg4txGGWje1EoTFRoewPVFPx36dRmRJi4yPXS
	pSwdl+m/rs6h5dQG0fqiT9qeDu0tY3+jPv9nmT5UY+qL2BNq/ZjG8sZwsO5yDZRBWgb9iGrQ/ge
	mfg40ULO6OakBL1DHKY3TpEvbuq5tApuefeZ0xbpcDJgKS87FmQEwNkQ4gbx756ashw3ddvAzKR
	bkjrk8prdJLjyBjDEF2FBn2Cum+2SR0gUYzaPrJgDq/tiNte+cKixBuDvLPiioOAcvMaOjjcapH
	viMmema2lrp9/o8Nx63lhomNeMddoeVm7YerTTN2KZpdQZ7jtr7pyOaH8Jk4Y60ov3+UqTZKYCb
	Bud5aJFsBilgmCIozgs/ZYSW/BirzyCSgDFNHL25d3p1Q3PHptDa0jEb+zPLuwQKvx6+MehAX0j
	pK9bHcX5Sde8p2kfB7j9WEt+nke1ZX00FZYrmrDpUXt0NdhRauxSDifaJ1f7QVSr5LfyPok2D3F
	wJpHb9407i+r64bOIYuFA0fe7j5StesFn3gz/7uQ9M+b2S9CQwTJLhhnMHCVFM6OnTLuVJd9URl
	Hkw==
X-Received: by 2002:a05:600c:3114:b0:4a1:d492:1604 with SMTP id 5b1f17b1804b1-4a211eef48cmr29490235e9.11.1792754331286;
        Fri, 23 Oct 2026 04:18:51 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:e71c:400:f186:eea4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a215571923sm34503275e9.5.2026.10.23.04.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 04:18:50 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the rings are reset
Date: Fri, 23 Oct 2026 14:18:40 +0300
Message-ID: <20261023111840.2844381-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <74b5ab33c8a3445ea45d2f5d0c8d7387@realtek.com>
References: <74b5ab33c8a3445ea45d2f5d0c8d7387@realtek.com>
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

> I meant if you have more dumps in the future, please analyze them and
> give us summary.

Understood. One result since that mail, since it closes the observation
I said I could not place: on a healthy link HISR0 carries the same
unmasked bits while interrupts keep being delivered and the BE ring was
empty at every sample. So those bits are set in normal operation and do
not hold off the edge-triggered interrupt. Not a lead.

> Let's me clarify two groups are:
> 1. stalled TX ring causing queue_stopped flag raised
> 2. link (connection) loss (not clear yet)

Group 2 as you put it. Group 1 with one qualification: the raised flag
is a later stage of that group rather than the whole of it. Most of the
stalled-ring captures were taken while the ring was still filling and
the flag was not set yet; it was set in a minority, where the ring had
reached the stop threshold. So the patch covers the end state of group
1, not group 1.
