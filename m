Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0A19E96D;
	Mon, 19 Oct 2026 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402422; cv=none; b=NxBttMCDoDFF9RA1wGcDDpdb8thQGQuRKsqT5Yp8WMhbtKOKb+MTOYniMYpeaJUYCVZBM9tEusnpikCVOVGGUgKVXnaCPDsyS2fsPQ+zAge3Qan+xAyZJyc09Yjt872DDN4wMBpRpwjON/zGIHKrhN+AqnASUe7b/s9eIW05EqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402422; c=relaxed/simple;
	bh=NsIB6m/6g1hAm0Cl5jwFp1e86vmzBE3E10CQT4it3yg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DRAVuW6jyjI4REXJjG0SGrHjGhw9bHNVxPoPouC6XksZroDoo+AZZSfoAIDhAb2ChZHklACo+8wBuZksoDm92Zjcaon8u4waNAOcI1l0HR2d0KMOZCwrn34WC1nT9/KKxy7YAmsiKuCaApVNUlq4PCqCol6El9E1vCXazNfkdV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VIDLGR7h; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VIDLGR7h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=HG
	oDgbos5+KdTiduVlTaFvmQwj1yhcEDAezKlFJuiUM=; b=VIDLGR7h9Gf7GRW2CC
	13+mY+KznJtEuEr7MvA8Mkpgu8xFI4xjkCHnrYENkN6YlH1DZysP6tKagS5kmvoV
	6ByaWkpDqQ6emK8UYsWMWbD055vyGhdhHY9y8+6NWOx0/xwKtGZQmKyTk5bpiVFM
	Ci2j2qOzskLkx0UTEGwWcl7Yg=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3H73U49VqbIAVBQ--.320S4;
	Mon, 19 Oct 2026 17:33:15 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <jiale.yao@example.com>
Subject: [PATCH 2/2] wifi: mt76: mt7996: clamp EHT beamforming NSS
Date: Mon, 19 Oct 2026 17:33:07 +0800
Message-Id: <20261019093307.1869749-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019093307.1869749-1-yaojiale02@163.com>
References: <20261019093307.1869749-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H73U49VqbIAVBQ--.320S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxGrW7ZFy3Xry8ArykCw4rZrb_yoW5WF1kp3
	yfZa42vr4xA3y8W3WfArs7tr98Ga13G34akw4kWrs3CryfKFyxJF4xuF9xJFyrAF4UAry3
	Zw1DArn8Wa4Y9FDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Utb1nUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xs-eWrV49tfsQAA3b

From: Jiale Yao <jiale.yao@example.com>

An EHT peer can advertise zero receive spatial streams for an MCS
range.  The beamforming setup decrements that value, causing an
underflow and sending an invalid column count to firmware.

Clamp the converted NSS value to zero for 80, 160, and 320 MHz
beamforming configurations.

Fixes: ba01944adee9 ("wifi: mt76: mt7996: add EHT beamforming support")
Signed-off-by: Jiale Yao <jiale.yao@example.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index e6243dd33c31..29b67248fad7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1969,7 +1969,7 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_link_sta *link_sta,
 	struct ieee80211_eht_cap_elem_fixed *pe = &pc->eht_cap_elem;
 	struct ieee80211_eht_mcs_nss_supp *eht_nss = &pc->eht_mcs_nss_supp;
 	u8 nss_mcs = u8_get_bits(eht_nss->bw._80.rx_tx_mcs9_max_nss,
-				 IEEE80211_EHT_MCS_NSS_RX) - 1;
+				 IEEE80211_EHT_MCS_NSS_RX);
 	const struct ieee80211_eht_cap_elem_fixed *ve;
 	const struct ieee80211_sta_eht_cap *vc;
 	u8 snd_dim, sts;
@@ -1988,6 +1988,7 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_link_sta *link_sta,
 	snd_dim = EHT_PHY(CAP2_SOUNDING_DIM_80MHZ_MASK, ve->phy_cap_info[2]);
 	sts = EHT_PHY(CAP0_BEAMFORMEE_SS_80MHZ_MASK, pe->phy_cap_info[0]) +
 	      (EHT_PHY(CAP1_BEAMFORMEE_SS_80MHZ_MASK, pe->phy_cap_info[1]) << 1);
+	nss_mcs = nss_mcs ? nss_mcs - 1 : 0;
 	bf->nrow = min_t(u8, snd_dim, sts);
 	bf->ncol = min_t(u8, nss_mcs, bf->nrow);
 	bf->ibf_ncol = explicit ? min_t(u8, MT7996_IBF_MAX_NC, bf->ncol) :
@@ -2001,7 +2002,8 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_link_sta *link_sta,
 		snd_dim = EHT_PHY(CAP2_SOUNDING_DIM_160MHZ_MASK, ve->phy_cap_info[2]);
 		sts = EHT_PHY(CAP1_BEAMFORMEE_SS_160MHZ_MASK, pe->phy_cap_info[1]);
 		nss_mcs = u8_get_bits(eht_nss->bw._160.rx_tx_mcs9_max_nss,
-				      IEEE80211_EHT_MCS_NSS_RX) - 1;
+				      IEEE80211_EHT_MCS_NSS_RX);
+		nss_mcs = nss_mcs ? nss_mcs - 1 : 0;
 
 		bf->nrow_gt_bw80 = min_t(u8, snd_dim, sts);
 		bf->ncol_gt_bw80 = nss_mcs;
@@ -2012,7 +2014,8 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_link_sta *link_sta,
 				   ve->phy_cap_info[3]) << 1);
 		sts = EHT_PHY(CAP1_BEAMFORMEE_SS_320MHZ_MASK, pe->phy_cap_info[1]);
 		nss_mcs = u8_get_bits(eht_nss->bw._320.rx_tx_mcs9_max_nss,
-				      IEEE80211_EHT_MCS_NSS_RX) - 1;
+				      IEEE80211_EHT_MCS_NSS_RX);
+		nss_mcs = nss_mcs ? nss_mcs - 1 : 0;
 
 		bf->nrow_gt_bw80 = min_t(u8, snd_dim, sts) << 4;
 		bf->ncol_gt_bw80 = nss_mcs << 4;
-- 
2.34.1

