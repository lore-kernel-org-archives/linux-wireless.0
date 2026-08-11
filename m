Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9079C352003
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441563; cv=none; b=KuWrFeImSpU4AcFC7jiqP9o3LqqpCyeW9/ntfiKFGVSOyUVlpBmLbdrfQSNaEvkaW7mnXKM5xTBZyhBrlXE20+UmdjMve6rSJG7TbewnUdPWw/OnxhslOZdmOI7Bj7iOlP+baq5Z155aRxhj6IMPecLQ5tvhJV3TacemR072T9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441563; c=relaxed/simple;
	bh=ANqtD7m0S5+YwTvHuK04QMea53ErSeJ+Mdr661zZSTA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EZuBXq5GY5/YV49Xyjflr82p3A8+zuI0mmg5ecuZl39QImuAgZzkBt8dXxpVWVTClfxS246ze2VYi6xFuEbD+j7Me9CRrEeFAP6Oo0qr4mtzreaVgw9vSWfjoCmEL+T1H4+bvcwJ/UNv7Tc17OhYTLTp0TDPxya8zVSkRQ/8Jzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LrkRoNyC; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LrkRoNyC"
X-UUID: 6cef98dc956911f18dc8c9802ae25ab1-20260811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=HnCKl4w4K2CmNhkIbsHwhAvkXw4PYZKLozDVpSIKau4=;
	b=LrkRoNyCQAwzgGemxKIj8P+A/gz709QY5c1JEJRAPjtoJMbdvDfTUW2VCRaCN7dl3JJD7WmWwvvjWfb/yZG2oFn1yPti9KJ5TRkqxfnXULwD65B8d8fcFlDM2ERJa57lS1m1CELlrmNmTHmsjKVMVMTAnJ3m0a1mq5+JkynFnP0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:82e14f44-338a-4747-8416-6d25201a7859,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:3b2ae3a7-8a7b-4c49-a0c0-42d13e7adac0,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6cef98dc956911f18dc8c9802ae25ab1-20260811
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <allan.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1678288237; Tue, 11 Aug 2026 17:45:45 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 11 Aug 2026 17:45:44 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 11 Aug 2026 17:45:44 +0800
From: Allan Wang <allan.wang@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <deren.wu@mediatek.com>,
	<mingyen.hsieh@mediatek.com>, <Sean.Wang@mediatek.com>,
	<robin.chiu@mediatek.com>, <posh.sun@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Shayne.Chen@mediatek.com>,
	<linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>, Allan
 Wang <allan.wang@mediatek.com>
Subject: [PATCH wireless-next v3] wifi: mt76: mt7925: add AXI DMA calibration cache for MT7928
Date: Tue, 11 Aug 2026 17:45:38 +0800
Message-ID: <20260811094538.588332-1-allan.wang@mediatek.com>
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

MT7928 supports caching calibration (fact-cal) data in a
host-side DMA buffer over AXI DMA, so the firmware can reuse previously
computed calibration results across warm resets instead of recomputing
them on every bring-up.

Add a new cached_cal source file under mt7925/, built into mt7925e
since the cache is reachable only over PCIe AXI DMA, that:
 - allocates a coherent DMA region laid out for the common/group/channel
   fact-cal buffers plus the mapping table,
 - programs the firmware with the region base/offset via the new
   MCU_UNI_CMD_AXIDMA command,
 - builds and streams the fact-cal mapping table to the firmware via the
   new MCU_UNI_CMD_FACT_CAL command.

On MT7928 run-firmware, the cache is enabled only when the chip
advertises MT792x_CHIP_CAP_AXIDMA_EN. A carried-over buffer that still
holds FW-written cal data is reused (reused=true); a freshly allocated
zeroed buffer starts cold. The region is freed on device unregister.

The buf_info and mapping-table layouts are size-asserted to match the
MT7928 firmware ABI.

Signed-off-by: Allan Wang <allan.wang@mediatek.com>
---

v3:
- fix the ACK handling: wait for the MCU response on every fact-cal command

