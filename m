Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C9A3E1D13
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 06:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787552741; cv=none; b=GuAyLWu7CRM8uTvc5ibdvGeIUJZ/2huz4EWRZDNSQbp356ULQU7M6xHx0FS8hkKaRNNiXr8pgWOT5L69p1kvvGQF34JaH4QivWFsLDR3Thr+/qC1vfTv10f8TCT2mkeVi1OyBqjOEXocm53ghKS0SFy6yE9AQ+bTHf1YZYY2Ung=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787552741; c=relaxed/simple;
	bh=OwDH5kLOHW7sAtUiOIUywn+Z+rIZG0KqUwe7EAjir9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GEVB2XTKvq5TyGUgULEymcyYEYo3Q1Bvw3A9DrPtMK0UU3iw/SOqbqna9DPMkWhyrY+LQfnwarsq9oef+cqPcCl5/0ZSVBY8wcYefSp7dMPyp6HzCpLHO3AXTUPUF/AagtcWCRv2FLAyjRQuI3R5FLYHsXSXnbpngKTRhcfdkdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixB+imje; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixB+imje"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c247f6687dcso338346466b.2
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 23:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787552736; x=1788157536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EBzG8kLn3Nb6I4HgQIa42oHJ+FqVXnchLH9caD50OSQ=;
        b=ixB+imje8tKe5Y0AtWAjOM9nwKRsPLG/3lCcPWftlz+rduSbsk64JrPCOPQnRIdRAt
         9fekoSEW9caPIxAsBuYAmYmd5x4K4v5Uaej+WM5X8+fJ4n62r+qmex0vR6+Fa8K25oYm
         I/LkQJkw5qhNwx9AbNABi8qWB6fG/f/HzLuWB2iNF6yvRSNeruHe+ih1uB2ttCJ+FeNv
         ojQRMiABLYydJzIn7gxitykGU4pbmLGcjyC3ZYUWKG1nq5M3mIZfz67AB4Jma/mQZ+hE
         lsOiksJDPW8hovCrd6YEsM2QTYmXoMvdvBBHHfCX0HbofVxC2Zqd4QGVJMOJeXkAIK3X
         n07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787552736; x=1788157536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EBzG8kLn3Nb6I4HgQIa42oHJ+FqVXnchLH9caD50OSQ=;
        b=ajsg47OuE0KKzLp93vCnQvYLBMteznIsjDiYsboIm8VobiPOXq0rZtxpJgYH9D1rNe
         hwwh0dlR0Mp7eyyb9Bvlp7g5K6deCFsenWYj8F2m9C1cCNAZ1cbxOlD1fZAynJgYZkzU
         UPJgljfPWsrwY+hOMqBlWRKbGg/LSLFMGWrYKrtm+KpouorkEH1eyl0EPiEWR41ufNLv
         0u4yLmqU743ZHCXjbTJUVyGEUpUCkoBJcccgiGuaO7deiB+/X64RpkV8hKncj+hm/WNC
         zK9N42AR3mulCjnzycP5n9IyCOcqbJsryeRW11NK8zQ9MCc1pPMlZsXcycqzmOmBxybJ
         Cc0w==
X-Forwarded-Encrypted: i=1; AHgh+RpaW+29pU9n7MPPmQF5VnNI44AxjIC/4tWE3ffEAZnR5tTIo4mgQBIXXz5aftIh9SF6Bv/8CSXcyq2zw/dPIg==@vger.kernel.org
X-Gm-Message-State: AFuF++l0qsSRZD9IBmq6jZQhHcnjPaopEEbh5WTBN6jTA78VQJ8EkPfe
	ZcS0w+/C20c9ZzOZJwnoxRxDN2oqT2Omim3dcB4h0aOWiDQHPWXcR8Gm
X-Gm-Gg: AR+sD12SYSITtLowuqo2ZTBQr5NoWypH3097BwInSQ6XFV5SVcSrwF7srAhJHQ612/K
	swdZNAo+cM02nz8oV+T3ObbWhW2k6vzWpQ5qodOoFIi15Qt+swyBmTplCQEhqgSv2nkTybKTCWo
	Uo222xPODOCFRD5rBfFcL0DE2azzkB0Ql0qBmoHJqMSosG5jBoSFYUGsfsxPa0XXbuHs7kiOUAK
	hXP0w1WCm96xSwNm17HNcIH1i+q06GvOgzRJDjZ4hTePy3iuaCif/73Iaa99zh2IVS7fX4Riy5y
	iGqjPsRuabij98QwkgK7aD+j3kvKXmq9oD3HL2se1TxzZsPZiwGCSkatipv3emeXoW3PZP8YdDv
	CmEVchujslFDxPmQn7TIHf9ctrUX7NWeCrPkGLF1wr+2Uhvcr8HGMJAVLlhMzT6FSRmZBiPYTP9
	Q3yPd3ii3nIPgnMSxJ1prcrWH/03HzqGsUO0B+kC0Ekw43URPZEm54a2hROtzD+hyw1tB4HPgio
	OFaW/2bSQSJMuP2NrbvizlEGcdQzaH8su6L
