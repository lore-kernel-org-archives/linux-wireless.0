Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC0B511E97
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788547994; cv=none; b=SdFF2wZv73DDujeEah7AioJru8tWJlUVIBLzjVejgA4IRF2p/XNuXLDldDwttXuDK9QOgZr1CV5S0HJUR6zRtr2wqiJlwbhj9YqIu+S21d+Ua2n5IYdTh3TuaPMzV83Bon5q06UfEAyzuChQeY78d+LKeb8c0vSj4nBQVJudZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788547994; c=relaxed/simple;
	bh=5x4dulZK0+121XejeF6S/bpx9DVjzeNeXGD4og3vsyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fC1P4GNYAQA0xDNFG3T1nRz3NETQrcYGVOWWSXFmCAyv0/seaC2IN2KSYYfh0NIXThFQVv1T7HIdWpAnfO6GeoUI9EWR31sxVMk5ViBIaNX6C5vQjV+iZou0eYp4hup/QVs023KN8kVwZI6MpQR2ajnpbaQUE3EKKG+Y9vo1fcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZJd98wSa; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZJd98wSa"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so13803225e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 11:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788547990; x=1789152790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LN+PUjIhc1QRgwWnqFTrNClD/WVs9AN63AUQ/okw4kc=;
        b=ZJd98wSaGXr9l8ELnHJl2uBnBZL0JeQUFeKdxfiCs+ZIHJvC8bCUEYjwMkkFisOG5Y
         qIOqncdGdBa9hJ3BWPwZose6mKBoERQDyllJsSHPCFhE+G27IsKmTh+oUO/vIU73paKm
         9XtZTB+8pU6aTAK7NDCGKP0d1svcVWJHAe3GcZOAOwjj1RR3KyNuC3dWTC746V5em3Pd
         1HCBBFBrsbjz1dqJFpUkSry1nI+oxF/PSBT+BQjry+BYylNhFHzS3J714O0qAPKkfakY
         AVlsCpQMzqt8mBwm7itxT7+fgg1bHssnEEjbRWArbfiW6W4D7ikc+TFVDmsgn2OcT+8j
         j9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547990; x=1789152790;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LN+PUjIhc1QRgwWnqFTrNClD/WVs9AN63AUQ/okw4kc=;
        b=XuXkwa1vDly/Wqm36X1rNMnLAYounyN46gKVmg6ucEEQ5Y47Wle4gtwB0yuJFmNUPR
         QQ37vPCxQk4AB1tNsw2bY5R8JkAL8SwA9Mjj4pLLE4ZHUskwZeLaPkV1SPzzHzkM41HY
         4sQM8IgxUxLHyHhZLgcb7nZOXY/mqudA1Q+HIOCR1VYj1bJjAipdHKs71CfChOs8MYNy
         DDPJax3vT3M5MjOJ5xp0jsGnuyMnPCrho9nUKeEX5Ko0ldm1+DqbuHpcCAlxqqh7f5Rt
         yMp2jMRO9Gh2ISdXsqCIX1wT+kUz4+/81rONIptENAGAkqDMDM/DAoxYhhhZw66lbWMO
         vOtg==
X-Forwarded-Encrypted: i=1; AKwUvBx0aLejUK3Q2rcoyrb9opfR4wBlBJKnuH5fNZWeoWeKmS+umY5htO6m3Lp8yafCl8ZvGBi1AWZE5aCCG5aiSw==@vger.kernel.org
X-Gm-Message-State: AFuF++lEBuMcg05t8rYfg7n4TIo/GONXJosNXmExrExw+VhhRfXmstWJ
	HnwSgATfuOJByUbewBhyoYo23En2kBgrMGTdGdMZlXQl3PAMwbIRniQ=
X-Gm-Gg: AYBFou32SLBHN3A8dvXFcsuLi0lkAkpjBIt687rR1umrnwubeU4ZRZg+kplsIgSHS1l
	zSN04YsE5+pxUsXUk9Ulzb+puTFOGrBhchBu+1Ehgf/23r5qwjDo2ObzpYP+X8cY57liA7QdVhd
	A20ZZYbkk8udXbDnx0LACyMM+qfUOAVrKo8jnnnpu2YT/YbjJIeECSXYIkrTkYuatTm2sGjhNNt
	yXA7Ov9X+iR0c8uojEsRQDsE6NDXAQteLTOr9FU2SloJJ4fLcjRx29vw8wH2T/aVO53POS4KR5Q
	EXKaiIvNg5O+PAWD3TKwzkeHzMlvT9+YL/Y6Ui49OQZ3M5Rikn7I7N3PHQkb6zwfrQR6lozioYK
	K1GrYB1rAhh8lz5F26m/4DI4Doq+ddFDK5UKDpW9+6y1CYCPQNoRF7qXZNxDSusf3rTolni/6FB
	fS4JPWCR7kLWGYnIwM7AWPXZVnRiW7rcGgV2M78OX147gpXBnyLxDQEVsID+gSpygPQAiPapSYU
	DworfP/YLkrJHFzkTHg5luFkP9veFpdzC3c9wIOzspcU3DlAEfurvCSRwQ8ce65QdjvtQBDXYW7
	eEr8
X-Received: by 2002:a05:600c:5397:b0:49c:e37e:4389 with SMTP id 5b1f17b1804b1-49cf82cba17mr68895295e9.4.1788547990271;
        Fri, 04 Sep 2026 11:53:10 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfbe5b252sm58607715e9.3.2026.09.04.11.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:53:09 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] wifi: ath9k_htc: report a failed multi-read as all ones
Date: Fri,  4 Sep 2026 21:52:49 +0300
Message-ID: <20260904185253.809209-2-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
References: <20260904185253.809209-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the WMI command fails or times out, ath9k_multi_regread() logs
the failure and still copies its result buffer to the caller, so the
caller receives uninitialised stack data for every register it asked
for. ath9k_hw_update_mibstats(), ath9k_hw_usb_gen_fill_eeprom() and
ath9k_hw_read_array() all read through this path. ath9k_regread()
reports the same failure as -1.

Fill the caller's buffer with all ones instead, so a failed multi-read
looks like a failed single read. ath9k_hw_first_txpending(), added
later in this series, relies on this: a timed-out tx queue status read
must count as frames pending.

Fixes: 09a525d33870 ("ath9k_htc: Add multiple register read API")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6de78ae85726..f5844e9bdd2d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -273,6 +273,9 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 	if (unlikely(ret)) {
 		ath_dbg(common, WMI,
 			"Multiple REGISTER READ FAILED (count: %d)\n", count);
+		/* Callers expect what a failed single read returns. */
+		memset(val, 0xff, sizeof(*val) * count);
+		return;
 	}
 
 	for (i = 0; i < count; i++) {
-- 
2.55.0

