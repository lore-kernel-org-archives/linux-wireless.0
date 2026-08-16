Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9E8199FAB
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786886612; cv=none; b=gSrHb30VvAZYfUGcf05uyTX/lfpRNvcPIGXHtiCfmIl2oGozPnxALcxNd+LtiBUOii/2HvaNixvCS3bdtiJD4xdKM2H0zc1c/DfLLI9bWmNzSWZ3PNZ0N7zVDKyuCuX0RImKWdIEq3zF4So8Sz6mP+ldns/kQS2iQI1gfVh3zTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786886612; c=relaxed/simple;
	bh=PN6gCG+z6B1utNgqkVVKBl3bE+RgOT9FuJT76I+438U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWyxlC9zRkPYoom0NRLh2gFTR37hFjO8LDEOzrM6ZaRzGYnsDPfvdSb3fonGDMwVTiYlKQQPFQy9GeQqYe4n+Nt4yGXbf1BE1kIQ88npEBaOeI2e+qTo+RvS+JiKfCn7J4rIjgfBwhLwBen/XmzSUzxCVC1x/AglyxahB21H6YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXIDmgu6; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXIDmgu6"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39c86945164so23281411fa.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 06:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786886609; x=1787491409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vg9qAqprJ1qT8ZCEcxsSaRPXUDpRR/0AcgE/OG5kf+U=;
        b=iXIDmgu6EubDrlWbvqjp9UG+3s56TjwRJJeWUbMR2wxzpXAVQISLPUgRXMUFz75xgZ
         RJ4YEsQE9pNr1PV3i93MKDQc9LxTvbOS1YZJX3I+zYcIBFQydijUCjzeF7Iz+rkgRpmd
         bh2SdYdmL4Y4+FllWRcuRbAd/eyS/RiK0SEjjK+o3TcKSB4ti4PynIbiiE+CE307ys4J
         uaTmdRuSX4cVcr+e8ORX0BnXVfbKJ8R1YCRlBGhhzPANZzgmGkRS0IuamNP2udD4RvVH
         vhu/rBYgPvHMzHenap4ggErOE3gXmrOU6iNcbYYjNll2VHEWZCLLNJInNbRulzgl5w0v
         9bfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786886609; x=1787491409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vg9qAqprJ1qT8ZCEcxsSaRPXUDpRR/0AcgE/OG5kf+U=;
        b=Dh2INoGvx84LR5qlDPiqd429AAqgoY/LM3YvHAVModpb6kvWBG30dDD62h52Y8HNUr
         +a6iIHnx/kkvFNLYqkksDGaTatA3NYS8Lh7xfkOzh5qkRS/QXkJ5MIkI3NVoITklPpT9
         wo4GlJJewvVkXjrvXl64CxHVY2aqaQ0+zmhaPQHthRDRvuMXDRuO6OThvAM2PKr+AdJv
         /ynBoHh2hwC+4DwHXXyH5hIwsk3qfDqDX5UrPlmIIQOyMee1K4HPg7K/uzpQ8P+eBAzW
         6EW+2lWQvml7wDRMet+i38EdwVrp8n7IZ0/cy3y6sfMJop/8D9K5AkdM++C+AG+Mrg/x
         lzNg==
X-Forwarded-Encrypted: i=1; AHgh+RqnsER5JfvlvHu1K6OUZANrEm8O47THiS3VS19hF0ex5ewm92ewhQn2Q+7br6XVTsQm4/uKdURtIJLSBUlzLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXETN222S3lZDul2RWBPmPCAoxEJTaM3i82NVA5P83xVaZ6gi4
	jRAVexsAM8DWmQ9cY4HwiTPMKiVv0VMn2ODsAzSp1D1QXvI1u4cK+Mqt
