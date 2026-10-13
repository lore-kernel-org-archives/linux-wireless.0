Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49AF3CA483
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 10:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887235; cv=pass; b=aCyI+M1xGADC7f0M8E7CygG9WUrDQgcj6zQv/92XcOvFAZtc074voEcU4Z00v3pI4AIyo9wImFTig0rYEZAdcbwIcO7aS075RwCyu/O9PTUvXj15hf8v0F4EQEZ+eGcoz83fMDD08GZg+IjKMyD+uDZLMZMZpEp+T9+1/GjrTHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887235; c=relaxed/simple;
	bh=EvYg/nZFolqpHH6bGHm5NPD/0IrXIoVtlIW4jSDafKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DbzKj3qrPcq21+2Uszij3MXJVKjlXQ+qpj0Cyu8a83wT1L23baOMmusk1XtxUMU9LofWFOcuNMKQOYuwjwwD5KS6Zq1/WLCj6YX19xfSo6a3xFvmLpbSXkMyAd8MCQ9dgsszFTXe6CXXupH75lul7Sp1G/prP7lD3R40FIouaOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SfIxWMiJ; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SfIxWMiJ"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6cfed5dd083so1635127eaf.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 03:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791887233; cv=none;
        d=google.com; s=arc-20260327;
        b=OdcfWpOuQu8FYrQN4eM+lirRUkTN3sBfygLTyalPMz/QzHANlOCLHAXxLsEw4zgCAv
         4C3s2OwlZFwvQx8+hzWJFREUg/LIaCM6S8tTPaptEBxmsimUp7qK/cjb4CIS7aCVWzeq
         acch7AVracj5G2NW4egpRRlF3iONYZIIubpBIjBeu0rHypryh5HbnDIoip41T+45gSpV
         r7cAQMWzlHb0m/PY6H0DwaI6MuwHsezYd8w4OQ3gvGscaHi2u4tGHtAoqSkB1v4/eaXR
         nZpZX92ePhvA2OFx0ij7LFPMnMdVVSyM+kTLEH39LEX95WN4QbYM2yOk917WN6TJHbNN
         34bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EvYg/nZFolqpHH6bGHm5NPD/0IrXIoVtlIW4jSDafKQ=;
        fh=IJaBKF3sdbgyAt11f62GD5FGnsZHuSE53p6EuDJU8CY=;
        b=AzDFQiGm6tLuW2JfcK6HmP1zUy4IBlA46/l0dWfLLRMB4r4W2f4BgWXtMbV0P1KRjk
         UTdq2W27BsV9brLyU7785KybhNvRQ5JnlyCeo3MEafvU97A+7wdTQCinGEQOTA1uZcuF
         KTbYQ0NraAm+rXRli0MCv16eeUWxqeLhaFpx1CURZYI/JXF0qDAVz/zNO21LSu03n+25
         o06fdMI62YJEmMQuZFBqS/okZw6LGzhtrQPuyjhTGAChEf67L6XMDqqRB2aGuwJxKlaF
         wOij59drYy9wlyEBpmTkCPK7Z5iHHKc5Ac+/HJi8PX26mxSi3CYFr31UvcfpepyYpQv9
         VIXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791887233; x=1792492033; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EvYg/nZFolqpHH6bGHm5NPD/0IrXIoVtlIW4jSDafKQ=;
        b=SfIxWMiJkqp6kmt48++eyAfDJaR9KlsXFMETo/S8Bsf2Ds/L3W/HTgT/kiAy245Hrm
         Md/pEww+uTrpeCm1Bnm3b08NwMILnVUQr0WO6ZQSXv9b9BJsmL/V3+2iRnV/4Zd0s4gT
         0nSfvvqsoY3Nb2TYBJ0Y8hJfB1w9KfgDNYN+nKGokqVG7cFluCYDrtsliIB1sS6Eo+dg
         jfch+Rcgah4YwfQ1aufIrdBANrw5bQIaMJr4w2VKlOsviHtIsjicIpmdR2fLTTxF2Olc
         zCQiW7Mz0fDgcVqTD1ChhKgKwwQbfWO/bPHrK+4Gjh0TI2J4kVGY8rODwXbKJ37KcLoD
         scRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791887233; x=1792492033;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EvYg/nZFolqpHH6bGHm5NPD/0IrXIoVtlIW4jSDafKQ=;
        b=KFym2Y8nfsSJNPvGJUzG4OWrXVPwPvwUtQNCnX3Z6ptyalr7iU3D/79/OfVdhrpN6D
         89TLZKzCpgk66yASv7GFmSVavzyMqXqEFqDWv45dYJfiXiR4Ti6FNv3ycAdhs77/sNX+
         emH51lDxCA1om6HLJFWj/SPRWg3cfkQIMqXAD1gjm0PrUBa2p6zByP8KhqHD5UfEMAn/
         x5WPewi9mcLpuOUn1lNIfCww13/ntX80i6QwjEb7DY+bKCgNhGENMlBHbT2MTXoh2F0L
         I9oHrUEUskYobbC0LvGI2UL2KPSWuGpypX+EO6DBBiABYoWpLC5p3P8P4zOXJLngsRke
         Y3FA==
