Received: from mail-dl2-f9.google.com (mail-dl2-f9.google.com [74.125.229.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D1039795E
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791657416; cv=none; b=lyiW+8rLhiky6Om/Twni5eufTaGxOV/t/s3HB6/JPiT5VMjnAo2hMmUscgjxF+zdD4r5fzhnR16n+ENKIQoQxsy5ijA4T1VzO8UFG9JZ7DVvyHh3s3GChhrTJZ+GM9lUHGxfaDejL/t0nlIXscheYPxLl+5U+UpTuH2uk9/9/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791657416; c=relaxed/simple;
	bh=zMHZJK+Lil5rgpQc8tSNIk8/tNDjLLOyL9TYlu0EuFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RckRf7lbpo3QPz477dBH/i0dPAfjocxIofPuNtJMTiMR5yh/hCBMpdUBYEQOhG5MFuHhLBi2xm5ZC5OiZzFyiKw9F1aBFnkZY1YCRrFBR0Z34r18RhCUkzu7NMz4RmFC1DWjin6w0mJW705BnBHDNEDTbUw59Djo4Nh3OpZFxck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FS2mTucy; arc=none smtp.client-ip=74.125.229.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FS2mTucy"
Received: by mail-dl2-f9.google.com with SMTP id a92af1059eb24-1397ad3d891so228384c88.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 11:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791657409; x=1792262209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hW1Or0lp9arcI5QuX436/2y3ET8mHo78jKw5Up39hXs=;
        b=FS2mTucyt+7hDVduTy5Y1l4QeP1clnIx/+zeRV+vETS2JU9NqbzNBFMrk0xCuNYLpZ
         gYZtyJveLv9X5W+TPPtOeYX1tLLWcZ/JmT+ye0KkbbNTzPmlOHSjHf7qPGhqU+NSzeWk
         p2jqcjPveUNo4yAW5gA+D0EKuntQt6dh2ry3747Cbshmb3c7tgy6+sj8yCFwfJpBHeYY
         wQBVAxZ7jzTy1Vdzg8RmnaowPpMd3wCPfM2dYBgPl2kfot/w5TXjJHZWSyDdY182ynwF
         T9M8JHC0zh2+idHdyz9HIW3S6IeNdYAjC1I7t1RmYG8T4kmjosYzlM3DUlWbVlSO7uC1
         0S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791657409; x=1792262209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hW1Or0lp9arcI5QuX436/2y3ET8mHo78jKw5Up39hXs=;
        b=M0VFn5ZGroqNJmbIjt1py/YoITXN95d52Qf++2PEqs2a0OeV/b/HbdGuqCbrokv6pZ
         eeRxR7bLLhxHnG247KVbmsDhOMhma8WDs7wwaN2XulQcYX2xRzDzGazp7M4tPGl7yVkK
         fMZvInvDiNaWAcc2r22JrKihDsJW669LL3VYY/kUGRcfz9pUkdtO9TEtAsf9jYC/2tVx
         SXr+nFv8QxTI12D2ZxVYUd8bKBVKr9xVRJM+fcjBHT1l9em+K+kWxUM7UVMSTwHpDKO1
         07jci4SQL211212x8XnNeTaWYwHCsRKH+7PoWVhOXysnEwRl40ZH3WSro0gScggtZ6MF
         pbaA==
X-Gm-Message-State: AFq9FYK3l/dy3b59AQTig+kfoGv9O4NjjFXKGwLL2vVfG0g8IIjOqGYq
	KEDQSw9Phs+IKEvr9VLIqQUYHQNPsD3zcTTxnZqo/Ch+wPbCfYU6sMVo
X-Gm-Gg: AYBFou2axFEWTpJ+jbmlQ+vzZWG867ait9pMVz3cwchgzEGQOiJJBIB6fZNaIjtYDgi
	nUZBRTFXxpsW+gTfpJWZp4vUT3O4UFTQO68oW+8xSoAZHR15/vtWA7d4bh2dynG/d8Wv3IU014i
	iqm3OrtDJrgHjWv/vwFrDmgvDIAcPrhSwniGmVFb58jNXXU07PUUd+/FB5GhYlbFuerb6u0jQdr
	suk1MBQeqo3ChiHo9kiEF+T/gWP7X/iwXSpiDJ+sfwwoseQTwUJu+KjpRvK/1cbc68loA1XSw9h
	CTd0Q/9YJfN6Km8ncnZ3lRJTb2hYSk7HZ5HCRyq1iz8jZJy8Q63Qy2+VleAl2+sN4L/J+PoRkTa
	zikZURPZNtvTnRvUA3vpk7hSQcNhVU3wO1h25tGaEUWVylonVw0E2NRXLqpLlMFECjxnRooVbqZ
	m2Zjs/3s3BIDmjEb5PqDlZJYObNp+YbAb4HaI6WUaozDI9C+PuyUTX+ygoEkD9r2uWgaq3M9xdK
	NUfcIE8aZbMz8p3WCDLtFDs5k4=
X-Received: by 2002:a05:7022:1584:b0:143:4d12:396d with SMTP id a92af1059eb24-16a61a6def5mr10483700c88.26.1791657408704;
        Sat, 10 Oct 2026 11:36:48 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a42407e7sm16217110c88.15.2026.10.10.11.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 11:36:47 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luka.gejak@linux.dev,
	fiona.klute@gmx.de,
	kvalo@kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] wifi: rtw88: 8703b: avoid converting RX SNR twice
Date: Sat, 10 Oct 2026 18:36:29 +0000
Message-ID: <20261010183629.39748-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

query_phy_status_ofdm() divides the SNR report by two when filling
pkt_stat->rx_snr, then shifts it again when updating dm_info->rx_snr.
This halves the SNR used for diagnostics and average statistics.

Store the raw report in pkt_stat->rx_snr and convert it only when
updating dm_info->rx_snr, as the other chip drivers do.

Fixes: 61a486bcd782 ("wifi: rtw88: Add rtw8703b.c")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8703b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8703b.c b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
index 25456f0367b2..1920277d626f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -959,7 +959,7 @@ static void query_phy_status_ofdm(struct rtw_dev *rtwdev, u8 *phy_raw,
 	val_s8 = phy_status->path_agc[RF_PATH_A].gain & 0x3F;
 	pkt_stat->rx_power[RF_PATH_A] = (val_s8 * 2) - 110;
 	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
-	pkt_stat->rx_snr[RF_PATH_A] = (s8)(phy_status->path_rxsnr[RF_PATH_A] / 2);
+	pkt_stat->rx_snr[RF_PATH_A] = phy_status->path_rxsnr[RF_PATH_A];
 
 	/* signal power reported by HW */
 	val_s8 = phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
