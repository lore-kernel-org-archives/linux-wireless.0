Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671F3C456B
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189130; cv=none; b=Ss/5tS9d23LrewkL3ZmZS3MMiGlPCMxRIqd9V9GfLF5IZ1EbJarCmNl8ulxAvcHsTXysXVU6KgyyAroMexT4uWVnkAFb90fUyJR7FRYTj1+jjmQnme9qQpmg9h7zzcJ2NZNNO7GQpy0x+211i8+df50o3U1sCGtHyy/ZVcFsesI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189130; c=relaxed/simple;
	bh=j8XQS8MZ6OG4tTmGgw22eJ+apDivwIKfVllzvoeX8ls=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kp6z+LTUmQSwNUshn4r9RRN5r0+CWqlfGM4BD4gLE4qgH4n7YSalHDBxxKXgutEk/1PyogSPbiEM78bkfA1QOtXizAX+4ge076sbl0IW5E24UA/UDIZ4mWSWeiw9PAmfVyqwi1Ot6gHHEHwPe6/9rjks2lTvWYil6gV8U3KsXqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kRrw2kF2; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kRrw2kF2"
X-UUID: 3a3ed502c09711f18dc8c9802ae25ab1-20261005
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=xrOQAlKnMayRWkQYD/KAXQS8F0ACfImZ+yIyGXUZnNc=;
	b=kRrw2kF2Rq67rxvV0VwtXaaAxrQ4e53wY+3Y/yapcogOocBuMfwdV1yOMSg0xaM8ilyQccScWmg0JVPQrskI5L30EbYMouAIaYqDNNltVdKLsFkMLcD1Im3C8gQShk+8E1rFLoNkO43DYzVH6KKnx19LixeSsoEuFS6bbm0Km9o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:68b469b7-314b-47ec-a705-4d31ee8c56d5,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:291e20b,CLOUDID:928a5c56-66df-4ed9-ba9a-e32623d07625,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3a3ed502c09711f18dc8c9802ae25ab1-20261005
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1151705153; Mon, 05 Oct 2026 16:31:57 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Oct 2026 16:31:56 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 5 Oct 2026 16:31:56 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v4 5/5] [PATCH v4] [PATCH 05/05] wifi: mt76: mt7922/mt7928: send Tx/Rx statistics to FW for link tuning
Date: Mon, 5 Oct 2026 16:31:55 +0800
Message-ID: <20261005083155.104718-1-anthony.liu@mediatek.com>
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

Update Tx/Rx statistics to FW for link speed tuning in FW.

Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  |  15 ++
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  53 ++++++
 .../wireless/mediatek/mt76/mt7921/debugfs.c   |  36 ++++
 .../net/wireless/mediatek/mt76/mt7921/mac.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7921/main.c  |   2 +
 .../net/wireless/mediatek/mt76/mt7921/pci.c   |   8 +
 .../wireless/mediatek/mt76/mt7921/pci_mac.c   |   2 +
 .../wireless/mediatek/mt76/mt7925/debugfs.c   |  45 +++++
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  |   4 +
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |  14 ++
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  52 ++++++
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 170 ++++++++++++++++++
 14 files changed, 411 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 015bbd92d458..eb4d02ec3ebe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -272,6 +272,21 @@ int mt76_connac_mcu_set_rts_thresh(struct mt76_dev *dev, u32 val, u8 band)
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_rts_thresh);
 