X-Forwarded-Encrypted: i=1; AKwUvBz9x45w2KxfAXS6cK5YcxJoNEhNblkr5LG7ALcXI4OaHIL9Ob3sx2OXMvdNmncQkpCYHvr1Z+Q9aEYFnBdmtw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKOoX0cg7JOwkJVgwLyD59EYGiQMgw71F9BqLXbEg8LeZ8IxDcj
	56iMbi7kkiZcqn29wFsGr+PLigrp5XxdrCdz0J1KMevbdffJ97Pxzmk6h0R7V18oEKKDrgLqxus
	3zAjtmAFKy4eYhxQ5EB95GFgPCNoJydk=
X-Gm-Gg: AYBFou2zuX+D2bWaNjN5mJybWxoL3hF3P2/571fvgBoaJG0TDUa2iqf2OyOBRy1XOzO
	A5u0gJDXhOvG8WGUtP8yllQ5aa92IiBRmJ84lKbSnD4/jJVcR3UPyX5WM1+q4Hey1rdT2BSI5TB
	Ee2YJdRvulDACDJMU3WDZM+S55CPhY/hnjst+0lq7KbDGRUzHf+89HNe7QKXgAH48l1Vn9ZESCv
	aImre8ArcRNBsgfD96Oq577X4HaDkyAOqN9I6KegmHG32OcaLlBSrQhIWWbce5+y3th+GM2Ri6T
	wCRlXdmxNX7E5GXgovSS4ZA0Gdm+qG8dclxPNJhLTV5HWdN2DqCr4tUwtHpIIjbt2U5uY/3DV0M
	t6Gc/OqaohWE=
X-Received: by 2002:a05:6820:4b0d:b0:6ba:3635:800f with SMTP id
 006d021491bc7-6ef12202b9emr8317434eaf.69.1791887232748; Tue, 13 Oct 2026
 03:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012011707.3378-5-sigefriedhyy@gmail.com> <179185710223.434549.6133926948819737320@kernel.org>
In-Reply-To: <179185710223.434549.6133926948819737320@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Tue, 13 Oct 2026 19:27:01 +0900
X-Gm-Features: AclHuK8JAnqsEY2qHAL_CL6PzjdPWfJwCgFSVzJgmZ53WVtZSl4NqYxxzMIIVrs
Message-ID: <CA+7S2vK5iSraGLz2BP_akbYMHAtjV1FKE6KNx46wZNmuy1TCew@mail.gmail.com>
Subject: Re: [PATCH net-next v11 4/6] net: add AF_PACKET multicast dumps
To: netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com, 
	andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net, 
	dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com, 
	idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org, 
	johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com, 
	kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com, 
	pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org, 
	sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> - [Medium] dev_mc_dump() is registered with RTNL_FLAG_DUMP_UNLOCKED.

This was raised on v9 too, already replied in a previous thread.
