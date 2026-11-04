Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784236;
	b=Z9glxS7o67VHEWLUVvYf890v1CQ/oY+1I1AtoskOn3082Cpu9Gjth6n/W6uJX2zcHSnj
	 9LHlpqq/VGrN1eRpNoernyBHHbNl8wEUs0O5djLku2OJpFNGj/a4BnUJ+HTIhwiFrfvhR
	 gCG1GvUWtAzz4/5qYPoCslK938zkpbpqsvfpAehAlEADX1WqYNsYgogI8I+/rKOQMZExK
	 McY46kXjSkls/h9DRNnUR9BHeygrY+uvOdyKPBGtwN+/w7qKvmlYhQrFTuN9zt5RZEqNu
	 qNXiudnTn7j4OjjJuspWDeUoonFh79nWbSq6Y+PhxLQjgBYRwOIdvLTOeOaWicf4c6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784236;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=VLzlU5bROcg6hrBZF9apevX7FimRJFoFnBnz7zak1KE=;
	b=4YjYKu9e6Ql+k6M3q8R9+cp+9aGUOKFUPucfG5VmqdJtDRxIAqtMmRWtyTE/8fizIMSa
	 Csepspk23tFtESizCvs/QEjWjgqk5Be0RaliYBKE7aFHkbNFbqgLuR4U0wyLSoIvWVn6G
	 KpVqSNlYNjcaqvf4nPq4WfpqYCtHd064U/HkvqY6Gq0gNDGrOnwgNbJZdTQgHhtr4UhKJ
	 wchwpkkxZuzqj+AbqEDJhu/6c0NCRCBUNnuCI/rmo5a57CeHr+65fAi8F2X4M22BeB50j
	 fnj0vRWNRYlVPai9r2hAcw/K9jya8OimeV+GtcHWITupVnaw3p1oR6z8cKBgYTX93ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Y8oqCR7J;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC60606D811
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 09:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EC60606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Y8oqCR7J
X-UUID: 734ae276d83111f18dc8c9802ae25ab1-20261104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=VLzlU5bROcg6hrBZF9apevX7FimRJFoFnBnz7zak1KE=;
	b=Y8oqCR7JDseyXBM2FgHY4VNq5vL+VN7xJaNubqIWve3ZUYSxZhjKKR/395rY4Mdv+azMuDrzCq3TtdcDbLt4Yl6aL97LeakVZYyQ2tUNcoQRDc0a8bocNfiLpSAcHFBWtqosjFptsTK0315af2IiZREMiDNcqC5wICBOSCg2T5o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:bf7101a5-89d1-46c6-ba6e-63ef971b55b5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:db0ec7ce-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 734ae276d83111f18dc8c9802ae25ab1-20261104
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2120480072; Wed, 04 Nov 2026 17:23:52 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 4 Nov 2026 17:23:51 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 4 Nov 2026 17:23:51 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <James-LY.Huang@mediatek.com>,
	<jb.tsai@mediatek.com>, james-ly huang <james-ly.huang@mediatek.com>
Subject: [PATCH 8/9] wifi: mt76: mt7925: track BSS absence and drop stale GO probe responses
Date: Wed, 4 Nov 2026 17:23:43 +0800
Message-ID: <20261104092344.1932406-8-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261104092344.1932406-1-jb.tsai@mediatek.com>
References: <20261104092344.1932406-1-jb.tsai@mediatek.com>
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
Content-Type: text/plain
X-MTK: N

From: james-ly huang <james-ly.huang@mediatek.com>

