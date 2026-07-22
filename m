Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3978A1DDC35
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708783; cv=none; b=DfcxH12BxHx5MHnPlzcRBVQ1eJAlxwP6x+VZjuSj+RmvT3vWuEtL6yvLwO2xXxyg+4oXsR+YuNSC5Q/mOK1fGI4+mtKQnCKsimfO9l1Bn4nDrtunkNQrQIhrQrlFwca+B1/YtNIYRGHtaB/XfdX5Kx9Sz96YICyoXOv78w1Om6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708783; c=relaxed/simple;
	bh=NE1DEPydotd/RWndW40YiQs02Tor804UiRo6zNb3U8c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBgpirbdJKtdTdPMP4t/ld37hOS2nBkbGMgzDWuvhE2EKEaCUnaGQeYDlIidZcMlkszEmryeSaSg7BoidJ6tXjDpXnDDTeM3Y52dvNUPXFYghVSgJdIks6WDOobh72jWQWrsCw/nSy4Qv2QK1dllcv5OfP2IEGMyfcpAOnGZObo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ANvNoufW; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ANvNoufW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j0lNtk4qw5OQfooW2mIv1/H+sgG1SbG/6bz9akEDi8M=; b=ANvNoufW7vaD3DANjrWr9aEdGp
	hl3wKvYHadU6bAKlbkz6Me7XRlzbz4mgYChe+hTVQA4oy9pwqsANvFCLXN2Sh1RT1N8QJ64REjpon
	Ka633PGC9oqLHkLLGj9pPS02ylueR3/z/TG7OvmGtX50bPosu/gjLi+H6/CteOeWPCcI=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHQ-005AHx-2i
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 12/18] wifi: mt76: fix 4th chain ACK RSSI bitmask in sta_poll
Date: Wed, 22 Jul 2026 08:26:04 +0000
Message-ID: <20260722082610.2699628-12-nbd@nbd.name>
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

The per-chain response-frame RSSI values are packed one per byte, but the
4th chain was extracted with GENMASK(31, 14) instead of GENMASK(31, 24).
The wrong mask overlaps chains 1-3 and shifts by 14, producing a garbage
chain-3 value that corrupts ack_signal/avg_ack_signal on 4x4 radios.
Extract the correct byte.

Fixes: a71b648e3527 ("wifi: mt76: mt7915: add ack signal support")
Fixes: ea5d99d07fbf ("wifi: mt76: mt7996: enable ack signal support")
Fixes: 67fc7a304bf5 ("wifi: mt76: mt7921: add ack signal support")
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 19f807aa3d2f..10cb56284a11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -221,7 +221,7 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		msta->ack_signal =
 			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 95c198df26c2..0453af05cf85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -156,7 +156,7 @@ static void mt7921_mac_sta_poll(struct mt792x_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		mlink->ack_signal =
 			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index d3553f4f8a48..8cca9f7a7ded 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -152,7 +152,7 @@ static void mt7925_mac_sta_poll(struct mt792x_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		mlink->ack_signal =
 			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 4ba088e8907f..531b5bee3f48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -166,7 +166,7 @@ static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		mlink = rcu_dereference(msta->vif->mt76.link[wcid->link_id]);
 		if (mlink) {
-- 
2.53.0

