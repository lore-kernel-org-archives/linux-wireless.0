Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55549379974
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783895603; cv=none; b=aXgn2OlYbhtkDY5VQwJ+caFRpOUEnxm261vCJBr7x8T/wk6qIR37yj5gBjTVufII+YvrPub/8A5CVVP48+TN4+BaGpj/L4DCwuejX43mfFz1RuXxoalX6+4mOA/kbebHTAyt1TlgmWoM6kIFJgvCvfyn8w+bBcJbmjAGqo7PUek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783895603; c=relaxed/simple;
	bh=9eV6FVRBj0+rcygV/638gCn4ARxyqwVGy0pBnruSIEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNTa1SrYnFz1mDJy0YLw19CuPK51Zki6zGN4xRMkNNg1siMTbHF0EdNWqu4+HsU4GWhwtlz31Fr3aigp/62i0o8EileElNQXhdNJA+dB+CVCvs22c9fmEbm0KvahYajJ3GDean5AgfGrl6BoInl5EwQzy3JueO3+s13y3B/Z3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UcU6fRmc; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UcU6fRmc"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2cca0c5799eso25313535ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 15:33:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783895602; x=1784500402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=as9uoNChv4bOT2fKEipNolL6IX5VF1WJ1fVqwJJ/Tbk=;
        b=fBQV72wpWl4LzaP3NXzFyFiW+R6OLrCBhl7r2e2zNirrqlNFhpXDqSS5IDVz3bsDZ+
         gPhifQ7rLZHS0nAqz78N6LQK3rywGpfHRKav+bD53n+UAtKrCfceNxeokY5WEi1PBqhu
         uTOTyxe5H1MWcseAifnzLy89Ws32CjybxWbneAZGGdK/XzFjnzYPvDR3dyMxKKSjPxkj
         QZDdjXTjcRlKxG3aLIQ7OWY/f6cLhGcJXbKXf7NVtPQmBVWZF16sW+Mhy+u8DEZBSuCJ
         y1lMyM6HJM3GMpXZA/yVgn2xpudgrsDBoe4ccwQqqB8U8tIzrK0H/HwIScrDYKgmMJxe
         N/PQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQo8YL8enS/M7BiFHLYjLeqdD9Rnkwzzyy9RV/LZqf8oOl8a87yk+FWnyInVU6H2nACLWhvOp154Qv8EYRzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuXqrpcv44hE+O1cQ5vTHf0kxaslQZwxqC27HAVl2zVTja7qKN
	P/UEfD8How47gkE8jeAlXUrycI4vUWNC8IJPYHU6+oCECWm+kahqW1bMWq+MLbOQ6UEsgrqrpFN
	giJ6p91l2tFpAeLRmDNGlBEmO8c1/TezDzIngdpAInmAEbM/da9brzKiHB+V1peDtl1rUp4nrZC
	ScrvJNgbmGN4sMsziQrOPCTgrL1KmEkdI+kFS2AaUH5L46pyXzJQqDHKFuVybLtT+rDK+Fj0Zzm
	wL+2zZUNhxpSrmb7xHI08XiHSDC
X-Gm-Gg: AfdE7cl6yDnww8TSFrgDK3Ua9Fs3bNMGMARSOkuEtnErOlDRQQVepta0osem/Iqlbxz
	JUSPKBnYrRb5B3cuAL9uAV+Ffx3LfuqG8IaxWKIXF5dAPZ0sSmAgWA1aVrV/pcQtml3hi46Be4/
	89ZYYyNclltvh4U7lU4PIJDOTY62BDPB5DK/mMyCEDDXh5EMQTXA1sglJlHEYCU0hODwXWAzoaK
	AgfZv/o5vQG4JxrLQqA0+HTtLwnfWnZzjvZCsQI0wkZ0ncl79UKIDl1/Lt1FohIhAx7eGr+DkZE
	uNewnpbWY59x1pRW+A29xUHDjSyW3iuKb1lnfzUpood7rmA91MeVAA79Pc70XDF6Zz60NKsl6kF
	tMV+h+GlQNNpIY8rY4M97Bw8JKmeivoJ6Pwtmw4Oz6t8gc8DvP0Ygjz5QLPo8xOy2Hjkz4E9tgB
	xOCeAtp2IkPa1GgvBk225SUomSahJayb1FnIXlDnBTRV0qCQQ=
X-Received: by 2002:a17:903:110f:b0:2cc:aa36:c04c with SMTP id d9443c01a7336-2ce9eae29a7mr68617945ad.1.1783895601534;
        Sun, 12 Jul 2026 15:33:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-6.dlp.protect.broadcom.com. [144.49.247.6])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ccc9ccdc15sm17778835ad.33.2026.07.12.15.33.21
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jul 2026 15:33:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-381250979d5so2805740a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 15:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783895599; x=1784500399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=as9uoNChv4bOT2fKEipNolL6IX5VF1WJ1fVqwJJ/Tbk=;
        b=UcU6fRmcDwP1BOIrJmXL+A6qaGJTwC5rPvbWnEUbJT7Dt0clJ354cZ2qzBK8UTZC+o
         a5Hk6epiCXqK9H6ujsupj0gPcQvg9rMBhBDzBsr92wuN1TNKXlZdv+YoZzRgrurwKjFA
         VtnVP/FjHqSlJKMNFQR2GHgk9DBQAqM0XxtvA=
X-Forwarded-Encrypted: i=1; AHgh+Rot6ifF8u8ES2WuGiD5WTnsswNGtYfiIQX6QcDbrkCWjK3np+hM+D7lDldEgX77oxq7cTypGiSF8hytw28Ejw==@vger.kernel.org
X-Received: by 2002:a17:90b:2b43:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-38dc7a494a6mr7053678a91.14.1783895599471;
        Sun, 12 Jul 2026 15:33:19 -0700 (PDT)
X-Received: by 2002:a17:90b:2b43:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-38dc7a494a6mr7053673a91.14.1783895599053;
        Sun, 12 Jul 2026 15:33:19 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3120c8e41fcsm30681627eec.15.2026.07.12.15.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 15:33:18 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: arend.vanspriel@broadcom.com,
	brcm80211-dev-list.pdl@broadcom.com,
	brcm80211@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Kurt Lee <kurt.lee@cypress.com>
Subject: Re: [PATCH v4] wifi: brcmfmac: add DPP support
Date: Mon, 13 Jul 2026 00:33:14 +0200
Message-ID: <20260712223314.2182929-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708071230.312836-1-Jason.Huang2@infineon.com>
References: <20260708071230.312836-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 8 Jul 2026 15:12:30 +0800, Jason Huang wrote:
> Add DPP AKM handling and RSN parsing support. Map DPP to the
> firmware wpa_auth value and recognize DPP public action frames in the
> P2P action-frame TX path.

[...]

> +	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif &&
>  	    p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {

[...]

> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 151 ++++++++++--------
>  .../broadcom/brcm80211/brcmfmac/p2p.c         |  59 +++++--
>  .../broadcom/brcm80211/include/brcmu_wifi.h   |   2 +

In the v2 review I asked to split the P2P device vif bug fix into a
separate patch with a Fixes: tag for stable backport. The null guard and
the fallback vif in brcmf_p2p_abort_action_frame() are both pre-existing
P2P bugs that should be split out and submitted as a standalone patch so
they can be backported to stable independently of the DPP feature.

Please also add a changelog below the --- line describing what changed
since v3.

Note that the P2P device vif fixes are pre-existing bugs that need to go
to the wireless tree for stable backport, separate from the DPP feature
which targets wireless-next.

Regards,
Arend
