Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190255;
	b=5UJUU812RooCWrhKC2OyylV2+Ejc4RYdzsMRg45jO+dfYIVUNkr3t2CQO2PqoxqK4KMg
	 +mma3G0PfGBFsQFxf70Cx7anfy0w5Ci1XbuQu/HgrkOXqQxe66f9wzPLJXbpuRvoneEjC
	 3dk6Sa90d5O2P7275pRItJErITX9FklS36NzwcPQzuXRsLVoZklIbRCXe7/dRDSmftkth
	 Hk8MIATMMs2L6rnIjedcbFBBpBUHbylyDXIqJbjD5Ao78RP9GVQqP2AAmjJ3gOcwJIg8q
	 C4LwRUAtWuucxaAiGi6BkqfZzpDemHapGLlFOkB7vD1VgGQr69czELqNk3vMJkWwebw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190255;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rBeWeZEWXRDiiv329SYfiB2vbFAefZl4V3oW/CYMvBY=;
	b=Es8GdvpVsJv7YcVxKqPt+kbs6zi3lHTgPXruDfhHIAS+QidkfqsFxS/ElDyktPsqcU1U
	 pamE67IoG3T2K/HNg2XSc3CbDd0ju54Ka9XuJKmF7XdTvFDSY5z4KV6omA8dqJc9GOOqk
	 i0ptnK3wXBjF6jYtqg42WvjctkbZREV/EBgapUC3iR8UOREgES4P0aSCwLTOUacbzWTRi
	 YekrdUir9fLjcbH+DSPLaNJlZqH3ZfS/6tdOBw6f+hbExx6n65gZn8MNP6eTPCAkgJGFJ
	 06F1FGND9ENe9j/BRjWovlJF9G5XGbrZGRiVExSQHtXf0MKdO8MlM2vC9o2Mk7Pef6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=TGALUoD0;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B963606A330
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B963606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=TGALUoD0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rBeWeZEWXRDiiv329SYfiB2vbFAefZl4V3oW/CYMvBY=; b=TGALUoD09jGN2ScqNjKGMnsn5o
	xtihy7MGW2u55u4Ap6wedQ4HUJUHJoJItWKZOsDw5lZalh3SlxvAIl1Id8+uhDolQI9KnyDmnxhNa
	9ZDmIIWb0aJIYkO8PerkpwESblro+6O3DlVpK6VdFg4QWAxaki0ePjvBDWTu0quMNzWU=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hM-00C8Bw-1b
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:08 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 14/25] wifi: mt76: mt7915: honour the valid flag in efuse block reads
Date: Wed, 28 Oct 2026 13:23:52 +0100
Message-ID: <20261028122403.796394-14-nbd@nbd.name>
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

mt7915_mcu_get_eeprom() ignores the valid flag of the EFUSE_ACCESS
response, and copies undefined data for an unwritten efuse block.

Return -ENODATA for an invalid block. mt7915_eeprom_load() skips the
block and leaves its eeprom range untouched.
mt7915_eeprom_has_background_radar() then reports no background radar
on MT7906.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 145d14a1012d..0ab02580423f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -154,7 +154,7 @@ static int mt7915_eeprom_load(struct mt7915_dev *dev)
 		block_num = DIV_ROUND_UP(eeprom_size, eeprom_blk_size);
 		for (i = 0; i < block_num; i++) {
 			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size, NULL);
-			if (ret < 0)
+			if (ret < 0 && ret != -ENODATA)
 				return ret;
 		}
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 67b470f4bd9b..e66968b819da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2952,6 +2952,11 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 	}
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
+	if (!le32_to_cpu(res->valid)) {
+		dev_kfree_skb(skb);
+		return -ENODATA;
+	}
+
 	if (!buf) {
 		u32 addr = le32_to_cpu(res->addr);
 
-- 
2.47.3

