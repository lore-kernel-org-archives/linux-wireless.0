Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3D647043D
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708784; cv=none; b=gEDmEXUyOJ2FoGKqwNviBzyqNQ4rBzUNHP0wCWePfYS2Cqg3tx/QMRuPQ1sBZ1K9R85t2WinjvlgFXR8oK1Iig0poB0PQ+3ritV10qMVGR5OtBB112saRQMudU0RrZPrp86ErziyGdk3eUCDOBrR9tQxOOSRnO2yn1hfFpiyZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708784; c=relaxed/simple;
	bh=kpRGL4dCgan4z3IleKZzkrOrDlcP695ssfJVUGIpLd8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDhbl3QSHBm0dwLDujp6HFYjBIfCLclELflmf0ZBRMQKmHcD+OJTx1P467tNntO9XyThL2PvH4s3N0wYnfw3zgmjohoMTuqXUWPLNh1maolKXzEnk/fKh1SDbXXP5mPU0SV7bFQkkPuxj37RasNm4oxDklA7JJ+KkUEerNHTaS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=DeEJGr3X; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="DeEJGr3X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hss8D3IzvnHSkQvpc6ACTOR1XDBrCW6HOWz3f9sCwM4=; b=DeEJGr3XkjSAmi5Z0jw1IZL/DH
	fyVhx3P+R/lk/wK7oofGA8EKSy/n416DRUByk4sToMPgEgKNe40dpdqTX4mnn+cG+6FQpPI1rmEKw
	UY+ggUTPhDM9Dkb6kjdgHMey3califdMtVCnC1HvdTo1HjTmXjhyOVUyGdvhowh2geGI=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHQ-005AHx-2A
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 11/18] wifi: mt76: mt7915: write RX header translation bit to the correct register
Date: Wed, 22 Jul 2026 08:26:03 +0000
Message-ID: <20260722082610.2699628-11-nbd@nbd.name>
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

MT_MDP_DCR0_RX_HDR_TRANS_EN is a field of MT_MDP_DCR0, but monitor-mode
handling applied it to the per-band MT_DMA_DCR0 register instead. As a
result RX header translation was never disabled in the MDP when entering
monitor mode, and an undocumented bit of MT_DMA_DCR0 was toggled. Target
MT_MDP_DCR0, matching the mt7996 driver.

Fixes: b2491018587a ("wifi: mt76: mt7915: fix monitor mode issues")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 8ff85cfbb936..2475ddbf1098 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -503,7 +503,7 @@ static int mt7915_config(struct ieee80211_hw *hw, int radio_idx,
 
 		mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_RXD_G5_EN,
 			       enabled);
-		mt76_rmw_field(dev, MT_DMA_DCR0(band), MT_MDP_DCR0_RX_HDR_TRANS_EN,
+		mt76_rmw_field(dev, MT_MDP_DCR0, MT_MDP_DCR0_RX_HDR_TRANS_EN,
 			       !dev->monitor_mask);
 		mt76_testmode_reset(phy->mt76, true);
 		mt76_wr(dev, MT_WF_RFCR(band), rxfilter);
-- 
2.53.0

