Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C777337DE9F
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791304582; cv=none; b=F/Lxpna2+GF55MDo7b0emZNRnteyGueA5hOE/2ZaX47xGhb45VbYrO057uS76790P5YFYSw2Ouz3H5DcVl+biKTmNfPpVaV//DBVzU2X7mqMAX0nBTNGXWWKJ6FIVAGk/4l/EZiK1Oa87bGoeDGAOon/xliFWmnBtYBFnRbEIFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791304582; c=relaxed/simple;
	bh=yDsaL9pf0Tb7yeaW7R0lXUvADbUkuAEMy7ZzrDm4dlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fGEAOkVkSX9RZ/ZrP3CaPqBrZqd7IKmtoy8RuFdweEFBxPBavRydIMmmlRVg+YteiW2z8TUD8qrTluH3kws8cRIStQXt+knuSwcvwqoeXryUuaD1tyCebCuJ2krsn9AY87GXJGMBjKuGI7wu9/r/zT0JXJOLOyXhjTzsGDUy24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkKHEtFd; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkKHEtFd"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d71d1cc8b2so5956425ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 09:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791304580; x=1791909380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=foeiVoYiYuznXO4eJpvG+c8b8Xx79Qdyfmqi22YhLmg=;
        b=ZkKHEtFdEE9abBI2OBrHRWfqhKt/2DYKU6i0NHt0p+1FX58qK0byf6Wm/K2bx1rggH
         ke8QUU3pFgu0F9hjfvudU14TD2eqhH9a480Epeq/Tb2SZFMg3SAV5lk7L3SM8+dCQ/6V
         J7E6myQ9fH53od2wdrPHJ9Iqi03ohmcGyqqQcTkJuEMVXteKOSab0eVURs+VhXprIQmr
         FZnHih63qKt05YeTjPac9aq3BH+qbj/7zqfFKmxsrSMGBsao2wJ63bdZaG37H025JSa1
         SLK9pd7ANhAEOQRr/VA/ZdMyxB6EbLB9EB4hKXoZ4o+Kb4mimyrfXvAmuG4P14POO19l
         8YnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791304580; x=1791909380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=foeiVoYiYuznXO4eJpvG+c8b8Xx79Qdyfmqi22YhLmg=;
        b=JOT/Yqd/oyGufuU26IqDMZLOVO1BQNE9V4pr05kShOFuxEUxDVEDzRXLY9yPnJeQ28
         B6D6MEM3dIeaH8YpmXzoTgKiam1rl4uHks3fu8tZmwRIlZ/jbsH/XYBfXP0hEG9HsUlu
         3idAgDYYeIrK3yFU1jLZaEn7JvkouI2r4R4G0/ENpJHU9Po89n3R9n7RX14fg5o/3f6X
         2lPUKCWRztBcEqGZRcV0DVnBv6Fhv7jOnComWsYIeYi2jW78W4vPg0C4JZS8Z2hqmwnr
         nYeeR6E0/tbAK1GCAsuYD0xGZmO9lPXlRAjtYIvywdwwCedIaM4/gOscI7muWo88Ee9l
         X0nw==
X-Gm-Message-State: AFq9FYLBg/Y2wKQiBGK0hvs4uj+61gM8BK3EoFOkIGM/NVfxxlbmEgrR
	z+KZNneIK9tknxaDr44EiWMhdRGd3Ez87V8umRR1gkvh7Xe8htt2AyzHYt4t0nsA
X-Gm-Gg: AYBFou0iN8+pYPBdRng+gPAeqgIptHaYR9Z4TNW4JikJZtjSGzkejlLSs1ax5+F+6Be
	gwp+RCCAwaoxAtXwbbNAvmIcC7r/iIXw/MKEt8M9XJdHxtLbL9WAdmfQEw4xzPaZtiS09fb0KSJ
	/WZbfaLxwr2aOFNZuSByytFnFZHLN7DoFiSci/puEDHQdQDal+7N4P2zvmFK8ZYAzHigu2XIBEh
	XlQ8dlt3nWb3r66EqgPlkRmFIfFuckRy78og34SGd4VAMfFqDjAOWqgiAU8r4B9AXZI6rHf6+u0
	83FZCinqhr4di4jmC9zSoMwFetmEl77E6HRU9+n1fAxW2bZo9d+U3Ijsdf/9PROHbt+Hr3lWRYc
	LXnOAVGW0ZSkPMnualkiZNswN5VU8jDt85O35tQiyIG+OLRLPapxpdVW6sbajFyiulTIqv6MwHY
	BKhquDrWyJaDk/A1A/FgHUOtZQqN1wCewrKRKPnUlSNNFf8Nvj5K/JtSJVciYuZDHe0ji/gE9RU
	5sh5xrDmbfstYlkF/ACc2tl2mK+UYF4gNL/Dh8=
X-Received: by 2002:a17:902:d542:b0:2dd:c100:942e with SMTP id d9443c01a7336-2e60053cc18mr111375ad.44.1791304579856;
        Tue, 06 Oct 2026 09:36:19 -0700 (PDT)
Received: from arch.localdomain ([1.187.69.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5ff91eb86sm388445ad.80.2026.10.06.09.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 09:36:19 -0700 (PDT)
From: Mahesh Saran <maheshsaran477@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	emery.hsin@mediatek.com,
	linux-kernel@vger.kernel.org,
	Mahesh Saran <maheshsaran477@gmail.com>
Subject: [PATCH] wifi: mt76: mt7921: clear WM2 from MT7902 RX all_complete_mask
Date: Tue,  6 Oct 2026 22:05:53 +0530
Message-ID: <20261006163553.11193-1-maheshsaran477@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MT7902 does not have an MCU_WA ring and sets wm2_complete_mask to 0.
However, commit 83c65e82e5b2 ("wifi: mt76: connac2: apply new rx
all_complete_mask") populated all_complete_mask in the shared irq_map
template with MT_INT_RX_DONE_ALL, which includes MT_INT_RX_DONE_WM2.

Because MT7902 duplicates irq_map but only clears wm2_complete_mask,
its all_complete_mask still contains MT_INT_RX_DONE_WM2. This leaves
the MT7902 RX interrupt configuration inconsistent: the aggregate RX
completion mask includes WM2 even though the corresponding RX queue is
not present on MT7902.

Clear MT_INT_RX_DONE_WM2 from all_complete_mask for MT7902 as well.

Fixes: 83c65e82e5b2 ("wifi: mt76: connac2: apply new rx all_complete_mask")
Signed-off-by: Mahesh Saran <maheshsaran477@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 56a914aaa81e..f87c44f2a8b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -375,6 +375,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		}
 
 		map->rx.wm2_complete_mask = 0;
+		map->rx.all_complete_mask &= ~MT_INT_RX_DONE_WM2;
 		dev->irq_map = map;
 	}
 

base-commit: 69f80fef3153299d9c72c53d1d71eef6354b6926
-- 
2.55.0

