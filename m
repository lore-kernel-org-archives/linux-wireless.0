Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953819;
	b=F72yZi+aObVW2kSt5XJhOETu/actBzA964B20g3cJUHRlxNzd10JC3clLQrMozg8fCcu
	 rYfxWim4famuVXUFmTpEt45kLhsRgOvMxODT3AuBBF7IzbZsSbJYQSneBOZZYAFTvk2b7
	 lKfHmIg/pL3s21yP2pTbEPQC5GM+xPQluBpb1zGJDhb3WLo6eWt2Rj0ODgzwDoZX7Gyp0
	 aD4Xv3CDwP9Pt+GCoGZ4QunSFJedM1H6xATiBaP2JbpwpHXOsE5JqUPI7pZQn4tBFGl5s
	 YDG+PBB3Q0JcDhHEq29QKhbXlpWCiktsZcx14oL2ijDx/O65ErmxvZSiCDl9y/9RTuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953819;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=LGSvrTv4Wf91vkSRllE7f4GzHyMY5oUERas0d4QiPbY=;
	b=b98AANC8ihQarciy031bZPzwqJ8HNxtUFFWrZ87NT0TWzwqJIkWOpEDQ/VE5rni7fP4l
	 0ZgoDikXxIv4yNOqJ2HnvtyJb2B/PPo5SL3WIuExDugmbw6xU6q9AqIfdzTYoS/ngzOta
	 ZYQ2VpFDfzurKDDqP0X/kbLs9KMus2cmpuuDj/6H+GOA6gxN4ga6Q3mqy81oeUG7fPRRR
	 HAPmngKW3dlg8Ftsm1POOaTx1PBz+svihbc/oFhH9DDZD8qiaOxMlpuiRlI4uKSFXr41i
	 ZnQivyNz7JmJi0eB/4HAsIDFDcxh8C+lLjDSWBBsuTmmuNDZVZSwAPeZAmmhdwDFCmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=ALDIxUv8;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1C2606A33F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C1C2606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=ALDIxUv8
X-UUID: 47fb6f14d9bc11f1b1788b6acf885367-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=LGSvrTv4Wf91vkSRllE7f4GzHyMY5oUERas0d4QiPbY=;
	b=ALDIxUv8D2b1uZtJG03ypcqLiJ9m3rq8DKxnWMcDn9C/VntDUW/rMJsVnKWwbbwxCBeLj7c8KKo3n04HPgUDnGvXVBBMpIKF31dhPDJc8Cr+asRrrQfudbK0+08AE+Dw3JQ7XpD5wPe+1faFP/a7ERuFqRk+6yi+P9+xRu8IZdg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:3ec3dfb4-0104-4d1e-9374-7ff8844c8b4d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:35a4dace-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 47fb6f14d9bc11f1b1788b6acf885367-20261106
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <james-ly.huang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 407701143; Fri, 06 Nov 2026 16:30:10 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 16:30:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Nov 2026 16:30:09 +0800
From: James-LY Huang <james-ly.huang@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<sean.wang@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<James-LY.Huang@mediatek.com>, james-ly huang <james-ly.huang@mediatek.com>
Subject: [PATCH v2 7/9] wifi: mt76: mt7925: inject the deauth for an aging-timeout SAP event
Date: Fri, 6 Nov 2026 16:30:02 +0800
Message-ID: <20261106083004.3156085-8-james-ly.huang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
References: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
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

The FW ages out inactive clients of an AP/GO and reports it with a
SAP aging-timeout event; the expected reaction is a deauth with
REASON_CODE_DISASSOC_INACTIVITY. The AP MLME here lives in
wpa_supplicant (softmac, device_ap_sme=0), so synthesize the deauth
frame the GO would have received from the GC and hand it to
userspace via cfg80211_rx_mgmt_khz().

