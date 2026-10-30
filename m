Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333972;
	b=vQMT+NkPeTaFS6otSdVGZje0HhVVzGlgbMTNPuv0+XroizUgVYzXMO/H1e5IccMMen5I
	 HaiAnXANIndMv2Pl5biQ5TgXR30oJIMdxZ14zs/VeYYrIVgYC6LAAuTfy5dEBhukZWYZa
	 waTVZ+s7FNabErRfj/kUjM9Yc+qaW5PQa142/qi0qXVHjEwmgcRaiwmKLTfZpJoAM6iQt
	 J1wNW72CIYOevCBhhR0z7+MNhHR+WZr32bAzeee92sNyy4uWoeayZTvi9UEIwZRln3YOC
	 w7FrmG3SfBYLOOUAObWCi5tCiM3rn0G6ncz6KjJnqz/uXydLrcax5csWPKjIn38D49w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ixvNCvc3ElMgxUSC7xZq0g0AIW9Y+WnUXNOWMqR4I1Q=;
	b=GIa9OHRvYEG5CiFeA3DzfPyRh/o9Zrf989vwnnGShHPK2wtXSyT1291FDStbVga/qxJh
	 i4Ib1q8C54Y9PCm8lorHRLMImBVFk882VD1PV4GSfApsXOt4DuJ1bm6iXA2q6oJ1kOpCH
	 VKaTmlG5r1hSKsRIfCTIWCRWfia4iHmNb0lirMVdMoS1iSXzaAmKIwAE/ZJOANpKm3miD
	 DXh60lcLpeO98vHctSMaKBGOiXhntpqDmJg5ebcezlh1aV6C6woCZnaEVh4GZAqugoPd7
	 9wZNAQo/C5RlqkOf0AYHoBh22PstD3JXa5AiHq1NqyxZtyecu598GykBcoOjdI+uYlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IsgslOaG;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897C1606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 04:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 897C1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IsgslOaG
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso125808a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 21:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793333971; x=1793938771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ixvNCvc3ElMgxUSC7xZq0g0AIW9Y+WnUXNOWMqR4I1Q=;
        b=IsgslOaGls1pJvu5hBLCIrJnozn/KIWrwwwzBoV/v30/KrDa5ZNG2cwOkjyDunXVGz
         /Puay8lmldHZyh8Ch+VmCqCZF37So1H/4U5sOFLaYS6GwtcgfSo86vEvmX3ptD1Azxql
         NUXM9CHKeckLBjUi61W9V8wFevGFMAkUUQgEfH7+P03Azh/g1D2I5hXukEQbUK3mAy/4
         gPAJ+KmHE4sbWH1bVeWANThWAkJduAHrie2x1PTriLftmJhq9aGunQM44TvLtNcNE1Jt
         6P/gqLvRDs0oVAR0v9Du9fA9DV9wwfC95ZD5NKee2NZBLBGJ3Yx/3SIVe13kbDa2s7Vm
         icCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793333971; x=1793938771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ixvNCvc3ElMgxUSC7xZq0g0AIW9Y+WnUXNOWMqR4I1Q=;
        b=rSzI4o/9+YOei/6Z4jas67moG6Jhr22CLRMVcLSGsepPQuLPGkArljNrYkj7KpdilW
         eQhpmGjD88Zd+EQ+yxu6ZAFFidmKiBrE6Lb7eTwt9krnuXfzUn+Bj+rAuGn//0A4+xZu
         qABai826xXpvEm/7Qm2PlMCZM/pQlfiCseEM3fKtHixQf8A0ta5D+dmwz2LbxrZFDSTO
         /JW6oLVhQFXpCH1eiEhn9vqW6tygC/OeyRPd6vzHJzActnptP0N9F/QyweQfsdWuyyGB
         HHH54D8t5r8LB8TslVgEvgG4rXhmgOrK7RQw2pO+nTDtfscpyHDC65We+KtoAC6h2Te6
         Uunw==
X-Forwarded-Encrypted: i=1; AKwUvBxW+Uq3qQIEFgGWNf2nelrZkc2x8eygnC6Xm1Mp17pKESCoQ1+XUX45z+ZD4I/g15iSQ+C+uhcbLeTkavyrqw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLxx3oVjEhApDtGVm9HgTwycXVkNVFwn15EuLGtAdiYioHiNP7O
	KI3M5bmwX9PjqQTOjxN93hXWKiYjzei3j8T/FJl4zSn4tH58RbLUW6A=