X-Gm-Gg: AR+sD11FBClDWl4mENCoaqgQQmUCUhHWi/zswni++aFMT8pjcUQgMOe/rNF09yroOzk
	u6q6+j5zBV9qxo+wFIKBikOhIVQyyXkiu9TbiVpKpehM6Le79IIinJqh6rzFkYAQQavF95StvX3
	erwI9TM9qL/lyJS6TQqXj9rLSJveOM8+UsdOulrAjkdp9/5t+MNmZTiVBNddT+zm5RJeaYBQqKE
	1eYXJD6eZSZGxoIRLSLLcJHUhsEcUvdnjLPMDecTmu8zhZLRZh0vLdMRV4qW298PW+KQlY0B28r
	FNzrH8hdjyfc3mDF1cruws7TyZ5q5B7EfzGi6GGTqe4cmipTfRmw/l2uOeU8NYw6j4UamuCVKjn
	UqbyucEeQB354e/dPJdiGxFMEUo0Z0qkdV0o56Q5Ef5COvOWOPWExKZJ2SlxVlC0XHStZAQUL+n
	+IO1WWC4iQU1kPJVEvYJJ4k9OOCgC7bxr7NmQ6+XrItdVBaf0RIX3iErXOJoAfYmLZgbqN4R/Lr
	tcXkLaRb7qy/C4dnb9Kqczftm2bRuze9r2KpXLQ+QtFG4dN49gItWxKvjAHokPqQj2XIFs=
X-Received: by 2002:a05:651c:2113:b0:39c:71c9:e28f with SMTP id 38308e7fff4ca-3a1327dfff1mr17716681fa.25.1786886609125;
        Sun, 16 Aug 2026 06:23:29 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a130cfd4c8sm18812451fa.34.2026.08.16.06.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 06:23:27 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7921: validate CLC firmware records
Date: Sun, 16 Aug 2026 18:23:25 +0500
Message-ID: <20260816132325.23007-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAMyXUJmh=WfwC4_KHupNxYR5e2Gy5QhBDL5TSG6XEW-XLa+X4Q@mail.gmail.com>
References: <CAMyXUJmh=WfwC4_KHupNxYR5e2Gy5QhBDL5TSG6XEW-XLa+X4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is in linux-next as 9417c5818a01, and on current shipping
firmware it stops mt7921e from probing at all.

An unknown clc->idx is treated as fatal:

	if (clc_len < sizeof(*clc) || clc_len > len - offset ||
	    clc->idx >= ARRAY_SIZE(phy->clc)) {
		ret = -EINVAL;
		goto out;
	}

but linux-firmware 20260810 ships an MT7922 image that legitimately
carries records with idx 3. Dumping the CLC region of
WIFI_RAM_CODE_MT7922_1.bin before and after that firmware update:

  20260622, region len 366448:
    idx=0 ver=1 nr_country=255 type=0 len=179384
    idx=0 ver=1 nr_country=255 type=1 len=187064

  20260810, region len 475488:
    idx=0 ver=1 nr_country=255 type=0 len=179384
    idx=0 ver=1 nr_country=255 type=1 len=187054
    idx=3 ver=1 nr_country=0   type=0 len=54520
    idx=3 ver=1 nr_country=0   type=1 len=54530

So mt7921_load_clc() returns -EINVAL, mt7921_run_firmware() fails, and
the probe retries the firmware ten times before giving up:

  mt7921e 0000:0b:00.0: ASIC revision: 79220010
  mt7921e 0000:0b:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260724143257a
  mt7921e 0000:0b:00.0: WM Firmware Version: ____000000, Build Time: 20260724143402
  [ ... nine more identical pairs ... ]
  mt7921e 0000:0b:00.0: hardware init failed

No interface is created. There is no dev_err on this path, so the only
clue is the retry loop. Loading mt7921_common with disable_clc=1, which
makes mt7921_load_clc() return before any of this, brings the device up
normally and the firmware is loaded once rather than ten times.

The rest of the patch is a real improvement - bounds-checking the region
table and each record length also closes an infinite loop on a
zero-length record. Only the handling of an unknown index needs to
change: an index the driver does not know about is not a malformed
image, it is a newer firmware, and the record should be skipped:

	if (clc_len < sizeof(*clc) || clc_len > len - offset) {
		ret = -EINVAL;
		goto out;
	}

	if (clc->idx >= ARRAY_SIZE(phy->clc))
		continue;

I sent an overlapping patch yesterday, "wifi: mt76: mt7921: fix
array-index-out-of-bounds in mt7921_load_clc()", before I found this one
in linux-next; I will mark mine superseded, since this patch is the
broader fix. Happy to send the one-line change above as a follow-up
patch and test it here, or leave it to you to fold in before this
reaches mainline.

Separately, it would be useful to know what CLC index 3 actually
contains - roughly 109 KB of payload in two hw_encap variants that the
driver currently discards either way.