Handle the new MCU_UNI_EVENT_SAP in p2p.c
(mt7925_p2p_mcu_sap_event) and dispatch it from the unsolicited
event handler.

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
v2: fix build warning
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |   1 +
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7925/p2p.c   | 141 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/p2p.h   |  16 ++
 4 files changed, 162 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index bb98a6eacac4..817554ffb9d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1099,6 +1099,7 @@ enum {
 	MCU_UNI_EVENT_PS_SYNC = 0x0d,
 	MCU_UNI_EVENT_SCAN_DONE = 0x0e,
 	MCU_UNI_EVENT_RDD_REPORT = 0x11,
+	MCU_UNI_EVENT_SAP = 0x1c,
 	MCU_UNI_EVENT_ROC = 0x27,
 	MCU_UNI_EVENT_MBMC = 0x28,
 	MCU_UNI_EVENT_TX_DONE = 0x2d,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 6ec74d7bfd82..d9a5b5f57fba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -8,6 +8,7 @@
 #include "mcu.h"
 #include "mac.h"
 #include "nan.h"
+#include "p2p.h"
 
 #define MT_STA_BFER			BIT(0)
 #define MT_STA_BFEE			BIT(1)
@@ -734,6 +735,9 @@ mt7925_mcu_uni_rx_unsolicited_event(struct mt792x_dev *dev,
 	case MCU_UNI_EVENT_BSS_BEACON_LOSS:
 		mt7925_mcu_connection_loss_event(dev, skb);
 		break;
+	case MCU_UNI_EVENT_SAP:
+		mt7925_p2p_mcu_sap_event(dev, skb);
+		break;
 	case MCU_UNI_EVENT_RSSI_MONITOR:
 		mt7925_mcu_rssi_monitor_event(dev, skb);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
index f41098b324ba..1fa6787600b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
@@ -462,3 +462,144 @@ bool mt7925_p2p_chanctx_bss_programmed(struct ieee80211_vif *vif,
 	}
 }
 
+/* ------------------------------------------------------------------ */
+/* P2P-only MCU events                                                  */
+/* ------------------------------------------------------------------ */
+
+/* FW reported that a peer of our AP/GO aged out (no traffic/no ack for the FW
+ * inactivity period); the expected reaction is a deauth with
+ * REASON_CODE_DISASSOC_INACTIVITY. Here the AP MLME lives in
+ * wpa_supplicant (softmac, device_ap_sme=0), so instead of tearing the
+ * STA down in the driver we synthesize the deauth frame the GO would
+ * have received from the GC and hand it to userspace via
+ * NL80211_CMD_FRAME.
+ */
+static void
+mt7925_mcu_sap_aging_timeout(struct mt792x_dev *dev, u16 wlan_idx)
+{
+	struct {
+		struct ieee80211_hdr_3addr hdr;
+		__le16 reason_code;
+	} deauth = {};
+	u8 peer[ETH_ALEN], own[ETH_ALEN], bssid[ETH_ALEN];
+	struct ieee80211_chanctx_conf *ctx;
+	struct mt792x_bss_conf *mconf;
+	struct mt792x_link_sta *mlink;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+	struct mt792x_vif *mvif;
+	struct mt792x_sta *msta;
+	struct mt76_wcid *wcid;
+	struct wireless_dev *wdev;
+	int freq = 0;
+	u8 link_id;
+
+	rcu_read_lock();
+
+	wcid = mt76_wcid_ptr(dev, wlan_idx);
+	if (!wcid || !wcid->sta)
+		goto unlock;
+
+	mlink = container_of(wcid, struct mt792x_link_sta, wcid);
+	msta = mlink->sta;
+	if (!msta || !msta->vif)
+		goto unlock;
+
+	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_P2P_GO)
+		goto unlock;
+
+	mvif = (struct mt792x_vif *)vif->drv_priv;
+	sta = container_of((void *)msta, struct ieee80211_sta, drv_priv);
+	link_id = wcid->link_id;
+
+	ether_addr_copy(peer, sta->addr);
+	ether_addr_copy(own, vif->addr);
+	ether_addr_copy(bssid, vif->bss_conf.bssid);
+	mconf = &mvif->bss_conf;
+
+	if (ieee80211_vif_is_mld(vif) && link_id < IEEE80211_LINK_UNSPECIFIED) {
+		struct ieee80211_link_sta *link_sta;
+		struct ieee80211_bss_conf *link_conf;
+		struct mt792x_bss_conf *link_mconf;
+
+		link_sta = rcu_dereference(sta->link[link_id]);
+		if (link_sta)
+			ether_addr_copy(peer, link_sta->addr);
+
+		link_conf = rcu_dereference(vif->link_conf[link_id]);
+		if (link_conf) {
+			ether_addr_copy(own, link_conf->addr);
+			ether_addr_copy(bssid, link_conf->bssid);
+		}
+
+		link_mconf = rcu_dereference(mvif->link_conf[link_id]);
+		if (link_mconf)
+			mconf = link_mconf;
+	}
+
+	ctx = mconf->mt76.ctx;
+	if (ctx && ctx->def.chan)
+		freq = ctx->def.chan->center_freq;
+	else if (dev->mphy.chandef.chan)
+		freq = dev->mphy.chandef.chan->center_freq;
+
+	rcu_read_unlock();
+
+	deauth.hdr.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					       IEEE80211_STYPE_DEAUTH);
+	ether_addr_copy(deauth.hdr.addr1, own);	/* DA: the GO itself */
+	ether_addr_copy(deauth.hdr.addr2, peer);	/* SA: the aged-out GC */
+	ether_addr_copy(deauth.hdr.addr3, bssid);
+	deauth.reason_code = cpu_to_le16(WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
+
+	wdev = ieee80211_vif_to_wdev(vif);
+	if (!wdev)
+		return;
+
+	cfg80211_rx_mgmt_khz(wdev, MHZ_TO_KHZ(freq), 0, (const u8 *)&deauth,
+			     sizeof(deauth), 0);
+
+	return;
+
+unlock:
+	rcu_read_unlock();
+}
+
+void mt7925_p2p_mcu_sap_event(struct mt792x_dev *dev, struct sk_buff *skb)
+{
+	struct mt7925_uni_sap_event *event;
+	u32 tlv_len;
+	u8 *tlv;
+
+	skb_pull(skb, sizeof(struct mt7925_mcu_rxd));
+	if (skb->len < sizeof(*event))
+		return;
+
+	event = (struct mt7925_uni_sap_event *)skb->data;
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
+		if (tag == MT7925_SAP_TAG_AGING_TIMEOUT &&
+		    len >= sizeof(struct mt7925_sap_aging_timeout_tlv)) {
+			struct mt7925_sap_aging_timeout_tlv *aging =
+				(struct mt7925_sap_aging_timeout_tlv *)tlv;
+
+			mt7925_mcu_sap_aging_timeout(dev,
+						     le16_to_cpu(aging->wlan_idx));
+		}
+
+		tlv += len;
+		tlv_len -= len;
+	}
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
index f7af45ee4c1f..9afae222845f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
@@ -39,6 +39,20 @@ static inline bool mt7925_is_p2p_go_probe_resp(struct sk_buff *skb)
 	return ieee80211_is_probe_resp(mgmt->frame_control);
 }
 
+/* SAP event (FW event UNI_EVENT_ID_SAP / enum ENUM_UNI_EVENT_SAP_TAG) */
+#define MT7925_SAP_TAG_AGING_TIMEOUT		0
+
+struct mt7925_sap_aging_timeout_tlv {
+	__le16 tag;
+	__le16 len;
+	__le16 wlan_idx;
+	u8 pad[2];
+} __packed;
+
+struct mt7925_uni_sap_event {
+	u8 pad[4];	/* fixed field */
+	u8 tlv[];
+} __packed;
 /* TX/RX path overrides, BMC wcid bookkeeping and the P2P-only MCU event
  * handlers.
  */
@@ -54,4 +68,6 @@ void mt7925_p2p_bmc_remove(struct mt792x_dev *dev,
 bool mt7925_p2p_chanctx_bss_programmed(struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *link_conf);
 
+void mt7925_p2p_mcu_sap_event(struct mt792x_dev *dev, struct sk_buff *skb);
+
 #endif /* __MT7925_P2P_H */
-- 
2.45.2

