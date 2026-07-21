Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC95B46D2D2
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660026; cv=none; b=rCWAucdtCsg1/t6yYvm/3jgnL7cZ7mJRuVXz1lBebgG2G19eu9rtBxUEZ1tb77IB3XI7nqZAKjxxnvuX5XJMC0Bija6MX7dqlJ6pQIi67YPMpjtNoSbqJP74JPcZzUCk/54FeTUzuL3wTdQ60rc7VB/eC+T7zvMSJ8qg3akXobE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660026; c=relaxed/simple;
	bh=TYbxyV54QugVmzqHcqPQzoADYNVLjbbNGzgkmHZx2+k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZhXQpOny0xRnU0T6dmBAgon8ND5fiUrYEuf2y+lYk0grVHEfNk9JFGfwLpF7q9w1xxR/dgimXLTKtL+VcDCpcblca2t1pc3wBRx23Nr21G0wl/MtY0Rajwjsj3wf4XDqfQWOebu+830PH+7wlFgnurNeyWQOiuNOb81Ge/03ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=XRX/NF5+; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XRX/NF5+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=phi7F0miJdCC8iv3FFSzVva1fso0s9LXsDN6HzL/ZE4=; b=XRX/NF5+FyFWtJfwKafHItcVtl
	+Wt0e4vi5kv7EwlaIzENZtv2BPp41Ufk8RZpHjr+1C9C3q0dmbNmGUDuKkSgDV/8ySon3pA6CU9Ej
	5ozd6g11qxVH3EtHDXBooKY++fZvcCc4ncxTLIt224cI+UzTvl3EADmyJH4GGr3HisHw=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmFax-004vjF-2U
	for linux-wireless@vger.kernel.org;
	Tue, 21 Jul 2026 20:53:35 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wifi: mt76: mt7996: fix non-MLD station num_sta leak
Date: Tue, 21 Jul 2026 18:53:33 +0000
Message-ID: <20260721185333.2419297-2-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721185333.2419297-1-nbd@nbd.name>
References: <20260721185333.2419297-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chad Monroe <chad@monroe.io>

The MLO link-reconfiguration rework moved the per-phy num_sta
decrement inside a link_valid guard. link_valid is only set for
MLO links, but num_sta is incremented for every station link,
including the non-MLO deflink. Non-MLO stations bump num_sta
on association and never drop it on removal.

A non-zero num_sta forces connected-mode off-channel scanning which
prevents the directed probe exchange needed to find hidden APs.

Decrement phy->num_sta on the actual link teardown, pairing it with
the unconditional increment on link creation.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index afbcc8c7b18b..574aeac286cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1202,15 +1202,9 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 	mt76_wcid_cleanup(&dev->mt76, &msta_link->wcid);
 
 	if (msta_link->wcid.link_valid) {
-		struct mt7996_phy *phy;
-
 		mt7996_mac_wtbl_update(dev, msta_link->wcid.idx,
 				       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
-		phy = __mt7996_phy(dev, msta_link->wcid.phy_idx);
-		if (phy)
-			phy->mt76->num_sta--;
-
 		if (msta->deflink_id == link_id) {
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 			if (msta->seclink_id == link_id) {
@@ -1236,6 +1230,12 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 	}
 
 	if (flush) {
+		struct mt7996_phy *phy =
+			__mt7996_phy(dev, msta_link->wcid.phy_idx);
+
+		if (phy)
+			phy->mt76->num_sta--;
+
 		rcu_assign_pointer(msta->link[link_id], NULL);
 		rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx], NULL);
 		mt76_wcid_mask_clear(dev->mt76.wcid_mask, msta_link->wcid.idx);
-- 
2.53.0

