Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFA25D530
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883058; cv=none; b=ju0iuOZYSmLH42w9xPlXStW88ncbJ28HhJPc9xCzFsuVACQZHRXckAMRmFE3QAZxXRU4NSxSS0a4fsP0+ou3SAyi1IuodCPzmkZz5DXrMSvrHubjKM3q90fsIjrjZIwwVbtFNl7qsWY/RYh9NOzXdxt4fHnuVQzjRir5yXcqokE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883058; c=relaxed/simple;
	bh=iUwKdPVhTcihTefcKVnJRGdgSfbVNIC0aUK5/U0ymkU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R1A6lIT8cPiU/TJSE1EIfShMnLlfk8MZE2OdhE26JdSUkZMJs419TZbaHErPRJh85nwf6GqhcPVchpHz9lAKgA+t+PYfVeRrCSMLe/WD9NzrEXa/xkTB2hQEu6PMGHfcCyKV4xGC7gjmC3K/D0TIhVXSxFK+4g4DqL/VJXcxzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FPVfEo+g; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FPVfEo+g"
X-UUID: c6577f56873c11f1b1788b6acf885367-20260724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=MnRixE6weqns9LMjI9StUQxtCc6zp/FRL3aSl+otoVY=;
	b=FPVfEo+gPVcfxi+Ny5+iaqurMLhOe7WgpICmIZ0gij/RKqqL0BNRi+yALsYjVNrNnRltkL8c4756M0Lt2vf0ssW7kmBWhV6ey8NnigWWepwpzYtRgpnHNj733/+T8g8mrKOEAfWW+6hjCpfVluu9ypYYnINSwbAq0/HgeKFZOKQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:23dc3e62-d992-4038-81da-c84811db0d8e,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:8a735a6,CLOUDID:12f5dc5f-762a-4584-baab-4eebe609beea,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c6577f56873c11f1b1788b6acf885367-20260724
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 172949762; Fri, 24 Jul 2026 16:50:52 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 24 Jul 2026 16:50:46 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 24 Jul 2026 16:50:46 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Charlie-cy.Wu@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: connac3: add fixedrate and autorate debugfs for rate control
Date: Fri, 24 Jul 2026 16:50:45 +0800
Message-ID: <20260724085045.3155797-1-jb.tsai@mediatek.com>
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

Add two debugfs interfaces to manually control the per-STA rate
adaptation via the UNI_CMD_RA firmware command:

- fixedrate: lock a STA to a fixed TX rate (SET_FIXED_RATE tag). The
  value is a packed hex field describing the full PHY rate:
    0x[WCID(2)][Mode][BW][MCS][Nss][SGI][Preamble]
	[STBC][LDPC][SPE_EN][HeLtf]
- autorate: re-enable/disable firmware rate adaptation for a STA
  (SET_AUTO_RATE tag):
    0x[WCID(2)][En][Mode]

Key changes:
- Add mt7925_mcu_set_fixed_rate() sending the SET_FIXED_RATE(0x0F) TLV
- Add mt7925_mcu_set_auto_rate() sending the SET_AUTO_RATE(0x11) TLV
- Add RA command TLV structures (mt7925_ra_hdr,
  mt7925_ra_fixed_rate_tlv/_v1, mt7925_ra_auto_rate_tlv) and the
  UNI_CMD_RA tag enum
- Register fixedrate/autorate debugfs files and store the last value
  in mt792x_dev for read back
- Translate the LDPC input to the FW's "on" value (7)

Note: EHT modes require HeLtf=1, otherwise the firmware drops all TX.

Usage:
  echo 0x1D372000101 > /sys/kernel/debug/ieee80211/phyX/mt76/fixedrate
  echo 0x110 > /sys/kernel/debug/ieee80211/phyX/mt76/autorate

Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/debugfs.c   | 97 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 40 ++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   | 42 ++++++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  3 +
 4 files changed, 182 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index 3db564d63c15..4a043855a049 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -427,6 +427,101 @@ static int mt7925_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7925_chip_reset, "%lld\n");
 
