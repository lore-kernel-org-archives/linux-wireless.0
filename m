Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD323C3C02
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788291860; cv=none; b=WMMu+/6xDt7Y44Ug3ktqkoWEWOZSfmHzjquCnpNpeUHltQ3Z3We9M1f4BP7btlHyql+PwB/HOljl4Q1qw/PDx5/ynomD45rjNhUDIQhPxrK/zE9p8F/jzI4nCItqMrUixOM5JbgNsz+eiDvbJTjyGEK8HZi7AWbHxJOJQkwgC+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788291860; c=relaxed/simple;
	bh=vJ1gUL/MUs6aFjhsZNpKLyV5U2rtjvRoa6ou/s+kvw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkOw08dLob9w8EVnDNPt+4/0jLCL7GWTk61cH9ip6ds/ccAEVlbgRNIv7Te3l5OpJ8qamQq2XcSiGka2d7ptMp7DHuLi+LoBAeBP4YRaYYI74NYcyOIEsPq3E9x9032XIWeyRo556cOPznt//AYFuoI4qUt3OGpw9uho2Zrm3q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bpkoz/0W; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bpkoz/0W"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3966791a6eeso269271a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 12:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788291858; x=1788896658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+xVIch34Nbif/rvLV74dX0Irc4hTEm6Qb3Dw/ncNbVY=;
        b=Bpkoz/0W+5EcuDcTu2jY46/K5jyJ8UDIkULhKGqWZFg8CU7CCagf2RF0r5KsvQ+4UG
         e2DKyZ4R716RCdFFWtbZBJa0EeQMOTRjEywBHRo0myLHDnEEmxQEY+7tq25LGYJNKQ7g
         3/MYiJ9YF1UyQjA7XIA816l/eKocIsC6NUptdzUGE786qamlA0MsafTQ/sleWnreXbRa
         BUQn51DXvaOMiTHl9HywO0zc86NN+oAf9y/btv3irs4xnMI9RFwzgSVxiainjr+lWcGp
         TQdYqTTWDDLvjaaZ4pMm80qSicAebQLJxm86upuphLz9CqRUJ6b01HwYdhBadQ7DEcKy
         aCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788291858; x=1788896658;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+xVIch34Nbif/rvLV74dX0Irc4hTEm6Qb3Dw/ncNbVY=;
        b=DB+ptN+UMuuLHWVBfmKmuc6eDRFFctw0hB/mpLd/uMOqrgyFZFdwmQ0ya3okBoyhwz
         L/mhWF5Q75doGKDDE1uBYxo07PXjIsSdZCw9217RCMGV1td2xMOtGqL+Ghqn+aE8vIRz
         53ZMNpo3kE3BJ4dYnWERmSYmKsiftwJyZX/Py9LaDZMaUeijaIb37cAjtVM8CqEkXTmk
         MITW31rXKfQjim+xCvc+osNB9TnCvoXYQp3CCCW5VvAkGapILJrvIbFuellFFIplFJYP
         bh2rWiJ11cRwFXf7GpbXOSHV8uWXvWAW+8ut5/msX+iSbjlHJ4ZMOQp8QrHX1bxbj0HV
         +T0Q==
X-Gm-Message-State: AFuF++m5RvTtTyWtFPVNLN7iGXpOcTCf3+sWhgfSXg5kt7J+AfDXuric
	59ZB/itgwTXLCSpdbhoaj8gB1gSVh2MIBiUWfzlm1X0LhRPjASSFInl7ScUOWIjQeX8=
X-Gm-Gg: AYBFou38AVQ/EN0KGQuuTYEGeTJkxRyP4wrmbymLNZOOZTVWWoXFcq8rZd0wR59HfKq
	W4U0OBn1eA/eU/ZyaQ4mqrBAmCnXWP4WHyAAxIFpafvanBEaBttPnxLBStlwAh/Upp0ZzqLJlmp
	qagRXqDBV6SrVMCfyQqyKy7C7F6s+TDDXSlC67qbOnNy2Jhc2wwvarPcn2doNRbcaJtg73PmAw+
	nCU4hQybLIMPv5NeHRkVP3boFi3zlE78n95GFAAn0JLm2Mo3Ap5VTRbYnYgL90FavwJm57oEZLS
	4gtoNggYY0EO/CPxXXdL4ZSPvjP15uMYVUS+eOIrY5AZmtIatc8dpg2/4/5jSt0xKSSrmBKGTNs
	FIXVuBJ/rbdaAs1EI0KFFmUXSE8UOtxBjCzcRGF5tdqR3biMGu65yP0w+qsBJuvdHmtAv6O1lss
	mmOHkJW5Xv/E0z4oinsVMri3s0lpurmJ0551mQ4a4+yzQTUAnhPDSrTE/aY747uQjjMNQFpTtqS
	f5oKaI5xnV+oJFIJo52zekQ
X-Received: by 2002:a17:90a:d407:b0:398:e73e:5a13 with SMTP id 98e67ed59e1d1-39907bbe00cmr16920649a91.9.1788291858509;
        Tue, 01 Sep 2026 12:44:18 -0700 (PDT)
Received: from ca91a6afa0c8 ([31.7.57.58])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07b79cf9sm309019eec.18.2026.09.01.12.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:44:17 -0700 (PDT)
From: Valera Kozlov <valera.kozlov19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	Valera Kozlov <valera.kozlov19@gmail.com>
Subject: [PATCH v2 1/2] wifi: mt76: mt7996: use spin_lock_irqsave for reg_lock
Date: Tue,  1 Sep 2026 22:43:37 +0300
Message-ID: <20260901194338.110-1-valera.kozlov19@gmail.com>
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
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index fbfbb96a742f..4e335e601581 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -391,29 +391,31 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 			  size_t len)
 {
 	u32 addr = __mt7996_reg_addr(dev, offset);
+	unsigned long flags;
 
 	if (addr != INVALID_REG_ADDR) {
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
 
 	if (addr != INVALID_REG_ADDR)
 		return dev->bus_ops->rr(mdev, addr);
 
-	spin_lock_bh(&dev->reg_lock);
+	spin_lock_irqsave(&dev->reg_lock, flags);
 	val = dev->bus_ops->rr(mdev, __mt7996_reg_remap_addr(dev, offset));
-	spin_unlock_bh(&dev->reg_lock);
+	spin_unlock_irqrestore(&dev->reg_lock, flags);
 
 	return val;
 }
@@ -422,28 +424,30 @@ static void mt7996_wr(struct mt76_dev *mdev, u32 offset, u32 val)
 {
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
+	unsigned long flags;
 
 	if (addr != INVALID_REG_ADDR) {
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
 
 	if (addr != INVALID_REG_ADDR)
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

