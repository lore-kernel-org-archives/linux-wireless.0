Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCD04315A
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708782; cv=none; b=tpeDXLneO8zb3ZEhUy9feTa51axH/w7f+bPQDmG1aiYFd/iCTJKurwoA07gJp6TrMgFD4aMlbKkH3t5RRsJZqK/yOglcc11gDps7wCkDJkh7nwxWGTafMIFKesb1UhMoOK+pbTLUWCR33HgczabWtkhscmwUlmohh297hxwrW10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708782; c=relaxed/simple;
	bh=xHLSVrPqQ6tO0C4jCjBtS/elzCjOBywDQW80S7tN+6g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QENdtDEckUYi8govodM+FKtumNPMPDraiPEToanoxujOzreAa0RwlUZDxAwFblnq535DOGYIX6lgfiLBitCSOCXZ2eLDIkwl3Jgpz8KQk8IvmHpU5xDNJRNaT6cVBy7VxIJVChsQsOsbOFpc5G7Wva7ZIuDjryqFd9V81+EhjGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=i2/vEZ9P; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="i2/vEZ9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZxE+P2V1NYLwyoXuTXkVDEhnJ2qbPyhLdMaDi3vuj+w=; b=i2/vEZ9P8EXEmr/8W0GNFabLWX
	ObXYR6RdfOjxhkmMpMwW0SkouHiuaL78EwiYX9Knkinx86vXZbHuIxPYYoZc6WqplhUmyjhe927wx
	jqAeGWkSkfZXSA3ayDX3+rwMduGKqAnjS2uLCI+By81bxuOL6ksBr6KDSbzIyQiSBC00=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHP-005AHx-2F
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 05/18] wifi: mt76: assign link_id when sending probe request during scan
Date: Wed, 22 Jul 2026 08:25:57 +0000
Message-ID: <20260722082610.2699628-5-nbd@nbd.name>
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

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

The link_id in info->control.flags is required by mt7996 to select the
correct mt76_wcid for transmission.

Not assigning the link_id in info->control.flags is equivalent to
assigning the link_id to 0, causing mt7996 to select link_id 0 for
transmission, so probe requests sent on behalf of an MLD vif scanning
via a different link were transmitted with the wrong per-link wcid.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 3895d080475f..3cb11689d4bf 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -55,6 +55,7 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 	struct mt76_phy *phy = dev->scan.phy;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
+	u8 link_id;
 
 	skb = ieee80211_probereq_get(phy->hw, vif->addr, ssid->ssid,
 				     ssid->ssid_len, req->ie_len);
@@ -84,6 +85,10 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
 	info->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
 
+	link_id = mvif->wcid ? mvif->wcid->link_id : IEEE80211_LINK_UNSPECIFIED;
+	info->control.flags &= ~IEEE80211_TX_CTRL_MLO_LINK;
+	info->control.flags |= u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
+
 	mt76_tx(phy, NULL, mvif->wcid, skb);
 
 out:
-- 
2.53.0

