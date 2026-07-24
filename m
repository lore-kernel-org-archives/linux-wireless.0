Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45651433059
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897304; cv=none; b=tBEPiU+I65v2DKPvtLTAkEKpVu2qbR39LbISKmvgWRPpFB8yuhF4vRrc8B4hD6UTtB0vbWorLQ4E7JKP0kPvjVASbNx1REvu1+J5FKa+svUePIOm5pn+jiB+JTVUjIjZg7nRmlr9Kka7z/JOnmHZDnN+u0zpW6G8bXemQ7eMdJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897304; c=relaxed/simple;
	bh=5tc0lHQdCYCVeCk1ORNreR1+Toca9NfCSxH9CQ0dHwM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lljVXyOR+GK5nKrr9UUlCBF9r/DvWQT02YeQiJHwDuHXbuiKt8L4XX/TVbVoAG4u7/xTVcFayz0UyQaCHqBAHY3+DGGz8i49/+tFNWwD16EMMO2h/Px2FLjqw01cl/YjzyUo3tK30k1WK6sqCfIZ/JYH1h/07q2nsJg92yofRzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=bK+wXM+h; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="bK+wXM+h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cx5Z0VF40ZbTxBr3+UyXq1cCyK+6dJyHMTeGGdTut7E=; b=bK+wXM+haPRWRxIFvD1kOAE7fi
	BHg58DnOSrYK0GjV6WEZsNp0dKFYnUyA2DeS+umt3+mm9tej/x3hiGTLAGSebwPTZlBs3WJSJBBSK
	rCLdiKEzlTaF6PmSgciljXl7+cUhzbBEZ6Fpwm7g9Siubbrge5Q4e7zKburF4Wusd9h0=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK8-006LeO-0N
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 24/29] mt76: mt7915: trigger L1 SER on PLE MDP RIOC hang
Date: Fri, 24 Jul 2026 12:48:08 +0000
Message-ID: <20260724124813.3961474-24-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chad Monroe <chad@monroe.io>

WM firmware can enter a partial failure state where RX is hung.

Detect this condition by monitoring SER_PLE_ERR_1 for MDP_RIOC_HANG_ERR
and trigger L1 SER to restore operation. Use transition detection on the
error bit to fire only once per new occurrence, preventing an infinite
SER loop when the bit remains set across checks.

Signed-off-by: Chad Monroe <chad@monroe.io>
Suggested-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    | 13 ++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 350d4573ced2..df6359c88b18 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1934,7 +1934,7 @@ void mt7915_mac_update_stats(struct mt7915_phy *phy)
 static void mt7915_mac_severe_check(struct mt7915_phy *phy)
 {
 	struct mt7915_dev *dev = phy->dev;
-	u32 trb;
+	u32 trb, ple_err;
 
 	if (!phy->omac_mask)
 		return;
@@ -1954,6 +1954,17 @@ static void mt7915_mac_severe_check(struct mt7915_phy *phy)
 				   phy->mt76->band_idx);
 
 	phy->trb_ts = trb;
+
+	ple_err = mt76_rr(dev, MT_SWDEF_PLE1_STATS);
+	if ((ple_err & MT_SWDEF_PLE1_MDP_RIOC_HANG_ERR) &&
+	    !(dev->ple1_sts & MT_SWDEF_PLE1_MDP_RIOC_HANG_ERR)) {
+		dev_warn(dev->mt76.dev,
+			 "band%d: PLE error 0x%x detected, triggering L1 SER\n",
+			 phy->mt76->band_idx, ple_err);
+		mt7915_mcu_set_ser(dev, SER_RECOVER, SER_SET_RECOVER_L1,
+				   phy->mt76->band_idx);
+	}
+	dev->ple1_sts = ple_err;
 }
 
 void mt7915_mac_sta_rc_work(struct work_struct *work)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 92e0f9f0169c..0f7e871dc7a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -296,6 +296,7 @@ struct mt7915_dev {
 	spinlock_t reg_lock;
 
 	u32 hw_pattern;
+	u32 ple1_sts;
 
 	bool dbdc_support;
 	bool flash_mode;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index 307bf6a75674..dc7bb9a1f223 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -1044,6 +1044,7 @@ enum offs_rev {
 #define MT_SWDEF_SER_STATS		MT_SWDEF(0x040)
 #define MT_SWDEF_PLE_STATS		MT_SWDEF(0x044)
 #define MT_SWDEF_PLE1_STATS		MT_SWDEF(0x048)
+#define MT_SWDEF_PLE1_MDP_RIOC_HANG_ERR	BIT(3)
 #define MT_SWDEF_PLE_AMSDU_STATS	MT_SWDEF(0x04C)
 #define MT_SWDEF_PSE_STATS		MT_SWDEF(0x050)
 #define MT_SWDEF_PSE1_STATS		MT_SWDEF(0x054)
-- 
2.53.0

