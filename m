Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD39470128
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787849237; cv=none; b=emQvcY9ezvIb4jq8FeEzIjAgaAP3RZyEIRAwU/HSeUtetnTpfSVFwKzslPpQxLvMgR2Qc4ly7J4AdNWIh3J6m8+8/MYqleusiT1h5EhGuamn4eZV28Nj6X+MPNjdP1Dp8lXtQaCPBWIPtTNYholcsOvn3SW+Z/u6kMCwnKQJuM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787849237; c=relaxed/simple;
	bh=SCYog4OjHTHSs2pBbxEUNl7ODuQFEFB9GOT6LLdSVVg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=DFjqFuaTXnydPEYiSam86IAqzRWBPeg4K9nCGLaqmYoIprH56rI2JzylgCR74GJMBxcBR3Dqf9M3yVU1+OMitZXFy1WW/qGmQ3iS9wgtLF6HBAQH9s8EBX08W9i0B+CLAi++IaNXUc0PfwcBDGy1f14oY6XQbHNUvhE+Eiqp/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Wf7N/tci; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Wf7N/tci"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=juH3yQsX28gn5VNTzrK/+9L4Aj8nM2YOm6hdLda4Dfo=; b=Wf7N/tci8/21f+g1YWxKMBZ0bm
	9yi5k5tWZQkbQA/YJwOIe2nWIf5IR4RDDcs+0PcZp4yhVUShlyIRQQoM9qcHVxND5tdO94YOeZdxY
	JnozqWhAdCWbeQUoP0pAIjY0VjGYqw1DxwWLRJbo4i5fwgTKVu/AVKiM8unHhtzWVVlc=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wzcqx-008db0-19
	for linux-wireless@vger.kernel.org;
	Thu, 27 Aug 2026 18:21:23 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-fixes] wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
Date: Thu, 27 Aug 2026 18:21:15 +0200
Message-ID: <20260827162115.1449757-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7925e_mac_reset() returns directly when mt792xe_mcu_fw_pmctrl()
fails, leaving MT76_RESET set and the TX worker parked. Every other
error path jumps to out, which clears both. mt7925_mac_reset_work()
clears neither, so once every reset attempt fails there, TX stays
blocked until another reset succeeds.

Jump to out instead.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 280797fa0d85..67eb86746779 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -127,7 +127,7 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 
 	err = mt792xe_mcu_fw_pmctrl(dev);
 	if (err)
-		return err;
+		goto out;
 
 	err = __mt792xe_mcu_drv_pmctrl(dev);
 	if (err)
-- 
2.47.3

