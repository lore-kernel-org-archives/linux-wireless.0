Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C3A3CBE7C
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189127; cv=none; b=nzB31gzW8FT0BSrKblxdu9wJOKKcTJwiBGXTVIQ9RCDnNnaTVw2NR8qCtzr2ji0pKI7aWwoiP2vQrSLZLWbnwPUIheaCHAxxDj66Ed+PiRpatbJtHusW7w5PYs7Vlx3rV7KEZE0UG3EfOaBK5DMyVf/9rfDAo2MYlXq7KRsTglg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189127; c=relaxed/simple;
	bh=tWBfhyHlQOmk0gdVqAjmpZR7weP9VQuFgLkO3IAh1mc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZFReDcUjiq/HZ/aFRsdTjSgcwrhYtTbKIu8hOj2TiHzmo6hYJLG4FxzDZ+lHycuSHe3ZLILQvDVRBmoApBIIUxmFm2PHsoRZgUcuhtxKUoDgGlowci1jcUe3dGuoiVlydAh/jROrSzbmDozfCluoqbRGWLLzZu/arR5Ubb4Nb7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EK5ao+uZ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EK5ao+uZ"
X-UUID: 356d6c64c09711f18dc8c9802ae25ab1-20261005
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=z5APDyOYx3Zp8DZzyv674R0MCNlcxigSv/6z6hXyC4I=;
	b=EK5ao+uZkn8jFRgsOiWVH2TSIXIJDLJh//+W8rMtkmYxpJAM5KzZge93T+F3aau9JHtU1hkqrWF922qpiNIhDnj5Xl0N5gvdG/top1M6mucQidkUACx+UleYZnXwwqMTBIDTVNdoTsMq9Fiyd1OeqjIsxBTukUJU5N+6dqZGCXs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:2c2982a4-7277-4c7e-8c59-88f298be979f,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:291e20b,CLOUDID:0290a094-f92e-44c1-a195-feed1a426245,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 356d6c64c09711f18dc8c9802ae25ab1-20261005
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 395879947; Mon, 05 Oct 2026 16:31:49 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Oct 2026 16:31:48 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 5 Oct 2026 16:31:48 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v4 2/5] [PATCH v4] [PATCH 02/05] wifi: mt76: refactor chip_cfg commands to be a generic API
Date: Mon, 5 Oct 2026 16:31:47 +0800
Message-ID: <20261005083147.104662-1-anthony.liu@mediatek.com>
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

New chip_cfg command isn't chip specific but only available to mt7925.

1. Move chip specific mt7925_mcu_chip_config() from mt76/mt7925/mcu.c to
   mt76_connac_mcu_uni_chip_config() in mt76/mt76_connac_mcu.c.
2. mt792x_mcu_chip_config() uses mt76_connac_mcu_uni_chip_config() if is
   dealing with CONNAC3 FW, and uses mt76_connac_mcu_chip_config()
   otherwise.

Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 35 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  5 +++
 .../wireless/mediatek/mt76/mt7925/debugfs.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  6 ++--
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  1 -
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 13 +++++++
 7 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index de83d41ca9c9..015bbd92d458 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2057,6 +2057,41 @@ int mt76_connac_mcu_chip_config(struct mt76_dev *dev, const char *cmd)
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_chip_config);
 
