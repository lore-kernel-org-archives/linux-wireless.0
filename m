Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A6947F774
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519206; cv=none; b=tsjmApScuCltxHI5mcbo6OkqRDSUWiXXCpdJ77LRX2cqeEN/NKFHjqaFEfkADUtmxEWB8uMnwdsgN9mN9x534G/mKeCaZCAqIeygtulOuYlRcvspzDVbDEK4rPCkOgyyFmTnWUYIjNaMWEK0Kh3z4yT1RaW7MVWzo5TkuDIOPww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519206; c=relaxed/simple;
	bh=Uo0nJNWyQeugzeZ71OV+2aOLYFmZFM+SLpYSMzCZIWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L+jWVasY6ajoqde0TGmzLWhiETG7YUdVuI6JPAVo//zz5Gagnartu6OQuZHzivZnPrJnnyYdUSP1t/1Nydz6bLfQrTtXUICH0fVKZ5zQHn1wO/nBCRRyhCoXN69VoGzkrFqrBsJPVwvdvtUFjByQvhj89wvS6seiCjt2ltFYXi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bapG/pt6; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bapG/pt6"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cbedf433a99so927071a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 03:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788519199; x=1789123999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZpIP2MYSsGgQmoU6USafOMMVUmfThh8Xiz9qk2fLfyA=;
        b=bapG/pt6JLaGyer+ME3IOo4ak5/hS3tmHIAYg99AFRmeN5r1gQGQb2c3Wo9G4ksCVU
         1kwA0/G07x/wswDM2/sSwiWiUnSwNGG6z7YK14FQqZ95COFCytCHuVQMJRocsiWwsYdt
         Da2diZ2UfCYg3q0JJX43+GFhMCMF2JT329uYxZrU12dkoC0pOcaTayeafujInulmFJdZ
         XplPNc7RCiccSSZumVS+yu4w8sykXOcVU9KF1jsiOYtUWv1u3rFtSjNj6M+g30vQ5FaE
         6CEQ/TEs9/JWfIg7Ybr6jfTx6GFwHBmOk6IwswyziNVe3hCwAI3Ji3ygg87GQO8czX+d
         0a+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519199; x=1789123999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZpIP2MYSsGgQmoU6USafOMMVUmfThh8Xiz9qk2fLfyA=;
        b=gdxMgXvKihbkwpKeMT4885AbmxDY7oHqD/B/GziFk7IbXGze4wKnWnDysCp3jvnNXZ
         EMV5Sx6/0+r5WQ2yUd8Q1CL8LtHggSWBUbFgwxdyEBK7OT1Q9/kmfxZsmQ7cHPaHwyJK
         MI6HIZKBOzZw5QC9xcOEc3Uhgsfp+6eVwl9R886On7BrpgpkY8XGjID7A3Rs88QuUWTX
         9LU4GmGPg1cGScR+/K3/l0BuHguyPKm6kHDBom3ZP0JIeUBciZC3w0/Q0KAMEjCkJXvO
         Hc+4UhMAcrcV6wX2vNrlnPOkO6lozudDZ4myBk2231Iwn23JVa1dPpCYy3gU11hA6ngh
         wUvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzOB9+iLdVtnQHDC3SAB8hc1GwFpqHGyHa+xHgGl0R5DiTLy/9SH9jtFvIM45NxLMBXsKkyqx95zc6R16YxWQ==@vger.kernel.org
X-Gm-Message-State: AFuF++l/s1BJL7hs/28V2iPGKsKONy93L9vGTGfcWLtgLAHtakC1ojbC
	6ph4+Y59Ql0swlTNdxmIDSuGiPpxFLqo7u2JQnsfaL2A/JbeefC0Dg4W/V0bR14DLZw=
X-Gm-Gg: AYBFou0Ma5Lx8hgtbaQGmxTla12735eBDc3THuG+h/TBeaLrWhCNsJwKFRuJWoO5bZ6
	d9Z/EBSlEmEHBeMkdjCleXuO8kpyo97rnXXQQml9DvXeBy1Ganvonr+Q9xhxA9W4+vLWtC7b6gF
	9PXYttkBeet11CaQhebFen2lo6U5LLkTcR9rcr1W3G16UxYVveNBgP/stSOLYsu3F2x1/t05/9k
	dV1i6uz+1ayouypCH2OjGJ1YI03Lz/e/Sh5xafCW/nU0+LNVs+kLxdw+cO5cvXVhiPh0thbhxar
	YqcIY1Yn7XhuY5QBYtMF2zARU+UOTK9lA38wGkJL0eVE17HOnExZLa3d3sBW8p7tvC7OrVqoVMj
	isafcJ0zvbSH3EL7IBv1wbe4XF9crDrTYU9OIgCWHInr78pCi4VrcmoxbTanc6LyxTipEOhq3Sl
	BB/T06VHXOnn05IdoxH/YzAZudn4zVi5hlsHayf7mnYeBpZKii9Kb4+epIE0gVLKU+3xAP+hy2f
	5RrqguNhjiAEXJAjhaZJnXEsQ==
X-Received: by 2002:a05:6a21:3204:b0:3c3:bbe6:95c7 with SMTP id adf61e73a8af0-3da3a0a910amr8553364637.17.1788519199395;
        Fri, 04 Sep 2026 03:53:19 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm8624311eec.16.2026.09.04.03.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:53:18 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: ath9k: fix typo "upto" in comments
Date: Fri,  4 Sep 2026 16:23:12 +0530
Message-ID: <20260904105313.33238-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "upto" to "up to", reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0d6272ac0dac..af92bb25f74b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1826,8 +1826,8 @@ struct base_eep_header *ath9k_htc_get_eeprom_base(struct ath9k_htc_priv *priv)
 	struct base_eep_header *pBase = NULL;
 	/*
 	 * This can be done since all the 3 EEPROM families have the
-	 * same base header upto a certain point, and we are interested in
-	 * the data only upto that point.
+	 * same base header up to a certain point, and we are interested in
+	 * the data only up to that point.
 	 */
 
 	if (AR_SREV_9271(priv->ah))
-- 
2.48.1

