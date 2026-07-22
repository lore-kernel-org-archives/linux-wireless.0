Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366CC30ACF0
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708783; cv=none; b=XBNTQRgdUmTJI+rtHj8OFll3lTLVA8I15r2PbfolIZSHCtZTJ5XoNjlAhJZc9PKg6zXhCm0ZJEX/zFBYi9RIP78aFRs5sqftFXZJIC6bMAYF4YqjBOH7EqqNuwf/m9ICJQPgu38eDVn8CJ755NNwcTCfRxm9ENJTxCqY6O20oWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708783; c=relaxed/simple;
	bh=TRrpkg56XA5Du42A/3yZdcelTN4ixhyvT8UeyidxS64=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyQvdIeEHsAhJAgYXVEK8Q6Kn2GhBO7oG2CM9bPV9RUgZgNELRIyndWX8r88IfGwD7n/XvZGQdMXhtu2Lt/4A93onCt2XOIqHcl+kMPSxYKYsLUFyWnR3ZCtNO5eK8KqO7IHipgXna71mpQAHIGskhknCp66ymmqInMcg9fPiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Csv4T+2N; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Csv4T+2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q+5h/U79Cbfkg0L2/SWBXM0fBJ/BAoAWy7wnuuTXcNw=; b=Csv4T+2NmP2TAvNb0yedBWlFhU
	wAUij+B/43r9DJG5oHTMlk8RiqwDFbjoT9YC3uuy61Q8PYP1w+CoRyFKk92CQo8qdpku40y6bqSdV
	b3TJJGOD6A+6ykw3Fz+LIttXzTWJpU05DvUhAw4/bwCbjVy2PehqiIymmgWkuqjMJ5Ws=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHP-005AHx-2l
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 06/18] wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
Date: Wed, 22 Jul 2026 08:25:58 +0000
Message-ID: <20260722082610.2699628-6-nbd@nbd.name>
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

band_idx comes from a 2-bit descriptor field (0-3) and was used directly
to index dev->mt76.phys[] (size __MT_MAX_BAND == 3) and dereference the
result. A corrupt or reserved descriptor value could index out of bounds
or hit a NULL phy on parts with fewer bands. Reject invalid band indices,
mirroring mt7996_rx_get_wcid().

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index eea53aa55e4f..28a69c8c1fd3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -445,7 +445,13 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	memset(status, 0, sizeof(*status));
 
 	band_idx = FIELD_GET(MT_RXD1_NORMAL_BAND_IDX, rxd1);
+	if (!mt7996_band_valid(dev, band_idx))
+		return -EINVAL;
+
 	mphy = dev->mt76.phys[band_idx];
+	if (!mphy)
+		return -EINVAL;
+
 	phy = mphy->priv;
 	status->phy_idx = mphy->band_idx;
 
-- 
2.53.0

