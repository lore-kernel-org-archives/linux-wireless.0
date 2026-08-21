Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CEE2FF65F
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 01:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787275932; cv=none; b=dNKdQ/Wehrc9UbbtEpJNAdnGfUkVOHnP1WougaBOd7c0R4ynCGfP3/NRyN7lSvrsalkrW6CmwTeoKXRGPXevND68VL0wZ/vKNo8evb+VslJp/4ck0gFI4YsYfeQa8unNkd2P9oxt4zpG/mI3ftWwB5DN8twcGsrrGcqU/StigEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787275932; c=relaxed/simple;
	bh=7Wtb8jQN7E1U+P5cTBPd5QaWbjVy+0PwPqjxW5G9yso=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBAVwH4uOg79ZdtsxYzE5tWPHHS6hJvX0qCzEBfPBx8OiGv19u9aRjU3gu3PqXeVasC7ix0a4oa+h+OoMvgGxTwckkRF7dKgqslKUUhzLBlgbicrp+LjJXMp3eiGETu+hB57p+sBYeaHFdRmoT/TIoBFmWyank34afeyGRuD0Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=F0v62nxK; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F0v62nxK"
X-UUID: 1cb8fa729d0011f18dc8c9802ae25ab1-20260821
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=pVBRQMzXN74sh53XLSLUpUpakdwcCdeHBXUzT2A8r7U=;
	b=F0v62nxKvhza6RuhupaCQEhTF3Ovw0wkho0IguqhM5Gk17oNaDFHnBke2erScsIEGLVLrjTivcwslBB74RuyZCnZJwT+bfWXctfCtrRl/C79f1n1KNZtflC3pnj66zFNoDw0wnFLvh39GPQQN6A0eZsKD4EI9J93k3CxyJ/Ha74=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:94139afe-6b60-4adb-a35f-a48f85b54692,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:7e75495e-4843-4d87-9105-fd688b4769cd,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1cb8fa729d0011f18dc8c9802ae25ab1-20260821
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1806462605; Fri, 21 Aug 2026 09:32:03 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 21 Aug 2026 09:32:02 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 21 Aug 2026 09:32:02 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v3] [PATCH 04/05] wifi: mt76: add PCIe speed tuning for mt7922/mt7928
Date: Fri, 21 Aug 2026 09:31:58 +0800
Message-ID: <20260821013159.2263479-4-anthony.liu@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260821013159.2263479-1-anthony.liu@mediatek.com>
References: <20260821013159.2263479-1-anthony.liu@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Some hardware platforms use ACPI MTFG table denoting the existence of
noise that impacts Wi-Fi performance.

This patch reads the ACPI SAR info and notifies F/W to detect current
status and to adjust PCIe bus to mitigate the noise.

Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7921/init.c  |  5 ++++
 .../wireless/mediatek/mt76/mt7921/pci_mac.c   |  6 ++++
 .../net/wireless/mediatek/mt76/mt7925/init.c  |  2 ++
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   |  6 ++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  4 +++
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 28 +++++++++++++++++++
 6 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 49be2fa4e3fa..fbd77ec48a52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -102,6 +102,11 @@ static int __mt7921_init_hardware(struct mt792x_dev *dev)
 		goto out;
 
 	ret = mt7921_mac_init(dev);
+	if (ret)
+		goto out;
+
+	if (is_mt7922(&dev->mt76))
+		ret = mt792x_mcu_set_dyn_pcie_gen(dev);
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 98b3469ac597..2449ac8ed6a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -116,6 +116,12 @@ int mt7921e_mac_reset(struct mt792x_dev *dev)
 	if (err)
 		goto out;
 
+	if (is_mt7922(&dev->mt76)) {
+		err = mt792x_mcu_set_dyn_pcie_gen(dev);
+		if (err)
+			goto out;
+	}
+
 	err = __mt7921_start(&dev->phy);
 out:
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index cd22fcc021b1..e499b64971b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -126,6 +126,8 @@ static int __mt7925_init_hardware(struct mt792x_dev *dev)
 		}
 	}
 
+	if (is_mt7928(&dev->mt76))
+		ret = mt792x_mcu_set_dyn_pcie_gen(dev);
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 8477d21abc66..9e4e78910560 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -149,6 +149,12 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 			goto out;
 	}
 
+	if (is_mt7928(&dev->mt76)) {
+		err = mt792x_mcu_set_dyn_pcie_gen(dev);
+		if (err)
+			goto out;
+	}
+
 	err = __mt7925_start(&dev->phy);
 out:
 	clear_bit(MT76_RESET, &dev->mphy.state);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index e7f3d36d5338..c1fa3dbba5ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -532,6 +532,7 @@ void mt792x_mac_link_bss_remove(struct mt792x_dev *dev,
 				struct mt792x_link_sta *mlink);
 void mt792x_config_mac_addr_list(struct mt792x_dev *dev);
 int mt792x_mcu_chip_config(struct mt792x_dev *dev, const char *cmd);
+int mt792x_mcu_set_dyn_pcie_gen(struct mt792x_dev *dev);
 
 static inline char *mt792x_ram_name(struct mt792x_dev *dev)
 {
@@ -630,6 +631,9 @@ int __mt792xe_mcu_drv_pmctrl(struct mt792x_dev *dev);
 int mt792xe_mcu_drv_pmctrl(struct mt792x_dev *dev);
 int mt792xe_mcu_fw_pmctrl(struct mt792x_dev *dev);
 
+#define MT792X_ACPI_FLAG_VALID  BIT(0) /* ACPI SAR is valid */
+#define MT792X_ACPI_FLAG_PCIe   BIT(3) /* Valid only when valid is set */
+
 #ifdef CONFIG_ACPI
 int mt792x_init_acpi_sar(struct mt792x_dev *dev);
 int mt792x_init_acpi_sar_power(struct mt792x_phy *phy, bool set_default);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index d676517df902..e77224e2ca50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -1180,6 +1180,34 @@ int mt792x_mcu_chip_config(struct mt792x_dev *dev, const char *cmd)
 }
 EXPORT_SYMBOL_GPL(mt792x_mcu_chip_config);
 
+int mt792x_mcu_set_dyn_pcie_gen(struct mt792x_dev *dev)
+{
+	u8 acpi_conf = mt792x_acpi_get_flags(&dev->phy);
+	char cmd[64];
+	int ret = 0;
+
+	if (!(acpi_conf & MT792X_ACPI_FLAG_VALID) ||
+	    !(acpi_conf & MT792X_ACPI_FLAG_PCIe))
+		return 0;
+
+	strscpy(cmd, "PcieGenSwitch 1 1200 0 -60");
+	ret = mt792x_mcu_chip_config(dev, cmd);
+	if (ret)
+		return ret;
+
+	strscpy(cmd, "PcieGenSwitchAGGen2 0");
+	ret = mt792x_mcu_chip_config(dev, cmd);
+	if (ret)
+		return ret;
+
+	if (!dev->mphy.cap.has_6ghz)
+		return 0;
+
+	strscpy(cmd, "PcieGenSwitch6G 1");
+	return mt792x_mcu_chip_config(dev, cmd);
+}
+EXPORT_SYMBOL_GPL(mt792x_mcu_set_dyn_pcie_gen);
+
 MODULE_DESCRIPTION("MediaTek MT792x core driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Lorenzo Bianconi <lorenzo@kernel.org>");
-- 
2.45.2

