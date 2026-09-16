Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24504B827F
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789582698; cv=none; b=NIXiLbZNH2ODUGOe4h/nIRIXCpQik8mLw0gDC9KOaj9wBbkuK28cnePd/vzPI+M869ZS9YMGhiJPFsJ1nl8NaQ3PEwYfZb7D/bBAp4wazxBRQ9kLLgGB+YJFzBcdgZ4tnju+9y0Jk39gM55Z81/nGs+ccOWThr9KLCoG488Errs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789582698; c=relaxed/simple;
	bh=qmNHsftrPigc6z9lAhD5TrQ9HA5z1cFLq5Fdk1Pby1Q=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E42+oSXHpOlNrh/ISTJr/a6X4UExoQLiON9mo40SBiT+PpxSi6QFS9Li8DEwKtaHhllBbTuqv1BWPNeYUnw48WnHzTFNaqYwGfrnfXVGLSiTiU9gJekL8OY3G8aZvFyjhRSpC/PMHnYvcTXCMg0oD/qDWy9euefU5aV026119HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luD3KYPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luD3KYPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF301F0089C
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 18:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789582674;
	bh=NcQe03qyUu7W4K18zVzWNwv6MgOA45mAnb9g7/iXl8I=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=luD3KYPtQ6rVMU3canU+kY6TJZHae8NyVUBeWdM/TSLcgcyFEK9fHqsZ1Lf/ggrPJ
	 +AQ62gV/2VLSfGIbVcm3QyD+DhZTf1ZWcGCI+LJQ5f8blfGn637DLQd0cvnGT8nR5V
	 g1Drbzd11p8TrUI3uM7g39+m4LS3EYGDxxxRnlAdstpY2wJHyzZCTpO+IfOal5J/F1
	 IhOMNQ/BmPqwUx/8F18mbeqf7+0srQYWLOOcOIyIjE97ZzzOG5bAR3gkXLMMQ1c7xF
	 pl4hKbBH7Vkr6CLJK70t3r2GEdvHpXocftmnMqRKAftqA2OQmV6mJUzUgehhuO6z5y
	 6qlQanImIhZkQ==
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b76ff64d78so1145496e87.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 11:17:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwAxcRFQPNDhKsaKUDVRgxCRmMbKOnGs6H6jtaPrjoXDcsg8c2jFJ7GFamt1weU6X1Zrpcq5+dw+AwEyZN6OQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nKWQEWl4pSfMO50a9l+JKsiyt6iWPwr/MZt92tGIPORPK4nZ+p
	1PfjwkQnrcseayITojtLL13y3LbwBl/FvScc/YLk5FDsf9utsifLfQVSXcTdX9Zv9uXl4VjOIXA
	GfzQnkkjHU65KMXn42he+83PyeMJvWxhOXXeEANI+9A==
X-Received: by 2002:a05:6512:3345:b0:5b7:f0b9:ea7c with SMTP id
 2adb3069b0e04-5b8b6605f11mr972331e87.8.1789582673568; Wed, 16 Sep 2026
 11:17:53 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 16 Sep 2026 14:17:51 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 16 Sep 2026 14:17:51 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260907090956.2825703-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907090956.2825703-1-arnd@kernel.org>
Date: Wed, 16 Sep 2026 14:17:51 -0400
X-Gmail-Original-Message-ID: <CAMRc=McRc9Aw-5WBipW5QhqqHp4+UKch15ui3E8a0srk2CUN7g@mail.gmail.com>
X-Gm-Features: AcwNN1WT39KCCBGzK8bB5OYELfDMzkO3xawenRbklBZjDzeHGIgp80Nbi0LahYQ
Message-ID: <CAMRc=McRc9Aw-5WBipW5QhqqHp4+UKch15ui3E8a0srk2CUN7g@mail.gmail.com>
Subject: Re: [PATCH 0/2 v7] gpiolib: finish the legacy cleanup
To: Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Kent Gibson <warthog618@gmail.com>, 
	Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-wireless@vger.kernel.org, 
	Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sep 2026 11:09:54 +0200, Arnd Bergmann <arnd@kernel.org> said:
> From: Arnd Bergmann <arnd@arndb.de>
>
> These two patches are left from my cleanup series, finishing off the
> work to turn off CONFIG_GPIOLIB_LEGACY by default, and removing the
> include/linux/gpio.h header.
>
> I had originally planned to send these during the merge window after all
> the prerequisites made it in, but didn't finish that before my vacation,
> so I'm sending it now.  I suppose this makes them 7.4 material now,
> but at least the first one could stil be fast-tracked to 7.3 if there
> is a good reason.
>
> The second patch has to remove a few more leftover <linux/gpio.h>
> inclusions that made it into 7.3-rc1 either from new code or from
> conflicts with other changes.
>

With acks from SH and MIPS maintainers, I can take it for v7.4 through the
GPIO tree.

Bart
