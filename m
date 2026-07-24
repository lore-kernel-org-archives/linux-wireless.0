Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA383B71C7
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883136; cv=none; b=ZjQ2AgVYfspFOVIsDStx8UjA2tS4h1+zcUZk8VMqcxEwHrToPIrH+o2f2G+MzF5hmDwCt72CrzloC3hdJezMCheth5gVYJZyO2vU/3zkl+Tf5/YEDs+8+EPwEYDdSbXvuVFrm/cL6AcBPtaDpj4SSeeuj94kDOWGmUyLCp64AYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883136; c=relaxed/simple;
	bh=uDPzu4IG9RnxnR4FiEfinyq2EFTdlu62RfXaop4PgLU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Eb1n5l5wPZeIh52eJBcEfYyAkCAUBhD8fhCJeABqHJhvkzAIHT9QlIyA6kdVMSAWDpZABu4GXSNE8QCplhCKVpcEXTFaFP+S8BhgSObqIiUTJsO3wM2D49oupXM71aF4NYr4j+HLTlZApcNJKaO3ofFidAkNtfszjmmAH1WG/Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qp3hhReI; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qp3hhReI"
X-UUID: f1f59bc0873c11f18dc8c9802ae25ab1-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QYhmYq2WAD30T7u1mafkJDiF3z7roUP0ClrwqEjC8ok=;
	b=qp3hhReIzP0xOIZJIGZ95Pdak2yALWj4zhrksaTzCpC7BHaTAeL324u/EG4ndJYPjDigQ8MDtPQiWT9GlgIqOQ92S3R7Oyg3GOZKKlbn+D2vSVTniperGdsSpVQTDpE4iziza0Ru1jDVVkpYJr9Ud2xvQWFa8tancoA+ymgrw7Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:f5ba5d52-6379-4137-a9ba-ed51a48b1521,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:fcf7dc5f-762a-4584-baab-4eebe609beea,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f1f59bc0873c11f18dc8c9802ae25ab1-20260724
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 74010583; Fri, 24 Jul 2026 16:52:05 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:52:04 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:52:03 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: add MT7928 debugfs txpower_sku with power table selection
Date: Fri, 24 Jul 2026 16:52:02 +0800
Message-ID: <20260724085202.3156422-1-jb.tsai@mediatek.com>
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

From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

Add MT7928-specific debugfs interface for txpower_sku that supports
multiple power table selection. MT7928 extends the power structure with
additional OFDM bandwidth variants (OFDM20/40/80/160) compared to MT7925.

Key changes:
- Add struct mt7928_txpwr with OFDM20/40/80/160 support
- Implement mt7928_txpwr() handler for MT7928-specific power display
- Add txpower_tbl debugfs control for selecting power tables:
  * 0: STA_SISO
  * 1: STA_CDD
  * 2: STA_MIMO
  * 3: P2P_SISO
  * 4: P2P_CDD
  * 5: P2P_MIMO
- Extend mt7925_txpwr_req with power_tbl field for FW communication
- Add mt7928_txpwr_event structure for handling FW responses
- Store txpwr_tbl in mt792x_dev for per-device power table tracking

Usage:
  echo 0 > /sys/kernel/debug/ieee80211/phy0/mt76/txpower_tbl
  cat /sys/kernel/debug/ieee80211/phy0/mt76/txpower_sku

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/debugfs.c   | 151 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  27 ++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  20 ++-
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  39 +++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   1 +
 5 files changed, 235 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index e2498659c884..3db564d63c15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -178,6 +178,147 @@ mt7925_txpwr(struct seq_file *s, void *data)
 	return ret;
 }
 
