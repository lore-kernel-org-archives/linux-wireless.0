Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197093;
	b=f8pe/dVJHHdD3yk1uOHI0kVXoMsnJbQoypLPsHmL0D7o79b8brJ/DXDaI6F2TaXiQOut
	 nBZYo45rLGoBwGLJtIXZA8Uw29Es2ogX+Q1EjLw5ZDEIsFr99xCby54yhK16+F3fmJ3A2
	 YKMdJkKg0jH0Rm7Z8nXIg39qD6xss8iE6KLU92iFWnzYRnqMq9nF2JiFlF3Yax5nt/353
	 5sGQ6qnY4oVkxMtmOo9tT+EXEqKERjwAUHq3omfoeMJ3IaAiNtMMupqZtuQZrQTjdH6JG
	 K+BYHX6hYMBQAM1DQvQKmBc+8AJscZ8cZ+4/Gm2Zi1MaaoyYHr7FrUN3ColRnlVQIyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ONCYbawM4xmouwx70v8kk5rZch7dwor2A7i2JVNx4cE=;
	b=2UfsslSEHW2uV9h7eAdb3A+p9Ib75nk8DyTmGC+LAoMrMxk70pVJyfpiiY9EYb1ej0+0
	 OY4neM4Zz16zt2bE4PF5w4Vm8egj/nrO6dKjuqQ1Pr0hf2iVUWq1DZn+caNuc1dwpZV8D
	 pse+0exIogS04W4KwJkpmATTh5WY/AyrnCdsDTel41x4trw0cVYZwPPrtuPEObU10z2gu
	 +S3UNoAvUXjd4MDcCut/TV1qUDey1kRiQG2JvWVfDg+DYmKBptMb0nv/+Bflr6LGdZmKV
	 lFdT36+iCMZ4auFkpX0HXiq1TbW2qxO7daqIFNbIyKZpOkD4zNl9c6m2LrXX3BPTzhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z30BiNlA;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D9606A31C
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 110D9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z30BiNlA
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a05e3f0d23so621104b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197092; x=1793801892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ONCYbawM4xmouwx70v8kk5rZch7dwor2A7i2JVNx4cE=;
        b=Z30BiNlAmfN3QCpYBCecmQ9PQ2Wdr9QubgxX1f95degqTcCzd88fZ5UPKlDhv2zdO+
         hSRGWdePi4U+IElKgRifUb9NbjaKcOtNuIe0KeJii/BrT+fCPI0Fr6BF3SRQZEJbM6+Z
         8W+JWsFc4zNU1g+Nfuz/9/LiuBHMeiX9VLwYnhdH9fAAEDXgu0arH2jE77+JDs2YMm4K
         NE8UGF6Js7UY3B1/Zkk0lVcC2xKbtbTMpdkj38AecnfgYgSF4rBSLtuH3FAxrDwTMhay
         4HNTfhUZBAYyLKN3AHV0o9GRVHpOBO0d9odCQ9SiqQZkjJT7/sc9sxajHu4gfkGSdVxe
         tzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197092; x=1793801892;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ONCYbawM4xmouwx70v8kk5rZch7dwor2A7i2JVNx4cE=;
        b=ssdEH5N4f/eeQ5QsmK7ZXosFef1T3bJPYoVcjf6BlsfqTFd1RBNfPzWHwOxLoYjAVu
         xX18U8vI9YVKMwftyQoGaVeTb6cvDnFD76Ya/dlQUWmHey0OSch/7w65HAfiT61h7jT0
         k8zf01CBdu/1rZQJY3pVmwaC44xOwfYNEGQJmVN1L2fxEvn6ukjWFNnoPpVT8zFxDItb
         SbanAWvXEgN2yt+llR563DOgJQtu9+VBIdEY5WV6Dx1D05dDJx2xvoEhttXN1fmdDTMX
         FpTd/10NftgQcy30PatcrxRPmUJS53eq9qf7eb6Vs+pYte0EJcLRHGlf7jd4STJli1Oz
         0GxQ==
X-Forwarded-Encrypted: i=1; AKwUvByrljYuSXMZgZOBUmBBEQ9H1oWliznCehNLaI+qcpW0onv83EnRyahpg7R0ckUIjIMK/UmBCS5Bh98GLD9OUw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKtUNOyT6gEwRBuwAyGSZ2KPnbBMuf3VNLgoShnmqgltYMhz2GL
	Riztze63Ugw5gFe6cGJ2IB+YB0anbymgBvyNBmgsTyUfTcLE/pdYQReg
X-Gm-Gg: AYBFou24xILtoneErrmNRsw0FavRtIOtpBCBvEdRGeq5D5eBFvTeddAIJ9UK+OWBWIl
	l+4Q6x6reCUBuvR205jhkeXZDKtUma8EoxfRiMv2rjE6IBwjnWzF8qKMT09nzizVsRz8sxwbgb0
	mADPhfVaa+6svMWviGfki9f75fFjPFLG1d43TeedRUJlbZCJYlRxYXBgn6pcqPxQ+X6FPdufDnq
	ohbSm5pjoR9uw32YxrgD4oa/9Ric3S42hRE1C1Grzn4uI4feTGXE94I/qWrZRR7mqSBXlbKqt9S
	4thc2CV/+sSXWu8lmDbfPllLGRW+91um/hPO8AfQNhSYpgtBgqSMDmEYd7XEODQEygwqYIfhuaB
	h0jjYq/I0Uj8hqcSi1GFw7ga3dyKdMKAwEkhywk8ONJMxp4iVnZl4JBTSi+DG5CQZTWnpyjEHv5
	uRuj+sYpYKkeeEcd6tb1GzPED2VF2n1dMZ/xBbhKXJlUaRZCAuzlhzW3XBI9wr55UEgIhG0MChY
	p71gQM1uXx/UFn2X78lAQboOf0DKQJUis3ZZDj8uHiO6Kv6ZrW8jI5ZRXbYmj2qeLc7pYkrfLqu
	M1PM9dhmiUQjP4Lnb3VR+dNIttweHXZOh3U8hncTxjHp2o9thwt2AMkpOk0V9e/XC5Y6QReZtN/
	SWMN+Fn+sFSJGZVw=
X-Received: by 2002:a05:6a21:2983:b0:3e8:b7fd:6265 with SMTP id adf61e73a8af0-3e90229776fmr2122487637.23.1793197091768;
        Wed, 28 Oct 2026 07:18:11 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5e302sm1284996b3a.7.2026.10.28.07.18.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:18:11 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Javier Lopez <jlopex@gmail.com>,
	Jukka Rissanen <jukka.rissanen@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: mac80211_hwsim: fix netlink release and radio removal races
Date: Wed, 28 Oct 2026 22:17:49 +0800
Message-ID: <20261028141751.6728-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
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

The first patch ignores release notifications from netlink protocols
other than NETLINK_GENERIC. The second serializes radio-consuming
command handlers with asynchronous radio removal.
LLM assistance was used to review this series.

Zhao Li (2):
  wifi: mac80211_hwsim: ignore non-generic netlink releases
  wifi: mac80211_hwsim: serialize radio removal with frame commands

 .../wireless/virtual/mac80211_hwsim_main.c    | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)


base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

