Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD14A33F5
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=g7LSmmJrS0veuOJej53FbprbKsgU+E0cHyzZC/F6uezF3meGGyvKrNAQ5h5ZAxJknlWLI10BkxH5VtTRdrMDjfklv+FlJJMmpMqVBd9RQhO8Iz1XxASHBEUhklw2Wvbs+scLvck/RbphErgp+/0jO5+G2R67E3eZywpIH6x8mlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=SGzSrJcUdHYi5eGuh50pVe3i2pitgerwd0x/3rkTXC0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0u4Wkt3knvELOyhQUxX4/gJWlb5Hk6Auv4qN25Sz2ZzsjpSQpNAk7ypn/HZubaZpIrL0uOVevaxvxEByb6GHGBdBEIGF9/hslLuNk7HvuC3KK5TCy6909Au50LH3EkaP/0SXl3W138/bR0di0J8lynyGOMaou+pZyUxAzWe+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=hok+ueB3; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hok+ueB3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BmUgBpa2MIMeU0YPkR85u1qYeu1wtDr3dvc/3v7r8Bo=; b=hok+ueB3rabqnQSOUTrPTguMGy
	1/phWWG8eApXGWJ8DArwdNC/HJ+qlQhQL7/4ip8xfPeoqi2r/SzZ/WQY9ZOsgTzx3Obw2UzA9yFN4
	UPpcfDZZU4O7REf+y7etnogKv8iNAoYRhrjylG+MMnkxBLa3d8c//JEx1FWFWAhIUV+E=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGF-00HAg3-0U
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 22/27] wifi: mt76: mt7996: bring up station links added after association
Date: Tue,  6 Oct 2026 22:59:31 +0200
Message-ID: <20261006205936.669125-22-nbd@nbd.name>
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

mt7996_mac_sta_change_links() only sets up the driver state of a link
that is added to a station. The CONN_STATE_CONNECT and
CONN_STATE_PORT_SECURE STA_RECs and the rate control setup come from
mt7996_mac_sta_event(), which runs once per station state change, so a
link that becomes active after association has no firmware entry. This
is the normal case on a station interface: mac80211 activates only the
association link at first, and mt7996_sta_state() requests the other
links with ieee80211_set_active_links_async() when the station moves
to IEEE80211_STA_ASSOC. The STA_REC_MLD of the links already connected
also keeps the old set of links.

When links are added, replay the association on the links that are not
connected yet, install the keys of the station on them, and replay the
authorization if the station is authorized. mac80211 does not install
the pairwise key again, since ieee80211_key_switch_links() moves only
keys with key->link_id >= 0. Send the other links a STA_REC with only
STA_REC_MLD and STA_REC_EHT_MLD, so that their link list follows the
change. A 4-address link other than the primary link also gets the PS
leave request that mt7996_sta_set_4addr() sends on association.

If bringing up the added links fails, reset and remove them again
without flush, since the firmware can still hold an entry for their
WTBL index, and send the remaining links their STA_REC_MLD again.

While here, indent struct mt7996_key_iter_data with tabs.

Fixes: f520eceacd24 ("wifi: mt76: mt7996: Add mt7996_mac_sta_change_links callback")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 152 ++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   |  21 +++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |   5 +
 3 files changed, 166 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 4f3ebe4cee65..324d3b195a3f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -277,8 +277,9 @@ mt7996_set_hw_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 }
 
 struct mt7996_key_iter_data {
-    enum set_key_cmd cmd;
-    unsigned int link_id;
+	enum set_key_cmd cmd;
+	unsigned int link_id;
+	struct ieee80211_sta *sta;
 };
 
 static void
@@ -288,13 +289,13 @@ mt7996_key_iter(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt7996_key_iter_data *it = data;
 
-	if (sta)
+	if (sta != it->sta)
 		return;
 
 	if (key->link_id >= 0 && key->link_id != it->link_id)
 		return;
 
-	WARN_ON(mt7996_set_hw_key(hw, it->cmd, vif, NULL, it->link_id, key));
+	WARN_ON(mt7996_set_hw_key(hw, it->cmd, vif, sta, it->link_id, key));
 }
 
 int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
@@ -1530,6 +1531,23 @@ mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	return 0;
 }
 
+static void
+mt7996_mac_sta_link_ps_leave(struct mt7996_dev *dev,
+			     struct mt7996_vif_link *link,
+			     struct mt7996_sta_link *msta_link)
+{
+	/* HW cannot derive the BSSID from 4-address non-AMSDU frames,
+	 * so PS exit is missed on links other than the setup link.
+	 * Let the firmware wake those links instead.
+	 */
+	if (!is_mt7996(&dev->mt76) ||
+	    !test_bit(MT_WCID_FLAG_4ADDR, &msta_link->wcid.flags) ||
+	    msta_link->wcid.link_id == msta_link->sta->deflink_id)
+		return;
+
+	mt7996_mcu_ps_leave(dev, link, msta_link);
+}
+
 static void
 mt7996_mac_sta_clear_connected(struct mt7996_dev *dev, struct mt7996_sta *msta)
 {
@@ -1578,6 +1596,113 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	return err;
 }
 
