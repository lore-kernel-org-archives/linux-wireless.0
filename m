Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042D73D649C
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785926900; cv=none; b=tfvCkPlorIBHofkj8ZoOZ7r0XXhkz8jmmiITV5HaOKYDPfKQ3FLklQzMED8ZCg9qRRzt6NSdNMUJk8H28SCnbtwYjlSrGV/FdxKoOwLqnHuJfzqLz3dEP6Qd0FjIbWr6YXM+QK+S2T4r+bWHykqicZZ38GRhJWJVQOIOA+gSpsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785926900; c=relaxed/simple;
	bh=gUpyyqs6gJpCeGpD1RKcbYYS2KUuR/dMlYj1P/DLGu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFY72XhdN1E2rS9Ucog4rj69ej5bXIB4NB3+qWb2hZ+expGfZBUdi6ZxkucRLO/X+iXFOty4h3f4Z2bwPqnqsWVMig3LAsscmiNFeLtu7l3N5JAEk67x3jLr0TDMSODUJlcPZKmdNSDNFTd8UlgzWS9dRhyPtqTslowPou3R9l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=TnbHlg5F; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="TnbHlg5F"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a051904222so1026017a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 03:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1785926897; x=1786531697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GvEJw99p8ayWOXHnBsyaDzv0WkQm248L0elbcOdHRLQ=;
        b=TnbHlg5F+1JLvbJsTBIaeCwNK3QWEG/X+j7FwgkYwKH2716v3+IYklycY7B0SpTfjf
         AFplASwjSW9lbZAClMoJ8/85tiLwyJcoWZyZp3cV8hwdOGD0U+YK15xrCDseDq3d05D9
         o4+TL2ZuLgdBQ0e+9ZlwaRS6wCKtglEhlzA+qk89c76fD+l19fHBoHTJ9GPfsPKqmRqT
         QnJo8mv9En6Yene95Z1NDeVAn++U3FWlwr2aJfuumooCCrVgBEcOEUaOL99DpbanUDQb
         dE3agM386Ql4UOKu2udR110sixOxcdesMiZOgag9dt38lWzyV6A48sLc3rTfYbdB3h/X
         nMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785926897; x=1786531697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GvEJw99p8ayWOXHnBsyaDzv0WkQm248L0elbcOdHRLQ=;
        b=NMSY25AJycu6kK/BQBDaSnKPfSHgXTTQ3IHD3nvYExS3cd83WqbD+Hau/CjxW8qCUz
         mcKd/yifpceYbGB9VoaRdpfKZI+ounZpna2uOP5udWjITxAUm7EkC9Kn37UlyHt/AACJ
         hmWblPjzcQuLg90gn0+L5agLlwmphzHhrRPLprhwrYOuMAxxRYmsRqHgaplZhWwSOV9q
         gFb/Y3HzlfZV1A5vFuMX/idWYNaH/arPRDk+/xPWwr5GNKBttxVmdT4zH4FBzvZUbm/1
         HErBomry1wnkxZhKQXhx9oO1140SXHvoUQ6BlYamxontNTzf6vCqUEf+jDmvMFEL9b7e
         945g==
X-Forwarded-Encrypted: i=1; AHgh+RpryBDSEhjKqfTTQoNIQY/qnMyXbVGNeOwF+cF26R4iPfdNeVb35/202cqyHo4+B+iFZBysLXCUh6haJ6dZig==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoQfx1/ATYpU3+btjtMf5jp2PsePvXD4gt6yoYfrFLFJhJW+GL
	8gWmqvLd14cW9lrjvFXeFRCTNA1BzrOYtVgjVCTjNanbebZ5m8stuBNiwsxUV3kBIAACRl9SJsy
	KuUMrwSuB
