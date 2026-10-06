Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483C74A1E1F
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320386; cv=none; b=eMskaxDi3Q4LsoplnnE8SJUABBgIQrDVS+Qrdhw7uK+WgMYN9cXxJ+IfnhttjwFHtCptJHIi35CAcBJNASzWYHDEUKi0q7RW0v29Q6d1N8krwK2ENl7mvkioaR2mhWimbON5HKVBWwZmDA8zCUtr1PaaGjiVy6+/qv1k/kCw4dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320386; c=relaxed/simple;
	bh=T+ee6gpmb7/pdmxMM6Fp1h2XD1SSNS1HHPloTxFNW8w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIdtEL04sds746KEAMY0NOeMETuRAwhheuaue9NiWxw/WisZ6XNXtWnECNATBt0NreGqU7HVCg9u+uWovcVaxF46pjeVfsIR9jsmIbHqQw8OuBJtStL5xKqNh1//beDqokwF+kU9nNfQqNsqFOk4sV9uyffsY80eBbBW80OhMS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=MC39iZ15; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="MC39iZ15"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EJiQR2+pIw1T/6WJkcopeKIcfNEmefSN+CYh7+3ItRw=; b=MC39iZ15ELM5iZ5MEWld1NZZJd
	utxRjE+EUKFbmTzkWjgvhnBd4cyMrNCMaVxGgr1RXCsMBN5qC7jYip0eaM01Tpd/YuD53do+uWFu7
	YEYTJC2gTtGAQHJIlOoiVHE13N0APFii65GaveKf0POXzx4gO3cYyPGmOXxbgDm10AtY=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGE-00HAg3-0y
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 17/27] wifi: mt76: mt7996: keep 4-address and decap state per station
Date: Tue,  6 Oct 2026 22:59:26 +0200
Message-ID: <20261006205936.669125-17-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211 reports 4-address mode and decap offload once per station,
through sta_set_4addr and sta_set_decap_offload. mt7996_sta_set_4addr()
and mt7996_sta_set_decap_offload() set MT_WCID_FLAG_4ADDR and
MT_WCID_FLAG_HDR_TRANS only on the links that exist at that moment, but
the hardware keeps header translation per link. A link that is added
later starts without the flags, and a link that is removed at that time
keeps its old flags when it comes back, so the firmware gets the wrong
to_ds/from_ds pair for that link.

Keep both states in the station, and apply them to a link when the
callbacks run, when the link is set up and when it comes back.

Fixes: f520eceacd24 ("wifi: mt76: mt7996: Add mt7996_mac_sta_change_links callback")
Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 29 +++++++++++--------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  2 ++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d868e9641334..bba5a8c6dec8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1155,6 +1155,16 @@ mt7996_sta_deflink_set(struct ieee80211_sta *sta, unsigned int link_id,
 	mt7996_sta_init_txq_wcid(sta, idx);
 }
 
+static void
+mt7996_sta_link_hdr_trans_set(struct mt7996_sta *msta,
+			      struct mt7996_sta_link *msta_link)
+{
+	assign_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags,
+		   test_bit(MT_WCID_FLAG_4ADDR, &msta->wcid_flags));
+	assign_bit(MT_WCID_FLAG_HDR_TRANS, &msta_link->wcid.flags,
+		   test_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid_flags));
+}
+
 static bool
 mt7996_sta_deflink_busy(struct mt7996_dev *dev, struct mt7996_sta *msta)
 {
@@ -1261,6 +1271,8 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	if (link_sta->sta->tdls)
 		set_bit(MT_WCID_FLAG_TDLS_PEER, &msta_link->wcid.flags);
 
+	mt7996_sta_link_hdr_trans_set(msta, msta_link);
+
 	ewma_avg_signal_init(&msta_link->avg_ack_signal);
 	ewma_signal_init(&msta_link->wcid.rssi);
 
@@ -1381,6 +1393,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
 		if (msta_link) {
 			msta_link->wcid.link_valid = true;
+			mt7996_sta_link_hdr_trans_set(msta, msta_link);
 			if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
 				mt7996_sta_deflink_set(sta, link_id,
 						       msta_link->wcid.idx);
@@ -2166,6 +2179,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	assign_bit(MT_WCID_FLAG_4ADDR, &msta->wcid_flags, enabled);
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
@@ -2178,11 +2192,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 		if (!msta_link)
 			continue;
 
-		if (enabled)
-			set_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags);
-		else
-			clear_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags);
-
+		mt7996_sta_link_hdr_trans_set(msta, msta_link);
 		if (!msta_link->wcid.sta)
 			continue;
 
@@ -2212,6 +2222,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	assign_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid_flags, enabled);
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
@@ -2224,13 +2235,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 		if (!msta_link)
 			continue;
 
-		if (enabled)
-			set_bit(MT_WCID_FLAG_HDR_TRANS,
-				&msta_link->wcid.flags);
-		else
-			clear_bit(MT_WCID_FLAG_HDR_TRANS,
-				  &msta_link->wcid.flags);
-
+		mt7996_sta_link_hdr_trans_set(msta, msta_link);
 		if (!msta_link->wcid.sta)
 			continue;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 03fc0e7fd4f1..949e659b8e2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -269,6 +269,8 @@ struct mt7996_sta {
 	u8 deflink_id;
 	u8 seclink_id;
 
+	unsigned long wcid_flags;
+
 	struct mt7996_vif *vif;
 };
 
-- 
2.47.3

