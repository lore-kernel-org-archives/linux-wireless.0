Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD013B2FF7
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132886; cv=none; b=gxCVUrerA58YBEUzM0DcP5HUlZPLYyCkTVIbGsW7sr2SJX/wHI2qwkD451AnLTUOldef+8xQ5RztZ0efgNnWELS2oKTDaSqJ+CTpmY6FFttDrDqebv+aSrUV3Tu7Ce9mx8i6VwhgR4Zrxt16O5UBG0USZX1Mf7B1IznQXCnNS1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132886; c=relaxed/simple;
	bh=vlc6n0wucwwzcyFpYrDIRDUbt+XJH5Ilzdk8lMP19vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRlJ2mH3v1hm4dI6xEL5Eow+Cnz2+PfluPoBMBbTWUhubXdsYEBE6/dERm1DrXjeL73YQGFKwcfwSBhsleYaA9i4e8bDbJZ3U1AK+mTEPoaftNTHq4TrVu9P4PihDjJ6vpZfDIx9raMAPUJAb0vIux7wAiDy84C4EeZnZHboBGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=lTjQ+76d; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="lTjQ+76d"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493e4ccccc2so35841555e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 09:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1784132883; x=1784737683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vlc6n0wucwwzcyFpYrDIRDUbt+XJH5Ilzdk8lMP19vE=;
        b=lTjQ+76dDNnxMKnz3PquFQnbQNK9JgbYf/axe60O2u8ydZuUKN4pSytt+EDnGsZHuA
         OzKfU0UemRvB63LTTT+7stZEBYp2NMkGTNwm2bXm8VA0C6+8kbypAFRyDx52FbSypddJ
         g2GGA4yqno9RQ1gYW+M5nMv9vr2Go1rDDau5qhdlcsT15dsbKiiG1Fs69dUSQ9xhR5cq
         7O70yglDObYvz5106xA87W7i6+Dm6DWiAhV2zSNzlzK7gngu8r7YeHVDqqR6SI2xNTxu
         EZ/f4JBKStXGqh8y9San8O5ZNZL+q0LKAgSrjz3riOoRRptqqYjZetIjnMKZUQGwlwkx
         9xMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784132883; x=1784737683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vlc6n0wucwwzcyFpYrDIRDUbt+XJH5Ilzdk8lMP19vE=;
        b=Em/6VrBPATP7BTBS34kWKaQUtb8ch0AaAqj3pw24OGjIIpnNdCF8WEmZOEveHKiR/e
         H/fswfvLmFBmI7+UUC2yBoEeYtM24aVq24YM9mMc2vcR8BgLSezigV1U1Hhgoaiz2IJM
         VACobVMiM/K6IG09HXQhDPomHtwam5/dhMZbOmrbAsqgj6OLz8QF1A7XBSRHzHW35mKY
         SUJmdPoD/MCOWmDCdlWR6wUEUZlh6Va6WhVjyXJWIw0XgL2VOSz3taCnEb9flZ1+s1Iu
         SLyQg33XwSnYTthgpV/Wtt8He1P2iM1DuJ0daZw5xZHhxPKLwMor32Tm+Mnv0aJc/rZD
         mM9Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq2EEt4co1T6LF9x+0iq/yJTbBVvvC9RED8g667cyVQNQrteMZaD9liU9FCqAJ3bxIEXiZVk51/GA6NDwfz/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoIod9a3QVcQ5ySnn7WOSjP34zF/3RTkaquxt1kbOSF+VraYd9
	XGiFZL+TfEIkg/eYPkGAVCqOVP2bbZhGIGuvLCPdPqIiMKO5pIlJ8ydY1jIu4fK5PVha
X-Gm-Gg: AfdE7cnPlHxvQhPmmwCi9kfePLoP5RsuzGxQ2/f3V3taOvcyev/W6LazuAhJLqM3edI
	U9soos1F2/3zbTFhTTUym0EEair5dsNpzbQqYl3wwuOYen8QVZF4mn9xB+p+O+1/ofkUBmm4UXz
	Em28dXkx0/ylOE6tRPpunhkLAGfyieQCdnHLqOMDdjRJIKbw8xEA1QKfrVd2IvD24O9vxiGaZtl
	eaOyCfHMX3delHZbuatsdawss5tpDqRwdOqUBltZs9eyeSBFNUwhORQAjNqtUx4bQ4nLaoe1I1y
	7dFohOARwePvM3ZEY1w0H7vGPOwuy0RPA6qm4xWd99MKbYdnEqr9qvCCX4EIvzYsZSlViUtqd+J
	1uH4Lq315ezGPO7EDFUwVyLT+d2cGImru72tgTjmws51+ZQ0FV19IAmkHnIlP3UUl2aB2LcDtu/
	mXIav71Y4eFJxK6SCzqH9U5UPnMnUtxfSiY9skNmgZBjvsU7ZT5FdihADTtChFrQLdkwIiFwjgb
	94BhLfckSOvThi4UanjCuz92v+dJw==
X-Received: by 2002:a05:600c:3218:b0:493:e81c:fc9 with SMTP id 5b1f17b1804b1-495389a2301mr50045645e9.15.1784132882816;
        Wed, 15 Jul 2026 09:28:02 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49508731fcdsm142523185e9.4.2026.07.15.09.28.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Jul 2026 09:28:02 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Brian Norris <briannorris@chromium.org>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: mwifiex: validate HT/VHT capability and operation IE lengths
Date: Wed, 15 Jul 2026 18:28:00 +0200
Message-ID: <20260715162800.1922-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715144021.GE56330@francesco-nb>
References: <20260715144021.GE56330@francesco-nb>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Were you able to test that this is not breaking the driver functionality?

Unfortunately I don't own one of these cards, and mwifiex is fullmac so
there's no hwsim either, so it was source and compile only. The added checks
only skip elements too short for what the driver later reads, so they
shouldn't affect a well-formed beacon.

> why break and not return -EINVAL? (this in general, not only on this
> specific one).

To skip the one malformed optional element and keep parsing the rest of the
beacon, like the FH/DS/CF/IBSS cases just above in the same loop. Happy to
switch to -EINVAL if you'd rather reject the whole BSS.

-Doruk