+static inline void
+mt7928_eht_txpwr(struct seq_file *s, struct mt7928_txpwr *txpwr, u8 band_idx)
+{
+	seq_printf(s, "%-22s  %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\n",
+		   " ", "mcs0", "mcs1", "mcs2", "mcs3", "mcs4", "mcs5",
+		   "mcs6", "mcs7", "mcs8", "mcs9", "mcs10", "mcs11",
+		   "mcs12", "mcs13", "mcs14", "mcs15");
+	mt7925_print_txpwr_entry(EHT26, eht26, band_idx);
+	mt7925_print_txpwr_entry(EHT52, eht52, band_idx);
+	mt7925_print_txpwr_entry(EHT106, eht106, band_idx);
+	mt7925_print_txpwr_entry(EHT242, eht242, band_idx);
+	mt7925_print_txpwr_entry(EHT484, eht484, band_idx);
+
+	mt7925_print_txpwr_entry(EHT996, eht996, band_idx);
+	mt7925_print_txpwr_entry(EHT996x2, eht996x2, band_idx);
+	mt7925_print_txpwr_entry(EHT996x4, eht996x4, band_idx);
+	mt7925_print_txpwr_entry(EHT26_52, eht26_52, band_idx);
+	mt7925_print_txpwr_entry(EHT26_106, eht26_106, band_idx);
+	mt7925_print_txpwr_entry(EHT484_242, eht484_242, band_idx);
+	mt7925_print_txpwr_entry(EHT996_484, eht996_484, band_idx);
+	mt7925_print_txpwr_entry(EHT996_484_242, eht996_484_242, band_idx);
+	mt7925_print_txpwr_entry(EHT996x2_484, eht996x2_484, band_idx);
+	mt7925_print_txpwr_entry(EHT996x3, eht996x3, band_idx);
+	mt7925_print_txpwr_entry(EHT996x3_484, eht996x3_484, band_idx);
+}
+
+static int
+mt7928_txpwr(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	struct mt7928_txpwr *txpwr = NULL;
+	u8 band_idx = dev->mphy.band_idx;
+	int ret = 0;
+
+	txpwr = devm_kmalloc(dev->mt76.dev, sizeof(*txpwr), GFP_KERNEL);
+
+	if (!txpwr)
+		return -ENOMEM;
+
+	mt792x_mutex_acquire(dev);
+	ret = mt7928_get_txpwr_info(dev, band_idx, dev->txpwr_tbl, txpwr);
+	mt792x_mutex_release(dev);
+
+	if (ret)
+		goto out;
+
+	/* Display power table name based on the index */
+	switch (dev->txpwr_tbl) {
+	case 0:
+		seq_printf(s, "Power Table: %d (STA_SISO)\n", dev->txpwr_tbl);
+		break;
+	case 1:
+		seq_printf(s, "Power Table: %d (STA_CDD)\n", dev->txpwr_tbl);
+		break;
+	case 2:
+		seq_printf(s, "Power Table: %d (STA_MIMO)\n", dev->txpwr_tbl);
+		break;
+	case 3:
+		seq_printf(s, "Power Table: %d (P2P_SISO)\n", dev->txpwr_tbl);
+		break;
+	case 4:
+		seq_printf(s, "Power Table: %d (P2P_CDD)\n", dev->txpwr_tbl);
+		break;
+	case 5:
+		seq_printf(s, "Power Table: %d (P2P_MIMO)\n", dev->txpwr_tbl);
+		break;
+	default:
+		seq_printf(s, "Power Table: %d (Unknown)\n", dev->txpwr_tbl);
+		break;
+	}
+
+	seq_printf(s, "%-22s  %6s %6s %6s %6s\n",
+		   " ", "1m", "2m", "5m", "11m");
+	mt7925_print_txpwr_entry(CCK, cck, band_idx);
+
+	seq_printf(s, "%-22s  %6s %6s %6s %6s %6s %6s %6s %6s\n",
+		   " ", "6m", "9m", "12m", "18m", "24m", "36m",
+		   "48m", "54m");
+	mt7925_print_txpwr_entry(OFDM20, ofdm20, band_idx);
+	mt7925_print_txpwr_entry(OFDM40, ofdm40, band_idx);
+	mt7925_print_txpwr_entry(OFDM80, ofdm80, band_idx);
+	mt7925_print_txpwr_entry(OFDM160, ofdm160, band_idx);
+
+	seq_printf(s, "%-22s  %6s %6s %6s %6s %6s %6s %6s %6s\n",
+		   " ", "mcs0", "mcs1", "mcs2", "mcs3", "mcs4", "mcs5",
+		   "mcs6", "mcs7");
+	mt7925_print_txpwr_entry(HT20, ht20, band_idx);
+
+	seq_printf(s, "%-22s  %6s %6s %6s %6s %6s %6s %6s %6s %6s\n",
+		   " ", "mcs0", "mcs1", "mcs2", "mcs3", "mcs4", "mcs5",
+		   "mcs6", "mcs7", "mcs32");
+	mt7925_print_txpwr_entry(HT40, ht40, band_idx);
+
+	seq_printf(s, "%-22s  %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s %6s\n",
+		   " ", "mcs0", "mcs1", "mcs2", "mcs3", "mcs4", "mcs5",
+		   "mcs6", "mcs7", "mcs8", "mcs9", "mcs10", "mcs11");
+	mt7925_print_txpwr_entry(VHT20, vht20, band_idx);
+	mt7925_print_txpwr_entry(VHT40, vht40, band_idx);
+
+	mt7925_print_txpwr_entry(VHT80, vht80, band_idx);
+	mt7925_print_txpwr_entry(VHT160, vht160, band_idx);
+
+	mt7925_print_txpwr_entry(HE26, he26, band_idx);
+	mt7925_print_txpwr_entry(HE52, he52, band_idx);
+	mt7925_print_txpwr_entry(HE106, he106, band_idx);
+	mt7925_print_txpwr_entry(HE242, he242, band_idx);
+	mt7925_print_txpwr_entry(HE484, he484, band_idx);
+
+	mt7925_print_txpwr_entry(HE996, he996, band_idx);
+	mt7925_print_txpwr_entry(HE996x2, he996x2, band_idx);
+
+	mt7928_eht_txpwr(s, txpwr, band_idx);
+
+out:
+	devm_kfree(dev->mt76.dev, txpwr);
+	return ret;
+}
+
+static int
+mt7928_txpwr_tbl_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	dev->txpwr_tbl = (u8)val;
+
+	return 0;
+}
+
+static int
+mt7928_txpwr_tbl_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->txpwr_tbl;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_txpwr_tbl, mt7928_txpwr_tbl_get,
+			 mt7928_txpwr_tbl_set, "%lld\n");
+
 static int
 mt7925_pm_set(void *data, u64 val)
 {
@@ -303,8 +444,14 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 
 	debugfs_create_devm_seqfile(dev->mt76.dev, "acq", dir,
 				    mt792x_queues_acq);
-	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower_sku", dir,
-				    mt7925_txpwr);
+	if (is_mt7928(&dev->mt76)) {
+		debugfs_create_devm_seqfile(dev->mt76.dev, "txpower_sku", dir,
+					    mt7928_txpwr);
+		debugfs_create_file("txpower_tbl", 0600, dir, dev, &fops_txpwr_tbl);
+	} else {
+		debugfs_create_devm_seqfile(dev->mt76.dev, "txpower_sku", dir,
+					    mt7925_txpwr);
+	}
 	debugfs_create_file("tx_stats", 0400, dir, dev, &mt792x_tx_stats_fops);
 	debugfs_create_file("fw_debug", 0600, dir, dev, &fops_fw_debug);
 	debugfs_create_file("runtime-pm", 0600, dir, dev, &fops_pm);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 37502d8a0e7d..7162eca8e23e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2211,6 +2211,33 @@ int mt7925_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx, struct mt7925_txp
 	return 0;
 }
 