The FW tells the host with a BSS_IS_ABSENCE event when a P2P GO's
BSS currently has no channel

  - latch the absent / free-quota state per bss_conf
    (mt7925_p2p_mcu_bss_is_absence_event in p2p.c), and kick the
    TX path (tx_worker) on the absent->present edge so whatever
    piled up while the BSS had no channel is dequeued
    immediately;
  - clear the latched state where the BSS index is (re)assigned:
    a GO stopped while absent and restarted on the same netdev
    would otherwise come back with absent still latched and drop
    every Probe Response until the FW sends a presence event
    for the new bss_idx;
  - the TX path (mt792x_tx) drops a GO Probe Response while the
    BSS is absent - by the time the FW comes back the requester
    has moved on, so the response is stale and only costs airtime
    and a TX-abort.

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 12 +++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  3 +
 .../net/wireless/mediatek/mt76/mt7925/p2p.c   | 97 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/p2p.h   | 20 ++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   | 25 +++++
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 16 +++
 7 files changed, 174 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 817554ffb9d8..2acaae9830fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1102,6 +1102,7 @@ enum {
 	MCU_UNI_EVENT_SAP = 0x1c,
 	MCU_UNI_EVENT_ROC = 0x27,
 	MCU_UNI_EVENT_MBMC = 0x28,
+	MCU_UNI_EVENT_BSS_IS_ABSENCE = 0x29,
 	MCU_UNI_EVENT_TX_DONE = 0x2d,
 	MCU_UNI_EVENT_THERMAL = 0x35,
 	MCU_UNI_EVENT_RSSI_MONITOR = 0x41,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index cfdb736f53ca..25e981e38ea9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -401,6 +401,18 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 			       0 : mconf->mt76.idx;
 	mconf->mt76.band_idx = 0xff;
 
+	/* A freshly configured BSS is on channel until the FW says otherwise.
+	 * mt792x_bss_conf lives in vif->drv_priv / mvif->link_conf[], which
+	 * mac80211 only zeroes when the interface is created - a GO that is
+	 * stopped while absent and restarted on the same netdev would come back
+	 * with absent still latched, and then drop every Probe Response until
+	 * the FW happens to send a presence event for the new bss_idx. Clear it
+	 * here, where the BSS index is (re)assigned.
+	 */
+	mconf->absent = false;
+	mconf->free_quota = 0;
+	mconf->absence_tstamp = 0;
+
 	if (is_mt7927(&dev->mt76)) {
 		struct ieee80211_channel *chan;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d9a5b5f57fba..24de2ff3a15d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -738,6 +738,9 @@ mt7925_mcu_uni_rx_unsolicited_event(struct mt792x_dev *dev,
 	case MCU_UNI_EVENT_SAP:
 		mt7925_p2p_mcu_sap_event(dev, skb);
 		break;
+	case MCU_UNI_EVENT_BSS_IS_ABSENCE:
+		mt7925_p2p_mcu_bss_is_absence_event(dev, skb);
+		break;
 	case MCU_UNI_EVENT_RSSI_MONITOR:
 		mt7925_mcu_rssi_monitor_event(dev, skb);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
index d05c936d40ea..9be6891cc5d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
@@ -603,3 +603,100 @@ void mt7925_p2p_mcu_sap_event(struct mt792x_dev *dev, struct sk_buff *skb)
 	}
 }
 
+struct mt7925_bss_absence_data {
+	u8 bss_idx;
+	u8 is_absent;
+	u8 free_quota;
+};
+
+/* Per-BSS handling of the BSS_IS_ABSENCE event: latch the absent /
+ * free-quota state, and on the absent->present edge kick the TX path so
+ * whatever piled up while the BSS had no channel gets dequeued
+ * immediately (the kick is the tx_worker).
+ */
+static void
+mt7925_mcu_bss_absence_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt7925_bss_absence_data *data = priv;
+	struct mt792x_bss_conf *mconf = NULL;
+	struct mt792x_dev *dev = mvif->phy->dev;
+	unsigned long valid_links, now = jiffies;
+	unsigned int link_id;
+	bool absent, was_absent;
+
+	if (ieee80211_vif_is_mld(vif)) {
+		valid_links = mvif->valid_links;
+		for_each_set_bit(link_id, &valid_links,
+				 IEEE80211_MLD_MAX_NUM_LINKS) {
+			struct mt792x_bss_conf *link_mconf;
+
+			link_mconf = rcu_dereference(mvif->link_conf[link_id]);
+			if (link_mconf && link_mconf->mt76.idx == data->bss_idx) {
+				mconf = link_mconf;
+				break;
+			}
+		}
+	} else if (mvif->bss_conf.mt76.idx == data->bss_idx) {
+		mconf = &mvif->bss_conf;
+	}
+
+	if (!mconf)
+		return;
+
+	absent = !!data->is_absent;
+	was_absent = mconf->absent;
+
+	mconf->free_quota = data->free_quota;
+	if (was_absent != absent) {
+		mconf->absent = absent;
+		mconf->absence_tstamp = now;
+	}
+
+	/* From Absent to Present */
+	if (was_absent && !absent)
+		mt76_worker_schedule(&dev->mt76.tx_worker);
+}
+
+void mt7925_p2p_mcu_bss_is_absence_event(struct mt792x_dev *dev, struct sk_buff *skb)
+{
+	struct mt7925_uni_bss_is_absence_event *event;
+	struct mt7925_bss_absence_data data;
+	u32 tlv_len;
+	u8 *tlv;
+
+	skb_pull(skb, sizeof(struct mt7925_mcu_rxd));
+	if (skb->len < sizeof(*event))
+		return;
+
+	event = (struct mt7925_uni_bss_is_absence_event *)skb->data;
+	tlv = event->tlv;
+	tlv_len = skb->len - sizeof(*event);
+
+	while (tlv_len >= sizeof(struct tlv)) {
+		struct tlv *hdr = (struct tlv *)tlv;
+		u16 tag = le16_to_cpu(hdr->tag);
+		u16 len = le16_to_cpu(hdr->len);
+
+		if (len < sizeof(*hdr) || len > tlv_len)
+			break;
+
+		if (tag == MT7925_BSS_IS_ABSENCE_TAG_INFO &&
+		    len >= sizeof(struct mt7925_bss_absence_info_tlv)) {
+			struct mt7925_bss_absence_info_tlv *info =
+				(struct mt7925_bss_absence_info_tlv *)tlv;
+
+			data.bss_idx = event->bss_idx;
+			data.is_absent = info->is_absent;
+			data.free_quota = info->free_quota;
+
+			ieee80211_iterate_active_interfaces_atomic(dev->mt76.phy.hw,
+								   IEEE80211_IFACE_ITER_RESUME_ALL,
+								   mt7925_mcu_bss_absence_iter,
+								   &data);
+		}
+
+		tlv += len;
+		tlv_len -= len;
+	}
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
index 9afae222845f..e189f9e56e93 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
@@ -53,6 +53,24 @@ struct mt7925_uni_sap_event {
 	u8 pad[4];	/* fixed field */
 	u8 tlv[];
 } __packed;
+
+/* BSS absence/presence event (FW event UNI_EVENT_ID_BSS_IS_ABSENCE) */
+#define MT7925_BSS_IS_ABSENCE_TAG_INFO		0
+
+struct mt7925_bss_absence_info_tlv {
+	__le16 tag;
+	__le16 len;
+	u8 is_absent;
+	u8 free_quota;
+	u8 pad[2];
+} __packed;
+
+struct mt7925_uni_bss_is_absence_event {
+	u8 bss_idx;
+	u8 pad[3];
+	u8 tlv[];
+} __packed;
+
 /* TX/RX path overrides, BMC wcid bookkeeping and the P2P-only MCU event
  * handlers.
  */
@@ -69,5 +87,7 @@ bool mt7925_p2p_chanctx_bss_programmed(struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *link_conf);
 
 void mt7925_p2p_mcu_sap_event(struct mt792x_dev *dev, struct sk_buff *skb);
+void mt7925_p2p_mcu_bss_is_absence_event(struct mt792x_dev *dev,
+					 struct sk_buff *skb);
 
 #endif /* __MT7925_P2P_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 94186e9f77c8..6bfbeceaf026 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -163,6 +163,17 @@ struct mt792x_bss_conf {
 	struct ewma_rssi rssi;
 	struct ieee80211_tx_queue_params queue_params[IEEE80211_NUM_ACS];
 	unsigned int link_id;
+	/* FW BSS absence/presence state, updated by the BSS_IS_ABSENCE
+	 * event handler.
+	 */
+	bool absent;
+	u8 free_quota;
+	unsigned long absence_tstamp;
+
+	/* Dedicated BMC entry, only allocated for a p2p GO. Group-addressed
+	 * frames are transmitted on this wcid instead of the vif wcid, so
+	 * they no longer share the wcid
+	 */
 	struct mt792x_link_sta bmc;
 	bool bmc_valid;
 };
