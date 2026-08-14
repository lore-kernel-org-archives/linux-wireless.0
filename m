Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DED635C68E
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 06:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689440; cv=none; b=OLkiJ3MgwGiS1MT9pb3qdAMVjYtVf2cC3xq/xPsLYyqFsd33uCdytYGcygy4awWsZ6ShUgOgQAeoK+R+2xBckKS7Ah+xlu9Twb6R8T/TDs29lYCAyQRwUbQ0RqIkD73igkzaPTrzm8W86UOvd6hHQzyx5676WaC+1Yb1bsyA6Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689440; c=relaxed/simple;
	bh=bGTRgAvVdDCF3ilVLwg8kCYCxhJyQlbxy6pWJ/SeqdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEmLr8+m7jkLtfu9GbcEKC0AU+eKCqgqVHxxIm1DMEIHv9PaIEXU2PnE21xWfZfL6o1tDmGyRp2tgQgXWDmU6qJR1oZLFsmn+yxt7jvyt2iwcabbc2Ri/Zr2dEjqpBPIeKEbeYOkNPvnYDKZiL4dcK2jWG9+GsiRP/OSpWd0j0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPrpzryF; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPrpzryF"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so4644215e9.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 23:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786689437; x=1787294237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bGTRgAvVdDCF3ilVLwg8kCYCxhJyQlbxy6pWJ/SeqdA=;
        b=DPrpzryFv/1Euo1FEWeBPKUFv5BizuyIXznypAsqHCBkrDrVsnsmaGNmAbX97T9GJW
         Yo9GO+EAX8rxVjtrz66llK68WIc7yq6UXC4M4SvWTZh9oyu6WJaN7lZUqXMIw735TJMi
         SGH7xNDo720cGUhIX6nNvdKKLZob75LirqGbwZpvehXcyg2V4Y2+5BJeWShAxzM54/eX
         N80qLAtLkBKZG2w72tCICMi6MHjhSAv/cqGtaQ6UYJneLQ9oCcDTtMxFwjnCB6LpSP11
         GqZIfTYQfcHG/UknLm6fTpuyEFu5Ma/HMYn+0GU1mAHl5k7VdmJp1oUjZAqYU2R98trm
         ad8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786689437; x=1787294237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bGTRgAvVdDCF3ilVLwg8kCYCxhJyQlbxy6pWJ/SeqdA=;
        b=HeFRC8tqjadYPq5uAN/t10B1oPg5Bz9/sho0923zqGQY/AooYyiQufJ8bwsepKmMt/
         j0QgQgaPpQLW1afd9k/USspmvOhIQsQZ0T8Xjyx3F3ufEYPmuxjfufA+Y0yu2PrmOV7b
         nZPT7YK0GZs4Sl6a+MjShBJgVqzpDm1hRLWB/qKwOIDiqWUeeshkWi3NiJbwiWawdZ+o
         ElSxguW4lJarj/v6dXCLtmse4QXOM2BbcakuQV1p1GOcU0FEqp2uYqSLm8XyGE7ku59X
         2FBi06A3pZJkWAKkNrsEON6wbaRpGwBdMDK3h9vRR9A5QBh2FyprhdkCIrDniOZv20Cb
         epWw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0G0BhRapgoZfiLs0b5MjlLMsEcVNzeqY4G3flj4rlmP7hSbRMkrUIevm0StMe+uRYe4/1zXrpzJHMYUDlqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoTBIWsKRaQNlIXQd8iHmlvuHDLvNU5JQB2i3lje/sws+BqhCF
	pHlAaX3PPTmpIKCa/14+Kq1HXAeBL+eRYPUOPhTAZQP+FnptUH/lxZ3E
X-Gm-Gg: AR+sD12Of4F5x42Y6yXhbKlW/AnRKjlC8V8C9aH4NTRlwXwgngkrqbCDViZ/g5YTPOB
	WR1o4RqBcTdlEl3o2eBKu7XN8P1gT9q6yCBDeiviPStZkc1kOg+HzvQLGDftMdWa/W06ciB4cge
	NvqKFkbbqPT0NbcDPOADWOrQ9MQ96eAjZxvTvOj4dhK87mXfASjBetUaHOTkxjNodVrlfXcxarD
	EdqVVkc32HGgwVhn9RjqDJgcHSujR/y2M8Wf5H5waZqm9mpGeHwAJZEOY2KEDBh6yydKN1HSaGb
	K8H2iL+knq4uNUIn3UirNvdLIY9id37L1EVg4ZPH8nwAURiN82ckg5WAA0UFgtpaQdbqLCXmHjG
	UCNLS1wng+tdpIJPpk5fBBZfR6JK+jLJmRFqFdgJS/q0wEoHEBshlP3WI1KZS5WG7QgUL8CCmCz
	5JIKYx92sFMlRVcRqRlA/fDNUK410/gGKTyJHSUTa5pyEx91i3xZ/a9FS1iqOso15HK8073gBgN
	X14
X-Received: by 2002:a05:600c:1da8:b0:496:bbce:fc with SMTP id 5b1f17b1804b1-4998798467amr45381675e9.12.1786689437299;
        Thu, 13 Aug 2026 23:37:17 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998777a4bdsm31735375e9.0.2026.08.13.23.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 23:37:16 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
Date: Fri, 14 Aug 2026 08:37:14 +0200
Message-ID: <20260814063714.2480456-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814053426.2473247-1-mehmet.fide@gmail.com>
References: <20260814053426.2473247-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

Hello Ping-Ke,

One more data point that may be useful for the firmware side,
separate from this patch.

While comparing against the vendor driver I noticed a difference in
how MORE_DATA is terminated. rtw88 sets the bit on every high queue
frame (rtw_tx_fill_tx_desc(): more_data = qsel == TX_DESC_QSEL_HIGH),
including the last one. The vendor driver releases the high queue as
an explicit batch and sets mdata = 1 on all frames of the batch
except the final one, which carries 0 (chk_bmc_sleepq_hdl() in
core/rtw_mlme_ext.c of the 88x2bu source).

On both RTL8822BU and RTL8821CU I measured the high queue draining at
roughly 3 frames per DTIM with BIT_TCR_UPDATE_HGQMD set, instead of
the whole buffered burst, so the burst fetch of 076f786a0ae1 does not
seem to engage on these chips. A never-terminated MORE_DATA chain is
my best guess for why, but that is a guess; whether the hardware
needs the 0 to conclude a burst is something only the firmware
documentation can answer.

Thanks,
Mehmet
