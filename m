Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341CD369D4A
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708782; cv=none; b=Itr41eWSL5XeC8HF7twg4FC2/0mFWysFLj4HIyTGYPrkJlQPOU3XrGs6cgSeRClukJFV+LM3khB0vFKreNrRKR4yufpuqMdOtOmdzdrBxx2aQmoCe4aWKyDLCYDmZXuj53vM8oVCaJF2Xaa0wep6s2Mht5NnCprISgL9FlakWCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708782; c=relaxed/simple;
	bh=Ksiqhe1/bLUCV78rO/PN5E5usO+7lTekosD3CwYDyT0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PpoMO2OP8lJMwiFKemFP+1rw9NL67ZDbVrV6DUWY+3nwKDt7Myezn8vunIGPhms2UvmlA9sMjwqvf9cHlUVBm7Nv+FGW+3YdXOP0WPUHh1o4oHbY6yRGgxQNMgLX07IYLQnTLAPBgvQreHDTp+eATyDW7pqwP7GrPs/zBXzcEdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=I2Ilst2p; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="I2Ilst2p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mF2CmRpf2JrFQTf39YBLnaJyAXYy8vLUb5eg9USKORA=; b=I2Ilst2pLIkusBSEO65DRw9wpk
	QvYEPHtLnIL0A+pZXK+JHS1A8SFnHoVclCcl2a5P/dUXi928o9KjFCldVWEfgMqqJB3imoWTerQj7
	1bShRnEDPrJxhSldD3AozCf0w/26bVfrtN4YqO+q+tBs70ZSLuhHA2G/DjiScjRyzoUQ=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHP-005AHx-09
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 01/18] wifi: mt76: fix RX data queuing of RRO 3.0
Date: Wed, 22 Jul 2026 08:25:53 +0000
Message-ID: <20260722082610.2699628-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rex Lu <rex.lu@mediatek.com>

For RRO 3.0, RX data released from a RRO data queue should be put to
the indicator queue. The frames are processed and completed in the
context of the indicator queue NAPI, which only polls skbs queued on
the MT_RXQ_RRO_IND list; frames queued under the data queue id are
left sitting on that list until the data queue NAPI happens to run,
stalling and reordering RX data.

Fixes: b1e58e137b61 ("wifi: mt76: mt7996: Introduce RRO MSDU callbacks")
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index c4cbf7195b80..f92277770488 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -893,6 +893,7 @@ static void mt76_rx_release_amsdu(struct mt76_phy *phy, enum mt76_rxq_id q)
 	struct sk_buff *skb = phy->rx_amsdu[q].head;
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct mt76_dev *dev = phy->dev;
+	struct mt76_queue *rxq = &dev->q_rx[q];
 
 	phy->rx_amsdu[q].head = NULL;
 	phy->rx_amsdu[q].tail = NULL;
@@ -921,6 +922,13 @@ static void mt76_rx_release_amsdu(struct mt76_phy *phy, enum mt76_rxq_id q)
 			return;
 		}
 	}
+
+	/* RRO 3.0 data queue skbs are processed and completed in the context
+	 * of the indicator queue NAPI, which only polls its own skb list
+	 */
+	if (mt76_queue_is_wed_rro_data(rxq) && dev->hwrro_mode == MT76_HWRRO_V3)
+		q = MT_RXQ_RRO_IND;
+
 	__skb_queue_tail(&dev->rx_skb[q], skb);
 }
 
-- 
2.53.0

