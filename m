Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B045E282F3C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897299; cv=none; b=ZMbKmY5iNKnuaqOoN5W3ILc90/0eALwjTKBr2aja/fhe6hSFI5Eg3YKWs/SUCEcEfu0iyRFSUEl2KwaXWNdTqQiC0dlJcmKymshZNy1rlfird5PJBxkJOUEfwQp6vrKBOY4B3x71Hdtlymb8Np7tvyihNfuDj5NdiE02HsWFjkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897299; c=relaxed/simple;
	bh=Xm900JzWYykevmVrOZR7UUVIRzw+3BO84jy/CQj00GA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Gg0+KqlFVVIc1/xq7uSM0x+7fvvsQE1qg7IQdsMpES3seU1MNFWaAn8OT5zRn9RBjbymQK5Tnp0rSqbqt2e5DrPqtx4RjmtS09LB7Qe1MDpv/8MPWMw+yX9qK0Y+CXCXpSYvbPa48RXIyGfT9eqNJY6gVMRB4DtaSFuwjC/1IX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EAw/BMWv; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EAw/BMWv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+oiys/LcRnI36rl7Z4M11WxoSSwJs3GEYKUb1sHa28c=; b=EAw/BMWvEv1Avy5cCJaIb/TvEh
	+o8mUkSA6FxjuXeeKEsn+18lODD6Jrpl6GUXDmrO9aNTfUJTAK3iKGa+5BCvgnolWkPLlItMDTh1Y
	GmuFyprXuoEry07uK0YkBM1z3TbgXjWJPK9csomj0NzWb1Th0i2qf8nrt16+1VnTpGLM=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK3-006LeO-2G
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 01/29] wifi: mt76: fix HE DCM max-RU capability encoding
Date: Fri, 24 Jul 2026 12:47:45 +0000
Message-ID: <20260724124813.3961474-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sta_rec_he.dcm_rx_max_nss was assigned twice: the second assignment,
sourced from HE PHY capability byte 8 (DCM max RU), overwrote the RX-NSS
value and left dcm_max_ru at zero. Every associated HE station advertising
DCM support was configured in firmware with a wrong dcm_rx_max_nss and a
zero dcm_max_ru. Store the DCM max-RU value in dcm_max_ru as intended.

The same copy-paste error existed in both the shared connac2 path and the
mt7915 path.

Fixes: c336318f57a9 ("mt76: mt7915: add HE capabilities support for peers")
Fixes: 67aa27431c7f ("mt76: mt7921: rely on mt76_connac_mcu common library")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 562d4b936d6c..ed6a0c92e8e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -800,7 +800,7 @@ mt76_connac_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta)
 		HE_PHY(CAP3_DCM_MAX_CONST_RX_MASK, elem->phy_cap_info[3]);
 	he->dcm_rx_max_nss =
 		HE_PHY(CAP3_DCM_MAX_RX_NSS_2, elem->phy_cap_info[3]);
-	he->dcm_rx_max_nss =
+	he->dcm_max_ru =
 		HE_PHY(CAP8_DCM_MAX_RU_MASK, elem->phy_cap_info[8]);
 
 	he->pkt_ext = 2;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 4409962b20e2..0ee21fcc83c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -900,7 +900,7 @@ mt7915_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 		HE_PHY(CAP3_DCM_MAX_CONST_RX_MASK, elem->phy_cap_info[3]);
 	he->dcm_rx_max_nss =
 		HE_PHY(CAP3_DCM_MAX_RX_NSS_2, elem->phy_cap_info[3]);
-	he->dcm_rx_max_nss =
+	he->dcm_max_ru =
 		HE_PHY(CAP8_DCM_MAX_RU_MASK, elem->phy_cap_info[8]);
 
 	he->pkt_ext = 2;
-- 
2.53.0

