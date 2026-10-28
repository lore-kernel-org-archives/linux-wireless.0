Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190257;
	b=v/j6takSUab/bA1nY4QJewUXSJu5lxJb2xbvJ0nES5joTaiTcWCyABYQYujn0/aaPT/d
	 xJmGrDZVH/AgI4Gnl36536nxSTGNeHloXKuwjwKzUsji9ECGEQezcWwYNV4Csm/WauzI4
	 le0sUp1Fh4KF9gh0nxTUG69PxQ7GOmFe2QM69YWEB5qqbsdVOQ15c6jgPVA4YPTEMW1F2
	 SUVQ+aj0utNvU4q18w+ZBy/jIofCb2QqoKrCIqPMDsr2fYXjeWKFHQo41ZdCB92yWFuSC
	 ZobV6qAvaGT1cEpj0N8VC1CzP1DK83I5ewiDzPQUHh1fRi1goS2UDrdb3sJZSbIJNcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190257;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DG0luWcBfQWIMODHMFJU1ZAQ85XYfsZLy/J0XWbpVe4=;
	b=OS557QKmvhzlE4JBrMXHpLlL6XTzMgoExlw7jZCztsZ3Hq2ILaJEH8zk5X8BHI2xwYdH
	 5ntbaogYzMvSCGJFq9PXRSKMgeIeS4x016xmm38RZVwtFCcuoLVQBkkn/w2ZDSvAURb5Y
	 lN10bIMggiqwJZxIkKRYN1UJNja3fdUAKBN4V/M946aJurBHVnDCGUa3wwDP+vjVCFHyT
	 TlEKRjk37smn7YAPlqivqEIgn9+7gMTVrnKaFv4gyQMM2ZbC+W5m4SC63X2c58oq0yr7+
	 C7AFuXwjfG/F9dbcfmtZc6KDzYZoP83nqBJv2DxaNk+1aH8uiSlNCBRi0yhoKbZY45g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b="ln/S4D/F";
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DDD606A337
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27DDD606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=ln/S4D/F
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DG0luWcBfQWIMODHMFJU1ZAQ85XYfsZLy/J0XWbpVe4=; b=ln/S4D/FO/trJ9i2oY03ZuVuPI
	6rUbtRjSUS7JYOTzrFWC6teAJtTvzOrKl+x+TXvoEMhAxM5Mp4IAhxliqmGx4ukKSFQw9keThqRCT
	OUOJNIL2i54UN03xzf8LSB2+wYuYpKrUZvAyTGcWxdkW+zsR4Zn3XellM8lGWBQ4hvt0=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hN-00C8Bw-29
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:09 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 21/25] wifi: mt76: mt7996: keep rx header translation off while a monitor runs
Date: Wed, 28 Oct 2026 13:23:59 +0100
Message-ID: <20261028122403.796394-21-nbd@nbd.name>
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

MT_MDP_DCR0_RX_HDR_TRANS_EN is one bit for the whole chip, but
mt7996_set_monitor() writes it from the state of one radio. When a
monitor interface goes away that covers a radio no other monitor
covers, mt7996_remove_interface() turns sniffer mode off on that radio,
and header translation comes back on while a monitor of another radio
still runs. Frames translated to 802.3 do not reach monitor interfaces,
so that monitor stops receiving the data frames addressed to the
device.

Turn header translation off while any radio of the device is in monitor
mode, like mt7915_config() does with dev->monitor_mask.

Fixes: 947d63d8cd3b ("wifi: mt76: mt7996: Disable Rx hdr_trans in monitor mode")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 6815f5192116..ec7c5e8f3fda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -612,6 +612,17 @@ static void mt7996_phy_set_rxfilter(struct mt7996_phy *phy)
 		mt76_clear(dev, MT_WF_RFCR1(phy->mt76->band_idx), ctl_flags);
 }
 
+static bool mt7996_monitor_active(struct mt7996_dev *dev)
+{
+	struct mt7996_phy *phy;
+
+	mt7996_for_each_phy(dev, phy)
+		if (!(phy->rxfilter & MT_WF_RFCR_DROP_OTHER_UC))
+			return true;
+
+	return false;
+}
+
 static void mt7996_set_monitor(struct mt7996_phy *phy, bool enabled)
 {
 	struct mt7996_dev *dev;
@@ -632,7 +643,7 @@ static void mt7996_set_monitor(struct mt7996_phy *phy, bool enabled)
 	mt76_rmw_field(dev, MT_DMA_DCR0(phy->mt76->band_idx),
 		       MT_DMA_DCR0_RXD_G5_EN, enabled);
 	mt76_rmw_field(dev, MT_MDP_DCR0,
-		       MT_MDP_DCR0_RX_HDR_TRANS_EN, !enabled);
+		       MT_MDP_DCR0_RX_HDR_TRANS_EN, !mt7996_monitor_active(dev));
 	mt7996_phy_set_rxfilter(phy);
 	mt7996_mcu_set_sniffer_mode(phy, enabled);
 }
-- 
2.47.3

