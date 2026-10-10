Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D909349E13F
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791637688; cv=pass; b=JA2dGve+rPKyE0Hb+tDuuKQV0kQfYE0Yp5D7GJUz+mJaPBvjfZ+cPZYTHlX9kDI4LJ5hNMyosQB9t2Jj3ndITB5BmuReWvRrf2Z9eNW3+Wx4jV64z+xU7P9ox4+m5+At8Kc0YNmyMPzsSA1Tvg9r6053wrkNq0WrkfDaTke1v7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791637688; c=relaxed/simple;
	bh=Peoepvw/CV4v2nNzhaOWVLf6PtcCki7ZSzzGuOeWGYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iFucjT0YC1si/EFZ7bDhjG/Zhz3iti/vNZEBFE2NFkmgKR3sIy7zUqlv75wMPJYCN4qQwdKeoFtmLSdeJ/jNg/JNUitYOaLN6CcWQTko8b2vhAiRZUV8a7pJ7eWuAnYw8oS1/7nAmGgef/Es7EoYTg7fktU/6NQFqbOUOZAVldI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GFtnxtnM; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GFtnxtnM"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3a7754c2471so5522111fa.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 06:08:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791637685; cv=none;
        d=google.com; s=arc-20260327;
        b=ecWfzdjvVa98ARQSwxx6AyUI5orYbv73Td4Q9VPHIjUcYu1NygswDQvOkC7ybZaUEr
         OD1AJdQsbkcJWdu47tH8hW/tacQcacTxiBKQ2KusuFd5VBJheUXp4uB7Af8M+t/wssEA
         aAwtLlPEV41cX6G2UEzEDsRgDWN2+RhryIatwRpmDyF9Xj7mpn46ltlNDNtYT0HM8d01
         VYkr3QuHka7J9NlViQsLrwzpGf87Yb7zbYuTQ7JaVhH8y28yXqX97gYMSR9LPDNNIbrG
         sL2mPhjCKlgmbal1r/sTeqTtzdZc4NrfWtQ1vGPLhTMqTKkLicw+003eLk4j2o6QlfKY
         EeiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Peoepvw/CV4v2nNzhaOWVLf6PtcCki7ZSzzGuOeWGYs=;
        fh=twYKiOilCdxcXlhujQcwGA+13aXflgOoebNeY3HzR/U=;
        b=mNe/Zwpqtm1G+rit09SP7b+5/YZWz0RGoEeumt5ZILphKoTiXqOeSej5nyMxfCsYqx
         aALYHt1WhdwDdS/Docipx0Ckw0zAsg8Vsgwi5Dx0y2i5XkzbORiGD65y2vJFQjP/BN7l
         tRb5AJzmoGJ0uadkHN0RPAsClQpakzI618+ArYi+8epddDTXpMlKvldp1hoN4m8JgH/e
         bQn5YwA3+jaUROsD6JRUpT5Dm+SZELUmVdqJgKSWvVIBDNMYNX77V05lrjN6QZb/4CzU
         M4SH9TYrbOwh0v36hVM74nsjiW+4Yw4BgfpPh+SXPvz4fZwpBY4CHh8ZPJOH1mjvdFcV
         Hnpw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791637685; x=1792242485; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Peoepvw/CV4v2nNzhaOWVLf6PtcCki7ZSzzGuOeWGYs=;
        b=GFtnxtnMvNaq4SJ1WOB/2/nknKlK/HIOBMPtnwnullEMOFW50Ww9QBWYCmB7X+EGIm
         pSLQif0Qbv3ZdpFrntpTwOaGWMdG2C2o0JkHvV8sXZbSN4R8XnWffx3vOLx9Dwokeqbo
         RDvwQ5hWGi4WdxmfelLKMloPxsce1/vqYNjqYxy507UttrM7ivmtQ86x9kDDa1k/sZoz
         tAZO3IZWS6q7oTC041c3vaFT/UaYF0XMJmFX4Ni9CfgYrAWUdyoE+/YprAdKvfUG9Sy3
         t3Cu2WHAEEx/gI2LXBurteS1cJLERNUo02TzfcKj6ZsXzVAnsbbIT/u8w9dCMfKb64iT
         dd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791637685; x=1792242485;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Peoepvw/CV4v2nNzhaOWVLf6PtcCki7ZSzzGuOeWGYs=;
        b=v5Tf8jExmD4cRofmx+Nl5wv2DLMxiBHGgFYNoYRIaDgs1VNG8e1vTH6ypVX7I6RH+Z
         Rvz9enwETe+o49D7F9izF9rw+9qXbnlFdqQCvZy+NQwrBKOuM+zkVppwinL5pH5Otfqd
         trVxFwBfffwg43CNTs5p17uAjrvQw5t7F91TZMNAD4NFw8AmUSr46pBuUeIEWU8rMVYf
         GyB2+jgnHQZeaI+FUgmsx9avlPwYu0S8o/nbBIqqcXkl0uBb4tMjNzehTsNt+s7TlhNp
         0Tp9I3KM++eZCAfrgd73krA4QypOHCyVXJpO5fMRXjNyqzJOVj8ot7P0xJyOYsU9FT5c
         +LdQ==
