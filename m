Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927DA1D5CC6
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2026 03:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781579231; cv=none; b=hY7U4gwybRtjoQLVKC9ZI7yazOXtpZjEZZoVYR73p+iAPHuc+5gLsRs+hBQI7NmhCpdXcyuBZpxXdQpWivZfgAOtdO6tJw/X9SMka+HKl83vIoBBYGYeap3mS7qmDTWYr2XeyrdK6DfmpUYjOih1QT1PkD2ikTAMryTWWjK3nX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781579231; c=relaxed/simple;
	bh=JjlZNlN4v6u98YqT43DyTY3AlLizsEYbds5xBEPISKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JJTpya5iw9KKHQAHrldNuA2brYap/s98GZAQ8xMl6Cic68I1mx2zeEHSflWEoCCnr155sqhzWYlR3OHO2XMtX+pHKrzL4by+iy/AUsFiIeTOc6Z1XkrVB7SSbc3Zkv9GKWVnSisBn28cRNoSuY+95z4q48a42UbhFqBs6s3cIV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBEFbWAW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBEFbWAW"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-842848fd613so3551681b3a.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 20:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781579230; x=1782184030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XO1cyg1Sa01Yg0GQu95unCsZpotTFXxazwrX/N+VVCg=;
        b=nBEFbWAWoEnDEepA9J+947lLe7b7DKfRZuoo8r4VQAWKoHUCSfBnGBASa503EF1ki1
         H2vVV8RVtegEYaVpKU/EU082AIbbai1V9uNlLT5LcTc8ei0WceH3QgmtVkqv25lw8rAW
         pfUjDiGmE8yn58yNkeyScNqmXlfpbPM5jDEOrpli4AZhwCbu+/L5p2oICctblaiBfoaY
         JwG3kDCCvmD47q206NU5QLK2moy5gyEcDlwJFR+N/lCJlPm9B93Z3lw3YV8EU4AQtes6
         FH4tWaEWq1UChapUk2BOeYqBpXGMXtV3XgaJj0PgSsXGl3XobGoioJFDCM36ilJXLKt9
         YWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781579230; x=1782184030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XO1cyg1Sa01Yg0GQu95unCsZpotTFXxazwrX/N+VVCg=;
        b=btAZaIDY5fyYQkJwQj7n8X4dBrc35h+ndbTrY+jQ8UH3YnNIdYWROy3KJMbQNM7bUO
         b9+qa1gLJOQ4NduD/Qhv7IuzQxe/8rXmrsexz+MH/c7OYZkmfLihln1ueIqQaPe+pezV
         sr6k5uqadQ+BwyZXjI3KeBgUedEyGo2kzjUVZ2BCLJwx2GtiTsJz3SdwKKARUzFF+O6L
         dfboquYP4YguLOy2g25RhnzlXZNmkc30Q3g2AOKNXc0iramyCF5RUoQejJaCM22ybwmH
         9MKPxK9m8y6bAvGyAsr1puRH8gfNAmgIptZwCyUMrhCusDMdcDV433v6omzjZQuVCof7
         fjwg==
X-Gm-Message-State: AOJu0YzW47Nw3pbXFdo6Gt3bJbjX3d7FBwz3ERJJsYqE1bZ5ipcDQrkM
	ynuy/zlaSkTVSSCYzak81qZYW3hr1KncccnETaDI0thbsanw5+ElOLQhcwFZsg==
X-Gm-Gg: Acq92OGKdFFG+2ai1TsMEZvWulzWuSwZDxdGRDgyEUYyXeJb8QMZusn1GAfp+76Y4Vq
	apVIGtUUeHGz6jPeW5v1nEgYV8EVqJPRpuuVLa62/b49jPbxq3N9IQRwNGDLlWhAVLeQrhtq55Q
	ADUghwoTipmTJ44zpUG+N2KpnHw31tJ7MuQbEqhyT1s3NfZsdne7DrzkkUTTuieYSCvUplfTFgm
	MW04DxQ7qFBu9VVZ4nfckIDn9wNDqDyz6kxQRQpdYGxcvaBaxMbmbFTC3SWdegUDnByqJR7/SOP
	/ey9qaYHDdI5jmfFaOVAttW8EMI9MBKsapPvPsjRKHHN1qhuRxAGnNttw56b3lRKYW1S3FEEcet
	eBYERKnhwTNDKlInex6/NAq12UTszU/HhJ1s9WFtU+7ottY07HbXpZg88CEBTdPU14LhGV16On2
	iBZwSNBjg6P6P8h83wdTh8BbY6NqTcZ2UKP5t5Lk9KFsoO9MW+aLPIB0/hYDLc4hb/vLbWfokSk
	fHnplHt34sfh1NCArTmMekfox9FUxbNTbLFsfna8cWUgQ==