+/* fixedrate input format (12 hex digits):
+ * 0x[WCID(2)][Mode][BW][MCS][Nss][SGI][Preamble][STBC][LDPC][SPE_EN][HeLtf]
+ * The RA tag is fixed to SET_FIXED_RATE internally.
+ * WCID is 2 nibbles, all others are 1 nibble.
+ *
+ * [WCID]    Wireless Client ID
+ * [Mode]    CCK=0, OFDM=1, HT=2, GF=3, VHT=4, PLR=5, HE_SU=8, HE_ER_SU=9,
+ *           HE_TRIG=10, HE_MU=11, EHT_ER=13, EHT_TB=14, EHT_SU and EHT_MU=15
+ * [BW]      BW20=0, BW40=1, BW80=2, BW160=3, BW320=4
+ * [MCS]     CCK=0~3, OFDM=0~7, HT=0~32, VHT=0~9, HE=0~11, EHT=0~13, EHT_ER=14~15
+ * [Nss]     1~8
+ * [GI]      HT/VHT: 0=Long, 1=Short; HE/EHT: 0=0.8us, 1=1.6us, 2=3.2us
+ * [Preamble] Long=0, Short=other
+ * [STBC]    Enable=1, Disable=0
+ * [LDPC]    BCC=0, LDPC=1 (driver sends the FW's "on" value 7)
+ * [SPE_EN]  spatial extension index
+ * [HeLtf]   1X=0, 2X=1, 4X=2 (NOTE: EHT modes require HeLtf=1)
+ */
+static int
+mt7925_fixedrate_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+	struct mt7925_ra_fixed_rate_v1 rate = {};
+
+	dev->fixed_rate = val;
+
+	rate.wlan_idx       = cpu_to_le16((val >> 40) & 0xff);
+	rate.phy_mode       = (val >> 36) & 0xf;
+	rate.bw             = (val >> 32) & 0xf;
+	rate.mcs            = (val >> 28) & 0xf;
+	rate.nss            = (val >> 24) & 0xf;
+	rate.short_gi       = cpu_to_le16((val >> 20) & 0xf);
+	rate.short_preamble = (val >> 16) & 0xf;
+	rate.stbc           = (val >> 12) & 0xf;
+	rate.ecc            = ((val >> 8) & 0xf) ? 7 : 0;
+	rate.spe            = (val >> 4) & 0xf;
+	rate.he_ltf         = cpu_to_le16((val >> 0) & 0xf);
+
+	mt792x_mutex_acquire(dev);
+	mt7925_mcu_set_fixed_rate(dev, &rate);
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7925_fixedrate_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->fixed_rate;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_fixedrate, mt7925_fixedrate_get,
+			 mt7925_fixedrate_set, "0x%llx\n");
+
+/* autorate input format (6 hex digits):
+ * 0x[Tag(2)][WCID(2)][En][Mode]
+ * The RA tag is fixed to SET_AUTO_RATE internally.
+ * WCID is 2 nibbles, En and Mode are 1 nibble each.
+ *
+ * [WCID] Wireless Client ID
+ * [En]   Auto rate: Enable=1, Disable=0
+ * [Mode] don't care (RA picks the rate)
+ */
+static int
+mt7925_autorate_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+	u16 wlan_idx = (val >> 8) & 0xff;
+	bool enable = (val >> 4) & 0xf;
+	u8 mode = val & 0xf;
+
+	dev->auto_rate = val;
+
+	mt792x_mutex_acquire(dev);
+	mt7925_mcu_set_auto_rate(dev, wlan_idx, enable, mode);
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7925_autorate_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->auto_rate;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_autorate, mt7925_autorate_get,
+			 mt7925_autorate_set, "0x%llx\n");
+
 int mt7925_init_debugfs(struct mt792x_dev *dev)
 {
 	struct dentry *dir;
@@ -461,6 +556,8 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 	debugfs_create_devm_seqfile(dev->mt76.dev, "runtime_pm_stats", dir,
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
+	debugfs_create_file("fixedrate", 0600, dir, dev, &fops_fixedrate);
+	debugfs_create_file("autorate", 0600, dir, dev, &fops_autorate);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 7162eca8e23e..b8062eb91ba5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -4113,3 +4113,43 @@ int mt7925_mcu_set_rssimonitor(struct mt792x_dev *dev, struct ieee80211_vif *vif
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(RSSI_MONITOR), &req,
 				 sizeof(req), false);
 }
+
+int mt7925_mcu_set_fixed_rate(struct mt792x_dev *dev,
+			      struct mt7925_ra_fixed_rate_v1 *rate)
+{
+	struct {
+		struct mt7925_ra_hdr hdr;
+		struct mt7925_ra_fixed_rate_tlv tlv;
+		struct mt7925_ra_fixed_rate_v1 v1;
+	} __packed req = {
+		.tlv = {
+			.tag = cpu_to_le16(UNI_CMD_RA_TAG_SET_FIXED_RATE),
+			.len = cpu_to_le16(sizeof(req.tlv) + sizeof(req.v1)),
+			.version = cpu_to_le16(0),
+		},
+		.v1 = *rate,
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(RA), &req,
+				 sizeof(req), true);
+}
+
+int mt7925_mcu_set_auto_rate(struct mt792x_dev *dev, u16 wlan_idx,
+			     bool enable, u8 mode)
+{
+	struct {
+		struct mt7925_ra_hdr hdr;
+		struct mt7925_ra_auto_rate_tlv tlv;
+	} __packed req = {
+		.tlv = {
+			.tag = cpu_to_le16(UNI_CMD_RA_TAG_SET_AUTO_RATE),
+			.len = cpu_to_le16(sizeof(req.tlv)),
+			.wlan_idx = cpu_to_le16(wlan_idx),
+			.auto_rate_en = enable,
+			.mode = mode,
+		},
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(RA), &req,
+				 sizeof(req), true);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 754db84200d8..855613f0b29d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -61,6 +61,44 @@ struct mt7925_mcu_ant_id_config {
 	u8 ant_id[4];
 } __packed;
 
+enum {
+	UNI_CMD_RA_TAG_SET_FIXED_RATE = 0x0F,
+	UNI_CMD_RA_TAG_SET_AUTO_RATE = 0x11,
+};
+
+struct mt7925_ra_hdr {
+	u8 _rsv[4];
+} __packed;
+
+struct mt7925_ra_fixed_rate_tlv {
+	__le16 tag;
+	__le16 len;
+	__le16 version;
+} __packed;
+
+struct mt7925_ra_fixed_rate_v1 {
+	__le16 wlan_idx;
+	u8 phy_mode;
+	u8 stbc;
+	__le16 short_gi;
+	u8 bw;
+	u8 ecc;
+	u8 mcs;
+	u8 nss;
+	__le16 he_ltf;
+	u8 spe;
+	u8 short_preamble;
+	__le16 _rsv;
+} __packed;
+
+struct mt7925_ra_auto_rate_tlv {
+	__le16 tag;
+	__le16 len;
+	__le16 wlan_idx;
+	u8 auto_rate_en;
+	u8 mode;
+} __packed;
+
 struct mt7925_txpwr_req {
 	u8 _rsv[4];
 	__le16 tag;
@@ -758,4 +796,8 @@ int mt7925_mcu_update_arp_filter(struct mt76_dev *dev,
 int
 mt7925_mcu_uni_bss_bcnft(struct mt792x_dev *dev,
 			 struct ieee80211_bss_conf *link_conf, bool enable);
+int mt7925_mcu_set_fixed_rate(struct mt792x_dev *dev,
+			      struct mt7925_ra_fixed_rate_v1 *rate);
+int mt7925_mcu_set_auto_rate(struct mt792x_dev *dev, u16 wlan_idx,
+			     bool enable, u8 mode);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index fbe1793e5598..eecd0b1a5d0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -283,6 +283,9 @@ struct mt792x_dev {
 	u8 fw_features;
 	u8 txpwr_tbl;
 
+	u64 fixed_rate;
+	u64 auto_rate;
+
 	struct mt76_connac_pm pm;
 	struct mt76_connac_coredump coredump;
 	const struct mt792x_hif_ops *hif_ops;
-- 
2.18.0

