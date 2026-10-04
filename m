Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F35C414421
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791116948; cv=none; b=vDZSv+mPSeN7AKmI3WHJkqCGydl6cBHK2qBJ4XSNa4GTGt545T6RRITDFgjoqSm9QeNR+EzHr4xatUfmB8MgTi0ocLOTWxmEdMfATcvoHnG8zabwiD1hBnCuL5QRylaX2MZupQ2b1/c0JXORpNTNLyHSk1vJCYaDtuSI2t994Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791116948; c=relaxed/simple;
	bh=O8AOb5QLaO7btcj37/Ldlt4sf7K5LubilbX/lofAehA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBA2MkJ9m+L66AEk6EDg8pfpMva7KbXmqA2xjHx8krp7NySfkepzjAfjK53EFUZ8RAwWzMrNVbBKzgZ2ewP4+TYhf+vgMN04O2R3H3eERhK4f4aGHC52LV4XtYnGGGz2AnQV581OEmGtEG3X5LGiQo93ScwKio933mBfbxC/HKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gvPb8qHC; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gvPb8qHC"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so46867a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791116947; x=1791721747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lFxRZe/WwmbBPaTtaFu4NCRozMGI6L0mmZzZk89wk58=;
        b=x8cGbrEGjWskaLINtTSK4XoTvtsULfpYHMrvCteXTsAvHX9uL/dsDH/LV49mU5hJ7r
         VBC7OvhS//st2WoZzUZPIk6g8Bg/tDkzydgpDkS1rSbIz3HTy1eiA1wv/Zg8TRxsJVOV
         7nPb8xsCJx1zKDCCyafdhjLBbNNfa8pIWvivo9rEbAh6lAzea3gYuJxdWcqkps8iqbmp
         bnkQczOd0C26gUtyuh94c1/5WKEMaobUhgnLfG/HEMYDCyDSPH5xXBDv0ntvrOw7oHl5
         fu3LaZiwzNYhnFukP0iLCMHnubDKup6F+AlbT5T+uO5aVUmDugUiRBA/0gZSqS8oFATc
         YnSg==
X-Forwarded-Encrypted: i=1; AKwUvBx/0K1UpPf5EFOZdzYiScllyKviP9fTJhvdvYKWDpOlHb2GD4ztlYn23R5F3gSzg1TCmjVY2Fobj3PgIWIWug==@vger.kernel.org
X-Gm-Message-State: AFq9FYJpEBC6rXU9gX5fVMixXAYsUKxq4U2RRdnX5yvvvm5EHvGYnJ3n
	wjy5rHm25LPoyPeBUoh1MuvV0D9CWXLBeha6VlgAqUP8L6apSPcDyfDGH4otebZve1SmnEiUHBo
	wfZ1JotlJGGxD1xLg2USvAnnEBr0uArFggITwuaJTpZbcDECk2W6Wcc9MP8H0Oj0YdlKdy4icYV
	al00VEH4lSkGmfBtCtBTKDkmGkqU4l/JmtpS30DY2fOc1C7BARv3bjYSNwnVLzDNDCMfbTfYsFc
	FPYlgwEFfNppUU/WW/UmD3KCW24
X-Gm-Gg: AYBFou2+6llQdNfaRwGoWIPcdIsC8nzp1MPdCiaZgcm372gtkAQ20xsq/IeEgMqSgcQ
	NypV4AmVa+jH/l0m8kLk945p8N5LYnIhmSgNDPCFNUwq2ujYMqz+RcgVsLIuDgxSuXil0sYn8eb
	imLDGrQ7lt1+AI6oAqiCDSOKgTTgGuUPSVpbO1KWbKiLjyrxX98Hr/QrJcA0E72Fm6BscMdMu5I
	FPvfP7ROVOPGKpvAWn6kOGtsHagZDrcwllsoU7XZbv65gpK1QBv5sJhRq8QxUZb4lXqGyh/Xh9P
	SKagFKHgYNN5d/vENmyGiXxhnENdTxo+DK1lxHT0kAt20PWAX1f0wh12XhQSRZfO3ukVbXUM0jz
	sIJBoG17w3q4pgKeG6JvTmJ3PH7lEhT6lvQ3eZ1dLrAd2A9kYoUUywdbhU7JUrkaDIEEUeuHFY6
	/MQwKf338ZrV4wwLwxeRKrathkKKC36Wl2aWbPswXtpw==
X-Received: by 2002:a17:90b:1807:b0:3a7:92c9:eacd with SMTP id 98e67ed59e1d1-3a792c9eda0mr1753942a91.0.1791116946568;
        Sun, 04 Oct 2026 05:29:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a7bf399692sm410702a91.4.2026.10.04.05.29.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 05:29:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34bbf2e3c5cso1967659eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791116944; x=1791721744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lFxRZe/WwmbBPaTtaFu4NCRozMGI6L0mmZzZk89wk58=;
        b=gvPb8qHCErwh5NKRsf5UFEwscCV9c5S2eu+wxpiamYPbZf9l4WkdeYTyveOivSn7IN
         6Et0yXw0UM8kVfOf/GPgv6+8MM0PiBkwMMPQCQJlG06fD0/Kktj2LOnzlCgufqSovCGv
         yr7Srn/6hRj/NkMu5Hn5EBQ/AWOPsy+1a4TLE=
X-Forwarded-Encrypted: i=1; AKwUvByLrvP+nk0VBJv19glquCWzeh1dOn8hCim09vzcgAHaT9luCuzoShc/ylAfKWbbx2kDKnilhKnTu3TOm9QUAg==@vger.kernel.org
X-Received: by 2002:a05:7300:d518:b0:34b:dbbc:a72 with SMTP id 5a478bee46e88-34f2185446fmr13565330eec.24.1791116943593;
        Sun, 04 Oct 2026 05:29:03 -0700 (PDT)
X-Received: by 2002:a05:7300:d518:b0:34b:dbbc:a72 with SMTP id 5a478bee46e88-34f2185446fmr13565295eec.24.1791116943044;
        Sun, 04 Oct 2026 05:29:03 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3512713861fsm4656855eec.10.2026.10.04.05.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 05:29:02 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Michele Dionisio <michele.dionisio@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH wireless 1/1] wifi: brcmfmac: fix P2P device removal race in brcmf_detach()
Date: Sun,  4 Oct 2026 05:28:57 -0700
Message-ID: <20261004122857.1391917-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924123027.4122909-2-michele.dionisio@gmail.com>
References: <20260924123027.4122909-1-michele.dionisio@gmail.com> <20260924123027.4122909-2-michele.dionisio@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 9/24/2026 2:30 PM, Michele Dionisio wrote:
> When the driver is removed while the user space process that created
> the P2P device (e.g. wpa_supplicant) is still exiting, the P2P device
> interface is removed twice and the kernel crashes.

[...]

> For the interface without a netdev (the P2P device), take RTNL and the
> wiphy mutex in brcmf_detach() before reading iflist, and remove it with
> locked=true. If brcmf_p2p_del_vif() runs first, brcmf_detach() finds the
> slot empty. If brcmf_detach() runs first, nl80211 does not find the wdev
> any more. The interfaces with a netdev are removed as before, because
> brcmf_del_if() takes RTNL on its own for the primary interface.
> 
> Fixes: 9831bcb987df ("brcmfmac: Deleting of p2p device is leaking memory.")
> Cc: stable@vger.kernel.org
> Assisted-by: claude-opus-5-5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Michele Dionisio <michele.dionisio@gmail.com>
