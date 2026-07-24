Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49730C606
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897300; cv=none; b=Vjdmabl3y7mNcY8LpH0EyomOjiW9LtUXsp4TDOgRvblzr24/Tr5AkXNJmoSG+GOkTjkzN/Yrf6h28LYUwxK6i6nwcXVbxwdjTGssn5VWW7UlCyX4yV8CgMXUDTFyOVJQM7JEnwGFcA0WIydZ17p9n+rVDM9q+rH4ZQfq7yYvm9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897300; c=relaxed/simple;
	bh=2ZMxSZrggo3Q+7K2Y57CPKOUJ7dQGDTLMvzU82GWbzU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5bdZU5uUZnsvdfxUQmyDcK1Mcph04y3bBmUwiyvbKxBTKPaHpPaEiy2nwrhqojKt2j86tZJtm0Xy7RXpQdiQySVcmbwm0pqMu+4zV20AkH0lSnagi78WSof45A+PF3/hgn1oAjIRJwQEp5mSUE94s6zFKryDziwvxQM2NLWlP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=dJEMGkYL; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dJEMGkYL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vP4iMbmA00rJxFCZOZKUsog/s15OqPHHmDk+oD2fXks=; b=dJEMGkYLaQHtiUz0Vf9KfjNezp
	xUfo5K+/5DXqqlmCw6QgPuxmUdklTRAf98baf5r4EI3zteHlR8pv+msdl94kXoE/KaPj4QMwJGFTl
	qoJgmYawoDNBhD24+CPqE8ZZJub7qxbKwb0/EFbF8V72p0qqu+ac+UWzaooWCrXiokDk=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK5-006LeO-1K
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 11/29] wifi: mt76: report data NSS for STBC frames in RX rate decode
Date: Fri, 24 Jul 2026 12:47:55 +0000
Message-ID: <20260724124813.3961474-11-nbd@nbd.name>
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

The RX rate decoder set status->nss straight from the PRXV NSTS field,
which for STBC frames is twice the data spatial-stream count. cfg80211
then reported a doubled RX bitrate in station dumps and radiotap. Halve
nss for STBC, matching the TX status path.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: d832f5e73815 ("mt76: connac: move mt76_connac2_mac_fill_rx_rate in connac module")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c      | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index cbf6a987cf90..8a8d608dd56e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -1069,6 +1069,10 @@ int mt76_connac2_mac_fill_rx_rate(struct mt76_dev *dev,
 		bw = FIELD_GET(MT_CRXV_FRAME_MODE, v2);
 	}
 
+	/* the hardware reports NSTS; report the data NSS for STBC frames */
+	if (stbc && nss > 1)
+		nss >>= 1;
+
 	switch (*mode) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 866752f2fa24..4449dde33f4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -294,6 +294,10 @@ mt7996_mac_fill_rx_rate(struct mt7996_dev *dev,
 	dcm = FIELD_GET(MT_PRXV_DCM, v2);
 	bw = FIELD_GET(MT_PRXV_FRAME_MODE, v2);
 
+	/* the hardware reports NSTS; report the data NSS for STBC frames */
+	if (stbc && nss > 1)
+		nss >>= 1;
+
 	switch (*mode) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
-- 
2.53.0

