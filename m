Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB252D59E8
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 06:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785824654; cv=none; b=TzKckgNRtv5fa9ixthJZlPI0YcBaCfDI8XIXy5vKFqMSYrvhBIzIySjCSNJ2Omlt3bee3xsjpizJITFI5xvWQq8iEkBeWW7VBFR6PGMVuM+LOuwdgC4WQf2+bGlqD9iJdmZ34Pd/TU0Fj2qcmoJb6hJAHktH0jfIdjYISzw57QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785824654; c=relaxed/simple;
	bh=ry91+bdfPu5ffDBz5LgbMpdgsTSd77i5rpt34da2pS0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEDo8RkBis6I23rSHsGbq2ALOfOEjhg8m5nUt2eg7Kwe2e5yV+YaAVDXwGfbOgFCyfd4Pte9nijRvnX+XGbeglYm/dCPYAU7FPR5xBDbF1cLVE+kvSFN/3aNytfyD1T6BrYRQmriuqzwhuIPNvtEupSqgafaCRfO0sm/N8/S540=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OUzfjG53; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OUzfjG53"
X-UUID: 188bd1588fcd11f1b1788b6acf885367-20260804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Dcq6KvToLY8RXeRwKZY8lWOQzYPl0qxL7K9MxmMPL6I=;
	b=OUzfjG532skcjcsXcPbA3gduEJYYqBJM4pv+LpW+Q3KrSo9PEzDeYXLV4mGgx16p32zsi6EjeAw6Ozd7Lq5OAQJd2G2P+Qx93JNd0PGoA8uw3X5mdA0+S4orTy77ZHVLuGVUqBqvDzQ033qNk4vOYuwGzqGGZbABGRWZJwYw1vQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:56a0373c-dca9-4963-b2ed-2c8d72d1935e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:c64081f1-0685-46a3-9cac-19d8f3a05ae7,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 188bd1588fcd11f1b1788b6acf885367-20260804
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1228004395; Tue, 04 Aug 2026 14:24:06 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 4 Aug 2026 14:24:05 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 4 Aug 2026 14:24:05 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<Shengwei.Lu@mediatek.com>, <litien.chang@mediatek.com>,
	<jb.tsai@mediatek.com>, Shengwei Lu <shengwei.lu@mediatek.com>, Sean Wang
	<sean.wang@mediatek.com>
Subject: [PATCH 2/2] [PATCH 2/2] wifi: mt76: mt7925: add STA_REC_SUSWM TLV for SU beamforming capability for MT7928
Date: Tue, 4 Aug 2026 14:24:03 +0800
Message-ID: <20260804062403.642593-2-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260804062403.642593-1-jb.tsai@mediatek.com>
References: <20260804062403.642593-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Shengwei Lu <shengwei.lu@mediatek.com>

MT7928 firmware requires a STA_REC_SUSWM TLV to convey SU beamforming
and spatial stream capabilities when associating with a BSS. Add:

 - sta_rec_su_swm struct with a capability bitmap (tag 0x1A)
 - STA_REC_SUSWM enum entry in the STA record tag list
 - mt7928_mcu_sta_suswm_tlv() that resolves the peer link_sta and own
   sband, then calls mt7928_get_bss_suswm_cap() to obtain the SU BF
   bfer/bfee/nsts summary and fills the TLV
 - Call site in mt7925_mcu_sta_cmd() guarded by is_mt7928()

The capability bitmap bit layout passed to firmware:
  bit 0 - AP is SU beamformer capable
  bit 1 - local device is SU beamformee capable
  bit 2 - AP NSTS <= 2 (within supported spatial-stream limit)

