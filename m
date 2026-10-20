Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792491769;
	b=ntED+PVuZ66Th33yU1uLkSElMD0NSQlxjYoc5JxgGjAxqlXrGJ2w7V6F1eLkir0WAXfJ
	 GJSKNE96hfq4skwb2BnvbNHCE21bxTi9vGCKJEkNl+yVFfknlG7WV6sQR54ShkyrFIVm9
	 Conmr7i7DCCf2VVlko8eIdwmogwMTxA598bAdNw4sJFV8iSInO5fNi1LzZ8HQnVyLJqgL
	 hpjAgzOZs1ECaniCzo5+WskNNfg9f1jm9hbhigMJlGOWaUrmtNbNJJ9G5Z0I4R4fL90uC
	 y9fywzruQGsz6HeZmkWtUASeRAWZE7njnBBjqqOLfaghv75M+/k2nIOk17yzcbhWn6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491769;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=S9TtwUeUO8Ss4JzAEBBTdeSudHe8tk94C0JNHQu/04g=;
	b=oO6923ZyCSUh60FoUVl15wwSJeE1iUSBYhxbolZTKrTSbr8mWw5KMoQZHcjqfNbJqAT/
	 G5Oadp4iQdOzfp+fumfWtq8SAWnBmjTu2RiNCr1mtdXXOLQVlg6NvLOdDgywbcVv8Ijqq
	 UCdnXwlG3NrO7ZRr6soW45ZJK8VTiME3n9vdaDw+r7a1QlbPcEpfJfGPUJGacP3oV4FJd
	 qq+wQ1kvI6HyLKuChhD7yMKPydMIzQW65fIrb233fQZbD0AmOS+rXEGRCdsib+8rNBmV7
	 s7TW0AseDLZi1yH9KXL/puno5J/hH4yzSoE+6312G4H2Oqj5h6ze9PWde4Jzqojhihw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mAeXLhva;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56663606A329
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 10:22:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56663606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=mAeXLhva
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be4a2d94adso2473119e87.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 03:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792491767; cv=none;
        d=google.com; s=arc-20260327;
        b=INTatim4PiIrFLM1okLnbTdUHB/F49sCcr2Z98/XcLPDOYfSpKmAjNsEmvQwKe4CHy
         ieVeKSm8LpperS4o8j7ozHH/R/AsIkK0XmMfgiFRTexoq4Qx1n7091fVczZNBYjL/M/0
         X06AjQSlRxU2snaFyUH+P1T6fkV4q5mecjL5u5RZiRx475z6WWqIZ0ceGtPukGrmTalO
         kpBgWPPLYCkYpUDaAkUpa3aIkNE/jFqiVHoQdJ79RBcgJdapCzYrSkqSk4GfX/Cjxi0h
         KY82Ivu1jZ+jnVCG2v1nCqID4FGatJJ3e1bz1Ds7PO0flrjKO/jv5km6Zf8zUAbT7ezU
         6u8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S9TtwUeUO8Ss4JzAEBBTdeSudHe8tk94C0JNHQu/04g=;
        fh=OGCV/9n5inDaA6LFgalWhcsOCd0/rXYDKZFQC5eo5V4=;
        b=NPrIjyfg92dq59kyliAtXp6ZZcWAKRigqtsGak5p5/P73qmz8rYU+hCdxk4eKkkgJb
         g15SzBIzSpaV9FOT5ynexQNwxTb7g805Ar8joKTU0a7jeF5xzbPUB4TsCyz6O9b6NUz9
         SkoVjLx/J0akfcU464J0842rtHa7zheKKXPAmjTv6kmg9k9KfkWOBGVkTDEn+60XJ12d
         IgJyQmGjcihhF66DOI2yaa2XlXYEeQtX82s1lAD6eW9mbbtffUaFJXOBhyUvTi7Ua0EZ
         qMKA1Lkir4TOgrFeO+Uym2B5GGOiPxipumdyfVYiHgBIAGqSr+CGK79DBPOn9An2rCGl
         +zrA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792491767; x=1793096567; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S9TtwUeUO8Ss4JzAEBBTdeSudHe8tk94C0JNHQu/04g=;
        b=mAeXLhvanluEkjo1PmluJSdlXstt4qTX5kS5IyN69H8ESLCM0C7Pxty8hpRlpRnXnh
         zxeHwIv8Esb+BwfrRoTbcsWwm1Etpst+Ydbo8/xnUYBmplXhjqDcuALWUSAO7N51DJys
         AyzhaaO1KuNv3pjCLqNsGCU1jUY3U1ygEUEZ3bpIT2riyBOBtdi0QBkSZtm4x8vjxpgA
         dRxD5+Foy1UvYXzADUJkVEcbG3jKtRWlvN8Q4dEO7WaREbcuJssfS5MVYKXpnojR0ivg
         YCQxSQIcVHj4A38duEzGY55qQQvuZTDH11WNXolbWDWqrPtYQ/5Oglpu5UG3KINeNR9f
         nu3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792491767; x=1793096567;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S9TtwUeUO8Ss4JzAEBBTdeSudHe8tk94C0JNHQu/04g=;
        b=dXzlVZHPiZbdNxivJOCXdZfXUYG2JKuKRQT9CixV+Z6JVlU4KG5ZHUmcxsJadpr4zi
         e5zCh0gOr8a4GeryzQdfwUcuF3sn0xPoqizRnqCu+VcBK/K0LCJvWT+14aHC527GMnUm
         W9gyDEHxiEUnalvNUTaF3lnx9VnphgNdLI4y4GXlZFGz92W4+SpkVj2Z+HyCTfKIuAzc
         dUQOKifQUQ1p8t5Av/dkhsBnwvrmoi/jjW2caL4xQuk59M36UJcX3BBDqPVF+bo6z+hG
         87VY65yoYex9CnTrOadnQ2PHHZB7ULlCVI1M7QhlWf672jf74fbT1Dkog+0xUv0N88Zq
         DshQ==
