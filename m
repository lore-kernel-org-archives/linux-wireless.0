Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5742141DDEE
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164691; cv=none; b=AL9Wh1FdKRYmX2xMaF2TksEaAen0rgm/glFICpzHV7lKEGbuQrnFwxAWICCltb/ZkecRpI4QrCcWls4PXKCFhTJ+xDDvTDVQLvsxnPhnMm8tgvpT9yLCJzJgmZpSK4vfV8dPBqMjHqrjPE31028zl7OD6OA7cG+Kar4gRReKOqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164691; c=relaxed/simple;
	bh=3nDkTwAc6+GwxPIXFOuLq9nMm3fD+SO/pBwwD3mSvYI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA87A+rmivBYOfkrZcQlM5Qs0efoJlfPS0TmbVk6on1CVF1WL8TIoCiVcPjkDnWYZqfiBmL+2LiBeE9df2wEGx2Gf2+lNYgWrDVhqX6x7Fen7g3XyZNWQbr6LJCJCH03J7Hs2Q6bKPvknZvIJYUIcqtGDKKon9UnaGk2U5Zs/Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=l0jav9Au; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="l0jav9Au"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pXM+jVwLEStZnTolM/NYPklhcKIW8iQM6cmN7Dm5wLQ=; b=l0jav9AuBY0gx/T96zAZSK7PAS
	W8GyMrJ8K+U9YLi7TJFxVpdynq8ryP1s5bchF9rHqZIcAM0XaZJYoOh7BTbgcd5EtVuWdPPkfpXnJ
	jXeSW/QDkwkED3dM4dIkIaivCMBHwbCrE0u9iacMkIq4gZoOjHJ1G16d2Blp6+bP/vU8=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsk-008KN0-2d
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 09/15] wifi: mt76: mt7915: report RX chain signal for all RX paths
Date: Mon, 27 Jul 2026 15:04:28 +0000
Message-ID: <20260727150434.1778520-9-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

status->chains was set from the antenna mask, which is derived from the
number of spatial streams, while the chain_signal array is filled from
all RCPI fields. On boards where the number of RX paths exceeds the
stream count, e.g. the 3T3R mt7916/mt7981 variant with 2 streams on the
5 GHz band, the RSSI of the extra chains was never reported.

Use the band local RX path chainmask instead.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index df6359c88b18..b3d4abf6a9ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -437,7 +437,7 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb,
 		if (v0 & MT_PRXV_HT_AD_CODE)
 			status->enc_flags |= RX_ENC_FLAG_LDPC;
 
-		status->chains = mphy->antenna_mask;
+		status->chains = mt7915_band_chainmask(phy);
 		status->chain_signal[0] = to_rssi(MT_PRXV_RCPI0, v1);
 		status->chain_signal[1] = to_rssi(MT_PRXV_RCPI1, v1);
 		status->chain_signal[2] = to_rssi(MT_PRXV_RCPI2, v1);
-- 
2.53.0

