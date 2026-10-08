Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5763A37F728
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 22:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791500350; cv=none; b=fNkZW8knN9P/wlXCe0W8DgYKJb/NetQtHPWYeYooYjY+b6Ssy4bwgnFv62sCyhYo28lyFcxGpRy2eHJb7ALnkv+xpZZvDYzvTJ8Ob80yxp9JXZZK7wFkG7b5Ek4BttNb9GZnxocLUIIV+45ujC8pGdoal+0kuy10dflvp/pfQ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791500350; c=relaxed/simple;
	bh=5bo8Z0Uwl8dSFhwhPNfB8/6B1IICwxC6+kKdrBBiByo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ot1tMVRRtrjtFBItGiPcZOoeA5YVCwAkLJCC9HQ76NOvHMLZJt+A5QXk/vZtFtqyi1mnqEBFQvViN6zUh5Z2KSrpd/YtjQEySzgcsPRRslJtOoI5M2KoUx1LOyqN+UDf4CIgO+6Eb2GLS2wSOONVECgBs/AgEdVRh+khDq3qtSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ua2bQwrz; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ua2bQwrz"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2533d83e3bso568675866b.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 15:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791500347; x=1792105147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xRoGZQlYlVAuxRfgdxXpGqhgqrrcnM9oFsa9ZYtBb+A=;
        b=Ua2bQwrzDQF0AEelRtTzdDEB4ko79VttTtyNr5QLzIaBzYgmW1gJjFopaM4mgjsVH5
         aeWb6rrApAb/Il9mrXXSgUfbz5h98I3Zosbn/qMq6MNO/MAMANd8mu5R80irMrYUVWXl
         ko/PDdaF/00qlJ/jJd8tAzjI0NZed0W3A4AY9Y6swumW8UwimX7THG9mltb0TOQWlnsb
         LITAHSi7cCtavB2Tr/XU0zlWgXge38REru1z70IUCEPvrbQHX/kyOi9yjFtIDUMMVA27
         Sxa1msWqNGRtAi3y9d3GTLQG72erZBNec0ytvDwMB0Zi6pRqiOqU8C3/aj244jEVsbar
         T4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791500347; x=1792105147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xRoGZQlYlVAuxRfgdxXpGqhgqrrcnM9oFsa9ZYtBb+A=;
        b=w0vcf4Q4jj78RTZu50Km6XFX7B1Km9h930c570EXtyasjPx/XxpkoaT9Qxk6DxMCNS
         7oNkTMOoncZXA6/iQF9WQ6UWRZndF/jjyY27ItaQQZBzHDQJ+PT38HFd20FiEWtTqQVc
         0L2NLm4O3HTu1VarL1/OKvPxp1sISXHzSVPRZTbXSojKgqCqZ82ItXgRw5mgEec0KfRD
         Xwft1tIi/7txHLyaOY8bagASvQDISzHXmgAh9o+Z1R89ot9V1Y5CTddebOpwEJnZrpFq
         WmvTPvv1K0g+P87rR5LRMw//67oU4zvoKjP9H7CjAuGjSwDMQEsOe5KI7+FAEpZIyTNz
         loRg==
X-Forwarded-Encrypted: i=1; AKwUvBzExGct0nrcfoVcQGLF5vSDMKFKOpp4t5twkMDoqqV6OWhLjdPGdjWPG4H72k3iVdLvVXB2tShSUGGqlMKEyA==@vger.kernel.org
X-Gm-Message-State: AFuF++lYgEdjZF0g4hgFePzs5vZ7KdY6A44qykcKh+MjKDbWKHXQ687+
	ICCUH0fbPmgdhn7XHErjtVe54815+ed9toHfLEneCj9feeikXzTZ1e95Xfw6xkdP