+int mt7928_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx, u8 power_tbl,
+			  struct mt7928_txpwr *txpwr)
+{
+	struct mt7928_txpwr_event *event;
+	struct mt7925_txpwr_req req = {
+		.tag = cpu_to_le16(TX_POWER_SHOW_INFO),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.catg = TXPOWER_ALL_RATE_POWER_INFO,
+		.band_idx = band_idx,
+		.power_tbl = power_tbl,
+	};
+	struct sk_buff *skb;
+	int ret;
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_CMD(TXPOWER),
+					&req, sizeof(req), true, &skb);
+	if (ret)
+		return ret;
+
+	event = (struct mt7928_txpwr_event *)skb->data;
+	memcpy(txpwr, &event->txpwr, sizeof(*txpwr));
+
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
 int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 			   bool enable)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 1613c4765186..754db84200d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -69,7 +69,7 @@ struct mt7925_txpwr_req {
 	u8 format_id;
 	u8 catg;
 	u8 band_idx;
-	u8 _rsv1;
+	u8 power_tbl;
 } __packed;
 
 struct mt7925_txpwr_event {
@@ -90,6 +90,24 @@ struct mt7925_txpwr_event {
 	u8 rsv1;
 } __packed;
 
+struct mt7928_txpwr_event {
+	u8 rsv[4];
+	__le16 tag;
+	__le16 len;
+
+	u8 catg;
+	u8 band_idx;
+	u8 ch_band;
+	u8 format; /* 0:Legacy, 1:HE */
+
+	/* Rate power info */
+	struct mt7928_txpwr txpwr;
+
+	s8 pwr_max;
+	s8 pwr_min;
+	u8 rsv1;
+} __packed;
+
 enum {
 	TM_SWITCH_MODE,
 	TM_SET_AT_CMD,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index e3fef41cbb33..b06f17b2fd8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -260,6 +260,43 @@ struct mt7925_txpwr {
 	s8 eht996x3_484[16][2];
 };
 
+struct mt7928_txpwr {
+	s8 cck[4][2];
+	s8 ofdm20[8][2];
+	s8 ofdm40[8][2];
+	s8 ofdm80[8][2];
+	s8 ofdm160[8][2];
+	s8 ht20[8][2];
+	s8 ht40[9][2];
+	s8 vht20[12][2];
+	s8 vht40[12][2];
+	s8 vht80[12][2];
+	s8 vht160[12][2];
+	s8 he26[12][2];
+	s8 he52[12][2];
+	s8 he106[12][2];
+	s8 he242[12][2];
+	s8 he484[12][2];
+	s8 he996[12][2];
+	s8 he996x2[12][2];
+	s8 eht26[16][2];
+	s8 eht52[16][2];
+	s8 eht106[16][2];
+	s8 eht242[16][2];
+	s8 eht484[16][2];
+	s8 eht996[16][2];
+	s8 eht996x2[16][2];
+	s8 eht996x4[16][2];
+	s8 eht26_52[16][2];
+	s8 eht26_106[16][2];
+	s8 eht484_242[16][2];
+	s8 eht996_484[16][2];
+	s8 eht996_484_242[16][2];
+	s8 eht996x2_484[16][2];
+	s8 eht996x3[16][2];
+	s8 eht996x3_484[16][2];
+};
+
 static inline u8 mt7927_band_idx(enum nl80211_band band)
 {
 	switch (band) {
@@ -339,6 +376,8 @@ int mt7925_mcu_uni_bss_ps(struct mt792x_dev *dev,
 void mt7925_coredump_work(struct work_struct *work);
 int mt7925_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx,
 			  struct mt7925_txpwr *txpwr);
+int mt7928_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx, u8 power_tbl,
+			  struct mt7928_txpwr *txpwr);
 void mt7925_mac_set_fixed_rate_table(struct mt792x_dev *dev,
 				     u8 tbl_idx, u16 rate_idx);
 void mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 5a1ba1cfc5a3..fbe1793e5598 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -281,6 +281,7 @@ struct mt792x_dev {
 
 	u8 fw_debug;
 	u8 fw_features;
+	u8 txpwr_tbl;
 
 	struct mt76_connac_pm pm;
 	struct mt76_connac_coredump coredump;
-- 
2.18.0

