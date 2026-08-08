Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E65330D2A
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 17:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786209796; cv=none; b=qlpura+q6VETyMsfoJOud48Jq1VM/2sEWP3gYjrgqUYOGw7ORw9sAjVooXeG6rd3GM+XxbLMJXkgMsiNl5zGhr51PzeeLjSbBtHJuenpxGF6C3HrxvAuhEegQ2JERbbOULamzV6u8mNaTzjbdOHA1B2XR6Hm+Qxs21FUTvM15CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786209796; c=relaxed/simple;
	bh=8L4kkJyzr/KPVpvMP50Aqh1x1F0d5HYPXADX3t84ZBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bv28SV7SAz/vwYNyG0ueubYJrG/Crs2AuO0bSOyZNzJE/TMLKop/IMUluCPqXClgVicpR1UTJRrKlt4k5Wy0tqSo6rwlQ0lZAx0TcA36KOHiPMblR1jZOVxjA6nWVJ0LQXclxfMksrh9g4Sd57Jq+URiPw5Z8WN6wjmxIEa1/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YLDQUBlp; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLDQUBlp"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6611669cd16so692051d50.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 10:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786209794; x=1786814594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4pCPd3s3NemWrV5V3FYSXF9p9xL4kMmAf5P1ql8hShE=;
        b=YLDQUBlpG1g4gqDwJrgmxUgHG/1rIfMSFRuNJ5bD9fx0K+rsq0dc/8vSVsF4WM/chU
         vb7KT8Kqu6c2fBnlvoA0xcE1zypUKM2IyFLeZlTV78C9OWkuhi5WqGtiKiXbNZgHP1yo
         tEekkTiIHwHzLjPnB0/AIQw11c+I7fJk5trGd88zM9C/gGFB7YVUCvKHamcMfPZXQNWl
         6OSAjEdTcF1ErKJqQJgJeVm31tvCQ6Js48k1Xs8OwEqCKQNCqNmj6vBW9B7GHb2JcB3F
         zhB09qS24OoCHJbIaLM2XcX/bYCwfQ8BCCM8MLnpRhT2jS/VSjdro5OZU7t1J1zkaqid
         2+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786209794; x=1786814594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4pCPd3s3NemWrV5V3FYSXF9p9xL4kMmAf5P1ql8hShE=;
        b=mDKIUkLs81TQJ7E7ozIecHUKEtXHgjs5NX9rXCwhqGu/qNOkuajpdqfWM+auwC/zkp
         GYzoSa1ii1f1LomHiFlIVcmzswbtEjuvpyqrS62ApmKEylGmybQydPEwilyVWVCtrs2k
         xqpyriDML0RjBdocmp2x0p3uy7f3iT3T5KM/eFKTHBnNi9pw0AwLIqqaoNfgT1SkPJqv
         kRKKtueo6x8Nwo7xh+glkcpWaiTK0vcDhgZyK2gVEptYa9vJb48qi1S717q8lwOHwWGM
         KcSrrdLgCuNpg2z5EBM9zJCJoJP9bPR9LSGKFFtb0gJDKIQbiBjXtPJrmKZipf0NoQdA
         6lHA==
X-Forwarded-Encrypted: i=1; AHgh+RoTS8GNLEvDe9Ihi5d3w6T5FMK0h3kdfw9kaugRjn0Xn6Srt8QhlIZIRuiPM7y3lsyaN4Wc53qbTTgO3/f52g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxapPWkGwXCMoQneCeWlwakYNh3kjhDkeSsXnwADPmqxSjCxULe
	fdZJ9oEdDvLBcHaYD10loLy3P4B+K8TVvvZLYHXdtHIoNExiAb+3LUjy
