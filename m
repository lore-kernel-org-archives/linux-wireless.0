Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170C39A047
	for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2026 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781970821; cv=none; b=D0FXOmTEiGtLeE3iR7cxQ2Blqvrsg10AH3OPjIYsaaeDOATsiSYdtLCIZpWmOi1Do/Hx8YGZmUkwrW+md6MYMsZQZ1YJ8KL3efRxssQQ5cBvkJ6JkmJHRLR8ObR7w5Q2xzOmxjc8IRP7tYKQMzJVpEWB10ofxERMI8109CXtric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781970821; c=relaxed/simple;
	bh=PiCuRPIyYevGR0LFSL9xpuykBtiAMjwNoMGx+cj7ozk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CKKKajt6DdLgDtz7Ng89rr48kapgreKtKozyuWJuttFKkoDz7Lutr9EiqR7osfv1vuOe8aMbqJy6QQDenp3bLbLwQ3WmZEddV/JJk+bmwHeCYV8VF3Uiaxomi2WZg0uKFCO7Rr1hidyfn4R+hKgTpxRldfR1CvfqcpH3AB0NUnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/rMdazw; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/rMdazw"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36d630c0e35so3027346a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2026 08:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781970819; x=1782575619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xzjyojuMRuFwFVplXB0k7oZX5NvBxe6hl8pliXZwUvw=;
        b=k/rMdazwq+FP/YSiR71a1d1MQEnmYy5IfTL+lu5lEy0ppNvlZQ+mqMB+9Jtl8rn4S/
         mhHrQDzB/M3jt7bKwV+EAndAOimR+0avIavurYovR3JYrHSrV72OAytEpltGsLRcUFsj
         xI7wqAvvslAr1SCvgizM8KdbrAPF+0TKKKUYwvYsyLzxQ8PgBR5CSrbx1xbMYjL5xV3m
         ADU0qY+xaJKZlG/FzZw/TVphX8dO8qUJc/m60H/fM1CukFdDi6+TT3OFE9Pu9rjjpGw7
         d1VV2khJuJHblz+rAcrpezQ51u5eh02YhZUG8QNays/dRMk2rfCvA6oeXwecTCZE5MD+
         B2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781970819; x=1782575619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzjyojuMRuFwFVplXB0k7oZX5NvBxe6hl8pliXZwUvw=;
        b=YofIzAVM0mWH3QOfsFlpmdC19/PUvdM1q9Ny4UsZVmXRAAAUML7UM+lgaZs8X3OggI
         pvHA0bwBvWNS5066AjOqIU3NgdMinzYdmIdOj9gS4uhlB27vzbgqJCdYt+bpcDOHfOK6
         POvsm8/GoYHtj6yqxytgd/s+lRXZK9twIf69SKCqnSyThdLNzpbWMM6qrLxqxqD122/1
         9dxeqQn0/nPjIlNGl8qtmOYwEJWLDyO6DkA/54LFYrHMrluZ3A8NDD3Jz6hniNKN1WNU
         W2HpMtJOmdz/Sn57NV7OpsRsWoJb/IPVanOlp/9cvLWFZWhzGGg0O+CRwuBXKctK21ew
         a2kg==
X-Gm-Message-State: AOJu0YyasOO1hx+Ycle7P0JvVoPH1OBPVMDQbXYolRSwjz73nB3+ss50
	cVSzFpmIQM1mhwk06grka0T3QW1dyi3HnieoFtIkFdNfQRJsOwZmlDzX
