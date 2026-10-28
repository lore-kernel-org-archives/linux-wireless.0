Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190257;
	b=hnPpx6mFwvttYDzfXHb2R80BhxIydoG62AxgZQtiWOk07ykl8dv7QXCWOzMvoyuMo4b4
	 OblMgU+PSg34GZpR46j+H2PqyzUj5dqeuMzVBPj38xapby+dUo+ifAUPTzavORiY5os+N
	 HP6AYVAk5ZpDYpofmTMrPer3e7WfPgiPXrfJC/xVt29Ub+8ROTSZh++01IGHMeRk/FJSY
	 70Rw/ILwkiPWovCSfImXbfaYmeOKCzlamSrNHyKafzDc0e835/+ysn2t/y9GuMKIYVyUN
	 Bm5U0fyC99WPAxLLiPG9k/XSg3OAfoMIyqUw4eeGO/jj8QpYmcV04YgSSvx9HARuD9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190257;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nB/UvAnT7tn5iUci0JQHrh3fjJ2huwm5F+gkgQlA6Kc=;
	b=1l/R5IcD4LPrFoC7IC34aH2uG1vgkAcbbcEInAIjjDlidSDQrw1VLBBu5Rm6qhDgOiBW
	 7vTgp72FmlO2QVSH/nfxDOSqa0PDEM0xaMSGKWPWyVWemO1/pWAfy2k/JEp/jdZXnDarB
	 1funSG5WZkddruokbu5dKtoHXgP692FkKh/+gleaP9PFyXfKg0QLxe2vEzMc2QCqkBZ0O
	 cIeod8yx0w1CnQcsq1hwUiQMYz1o16kHGmTkchhfiUX9JuPtSVDfUaw6nLU9aeGnAbXPz
	 7UJJhlJHK2KMQu/LCU03q0Y9mL2K4jBfiA2ky6vOWDE6PZ4g/00XJrF8+NGM0b7LWkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=rpLnACta;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EA8606A335
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17EA8606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=rpLnACta
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nB/UvAnT7tn5iUci0JQHrh3fjJ2huwm5F+gkgQlA6Kc=; b=rpLnACtaFkK0huPWdMgnxTKvuw
	Wnf8UJB5y/8gXI7UKt/7//dynglnKZGUXfjdHPwI5Yl1xQG2eXq0BrwE2JvByoP0k0DYObMpBYd2y
	h+OuE2STJOTt3/LheiKDOAMtNqSNfW72yqGdAnUlLiPMf2x+XbgRSuSt+WM6R1XNy4zU=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hM-00C8Bw-14;
	Wed, 28 Oct 2026 13:24:08 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>
Subject: [PATCH mt76-next 13/25] wifi: mt76: mt7996: describe an MLD peer with the PEER_MLD command
Date: Wed, 28 Oct 2026 13:23:51 +0100
Message-ID: <20261028122403.796394-13-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The firmware learns about an MLD peer only from the MLD_SETUP TLV of
STA_REC_UPDATE. The vendor driver for the same firmware describes the
peer with the PEER_MLD command instead: a PEER_MLD_INFO TLV with the
links of the peer, its primary, secondary and setup WCID, and a
PEER_MLD_CAP TLV with the A-MSDU limits. It flags every MLD_SETUP TLV
with EXTRA_INFO_MLD_SKIP, so that the firmware takes the MLD setup from
PEER_MLD.

Send PEER_MLD at the association of an MLO peer, before the STA_REC of
its first link. The firmware MLD index of the peer is the WCID of its
primary link. The teardown stays with STA_REC_MLD_OFF.

Flag an MLD_SETUP TLV only while its links are the links that PEER_MLD
described. mac80211 activates the partner links of a station after the
association, so PEER_MLD of a station covers only the assoc link. The
firmware refuses a flagged MLD_SETUP for the full link set, and
change_sta_links then fails with a warning in
_ieee80211_set_active_links(). An unflagged MLD_SETUP sets up the links
that join or leave later, as before.

While the PEER_MLD description is valid, keep its MLD index as the
setup and primary WCID of each MLD_SETUP, also after mt7996 makes
another link the primary link when the first one goes away. With the
WCID of the new primary link, the next association of the peer gets no
MLD record from its PEER_MLD, and the firmware refuses the MLD_SETUP of
that association:

  NULL MLDREC of WCID 1

