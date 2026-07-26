Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6A83E0C6F
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785104388; cv=none; b=Q2wFEGvybY4bTNVesMoxdIkXpaK3plUY9pvlzywFQJDnUTnAnrYqwWg0vpYqMl3067vJODROu0Fb6MsqrCQqM/03/xn2y8tY82a38P1nX0SbSmH37e9kzZ9KuBth26qS1o4MaUnk1hvtx2NRQ0z4/LvS9ytTAzlz1gi6qQxXiFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785104388; c=relaxed/simple;
	bh=5z6xCM330x0gV6OWXp701jrk3HyaNz82AbVh+/w8o0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZ26vRChCpKLalRpeLBIlL1eAyKTOmw807AbSxzdcOuqjI92PPvUg4FI10EJpLwxSAbJLTjOkz2pQ9PCBTbYzMCwx1eUWt1mLsw4rKq3JV4eZf0SZvSuhRdffXzfpyk2HFbpwgQft9gcHOFo7ZZ7v5bnxvn9RrIgKaqu2vRqsv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=CCkQlXDn; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="CCkQlXDn"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1600d040e4so292313466b.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1785104385; x=1785709185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K9fcVVwyHbUhNRIUxOg0dRn9BUzSneLTHuKU2xQuQd4=;
        b=CCkQlXDn6Tc0Xe+D2FJ5oFrnaPtcOafp+06e+VkbKYeGEeK8q5PpVtXVlDsHK+LHFh
         AZSX+OL23TpmUfue52ZyX7pF2MG+ahxO8lzX3TsdKcHnwDDUqBRPUYaxwmAJQBo6rtpp
         DvEjRX5CUFEid799DgJAD15PkfX1NvdD52fZ57Ewuvu4tgLh7GNGZAQBLL1/vT3f2Vfi
         z+kiNs93pXR+BKRNOvoMoQhRG4fj4jjqZT35zngEOwDfkruQIhCpn8aTFd/e6WJXCvyA
         GXHiFhoA2F1YP057LqMQ0I4YFiBQ25u1lZNC/jiJ3Kcm9WVy2HDzAIHZN7PFXhvVZplA
         ODPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104385; x=1785709185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K9fcVVwyHbUhNRIUxOg0dRn9BUzSneLTHuKU2xQuQd4=;
        b=EDqAKM4Iuso/uAGkVCNew/LjPjXXjCKiYM+TFyCdOiwEgiidMV3ccoC2REgbUdFK+l
         DC6et/3mYlPTx2q5Z9X79pawGeIkU2bvq68H33qD3GNp+T0OfYVjhm6rVci844OtzGNE
         jv3haTyov9kbdIvv0+vQunpcQhmxgwnDK5lUESpTtI745hTcUioIUaaVeqneytbjXpIM
         k7Dwcv0bUJzFOLJ5RDzOem9QSx7aNRX269CGjsTc1Wh9D+I2myhUBdFPjY/isetkQ2G4
         fdFV9KJmCGhD1PviKkWgxuLlkCz3X3y5dT61kLwc4X2gkFEnoR8j+/2eBEwtbhx+DcHw
         73cQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPyofFZ2fORjAvysmZTEVa5taSR9Jm3QsCHHpedzO63ovGwuBpWp49tYg881gmC5Iy+AnXX0IXzZ+8NsDb/A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4cBs6vm+TAf3ftTkgniINQkJMrvMFxzeJ2PwFJHEwc6INhlsu
	/XJLNz+iYw6paloLmz2U1c1gXlSyW5I8P5EYzzNv3r0JkelNS9QBZXIngtlawMirBQ==
X-Gm-Gg: AR+sD12zePqjz4YJySEbemeL2ytHeXnw5C2LlvvrutCw5oUujWJUIn3LWfFpn+RSmJf
	RhIqTvuybNbED7a90sQ2SSTwqEY8wrMtN65qIENf+moO7EkU2SPvVecfH6YmliORJ4Gt5ulP5b2
	VZNGGMRfgrbTfQD1yYa9F20pvp6GNZ+X8+MzWlTYszvIjl/M6dIj0KQNzHdoLgK/jW5n/afhmOw
	+Akcgg9ykI8PRN8Q+uvZSwMBSgCaf8VXv+0P8xj93UTZXPQzXrGmj0hnFUETR9R2jitGXtM2yh1
	mEj926wRA4Q0ypWyk9DIoNMy9f0hRN+9sgL/aGgUtBS2552ijTQvxo9c6aOezNX2TXoODeTW2No
	VZ6OBaAlobV8zhiQb70xznPmoLHInwRt6VTM4WzdPGr2KfmoN19mRt3YjvfO9J6zgiG1ckH7/wU
	CYjMfkcC+1EwPvdLSfhdtf1cnpwabPNiBy+fUvdG6Ce3YAjfi0ZBQdhsDJkCQiAeGPMOuS7QDb4
	18CRT4bmlQL5GFfT3Rskug+YU+MCtB+6br7Ez67v2p//TP2TqcUpDwLLgmw8IWTF+sz5NG2Gke7
	yzT3gAsKfXGsbjl8YXtf50ilcGZiNLz5l16H5QF0jGxb5CyG/GMxR/kyaPqknnto/syA9uMY8Hp
	VUxMORfp0iOdOAwH5L/gvb8i0XgCRDKk=
X-Received: by 2002:a17:907:9286:b0:c1c:1fbf:5d18 with SMTP id a640c23a62f3a-c1f13388df1mr379927666b.3.1785104384611;
        Sun, 26 Jul 2026 15:19:44 -0700 (PDT)
Received: from Desktop (p54affe4b.dip0.t-ipconnect.de. [84.175.254.75])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a76fecsm561599466b.8.2026.07.26.15.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 15:19:43 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Subject: [PATCH ath-next v2 2/2] wifi: ath11k: disable interrupts during firmware crash recovery
Date: Mon, 27 Jul 2026 00:19:08 +0200
Message-ID: <20260726221908.104873-3-julius@bairaktaris.de>
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
 drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 8039124e7832..d2ed6a0ea7e3 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2334,6 +2334,16 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 
 	mutex_lock(&ab->core_lock);
 	ath11k_thermal_unregister(ab);
+
+	/*
+	 * ath11k_core_reset() already disabled the interrupts on the reset
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

