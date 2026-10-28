Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=cI9FR4XIq+7gxaE39wq2JORtrmXi5ll3uIy9Wgotn1BvhZNgcbzbR31txpC3yk34ebjG
	 Dvf9M/oyQZ679Jvgw97Bz867J6dDm1azYoQZCMy8vYIyESF0oCzNUdm55OnmR+WNC0U9e
	 UZLlWFg1Ex8BMdnQ+ofM8ljXXp8S71yAGRBtBBS3que4kDNcj5DRccoYoCnYNMXKhuGDE
	 s2dZ6QRPvooYMgkJRki/vA5/mTmxFZQHcYTCaFOErPv066G3btQkfivDd6Lo35y+bGaDI
	 g9vnsXJi72ExesTcGhX2o7LNAkZxIOgp96+Xxdm9BAfJoVd0t2cc8D8Wqo9HJ2gdsKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bPiFoIJrFFvRgZ/kIMizws9wsplPMlJ92QACNtjFkjA=;
	b=WIXhLaXGTy0PAjrTVPY1RQTLWTz9kuV73A0eveqWj69iI3bRx3tb+xav35UFlwu81TVA
	 Q7skgypWQnYYMy9P0JLkDTmVCDuHSw2D4wGuBLDNYnvIsG1ukVhBl2XaeVudKFPLY129y
	 Djzc19H0GDqUeC6t+6D9NztIXkVtB1oWtYtsAFFCP55LGpqSrtEmv1MLiuwIAAq9izlN1
	 8rv1NXFqXHeN+RfW+EiGtVk5sHYTyrKZYqDupsHR3q09kK/LHcdYd45ZodRbCjwGg5EDC
	 twbrUNRFSfGZXmSpxcZs7EAPXgCwp8DeLz+MXPDfJH5T48+taPqF/3ti1I4MrY6IIag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=LSABT2+4;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ABB606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21ABB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=LSABT2+4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bPiFoIJrFFvRgZ/kIMizws9wsplPMlJ92QACNtjFkjA=; b=LSABT2+4xnQ7QjjrBtvzMYdp2m
	oPn/GrAVc7DoZ+svRgU8HD5GBQ88EZEKjHdZUBcPICEj32uUvrdv8wsSai5Eb6tUdx/VeMqvRUV7g
	1owPNcWJ83tg1+FmWZd1LKgio9ulaKWgeCzQqI2Ab+JzI4zSgN/TEBhbqbJBrRRWePQ4=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hM-00C8Bw-2g
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:08 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 16/25] wifi: mt76: mt7921: honour the valid flag in efuse block reads
Date: Wed, 28 Oct 2026 13:23:54 +0100
Message-ID: <20261028122403.796394-16-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7921_mcu_read_eeprom() ignores the valid flag of the EFUSE_ACCESS
response. For an unwritten efuse block, mt7921_load_clc() thus selects
the CLC records by an undefined hardware type.

Return -ENODATA for an invalid block, like mt7915_mcu_get_eeprom().
mt7921_load_clc() then keeps the hardware type 0, which it also uses on
USB and SDIO, where it does not read the field.

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index a0caa77339ee..242a4415539e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -111,6 +111,11 @@ static int mt7921_mcu_read_eeprom(struct mt792x_dev *dev, u32 offset, u8 *val)
 	}
 
 	res = (struct mt7921_mcu_eeprom_info *)skb->data;
+	if (!le32_to_cpu(res->valid)) {
+		dev_kfree_skb(skb);
+		return -ENODATA;
+	}
+
 	*val = res->data[offset % MT7921_EEPROM_BLOCK_SIZE];
 	dev_kfree_skb(skb);
 
@@ -453,7 +458,7 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 
 	if (mt76_is_mmio(&dev->mt76)) {
 		ret = mt7921_mcu_read_eeprom(dev, MT_EE_HW_TYPE, &hw_encap);
-		if (ret)
+		if (ret && ret != -ENODATA)
 			return ret;
 		hw_encap = u8_get_bits(hw_encap, MT_EE_HW_TYPE_ENCAP);
 	}
-- 
2.47.3

