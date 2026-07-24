Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8173AEF3B
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897302; cv=none; b=YkzdjkX4qwZOv7euQX05+gkGA2Vx6/sn687zbjiEQn6LYUifTB6N6hmH8tKKnrDWO9ReYiojrfGOjkqmBO/Nh/J+AEG3QbUfzMgWsYH6IBGCdP9txERusQc0znq783CMNABJV3gjLqhIzbne/R/DvFUe/ZgClDud11yR4RYAa+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897302; c=relaxed/simple;
	bh=a7kv9WCoXWN+SC4L/TYN4YvcWYSDsxfRk8bIQgkLw+E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBni2prP/ZXsuI1jLK6Kk6uNHsgQcHKIYtOkBRAm5bBsP9jW/OL/WHN9tKPskJ/cikpRcjtNGGhfpcgJ1hUSEUUv3Z8WfvLzuqqqFeneq6A53ndAiWEcKBsXoDfOKbPbZNPwZpeD9v+4gc+v/2Ae4kal85SC5pxtgq6DK1fVLAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=NthPo1/s; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="NthPo1/s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MvDtRLXQ61FvTzGDHk7mTymZgsAjqMstePzfZQ/jUGw=; b=NthPo1/sdG0Sb0yIXb6wG4puex
	Ynt/Kt+fyTzjcirgvt64+wubSgLnXYazTpSSEFeedKQeRlQEITZUO7D3oF0Bsl+drS6XIZp/R7EmI
	+KjrD246iloWEFtW5LJHFAVFb4DeFu4GxQBGdYTuwcP7Prqp9ws83PDcFa9B3pGZdD2o=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK6-006LeO-0a
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:18 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 15/29] wifi: mt76: mt7996: add mcu command to set bssid mapping address
Date: Fri, 24 Jul 2026 12:47:59 +0000
Message-ID: <20260724124813.3961474-15-nbd@nbd.name>
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

From: Peter Chiu <chui-hao.chiu@mediatek.com>

When receiving a 4 address non-AMSDU packet, there is no bssid in the
address fields, which breaks powersave handling for 4-address peers.
Set the mcu command to use A1 as bssid when receiving 4 address
non-AMSDU packets on mt7992 and mt7990.

Also skip mt7996_mac_init_band() for invalid bands, so the command is
only sent for bands that actually exist on the device.

Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/init.c  |  6 +++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 26 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   |  1 +
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 4 files changed, 34 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index a344829f5a01..ee1f7a9f4851 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -562,6 +562,9 @@ mt7996_mac_init_band(struct mt7996_dev *dev, u8 band)
 {
 	u32 mask, set;
 
+	if (!mt7996_band_valid(dev, band))
+		return;
+
 	/* clear estimated value of EIFS for Rx duration & OBSS time */
 	mt76_wr(dev, MT_WF_RMAC_RSVD0(band), MT_WF_RMAC_RSVD0_EIFS_CLR);
 
@@ -593,6 +596,9 @@ mt7996_mac_init_band(struct mt7996_dev *dev, u8 band)
 	 * MT_AGG_ACR_PPDU_TXS2H (PPDU format) even though ACR bit is set.
 	 */
 	mt76_set(dev, MT_AGG_ACR4(band), MT_AGG_ACR_PPDU_TXS2H);
+
+	if (!is_mt7996(&dev->mt76))
+		mt7996_mcu_set_bssid_mapping_addr(&dev->mt76, band);
 }
 
 static void mt7996_mac_init_basic_rates(struct mt7996_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 09fcddb8e21d..69676a605549 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -5042,6 +5042,32 @@ int mt7996_mcu_twt_agrt_update(struct mt7996_dev *dev,
 				 &req, sizeof(req), true);
 }
 
+int mt7996_mcu_set_bssid_mapping_addr(struct mt76_dev *dev, u8 band_idx)
+{
+	enum {
+		BSSID_MAPPING_ADDR1,
+		BSSID_MAPPING_ADDR2,
+		BSSID_MAPPING_ADDR3,
+	};
+	struct {
+		u8 band_idx;
+		u8 _rsv1[3];
+
+		__le16 tag;
+		__le16 len;
+		u8 addr;
+		u8 _rsv2[3];
+	} __packed req = {
+		.band_idx = band_idx,
+		.tag = cpu_to_le16(UNI_BAND_CONFIG_BSSID_MAPPING_ADDR),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.addr = BSSID_MAPPING_ADDR1,
+	};
+
+	return mt76_mcu_send_msg(dev, MCU_WM_UNI_CMD(BAND_CONFIG),
+				 &req, sizeof(req), true);
+}
+
 int mt7996_mcu_set_rts_thresh(struct mt7996_phy *phy, u32 val)
 {
 	struct {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index c673e986ecb5..b53a9e71c281 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -927,6 +927,7 @@ enum {
 	UNI_BAND_CONFIG_RADIO_ENABLE,
 	UNI_BAND_CONFIG_RTS_THRESHOLD = 0x08,
 	UNI_BAND_CONFIG_MAC_ENABLE_CTRL = 0x0c,
+	UNI_BAND_CONFIG_BSSID_MAPPING_ADDR = 0x12,
 };
 
 enum {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 60397a1b1a2b..dcacc7d06e85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -772,6 +772,7 @@ int mt7996_mcu_set_protection(struct mt7996_phy *phy, struct mt7996_vif_link *li
 			      u8 ht_mode, bool use_cts_prot);
 int mt7996_mcu_set_timing(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *link_conf);
+int mt7996_mcu_set_bssid_mapping_addr(struct mt76_dev *dev, u8 band_idx);
 int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch);
 int mt7996_mcu_get_temperature(struct mt7996_phy *phy);
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state);
-- 
2.53.0

