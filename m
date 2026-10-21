Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571306;
	b=jqz4Byi7g3Srvs5b+zYsbDM/PZGjD26zXuxobLBfSPlRnIYNGPdZ4Q1JglGLH54Xtpsb
	 UsbO4lJlMr9iDCaBoslcCsgpiumqMYwZ8COjYFqpwSu/8kWIpZUo3HyCTWduTWZ7EvuVX
	 6YCX/s4xwlkYJXurfiSP0wp4JUEbjuBe8E4JCNzBseR2Lbd8Pkv1dc/F6PjXv+QDOQDZ7
	 l3rOf+i1IBWZ02V89nMvEqjBlKwWGYyiM42ZCoXNKhU0vlDRKvNWGnNX4VvDDb7BmKxvO
	 i/Lg7/c6QLtykckp3u7/Vs5KRRNyVlOPZI8MJdteqj1X9q+wYupw9C+frFCGBLtCluw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571306;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQwxJWuJwVDn4Eefp3xWv+hEEpnKtDrA92KX9RcEi7U=;
	b=heOBgy+dPHuqDqPPufw0iYOf5fuPr5o0+OypNsyAlupID0rfVrprNtFsI5YonzdOkE5g
	 zF3oowo7eKLFaTVQ6uQj3rXbBBCJ4D05gn6sIr92bs0OStI7axazAFPdiZ1EOQnwI66cI
	 SWKIU81VDl/Q3AcdM4Z1Jlnx8/DnemW0NhKaR92VvpKQp/dq7r4XLdp2vxDu+iTZvT47h
	 egy86sP+3R90R+9FGTH1g7xvyh16dtQcTE/FDOKwWHmf5G4/fJzfBxAu84lXcLT/eXm54
	 rcwuWa46oUy7V3kn0LtXhBM7kz+h1J6wVcjLtKPge949WNVVELhu6JgmRIhVSLoBhVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XOZmF+C+;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90A606A321
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 08:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A90A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XOZmF+C+
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e00eee27dso296618f8f.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 01:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571304; x=1793176104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KQwxJWuJwVDn4Eefp3xWv+hEEpnKtDrA92KX9RcEi7U=;
        b=XOZmF+C+Rl5Xdyv0wvtWpTCa37tU8hguSB9Yea1mYZ4ldD5XmLL2Bp7fmN4m3rJR62
         Y4ja9zDrxzlu42f40tHBb1Vv763zwGoQNYePK9BMJhJAhlUENbPyvLALU18jv9HZEIG6
         8Jk0uHb9xVqFEFDpZ09cCgFv/+Of9/f3DfjJ30OgyBPfFokWFLdBu45X98O9pmsA3e4a
         wPGd7B8Ydb9Eb2sYtbfPXuehBxY8v42IOSIJ6gXxGYJAVKCbjmd42A5jPLVnBxAJTOEl
         YQFDmgybdClCE8qJtxeQ71aPrOMoe3y5KsmoUDbbvstHg8pGuK0J3fNsiV/xWtieFB/n
         oM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571304; x=1793176104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KQwxJWuJwVDn4Eefp3xWv+hEEpnKtDrA92KX9RcEi7U=;
        b=OY1jOY+lfzdYjCbtZbsnoe6u/c6GlTuW40Dt6yj4BlHIj2uPqgtJ2rXrN1VF15pM8D
         EjLkrbDpO2biGd77YDUWlYawdGTN0bvMQi0C01AuHQ/tSJGVT8oOKPU9LEVhNhglWY7B
         OZ7dhz5NZqMUiaVpwqYgJ069v4u4j/ZNl17ey/IdRM5KLlmhRQ/KRupAebCZvSTJc4nt
         i9YfUBE56TEM9dkCHRp+/qesIdyFnuC1po2HXD6uKzFrYCAm4M+qV/HLoiakf5kMPGlI
         qM0FvmrMM0zxyPOR2MFwboKiH1gBCqUs/DIykakGTIYwZ+KrJCH7M83BwQgk/kVpPYQo
         98Kg==
