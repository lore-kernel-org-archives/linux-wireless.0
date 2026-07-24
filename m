Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BFA2931D7
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897299; cv=none; b=MeQhl35nzwSbs1Vi48P+1xiV2j54TCRizL+sj/0Sdj1T4QHStljSjjRf1g5roeSqxdmxiQXn0mhOP2vDMB/b7FLXVBnqdy7q8uRw4wsKmxOPDY+Sy8b5tMMZgqBIU916mMxjgvnhPmmZDf0yIXnoxpSbjTEi9alT4oywczysNvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897299; c=relaxed/simple;
	bh=kpsWJahoHEYg/ppRQNZZD4xAUMwc2iIMqYYE7c4Shgs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvP1XyKK2LdkilrsKYwJjEIvZ8gK9LUYIYj3rEiPd9R6s7RF/Ojiy88WtVVdRMxWTvlDRC7mGNnvhE7l7E5N1bM5CvqPJsxI73gbnQ2HoeYU8R0Q34XCCAtN+3V55L7V8lYLIYdDTnHB3Enrc6011V7ljLisWhlWrsHgQ+K/dk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=pD2FGPzp; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="pD2FGPzp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SJ4Aax0ADtPQ9wft37/Q85lPvTQK0J1WMfntcDRUZos=; b=pD2FGPzpNp1WLQKh46LYDAAI/c
	25exJdXxL7e3kd6xm3IMKjQu8eJJAbTBjU2zJB5xk4Y7ySNP+Qkf7468Scc8Ya0jr6V9EdbJohUmt
	pj6H9PjCSpyngHoejQXUcIkOSIBtUZc34kvtPnZLS6Gw4nOLFxy0UCCy5iXvZ26XB0d0=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK4-006LeO-1m
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 06/29] wifi: mt76: decode the full VHT Rx STBC capability field
Date: Fri, 24 Jul 2026 12:47:50 +0000
Message-ID: <20260724124813.3961474-6-nbd@nbd.name>
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

The Rx STBC subfield of the VHT capabilities is a 3-bit cumulative value,
but the driver only tested the RXSTBC_1 bit when advertising the peer's
Rx STBC support to firmware. A peer reporting Rx STBC of 2, 3 or 4 has
that bit clear, so STBC was never used towards it. Test the full
IEEE80211_VHT_CAP_RXSTBC_MASK, matching the HT path.

Fixes: 046d2e7c50e3 ("mac80211: prepare sta handling for MLO support")
Fixes: 2660fde82f65 ("wifi: mt76: mt7996: Update mt7996_mcu_add_rate_ctrl to MLO")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 0ee21fcc83c1..459dbcc9d90e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1617,7 +1617,7 @@ mt7915_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb, struct mt7915_dev *dev,
 			cap |= STA_CAP_VHT_SGI_160;
 		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_TXSTBC)
 			cap |= STA_CAP_VHT_TX_STBC;
-		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_1)
+		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
 			cap |= STA_CAP_VHT_RX_STBC;
 		if (mvif->cap.vht_ldpc &&
 		    (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 73ca92081ca0..1b334cbf6d72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2476,7 +2476,7 @@ mt7996_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb, struct mt7996_dev *dev,
 			cap |= STA_CAP_VHT_SGI_160;
 		if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_TXSTBC)
 			cap |= STA_CAP_VHT_TX_STBC;
-		if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_1)
+		if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
 			cap |= STA_CAP_VHT_RX_STBC;
 		if ((vif->type != NL80211_IFTYPE_AP || link_conf->vht_ldpc) &&
 		    (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC))
-- 
2.53.0

