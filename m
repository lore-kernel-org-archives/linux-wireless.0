Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC073112BD
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784989115; cv=none; b=CRf2tfmaOIpR+LVXmBGVGitcLOblEaxJROXUcao5ilPzseFnLc9jsypT4U2kidEDySCVnsukzSNGdmfqk7zSA0ehYGRMrZyMlGaYrJlAFoATDVeDhqjFdPpul4vGrY/P4DfJj5Gw7stacQuGHhZw/daJrf9OsYl4Uy1xRFq9h0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784989115; c=relaxed/simple;
	bh=0pKzBqEZfX/3FaX6SDS0BxpO0dmNYx8HIndVPLnDDR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLqyqbMK1QjCIUjXMA++paklmJxWpv+KXT9RenetAWyVX3uukjLKRT93qtkmNtAVsY3s++uX5lWHTgPq9vzCACt3TF39JVd9+mKRdIOlmaXPLhpQGYPfRPQe+QKUV/FinST5p8y2SqFWj81LcJPOuKbsMWZV9JnpLwSwGSYqWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=cZWBgBlD; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="cZWBgBlD"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so1919281a12.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 07:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1784989112; x=1785593912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I6HhSphr40arB6iMxyFae2bf796pOpLnQzTJ7BzfcsQ=;
        b=cZWBgBlDLa2VpLixujtQr5Cgc06rIb8gwp+tmypM3uRa3Qd7gyCExm2nJWU6yOVNcV
         RkUuckSF2m+gG1xRR828aRQA40YZlkZdVUH3Fkb2Plz/D8Vy4aVbl46NMdYNYGb0UsMS
         aMfhNw+n+IEaziL9oCtOpvUGhz3HHHmEaa0zCWhJbAIhwr7lkM4bCfXWkE+pUwUGyRdW
         5/juRIvzp3JZTLgMsWuAue6tYD3PJoYWvUIHkC2CA66xKflMaGeR0bOgueeBtoB8XxO4
         jYpRWtyeJa9cBenKKFZE3GLVOSNeVqL+AqHhdjkBcKwS0vywIeFcOdnMKbGYUsH6eTQG
         +l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784989112; x=1785593912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I6HhSphr40arB6iMxyFae2bf796pOpLnQzTJ7BzfcsQ=;
        b=rypmCGCs9ti/ZbgMxFWkq2Ga62pdyUkcgkyXhDtJD7Xc9zhqNihqH1bUC7X1syW8EX
         tDAJ6aJ9WrtdAD1gSAH2u1zXgBT2BiEJrt9iR2kMjvDAGIm0Ck1DJDEN2/oHuvLpv6wt
         KwAWru8zlLhz9sKtOuiywgZE0JroFKf5sLCht4U1PD7zPNINMO9IDxn39A+oRZXeDLfI
         KHnhWtvV0Mntp8cgNrf0Vh5Dh/x00oJGNsqcV3kuHnS9mIflYiM/2Afw9091kfx2SU6J
         8WUHI0jgNVIJHZquGFb9v9omrBhKPzDbl89GtFaQ1rQAf4l0r91BIlwdZPUJ4+kH05gT
         j3IQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsROcEQxIKuGxOipZNBDheQRuzBhGTWf77kbmr2jh9144hGUCcgbBlvPK/cDpeP/j9rI3mSycjasiX4R6wFw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwyB5o7USCgGTBSrg/N0F4NhH3jWMXRjfVCJFct9tNlVNN3dncy
	rnrOJffCYvGZkIL8l0anZoraV1qqflD5xaytYkLTgy9WF4aXoHrVnkyDSdFGrnBRAA==