X-Gm-Gg: AYBFou2pmcSqbAcVtmdFnrNhwACeDaD8PjDNxSjZ59IfSLIUvXf3IWxUZh7EkXURJ7K
	5c7S6vceB3AW8CB9RwnwmNHkn7hICsfWfKOcHeWy1oZBLve8ADPtWYi1K/MYSiQZ5/AeWzC31Ea
	rJwHGKH4VQ5lr8DFnjhyOulHmThfdr02Pm1ekgcskwHcMJ4XELnhZS9Gqhtr9AuQGY0gpHcKcOK
	t/xDRCbi1DxJib3AlPmraAKYxWaMEOilOZg71NIPm3KNuCZjPWTctiLI3vfRFWw0uHvNADBl6pF
	6t1gQrXUjytUYGlvM+iUy02HQfqKhoO2AZNPurgAOr2eaXHHNOih8tf8PRyDkFu8HhonvzgbySE
	dCFTlBVh6IES7LKuNQQMGITKtVonfYZeotvtUomBj7o6qc1GPqVdirilnsAjdcaJHT7cIBFrKQR
	zDvtZ8cuuBgWO/C/Hb2Q8aenu0okAJrw7GbpqqinN2swEmgTCTKyZxJPhLRvKfvkJ8Hut7KWu+E
	YfaqA==
X-Received: by 2002:a17:907:948f:b0:c31:9a1c:de76 with SMTP id a640c23a62f3a-c31a9fd424emr16644266b.14.1791500347484;
        Thu, 08 Oct 2026 15:59:07 -0700 (PDT)
Received: from nb-xps.ts.zxczxc.org ([78.56.243.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ae59f9sm6993566b.80.2026.10.08.15.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 15:59:07 -0700 (PDT)
From: Nikolay Bryskin <nbryskin@gmail.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net,
	Nikolay Bryskin <nbryskin@gmail.com>
Subject: [PATCH ath-next 0/2] wifi: ath11k: fix two races between ieee80211_register_hw() and the rest of mac registration
Date: Fri,  9 Oct 2026 01:58:51 +0300
Message-ID: <20261008225853.15399-1-nbryskin@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k does part of its per-radio setup only after
ieee80211_register_hw(), when userspace can already see and use the
wiphy. This series fixes two consequences of that:

1. txmgmt_empty_waitq is initialized after registration. A mgmt TX
   completion arriving before that (e.g. iwd authenticating as soon as
   the wiphy shows up) calls wake_up() on an uninitialized wait queue
   head and panics in softirq context.

2. The regdomain received from the firmware is applied after
   registration, and asynchronously, although the wiphy is
   REGULATORY_WIPHY_SELF_MANAGED. A GET_REG from userspace in that window
   hits the WARN_ON() in nl80211_get_reg_do(), and a connection made
   before the regdomain lands ends up with badly degraded TX once it does.
   This is the driver-side fix Johannes asked for when a patch dropping
   that WARN_ON() was proposed [1].

Both were found on a Dell XPS 13 9310 (QCA6390 hw2.0, WLAN.HST.1.0.1-05266)
with iwd. Patch 2's warning occurred naturally at boot; both failures
were reproduced reliably by inserting an msleep(2000) right after
ieee80211_register_hw(), and tested with and without each fix:

  delay  regd fix  waitq fix  result
  yes    no        no         WARN_ON, then NULL deref panic in __wake_up()
  yes    no        yes        WARN_ON, no panic, TX failing (83% tx failed)
  yes    yes       yes        no warning, no panic, link stable for 6+ min
  no     yes       yes        in daily use, no issues

The patches were developed and tested on v7.2.8 and rebased onto
ath-next without changes (git range-diff shows them identical); on
ath-next they are compile-tested only (W=1, no new warnings).

The same register-then-apply-regd ordering exists in ath12k
(ath12k_mac_hw_register()); I have no ath12k hardware to test a fix
there.

[1] https://lore.kernel.org/all/16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net/

Nikolay Bryskin (2):
  wifi: ath11k: initialize txmgmt_empty_waitq before registering the hw
  wifi: ath11k: apply the initial regdomain before registering the wiphy

 drivers/net/wireless/ath/ath11k/mac.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)


base-commit: 129324b60343dec19d45dcf87736f129b18b95bb
-- 
2.56.0

