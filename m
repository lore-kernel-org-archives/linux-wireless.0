Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533138F653
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 06:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785824655; cv=none; b=F/f2kzh2wqGFKZ9q68VJm4FDqY9Tu2EgAmKLykVo0pAKDo66xQ9NNn1GDhzvKaJH1O4E04Z7ICb6BJUruficHokq4XNypKvpnenPTZjyHdKSUm0oaGZuJ6JbdgzQoym28ht/MNiPwFE8Rnd3aYvNQ8T1lZW2SuYCs/Iaju22d9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785824655; c=relaxed/simple;
	bh=/wbGh9ZJbhI5pYB94HVG+Sa+FGQR+cVgqRy8US7vZrw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o2Oaf2eH/ceUjLQEQPEdPw3ty7gijTmWc5WytHdSRSv57kEXCr6Ao90nqEIrDWkAyDs3RmCUb4G/AA7gB2bXuTE7hKTC2PlwMABtfNHSHACueFA84fwZcPSn3Lrro0vvPAZ2rlwTocDwjT7nfPJRCMPfjAaqI7/CKu+MFlnNOKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oI7Iewx9; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oI7Iewx9"
X-UUID: 17d0052c8fcd11f1b1788b6acf885367-20260804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=M3loX8ga7znSQULYfqy+ijlN4dXdSpPjSIiieTvPzf4=;
	b=oI7Iewx9Ge4TMLSTKkFUO4kZutokVOpu/tGFLSl3dA24T+BVWQWjio5HCurnCprg7BAOyCKVpB9yiA3kNMqMt3d9WCCPosFSVFIbjqOszaW2FegqUNP/ZMFtzHelJdoLQsi4ifpeh4KCDt0Cq2jSklfPgfz8aL6IyXGogE/HuFE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c7c3b47f-4152-4c2a-a87c-799b81548aa4,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:0733a3a7-8a7b-4c49-a0c0-42d13e7adac0,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 17d0052c8fcd11f1b1788b6acf885367-20260804
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1910206704; Tue, 04 Aug 2026 14:24:05 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 4 Aug 2026 14:24:04 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 4 Aug 2026 14:24:04 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<Shengwei.Lu@mediatek.com>, <litien.chang@mediatek.com>,
	<jb.tsai@mediatek.com>, Shengwei Lu <shengwei.lu@mediatek.com>, Sean Wang
	<sean.wang@mediatek.com>
Subject: [PATCH 1/2] [PATCH 1/2] wifi: mt76: mt7925: add IE-parsing helpers for AP NSTS extraction for MT7928
Date: Tue, 4 Aug 2026 14:24:02 +0800
Message-ID: <20260804062403.642593-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Add a dedicated module (ies.c / ies.h) that provides four helpers to
parse BSS IEs and extract the AP's maximum TX spatial-stream count
(NSTS):

 - mt7928_ht_nsts_from_ies()  - reads HT Capability TX MCS streams
 - mt7928_vht_nsts_from_ies() - reads VHT Capability TX MCS map
 - mt7928_he_nsts_from_ies()  - reads HE Capability TX MCS/NSS for 80 MHz
 - mt7928_eht_nsts_from_ies() - reads EHT Capability TX MCS/NSS

Also add mt7928_get_bss_suswm_cap() which walks the HT/VHT/HE/EHT caps
of both the AP (peer link_sta) and the local device (own sband) and
fills a struct mt7928_suswm_cap {bfer_en, bfee_en, nsts} summarising
the SU beamforming capabilities and the AP's NSTS count. The
MT_SU_SWM_{BFER,BFEE,NSTS_MEET} bitmap defines used by the STA_REC_SUSWM
TLV are also introduced here.

These helpers will be consumed by the STA_REC_SUSWM TLV builder to
determine whether the AP's NSTS count falls within the device's
supported spatial-stream limit.

Signed-off-by: Shengwei Lu <shengwei.lu@mediatek.com>
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt7925/ies.c   | 183 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/ies.h   |  31 +++
 3 files changed, 215 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/ies.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/ies.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
index f9dcc0bba393..af62c775c3d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_MT7925_COMMON) += mt7925-common.o
 obj-$(CONFIG_MT7925E) += mt7925e.o
 obj-$(CONFIG_MT7925U) += mt7925u.o
 
-mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o
+mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o ies.o
 mt7925-common-$(CONFIG_NL80211_TESTMODE) += testmode.o
 mt7925e-y := pci.o pci_mac.o pci_mcu.o
 mt7925u-y := usb.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/ies.c b/drivers/net/wireless/mediatek/mt76/mt7925/ies.c
new file mode 100644
index 000000000000..0eb7dc7665b3
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/ies.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
+#include "ies.h"
+
+u8 mt7928_ht_nsts_from_ies(const struct cfg80211_bss_ies *ies)
+{
+	const struct ieee80211_ht_cap *ht_cap;
+	const struct element *elem;
+	u8 nsts = 0, i, max_tx_streams;
+
+	elem = cfg80211_find_elem(WLAN_EID_HT_CAPABILITY,
+				  ies->data, ies->len);
+	if (!elem || elem->datalen < sizeof(*ht_cap))
+		return 0;
+
+	ht_cap = (const void *)elem->data;
+
+	if ((ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_RX_DIFF) &&
+	    (ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_DEFINED))
+		max_tx_streams =
+			((ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
+				>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
+	else
+		max_tx_streams = IEEE80211_HT_MCS_TX_MAX_STREAMS;
+
+	for (i = 0; i < max_tx_streams; i++) {
+		if (ht_cap->mcs.rx_mask[i])
+			nsts = i + 1;
+	}
+
+	return nsts;
+}
+
+u8 mt7928_vht_nsts_from_ies(const struct cfg80211_bss_ies *ies)
+{
+	const struct ieee80211_vht_cap *vht_cap;
+	const struct element *elem;
+	u16 tx_mcs_map;
+	u8 nsts = 0, i;
+
+	elem = cfg80211_find_elem(WLAN_EID_VHT_CAPABILITY,
+				  ies->data, ies->len);
+	if (!elem || elem->datalen < sizeof(*vht_cap))
+		return 0;
+
+	vht_cap = (const void *)elem->data;
+	tx_mcs_map = le16_to_cpu(vht_cap->supp_mcs.tx_mcs_map);
+
+	for (i = 0; i < 8; i++) {
+		if (((tx_mcs_map >> (2 * i)) & 0x3) != IEEE80211_VHT_MCS_NOT_SUPPORTED)
+			nsts = i + 1;
+	}
+
+	return nsts;
+}
+
+u8 mt7928_he_nsts_from_ies(const struct cfg80211_bss_ies *ies)
+{
+	const struct ieee80211_he_cap_elem *he_cap;
+	const struct ieee80211_he_mcs_nss_supp *mcs_nss;
+	const struct element *elem;
+	u8 mcs_nss_size;
+	u16 tx_mcs_80;
+	u8 nsts = 0, i;
+
+	elem = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_CAPABILITY,
+				      ies->data, ies->len);
+
+	if (!elem || elem->datalen < 1 + sizeof(*he_cap))
+		return 0;
+
+	he_cap = (const void *)(elem->data + 1);
+	mcs_nss_size = ieee80211_he_mcs_nss_size(he_cap);
+
+	if (elem->datalen < 1 + sizeof(*he_cap) + mcs_nss_size)
+		return 0;
+
+	mcs_nss = (const void *)(he_cap + 1);
+	tx_mcs_80 = le16_to_cpu(mcs_nss->tx_mcs_80);
+
+	for (i = 0; i < 8; i++) {
+		if (((tx_mcs_80 >> (2 * i)) & 0x3) != IEEE80211_HE_MCS_NOT_SUPPORTED)
+			nsts = i + 1;
+	}
+
+	return nsts;
+}
+
+u8 mt7928_eht_nsts_from_ies(const struct cfg80211_bss_ies *ies)
+{
+	const struct ieee80211_eht_cap_elem_fixed *eht_cap;
+	const struct ieee80211_he_cap_elem *he_cap;
+	const struct element *eht_elem, *he_elem;
+	const u8 *mcs_nss_data;
+	u8 mcs_nss_size;
+	u8 nsts = 0, i;
+
+	eht_elem = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY,
+					  ies->data, ies->len);
+	if (!eht_elem || eht_elem->datalen < 1 + sizeof(*eht_cap))
+		return 0;
+
+	he_elem = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_CAPABILITY,
+					 ies->data, ies->len);
+	if (!he_elem || he_elem->datalen < 1 + sizeof(*he_cap))
+		return 0;
+
+	eht_cap = (const void *)(eht_elem->data + 1);
+	he_cap = (const void *)(he_elem->data + 1);
+
+	mcs_nss_size = ieee80211_eht_mcs_nss_size(he_cap, eht_cap, true);
+	if (eht_elem->datalen < 1 + sizeof(*eht_cap) + mcs_nss_size)
+		return 0;
+
+	mcs_nss_data = (const u8 *)(eht_cap + 1);
+
+	for (i = 0; i < mcs_nss_size; i++)
+		nsts = (mcs_nss_data[i] >> 4) & 0xf;
+
+	return nsts;
+}
+
+void mt7928_get_bss_suswm_cap(const struct cfg80211_bss_ies *ies,
+			      const struct ieee80211_link_sta *link_sta,
+			      const struct ieee80211_supported_band *own_sband,
+			      enum nl80211_iftype iftype,
+			      struct mt7928_suswm_cap *cap)
+{
+	const struct ieee80211_sta_ht_cap *ht_cap = &link_sta->ht_cap;
+	const struct ieee80211_sta_vht_cap *vht_cap = &link_sta->vht_cap;
+	const struct ieee80211_sta_he_cap *he_cap = &link_sta->he_cap;
+	const struct ieee80211_sta_eht_cap *eht_cap = &link_sta->eht_cap;
+	const struct ieee80211_sta_vht_cap *own_vht_cap = &own_sband->vht_cap;
+	const struct ieee80211_sta_he_cap *own_he_cap =
+		ieee80211_get_he_iftype_cap(own_sband, iftype);
+	const struct ieee80211_sta_eht_cap *own_eht_cap =
+		ieee80211_get_eht_iftype_cap(own_sband, iftype);
+
+	cap->bfer_en = false;
+	cap->bfee_en = false;
+	cap->nsts = 0;
+
+	if (ht_cap->ht_supported)
+		cap->nsts = mt7928_ht_nsts_from_ies(ies);
+
+	if (vht_cap->vht_supported) {
+		if (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)
+			cap->bfer_en = true;
+
+		if (own_vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)
+			cap->bfee_en = true;
+
+		cap->nsts = mt7928_vht_nsts_from_ies(ies);
+	}
+
+	if (he_cap->has_he && own_he_cap) {
+		if (he_cap->he_cap_elem.phy_cap_info[3] &
+		    IEEE80211_HE_PHY_CAP3_SU_BEAMFORMER)
+			cap->bfer_en = true;
+
+		if (own_he_cap->he_cap_elem.phy_cap_info[4] &
+		    IEEE80211_HE_PHY_CAP4_SU_BEAMFORMEE)
+			cap->bfee_en = true;
+
+		cap->nsts = mt7928_he_nsts_from_ies(ies);
+	}
+
+	if (eht_cap->has_eht && own_eht_cap) {
+		if (eht_cap->eht_cap_elem.phy_cap_info[0] &
+		    IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMER)
+			cap->bfer_en = true;
+
+		if (own_eht_cap->eht_cap_elem.phy_cap_info[0] &
+		    IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMEE)
+			cap->bfee_en = true;
+
+		cap->nsts = mt7928_eht_nsts_from_ies(ies);
+	}
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/ies.h b/drivers/net/wireless/mediatek/mt76/mt7925/ies.h
new file mode 100644
index 000000000000..a1239f22ef54
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/ies.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear */
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#ifndef __MT7925_IES_H
+#define __MT7925_IES_H
+
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
+
+#define MT_SU_SWM_BFER		BIT(0)
+#define MT_SU_SWM_BFEE		BIT(1)
+#define MT_SU_SWM_NSTS_MEET	BIT(2)
+
+struct mt7928_suswm_cap {
+	bool bfee_en;
+	bool bfer_en;
+	u8 nsts;
+};
+
+u8 mt7928_ht_nsts_from_ies(const struct cfg80211_bss_ies *ies);
+u8 mt7928_vht_nsts_from_ies(const struct cfg80211_bss_ies *ies);
+u8 mt7928_he_nsts_from_ies(const struct cfg80211_bss_ies *ies);
+u8 mt7928_eht_nsts_from_ies(const struct cfg80211_bss_ies *ies);
+
+void mt7928_get_bss_suswm_cap(const struct cfg80211_bss_ies *ies,
+			      const struct ieee80211_link_sta *link_sta,
+			      const struct ieee80211_supported_band *own_sband,
+			      enum nl80211_iftype iftype,
+			      struct mt7928_suswm_cap *cap);
+
+#endif /* __MT7925_IES_H */
-- 
2.45.2

