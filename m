Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC3829346F
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897299; cv=none; b=jR/irZpC5jgvjMbQp9l8cd1QiujdXP/OS1eZUbJjxfrLzpkTY5y40BJ7Xd5gQ63n6JLE2yyKbui4SPlge1XTEYjfVZuce7L9MRC8Ed1zj8bMbZF+VbYdYrMki6+9VumeqX7yM7acSlWOZVjR7vzi257uTnkPYPF9CZgA+e9i7lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897299; c=relaxed/simple;
	bh=cR7HUqKfxrYdfVTX5vl9OsPrhCVDpn72U/DZXVHfb6w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JibVwXVxqKOt9hyflr+JlBTYj2bH603CrvXHZhI767oLOuCUZyYi74AR/n+fkzulJYBO+3B81e3vCTc6bn9y9PZx5+uXPMa+JCRdeppoKMFZ5ny/W7x2zyovpla/pQW+Ct8m0qg1JWt+z53+h42hbo8k7R9ZmXdJwDow5Vmpffw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=QZbrOCSh; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="QZbrOCSh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fZe33zsbvplm3ZAwFiuEQzMMuPrr8BmIoz4a30ymqng=; b=QZbrOCShNo3SSR0lIDqXi5KhWD
	3kvwQHrvhvgb6OMhR+Y8z9EYpGMeiMp/OWNs2Af8Ft3jNjwj/0EucQ+Tf3egYqr/GiLNyz7DaXQLo
	mDZJSK71QQi3kZBT8QUUSAsBr2d8WaUsxYaSUj4bzU728bzaCpxqi2ZXv7N/bVB16T/E=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK4-006LeO-2K
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 07/29] wifi: mt76: fix ER-SU 106-tone RU check in RX rate decode
Date: Fri, 24 Jul 2026 12:47:51 +0000
Message-ID: <20260724124813.3961474-7-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MT_PHY_TYPE_HE_EXT_SU is an enum value (9), not a bit flag, so the
bitwise test "*mode & MT_PHY_TYPE_HE_EXT_SU" also matches OFDM, HT-GF and
several HE/EHT modes. Only genuine ER-SU should be classified as a
106-tone RU at 40 MHz; use an equality comparison.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: d832f5e73815 ("mt76: connac: move mt76_connac2_mac_fill_rx_rate in connac module")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 0ac3ab42ea40..cbf6a987cf90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -1114,7 +1114,7 @@ int mt76_connac2_mac_fill_rx_rate(struct mt76_dev *dev,
 	case IEEE80211_STA_RX_BW_20:
 		break;
 	case IEEE80211_STA_RX_BW_40:
-		if (*mode & MT_PHY_TYPE_HE_EXT_SU &&
+		if (*mode == MT_PHY_TYPE_HE_EXT_SU &&
 		    (idx & MT_PRXV_TX_ER_SU_106T)) {
 			status->bw = RATE_INFO_BW_HE_RU;
 			status->he_ru =
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index e0a1076ac706..866752f2fa24 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -349,7 +349,7 @@ mt7996_mac_fill_rx_rate(struct mt7996_dev *dev,
 	case IEEE80211_STA_RX_BW_20:
 		break;
 	case IEEE80211_STA_RX_BW_40:
-		if (*mode & MT_PHY_TYPE_HE_EXT_SU &&
+		if (*mode == MT_PHY_TYPE_HE_EXT_SU &&
 		    (idx & MT_PRXV_TX_ER_SU_106T)) {
 			status->bw = RATE_INFO_BW_HE_RU;
 			status->he_ru =
-- 
2.53.0