X-Forwarded-Encrypted: i=1; AKwUvBwT8iskQatYASo2/Gsjq0782QIjcyq8jP6gJCkfiAsLfjnnnBbQ8MRjzCJcEkrldQ6zbhiNQy2cobXzqIcXsg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJHeXGXs9lp8z5bnwdGCSisTh+y0xuBGOks22KmNMPs50FzzI3e
	ZSkTUQiWJ2ryPIL/Nir+KbDSQi+rZRVz231mi9m+mc+JZHRUmkKxR9Zr29OHNc04cCI1p7ZbsUL
	vjeS+QI917rz4sBmzx3VVjwFikj4cUuQ=
X-Gm-Gg: AYBFou312WUf/zVGvwvTCsAcFIXW/TuYnZXcxib93lU6g98/NTLfnoxVqffL6MVObZa
	9EM33BTfIfpBwBFurWBkF5A8wFDQ3osi56MWlrrvabn37OBEbKmf/5kF/a/ApkFUSzWyGHzwfsy
	x/kZ/XZGyPLHBnQ2n4JHF6UnSFJ+6r0lbPY9WIQezBADrBogDC763lLvxvuFeOtCzn1Jqdgcqpi
	g+7aTAuhAjn8dpmbSScBqPtUw0zIbdIF4wRVtODdvVsO4HHXQQyc+ZZzWuQSonS5xfu6Kerk8YF
	9XcmYBNFSYwhVEFi55YOQYTsNBygt2rySSXJXaMNt4CjwfMZEXvEKyBd0GmwOND9uF3d8PiMXr2
	dpk30N4654HXPoR9HrO+7fupZK5fbrz/AuSv2woOfMiDd
X-Received: by 2002:a05:651c:54d:b0:3a4:8913:a259 with SMTP id
 38308e7fff4ca-3a9c56def06mr10678081fa.29.1791637684541; Sat, 10 Oct 2026
 06:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007115821.11332-2-sigefriedhyy@gmail.com> <179154712848.434549.1887332518398499959@kernel.org>
In-Reply-To: <179154712848.434549.1887332518398499959@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Sat, 10 Oct 2026 22:07:54 +0900
X-Gm-Features: AclHuK-XNxBmVqaX_AVuTKFXpvUqvVpdQ0iJJw8t3L0zVc4v9El00m3OF_1B3Gs
Message-ID: <CA+7S2v+hTzSacfnSJi4V2A-oj5woKA+0ffOA2cY1-7iC_LDX8w@mail.gmail.com>
Subject: Re: [PATCH net-next v10 1/6] netlink: specs: rt-addr: fix the type of target-netnsid
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

> Should this have a Fixes: tag?

It is working as intended, already discussed in the previous patch review.
