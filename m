Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9657E2D837C
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 00:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791248106; cv=pass; b=e8FmC68N93wEt71tzJzXBNFp04yyK3MP1tEh5q6ZdQUYzIlMr36fK950ejb+dXrvh8J1VNbFEw5IbuHqGmSjprB0t7PxlCKXHIMyFqN6f6Xyx8HNcYqb7YFnz9JBkjbU8bYaZTH18AdifaOgrilrre9vDfFd9P32d6cDm/4wyBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791248106; c=relaxed/simple;
	bh=WlUUULkXecDA3FrqNMgGGTCq58pBRHG2vpFkFbVh+ZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KtN7HQ/4SPM00YDvwEpWq58gJaQxnKg0VdoeuUiHOxjzgoHmPzD2zGlExLkfPvnCvOlUevPgkRfPk1zV6M+7SWmef/QHtSjZMnlde+mVxJZOU7la9JgCw/eBE6nQnjTfGDFIcD4s/N0B1r8YfGqIQBkaG6HRjbmSQHNnes1HqHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bW/qOGkn; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bW/qOGkn"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3a595487d43so19612651fa.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 17:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791248103; cv=none;
        d=google.com; s=arc-20260327;
        b=qhOLZLWbuo0dYciHUOFWqqnFjAQo8DuA814lAdUcsFtQpxwwQUUYFvX04feAXC1qYE
         5QAbXC+Ylqjo/OmxZfM0Rb0ysrzIf8RC8NDTlY5IK0F5fcit0I/RLIocYdv5SqyqTSqc
         Slex+JDZ3hWH6LK5zCn0M0XNg8qeVlRNECxJjAR4UoF4DWlW5ZNBUnH+H0nFifw6wD9v
         KbkQknr8vKwd+rW6qTp6UfZH56rXxeLh6tP83ijOfRdRUbuTaXDNN1SfE35xQ4nXK3CR
         f5BsT9ef2MChM+7i2QcHCjfBIOZyDKPUXn/nWgzlX69Rc3QGB2fhKQEB9l7Lyzf36v1M
         OTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pcCvTZJFLUHdSKFVu50rhTAVsHuaYlG7ZNshew9spyg=;
        fh=ibxPtsKhLvcn5h03QB+VFbAGiX7BrfFW9VIrfk5WBZg=;
        b=dCzXX1J2OLAvbzHFVqkOr6W10wIQ7YIt5jfSz87HlB1b5yFE2ecvjohqkFDvg1vHYC
         iwH949Oa2e3eSqCgNtGmDvWbPpDHeb+Jh7JErmzNHY+jS9yFRqdlJsni6dTkbBxleUM8
         37k7DzjwjW/gZbeLPD5pXBcGzxq8T6A7TOuGFvDam32Uoa/YwEJ3wBhhXtmKBHG5Ohrr
         WGmp2CD8JaJ4uznamb1FmiSBQoLZ/Xe8LBptaLog7K/veueTJp01ra5vffD6tHIt9Sbi
         W9SFG2VnCVF63oO1JpyWNkplk0WZPeUlihhb/kdOmIAMsoTla3rTA45F9bO9yIoIz32b
         uvXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791248103; x=1791852903; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pcCvTZJFLUHdSKFVu50rhTAVsHuaYlG7ZNshew9spyg=;
        b=bW/qOGkn8Oq3ecnO3iORBbazJd2D788Dq6dJ3XWYfSdzJ6LwitRqTlwk46xelWflAV
         gbFGss68KaNVq7/giUy8G1imnN6qjgFYeGlGP4GkDjeI8mHeQmcGyZgO4DR8xgQBojFd
         BKAducA6nlvACC39vidsPLdmEkBBidl4l2tNV/l5BL7wKH5f6DmhVfHjAJLGGC/tuXxf
         XPSg+NTKeoCQzyOfEj2Mr8SDCLinsVL+iKUdl+/XWcioaKkJhM5Lz5jlM0d6+rFN5Eup
         dsFU9EjsHCawKIEUoxk67BFgonn5q5/8iVgi+JTenRCQhQu2rV7HNn+TLaxFHZFC3alU
         N2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791248103; x=1791852903;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pcCvTZJFLUHdSKFVu50rhTAVsHuaYlG7ZNshew9spyg=;
        b=aVjK7W7Yj/h3brm1GOhDdCeUuLoOxk25WnqSeMO1rHWzoMBcMzg2YfqPsKGRiqVYUc
         tzjCxwCPkFwwhCkz43d5nDH2eYcHicSeuP/7n1n6ea3twpzg53KQcP73gzaw3uJQvMt7
         Ffz5/4VQNifzXM6dYKfj9ypFoeymt0KGPb/qna+QAZbRxcESQZpcpvk0E7os+4JhtLqJ
         A9i1feKwrALht79kVC+0IQOFgVthwvkUWXwaU9op1OclgIYhL0ILol6hhjtnJL1TX9XS
         6aKQEL4OBAPFUQiD4k6Rko8Ot/6F4XjGhN0UirGMJnyU4zsskVAVnsPEL94upS0535WN
         iiyA==
