Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E08119B5A3
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059585; cv=none; b=Iw/fARipNcJpf/wjgRa0SzznvXNHogSfIUtuFYiqx/gkg1KSlrzLZyQ83sxYxHgoe3n/jxbrNPYGvFcRA4aoTW2aeFZJ+1hMUgFfzNBfQkeVvfHnj6CYfJ//SZ2diMlG7fr7nxRkaBrJ0K3HACw5Y016UJML2tWP+f60ox4DYlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059585; c=relaxed/simple;
	bh=UtZiPKdYKAUc/hLtK2s91N8t1c1i0MtLtCJnjTf1NbA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv+p0TXpT7iev9WZ2tF3qPaooHhjXCrxCsjCpMShYZqIC2OslwpHtg5DVNHlLhbexV5Ph6SiQBNor5M10eTGC/vXoy1V1mQu1HUI30M4/lnFoTOZB/KBjmM9SQccrqZZSDJLfl5hrY27tdKqCH7kh1S0wlmfXMIrxRjipTF+zoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=eDRUeUQm; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="eDRUeUQm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dTHSxlz8jedZ+E53Zq+cS/BwTTmEO4BV6E/aLqNi8DA=; b=eDRUeUQmfPxU0X8d/XHRQ++7QL
	YKAGWbHiNQ0xHY4qF1ykF+4dl0mzbhoLiZfF5jI/pBaLQyBio2LC9lzBgRqlVpBfLONo7VV55DjT+
	6IJtaSRD6L3mqfxGwW37mezqazwFrQ5/WTdx+N8ETCX1KlDkstfgQwLciZD6fox20nxM=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wwJOd-002b0i-2f
	for linux-wireless@vger.kernel.org;
	Tue, 18 Aug 2026 14:58:27 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 3/5] wifi: mt76: mt7996: take over connection monitoring
Date: Tue, 18 Aug 2026 12:58:23 +0000
Message-ID: <20260818125825.395538-3-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818125825.395538-1-nbd@nbd.name>
References: <20260818125825.395538-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76 runs its own beacon monitor. mt76_beacon_mon_check() counts a miss
for each affiliated link of an MLD, and it stops the count while the phy
is off channel. mt7996 supplies it through mt76_rx_beacon(), but it does
not set CONNECTION_MONITOR. Therefore mac80211 also starts its legacy
monitor.

The legacy monitor knows one interface, not a set of links. It also
counts while the radio serves a different link. After seven beacon
intervals it removes an association that still carries traffic on the
other links.

Set the CONNECTION_MONITOR flag to disable the legacy monitor.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index fb635a092584..2db63c3be9d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -540,6 +540,7 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
+	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 
 	hw->max_tx_fragments = 4;
 	wiphy->txq_memory_limit = 32 << 20; /* 32 MiB */
-- 
2.53.0

