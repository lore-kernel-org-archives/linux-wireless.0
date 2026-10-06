Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FD64A4F0A
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320389; cv=none; b=MiLmHwqw3f0j8SRcKEimYZDcl+ewhlnpc1bq6ttgg9dceWmHIAOIuqWeBAt4H8YEhiXl5SQiTr6o5tBwu3QE9Fy3XF1vls2gLGXit8XiVo/Q5xcth56p3aCJ7JkoO5lOXFwGQe9+nFKDOURpuwJHnTiiiUrY5A7T2i6Qe/IoOv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320389; c=relaxed/simple;
	bh=OSwG5pMsePphImwOC+bhLA24XevHu0lwX96vltgpxio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bne/9R64OQo4knG6z3fcwSEgFVf+jwh91zQGiJuY/+VU1wdiaONf9G7KwHfVyWpTadI85Yic6St31+3wW6eXRDhF143ULlTcbdNkk07ZoaSk8dFiiXSTrR48RcnlG/o8r95m+mRblp1vnbfEI08QsfoPjMKEXwsECO4oCzd1l0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=cyEHUwG3; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="cyEHUwG3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hNxammmW9oI5+3XlC0jDKr2P2AYnat3ZJiHToed5rBM=; b=cyEHUwG37+0JjA/rKcPQfsWwSX
	8HTY89t9IKsmRVprOH/vscTorSPs/R1DfJpjqew9SFFRQoeCwQ3uf081XTw2aTrps9+aKBoelw/zA
	NXd74OelHw/3VdQh9bZ3E5H2EFTUznoRBTgy5yhYUhFLTWYHbK9+iruxbHHCwG8D/OKg=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGE-00HAg3-1Z;
	Tue, 06 Oct 2026 22:59:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: Howard Hsu <howard-yh.hsu@mediatek.com>
Subject: [PATCH mt76-next 18/27] wifi: mt76: mt7996: do not add a station link in disconnected state
Date: Tue,  6 Oct 2026 22:59:27 +0200
Message-ID: <20261006205936.669125-18-nbd@nbd.name>
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

From: Howard Hsu <howard-yh.hsu@mediatek.com>

Since the driver uses the .sta_state op, mt7996_mac_sta_init_link()
sends a STA_REC with CONN_STATE_DISCONNECT when a station link is set
up. Before that change, the first STA_REC for a station was the one
that connects it. MediaTek reports that DL OFDMA fails after a station
reconnects.

Only send a STA_REC for a station link when it connects. Until then the
firmware has no STA_REC for the link, so track whether a link is
connected, and skip rate control updates and the 4-address and decap
updates for a link that is not. wcid.sta cannot be used for this,
since it is set when the link is set up.

Fixes: 13e2e9c6b348 ("wifi: mt76: mt7996: use mac80211 .sta_state op")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  4 +++
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 33 +++++++++++++------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index eb39526548e8..c4e82b1e259c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2948,6 +2948,10 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 
 		changed = msta_link->changed;
 		msta_link->changed = 0;
+
+		if (!msta_link->connected)
+			continue;
+
 		mvif = msta_link->sta->vif;
 		vif = container_of((void *)mvif, struct ieee80211_vif,
 				   drv_priv);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index bba5a8c6dec8..a23d148eafa6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1229,7 +1229,6 @@ mt7996_sta_seclink_get(struct mt7996_dev *dev, struct mt7996_sta *msta)
 
 static int
 mt7996_mac_sta_init_link(struct mt7996_dev *dev,
-			 struct ieee80211_bss_conf *link_conf,
 			 struct ieee80211_link_sta *link_sta,
 			 struct mt7996_vif_link *link, unsigned int link_id)
 {
@@ -1262,6 +1261,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	INIT_LIST_HEAD(&msta_link->rc_list);
 	INIT_LIST_HEAD(&msta_link->wcid.poll_list);
 	msta_link->sta = msta;
+	msta_link->connected = false;
 	msta_link->wcid.sta = 1;
 	msta_link->wcid.idx = idx;
 	msta_link->wcid.link_id = link_id;
@@ -1280,8 +1280,6 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 
 	mt7996_mac_wtbl_update(dev, idx, MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
-	mt7996_mcu_add_sta(dev, link_conf, link_sta, link, msta_link,
-			   CONN_STATE_DISCONNECT, true);
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], &msta_link->wcid);
 	mt76_wcid_init(&msta_link->wcid, phy->mt76->band_idx);
@@ -1384,7 +1382,6 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	int err = 0;
 
 	for_each_set_bit(link_id, &new_links, IEEE80211_MLD_MAX_NUM_LINKS) {
-		struct ieee80211_bss_conf *link_conf;
 		struct ieee80211_link_sta *link_sta;
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
@@ -1402,8 +1399,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			continue;
 		}
 
-		link_conf = link_conf_dereference_protected(vif, link_id);
-		if (!link_conf) {
+		if (!link_conf_dereference_protected(vif, link_id)) {
 			err = -EINVAL;
 			goto error_unlink;
 		}
@@ -1426,8 +1422,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			goto error_unlink;
 		}
 
-		err = mt7996_mac_sta_init_link(dev, link_conf, link_sta, link,
-					       link_id);
+		err = mt7996_mac_sta_init_link(dev, link_sta, link, link_id);
 		if (err)
 			goto error_unlink;
 
@@ -1515,6 +1510,7 @@ mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			if (err)
 				return err;
 
+			msta_link->connected = true;
 			err = mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
 						       link_id, false);
 			if (err)
@@ -1551,16 +1547,33 @@ mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	return 0;
 }
 
+static void
+mt7996_mac_sta_clear_connected(struct mt7996_dev *dev, struct mt7996_sta *msta)
+{
+	unsigned int link_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (msta_link)
+			msta_link->connected = false;
+	}
+}
+
 static int
 mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		     struct ieee80211_sta *sta, enum mt76_sta_event ev)
 {
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	int err;
 
 	mutex_lock(&dev->mt76.mutex);
 	err = mt7996_mac_sta_links_event(dev, vif, sta,
 					 mt7996_mac_sta_links(dev, vif, sta),
 					 ev);
+	if (!err && ev == MT76_STA_EVENT_DISASSOC)
+		mt7996_mac_sta_clear_connected(dev, msta);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return err;
@@ -2193,7 +2206,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 			continue;
 
 		mt7996_sta_link_hdr_trans_set(msta, msta_link);
-		if (!msta_link->wcid.sta)
+		if (!msta_link->connected)
 			continue;
 
 		mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link, msta_link);
@@ -2236,7 +2249,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 			continue;
 
 		mt7996_sta_link_hdr_trans_set(msta, msta_link);
-		if (!msta_link->wcid.sta)
+		if (!msta_link->connected)
 			continue;
 
 		mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link, msta_link);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 949e659b8e2d..ec453f5ff3a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -244,6 +244,7 @@ struct mt7996_sta_link {
 	struct mt76_wcid wcid; /* must be first */
 
 	struct mt7996_sta *sta;
+	bool connected;
 
 	struct list_head rc_list;
 	u32 airtime_ac[8];
-- 
2.47.3