X-Gm-Gg: AR+sD11Z+pPp5zR0zhEFOHkvlOUyOlgVPtd7fygL4/foEVN0V54vvwoumPwOWNTz8bM
	NTyfMfzdO1pxZGVZuiabtHPZOAMtuBA2KZwo+MkU9YGzC2lnM7yZojXn7PkPXVfKE/tSLzWQzDz
	Hn3Gbg96kRZNYsv/G70WD46m2gUGaB/e0oSgBsui8oxbopv1QHkYKvBDbgGbo91Tmwb3sU7pHc/
	YUu9Z/9U/g2JJLzu8WNpCz1+lIne72aF2itVrPD6liy99a0YJ1MLCmorB5v0w7hMsITigK5pNjf
	xq8wMEC5Rz1nX3OXW+BDhilLeHPihqQH2fZoAgMLhUllXm3YvttX/eLdNDbqb21cG1zjrE6oBa9
	NEHjz4xZ+zd9lXIPIxss/AaN/WPY2fGFqg61jb3p3FI4XRQc1UPWqNLbCgX2vbw3dK1FCokdf5F
	F6qFiH2MULHSBL8wKsZ5gWcYHHK4PKbLgNVHT6U7LChj9Oq2tA+kDogDVk/rDzr1TkIHxAoFh1W
	Rlvh3bRfxLXo5uiH+Hzzk6YMIKrEUZMAvzjDgT4gKnQeKl+5fo8DsC7AofZu0Q6Rmi3N9sI+Jq9
	KKyhS8qLMxNzMh1Zx2tX+fOnWgM4drUfbIKQCx2FFG0H5FCyGvzEsKwvMuFqXllmAQOOKx4pMwI
	IzuTIrwJ4kxWNYJS3Q/LDiRq1ANeFcTYklOmLjMNJClZ6osxiHVHsOKvToImuWmE3v0ObYvmx03
	4CQBThTTnlGK9l
X-Received: by 2002:a17:906:ee88:b0:c07:43ed:1b3e with SMTP id a640c23a62f3a-c2039901c40mr314065166b.0.1785926897008;
        Wed, 05 Aug 2026 03:48:17 -0700 (PDT)
Received: from Desktop (pd9513f50.dip0.t-ipconnect.de. [217.81.63.80])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036426ca8sm91267766b.50.2026.08.05.03.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 03:48:16 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath11k: fix SoC reboot on firmware crash on AHB
Date: Wed,  5 Aug 2026 12:48:00 +0200
Message-ID: <20260805104800.576058-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260726221908.104873-1-julius@bairaktaris.de>
References: <20260726221908.104873-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ping, and some extra data since v1 only had my own bring-up tree behind it.

I have now reproduced this on a stock ath11k with no out-of-tree modules
loaded at all, on an otherwise unmodified OpenWrt mac80211 backports
6.18.39 build for the Xiaomi AX3600 (IPQ8074 hw2.0), firmware
WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1:

  # grep -c ath11k_nss /proc/kallsyms
  0
  # lsmod | grep -c qca
  0

Driving the debugfs simulate_fw_crash 'assert' trigger, panic captured
via ramoops:

  without this series: 1 assert  -> panic, SoC reboot
  with this series:    5 asserts -> 5 recoveries, boot_id unchanged,
                                    both radios back up

The panic is the one from the cover letter, verbatim:

  Unable to handle kernel read from unreadable memory at virtual address 0
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
  Call trace:
   ath11k_hal_srng_access_begin+0xc/0x60 [ath11k] (P)
   ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
   ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
   ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]

So the AHB crash path really does reach ath11k_core_reconfigure_on_crash()
with the interrupts live on a plain upstream driver, not only on mine.

Two things I found while doing that run, both separate from this series
and neither ready to send:

 - the recovery leaves a list_del() warning from finish_wait() in
   ath11k_wmi_cmd_send(), once per recovery. ath11k_wmi_pdev_attach()
   re-runs init_waitqueue_head() on tx_ce_desc_wq on every recovery,
   under a task that is still queued on it.

 - once ath11k_core_reconfigure_on_crash() takes its err_hal_srng_deinit
   path, nothing calls ath11k_hal_srng_init() again, so srng_config stays
   freed and every later restart faults. A recovery that fails once looks
   unrecoverable by construction.

I will send those separately once I have them properly narrowed; flagging
them here only in case they are already known.

Thanks,
Julius