X-Gm-Gg: AfdE7cmVQyGIm55Lh7J7iECJPI4D2mGZpQM5dPraM3/puOXooDmmHzxLyYzwisklPWf
	BkPT6EqbBn5xRJltI87rFw1oQsNtdCyYZIcK9cQa0fbOiMN9U2hu/p9hhL1zDOlJxJx+bC+T1Sg
	Mzsx045aXZ2gRR1BQxZ5NyOS8R/z1Al/lQs0jehI2AoyzvbbK2sYuzmYJeCHQfxbTeQXzYCOD6s
	D7no3dqCx1rzej6scQiyamOZKSAITvHiYUsI5PfwKH51unKnW538/5SZhokH5o+uwl98cL3vO8G
	TjoVRdrTPhGZ+mnbE3U0AnVJfOI4WxuYPi+nPhUFFPawNDL24SBBsObtdswF+t1fnM4UupM+nfX
	slBZddiRsERSVtBbaY+v4lyrBjXcpxfOKDmx3UPsF0Bx3KM8vODeWqqcyxxyO5PrKe7PnV0KfGL
	Gmjiw9jYHUhCeyZgb2W3sBsEj99vS3DECs
X-Received: by 2002:a17:902:fc50:b0:2c2:f675:32c5 with SMTP id d9443c01a7336-2c718f3ec26mr90957095ad.29.1781970819245;
        Sat, 20 Jun 2026 08:53:39 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:8e0e:956e:b09c:23cd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af558sm31848775ad.14.2026.06.20.08.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 08:53:38 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] wifi: mt76: mt7915: guard HE capability lookups
Date: Sat, 20 Jun 2026 23:53:32 +0800
Message-ID: <20260620155332.81120-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7915_mcu_bss_he_tlv() and mt7915_mcu_sta_bfer_tlv() both run after
checking HE support, then dereference the HE PHY capability returned by
mt76_connac_get_he_phy_cap(). That helper can return NULL when no
capability entry matches the vif type.

Fetch the capability before appending the TLV and skip the HE-specific
setup when no matching capability is available.

Fixes: e6d557a78b60 ("mt76: mt7915: rely on mt76_connac_get_phy utilities")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 318c38149463..391c91675130 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -595,6 +595,8 @@ mt7915_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1177,13 +1179,12 @@ mt7915_mcu_sta_bfer_vht(struct ieee80211_sta *sta, struct mt7915_phy *phy,
 }
 
 static void
-mt7915_mcu_sta_bfer_he(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
-		       struct mt7915_phy *phy, struct sta_rec_bf *bf)
+mt7915_mcu_sta_bfer_he(struct ieee80211_sta *sta,
+		       const struct ieee80211_sta_he_cap *vc,
+		       struct sta_rec_bf *bf)
 {
 	struct ieee80211_sta_he_cap *pc = &sta->deflink.he_cap;
 	struct ieee80211_he_cap_elem *pe = &pc->he_cap_elem;
-	const struct ieee80211_sta_he_cap *vc =
-		mt76_connac_get_he_phy_cap(phy->mt76, vif);
 	const struct ieee80211_he_cap_elem *ve = &vc->he_cap_elem;
 	u16 mcs_map = le16_to_cpu(pc->he_mcs_nss_supp.rx_mcs_80);
 	u8 nss_mcs = mt7915_mcu_get_sta_nss(mcs_map);
@@ -1242,6 +1243,7 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 {
 	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
 	struct mt7915_phy *phy = mvif->phy;
+	const struct ieee80211_sta_he_cap *vc = NULL;
 	int tx_ant = hweight8(phy->mt76->chainmask) - 1;
 	struct sta_rec_bf *bf;
 	struct tlv *tlv;
@@ -1260,6 +1262,12 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 	if (!ebf && !dev->ibf)
 		return;
 
+	if (sta->deflink.he_cap.has_he && ebf) {
+		vc = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+		if (!vc)
+			return;
+	}
+
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_BF, sizeof(*bf));
 	bf = (struct sta_rec_bf *)tlv;
 
@@ -1268,7 +1276,7 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 	 * ht: iBF only, since mac80211 lacks of eBF support
 	 */
 	if (sta->deflink.he_cap.has_he && ebf)
-		mt7915_mcu_sta_bfer_he(sta, vif, phy, bf);
+		mt7915_mcu_sta_bfer_he(sta, vc, bf);
 	else if (sta->deflink.vht_cap.vht_supported)
 		mt7915_mcu_sta_bfer_vht(sta, phy, bf, ebf);
 	else if (sta->deflink.ht_cap.ht_supported)
