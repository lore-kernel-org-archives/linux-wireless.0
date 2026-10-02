Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FE3429825
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936020; cv=pass; b=nNvQTC3UtnFKjovWv5LMulm/45e9LQOHbuRPWclOxBaRo1LBQHal/ZaIcbPFZ4q4uCtOqf7SezxFzkl9CWjVh3eJ/L0bzI2lURrsn9aXmyfrzttjA6zyNKOmjlpEU9GlzrYICJP5Y1GKGqF6vvvQqhLrOW8ceMVLYKSUvDVWxnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936020; c=relaxed/simple;
	bh=R31dQDnJ53ap5GeH4hbi3ZM97krFZBGuCEodpNOsenA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHkR01AGRcxHwXkrB4srdVIE83QjxL4ShfvchrQyYVvVEaL+9A1sX1Qqz1vmuTKuaa8Fue5abr1U+bOZRKItHrnly9/FgmP6x2qHSvipgpPrvZzSHH/QCLIbGGdoEYWiqgRZ1pX2WYo6lpFu61dbinLONyDSv4LepK5koc9Kgtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dzoImABX; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzoImABX"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba447469b1so1542633e87.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 03:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790936016; cv=none;
        d=google.com; s=arc-20260327;
        b=LRkhTy55HAz518b4MEWgicdEoq3+x/AAMmBJ8GQbUIIQ/VRk7xBGSKweiBMDjYVNjE
         3XCMf/kGLCzwTC5ugIh6h3h8pzFb3v1EsKKcBeIgBCKEeXNqMSPxzswTUBkegMqTu2mZ
         mqrZ8E3MwpRveCJaao9reFQgE6ExIcTyiehi1Luo2DCK41Bm7l8T48yh0VzMITO8Bp1L
         TGnWx1MG0Z3tyooct1YkZK/+PQABW7BOS2OoYAlVwBlyaWnmtU7QtIrEAwOentq6u+b1
         WEJN9opvq4vEgZwsDYN5rkhl0NUqy5g2dQ5x/f6Rt3zTOaEuD0tzzDAU0BVNpmA92PY7
         Fnjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YtQs44M5gzBLsCq+UUJQkpTtJc7hzbbbWNdnDCJs0yY=;
        fh=CdZmGP5xBBiQDJh3OFH9BWJop+qKSFIqdagy/W5hBiU=;
        b=cXMCDE5Ww+04TRBwChruAXTo71SlByKhocUvA2ck395jJtB743K5NvpO9mahxXJ7f0
         4OIYyp3NF/OVwK1oAATOO8XmmCwMeNUHdaB3mFsk5mTIeouu9IFyWRqmbh254YW0V0GY
         KBOkzMFNHWU6/YB/Qu4DMOZaG+3FweqWCej5yODseydWabjVWCyvl1+UmsSn6vxOcv/E
         UqCM1cuOx/bZooQYRwT9rnJfjvojiWaNzyIJUYl5EflUzrhDb0m1O7HYH+AafqqZmVZM
         HAGODZWs9AN2KhN9PO1GgH6LSJUQf8wGwPo/HvX2elmI8te9GhKcBMBx3jXxXqTAZFul
         bhWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790936016; x=1791540816; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YtQs44M5gzBLsCq+UUJQkpTtJc7hzbbbWNdnDCJs0yY=;
        b=dzoImABXSK2Gn5sUjxkaIb3Ut06JZ5GtduYxFB+DlVlZxUZXLMXBxKtl9w5wb8jKmN
         869QAukK38CFKwy5AW1Wl/eSoSBulkQ9FYMFHJPXX65uanH6t15vx8mYbkA2Rp2+ETQc
         91gou23YDlaZVvHG9ZnL2ad6tnx7JY29xRZ+wMVqo6syg6pc5xswPPskxc/p7WiI/HwM
         5oHGaMz9xGzb5IvxIpqM205iFpKjvQ2fPi1oYxKrsI6Q2IeerGYiXYF5Lm1fjAPsQHiW
         dVT/sBCTxzfQu4ULOo9wOWQgSUGEy+aaADXdcPdak0rAqz5Vu/qZkvHos4pdlou5Jj8l
         KxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790936016; x=1791540816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YtQs44M5gzBLsCq+UUJQkpTtJc7hzbbbWNdnDCJs0yY=;
        b=OcU7JAscpasZBduV+dsZcqhkj68qAT9Ua4pIPedkWDNNfNrGsNOrDODRh1rHHOLbTF
         whrW0BYvYrrU2hFD1D03LduziT6YydACXALAsMnPjkcG+titqVMe4QWnxRGxUmTVkNd0
         h5Ks1RwdMhrHfZuoBSPgMiewpk/ydO8jMR6W/o01c9+ZtgBW/2O68WNB1QoGue4rbJgh
         IRcjzWtMrkgY9NdZB6OcI+BEnSMWdhc7QQn1T7u6Fqzmp9VQGdZ95omXYM+zi2y3HYNN
         Z/lKvEFsZRUOiMm8geFmJF+AsEOO8eQuWBCnpab76rbsA1QU7YO88L5CN3TVqtEnL+aL
         zjMA==