A link keeps its WCID until the station is removed, also after its link
station goes. TX still moves to another link; only the MLD description
in the firmware keeps the primary of the association.

Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |   1 +
 .../net/wireless/mediatek/mt76/mt7996/main.c  |   8 ++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 110 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   |  59 +++++++++-
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |   4 +
 5 files changed, 180 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index e9a7542c07dc..bb98a6eacac4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1363,6 +1363,7 @@ enum {
 	MCU_UNI_CMD_FACT_CAL = 0x7c,
 	MCU_UNI_CMD_RADIO_STATUS = 0x80,
 	MCU_UNI_CMD_MLD = 0x82,
+	MCU_UNI_CMD_PEER_MLD = 0x83,
 	MCU_UNI_CMD_SDO = 0x88,
 	MCU_UNI_CMD_AXIDMA = 0xa2,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 3384e46e7b05..e97af1828444 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1531,6 +1531,7 @@ mt7996_mac_sta_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 	msta->seclink_id = IEEE80211_LINK_UNSPECIFIED;
 	msta->conn_state = CONN_STATE_DISCONNECT;
+	msta->peer_mld_links = 0;
 	msta->ba_tx_mask = 0;
 	msta->ba_rx_mask = 0;
 	msta->vif = mvif;
@@ -1649,6 +1650,12 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 
+	if (ev == MT76_STA_EVENT_ASSOC && sta->mlo) {
+		err = mt7996_mcu_set_peer_mld(dev, vif, sta);
+		if (err)
+			goto out;
+	}
+
 	err = mt7996_mac_sta_links_event(dev, vif, sta,
 					 mt7996_mac_sta_links(dev, vif, sta),
 					 ev);
@@ -1664,6 +1671,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		break;
 	case MT76_STA_EVENT_DISASSOC:
 		msta->conn_state = CONN_STATE_DISCONNECT;
+		msta->peer_mld_links = 0;
 		mt7996_mac_sta_clear_connected(dev, msta);
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index ce37b6b65918..34ac25c22b01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2803,13 +2803,19 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	mld_setup = (struct sta_rec_mld_setup *)tlv;
 	memcpy(mld_setup->mld_addr, sta->addr, ETH_ALEN);
 	mld_setup->setup_wcid = cpu_to_le16(msta_link->wcid.idx);
-	mld_setup->primary_id = cpu_to_le16(msta_link->wcid.idx);
+	/* the firmware keeps the MLD record of PEER_MLD under fw_mld_idx */
+	if (msta->peer_mld_links)
+		mld_setup->setup_wcid = cpu_to_le16(msta->fw_mld_idx);
+	mld_setup->primary_id = mld_setup->setup_wcid;
 
 	if (links & BIT(msta->seclink_id))
 		seclink_id = msta->seclink_id;
 	msta_link = mt7996_sta_link_protected(dev, msta, seclink_id);
 	mld_setup->seconed_id = cpu_to_le16(msta_link->wcid.idx);
 	mld_setup->link_num = nlinks;
+	/* PEER_MLD_INFO holds only the links of the association */
+	if (links == msta->peer_mld_links)
+		mld_setup->extra_info = EXTRA_INFO_MLD_SKIP;
 
 	mld_setup_link = (struct mld_setup_link *)mld_setup->link_info;
 	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
@@ -2824,6 +2830,108 @@ mt7996_mcu_sta_mld_setup_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 	}
 }
 
+static u32 mt7996_mcu_peer_mld_amsdu_len(u16 max_amsdu_len)
+{
+	switch (max_amsdu_len) {
+	case IEEE80211_MAX_MPDU_LEN_VHT_11454:
+		return IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
+	case IEEE80211_MAX_MPDU_LEN_HT_7935:
+	case IEEE80211_MAX_MPDU_LEN_VHT_7991:
+		return IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991;
+	default:
+		return IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
+	}
+}
+
+int mt7996_mcu_set_peer_mld(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	unsigned long links = mt7996_mac_sta_links(dev, vif, sta);
+	unsigned int nlinks = hweight16(links);
+	struct peer_mld_cap_entry *cap_entry;
+	struct peer_mld_link_info *link_info;
+	struct mt7996_sta_link *msta_link;
+	u8 seclink_id = msta->deflink_id;
+	struct peer_mld_req_hdr *hdr;
+	u16 max_amsdu_len = U16_MAX;
+	struct peer_mld_info *info;
+	struct peer_mld_cap *cap;
+	unsigned int link_id;
+	struct sk_buff *skb;
+	struct tlv *tlv;
+	u16 fw_mld_idx;
+	int len, ret;
+
+	if (!(links & BIT(msta->deflink_id)))
+		return 0;
+
+	len = sizeof(*hdr) + sizeof(*info) + nlinks * sizeof(*link_info) +
+	      sizeof(*cap) + 2 * sizeof(*cap_entry);
+	skb = mt76_mcu_msg_alloc(&dev->mt76, NULL, len);
+	if (!skb)
+		return -ENOMEM;
+
+	msta_link = mt7996_sta_link_protected(dev, msta, msta->deflink_id);
+
+	fw_mld_idx = msta_link->wcid.idx;
+	hdr = skb_put_zero(skb, sizeof(*hdr));
+	hdr->fw_mld_idx = cpu_to_le16(fw_mld_idx);
+	memcpy(hdr->peer_mld_addr, sta->addr, ETH_ALEN);
+
+	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_CMD_PEER_MLD_INFO,
+				     sizeof(*info) +
+				     nlinks * sizeof(*link_info));
+	info = (struct peer_mld_info *)tlv;
+	info->link_num = nlinks;
+	info->primary_id = cpu_to_le16(msta_link->wcid.idx);
+	info->setup_wcid = cpu_to_le16(msta_link->wcid.idx);
+
+	if (links & BIT(msta->seclink_id))
+		seclink_id = msta->seclink_id;
+	msta_link = mt7996_sta_link_protected(dev, msta, seclink_id);
+	info->second_id = cpu_to_le16(msta_link->wcid.idx);
+
+	link_info = info->link_info;
+	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct ieee80211_link_sta *link_sta;
+		struct mt7996_vif_link *link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		link = mt7996_vif_link(dev, vif, link_id);
+		link_sta = link_sta_dereference_protected(sta, link_id);
+
+		max_amsdu_len = min(max_amsdu_len, link_sta->agg.max_amsdu_len);
+
+		link_info->fw_link_id = cpu_to_le16(msta_link->wcid.idx);
+		link_info->link_id = link_id;
+		link_info->bss_idx = link->mt76.idx;
+		link_info->wlan_idx = cpu_to_le16(msta_link->wcid.idx);
+		link_info->band_idx = link->mt76.band_idx;
+		link_info++;
+	}
+
+	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_CMD_PEER_MLD_CAP,
+				     sizeof(*cap) + 2 * sizeof(*cap_entry));
+	cap = (struct peer_mld_cap *)tlv;
+
+	cap_entry = cap->entry;
+	cap_entry->type = cpu_to_le32(UNI_CMD_PEER_MLD_CAP_TYPE_AMSDU_MAX_LEN);
+	cap_entry->val = cpu_to_le32(mt7996_mcu_peer_mld_amsdu_len(max_amsdu_len));
+	cap_entry++;
+	cap_entry->type = cpu_to_le32(UNI_CMD_PEER_MLD_CAP_TYPE_AMSDU_MAX_CNT);
+	cap_entry->val = cpu_to_le32(31);
+
+	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				    MCU_WMWA_UNI_CMD(PEER_MLD), true);
+	if (!ret) {
+		msta->peer_mld_links = links;
+		msta->fw_mld_idx = fw_mld_idx;
+	}
+
+	return ret;
+}
+
 static void
 mt7996_mcu_sta_eht_mld_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 			   struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 70ed57d9bf9a..2fdf82394355 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -730,7 +730,8 @@ struct sta_rec_mld_setup {
 	__le16 seconed_id;
 	__le16 setup_wcid;
 	u8 link_num;
-	u8 info;
+#define EXTRA_INFO_MLD_SKIP	BIT(2)
+	u8 extra_info;
 	u8 __rsv[2];
 	u8 link_info[];
 } __packed;
