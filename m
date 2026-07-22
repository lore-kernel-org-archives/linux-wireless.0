Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2FD42E8E1
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708783; cv=none; b=B1cNapsKuQ6Mpr+JYxddUx5L1O4xdZkpZUzczTfuOgZmKw45ovPFmqMwLE3h2i57rwQ5wsgPrJjs8PcYNVpHwCsou3cgavGqyBAN4hCfwQidp/UfJN7oRL5/jkDQ2gLM2uLkjmEoyP9PuFspEbGAVPeIvNds3/jexm1AiQJv9Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708783; c=relaxed/simple;
	bh=WaiTaT9iXzQFVw8iW9Cv9u1K7o3DBIX5RT3Cz7J7V/8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1JLC4YjYavcpNE1zLOv2gUih7ZY6jY28tNE62acD18iM+f/cMUYBMcVkf6+P2BXoEP7MatoMzruSPMyfh6BB/fGFuhgt98YHGwZHW/EMRECAV01Td4dxlDnMzZcAcLy+8uCW0xhxJklZs+TfhDRELBJRqEXCtvAv6v523JaofE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=GVAajJ+9; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="GVAajJ+9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dhkxN9WS8zAL9cX3bxX+NdAFePbycfPesyP8D2eAUwg=; b=GVAajJ+9i7ZMvZlQblok39qj5v
	NcMBdZQqR0FuNjUfL93mgGP8E41bGTxECm85BZ6XajRQwXcUnzWraAto6LWJ719ytG4A6DIxL46Ah
	kqiA0Yssz7m3vRSB2zB0+xuJxApBg7zP0NQz/Pfa7TuXuK7KMcbc1RS0JR3UNI/rdBCQ=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHQ-005AHx-0a
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 08/18] wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear
Date: Wed, 22 Jul 2026 08:26:00 +0000
Message-ID: <20260722082610.2699628-8-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7915_remove_interface() cleared the wcid mask bit with no lock held and
before clearing the RCU wcid pointer. The mask is a non-atomic RMW shared
with the allocators, which all run under dev->mt76.mutex; on DBDC the two
wiphys share one mt76_dev, so this raced add_interface/sta_add on the
other band and could leak or double-hand-out a wcid. Clearing the bit
before the RCU pointer also let a concurrent allocation reuse the index
and publish its wcid, which the subsequent NULL assignment then wiped.
Move the clear into the existing mutex section, after the RCU pointer is
cleared.

Fixes: f3049b88b2b3 ("wifi: mt76: mt7915: allocate vif wcid in the same range as stations")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index ed72e13f15aa..8ff85cfbb936 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -304,7 +304,6 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 
 	mt7915_mcu_add_bss_info(phy, vif, false);
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_DISCONNECT, false);
-	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 
 	mutex_lock(&dev->mt76.mutex);
 	mt76_testmode_reset(phy->mt76, true);
@@ -320,6 +319,7 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 	dev->mt76.vif_mask &= ~BIT_ULL(mvif->mt76.idx);
 	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 	mutex_unlock(&dev->mt76.mutex);
 
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
-- 
2.53.0

