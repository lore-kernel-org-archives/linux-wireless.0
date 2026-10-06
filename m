Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116C94A2638
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=UGnIq3/kRDj4WSp17vryoSFfOLAOMKwiB0eXSUPwFmk9Yj1OkfNLOF1MZ9lmdF423+GGLYhsOUOUvudesqec2yf5Zfb13STc4itIsCO8xTgutLDENMcGKaAmy5knwQzoFDr86BzWH4XYEPfj2jM5b6zYFWlsmxx6AShdmcr8Brs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=zBygcptz/Xn9eU++9hhbg48CY8aVNyliYOnKfif9QV4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFQrC/ihYtlIlauc04WrUAolvUH50au7SnerQU8Oku8UFzaIraxFmxh3OwDBPF7ZiNRP/YZHLHSQpvFm6w1ne0YI0hd9wbWQuSLSXLVe+JIF4771e3jSj5kbdyFgB/OebtwClmbrUpH+7lsdQkiUzgv2suo1H86z2E41zf8vDWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Y0j1MFuk; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y0j1MFuk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TepMdcQ72DVKivMxXGTdTf4SxqHYMJcnngHQx6P6eqI=; b=Y0j1MFukCfpg1PlMFb7BlT4i/w
	X4pdYh3ZpjdUxd2ClDJTvkCByNlFD1YGcXc0xoPtFGeiG6LW0S1PxBiLgYt6Whsu8KDd1lnTUPld1
	0QgUTTCriJCwSUzPm9xTxQGzuZTmlEDgpbvscIsb6+UpjWrgJ1diLi9rBXvRHpaFjb2g=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGE-00HAg3-2d
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 20/27] wifi: mt76: mt7996: keep the block ack session parameters per station
Date: Tue,  6 Oct 2026 22:59:29 +0200
Message-ID: <20261006205936.669125-20-nbd@nbd.name>
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

mt7996_mcu_add_tx_ba() and mt7996_mcu_add_rx_ba() send STA_REC_BA to
the links that are active when mac80211 starts the session. To set up a
running session on a link that is added later, the driver needs the
parameters of that session, but it records a TX session only as a bit
in ampdu_state and keeps no RX session parameters.

Store the parameters of each running TX and RX session per TID, and
pass the set of links to update to mt7996_mcu_add_tx_ba() and
mt7996_mcu_add_rx_ba(). mt7996_ampdu_action() passes the links from
mt7996_mac_sta_links(), which are the links that have driver state.

No functional change on its own.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 40 ++++++++++++++++---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 12 +++---
 .../wireless/mediatek/mt76/mt7996/mt7996.h    | 17 +++++++-
 3 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 7792c3a878af..d90ada7f0f2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1473,6 +1473,8 @@ mt7996_mac_sta_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 	msta->seclink_id = IEEE80211_LINK_UNSPECIFIED;
 	msta->conn_state = CONN_STATE_DISCONNECT;
+	msta->ba_tx_mask = 0;
+	msta->ba_rx_mask = 0;
 	msta->vif = mvif;
 	err = mt7996_mac_sta_add_links(dev, vif, sta, links);
 
@@ -1809,6 +1811,21 @@ static int mt7996_set_rts_threshold(struct ieee80211_hw *hw, int radio_idx,
 	return ret;
 }
 
+static void
+mt7996_sta_ba_update(u16 *mask, struct mt7996_sta_ba *ba,
+		     struct ieee80211_ampdu_params *params, bool enable)
+{
+	if (!enable) {
+		*mask &= ~BIT(params->tid);
+		return;
+	}
+
+	*mask |= BIT(params->tid);
+	ba[params->tid].ssn = params->ssn;
+	ba[params->tid].buf_size = params->buf_size;
+	ba[params->tid].amsdu = params->amsdu;
+}
+
 static int
 mt7996_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		    struct ieee80211_ampdu_params *params)
@@ -1820,6 +1837,7 @@ mt7996_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u16 tid = params->tid;
 	u16 ssn = params->ssn;
 	struct mt76_txq *mtxq;
+	unsigned long links;
 	int ret = 0;
 
 	if (!txq)
