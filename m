Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445823438AE
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2026 04:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781064694; cv=none; b=YQCvWh8O+iI4NqLBHz4qaakVAlt8Czju98xO+c99Tb9TBg1OPW+w8a2gyFLsiLXmGlA35H53lIq92VSWaeSp55AW9B+5uTZOgddnDjWm8PPSku8aYxXZWOTJbSj2B60iUBFStyY99qHOC0LqtTiBSQSnfP1fH9QISgEKh9/WGT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781064694; c=relaxed/simple;
	bh=yfDuceUCbg16HsyuTy4fx0Xbiyq3HnGfGib9RURpIrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RRLKGZgGLhtQAjib7g8EkQFkREF2MgJbJ25X8akkB8LmdOCXzT0BTnKAcTB77G4U21BB34nRgrk8lfgMOTgjjGA+o+frv6Bn/zamOktxIC2ppziniuRfIbKSdBMU3zU/3DCWt6Oh8XfMotDEcskBzjl96+WYeo8ZOnuxY1xR+I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJXU4Wod; arc=none smtp.client-ip=74.125.82.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJXU4Wod"
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-304cf518c9dso7794771eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2026 21:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781064692; x=1781669492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fUPJQP5o84fJ7ZD0pazp5pwV0hHwjnyQ2aFjNr95BlQ=;
        b=kJXU4WoddL9ymBMSiZE8Wdk9t83QIvwjfuiukmyaa2/1otyXWDpuznNcRkqwFqn4ly
         ol/KgW3D2vXING2vu+boZrvEMls86WnDQPhfIXFy6dwTzqVMDlgOBvfdi2Len8NHN7sq
         OQ9QVb8WD+NldTScM5sAhr1ub1ntyXg0pW+M+zGRzgp/Va2ohwFOOOquFX4mfH9RMv5s
         o+0la6WbDadeb0XWKmJgRSCQGfdZVk2BisqwXwEpEOJtG/5sWBgc1mSe2f43yxupHR6y
         /Qhn/i44QERUZ2djhw3nNtIlxdVe4PoBIgl0eE67ASYXpK7ZiuO/IrxuCf3+CYH7jgEW
         Qz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781064692; x=1781669492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUPJQP5o84fJ7ZD0pazp5pwV0hHwjnyQ2aFjNr95BlQ=;
        b=YTpDjnmeRcSJeuGYrFT5W3yr2vXNjYqkg1n83/f9h2jVRkvHNRZ+77JDo0YnCq9GBy
         1jmlDLQUNWAi6FLG7r72XxBS7zpfvyomHpbxmGLtL3Xs2bsX5V2prYWmu/TSimLSln6t
         7fOE9Ve92PQdhFxNCZj86Zl/Y6XfsOCC8+J62CowH5lM8JK+plJmOYmVMIRIuYHt6iKZ
         aaZEgnA3jMb5eDU8l/1Uds/RnZYIBQXorAoAK/daOAMoXV9D98fnKxqJRleQnlzDix6G
         qUNwVE4ccy6X6+hyYY9gOes6SjpgJ9qPsi+Rzdh0a5sBOyOC+NfFhSuop/MEp7mHJ7NO
         OIaw==
X-Gm-Message-State: AOJu0YybalrybnH11PD7ZxxaUFEX0jQzW2rUR6GcomMd/MY6Mk+t6i9g
	JD1Hdq0UovoHVTYcy5ya6ZfOX44qbUr1o2qXy6ync3OJhbUz6g5KSs9xJia6FOCy
X-Gm-Gg: Acq92OGvzsyLGjUewr3mBpfatG0voTUHHg4eMZLxJX4XTJHr1Z7NiCUoG0liTuphjoT
	48J+S78YoCLAyGAmcinDiKIqALJY9UUTy83P48lySzXsYpgFZYzG0DpnyclnIa/7RUCXF7v5hjl
	agzSRGCTjY5ErJk+OYlR5uVYMFKA4AIT+y9FuQdvOAZKCWBne3HoYopbzrEDgq18MYRC8znsrvo
	UCKY2qjcZLb/9+CMzobI+dOWYugJoaykQjtYuDEN244+2EQSQKMJoRM/5N2vcDp2iqp8xV0WAZl
	Zyz4RzHm1AV1NpLBstE83AzGb9rVBlHurGVG0G+37A8OeOsoXpbEQQJDnXRnEM+s9CPsM9a+QFv
	mC3K17YxzdaTPbUPNLDK4+nPL9XTUBAvlgt3uktOQyhS2kM+v3BrtbHRPuBXs766SizoXrubK+z
	2AnoW1blE7NE2n0tynJBByE4JlDdcF0mO1vXRrtG4yoWzgzREVYNG9noGrSYn7B/krVytGU25Uw
	QFkpOJJgoIf9p5LytqFHoBNbbm7Hu59lBE+ALMVTc4UQ/bsaZzcsjU/C69LkkwF+HNdKlkTyyGZ
	ghNMoeZu5OLrNdWw2LwbtwpwwAin
X-Received: by 2002:a05:7022:2215:b0:136:da48:5edd with SMTP id a92af1059eb24-13806682c6emr11767434c88.4.1781064692116;
        Tue, 09 Jun 2026 21:11:32 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137f549bbefsm17861149c88.4.2026.06.09.21.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 21:11:31 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Rex Lu <rex.lu@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7996: remove code guarded by nonexistent config option
Date: Tue,  9 Jun 2026 21:10:47 -0700
Message-ID: <20260610041050.206950-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A small piece of code in mt7996.h depends on CONFIG_MTK_DEBUG, which
has never been defined in the kernel. Remove this dead code.

Discovered while searching for CONFIG_* symbols referenced in code but
not defined in any Kconfig file.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index bdcf72457954..39c525a40412 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -921,10 +921,6 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 			 bool hif2, int *irq);
 u32 mt7996_wed_init_buf(void *ptr, dma_addr_t phys, int token_id);
 
-#ifdef CONFIG_MTK_DEBUG
-int mt7996_mtk_init_debugfs(struct mt7996_phy *phy, struct dentry *dir);
-#endif
-
 int mt7996_dma_rro_init(struct mt7996_dev *dev);
 void mt7996_dma_rro_start(struct mt7996_dev *dev);
 
-- 
2.43.0

