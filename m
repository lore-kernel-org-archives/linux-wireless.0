Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8B446D2C2
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660025; cv=none; b=UbJu4IGiFr3zQc8i4k8JgOfN+cVVckzygS1jueoHtBUwM6z69R3d/gVswh31dqIEJvjDvpTpP9ueNkyq3j7FPyNRyLsCgdgK4xFY4swhxEjQtLTlup3AdBHqSvr4vcb2CeQ66St1olqQe3tFwpiSyLslPjheVsp72RGcschY1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660025; c=relaxed/simple;
	bh=72cHbSO0wpO4kk1gn+rm1p7EMLt6EFoNMK/eGupDark=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QPjFN6TPQs3twgNNVUTIIAevu1k+ADntDOE1XJEFnFgu4qIcHU1QGOeptjmO2wYDonuHRngHm+0DH3FUVaUyA4ZP1F13ww/v1Yi9Wd4MhS7FA/TyIMXitNldkAm+osrNJUPbHlbiDAqIgfky5Rdz0JYKm8zDdrir+hRLIDQzFkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Z52KUHzp; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Z52KUHzp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gSjIvv5Z0C9Wxv37sHE4wyC0dex8W7S8VcUMfveb5io=; b=Z52KUHzpJOl4jZo9lRSNlKwdO3
	RkW/amVJaqzDbTQgwCzelMHljQz7FGmhshsJOCIo1Wt4I6sZRPTqPlhSTN+IFZHdkbJpgbujtJGJR
	0krMRalsi8bQzWn4Ah3tO+NCF7owye4kQDFt9QRazrV4SQsPeL50oxuxLvPo0kAo9Oek=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmFax-004vjF-1v
	for linux-wireless@vger.kernel.org;
	Tue, 21 Jul 2026 20:53:35 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations
Date: Tue, 21 Jul 2026 18:53:32 +0000
Message-ID: <20260721185333.2419297-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chad Monroe <chad@monroe.io>

A non-MLD station's EAPOL and data frames are tagged with link_id ==
IEEE80211_LINK_UNSPECIFIED, which now skips the per-link lookup in
mt7996_mac_write_txwi() and leaves omac_idx/band_idx/wmm_idx at slot
0. When the radio also runs AP VAPs the station's omac is non-zero
(get_omac_idx() prefers HW BSSID slots 1-3), so its EAPOL frames
egress from the wrong BSS and the 4-way handshake times out even
though association succeeds.

In mt7996_tx_prepare_skb(), resolve the link from the peer wcid when
link_id is UNSPECIFIED and the wcid is not the global entry, restoring
the pre-MLO behaviour for station traffic.

Fixes: 729c83a3330c ("wifi: mt76: mt7996: fix reading zeroed info->control.flags after mt76_tx_status_skb_add()")
Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 6df51394a26d..e77e48186cb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1030,6 +1030,11 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 				       IEEE80211_TX_CTRL_MLO_LINK);
 	}
 
+	/* non-MLD frames are LINK_UNSPECIFIED; use the wcid's own link */
+	if (link_id == IEEE80211_LINK_UNSPECIFIED &&
+	    wcid != &dev->mt76.global_wcid)
+		link_id = wcid->link_id;
+
 	if (link_id != wcid->link_id && link_id != IEEE80211_LINK_UNSPECIFIED) {
 		if (msta) {
 			struct mt7996_sta_link *msta_link =
-- 
2.53.0

