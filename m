Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533148987A
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372279; cv=none; b=YKiy1rDmw4Dq4Uy0Y7ZZI2GIFUtp+dbf3xbqGbfqoFqvn5AnVCgqB2tkzPLNI+Bj2fm1g0wxsYmrjh61TZn6GmjITlQW6hDKvfQ2zN6CqtwIqtet+ali/yhodz0ww4PuYPEN+pqwdOtvTR9y8egnCC382A3nkc/1boonmGpLEec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372279; c=relaxed/simple;
	bh=DF+aFErTLbn8VamJ9eBxxN/Ex7EC3yNxmYlHLUvtqQ8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvGYOZAC4HRpGuy9nK0TUFASuUwa2LQ3/cU3163y7cTsUFvxaDQUrblm10t4GFOHr1RlOyp7dn2Vlg7eX7ZYDG63vWA3rSYR805JgmwVDjtqfk07SUS49WEDdEHlsvVlGGQ76HhyPDzxk4RaMJkvN7vcRPwZ+O4IZ76HN0IgMH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=HtQGpmIy; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="HtQGpmIy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zaiTUUaJIuV4yAa/M+JCsT6KgrioVu08hFOi3aFNowM=; b=HtQGpmIyXbPqHndgpx/TO4ij3A
	qCD5+beoUyTeu3uvtHf0Uw3txxfDRo2KFwV6/vkTVZ9KnUfsqOseyyu1yyx1DzlqYrLh5NJaCeCLl
	zYcTgYqKP3niHs0zIo1hgEz2UEpvDl8CA8Ltt8RNT5KdMwKHyVonN3bTr/kKKflLz+gE=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl1-00HY5A-1M
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:23 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 4/9] wifi: mt76: mt792x: compute the assoc RSSI from the chain signals
Date: Wed,  7 Oct 2026 13:24:14 +0200
Message-ID: <20261007112419.1277594-4-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007112419.1277594-1-nbd@nbd.name>
References: <20261007112419.1277594-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt792x_mac_rssi_iter() adds status->signal of auth and assoc response
frames to the BSS RSSI average, which mt7921_mcu_sta_update() and
mt7925_mcu_sta_update() send to the firmware as the station RCPI.
mt7925 never sets status->signal, since mt76_rx_convert() computes it
from the chain values later. The average is thus fed 0 dBm on mt7925.

Compute the signal from the chain values, as mt76_rx_convert() and
mt76_check_sta() do, and skip a frame without a valid chain signal. On
mt7921, the average now follows the combined value instead of the
strongest chain.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
index 1e20b333cc61..ebf4c32924c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
@@ -165,14 +165,16 @@ mt792x_mac_rssi_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct ieee80211_hdr *hdr = mt76_skb_get_hdr(skb);
+	int signal;
 
-	if (status->signal > 0)
+	signal = mt76_rx_signal(status->chains, status->chain_signal);
+	if (signal > 0 || signal <= -128)
 		return;
 
 	if (!ether_addr_equal(vif->addr, hdr->addr1))
 		return;
 
-	ewma_rssi_add(&mvif->bss_conf.rssi, -status->signal);
+	ewma_rssi_add(&mvif->bss_conf.rssi, -signal);
 }
 
 void mt792x_mac_assoc_rssi(struct mt792x_dev *dev, struct sk_buff *skb)
-- 
2.47.3