@@ -407,6 +418,20 @@ mt792x_link_conf_to_mconf(struct ieee80211_bss_conf *link_conf)
 	return mt792x_vif_to_link(mvif, link_conf->link_id);
 }
 
+/* TRUE only while the BSS has no channel, so nothing we hand to the FW
+ * for it can go on air. Callable from the TX path: reads a single byte
+ * updated by the BSS_IS_ABSENCE event handler.
+ */
+static inline bool mt792x_vif_is_absent(struct ieee80211_vif *vif)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+
+	if (ieee80211_vif_is_mld(vif))
+		return false;
+
+	return mvif->bss_conf.absent;
+}
+
 static inline struct ieee80211_bss_conf *
 mt792x_vif_to_bss_conf(struct ieee80211_vif *vif, unsigned int link_id)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index fa29af8fff49..98fa46e85c1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -178,6 +178,22 @@ void mt792x_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	u8 link_id;
 	int qid;
 
+	/* Drop a GO Probe Response outright when mt792x_vif_is_absent()
+	 * says the BSS has no channel right now: by the time the FW comes
+	 * back the requester has moved on, so the response is stale and
+	 * only costs airtime and a TX-abort in the FW.
+	 */
+	if (!(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) && skb->len >= 2) {
+		struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+
+		if (vif && ieee80211_vif_type_p2p(vif) == NL80211_IFTYPE_P2P_GO &&
+		    ieee80211_is_probe_resp(mgmt->frame_control) &&
+		    mt792x_vif_is_absent(vif)) {
+			ieee80211_free_txskb(hw, skb);
+			return;
+		}
+	}
+
 	if (control->sta) {
 		struct mt792x_link_sta *mlink;
 		struct mt792x_sta *sta;
-- 
2.45.2