X-Received: by 2002:a05:6a00:4b07:b0:842:2cda:7aa2 with SMTP id d2e1a72fcca58-84515587c4fmr1470814b3a.30.1781579229859;
        Mon, 15 Jun 2026 20:07:09 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:33c4:7c66:bf93:6ee2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad0118asm10662907b3a.27.2026.06.15.20.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 20:07:09 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ath9k: mark PN9Data as const
Date: Mon, 15 Jun 2026 20:06:52 -0700
Message-ID: <20260616030652.635121-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PN9Data is a read-only lookup table and is never modified.  Adding const
lets the compiler place it in .rodata and prevents accidental writes.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 16 ++++++++--------
 drivers/net/wireless/ath/ath9k/xmit.c |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index f2144fd39093..b52d84f6cbc9 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -39,14 +39,14 @@ static void ath9k_tx99_stop(struct ath_softc *sc)

 static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 {
-	static u8 PN9Data[] = {0xff, 0x87, 0xb8, 0x59, 0xb7, 0xa1, 0xcc, 0x24,
-			       0x57, 0x5e, 0x4b, 0x9c, 0x0e, 0xe9, 0xea, 0x50,
-			       0x2a, 0xbe, 0xb4, 0x1b, 0xb6, 0xb0, 0x5d, 0xf1,
-			       0xe6, 0x9a, 0xe3, 0x45, 0xfd, 0x2c, 0x53, 0x18,
-			       0x0c, 0xca, 0xc9, 0xfb, 0x49, 0x37, 0xe5, 0xa8,
-			       0x51, 0x3b, 0x2f, 0x61, 0xaa, 0x72, 0x18, 0x84,
-			       0x02, 0x23, 0x23, 0xab, 0x63, 0x89, 0x51, 0xb3,
-			       0xe7, 0x8b, 0x72, 0x90, 0x4c, 0xe8, 0xfb, 0xc0};
+	static const u8 PN9Data[] = {0xff, 0x87, 0xb8, 0x59, 0xb7, 0xa1, 0xcc, 0x24,
+			             0x57, 0x5e, 0x4b, 0x9c, 0x0e, 0xe9, 0xea, 0x50,
+			             0x2a, 0xbe, 0xb4, 0x1b, 0xb6, 0xb0, 0x5d, 0xf1,
+			             0xe6, 0x9a, 0xe3, 0x45, 0xfd, 0x2c, 0x53, 0x18,
+			             0x0c, 0xca, 0xc9, 0xfb, 0x49, 0x37, 0xe5, 0xa8,
+			             0x51, 0x3b, 0x2f, 0x61, 0xaa, 0x72, 0x18, 0x84,
+			             0x02, 0x23, 0x23, 0xab, 0x63, 0x89, 0x51, 0xb3,
+			             0xe7, 0x8b, 0x72, 0x90, 0x4c, 0xe8, 0xfb, 0xc0};
 	u32 len = 1200;
 	struct ieee80211_tx_rate *rate;
 	struct ieee80211_hw *hw = sc->hw;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 89d8b3178784..57e451548958 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -41,7 +41,7 @@
 #define ATH9K_PWRTBL_11NG_HT_SHIFT      12


-static u16 bits_per_symbol[][2] = {
+static const u16 bits_per_symbol[][2] = {
 	/* 20MHz 40MHz */
 	{    26,   54 },     /*  0: BPSK */
 	{    52,  108 },     /*  1: QPSK 1/2 */
--
2.54.0