Signed-off-by: Shengwei Lu <shengwei.lu@mediatek.com>
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 67 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  8 +++
 3 files changed, 76 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 51380849d24e..b2c79d65525a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -857,6 +857,7 @@ enum {
 	STA_REC_PHY = 0x15,
 	STA_REC_HE_6G = 0x17,
 	STA_REC_HE_V2 = 0x19,
+	STA_REC_SUSWM = 0x1A,
 	STA_REC_MLD = 0x20,
 	STA_REC_EHT_MLD = 0x21,
 	STA_REC_EHT = 0x22,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 983a9eacd8c7..e94742c8c370 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -8,6 +8,7 @@
 #include "mcu.h"
 #include "mac.h"
 #include "nan.h"
+#include "ies.h"
 
 #define MT_STA_BFER			BIT(0)
 #define MT_STA_BFEE			BIT(1)
@@ -2110,6 +2111,70 @@ mt7925_mcu_sta_mld_tlv(struct sk_buff *skb,
 	mld->link_num = cnt;
 }
 
+static void
+mt7928_mcu_sta_suswm_tlv(struct sk_buff *skb,
+			 struct ieee80211_vif *vif, struct mt76_wcid *wcid)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_phy *phy = mvif->phy;
+	struct ieee80211_link_sta *link_sta;
+	struct ieee80211_bss_conf *link_conf;
+	struct cfg80211_chan_def *chandef;
+	struct mt792x_bss_conf *mconf;
+	enum nl80211_band band;
+	struct ieee80211_sta *sta;
+	struct ieee80211_supported_band *sband;
+	const struct cfg80211_bss_ies *ies;
+	struct cfg80211_bss *bss;
+	struct mt7928_suswm_cap cap = {};
+	struct sta_rec_su_swm *su_swm;
+	struct tlv *tlv;
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->cfg.assoc)
+		return;
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+
+	if (!sta)
+		goto exit;
+
+	link_sta = mt792x_sta_to_link_sta(vif, sta, wcid->link_id);
+
+	if (!link_sta)
+		goto exit;
+
+	link_conf = mt792x_vif_to_bss_conf(vif, link_sta->link_id);
+	mconf = mt792x_vif_to_link(mvif, link_sta->link_id);
+
+	chandef = mconf->mt76.ctx ? &mconf->mt76.ctx->def :
+				    &link_conf->chanreq.oper;
+	band = chandef->chan->band;
+
+	sband = phy->mt76->hw->wiphy->bands[band];
+
+	bss = link_conf->bss;
+	if (!bss || !bss->ies)
+		goto exit;
+
+	ies = rcu_dereference(bss->ies);
+
+	mt7928_get_bss_suswm_cap(ies, link_sta, sband, vif->type, &cap);
+
+	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_SUSWM, sizeof(*su_swm));
+	su_swm = (struct sta_rec_su_swm *)tlv;
+
+	if (cap.bfer_en)
+		su_swm->su_swm_cap_map |= MT_SU_SWM_BFER;
+	if (cap.bfee_en)
+		su_swm->su_swm_cap_map |= MT_SU_SWM_BFEE;
+	if (cap.nsts > 0 && cap.nsts <= 2)
+		su_swm->su_swm_cap_map |= MT_SU_SWM_NSTS_MEET;
+
+exit:
+	rcu_read_unlock();
+}
+
 static void
 mt7925_mcu_sta_remove_tlv(struct sk_buff *skb)
 {
@@ -2179,6 +2244,8 @@ mt7925_mcu_sta_cmd(struct mt76_phy *phy,
 			mlink = &mvif->sta.deflink;
 
 		mt7925_mcu_sta_hdr_trans_tlv(skb, info->vif, mlink);
+		if (is_mt7928(dev))
+			mt7928_mcu_sta_suswm_tlv(skb, info->vif, info->wcid);
 	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, info->cmd, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 11f9eac13ffc..f8696ce36413 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -493,6 +493,13 @@ struct sta_rec_eht_mld {
 	u8 __rsv2[3];
 } __packed;
 
+struct sta_rec_su_swm {
+	__le16 tag;
+	__le16 len;
+	u8   su_swm_cap_map;
+	u8 rsv[3];
+} __packed;
+
 struct bss_ifs_time_tlv {
 	__le16 tag;
 	__le16 len;
@@ -542,6 +549,7 @@ struct bss_rlm_tlv {
 					 sizeof(struct sta_rec_eht) +		\
 					 sizeof(struct sta_rec_hdr_trans) +	\
 					 sizeof(struct sta_rec_mld) +		\
+					 sizeof(struct sta_rec_su_swm) +		\
 					 sizeof(struct tlv) * 2 +		\
 					 sizeof(struct sta_rec_remove))
 
-- 
2.45.2