X-Forwarded-Encrypted: i=1; AKwUvBz+Be7lqN7sxAvDgphmDAslU1ubvdPIPuZMRBd1bfvptBmwkvpPqDu60zK8oGYZR5KU5WoL9jokV3INR9WFlQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ9hf1DUvA3xz4hvU9U0k0qGJKzgL1fKKhs+qq3hCBc63cXjH4l
	mbiglzm0hheMwQDQvVuPuaFD+pKG3QnyKGFpld+Eg8/INc6JfMtjscMm8R2+C1cI7GXOI5CnWkr
	uvlWuS7hpoZAb4uvk2ayP55WxkjeNdtY=
X-Gm-Gg: AYBFou2r4gGa1nV2Z/+Z8RSgv+K2+ouMl09PMTf126BZR9TdiurlYCugw1YsGEZ6dA6
	vEYj2QVnKJx8dZSwv8qLoHyJ5qPCCxDHh1dnt58no+cojJ1GipktxdHT/hb0vva26LffHyNMNsg
	QYD2S/KquzA0giGsmIbC26Z1nLsnT4FDXr6Dd4z3ItTiFiNyKWd/GHhz3na06vC+wadPPD/FHfA
	kzoRUsISR2pf2/GTLdAat05N9RiyCkyI41YN7lzTjoIG3jk+iM7zaSROjqjzeelrkxCVG8QTzWv
	8pzAmMfVpcT9wunBFSSciMk9A10yF6srNkmCsYsoH0AfcR/MF5DI2gPerJC9/kQ//+rHh22rinN
	JfPqBiGP1Dg6bSRK0FALrB2w=
X-Received: by 2002:a05:651c:a10e:10b0:3a6:48ab:7973 with SMTP id
 38308e7fff4ca-3a974f7c448mr16424921fa.26.1791248102355; Mon, 05 Oct 2026
 17:55:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
 <20260930112842.21323-4-sigefriedhyy@gmail.com> <20261005164905.3d5b6749@kernel.org>
In-Reply-To: <20261005164905.3d5b6749@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Tue, 6 Oct 2026 09:54:52 +0900
X-Gm-Features: AclHuK_fRzWbaSoo1jAzXFCqAnGNXFcKoa-i0NxMDceG-eS6OpMe7FREJUP2sdo
Message-ID: <CA+7S2vL2n+XTZHoSyitmQy59tAnKjJvErvZw-PdKaMx4-Deq6w@mail.gmail.com>
Subject: Re: [PATCH net-next v9 3/6] net: add a generation counter for dev->mc changes
To: Jakub Kicinski <kuba@kernel.org>
Cc: Ajay Singh <ajay.kathat@microchip.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Ido Schimmel <idosch@nvidia.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Kees Cook <kees@kernel.org>, Kory Maincent <kory.maincent@bootlin.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, 
	Nikolaos Gkarlis <nickgarlis@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > + dev->rx_mode_addr_cache.owner = dev;
>
> There's no need to set this?

No, only dev->mc is looked at. It was set for all the lists of a device
after Nicolas's comment on v7:

```
  There are several lists owned by a device (dev->dev_addrs, dev->uc,
  dev->mc, dev->rx_mode_addr_cache), the name 'owner' does not reflect
  that it is set only when the list is dev->mc.
  I wonder if the name should be changed or if __hw_addr_init() should
  be updated to always set owner when the list is owned by a device.
```

v10 takes the other option: the field becomes mc_dev, set for dev->mc
only.