X-Forwarded-Encrypted: i=1; AKwUvBwh4OBLwg+UPu4joNn65tLk6sEECTYGqgKcHyNKdh6YHpUfVNYu+k7qlevbvXvloLO+uaRIivmmg4DyjByzMw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIbw0r/TJwv75GFdF3/N1jfd/FZO13bayilitKnosc3OZFQCvnK
	hR9UGLTwiV+V+ECpuODRmroAPNISoUrYQo6a6FPiFv9Ti9/10pI8+U1CffPh0TFeQkl1xJXaTj+
	gQizecUsi8Uk41vCc+YvR6mrSF77HinY=
X-Gm-Gg: AYBFou3z6Of6o+m/uJhQheJRjcROS5hbOy2MR6NG3KUSsnhvWFEHTi1b7q3kb2+VLim
	Tn8vpOncYKNERZg7yiNa9BIw+Oyb+VZr9ZshChMSCsILMSFw+UrPb0shaDW15kuY0jt+gZFyCsT
	21SS8PDvpCkgaGijsGyZkKEywybsNwuxITbWnHx0SH/m0ldYretsSKdvMmjJO3nPksbnfY5WGzS
	w5CUgV5TmEN91bO/5NeddUrkmDhFfKbezwzRaVVfqzFIbDX0DZSWF6OjtGlNFc6Aafze+HWpUp+
	8A/S+C9juEiIuXXsIjnTpAiopweaxStSMF9Gj6Y4vm6nUTaZ8zy3300VSesRsvh9XZ3f1TrPjhv
	8sRGk3fVgUf8=
X-Received: by 2002:a05:6512:2346:b0:5ba:3888:705b with SMTP id
 2adb3069b0e04-5bb9bb22cb8mr661934e87.54.1790936016247; Fri, 02 Oct 2026
 03:13:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-6-sigefriedhyy@gmail.com> <179089748368.434549.14167408771777474746@kernel.org>
In-Reply-To: <179089748368.434549.14167408771777474746@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Fri, 2 Oct 2026 19:13:25 +0900
X-Gm-Features: AclHuK9nykm4Rn1HobyHFdYa8n2y3hHFC_CiwY1QwI6PRZQntiimuWrJxRLpDDc
Message-ID: <CA+7S2vJCT+PzSvFtmL9disx8t8nAMZvEMULcL=97v4p6MDyPcw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 5/6] netlink: specs: rt-addr: document
 AF_PACKET multicast dumps
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

> - [Low] The patch adds `target-netnsid` to the getmulticast dump request
>   with no condition, and writes doc text on which request semantics=E2=80=
=A6

Fair, will mention target-netnsid in that sentence if there is a v10.

> - [Low] In Documentation/netlink/specs/rt-addr.yaml, the getmulticast
>   operation still has a `do` section, and its doc still starts with "Get=
=E2=80=A6

Pre-existing issue.