X-Forwarded-Encrypted: i=1; AKwUvBzgRJPyE2h7ZHNEPX81y0WD/HcPYIKF+YW3anugSaXj4vtC9sncxZwtNvzQPorPShs+cXhdTVIbjNUh/ir3hQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJqVexZuHWH+/+HGATpDoepxaGliAI9OhjeE+LCKe5ivGkqd/oJ
	Z8uscJlqyngUlNe71dunC/SUJiEphcOUacdZZsuE3O7yECqlmygUsiBf
X-Gm-Gg: AYBFou20zyQRLyIWdlAlixeMw+c+0K37/Pa9YmrlqxwdohL7bNVFKFrqUk9gaUq0qMw
	uywMcsqhS8utfl7Wb6rSkG1NAKBZFwN2HMXk9CO8J1oLaK9Kl+Zk/AiMJdFePpqLuKJiTRf51Er
	aVMbuKAh7UNR09eDvyVylmSJX0f4BzbwOIiD9PdhZw86VAjw4LY9A5v/ypvhrQ97i8FZiVRwii7
	EN6sIeVbg2A0cB34XEcHMtdoCcYyDZXJVHYNGO/bo2jxd/H6bxOfu9o3aHahRReIgXwpP/fvCtv
	f45rSSktfdJFDDD0SZqZcgqYnYJ3q7PBsh95AG4GJSSR3Vazyus5WjKa2m/jd9yLqQ4acE7z0Ac
	aRXwleIJN1mV8tqiArh5FgjWP1jKru8oXXnxZwQFVFuXugnGGVCLSlGnyP216jOQrvdyHYfyOwU
	0qp4AfZZ8TjX0E1RDOBFJrz7DGTGKW2HMhVgyMIBV5oAnHfeu4X2AmKD5K0+C9tCXH22vY3Xore
	CUOxZ3R9s4dgPIK3upMo6/fk1aAX46aV1dwlafItXICTBI06nQN2b8CLDq8a5ucac8GdwF7yRKV
	q2DTZAyked53xw+SqwdwPtsIqFTjVaMl9/v7HZgFYRXPqbkkYLArOZYDo5ty4RtxIM+C355il6w
	Lc+OPJUfk3VnxcNASJDZIFtWycXB03KJLYnfUs77fPs0T8KyYdKLkrgZaIBIC4G7mkvWr3dO4Vk
	ggwa/taFCUNOmkZUupzSjdZUhbqA==
X-Received: by 2002:a05:6000:230b:b0:48d:ee59:3a30 with SMTP id ffacd0b85a97d-48e264b6937mr2199313f8f.22.1792571304121;
        Wed, 21 Oct 2026 01:28:24 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-cc3c-7cf0-3932-52d3.ipv6.o2.cz. [2a00:1028:8388:a84e:cc3c:7cf0:3932:52d3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581efd9sm3913928f8f.18.2026.10.21.01.28.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 01:28:23 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Sean Wang <sean.wang@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Allan Wang <allan.wang@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: mt7925: status LED of USB adapters and linux-firmware
Date: Wed, 21 Oct 2026 10:28:22 +0200
Message-ID: <20261021082822.65978-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261012125310.13917-1-pepe.schlehofer@gmail.com>
References: <20261012125310.13917-1-pepe.schlehofer@gmail.com>
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

Hi,

A short follow-up. The new MT7925 firmware in linux-firmware
(20261016233029, added on 2026-10-19) still accepts UNI command 0x2a
but does not change GPIO 8. With the same driver code, the firmware
from the Windows driver package switches the LED on and off.

JB Tsai, since you maintain the MT7925 firmware in linux-firmware,
could you check whether the LED GPIO control can be enabled in the
CE_2249_CCN16 build, or forward this to the right person?

If the firmware cannot be changed, is there a supported way to drive
this GPIO from the host, similar to the LED registers on mt7915?

Thanks,
Josef