X-Gm-Gg: AYBFou0xDKddxRX7V3tcnaK2d43hfRJd8W7YSXjnO+jWaIlA+OVbZ6pg8A+2oRfzqtE
	XMkn4LZPv+f6HcnJImUXwSLs95M6ZnCO+0hk72WFlKfksm9TiFr4okThEVWxfE3J++ySKcc4hTd
	FIGC7kqFGwniKp6CaSOSVAqHsTtodtNSKsrGwM3LF4/IZSQst/UZsk6JELHR6YJi3lLVG8/+rlG
	7MYQJ6acBD10IvmMU9oyxbUySNDJZSw4pvN2fo1X/Pru3KamsZ4eqiwEZhc8qlXXejKJFW+t0Xt
	OLBL4fkI8Rh36We3IgKnbHUfWVcIjmi/9Lt1B5p2jX6yQqDJDUICTrH6zWoNbChWctD1D7Hf3om
	D/14gexnF+PxnJbeFpsIT2IvKEbzVmu1SnpKZB2n4/cBBTGQEEdbSJRWPvWhFY1k/5XUGI+1+DC
	DKdVjYQ7OFRFcfdqCyaE2zHQ7EkD7m7VrrXWqe+ioUUkpuOdlFC5ayIvp7Pi57/fCP/oOLFqLir
	B+d/IYLNP1DB8Gp/zheA3vNQEEFKv/rS3oMRlwrSpr2c2ciD7KmRAG+nWvoa/pM2/EFP9v3IiXg
	zu2MB2iRHBoKSyeLrO874K9CzZ5/wxkYgkQUGeR5OwjSAey85rwoLXCPxEJfMLC7jwBu
X-Received: by 2002:a17:90b:4406:b0:3ac:b6eb:e0dd with SMTP id 98e67ed59e1d1-3ae8984de49mr744782a91.50.1793333970822;
        Thu, 29 Oct 2026 21:19:30 -0700 (PDT)
Received: from freddie-kane.lan ([71.212.222.246])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae85cb1bfdsm1030302a91.0.2026.10.29.21.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:19:30 -0700 (PDT)
From: Burke Cates <burke.cates@gmail.com>
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Cc: jjohnson@kernel.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH ath-next] wifi: ath12k: fix MLO 4-way handshake timeout on QCC2072
Date: Thu, 29 Oct 2026 21:19:01 -0700
Message-ID: <20261030041902.2740757-1-burke.cates@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260815014329.3748059-1-miaoqing.pan@oss.qualcomm.com>
References: <20260815014329.3748059-1-miaoqing.pan@oss.qualcomm.com>
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

On Sat, Aug 15, 2026 at 09:43:29AM +0800, Miaoqing Pan wrote:
> This is observed on QCC2072 where EAPOL M3 uses the MLD address,
>
>   deauthenticated (Reason: 15=4WAY_HANDSHAKE_TIMEOUT)

I hit this on an ASUS Zenbook A16 (UX3607OA, Snapdragon X2 Elite)
with the on-board QCC2072: Wi-Fi 7 MLO SSIDs (SAE, PMF required; one
6 GHz-only, one 2.4+5+6 GHz) failed with reason 15 whatever the
association link, with M3 dropped by mac80211. Non-MLO WPA2-PSK on
5 GHz was fine.

With this patch, applied as posted, both MLO SSIDs connect. I tested
on v7.3-rc5 and again on v7.3, each plus out-of-tree Glymur
platform/board patches; on v7.3 the tri-band SSID connected as MLO
(on its 6 GHz link) and rejoined MLO after s2idle resume. That tree
also carries your separate dp_peer fix (8b6b871332b5, "Fix failure to
create ath12k_dp_peer on MLO reconnect"). I haven't tried the rebase
onto ath/main that Jeff asked for.

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1

Tested-by: Burke Cates <burke.cates@gmail.com> # ASUS Zenbook A16 (UX3607OA)

AI coding assistants helped run these tests and draft this reply; the
results are from the hardware runs.

Thanks,
Burke
