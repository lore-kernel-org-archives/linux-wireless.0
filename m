Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A3F3E5598
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887170; cv=pass; b=JPtiRaI/FJhj7LJhaKsq24cW21mHhNo+535JyAQEZMOghktVHjLBzOvGznBvVeU/VF09avlsRSOBW34P895AO+Fj7YFCzhfjKYoBnmv80SiAZJJjrSO2xEoN0dQO2a44EuM5U3IWiFJnpYYPAFHb7sCb0faFsGnbuZC3wOj3mnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887170; c=relaxed/simple;
	bh=30/nByOcJLdjUUYb6QfrK3u4hDpBRdXaw3vsv0P1mN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eqn8wWcH+j9uIbFeTxHiS/WdZCFHw9oJYdrOIz5COrhb+7vL2d2jw2n2n2U9pfebh4qN3pM2zfCZO7i+wf8kTq3k/wU5Hn5kLa2Ki+qqygZJqDpDHwFNcxsVTrg62ZzqvGAKutZTdtkb2dnNISYfOfCyIFudbkc4o/d9ulKRGxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlvUzVj3; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlvUzVj3"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3a7858d3a20so21030671fa.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 03:26:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791887167; cv=none;
        d=google.com; s=arc-20260327;
        b=DSulQr2/A5HflLGadDzW/JUgxuPTCzImQrT7+/MQ+6ws14id/EjoeZ43BVRYhXCLHb
         JyZp7J6b+uSly75OSGrtLZ6sz9yfCU+r+tqFIrraUMfEFzvWp6N+23Cc6BIGDBKfTzGp
         8ep9H9tswuiddYRDqnPENc/tOgznnaliFSqubttfAKj4K2SIJET0ih1vQ4tsU2dpdJSw
         0QlRv4hQYx98KJxrW+V2BEi8nw3ZuX1Ydjs26OTjNDIsk5HHPr0QYNpXjeoSaQInq8ku
         +OvUm6ZLQvRYEICzv7Ie7zGwEBr6zwpE4hS3IFubTMI1smriEw7+LouDCYPpc8sJ2u4c
         ipfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X2iGlLnN9AnwU82QnbvfehXlTLjFdwbOP6w5F5kIy7w=;
        fh=iTOFqMkfd3sSpn2ygkrKCZxV7LaN8LTBA6VCsSMqsHU=;
        b=m3clmTO5i99zjloawkY0hN+gn35QSMyiiqH2aGelLJ0W/MiN6Zhki+t2Q79rVi8PNr
         +RAfiT3nV4pWoSfI5g/8uUz+U48Q9d9MR9YLMAjDEGb+ChLHGDmBMmPytBT3/lclRw6M
         pHZKg4qMDoStSN0WrX99G8+/wPIzWghg0JHsdW+JeoR+azn3L1pEZQopX5lVJH2ELmXY
         2AZaBrOS2mKtdcIShxCa4JIdJpHImz1V877cuO/k/GnRjBW+FKrVI+lfNhJJhQ009hKU
         rynpQM5+o/04vbbG2adl93XXMIRX1lwCEtql25Ian3leOghtaxX7+JX9mNkSE1DJJosh
         wZwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791887167; x=1792491967; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X2iGlLnN9AnwU82QnbvfehXlTLjFdwbOP6w5F5kIy7w=;
        b=FlvUzVj3Hmts5PuHrpcKAJF9XR5pb0xq02Y804/4zuNTa65wn9HSIbWFmeVewetFdx
         JTqgqgiWGCweUr/fZCAinXjH4ZB/I9mtVem5TjUg2ihxvLDxAjZStYu7v6rQdsd0rJT0
         nYfrQRQne8y/u+OzJjLRTHAyfsfb2WQxuKoDOKQD6oklP23jsEz4jHzS5ood7tUlmviB
         nkgCEWtvpTMcE3Nqxlh6nz3no3u+tungwiX2xfP4uUUzi8vGbnNmoMVoBMDuHanIXFYb
         fAM5i9azUb1PVo1DNwih2DjHNYdwwL34LhjDOyJmedlg3U1DyWll6zw7FupdCChojSe1
         M0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791887167; x=1792491967;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X2iGlLnN9AnwU82QnbvfehXlTLjFdwbOP6w5F5kIy7w=;
        b=0muQDraI28ZIRKSkZcjNN3g5qgpOjtDJw/1mP6wMCAV+dSyKPgcUrStMM96DZ2mF9k
         Mvsdgxzkarl+1iSo8VoU2v4jKlXdca3q5sbkeboznBUT0G/0NzGr+3rUdDdM7nZBPDJf
         vWNoi5eGnFqvReqDnH82G/HdTzUBYi5rfV8ILHMcwqzGF9SGyk6VcomEPNsf/a43lGKx
         i7oqHa4rwnfe4yLsJvOVYcqDvmT1etcMctsIOWIvsuiGDQew6Ex0HRZGVmqkB+TfHRGg
         irRXmKANKa2YikBxuxrUXevrtem6uusyxy8MeS4lHPPwLd6AKYgAA0DqoTL1+MX6ld0X
         eNAQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXlCj66cwvTJTcMarjpSONl3XIjevESlxbsvJnMLCQcq9sNyPnabjBB6Ex5B5rBifmm/368xwfnm49HKO+Qw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7fAsEDpl5yz6MnZiNOjE21pwaiVqOlDHuMNwIl9KBWmohMH+L
	NCjeA19rJ55xv5UAtePJ6bRMxZftNfYzC1LamCEJhDTnHHKCfSaHypFgXLHuc+Gf+6Fa+BDTgIH
	1SM5PbvWZyMHUz79LqdBPHTV5XiLcwoQ=
