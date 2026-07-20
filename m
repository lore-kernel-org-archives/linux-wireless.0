Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4092538BF9C
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 19:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576951; cv=none; b=W69lAVeyWTbr6nSaS9opoBnBkpkYf5RYJ5l7d/usfTxen65ufiZRweGzkD94xdsRCIQ0jVqt2mwvssfYQXN7Pd33ImY8GFlRO7A7C8Ezft2tOLOxV6fjCxLhzZ62vun3n3tGypCTwi/sIY2z6IcO8lP/sFU+I79es1T2sQAahV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576951; c=relaxed/simple;
	bh=ztxmNjXfgKgZkt7b+JrhvxBJmCCQaF0BuoffXtWBugA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4v/m37oESLGtw9HQJ1GI+pssFChkIoUu1zQngo4T2Ae5Dw4b6RQxfL0kTgOqPdytnf0KlN3+PHxiDxocPPHR1C1zOAkOokweneV3rExqUVPSmgvws2v7+8b9tixRyWtqCryhgyzPjWDnEhNYnNbb38hCa8YzvPTP0QlS00NGvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XDsXVmbN; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XDsXVmbN"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so94777625ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576949; x=1785181749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hoyrZqE1Bvx1hfQa+4u0/DLW7aA7wFVgfenpGZVSMXQ=;
        b=kUopr9+81c6rv93S3eP4q4mymErvBJ7JOhw8gGy9UesfMrYyAjdsw2l0RHNTqY6/C5
         v2c3zYibU9M4pNguw8Cb4pYqtSueFIwCo4Mo4img+ok+PmWp6EhmvkQgtgOKO02LEUUo
         CNkJQiJc8anSZB4jz2QR47+4phOCr3i6sNSoCLYFBVLpeh/roR/64ZSlsu3lQGbEsAYd
         MjFqn7hM6J0gD3vL8VtSHiZpuTYXw02uv4kvdXfTSZ7c1+pKGJW19cmD2uFz7Ye2W8Z0
         xZ7/fC/TdBvOD3MSZQ1FVDhmOu8w5a3Kj1Qpai1s/kjq6sj308hvURxkYZ+vrdNRlPyo
         o9Bg==
X-Forwarded-Encrypted: i=1; AHgh+RqAs2YPgzUiFWxETQS4rwkqLxdYmYLYPuWvuEQOfjX1v/SduQE6szX6vRxJpPf0DSi/+lCYLocVJYHouxzOBg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx32BEyzmwxQIMtplxY1bGVPFjfWaLZt3dwfHiU0+CTopgaNvBU
	cfd9TR6gugKNxBKBdznT8QhHzmeG8p9j06VdL3sn2nSDTHp+4Is9zfRFg6RfcvaceWqK7qy8+Jz
	R55VIweaY9V5e0kiUXy0wAGJIx7HaU9vs/CN5PQtkqT0DB3N8X+WU5q96aftGQLcdhYXFb5E5Wm
	lNBhwhoZbkJ7MAMqEh6XuoODjHf1005Bh+yjYSRDDjUtbD2Cfhypc108xl+H3ZnADMlmYlpwZrL
	Fp8v4CMn9kXgNyLpuO8xNQgJoCu
X-Gm-Gg: AR+sD10JuK81mAof4Q4RDNQnWuK8vRz08gWhwHfAKsks1dI1D1fIUI/JwHkpLsWkkXH
	AO3c/cquwV5fOqQfXlW81bGoafRS7foXZ1kqvYRhCXwDS7PUvdKfxvMgcYAc1/m08gbI0YWiOjF
	7oSGGkkyEfjTVrgw+KMCfwtdHhkHQTZ0muXPOgR2WPus0ey4eNRQVT71lBxMcyovLzI9Rkl5Ijj
	TmG/o+MvXYk7DrBJRDtaBpfG95OcNOq1vJiU+qIkq3Tc4KkHfVP07smNed+Ra159hV04GkiHdkd
	sqb8GQfIvBqfqiSP38bzuMnhIMl2PbUONiWUa+OGyFMJRTX72WCuvupErmJRT9YMCo0EMX9EZ5C
	MVJqFe/T0P0FIgxQcBwdBGVgDsEJUF/CTn9DwNiN4PdW4SU6cRr4DjQQe10Eh/4vnL2se6cnbr2
	dU3iM16Zp9MY3qcTWEKHiMr5Rz2M7vwpkDbm3aRMobnw==
X-Received: by 2002:a17:902:cecd:b0:2c9:9a19:10c with SMTP id d9443c01a7336-2cf34a4c9d7mr163535275ad.40.1784576949388;
        Mon, 20 Jul 2026 12:49:09 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cf34660c2esm10483905ad.31.2026.07.20.12.49.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 12:49:09 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15fed5653eso11988166b.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784576946; x=1785181746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hoyrZqE1Bvx1hfQa+4u0/DLW7aA7wFVgfenpGZVSMXQ=;
        b=XDsXVmbNt7a2UamVc7fgjextEme4o+w9le6DrJroBgDFc9TKaz1N3OfPgNwshcHW55
         j3p1OBVc7T9ZvUHjf8aTyRbOPyzEeXejxc9TcB3axKlhhDVtK1kwTgeu70EcJ4dQ1pQz
         /gMWCxeyr/Drsn0EkMmJCnNZtEtttFwDNFj58=
X-Forwarded-Encrypted: i=1; AHgh+Rq4OttiINbMmYvr4foiiDIUu1X96JgQxHvs9eqUyofBLLsLERK04NlXdpD+LG40PrZYUFmL/8s3lsAwTR94WA==@vger.kernel.org
X-Received: by 2002:a17:907:3d45:b0:c16:5fc9:e832 with SMTP id a640c23a62f3a-c16b48807c8mr666146966b.50.1784576945869;
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
X-Received: by 2002:a17:907:3d45:b0:c16:5fc9:e832 with SMTP id a640c23a62f3a-c16b48807c8mr666144866b.50.1784576945111;
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705912972sm506543066b.14.2026.07.20.12.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:49:03 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kvalo@kernel.org,
	eddiephillips@google.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	wright.feng@infineon.com,
	SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH v2 1/2] wifi: brcmfmac: make release_scratchbuffers idempotent
Date: Mon, 20 Jul 2026 21:48:58 +0200
Message-ID: <20260720194900.2356442-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260718024353.3147201-2-fanwu01@zju.edu.cn>
References: <20260718024353.3147201-1-fanwu01@zju.edu.cn> <20260718024353.3147201-2-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sat, 18 Jul 2026, Fan Wu wrote:

> [PATCH v2 1/2] wifi: brcmfmac: make release_scratchbuffers idempotent
>
> brcmf_pcie_release_scratchbuffers() frees the shared.scratch and
> shared.ringupd DMA buffers with dma_free_coherent() but does not clear
> the pointers afterwards ...
>
>  1 file changed, 6 insertions(+), 2 deletions(-)

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