+int mt76_connac_mcu_uni_set_perf_ind(struct mt76_dev *dev, u32 valid_period,
+				     const u64 *tx_bytes, const u64 *rx_bytes)
+{
+	struct mt76_connac_uni_perf_ind req = {
+		.tag = cpu_to_le16(UNI_PERF_IND_PARM),
+		.len = cpu_to_le16(sizeof(req) - sizeof(req.rsv)),
+	};
+
+	mt76_connac_perf_ind_v1_fill(&req.perf, valid_period, tx_bytes, rx_bytes);
+
+	return mt76_mcu_send_msg(dev, MCU_UNI_CMD(PERF_IND), &req,
+				 sizeof(req), false);
+}
+EXPORT_SYMBOL_GPL(mt76_connac_mcu_uni_set_perf_ind);
+
 void mt76_connac_mcu_beacon_loss_iter(void *priv, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index d237d56eb1c1..aab101d10186 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1349,6 +1349,7 @@ enum {
 	MCU_UNI_CMD_VOW = 0x37,
 	MCU_UNI_CMD_FIXED_RATE_TABLE = 0x40,
 	MCU_UNI_CMD_RSSI_MONITOR = 0x41,
+	MCU_UNI_CMD_PERF_IND = 0x44,
 	MCU_UNI_CMD_TESTMODE_CTRL = 0x46,
 	MCU_UNI_CMD_NAN	= 0x56,
 	MCU_UNI_CMD_RRO = 0x57,
@@ -1396,6 +1397,7 @@ enum {
 	MCU_CE_CMD_SET_RATE_TX_POWER = 0x5d,
 	MCU_CE_CMD_SCHED_SCAN_ENABLE = 0x61,
 	MCU_CE_CMD_SCHED_SCAN_REQ = 0x62,
+	MCU_CE_CMD_PERF_IND = 0x7e,
 	MCU_CE_CMD_GET_NIC_CAPAB = 0x8a,
 	MCU_CE_CMD_RSSI_MONITOR = 0xa1,
 	MCU_CE_CMD_SET_MU_EDCA_PARMS = 0xb0,
@@ -1463,6 +1465,10 @@ enum {
 	UNI_CHIP_CONFIG_CHIP_CFG = 2,
 };
 
+enum {
+	UNI_PERF_IND_PARM = 0,
+};
+
 enum {
 	MT_NIC_CAP_TX_RESOURCE,
 	MT_NIC_CAP_TX_EFUSE_ADDR,
@@ -1875,6 +1881,51 @@ struct mt76_connac_config {
 	u8 data[320];
 } __packed;
 
+struct mt76_connac_perf_ind {
+	/* DW0 - common info*/
+	u8 cmd_ver;
+	u8 mask; /* per-field valid bitmap */
+	__le16 cmd_len;
+
+	/* DW1 - valid period of the stats */
+	__le32 valid_period;
+
+	/* DW2~15 - stats */
+	__le32 cur_tx_bytes[4];
+	__le32 cur_rx_bytes[4];
+	__le16 cur_rx_rate[4];
+	u8 cur_rx_rcpi0[4];
+	u8 cur_rx_rcpi1[4];
+	u8 cur_rx_nss[4];
+	u8 cur_rx_nss2[4];
+
+	/* DW16-77 padding */
+	__le32 pad[62];
+} __packed;
+
+struct mt76_connac_uni_perf_ind {
+	u8 rsv[4];
+	__le16 tag;
+	__le16 len;
+	struct mt76_connac_perf_ind perf;
+} __packed;
+
+static inline void
+mt76_connac_perf_ind_v1_fill(struct mt76_connac_perf_ind *perf, u32 valid_period,
+			     const u64 *tx_bytes, const u64 *rx_bytes)
+{
+	int i;
+
+	perf->mask = BIT(0) | BIT(1);
+	perf->cmd_len = cpu_to_le16(sizeof(*perf));
+	perf->valid_period = cpu_to_le32(valid_period);
+
+	for (i = 0; i < ARRAY_SIZE(perf->cur_tx_bytes); i++) {
+		perf->cur_tx_bytes[i] = cpu_to_le32(tx_bytes[i]);
+		perf->cur_rx_bytes[i] = cpu_to_le32(rx_bytes[i]);
+	}
+}
+
 struct mt76_connac_mcu_uni_event {
 	u8 cid;
 	u8 pad[3];
@@ -2059,6 +2110,8 @@ int mt76_connac_mcu_sta_cmd(struct mt76_phy *phy,
 void mt76_connac_mcu_beacon_loss_iter(void *priv, u8 *mac,
 				      struct ieee80211_vif *vif);
 int mt76_connac_mcu_set_rts_thresh(struct mt76_dev *dev, u32 val, u8 band);
+int mt76_connac_mcu_uni_set_perf_ind(struct mt76_dev *dev, u32 valid_period,
+				     const u64 *tx_bytes, const u64 *rx_bytes);
 int mt76_connac_mcu_set_mac_enable(struct mt76_dev *dev, int band, bool enable,
 				   bool hdr_trans);
 int mt76_connac_mcu_init_download(struct mt76_dev *dev, u32 addr, u32 len,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 62bf33347e9e..86055a275ae0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -247,6 +247,37 @@ static int mt7921_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7921_chip_reset, "%lld\n");
 
+/* send one perf_ind carrying the written value in every tx/rx byte field */
+static int mt7921_perf_ind_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	return mt792x_perf_ind_trigger(dev, val);
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_perf_ind, NULL, mt7921_perf_ind_set, "%lld\n");
+
+static int mt7921_perf_ind_enable_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->perf.enabled;
+
+	return 0;
+}
+
+static int mt7921_perf_ind_enable_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	dev->perf.enabled = !!val;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_perf_ind_enable, mt7921_perf_ind_enable_get,
+			 mt7921_perf_ind_enable_set, "%lld\n");
+
 static int
 mt7921s_sched_quota_read(struct seq_file *s, void *data)
 {
@@ -287,6 +318,11 @@ int mt7921_init_debugfs(struct mt792x_dev *dev)
 	debugfs_create_devm_seqfile(dev->mt76.dev, "runtime_pm_stats", dir,
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
+	if (mt76_is_mmio(&dev->mt76)) {
+		debugfs_create_file("enable_perf_ind", 0600, dir, dev,
+				    &fops_perf_ind_enable);
+		debugfs_create_file("perf_ind", 0200, dir, dev, &fops_perf_ind);
+	}
 	if (mt76_is_sdio(&dev->mt76))
 		debugfs_create_devm_seqfile(dev->mt76.dev, "sched-quota", dir,
 					    mt7921s_sched_quota_read);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index e69978184f68..3f7e7b41fb3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -619,6 +619,10 @@ void mt7921_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	case PKT_TYPE_NORMAL_MCU:
 	case PKT_TYPE_NORMAL:
 		if (!mt7921_mac_fill_rx(dev, skb)) {
+			struct mt76_rx_status *status =
+				(struct mt76_rx_status *)skb->cb;
+
+			mt792x_perf_account_rx(dev, status->wcid, skb->len);
 			mt76_rx(&dev->mt76, q, skb);
 			return;
 		}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 68a059504e83..067aa42c4f4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -730,6 +730,8 @@ static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 		mt7921_mcu_sta_update(dev, NULL, vif, true,
 				      MT76_STA_INFO_STATE_ASSOC);
 		mt7921_mcu_set_beacon_filter(dev, vif, vif->cfg.assoc);
+
+		mt792x_perf_ind_update(dev, vif, MT792x_PERF_IND_TIME);
 	}
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 56a914aaa81e..938b3c3234b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -51,6 +51,7 @@ static void mt7921e_unregister_device(struct mt792x_dev *dev)
 		wiphy_rfkill_stop_polling(hw->wiphy);
 
 	cancel_work_sync(&dev->init_work);
+	cancel_delayed_work_sync(&dev->perf.work);
 	mt76_unregister_device(&dev->mt76);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
@@ -435,6 +436,9 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_free_irq;
 
+	/* the periodic performance indication is started on association */
+	mt792x_perf_ind_init(dev);
+
 	if (of_property_read_bool(dev->mt76.dev->of_node, "wakeup-source"))
 		device_init_wakeup(dev->mt76.dev, true);
 
@@ -475,6 +479,7 @@ static int mt7921_pci_suspend(struct device *device)
 
 	pm->suspended = true;
 	flush_work(&dev->reset_work);
+	cancel_delayed_work_sync(&dev->perf.work);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
@@ -598,6 +603,9 @@ static int mt7921_pci_resume(struct device *device)
 
 	mt7921_mcu_regd_update(dev, mdev->alpha2, dev->country_ie_env);
 	err = mt7921_mcu_radio_led_ctrl(dev, EXT_CMD_RADIO_ON_LED);
+
+	/* re-arm the periodic performance indication if any bss is connected */
+	mt792x_perf_ind_resched(dev);
 failed:
 	pm->suspended = false;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 2449ac8ed6a4..0853d56356b0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -21,6 +21,8 @@ int mt7921e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (unlikely(tx_info->skb->len <= ETH_HLEN))
 		return -EINVAL;
 
+	mt792x_perf_account_tx(dev, info->control.vif, tx_info->skb->len);
+
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index 69c545986d61..3bb53d8e58b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -286,6 +286,37 @@ static int mt7925_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7925_chip_reset, "%lld\n");
 
+/* send one perf_ind carrying the written value in every tx/rx byte field */
+static int mt7925_perf_ind_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	return mt792x_perf_ind_trigger(dev, val);
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_perf_ind, NULL, mt7925_perf_ind_set, "%lld\n");
+
+static int mt7925_perf_ind_enable_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->perf.enabled;
+
+	return 0;
+}
+
+static int mt7925_perf_ind_enable_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	dev->perf.enabled = !!val;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_perf_ind_enable, mt7925_perf_ind_enable_get,
+			 mt7925_perf_ind_enable_set, "%lld\n");
+
 int mt7925_init_debugfs(struct mt792x_dev *dev)
 {
 	struct dentry *dir;
@@ -313,5 +344,19 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
 
+	/* PERF_IND is supported on MT7928 only within this family */
+	if (is_mt7928(&dev->mt76)) {
+		debugfs_create_file("enable_perf_ind", 0600, dir, dev,
+				    &fops_perf_ind_enable);
+		debugfs_create_file("perf_ind", 0200, dir, dev, &fops_perf_ind);
+	}
+
+	/* PERF_IND is supported on MT7928 only within this family */
+	if (is_mt7928(&dev->mt76)) {
+		debugfs_create_file("enable_perf_ind", 0600, dir, dev,
+				    &fops_perf_ind_enable);
+		debugfs_create_file("perf_ind", 0200, dir, dev, &fops_perf_ind);
+	}
+
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 101f571b027f..6e0d2c4c39a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1458,6 +1458,10 @@ void mt7925_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	case PKT_TYPE_NORMAL_MCU:
 	case PKT_TYPE_NORMAL:
 		if (!mt7925_mac_fill_rx(dev, skb)) {
+			struct mt76_rx_status *status =
+				(struct mt76_rx_status *)skb->cb;
+
+			mt792x_perf_account_rx(dev, status->wcid, skb->len);
 			mt76_rx(&dev->mt76, q, skb);
 			return;
 		}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 84b55f008b3d..1f1f3c1524b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2113,6 +2113,10 @@ static void mt7925_vif_cfg_changed(struct ieee80211_hw *hw,
 
 		if (ieee80211_vif_is_mld(vif))
 			mvif->mlo_pm_state = MT792x_MLO_LINK_ASSOC;
+
+		/* PERF_IND is supported on MT7928 only within this family */
+		if (is_mt7928(&dev->mt76))
+			mt792x_perf_ind_update(dev, vif, MT792x_PERF_IND_TIME);
 	}
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 02ef09dd797d..036d9f312a16 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -49,6 +49,8 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 
 	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
+	if (is_mt7928(&dev->mt76))
+		cancel_delayed_work_sync(&dev->perf.work);
 	mt76_unregister_device(&dev->mt76);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
@@ -706,6 +708,12 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_free_dma;
 
+	/* PERF_IND is only supported on MT7928 in this family; MT7925 opts out.
+	 * The periodic indication itself is started on association.
+	 */
+	if (is_mt7928(&dev->mt76))
+		mt792x_perf_ind_init(dev);
+
 	return 0;
 
 err_free_dma:
@@ -743,6 +751,8 @@ static int mt7925_pci_suspend(struct device *device)
 	pm->suspended = true;
 	dev->hif_resumed = false;
 	flush_work(&dev->reset_work);
+	if (is_mt7928(&dev->mt76))
+		cancel_delayed_work_sync(&dev->perf.work);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	cancel_work_sync(&pm->wake_work);
@@ -878,6 +888,10 @@ static int _mt7925_pci_resume(struct device *device, bool restore)
 		mt7925_mcu_set_deep_sleep(dev, false);
 
 	mt7925_mcu_regd_update(dev, mdev->alpha2, dev->country_ie_env);
+
+	/* re-arm the periodic performance indication if any bss is connected */
+	if (is_mt7928(&dev->mt76))
+		mt792x_perf_ind_resched(dev);
 failed:
 	pm->suspended = false;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 9e4e78910560..4244eb239ccf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -22,6 +22,8 @@ int mt7925e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (unlikely(tx_info->skb->len <= ETH_HLEN))
 		return -EINVAL;
 
+	mt792x_perf_account_tx(dev, info->control.vif, tx_info->skb->len);
+
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index c1fa3dbba5ca..6d4ee556652a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -39,6 +39,9 @@
 
 #define MT792x_WATCHDOG_TIME	(HZ / 4)
 
+#define MT792x_PERF_UPDATE_PERIOD	1000	/* ms */
+#define MT792x_PERF_IND_TIME		(HZ)	/* 1 second */
+
 #define MT792x_DRV_OWN_RETRY_COUNT	10
 #define MT792x_MCU_INIT_RETRY_COUNT	10
 #define MT792x_WFSYS_INIT_RETRY_COUNT	2
@@ -162,6 +165,11 @@ struct mt792x_bss_conf {
 	struct ewma_rssi rssi;
 	struct ieee80211_tx_queue_params queue_params[IEEE80211_NUM_ACS];
 	unsigned int link_id;
+
+	atomic64_t perf_tx_bytes;
+	atomic64_t perf_rx_bytes;
+	u64 perf_last_tx_bytes;
+	u64 perf_last_rx_bytes;
 };
 
 struct mt792x_nan_conf {
@@ -342,8 +350,45 @@ struct mt792x_dev {
 	struct ieee80211_vif *nan_vif;
 	const struct ieee80211_iface_combination *iface_combinations;
 	int n_iface_combinations;
+
+	struct {
+		struct delayed_work work;
+		bool enabled;
+	} perf;
 };
 
+/* accumulate TX bytes for the interface transmitting @len bytes */
+static inline void
+mt792x_perf_account_tx(struct mt792x_dev *dev, struct ieee80211_vif *vif,
+		       u32 len)
+{
+	struct mt792x_vif *mvif;
+
+	if (!vif)
+		return;
+
+	mvif = (struct mt792x_vif *)vif->drv_priv;
+
+	atomic64_add(len, &mvif->bss_conf.perf_tx_bytes);
+}
+
+/* accumulate RX bytes for the interface owning @wcid */
+static inline void
+mt792x_perf_account_rx(struct mt792x_dev *dev, struct mt76_wcid *wcid, u32 len)
+{
+	struct mt792x_link_sta *link;
+
+	if (!wcid)
+		return;
+
+	link = container_of(wcid, struct mt792x_link_sta, wcid);
+
+	if (!link->sta || !link->sta->vif)
+		return;
+
+	atomic64_add(len, &link->sta->vif->bss_conf.perf_rx_bytes);
+}
+
 static inline struct mt792x_bss_conf *
 mt792x_vif_to_link(struct mt792x_vif *mvif, u8 link_id)
 {
@@ -533,6 +578,13 @@ void mt792x_mac_link_bss_remove(struct mt792x_dev *dev,
 void mt792x_config_mac_addr_list(struct mt792x_dev *dev);
 int mt792x_mcu_chip_config(struct mt792x_dev *dev, const char *cmd);
 int mt792x_mcu_set_dyn_pcie_gen(struct mt792x_dev *dev);
+int mt792x_mcu_set_perf_ind(struct mt792x_dev *dev, u32 valid_period,
+			    const u64 *tx_bytes, const u64 *rx_bytes);
+void mt792x_perf_ind_update(struct mt792x_dev *dev, struct ieee80211_vif *vif,
+			    unsigned long delay);
+void mt792x_perf_ind_init(struct mt792x_dev *dev);
+void mt792x_perf_ind_resched(struct mt792x_dev *dev);
+int mt792x_perf_ind_trigger(struct mt792x_dev *dev, u64 val);
 
 static inline char *mt792x_ram_name(struct mt792x_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index e77224e2ca50..e7a5d2f9b742 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -329,6 +329,176 @@ int mt792x_get_stats(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt792x_get_stats);
 
+int mt792x_mcu_set_perf_ind(struct mt792x_dev *dev, u32 valid_period,
+			    const u64 *tx_bytes, const u64 *rx_bytes)
+{
+	struct mt76_connac_perf_ind req = {};
+
+	mt76_connac_perf_ind_v1_fill(&req, valid_period, tx_bytes, rx_bytes);
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(PERF_IND),
+				 &req, sizeof(req), false);
+}
+EXPORT_SYMBOL_GPL(mt792x_mcu_set_perf_ind);
+
+static int mt792x_mcu_perf_ind(struct mt792x_dev *dev, u32 valid_period,
+			       const u64 *tx_bytes, const u64 *rx_bytes)
+{
+	if (is_connac3(&dev->mt76))
+		return mt76_connac_mcu_uni_set_perf_ind(&dev->mt76, valid_period,
+							tx_bytes, rx_bytes);
+
+	return mt792x_mcu_set_perf_ind(dev, valid_period, tx_bytes, rx_bytes);
+}
+
+static bool mt792x_perf_vif_active(struct ieee80211_vif *vif)
+{
+	return vif->cfg.assoc;
+}
+
+struct mt792x_perf_iter_data {
+	u64 tx_delta[MT792x_MAX_INTERFACES];
+	u64 rx_delta[MT792x_MAX_INTERFACES];
+	bool connected;
+};
+
+static void mt792x_perf_collect_iter(void *priv, u8 *mac,
+				     struct ieee80211_vif *vif)
+{
+	struct mt792x_perf_iter_data *data = priv;
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_bss_conf *mconf = &mvif->bss_conf;
+	u8 idx = mconf->mt76.idx;
+	u64 tx, rx, last_tx, last_rx;
+
+	if (!mt792x_perf_vif_active(vif) || idx >= MT792x_MAX_INTERFACES)
+		return;
+
+	data->connected = true;
+
+	tx = atomic64_read(&mconf->perf_tx_bytes);
+	if (!tx) {
+		data->tx_delta[idx] = 0;
+	} else {
+		last_tx = mconf->perf_last_tx_bytes;
+		data->tx_delta[idx] = tx <= last_tx ? 0 : tx - last_tx;
+		mconf->perf_last_tx_bytes = tx;
+	}
+
+	rx = atomic64_read(&mconf->perf_rx_bytes);
+	if (!rx) {
+		data->rx_delta[idx] = 0;
+	} else {
+		last_rx = mconf->perf_last_rx_bytes;
+		data->rx_delta[idx] = rx <= last_rx ? 0 : rx - last_rx;
+		mconf->perf_last_rx_bytes = rx;
+	}
+}
+
+static void mt792x_perf_active_iter(void *priv, u8 *mac,
+				    struct ieee80211_vif *vif)
+{
+	bool *active = priv;
+
+	if (mt792x_perf_vif_active(vif))
+		*active = true;
+}
+
+static bool mt792x_perf_any_connected(struct mt792x_dev *dev)
+{
+	bool active = false;
+
+	ieee80211_iterate_active_interfaces(dev->mphy.hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    mt792x_perf_active_iter,
+					    &active);
+	return active;
+}
+
+void mt792x_perf_ind_update(struct mt792x_dev *dev, struct ieee80211_vif *vif,
+			    unsigned long delay)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+
+	/* Reset snapshots so a future re-association starts clean */
+	if (!mt792x_perf_vif_active(vif)) {
+		atomic64_set(&mvif->bss_conf.perf_tx_bytes, 0);
+		atomic64_set(&mvif->bss_conf.perf_rx_bytes, 0);
+		mvif->bss_conf.perf_last_tx_bytes = 0;
+		mvif->bss_conf.perf_last_rx_bytes = 0;
+	}
+
+	if (!mt76_is_mmio(&dev->mt76))
+		return;
+
+	if (mt792x_perf_any_connected(dev))
+		queue_delayed_work(dev->mt76.wq, &dev->perf.work, delay);
+	else
+		cancel_delayed_work(&dev->perf.work);
+}
+EXPORT_SYMBOL_GPL(mt792x_perf_ind_update);
+
+static void mt792x_perf_work(struct work_struct *work)
+{
+	struct mt792x_dev *dev = container_of(work, struct mt792x_dev,
+					      perf.work.work);
+	struct mt792x_perf_iter_data data = {};
+
+	/* not enabled */
+	if (!dev->perf.enabled)
+		return;
+
+	/* skip while asleep */
+	if (!mt76_connac_pm_ref(&dev->mphy, &dev->pm))
+		goto reschedule;
+
+	ieee80211_iterate_active_interfaces(dev->mphy.hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    mt792x_perf_collect_iter, &data);
+
+	if (data.connected)
+		mt792x_mcu_perf_ind(dev, MT792x_PERF_UPDATE_PERIOD,
+				    data.tx_delta, data.rx_delta);
+
+	mt76_connac_pm_unref(&dev->mphy, &dev->pm);
+
+reschedule:
+	if (mt792x_perf_any_connected(dev))
+		queue_delayed_work(dev->mt76.wq, &dev->perf.work,
+				   MT792x_PERF_IND_TIME);
+}
+
+void mt792x_perf_ind_init(struct mt792x_dev *dev)
+{
+	INIT_DELAYED_WORK(&dev->perf.work, mt792x_perf_work);
+}
+EXPORT_SYMBOL_GPL(mt792x_perf_ind_init);
+
+void mt792x_perf_ind_resched(struct mt792x_dev *dev)
+{
+	if (mt792x_perf_any_connected(dev))
+		queue_delayed_work(dev->mt76.wq, &dev->perf.work,
+				   MT792x_PERF_IND_TIME);
+}
+EXPORT_SYMBOL_GPL(mt792x_perf_ind_resched);
+
+int mt792x_perf_ind_trigger(struct mt792x_dev *dev, u64 val)
+{
+	u64 bytes[MT792x_MAX_INTERFACES];
+	int i;
+
+	for (i = 0; i < MT792x_MAX_INTERFACES; i++)
+		bytes[i] = val;
+
+	/* wake the chip and serialize against other MCU commands */
+	mt792x_mutex_acquire(dev);
+	mt792x_mcu_perf_ind(dev, MT792x_PERF_UPDATE_PERIOD, bytes, bytes);
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt792x_perf_ind_trigger);
+
 u64 mt792x_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-- 
2.45.2