+static void
+mt7996_mac_sta_links_set_keys(struct mt7996_dev *dev,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta, unsigned long links)
+{
+	unsigned int link_id;
+
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt7996_key_iter_data it = {
+			.cmd = SET_KEY,
+			.link_id = link_id,
+			.sta = sta,
+		};
+
+		ieee80211_iter_keys(mt76_hw(dev), vif, mt7996_key_iter, &it);
+	}
+}
+
+static int
+mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta, unsigned long links,
+			  unsigned long add)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	unsigned long new_links = 0, updated;
+	unsigned int link_id;
+	int err;
+
+	if (msta->conn_state == CONN_STATE_DISCONNECT)
+		return 0;
+
+	links &= mt7996_mac_sta_links(dev, vif, sta);
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (!msta_link->connected)
+			new_links |= BIT(link_id);
+	}
+
+	err = mt7996_mac_sta_links_event(dev, vif, sta, new_links,
+					 MT76_STA_EVENT_ASSOC);
+	if (err)
+		return err;
+
+	mt7996_mac_sta_links_set_keys(dev, vif, sta, links & add);
+
+	updated = new_links;
+	if (msta->conn_state == CONN_STATE_PORT_SECURE) {
+		err = mt7996_mac_sta_links_event(dev, vif, sta, updated,
+						 MT76_STA_EVENT_AUTHORIZE);
+		if (err)
+			return err;
+	}
+
+	for_each_set_bit(link_id, &new_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt7996_sta_link *msta_link;
+		struct mt7996_vif_link *link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		link = mt7996_vif_link(dev, vif, link_id);
+		mt7996_mac_sta_link_ps_leave(dev, link, msta_link);
+	}
+
+	updated = sta->mlo ? links & ~updated : 0;
+	for_each_set_bit(link_id, &updated, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt7996_sta_link *msta_link;
+		struct mt7996_vif_link *link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		link = mt7996_vif_link(dev, vif, link_id);
+		err = mt7996_mcu_update_mld_sta(dev, vif, sta, link, msta_link);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void
+mt7996_mac_sta_links_reset(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta, unsigned long links)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	unsigned int link_id;
+
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt7996_sta_link *msta_link;
+		struct mt7996_vif_link *link;
+		int i;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (!msta_link)
+			continue;
+
+		link = mt7996_vif_link(dev, vif, link_id);
+		if (link) {
+			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
+				mt7996_mac_twt_teardown_flow(dev, link,
+							     msta_link, i);
+		}
+
+		msta_link->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
+		msta_link->wcid.hw_key_idx = -1;
+	}
+}
+
 static void
 mt7996_mac_sta_links_bss_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta, unsigned long links)
@@ -1624,7 +1749,17 @@ mt7996_mac_sta_change_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mt7996_mac_sta_remove_links(dev, vif, sta, rem, false);
 	mt7996_mac_sta_links_bss_add(dev, vif, sta, add);
 	ret = mt7996_mac_sta_add_links(dev, vif, sta, add);
+	if (ret)
+		goto out;
 
+	ret = mt7996_mac_sta_links_sync(dev, vif, sta, new_links, add);
+	if (ret) {
+		mt7996_mac_sta_links_reset(dev, vif, sta, add);
+		mt7996_mac_sta_remove_links(dev, vif, sta, add, false);
+		mt7996_mac_sta_links_sync(dev, vif, sta, new_links & ~add, 0);
+	}
+
+out:
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
@@ -2300,14 +2435,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 			continue;
 
 		mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link, msta_link);
-
-		/* HW cannot derive the BSSID from 4-address non-AMSDU frames,
-		 * so PS exit is missed on links other than the setup link.
-		 * Let the firmware wake those links instead.
-		 */
-		if (enabled && msta->deflink_id != link_id &&
-		    is_mt7996(&dev->mt76))
-			mt7996_mcu_ps_leave(dev, link, msta_link);
+		mt7996_mac_sta_link_ps_leave(dev, link, msta_link);
 	}
 
 	mutex_unlock(&dev->mt76.mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 1d2ee1ca5298..c324d199b212 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2910,6 +2910,27 @@ int mt7996_mcu_teardown_mld_sta(struct mt7996_dev *dev,
 				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
 }
 
+int mt7996_mcu_update_mld_sta(struct mt7996_dev *dev,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct mt7996_vif_link *link,
+			      struct mt7996_sta_link *msta_link)
+{
+	struct sk_buff *skb;
+
+	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &link->mt76,
+					      &msta_link->wcid,
+					      MT7996_STA_UPDATE_MAX_SIZE);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	mt7996_mcu_sta_mld_setup_tlv(dev, skb, vif, sta);
+	mt7996_mcu_sta_eht_mld_tlv(dev, skb, sta);
+
+	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
+}
+
 void mt7996_mcu_update_sta_rec_bw(void *data, struct ieee80211_sta *sta)
 {
 	struct mt7996_vif_link *link = (struct mt7996_vif_link *)data;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 8744411e0717..ae97ca091673 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -741,6 +741,11 @@ int mt7996_mcu_add_sta(struct mt7996_dev *dev,
 int mt7996_mcu_teardown_mld_sta(struct mt7996_dev *dev,
 				struct mt7996_vif_link *link,
 				struct mt7996_sta_link *msta_link);
+int mt7996_mcu_update_mld_sta(struct mt7996_dev *dev,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct mt7996_vif_link *link,
+			      struct mt7996_sta_link *msta_link);
 void mt7996_mcu_update_sta_rec_bw(void *data, struct ieee80211_sta *sta);
 int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
-- 
2.47.3