+/* Unified-command form of chip_config (connac3, e.g. MT7925/MT7928): the same
+ * CE payload carried as a TLV inside MCU_UNI_CMD_CHIP_CONFIG.
+ */
+int mt76_connac_mcu_uni_chip_config(struct mt76_dev *dev, const char *cmd)
+{
+	ssize_t len;
+
+	struct {
+		u8 rsv[4];
+		__le16 tag;
+		__le16 len;
+		struct mt76_connac_config config;
+	} __packed req = {
+		.tag = cpu_to_le16(UNI_CHIP_CONFIG_CHIP_CFG),
+		.len = cpu_to_le16(sizeof(req) - sizeof(req.rsv)),
+		.config = {
+			.resp_type = 0,
+			.type = 0,
+		},
+	};
+
+	if (!cmd)
+		return -EINVAL;
+
+	len = strscpy(req.config.data, cmd);
+	if (len == -E2BIG)
+		return -E2BIG;
+
+	req.config.data_size = cpu_to_le16(len + 1);
+
+	return mt76_mcu_send_msg(dev, MCU_UNI_CMD(CHIP_CONFIG),
+				 &req, sizeof(req), false);
+}
+EXPORT_SYMBOL_GPL(mt76_connac_mcu_uni_chip_config);
+
 int mt76_connac_mcu_set_deep_sleep(struct mt76_dev *dev, bool enable)
 {
 	struct mt76_connac_config req = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 45f77c80e879..d237d56eb1c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1459,6 +1459,10 @@ enum UNI_ALL_STA_INFO_TAG {
 	UNI_ALL_STA_MAX_NUM
 };
 
+enum {
+	UNI_CHIP_CONFIG_CHIP_CFG = 2,
+};
+
 enum {
 	MT_NIC_CAP_TX_RESOURCE,
 	MT_NIC_CAP_TX_EFUSE_ADDR,
@@ -2099,6 +2103,7 @@ int mt76_connac_sta_state_dp(struct mt76_dev *dev,
 			     enum ieee80211_sta_state old_state,
 			     enum ieee80211_sta_state new_state);
 int mt76_connac_mcu_chip_config(struct mt76_dev *dev, const char *cmd);
+int mt76_connac_mcu_uni_chip_config(struct mt76_dev *dev, const char *cmd);
 int mt76_connac_mcu_set_deep_sleep(struct mt76_dev *dev, bool enable);
 void mt76_connac_mcu_coredump_event(struct mt76_dev *dev, struct sk_buff *skb,
 				    struct mt76_connac_coredump *coredump);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index d01ff49de47a..69c545986d61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -276,7 +276,7 @@ static int mt7925_chip_reset(void *data, u64 val)
 	default:
 		/* Collect the core dump before reset wifisys. */
 		mt792x_mutex_acquire(dev);
-		ret = mt7925_mcu_chip_config(dev, "assert");
+		ret = mt792x_mcu_chip_config(dev, "assert");
 		mt792x_mutex_release(dev);
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a455..376cc4833242 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1166,7 +1166,7 @@ int mt7925_mcu_set_deep_sleep(struct mt792x_dev *dev, bool enable)
 
 	snprintf(cmd, sizeof(cmd), "KeepFullPwr %d", !enable);
 
-	return mt7925_mcu_chip_config(dev, cmd);
+	return mt792x_mcu_chip_config(dev, cmd);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_set_deep_sleep);
 
@@ -1177,11 +1177,11 @@ int mt7925_mcu_set_thermal_protect(struct mt792x_dev *dev)
 
 	snprintf(cmd, sizeof(cmd), "ThermalProtGband %d %d %d %d %d %d %d %d %d %d",
 		 0, 100, 90, 80, 30, 1, 1, 115, 105, 5);
-	ret = mt7925_mcu_chip_config(dev, cmd);
+	ret = mt792x_mcu_chip_config(dev, cmd);
 
 	snprintf(cmd, sizeof(cmd), "ThermalProtAband %d %d %d %d %d %d %d %d %d %d",
 		 1, 100, 90, 80, 30, 1, 1, 115, 105, 5);
-	ret |= mt7925_mcu_chip_config(dev, cmd);
+	ret |= mt792x_mcu_chip_config(dev, cmd);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 11f9eac13ffc..c397b435a230 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -115,7 +115,6 @@ enum {
 };
 
 enum {
-	UNI_CHIP_CONFIG_CHIP_CFG = 0x2,
 	UNI_CHIP_CONFIG_NIC_CAPA = 0x3,
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9efc251cb745..e7f3d36d5338 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -531,6 +531,7 @@ void mt792x_mac_link_bss_remove(struct mt792x_dev *dev,
 				struct mt792x_bss_conf *mconf,
 				struct mt792x_link_sta *mlink);
 void mt792x_config_mac_addr_list(struct mt792x_dev *dev);
+int mt792x_mcu_chip_config(struct mt792x_dev *dev, const char *cmd);
 
 static inline char *mt792x_ram_name(struct mt792x_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 0ad33f74c228..d676517df902 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -1167,6 +1167,19 @@ void mt792x_config_mac_addr_list(struct mt792x_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt792x_config_mac_addr_list);
 
+/* Pick the chip_config command form the running chip's firmware understands:
+ * connac3 (mt7925/mt7928) needs the unified command, connac2 (mt7921/mt7922)
+ * uses the legacy CE command.
+ */
+int mt792x_mcu_chip_config(struct mt792x_dev *dev, const char *cmd)
+{
+	if (is_connac3(&dev->mt76))
+		return mt76_connac_mcu_uni_chip_config(&dev->mt76, cmd);
+
+	return mt76_connac_mcu_chip_config(&dev->mt76, cmd);
+}
+EXPORT_SYMBOL_GPL(mt792x_mcu_chip_config);
+
 MODULE_DESCRIPTION("MediaTek MT792x core driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Lorenzo Bianconi <lorenzo@kernel.org>");
-- 
2.45.2