X-Received: by 2002:a17:907:a892:b0:c16:5cf0:3aff with SMTP id a640c23a62f3a-c246a62afb5mr2535891066b.18.1787552735516;
        Sun, 23 Aug 2026 23:25:35 -0700 (PDT)
Received: from ca91a6afa0c8 ([31.7.57.58])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249629a901sm1213602766b.25.2026.08.23.23.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 23:25:35 -0700 (PDT)
From: Valera Kozlov <valera.kozlov19@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	Valera Kozlov <valera.kozlov19@gmail.com>
Subject: [PATCH] wifi: mt76: mt7996: use spin_lock_irqsave for reg_lock
Date: Mon, 24 Aug 2026 09:23:01 +0300
Message-ID: <20260824062301.270-1-valera.kozlov19@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_rr()/wr()/rmw() and mt7996_memcpy_fromio() take dev->reg_lock
via spin_lock_bh() when accessing remapped registers. This is not
safe against hard-IRQ context, which can lead to race conditions and
kernel panics on some platforms.

MediaTek's own vendor tree independently found and fixed this same
issue, reporting it as causing AP panics via Asynchronous SError
Interrupt during normal WiFi operation:
https://github.com/mediatek/mtk-openwrt-feeds/commit/3edfc0cbf7dc666a0b051b54f51634d6ff2a3be6

Switch to spin_lock_irqsave()/spin_unlock_irqrestore() to make the
locking safe against hard-IRQ context.

Signed-off-by: Valera Kozlov <valera.kozlov19@gmail.com>
---
 mt7996/mmio.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mt7996/mmio.c b/mt7996/mmio.c
index 1f7355cb..67ed157b 100644
--- a/mt7996/mmio.c
+++ b/mt7996/mmio.c
@@ -365,29 +365,31 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 			  size_t len)
 {
 	u32 addr = __mt7996_reg_addr(dev, offset);
+	unsigned long flags;
 
 	if (addr) {
 		memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
 		return;
 	}
 
-	spin_lock_bh(&dev->reg_lock);
+	spin_lock_irqsave(&dev->reg_lock, flags);
 	memcpy_fromio(buf, dev->mt76.mmio.regs +
 			   __mt7996_reg_remap_addr(dev, offset), len);
-	spin_unlock_bh(&dev->reg_lock);
+	spin_unlock_irqrestore(&dev->reg_lock, flags);
 }
 
 static u32 mt7996_rr(struct mt76_dev *mdev, u32 offset)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset), val;
+	unsigned long flags;
 
 	if (addr)
 		return dev->bus_ops->rr(mdev, addr);
 
-	spin_lock_bh(&dev->reg_lock);
+	spin_lock_irqsave(&dev->reg_lock, flags);
 	val = dev->bus_ops->rr(mdev, __mt7996_reg_remap_addr(dev, offset));
-	spin_unlock_bh(&dev->reg_lock);
+	spin_unlock_irqrestore(&dev->reg_lock, flags);
 
 	return val;
 }
@@ -396,28 +398,30 @@ static void mt7996_wr(struct mt76_dev *mdev, u32 offset, u32 val)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
+	unsigned long flags;
 
 	if (addr) {
 		dev->bus_ops->wr(mdev, addr, val);
 		return;
 	}
 
-	spin_lock_bh(&dev->reg_lock);
+	spin_lock_irqsave(&dev->reg_lock, flags);
 	dev->bus_ops->wr(mdev, __mt7996_reg_remap_addr(dev, offset), val);
-	spin_unlock_bh(&dev->reg_lock);
+	spin_unlock_irqrestore(&dev->reg_lock, flags);
 }
 
 static u32 mt7996_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
+	unsigned long flags;
 
 	if (addr)
 		return dev->bus_ops->rmw(mdev, addr, mask, val);
 
-	spin_lock_bh(&dev->reg_lock);
+	spin_lock_irqsave(&dev->reg_lock, flags);
 	val = dev->bus_ops->rmw(mdev, __mt7996_reg_remap_addr(dev, offset), mask, val);
-	spin_unlock_bh(&dev->reg_lock);
+	spin_unlock_irqrestore(&dev->reg_lock, flags);
 
 	return val;
 }
-- 
2.53.0