X-Gm-Gg: AYBFou2ECDWRLmUL9pFG6zfcwJLi4Ug3T8M1SoOX/EMJ0qzzdNgKUtUvmxUaTtBGk0p
	jc6J7KOTw46xetgfsnB3ivNTbess1eKGasRLpiD7yKBoTrr6g4OrkytxDNQ9RrH8rMtAXGfhD3e
	5bOeOsNhz0hFXBajkE/hFcK9C6bHKRhmOpofYpVMkmJcau/+wDKFEU1N4z+jVoMKb5lWhqqdk1h
	L7pEvQnj3Fph1ekyph/YXtylQ9KT7jbTq3GT7z2aKNpbp7F4DIjLuGnZOLrhR6U4Aumw1Nyhzms
	XLwmwlnHuo6T2AlHOe+A/Fr5EDOp/6+N4nL3GdRzxw4GB2knvVns+ubMLUG/VrbNaEKZVdixBWM
	CY0g9+8A/mo3u/KMNvJYDTw==
X-Received: by 2002:a2e:bc23:0:b0:3a6:636b:63c5 with SMTP id
 38308e7fff4ca-3a9c5384f54mr25409041fa.16.1791887167208; Tue, 13 Oct 2026
 03:26:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012011707.3378-4-sigefriedhyy@gmail.com> <179185709988.434549.15422498299449004512@kernel.org>
In-Reply-To: <179185709988.434549.15422498299449004512@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Tue, 13 Oct 2026 19:25:56 +0900
X-Gm-Features: AclHuK9xbgdrkpalW9mtMclsWr4HeA1zLw1yC-dAP0vRwaQkMlm23OayOZqQ2Hw
Message-ID: <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com>
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
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
Content-Transfer-Encoding: quoted-printable

> - [Low] The commit message misdescribes the precedent it copies.

Looks like a nit, will adjust it if need new revision.

> - [Low] The patch adds an 8-byte 'struct net_device *mc_dev' to every
>   struct netdev_hw_addr_list (include/linux/netdevice.h:253), but only=E2=
=80=A6

It seems to me this issue by itself doesn't deserve a revision. Will
fix it if new revision is required.

> - [Low] __hw_addr_changed() (net/core/dev_addr_lists.c:22-26) reads the
>   device netns with plain dev_net(list->mc_dev).

This was raised on earlier versions. Every dev->mc writer already
reads dev_net() under only the address lock, so this adds no new race.
