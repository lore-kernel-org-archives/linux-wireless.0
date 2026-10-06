Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71983EF0AA
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320384; cv=none; b=dNEF7d3yFeUjuF2GgdRRzFYB0Cjl2vM0lodbchTGiwOETxQ78ieF2+GYVwZI6IJW11paFu47SHngh0o20xhX3fvuHXPEgRtNhWHMP6xPT89/HiWaGN3MOTkih9B6c+HbIPt+AWVsRQl0Z8NF1TpdZ4/rHBlxQxgzBx5f+SbElQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320384; c=relaxed/simple;
	bh=MmTifh9vU8SgXwAaO595Elz5PeArF4cd+NN03D4M3oI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBYssa3FEuIiri7qCxmmFuiPnjDRKWNHx1F867zoFNlzUwC6d6Nbb77jcYPXPXYQY6SbFoYUpcpB7dEBT4yWc7i8CAS7wq90jv5l1q1waT8WCO5zX3wnpyITijaqIDXJJI+Nd9LeJg1kkw6LHWNzpZRqzEbdtH/Ab4D426Vit9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=nfSgUvUE; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="nfSgUvUE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+iAgoqyGu8MwqpaziIM5i7R45ZBO4HeP2YpAkY05jeI=; b=nfSgUvUEoBcDvYhB5celL49cbv
	b5mvva46pBttdjeG68IuEVg3dD+vVXdqVZSMkeigK8zUctT/qRTuNPylvgBI89Ih3vvcA1a6QlCEZ
	mU16V/jTEixzOBRiFdsueWQjPXfNukf25HZu9cD/feO8ae9AJzG4psz/UJoVGZshpW24=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGB-00HAg3-2Y
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:39 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 02/27] wifi: mt76: mt7996: enable the SKU power limit table
Date: Tue,  6 Oct 2026 22:59:11 +0200
Message-ID: <20261006205936.669125-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mcu_set_txpower_sku() uploads the per-rate power limit table, but
the firmware applies it only after the driver enables the SKU power
limit. mt7915 does that in mt7915_mcu_set_sku_en(); mt7996 never does,
so the radio keeps the EEPROM target power and the configured tx power
has no effect.

Add the power control command and enable the table per band in
mt7996_run(), as the MediaTek vendor driver does.

The backoff table stays disabled. This driver does not build the
per-path limits; it pads that part of the message with zeros.

Fixes: f75e4779d215 ("wifi: mt76: mt7996: add txpower setting support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  5 +++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 34 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   | 23 +++++++++++++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 4 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d17d1dbb2038..c04e980f6ee7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -34,6 +34,11 @@ int mt7996_run(struct mt7996_phy *phy)
 	if (ret)
 		return ret;
 
+	ret = mt7996_mcu_set_tx_power_ctrl(phy, UNI_TXPOWER_SKU_POWER_LIMIT_CTRL,
+					   true);
+	if (ret)
+		return ret;
+
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
 
 	ieee80211_queue_delayed_work(dev->mphy.hw, &phy->mt76->mac_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index a534d07ea1e8..310ce18ec12c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -5488,6 +5488,40 @@ int mt7996_mcu_set_sniffer_mode(struct mt7996_phy *phy, bool enabled)
 				 sizeof(req), true);
 }
 
+int mt7996_mcu_set_tx_power_ctrl(struct mt7996_phy *phy, u8 power_ctrl_id, u8 data)
+{
+	struct mt7996_dev *dev = phy->dev;
+	struct tx_power_ctrl req = {
+		.tag = cpu_to_le16(power_ctrl_id),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.power_ctrl_id = power_ctrl_id,
+		.band_idx = phy->mt76->band_idx,
+	};
+
+	switch (power_ctrl_id) {
+	case UNI_TXPOWER_SKU_POWER_LIMIT_CTRL:
+		req.sku_enable = !!data;
+		break;
+	case UNI_TXPOWER_PERCENTAGE_CTRL:
+		req.percentage_ctrl_enable = !!data;
+		break;
+	case UNI_TXPOWER_PERCENTAGE_DROP_CTRL:
+		req.power_drop_level = data;
+		break;
+	case UNI_TXPOWER_BACKOFF_POWER_LIMIT_CTRL:
+		req.bf_backoff_enable = !!data;
+		break;
+	case UNI_TXPOWER_ATE_MODE_CTRL:
+		req.ate_mode_enable = !!data;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(TXPOWER),
+				 &req, sizeof(req), false);
+}
+
 int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy)
 {
 #define TX_POWER_LIMIT_TABLE_RATE	0
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 74b70fb6da3d..87573688171b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -1036,8 +1036,31 @@ enum {
 	UNI_CMD_THERMAL_PROTECT_DUTY_CONFIG,
 };
 
+struct tx_power_ctrl {
+	u8 _rsv[4];
+
+	__le16 tag;
+	__le16 len;
+
+	u8 power_ctrl_id;
+	union {
+		bool sku_enable;
+		bool ate_mode_enable;
+		bool percentage_ctrl_enable;
+		bool bf_backoff_enable;
+		u8 power_drop_level;
+	};
+	u8 band_idx;
+	u8 rsv[1];
+} __packed;
+
 enum {
+	UNI_TXPOWER_SKU_POWER_LIMIT_CTRL = 0,
+	UNI_TXPOWER_PERCENTAGE_CTRL = 1,
+	UNI_TXPOWER_PERCENTAGE_DROP_CTRL = 2,
+	UNI_TXPOWER_BACKOFF_POWER_LIMIT_CTRL = 3,
 	UNI_TXPOWER_POWER_LIMIT_TABLE_CTRL = 4,
+	UNI_TXPOWER_ATE_MODE_CTRL = 6,
 };
 
 enum {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 2a0cdb56f822..dcfdcd5975c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -778,6 +778,7 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy);
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state);
 int mt7996_mcu_set_thermal_protect(struct mt7996_phy *phy, bool enable);
 int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy);
+int mt7996_mcu_set_tx_power_ctrl(struct mt7996_phy *phy, u8 power_ctrl_id, u8 data);
 int mt7996_mcu_rdd_resume_tx(struct mt7996_phy *phy);
 int mt7996_mcu_rdd_cmd(struct mt7996_dev *dev, int cmd, u8 rdd_idx, u8 val);
 int mt7996_mcu_rdd_background_enable(struct mt7996_phy *phy,
-- 
2.47.3