X-Gm-Gg: AR+sD11WICYynisTfy+20sAp0lk+i/ZRQcmlZVR4NZHW//Eeq76/z0WUF2ExIorQnzF
	lH2nEycBwZCMFlpJFcP2rEOYlYOFzblp4UtlBGxYOo2Tmt5ovaQoVzjQZmzNBZH6Dol7twJjw3b
	fBrkBb2xr8+UAgh25hG+UHFl5zNXwWmXYGmPw+jhIqi7YiwCNshdK1Ei9XmR0cjTg0v+KW5oeEr
	1vfGzIufIUWpQQo0LU732qFX/RUg3dvd9R28Z2CxG0yBtS0iDMnRDnPOMt4N3D6O1FiVI+4ObZC
	dtqGCf0eCmvFrFZl5tT/xZNJ7KJ/lOPRFmTpuBCCMz0scobQMHLiCZLBrekTZt3Y5YAJ8M4P/SM
	hs3TdvuHOmA6DqhayH7a+T2WuhM0oQPuKbC66t9Nv9vn36URTtE0dYTkO3/Yn7zbe7F0okh9OID
	rgcX4M6nUt0bo3D+gU66iNENGFB2QxVUhuhHcWYqS3hNw61A==
X-Received: by 2002:a05:690e:11cc:b0:667:f1e0:3f69 with SMTP id 956f58d0204a3-66ad721f961mr5089313d50.17.1786209793977;
        Sat, 08 Aug 2026 10:23:13 -0700 (PDT)
Received: from hp ([71.12.42.234])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66acad06ad5sm3367129d50.5.2026.08.08.10.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 10:23:13 -0700 (PDT)
From: Tim Michals <tcmichals@gmail.com>
To: yanli.yang@bedmex.com
Cc: zhirun.liu@aicsemi.com,
	dijia.xu@aicsemi.com,
	chunqiu.liu@aicsemi.com,
	johannes@sipsolutions.net,
	kvalo@kernel.org,
	linux-wireless@vger.kernel.org,
	Tim Michals <tcmichals@gmail.com>
Subject: [PATCH RFC v2 1/2] wifi: aic: fix stack buffer overflow in aicbt_patch_info_unpack
Date: Sat,  8 Aug 2026 12:23:04 -0500
Message-ID: <20260808172305.138690-1-tcmichals@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During hardware validation of the AIC8800D80 SDIO chipset on real
silicon (Radxa Cubie A5E with Allwinner T527 SoC running Linux 7.1),
unpacking the BT patch table (fw_patch_table_8800d80_u02.bin) caused a
kernel stack protector panic:

  Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
  in: aicbt_patch_trap_data_load+0xe4/0x110 [aic8800_bsp]

`aicbt_patch_info_unpack()` calculated copy length as:
  patch_info->info_len * sizeof(uint32_t) * 2

When reading `fw_patch_table_8800d80_u02.bin`, `info_len` resulted in a
memcpy size exceeding the remaining bounds of the stack-allocated struct
`struct aicbt_patch_info_t patch_info`, overflowing by 4+ bytes.

Fix this by adding explicit bounds checking to `memcpy` in
`aicbt_patch_info_unpack()`, capping `copy_len` to `sizeof(struct
aicbt_patch_info_t) - sizeof(patch_info->info_len)`.

Signed-off-by: Tim Michals <tcmichals@gmail.com>
Tested-by: Tim Michals <tcmichals@gmail.com>
---
 drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c b/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
index a1b2c3d..e4f5a6b 100644
--- a/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
+++ b/drivers/net/wireless/aic/aic8800_bsp/aic_bsp_driver.c
@@ -1148,9 +1148,13 @@ int aicbt_patch_info_unpack(struct aicbt_patch_info_t *patch_info,
 		if (patch_info->info_len == 0)
 			return 0;
 
+		size_t copy_len = patch_info->info_len * sizeof(uint32_t) * 2;
+		size_t max_len = sizeof(struct aicbt_patch_info_t) - sizeof(patch_info->info_len);
+		if (copy_len > max_len)
+			copy_len = max_len;
 		memcpy(patch_info_array + sizeof(patch_info->info_len),
 		       head_t->data,
-		       patch_info->info_len * sizeof(uint32_t) * 2);
+		       copy_len);
 		AICWFDBG(LOGDEBUG, "%s adid_addrinf:%x addr_adid:%x \r\n", __func__,
 			 ((struct aicbt_patch_info_t *)patch_info_array)->adid_addrinf,
 			 ((struct aicbt_patch_info_t *)patch_info_array)->addr_adid);
-- 
2.43.0