v2:
- rebase onto the current mt76 tree
- tag the subject with the wireless-next prefix and advertise base-commit
- no functional change

 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |   2 +
 .../wireless/mediatek/mt76/mt7925/Makefile    |   2 +-
 .../mediatek/mt76/mt7925/cached_cal.c         | 298 ++++++++++++++++++
 .../mediatek/mt76/mt7925/cached_cal.h         | 151 +++++++++
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |   1 +
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |  62 +++-
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   |   2 +
 .../wireless/mediatek/mt76/mt7925/pci_mcu.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   8 +
 9 files changed, 526 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 0ededa569e9a..e46cb4ae37a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1357,9 +1357,11 @@ enum {
 	MCU_UNI_CMD_ALL_STA_INFO = 0x6e,
 	MCU_UNI_CMD_ASSERT_DUMP = 0x6f,
 	MCU_UNI_CMD_EXT_EEPROM_CTRL = 0x74,
+	MCU_UNI_CMD_FACT_CAL = 0x7c,
 	MCU_UNI_CMD_RADIO_STATUS = 0x80,
 	MCU_UNI_CMD_MLD = 0x82,
 	MCU_UNI_CMD_SDO = 0x88,
+	MCU_UNI_CMD_AXIDMA = 0xa2,
 };
 
 enum {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
index f9dcc0bba393..33539121a15c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
@@ -6,5 +6,5 @@ obj-$(CONFIG_MT7925U) += mt7925u.o
 
 mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o
 mt7925-common-$(CONFIG_NL80211_TESTMODE) += testmode.o
-mt7925e-y := pci.o pci_mac.o pci_mcu.o
+mt7925e-y := pci.o pci_mac.o pci_mcu.o cached_cal.o
 mt7925u-y := usb.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.c b/drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.c
new file mode 100644
index 000000000000..0209606e1a47
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.c
@@ -0,0 +1,298 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#include <linux/dma-mapping.h>
+#include "../mt792x.h"
+#include "cached_cal.h"
+
+static void mt7925_cal_cache_calc_layout(struct mt7925_cal_cache_layout *l)
+{
+	u32 hdr = sizeof(struct mt7925_fact_cal_buf_info);
+
+	l->common_stride  = hdr + MT7925_FACT_CAL_LEN_COM;
+	l->group_stride   = hdr + MT7925_FACT_CAL_LEN_GRP;
+	l->channel_stride = hdr + MT7925_FACT_CAL_LEN_CH;
+
+	l->common_off  = 0;
+	l->group_off   = l->common_off +
+		l->common_stride * MT7925_FACT_CAL_COMMON_BAND_NUM;
+	l->channel_off = l->group_off +
+		l->group_stride * MT7925_FACT_CAL_GROUP_NUM;
+	l->mapping_off = l->channel_off +
+		l->channel_stride * MT7925_FACT_CAL_CH_NUM_ALL;
+	l->total = l->mapping_off +
+		sizeof(struct mt7925_fact_cal_mapping_tbl);
+}
+
+static u32 mt7925_cal_cache_region_size(void)
+{
+	struct mt7925_cal_cache_layout l;
+
+	mt7925_cal_cache_calc_layout(&l);
+
+	return l.total;
+}
+
+int mt7925_axidma_alloc(struct mt792x_dev *dev)
+{
+	u32 total_size;
+	dma_addr_t dma_addr;
+	void *va;
+
+	if (dev->cached_cal.va)
+		return 0;
+
+	total_size = mt7925_cal_cache_region_size();
+
+	va = dma_alloc_coherent(dev->mt76.dev, total_size, &dma_addr,
+				GFP_KERNEL);
+	if (!va)
+		return -ENOMEM;
+
+	dev->cached_cal.va = va;
+	dev->cached_cal.dma_addr = dma_addr;
+	dev->cached_cal.size = total_size;
+
+	return 0;
+}
+
+void mt7925_axidma_free(struct mt792x_dev *dev)
+{
+	if (!dev->cached_cal.va)
+		return;
+
+	dma_free_coherent(dev->mt76.dev, dev->cached_cal.size,
+			  dev->cached_cal.va, dev->cached_cal.dma_addr);
+
+	memset(&dev->cached_cal, 0, sizeof(dev->cached_cal));
+}
+
+int mt7925_mcu_send_axidma_info(struct mt792x_dev *dev)
+{
+	struct mt7925_axidma_info_req *req;
+	u32 remap_base, pa_offset;
+	int ret;
+
+	if (!dev->cached_cal.va)
+		return -EINVAL;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	remap_base = (u32)(dev->cached_cal.dma_addr >> 16);
+	pa_offset = (u32)(dev->cached_cal.dma_addr & 0xFFFF);
+
+	req->remap.tag = cpu_to_le16(MT7925_AXIDMA_TAG_REMAP);
+	req->remap.len = cpu_to_le16(sizeof(req->remap));
+	req->remap.remap_addr = cpu_to_le32(remap_base);
+
+	req->fact_cal.tag = cpu_to_le16(MT7925_AXIDMA_TAG_FACT_CAL);
+	req->fact_cal.len = cpu_to_le16(sizeof(req->fact_cal));
+	req->fact_cal.host_addr_offset = cpu_to_le32(pa_offset);
+	req->fact_cal.size = cpu_to_le32(dev->cached_cal.size);
+	req->fact_cal.bound = cpu_to_le32(pa_offset + dev->cached_cal.size - 1);
+
+	ret = mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(AXIDMA),
+				req, sizeof(*req), true);
+
+	kfree(req);
+
+	if (ret)
+		dev_err(dev->mt76.dev,
+			"failed to send AXI DMA info: %d\n", ret);
+
+	return ret;
+}
+
+static bool mt7925_cal_cache_read_slot(struct mt792x_dev *dev, u32 region_off,
+				       u32 stride, u32 idx,
+				       u32 *cal_param, u32 *total_buf_num)
+{
+	const struct mt7925_fact_cal_buf_info *bi;
+	u32 off = region_off + stride * idx;
+
+	if (!dev->cached_cal.va || off + sizeof(*bi) > dev->cached_cal.size)
+		return false;
+
+	bi = (const struct mt7925_fact_cal_buf_info *)
+		((const u8 *)dev->cached_cal.va + off);
+	if (cal_param)
+		*cal_param = le32_to_cpu(bi->cal_param);
+	if (total_buf_num)
+		*total_buf_num = le32_to_cpu(bi->total_buf_num);
+	return true;
+}
+
+static void mt7925_fact_cal_build_mapping_tbl(struct mt792x_dev *dev,
+					      struct mt7925_fact_cal_mapping_tbl *tbl)
+{
+	dma_addr_t common_pa, group_pa, channel_pa, mapping_pa;
+	u32 hdr = sizeof(struct mt7925_fact_cal_buf_info);
+	dma_addr_t base = dev->cached_cal.dma_addr;
+	struct mt7925_cal_cache_layout l;
+
+	mt7925_cal_cache_calc_layout(&l);
+
+	common_pa  = base + l.common_off;
+	group_pa   = base + l.group_off;
+	channel_pa = base + l.channel_off;
+	mapping_pa = base + l.mapping_off;
+
+	memset(tbl, 0, sizeof(*tbl));
+
+	tbl->common.phy_addr_h = cpu_to_le32(upper_32_bits(common_pa));
+	tbl->common.phy_addr_l = cpu_to_le32(lower_32_bits(common_pa));
+	tbl->common.offset     = cpu_to_le32(l.common_stride);
+
+	tbl->group.phy_addr_h  = cpu_to_le32(upper_32_bits(group_pa));
+	tbl->group.phy_addr_l  = cpu_to_le32(lower_32_bits(group_pa));
+	tbl->group.offset      = cpu_to_le32(l.group_stride);
+
+	tbl->channel.phy_addr_h = cpu_to_le32(upper_32_bits(channel_pa));
+	tbl->channel.phy_addr_l = cpu_to_le32(lower_32_bits(channel_pa));
+	tbl->channel.offset     = cpu_to_le32(l.channel_stride);
+
+	if (dev->cached_cal.reused) {
+		u32 i, cal_param, total_buf_num;
+
+		for (i = 0; i < MT7925_FACT_CAL_COMMON_BAND_NUM; i++)
+			if (mt7925_cal_cache_read_slot(dev, l.common_off,
+						       l.common_stride, i,
+						       &cal_param, NULL))
+				tbl->common.band[i] = cal_param & 0xff;
+
+		for (i = 0; i < MT7925_FACT_CAL_GROUP_NUM; i++)
+			if (mt7925_cal_cache_read_slot(dev, l.group_off,
+						       l.group_stride, i,
+						       &cal_param, NULL))
+				tbl->group.group[i] = cal_param & 0xff;
+
+		for (i = 0; i < MT7925_FACT_CAL_CH_NUM_ALL; i++)
+			if (mt7925_cal_cache_read_slot(dev, l.channel_off,
+						       l.channel_stride, i,
+						       &cal_param,
+						       &total_buf_num)) {
+				tbl->channel.cal_param[i] =
+					cpu_to_le32(cal_param);
+				tbl->channel.total_buf_num[i] =
+					total_buf_num & 0xff;
+			}
+	}
+
+	tbl->buf_info_size = cpu_to_le32(hdr);
+	tbl->phy_addr_h    = cpu_to_le32(upper_32_bits(mapping_pa));
+	tbl->phy_addr_l    = cpu_to_le32(lower_32_bits(mapping_pa));
+}
+
+static int mt7925_mcu_fact_cal_rapid_set(struct mt792x_dev *dev, u8 cal_type,
+					 u32 seq_num, bool done,
+					 const void *data, u32 data_len)
+{
+	struct mt7925_fact_cal_req *req;
+	int ret;
+
+	if (data_len > MT7925_FACT_CAL_DATA_BUF_LEN)
+		return -EINVAL;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->set.tag = cpu_to_le16(MT7925_FACT_CAL_TAG_RAPID_SET);
+	req->set.len = cpu_to_le16(sizeof(req->set));
+	req->set.seq_num = cpu_to_le32(seq_num);
+	req->set.buf_data_len = cpu_to_le32(data_len);
+	req->set.cal_type = cal_type;
+	req->set.done = done;
+	if (data && data_len)
+		memcpy(req->set.buf_data, data, data_len);
+
+	ret = mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(FACT_CAL),
+				req, sizeof(*req), true);
+	kfree(req);
+
+	return ret;
+}
+
+int mt7925_mcu_send_fact_cal_mapping_tbl(struct mt792x_dev *dev)
+{
+	struct mt7925_fact_cal_mapping_tbl *tbl;
+	__le32 cfg[MT7925_FACT_CAL_BUF_CFG_LEN / sizeof(__le32)] = {0};
+	u32 seq = 0, off = 0, left;
+	int ret;
+
+	if (!dev->cached_cal.va)
+		return -EINVAL;
+
+	tbl = kzalloc(sizeof(*tbl), GFP_KERNEL);
+	if (!tbl)
+		return -ENOMEM;
+
+	mt7925_fact_cal_build_mapping_tbl(dev, tbl);
+
+	cfg[1] = cpu_to_le32(sizeof(*tbl));
+	cfg[2] = cpu_to_le32(MT7925_FACT_CAL_DATA_BUF_NUM_MAX);
+	ret = mt7925_mcu_fact_cal_rapid_set(dev, MT7925_FACT_CAL_TYPE_MAPPING_TBL,
+					    seq, false, cfg, sizeof(cfg));
+	if (ret) {
+		dev_err(dev->mt76.dev,
+			"fact-cal mapping tbl header send failed (seq=%u): %d\n",
+			seq, ret);
+		goto out;
+	}
+
+	left = sizeof(*tbl);
+	while (left) {
+		u32 chunk = min_t(u32, left, MT7925_FACT_CAL_DATA_BUF_LEN);
+
+		ret = mt7925_mcu_fact_cal_rapid_set(dev,
+						    MT7925_FACT_CAL_TYPE_MAPPING_TBL,
+						    ++seq, false,
+						    (u8 *)tbl + off, chunk);
+		if (ret) {
+			dev_err(dev->mt76.dev,
+				"fact-cal mapping tbl data send failed (seq=%u, off=%u, chunk=%u): %d\n",
+				seq, off, chunk, ret);
+			goto out;
+		}
+
+		off  += chunk;
+		left -= chunk;
+	}
+
+	ret = mt7925_mcu_fact_cal_rapid_set(dev, MT7925_FACT_CAL_TYPE_MAPPING_TBL,
+					    ++seq, true, NULL, 0);
+	if (ret) {
+		dev_err(dev->mt76.dev,
+			"fact-cal mapping tbl done send failed (seq=%u): %d\n",
+			seq, ret);
+		goto out;
+	}
+out:
+	kfree(tbl);
+
+	return ret;
+}
+
+int mt7925_mcu_fact_cal_set_bypass(struct mt792x_dev *dev, bool enable)
+{
+	struct {
+		u8 _rsv[4];
+
+		struct {
+			__le16 tag;
+			__le16 len;
+			__le32 data;
+		} __packed update_flag;
+	} req = {
+		.update_flag = {
+			.tag  = cpu_to_le16(MT7925_FACT_CAL_TAG_UPDATE_FLAG),
+			.len  = cpu_to_le16(sizeof(req.update_flag)),
+			.data = cpu_to_le32(enable ? 1 : 0),
+		},
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(FACT_CAL),
+				 &req, sizeof(req), true);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.h b/drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.h
new file mode 100644
index 000000000000..6572513b7646
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear */
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#ifndef __CACHED_CAL_H
+#define __CACHED_CAL_H
+
+enum mt7925_axidma_info_tag {
+	MT7925_AXIDMA_TAG_REMAP = 0,
+	MT7925_AXIDMA_TAG_FACT_CAL = 1,
+	MT7925_AXIDMA_TAG_NUM
+};
+
+enum mt7925_fact_cal_tag {
+	MT7925_FACT_CAL_TAG_TRIGGER	= 2,
+	MT7925_FACT_CAL_TAG_UPDATE_FLAG	= 3,
+	MT7925_FACT_CAL_TAG_RAPID_GET	= 4,
+	MT7925_FACT_CAL_TAG_RAPID_SET	= 5,
+};
+
+enum mt7925_fact_cal_type {
+	MT7925_FACT_CAL_TYPE_COMMON		= 0,
+	MT7925_FACT_CAL_TYPE_GROUP		= 1,
+	MT7925_FACT_CAL_TYPE_CHANNEL		= 2,
+	MT7925_FACT_CAL_TYPE_MAPPING_TBL	= 4,
+};
+
+#define MT7925_FACT_CAL_DATA_BUF_LEN		1400
+#define MT7925_FACT_CAL_BUF_CFG_LEN			16
+#define MT7925_FACT_CAL_DATA_BUF_NUM_MAX	4
+#define MT7925_FACT_CAL_BUF_CFG_U32_LEN		4
+#define MT7925_FACT_CAL_DATA_MAX_BUF_LEN \
+	(MT7925_FACT_CAL_DATA_BUF_NUM_MAX * MT7925_FACT_CAL_BUF_CFG_U32_LEN)
+
+#define MT7925_FACT_CAL_COMMON_BAND_NUM		2
+#define MT7925_FACT_CAL_GROUP_NUM		35
+#define MT7925_FACT_CAL_CH_NUM_2G		14
+#define MT7925_FACT_CAL_CH_NUM_5G		68
+#define MT7925_FACT_CAL_CH_NUM_6G		109
+#define MT7925_FACT_CAL_CH_NUM_ALL \
+	(MT7925_FACT_CAL_CH_NUM_2G + MT7925_FACT_CAL_CH_NUM_5G + \
+	 MT7925_FACT_CAL_CH_NUM_6G)
+
+#define MT7925_FACT_CAL_LEN_COM			600
+#define MT7925_FACT_CAL_LEN_GRP			4500
+#define MT7925_FACT_CAL_LEN_CH			2800
+
+struct mt7925_fact_cal_buf_info {
+	__le32 cal_type;
+	__le32 cal_param;
+	__le32 buf_seq_num;
+	__le32 total_buf_num;
+	__le32 buf_data_len;
+	u8 valid;
+	u8 done;
+	u8 rsv[2];
+	__le32 buf_cfg_info[MT7925_FACT_CAL_DATA_MAX_BUF_LEN];
+} __packed;
+
+static_assert(sizeof(struct mt7925_fact_cal_buf_info) == 88,
+	      "buf_info must match the MT7928 FW (88 bytes) or it rejects the mapping table");
+
+struct mt7925_fact_cal_common_map {
+	__le32 phy_addr_h;
+	__le32 phy_addr_l;
+	__le32 offset;
+	u8 band[MT7925_FACT_CAL_COMMON_BAND_NUM];
+	u8 rsv[2];
+} __packed;
+
+struct mt7925_fact_cal_group_map {
+	__le32 phy_addr_h;
+	__le32 phy_addr_l;
+	__le32 offset;
+	u8 group[MT7925_FACT_CAL_GROUP_NUM];
+	u8 rsv;
+} __packed;
+
+struct mt7925_fact_cal_channel_map {
+	__le32 phy_addr_h;
+	__le32 phy_addr_l;
+	__le32 offset;
+	__le32 cal_param[MT7925_FACT_CAL_CH_NUM_ALL];
+	u8 total_buf_num[MT7925_FACT_CAL_CH_NUM_ALL];
+	u8 rsv;
+} __packed;
+
+struct mt7925_fact_cal_mapping_tbl {
+	struct mt7925_fact_cal_common_map common;
+	struct mt7925_fact_cal_group_map group;
+	struct mt7925_fact_cal_channel_map channel;
+	__le32 buf_info_size;
+	__le32 phy_addr_h;
+	__le32 phy_addr_l;
+} __packed;
+
+static_assert(sizeof(struct mt7925_fact_cal_mapping_tbl) == 1044,
+	      "mapping table must match the MT7928 FW (1044 bytes) or the FW parse corrupts");
+
+struct mt7925_cal_cache_layout {
+	u32 common_off, group_off, channel_off, mapping_off;
+	u32 common_stride, group_stride, channel_stride;
+	u32 total;
+};
+
+struct mt7925_axidma_info_req {
+	u8 _rsv[4];
+
+	struct {
+		__le16 tag;
+		__le16 len;
+		__le32 remap_addr;
+		__le32 reserved;
+	} __packed remap;
+
+	struct {
+		__le16 tag;
+		__le16 len;
+		__le32 host_addr_offset;
+		__le32 size;
+		__le32 bound;
+		__le32 reserved;
+	} __packed fact_cal;
+} __packed;
+
+struct mt7925_fact_cal_req {
+	u8 _rsv[4];
+
+	struct {
+		__le16 tag;
+		__le16 len;
+		__le32 data;
+		__le32 seq_num;
+		__le32 buf_data_len;
+		u8 cal_type;
+		u8 done;
+		u8 rsv[2];
+		u8 buf_data[MT7925_FACT_CAL_DATA_BUF_LEN];
+	} __packed set;
+} __packed;
+
+int mt7925_axidma_alloc(struct mt792x_dev *dev);
+
+void mt7925_axidma_free(struct mt792x_dev *dev);
+
+int mt7925_mcu_send_axidma_info(struct mt792x_dev *dev);
+
+int mt7925_mcu_send_fact_cal_mapping_tbl(struct mt792x_dev *dev);
+
+int mt7925_mcu_fact_cal_set_bypass(struct mt792x_dev *dev, bool enable);
+
+#endif /* __CACHED_CAL_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 321e732347f2..4d79c1e66e66 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -353,6 +353,7 @@ int mt7925_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 
 int mt7925e_mac_reset(struct mt792x_dev *dev);
 int mt7925e_mcu_init(struct mt792x_dev *dev);
+void mt7925e_axidma_cal_cache_init(struct mt792x_dev *dev);
 void mt7925_mac_add_txs(struct mt792x_dev *dev, void *data);
 void mt7928_mac_add_txs_msg(struct mt792x_dev *dev, void *evt);
 void mt7925_set_runtime_pm(struct mt792x_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 02ef09dd797d..724abd2be57c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -9,6 +9,7 @@
 #include "mac.h"
 #include "mcu.h"
 #include "regd.h"
+#include "cached_cal.h"
 #include "../dma.h"
 
 static const struct pci_device_id mt7925_pci_device_table[] = {
@@ -38,6 +39,62 @@ static int mt7925e_init_reset(struct mt792x_dev *dev)
 	return mt792x_wpdma_reset(dev, true);
 }
 
+/* Set up the factory-calibration cache in host memory. PCIe only: the FW
+ * reaches the buffer through AXI DMA, so it has no meaning on other buses.
+ * Every failure just leaves the cache off, which is not fatal.
+ */
+void mt7925e_axidma_cal_cache_init(struct mt792x_dev *dev)
+{
+	if (!(dev->phy.chip_cap & MT792x_CHIP_CAP_AXIDMA_EN))
+		return;
+
+	if (dev->cached_cal.va) {
+		/* Carried-over buffer still holds FW-written cal data. */
+		dev->cached_cal.reused = true;
+	} else {
+		if (mt7925_axidma_alloc(dev)) {
+			dev_warn(dev->mt76.dev,
+				 "AXI DMA cal cache disabled: buffer alloc failed\n");
+			return;
+		}
+		/* Freshly allocated buffer is zeroed: no cal data yet. */
+		dev->cached_cal.reused = false;
+	}
+
+	if (mt7925_mcu_send_axidma_info(dev)) {
+		dev_warn(dev->mt76.dev,
+			 "AXI DMA cal cache disabled: info cmd to FW failed\n");
+		return;
+	}
+
+	/* Enable the bypass-cal flow so the FW reuses cached cal data
+	 * (common / power-on group) instead of running a full calibration;
+	 * must be set before the mapping table is sent.
+	 */
+	if (mt7925_mcu_fact_cal_set_bypass(dev, true)) {
+		dev_warn(dev->mt76.dev,
+			 "AXI DMA cal cache disabled: bypass flag set failed\n");
+		return;
+	}
+
+	if (mt7925_mcu_send_fact_cal_mapping_tbl(dev)) {
+		dev_warn(dev->mt76.dev,
+			 "AXI DMA cal cache disabled: mapping tbl send failed\n");
+		return;
+	}
+
+	if (mt7925_mcu_fact_cal_set_bypass(dev, false)) {
+		dev_warn(dev->mt76.dev,
+			 "AXI DMA cal cache disabled: bypass flag set failed\n");
+		return;
+	}
+
+	dev_info(dev->mt76.dev,
+		 "AXI DMA cal cache enabled (DMA=%pad, size=%u, reused=%d)\n",
+		 &dev->cached_cal.dma_addr, dev->cached_cal.size,
+		 dev->cached_cal.reused);
+}
+
 static void mt7925e_unregister_device(struct mt792x_dev *dev)
 {
 	int i;
@@ -58,6 +115,9 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 
 	mt7925_tx_token_put(dev);
 	__mt792x_mcu_drv_pmctrl(dev);
+
+	mt7925_axidma_free(dev);
+
 	mt792x_dma_cleanup(dev);
 	mt792x_wfsys_reset(dev);
 	skb_queue_purge(&dev->mt76.mcu.res_q);
@@ -587,7 +647,7 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 	is_mt7928_hw = (pdev->device == 0x7928 || pdev->device == 0x7935);
 
 	if (is_mt7928_hw)
-		ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(34));
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(34));
 	else
 		ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 8477d21abc66..c90f129b3a34 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -135,6 +135,8 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 	if (err)
 		goto out;
 
+	mt7925e_axidma_cal_cache_init(dev);
+
 	err = mt7925_mcu_set_eeprom(dev);
 	if (err)
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mcu.c
index 72707eddc3db..258f3753db1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mcu.c
@@ -46,6 +46,8 @@ int mt7925e_mcu_init(struct mt792x_dev *dev)
 	mt76_rmw_field(dev, dev->pcie_reg->pm, MT_PCIE_MAC_PM_L0S_DIS, 1);
 
 	err = mt7925_run_firmware(dev);
+	if (!err)
+		mt7925e_axidma_cal_cache_init(dev);
 
 	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_FWDL], false);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9efc251cb745..740d517eb38b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -33,6 +33,7 @@
 #define MT792x_CHIP_CAP_REGD_EN BIT(5)
 #define MT792x_CHIP_CAP_MLO_EN BIT(8)
 #define MT792x_CHIP_CAP_MLO_EML_EN BIT(9)
+#define MT792x_CHIP_CAP_AXIDMA_EN BIT(16)
 
 /* NOTE: used to map mt76_rates. idx may change if firmware expands table */
 #define MT792x_BASIC_RATES_TBL	14
@@ -342,6 +343,13 @@ struct mt792x_dev {
 	struct ieee80211_vif *nan_vif;
 	const struct ieee80211_iface_combination *iface_combinations;
 	int n_iface_combinations;
+
+	struct {
+		void *va;
+		dma_addr_t dma_addr;
+		u32 size;
+		bool reused;
+	} cached_cal;
 };
 
 static inline struct mt792x_bss_conf *

base-commit: 4df22710a77d2365e56d720bc4106e54c1dfa2ff
-- 
2.45.2