@@ -1829,6 +1847,8 @@ mt7996_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	links = mt7996_mac_sta_links(dev, vif, sta);
+
 	switch (params->action) {
 	case IEEE80211_AMPDU_RX_START:
 		/* Since packets belonging to the same TID can be split over
@@ -1837,22 +1857,30 @@ mt7996_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 */
 		mt76_rx_aggr_start(&dev->mt76, &msta->deflink.wcid, tid,
 				   ssn, params->buf_size);
-		ret = mt7996_mcu_add_rx_ba(dev, params, vif, true);
+		ret = mt7996_mcu_add_rx_ba(dev, params, vif, links, true);
+		mt7996_sta_ba_update(&msta->ba_rx_mask, msta->ba_rx, params,
+				     !ret);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
 		mt76_rx_aggr_stop(&dev->mt76, &msta->deflink.wcid, tid);
-		ret = mt7996_mcu_add_rx_ba(dev, params, vif, false);
+		mt7996_sta_ba_update(&msta->ba_rx_mask, msta->ba_rx, params,
+				     false);
+		ret = mt7996_mcu_add_rx_ba(dev, params, vif, links, false);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		mtxq->aggr = true;
 		mtxq->send_bar = false;
-		ret = mt7996_mcu_add_tx_ba(dev, params, vif, true);
+		ret = mt7996_mcu_add_tx_ba(dev, params, vif, links, true);
+		mt7996_sta_ba_update(&msta->ba_tx_mask, msta->ba_tx, params,
+				     !ret);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		mtxq->aggr = false;
 		clear_bit(tid, &msta->deflink.wcid.ampdu_state);
-		ret = mt7996_mcu_add_tx_ba(dev, params, vif, false);
+		mt7996_sta_ba_update(&msta->ba_tx_mask, msta->ba_tx, params,
+				     false);
+		ret = mt7996_mcu_add_tx_ba(dev, params, vif, links, false);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		set_bit(tid, &msta->deflink.wcid.ampdu_state);
@@ -1861,7 +1889,9 @@ mt7996_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		mtxq->aggr = false;
 		clear_bit(tid, &msta->deflink.wcid.ampdu_state);
-		ret = mt7996_mcu_add_tx_ba(dev, params, vif, false);
+		mt7996_sta_ba_update(&msta->ba_tx_mask, msta->ba_tx, params,
+				     false);
+		ret = mt7996_mcu_add_tx_ba(dev, params, vif, links, false);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 02f9bcfdf5d9..1d2ee1ca5298 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1511,15 +1511,15 @@ mt7996_mcu_sta_ba(struct mt7996_dev *dev, struct mt76_vif_link *mvif,
 /** starec & wtbl **/
 int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-			 struct ieee80211_vif *vif, bool enable)
+			 struct ieee80211_vif *vif, unsigned long links,
+			 bool enable)
 {
 	struct ieee80211_sta *sta = params->sta;
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 	int ret = 0;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
@@ -1545,15 +1545,15 @@ int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 
 int mt7996_mcu_add_rx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-			 struct ieee80211_vif *vif, bool enable)
+			 struct ieee80211_vif *vif, unsigned long links,
+			 bool enable)
 {
 	struct ieee80211_sta *sta = params->sta;
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 	int ret = 0;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index ead211391404..8744411e0717 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -264,6 +264,12 @@ struct mt7996_sta_link {
 	struct rcu_head rcu_head;
 };
 
+struct mt7996_sta_ba {
+	u16 ssn;
+	u16 buf_size;
+	bool amsdu;
+};
+
 struct mt7996_sta {
 	struct mt7996_sta_link deflink; /* must be first */
 	struct mt7996_sta_link __rcu *link[IEEE80211_MLD_MAX_NUM_LINKS];
@@ -273,6 +279,11 @@ struct mt7996_sta {
 
 	unsigned long wcid_flags;
 
+	u16 ba_tx_mask;
+	u16 ba_rx_mask;
+	struct mt7996_sta_ba ba_tx[IEEE80211_NUM_TIDS];
+	struct mt7996_sta_ba ba_rx[IEEE80211_NUM_TIDS];
+
 	struct mt7996_vif *vif;
 };
 
@@ -733,10 +744,12 @@ int mt7996_mcu_teardown_mld_sta(struct mt7996_dev *dev,
 void mt7996_mcu_update_sta_rec_bw(void *data, struct ieee80211_sta *sta);
 int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-			 struct ieee80211_vif *vif, bool enable);
+			 struct ieee80211_vif *vif, unsigned long links,
+			 bool enable);
 int mt7996_mcu_add_rx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-			 struct ieee80211_vif *vif, bool enable);
+			 struct ieee80211_vif *vif, unsigned long links,
+			 bool enable);
 int mt7996_mcu_update_bss_color(struct mt7996_dev *dev,
 				struct mt76_vif_link *mlink,
 				struct cfg80211_he_bss_color *he_bss_color);
-- 
2.47.3