X-Gm-Gg: AR+sD11GZ19LXTXsfSYwVcflN2ZmBENJbaDdZ957mrgdhpvnSJUjEQGHibspy+Xvkcg
	5o/hK4CF4M/AZCDZQYjUetvDQTbFG5IP8ii48VAPJejZBMID8irvY3WC80y0E84zfJCNcdzOz/3
	AIQmOYwRbFSqx2Y6kHynH5k9VT2wy6eBIs9gDviEYqRzYf90aWG+N/FED2siGnPDyoBAmbz8k+M
	H73IxkOC78GSOHqwtxqeeAPs8t2tqMPDN3s2ic8Xd/rNVf+B3KuU2RWroaWgu0M/zgGEh2rZtqN
	EK6Ivc7ZIk005U5B7MqBFork/5a/aYbfM0ZZA6qB15iI5S7XP0n4cOIVByKQT+CXm3SUvecDXwq
	Gg0wykN5pZMpdSqOkeDrzHM6RJw7RS61doGgQM0EiIZX7lKgT42+Wo6FCKoFWVq3c3VFLVuNvxf
	J2FwgTBaIAglV1yoDUfHBAYrSN8PGChViLDYbPPoL9/iYE2op6qCH/sruLwOQL/TZpDOwKsIUAr
	Yc+WJ3Pn7o1CgXtP2MGuc8VpitQNojXnoE1fCSP2DjxtSha8MCMD9w/kP/PsTwJOtVJPWoEPwCF
	F1fMSrGGL/Ib65r2ZIOR2LVOgmoyYU0lVIQnzBMzjURurHomzHQ5QtCEfgRL/BsaJFpvuXzexCd
	1x1EVnxW3/5oNaInVzbHBjXu70iHHEF0=
X-Received: by 2002:a05:6402:42cd:b0:699:f3b8:165c with SMTP id 4fb4d7f45d1cf-69fc116ad78mr869524a12.28.1784989111703;
        Sat, 25 Jul 2026 07:18:31 -0700 (PDT)
Received: from Desktop (p54aff063.dip0.t-ipconnect.de. [84.175.240.99])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb594622asm894010a12.26.2026.07.25.07.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 07:18:30 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 2/2] wifi: ath11k: disable interrupts during firmware crash recovery
Date: Sat, 25 Jul 2026 16:17:57 +0200
Message-ID: <20260725141757.1316877-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260725141757.1316877-1-julius@bairaktaris.de>
References: <20260725141757.1316877-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On IPQ8074 a firmware assert reboots the SoC:

  Unable to handle kernel read from unreadable memory at virtual address 0
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  lr : ath11k_dp_rx_process_mon_status+0x15c/0xd84 [ath11k]
  Call trace:
   ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
   ath11k_dp_rx_process_mon_rings+0xa0/0x5d4 [ath11k]
   ath11k_dp_service_srng+0x1f4/0x348 [ath11k]
   ath11k_ahb_ext_grp_napi_poll+0x34/0xd4 [ath11k_ahb]
   __napi_poll+0x38/0x188
   net_rx_action+0x120/0x2c0

ath11k_core_reconfigure_on_crash() tears the data path down with
ath11k_dp_pdev_free(), ath11k_dp_free() and ath11k_hal_srng_clear(),
which memsets the ring list. The DP NAPI is still running while that
happens, so it services a ring whose address pointer has just been
cleared.

That function used to disable the interrupts first, until
commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
moved the disable into ath11k_core_reset(). reset_work is only queued
from mhi.c and from the debugfs hw-restart handler, so AHB parts never
run it on a real firmware crash. Their recovery goes QMI server exit ->
restart_work -> ath11k_core_reconfigure_on_crash() ->
ath11k_core_qmi_firmware_ready(), and nothing disables the interrupts
anywhere along it.

Disable them again on the crash path. The reset path has already done
so by the time it gets here, hence the ab->is_reset check.

This is also why the debugfs hw-restart trigger never showed the
problem: it goes through ath11k_core_reset(), the one path that still
had the disable.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.12-01460-QCAHKSWPL_SILICONZ-1
Fixes: d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 8039124e7832..8c24fc8828d5 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2334,6 +2334,15 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 
 	mutex_lock(&ab->core_lock);
 	ath11k_thermal_unregister(ab);
+
+	/* ath11k_core_reset() already disabled the interrupts on the reset
+	 * path; only the firmware crash path reaches here with them live.
+	 */
+	if (!ab->is_reset) {
+		ath11k_hif_irq_disable(ab);
+		ath11k_hif_ce_irq_disable(ab);
+	}
+
 	ath11k_dp_pdev_free(ab);
 	ath11k_cfr_deinit(ab);
 	ath11k_spectral_deinit(ab);
-- 
2.53.0