X-Forwarded-Encrypted: i=1; AKwUvBycrW0sqoc92SmiJSH9w4vebm3+uioXQBSlA/OCuhVmfovkU+/WaATnWH2vpuZo7rrsAOI85mqH47nfD7qWgQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIba38IEMaCi0b08PKyqr2Rh2nnnkiVxO+H6Rgaq0oFu1AifqaC
	u6PGNQec0Hrshz9SN4MSbYcPWJ8FqzITY6YSs+SxDg6WzQrICmlC3lxSD6OF2t5Xub07qcYhQvV
	3/ZO0LgEKNDUN0zjIMzXKLFB9of78GiU=
X-Gm-Gg: AYBFou2nAJPsXbflOrJYW5s/1CdIssiV4Q85PMQHs8JUoTnepqe+WWNICk0qfN1DXqu
	t4NR5rijJJJFAhEWx67iy4kDW6osTPSlp2JrEZPIaWlc+5CdaqCd6+fMnNMIPLCemJu85XE83HC
	PJ4y4Cy0GKcbBA0id/VbJ12g+dWVxxXgWr42p7ODQ/2lmYBYO3vhnlsv7u6J8fOfPpoKYSiYjgz
	+lJpI4AjiJfnk/UxDPwmngqT6KkyjsPYFkSvsFXkkPMGsdgLepSXpZez4vRpLlbrnlYV2+ZCKx0
	Td11NrRX2p7LqbMMWaGCcx4bl9CSVu7BkP8kCfyGSXHAUcPTlKGMMad8eanFk1YB8vz1DG/7BdI
	gJg1788YJtONDb1lCnPaWCDj2FHU+JawFGGCx7Ifq5o25TKD48mGRWDo=
X-Received: by 2002:a05:6512:114a:b0:5bc:f280:e7ca with SMTP id
 2adb3069b0e04-5be509ef7d9mr3121213e87.7.1792491767173; Tue, 20 Oct 2026
 03:22:47 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012011707.3378-4-sigefriedhyy@gmail.com> <179185709988.434549.15422498299449004512@kernel.org>
 <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com>
 <8dcd9564-e9a3-4b00-93b8-3cb023d68047@redhat.com> <CA+7S2v+rWYvz9xKPEeM6=3HPz3o7TbX2uRfRKk95f9Y60HnEiA@mail.gmail.com>
 <976d815d-a9ec-4fa0-9b16-8e55695706c2@redhat.com>
In-Reply-To: <976d815d-a9ec-4fa0-9b16-8e55695706c2@redhat.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Tue, 20 Oct 2026 19:22:37 +0900
X-Gm-Features: AclHuK-kxJ7GesuN76pq16qYPFjVn7o8AWFRCTQQtoJTT6S63wPtOHkARgKHwik
Message-ID: <CA+7S2vLWvQd7GrnwB+B+DiqAgST8EjfWwBKzJXtjGRBPVgmOBg@mail.gmail.com>
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev-bot+sashiko@kernel.org, ajay.kathat@microchip.com, 
	aleksandr.loktionov@intel.com, andrew+netdev@lunn.ch, 
	claudiu.beznea@tuxon.dev, davem@davemloft.net, dsahern@kernel.org, 
	donald.hunter@gmail.com, edumazet@google.com, idosch@nvidia.com, 
	jacob.e.keller@intel.com, kuba@kernel.org, johannes@sipsolutions.net, 
	kees@kernel.org, kory.maincent@bootlin.com, kuniyu@google.com, 
	nicolas.dichtel@6wind.com, nickgarlis@gmail.com, sd@queasysnail.net, 
	shuah@kernel.org, horms@kernel.org, sdf.kernel@gmail.com, 
	vadim.fedorenko@linux.dev, willemb@google.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> To clarify: every I mentioned in my previous email was about possible
> follow-ups - not to be included here.

Understood, I will send them as separate patches.

> My understanding is that there is sort of a pending/implicit question
> from Jakub on v9: why are you doing this? is does it solve some
> specific scaling problem or is 'nl is nicer" thing?

I think the motivation question was on the v5 thread, and I replied
there as well.

My original motivation is to simplify some userspace hardware offload
code I am working on, and to finish moving "ip maddr" to netlink.

RTM_GETMULTICAST already reports IPv4 and IPv6 group memberships with
IFA_MC_USERS. dev->mc is the only part of the multicast state still
available only from /proc/net/dev_mcast, so every consumer that needs
the full picture keeps two paths: netlink for L3 and procfs text
parsing for L2. The offload code above is one such consumer. iproute2
is another: "ip maddr show" already gets IPv4/IPv6 over netlink but
still parses procfs for its link-layer entries. The iproute2 change to
drop that is ready to follow this series.

Also, compared to procfs, the dump provides a nicer API: it supports
per-device filtering, other netns through IFA_TARGET_NETNSID, and
reports concurrent changes with NLM_F_DUMP_INTR.

Thanks,

Yuyang