@@ -773,6 +774,62 @@ enum {
 	UNI_CMD_MLD_RECONF_STOP_LINK = 0x04,
 };
 
+struct peer_mld_req_hdr {
+	u8 ver;
+	u8 peer_mld_addr[ETH_ALEN];
+	u8 rsv;
+	__le16 fw_mld_idx;
+	__le16 flag;
+	u8 buf[];
+} __packed;
+
+struct peer_mld_link_info {
+	__le16 fw_link_id;
+	u8 link_id;
+	u8 bss_idx;
+	__le16 wlan_idx;
+	u8 band_idx;
+	u8 rsv;
+} __packed;
+
+struct peer_mld_info {
+	__le16 tag;
+	__le16 len;
+	u8 ver;
+	u8 link_num;
+	u8 rsv[2];
+	__le16 primary_id;
+	__le16 second_id;
+	__le16 setup_wcid;
+	u8 rsv2[2];
+	struct peer_mld_link_info link_info[];
+} __packed;
+
+struct peer_mld_cap_entry {
+	__le32 type;
+	__le32 val;
+} __packed;
+
+struct peer_mld_cap {
+	__le16 tag;
+	__le16 len;
+	u8 ver;
+	u8 rsv;
+	__le16 bitmap;
+	u8 rsv2[8];
+	struct peer_mld_cap_entry entry[];
+} __packed;
+
+enum {
+	UNI_CMD_PEER_MLD_INFO = 0x01,
+	UNI_CMD_PEER_MLD_CAP = 0x02,
+};
+
+enum {
+	UNI_CMD_PEER_MLD_CAP_TYPE_AMSDU_MAX_LEN = 0x01,
+	UNI_CMD_PEER_MLD_CAP_TYPE_AMSDU_MAX_CNT = 0x02,
+};
+
 struct hdr_trans_en {
 	__le16 tag;
 	__le16 len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 1f1dff9f6610..0c6a3dba2e03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -276,6 +276,8 @@ struct mt7996_sta {
 	u8 deflink_id;
 	u8 seclink_id;
 	u8 conn_state;
+	u16 peer_mld_links;
+	u16 fw_mld_idx;
 
 	unsigned long wcid_flags;
 
@@ -753,6 +755,8 @@ int mt7996_mcu_add_sta(struct mt7996_dev *dev,
 		       struct mt7996_vif_link *link,
 		       struct mt7996_sta_link *msta_link,
 		       int conn_state, bool newly);
+int mt7996_mcu_set_peer_mld(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta);
 int mt7996_mcu_teardown_mld_sta(struct mt7996_dev *dev,
 				struct mt7996_vif_link *link,
 				struct mt7996_sta_link *msta_link);
-- 
2.47.3

