Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64313EB0E6
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785917158; cv=none; b=V8k/jB3t7cliaR2wZ6QGn7lKcINm3Xf/sq3366WIQnpeIsOjx/cBi4D3Qv2gwLMuWnUcajpM8mqdm99jRi4a0Ze2YvbqXRlz59ChBuJPc8AfBg9hT1fbxrBxPVC1uNfP2Fr6o3e3I5Q+ERmwh4kr3Ez7AHD22zLi7rNvgNR3DOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785917158; c=relaxed/simple;
	bh=0jxweab9qxVlPqnrhHbCkc/pPlKuU5OLMEyKFljlKQc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bGjcMPBZIujj6IEgBkBmP0S/BesUEqqlK4y+7eMhflOVk2PRJmF8Q7r0ZChS7nhex+Q10u5UYiaHwON1YZ/bvT8pMgU/9zbm4MedXFaEE8YCFoZWpkWj4FOoieWKP89GUi/8M6Y31AaUmDXsZrtn3a5tjPyKlAyySy7wX/zuw58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=t3wY/HeG; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="t3wY/HeG"
X-UUID: 7205e3f490a411f18dc8c9802ae25ab1-20260805
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=6oHIG8bufx08CSNICgF40jlWcQaCegh5jG1SABcEZRw=;
	b=t3wY/HeGA0QSZ5pHGW/0L86eAINQDSnFRj+b2atHoYs1D/wyYjxqDlFtIF3RGp/6lBwbL7hcQfm4f/wTk7AmHOreOAwwHuOStnpx+yT+JakgUzqM0zBb1q3Y+sCeXIVamfQ38m0AlrqINepyMxTEsjv8y87A/Q/wUp9/j9qvK2I=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e1fb42c1-53a7-45b9-8e8d-fe5ef340f759,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:94151834-e4ca-4cf2-b0f5-4d5338f4661e,B
	ulkID:nil,BulkQuantity:0,SF:102|136|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7205e3f490a411f18dc8c9802ae25ab1-20260805
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1929906782; Wed, 05 Aug 2026 16:05:38 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 5 Aug 2026 16:05:37 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 5 Aug 2026 16:05:37 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Tony-TC.Lee@mediatek.com>,
	<jb.tsai@mediatek.com>, tony-tc.lee <tony-tc.lee@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: add MT7935 virtual efuse (vefuse) support
Date: Wed, 5 Aug 2026 16:05:36 +0800
Message-ID: <20260805080536.1449395-1-jb.tsai@mediatek.com>
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

From: "tony-tc.lee" <tony-tc.lee@mediatek.com>

MT7935 can override eFuse/EEPROM values at runtime using a "virtual
efuse" (vefuse) payload embedded in the RAM firmware image as a
non-download region (FW_TYPE_EXTEND_BIN_EFUSE). The host driver locates
this region and pushes it to firmware, which applies it as an eFuse
override.

Firmware advertises vefuse capability via the NIC capability TLV
MT_NIC_CAP_VEFUSE_INFO (0x44), reporting whether vefuse is enabled and
the expected payload size. Parse it in mt7925_mcu_get_nic_capability()
and store it in mt792x_dev.vefuse_cap.

After the firmware is up (mt7925_run_firmware),
mt7925_load_vefuse_from_fw() finds the FW_TYPE_EXTEND_BIN_EFUSE / NON_DL
region in the RAM firmware image and downloads it via the UNI EFUSE_CTRL
buffer-mode command (source_mode = VEFUSE), paged in chunks of
MT7925_VEFUSE_PAGE_SIZE (1024).

Two non-obvious ABI details:
  - The EFUSE_CTRL command payload carries a 4-byte header before the
    buffer-mode TLV (as the efuse access/read commands do); omitting it
    makes firmware misparse the TLV and silently drop the write.
  - The packed FW region is larger than the vefuse payload (connac adds a
    per-region CRC and 16-byte alignment), so the region length is only
    sanity-checked as ">= vefuse_cap.size" and exactly vefuse_cap.size
    bytes are pushed, matching the firmware's expected size.

Applying the vefuse override is best-effort: any failure only warns and
is skipped, so it never fails firmware bring-up (the chip falls back to
its default eFuse values).

vefuse content is delivered inside the RAM firmware image and is not
separately verified by the driver (no MD5/hash/eFuse binding).

Also add a root-only, read-only debugfs "vefuse" node (created only when a
vefuse region is present in the RAM firmware image) that reads the vefuse
buffer back from firmware.

Signed-off-by: tony-tc.lee <tony-tc.lee@mediatek.com>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |   2 +
 .../wireless/mediatek/mt76/mt7925/debugfs.c   |  52 ++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 226 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  35 +++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   6 +
 5 files changed, 321 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 0ededa569e9a..9c844bef92c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -44,6 +44,7 @@
 enum {
 	FW_TYPE_DEFAULT = 0,
 	FW_TYPE_CLC = 2,
+	FW_TYPE_EXTEND_BIN_EFUSE = 3,
 	FW_TYPE_MAX_NUM = 255
 };
 
@@ -1481,6 +1482,7 @@ enum {
 	MT_NIC_CAP_6G,
 	MT_NIC_CAP_CHIP_CAP = 0x20,
 	MT_NIC_CAP_EML_CAP = 0x22,
+	MT_NIC_CAP_VEFUSE_INFO = 0x44,
 };
 
 #define UNI_WOW_DETECT_TYPE_MAGIC		BIT(0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index d01ff49de47a..34e261e247fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -286,6 +286,51 @@ static int mt7925_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7925_chip_reset, "%lld\n");
 
+static int
+mt7925_vefuse_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u16 size = dev->vefuse_cap.size;
+	int off = 0;
+	u8 *buf;
+	int ret = 0;
+
+	if (!dev->vefuse_cap.present || !size) {
+		seq_puts(s, "vefuse: no region in FW image\n");
+		return 0;
+	}
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mt792x_mutex_acquire(dev);
+	while (off < (int)size) {
+		u16 chunk = min_t(u16, 512, size - off);
+
+		ret = mt7925_mcu_read_vefuse(dev, off, chunk, buf + off);
+		if (ret)
+			break;
+		off += chunk;
+	}
+	mt792x_mutex_release(dev);
+
+	if (ret) {
+		seq_printf(s, "vefuse: read failed at 0x%04x (%d)\n", off, ret);
+		kfree(buf);
+		return 0;
+	}
+
+	seq_printf(s, "vefuse content: %u bytes\n", size);
+	for (off = 0; off < (int)size; off += 16)
+		seq_printf(s, "%04x: %*ph\n", off,
+			   (int)min_t(u16, 16, size - off), buf + off);
+
+	kfree(buf);
+
+	return 0;
+}
+
 int mt7925_init_debugfs(struct mt792x_dev *dev)
 {
 	struct dentry *dir;
@@ -309,6 +354,13 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 	debugfs_create_file("idle-timeout", 0600, dir, dev,
 			    &fops_pm_idle_timeout);
 	debugfs_create_file("chip_reset", 0600, dir, dev, &fops_reset);
+	/* only expose the vefuse read node when a vefuse region was found in the
+	 * FW image (FW reports the capability unconditionally, so gate on the
+	 * actual region presence instead)
+	 */
+	if (dev->vefuse_cap.present)
+		debugfs_create_devm_seqfile(dev->mt76.dev, "vefuse", dir,
+					    mt7925_vefuse_read);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "runtime_pm_stats", dir,
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a455..800d48bee110 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -871,6 +871,214 @@ static int mt7925_mcu_read_eeprom(struct mt792x_dev *dev, u32 offset, u8 *val)
 	return 0;
 }
 
+static int
+mt7925_mcu_send_vefuse_page(struct mt792x_dev *dev,
+			    const u8 *data, u32 total_len,
+			    int page_idx, int total_pages)
+{
+	struct mt7925_vefuse_page_cmd *cmd;
+	size_t offset = (size_t)page_idx * MT7925_VEFUSE_PAGE_SIZE;
+	u16 page_len = (u16)min_t(size_t,
+				  MT7925_VEFUSE_PAGE_SIZE,
+				  total_len - offset);
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->tag            = cpu_to_le16(UNI_EFUSE_BUFFER_MODE);
+	cmd->len            = cpu_to_le16(sizeof(*cmd) - sizeof(cmd->rsv));
+	cmd->source_mode    = UNI_EFUSE_SOURCE_VEFUSE;
+	cmd->content_format = FIELD_PREP(MT7925_VEFUSE_TOTAL_PAGE, total_pages) |
+			      FIELD_PREP(MT7925_VEFUSE_PAGE_INDEX, page_idx);
+	cmd->count          = cpu_to_le16(page_len);
+	memcpy(cmd->bin_content, data + offset, page_len);
+
+	ret = mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(EFUSE_CTRL),
+				cmd, sizeof(*cmd), true);
+	kfree(cmd);
+	return ret;
+}
+
+/* Read back vefuse content from FW (UNI EFUSE_CTRL query, BUFFER_RD tag).
+ * offset is the raw 0-based index into the FW vefuse buffer; source_mode
+ * selects the VEFUSE region. Exposed for the debugfs "vefuse" node.
+ */
+int mt7925_mcu_read_vefuse(struct mt792x_dev *dev, u16 offset, u16 count,
+			   u8 *out)
+{
+	struct {
+		u8 rsv[4];
+
+		__le16 tag;
+		__le16 len;
+
+		u8 source_mode;
+		u8 content_format;
+		__le16 offset;
+		__le16 count;
+		__le16 rsv1;
+	} __packed req = {
+		.tag = cpu_to_le16(UNI_EFUSE_BUFFER_RD),
+		.len = cpu_to_le16(sizeof(req) - sizeof(req.rsv)),
+		.source_mode = UNI_EFUSE_SOURCE_VEFUSE,
+		.offset = cpu_to_le16(offset),
+		.count = cpu_to_le16(count),
+	};
+	struct {
+		u8 rsv[4];
+
+		__le16 tag;
+		__le16 len;
+
+		u8 source_mode;
+		u8 content_format;
+		__le16 offset;
+		__le16 count;
+		u8 rsv1[2];
+		u8 data[];
+	} __packed * res;
+	struct sk_buff *skb;
+	int ret;
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_WM_UNI_CMD_QUERY(EFUSE_CTRL),
+					&req, sizeof(req), true, &skb);
+	if (ret)
+		return ret;
+
+	res = (void *)skb->data;
+	if (skb->len < sizeof(*res) + count) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	memcpy(out, res->data, count);
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
+static int
+mt7925_load_vefuse_from_fw(struct mt792x_dev *dev, const char *fw_name)
+{
+	const struct mt76_connac2_fw_trailer *hdr;
+	const struct mt76_connac2_fw_region *region;
+	struct mt76_dev *mdev = &dev->mt76;
+	const struct firmware *fw = NULL;
+	const u8 *vefuse_base = NULL;
+	u32 offset = 0, len = 0, payload;
+	int i, total_pages, ret = 0;
+
+	if (!dev->vefuse_cap.enabled)
+		return 0;
+
+	/* recomputed on every FW load; set true only once a vefuse region is
+	 * found in the image below (the debugfs node is gated on this).
+	 */
+	dev->vefuse_cap.present = false;
+
+	ret = request_firmware(&fw, fw_name, mdev->dev);
+	if (ret) {
+		dev_warn(mdev->dev,
+			 "vefuse: firmware %s not available (%d), skipping\n",
+			 fw_name, ret);
+		ret = 0;
+		goto out;
+	}
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+		dev_warn(mdev->dev, "vefuse: invalid firmware, skipping\n");
+		goto out;
+	}
+
+	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
+
+	/* Region descriptors sit right before the trailer. Make sure the whole
+	 * descriptor array is within the image before dereferencing them, so a
+	 * corrupt n_region cannot walk the region pointer before fw->data.
+	 */
+	if (fw->size < sizeof(*hdr) + (size_t)hdr->n_region * sizeof(*region)) {
+		dev_warn(mdev->dev,
+			 "vefuse: firmware too small for %u region descriptors, skipping\n",
+			 hdr->n_region);
+		goto out;
+	}
+
+	for (i = 0; i < hdr->n_region; i++) {
+		region = (const void *)((const u8 *)hdr -
+					(hdr->n_region - i) * sizeof(*region));
+		len = le32_to_cpu(region->len);
+
+		if (len > fw->size - offset) {
+			dev_warn(mdev->dev, "vefuse: invalid firmware region, skipping\n");
+			goto out;
+		}
+
+		if ((region->feature_set & FW_FEATURE_NON_DL) &&
+		    region->type == FW_TYPE_EXTEND_BIN_EFUSE) {
+			vefuse_base = fw->data + offset;
+			dev->vefuse_cap.present = true;
+			break;
+		}
+		offset += len;
+	}
+
+	if (!vefuse_base) {
+		dev_warn(mdev->dev,
+			 "FW_TYPE_EXTEND_BIN_EFUSE chunk not found in FW image, virtual efuse skipped\n");
+		/* vefuse_cap.present stays false -> debugfs node not exposed on a
+		 * WF without a virtual efuse. vefuse_cap.enabled (the FW-reported
+		 * capability) is left untouched.
+		 */
+		goto out;
+	}
+
+	/* The packed FW region carries the vefuse payload plus connac
+	 * per-region framing (4-byte CRC + 16-byte alignment), so region
+	 * length is larger than the FW-reported payload. Only the leading
+	 * vefuse_cap.size bytes are the actual vefuse content to push.
+	 */
+	payload = dev->vefuse_cap.size;
+
+	/* virtual efuse is an optional override: if it cannot be applied the
+	 * chip still works on its default efuse values, so the checks below
+	 * only warn and skip - they must not fail firmware bring-up.
+	 */
+
+	/* [Check #1] region must hold at least the FW-reported payload */
+	if (len < payload) {
+		dev_warn(mdev->dev,
+			 "vefuse: region size %u smaller than FW capability %u, skipping\n",
+			 len, payload);
+		goto out;
+	}
+
+	total_pages = DIV_ROUND_UP(payload, MT7925_VEFUSE_PAGE_SIZE);
+	if (total_pages > MT7925_VEFUSE_MAX_PAGES) {
+		dev_warn(mdev->dev,
+			 "vefuse: payload too large: %u bytes (%d pages), max %d pages supported, skipping\n",
+			 payload, total_pages, MT7925_VEFUSE_MAX_PAGES);
+		goto out;
+	}
+
+	for (i = 0; i < total_pages; i++) {
+		ret = mt7925_mcu_send_vefuse_page(dev, vefuse_base, payload,
+						  i, total_pages);
+		if (ret) {
+			dev_warn(mdev->dev,
+				 "vefuse page %d/%d send failed: %d, skipping\n",
+				 i + 1, total_pages, ret);
+			ret = 0;
+			goto out;
+		}
+	}
+
+out:
+	release_firmware(fw);
+	return ret;
+}
+
 static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
@@ -1126,6 +1334,17 @@ mt7925_mcu_get_nic_capability(struct mt792x_dev *dev)
 		case MT_NIC_CAP_EML_CAP:
 			mt7925_mcu_parse_eml_cap(dev, tlv->data);
 			break;
+		case MT_NIC_CAP_VEFUSE_INFO: {
+			struct mt7925_vefuse_cap *cap;
+
+			if (len < sizeof(*tlv) + sizeof(*cap))
+				break;
+
+			cap = (struct mt7925_vefuse_cap *)tlv->data;
+			dev->vefuse_cap.enabled   = cap->enabled;
+			dev->vefuse_cap.size      = le16_to_cpu(cap->size);
+			break;
+		}
 		default:
 			break;
 		}
@@ -1199,6 +1418,13 @@ int mt7925_run_firmware(struct mt792x_dev *dev)
 	if (err)
 		return err;
 
+	/* Virtual efuse is best-effort and currently never fails bring-up, but
+	 * keep the error propagation for a possible future fatal vefuse error.
+	 */
+	err = mt7925_load_vefuse_from_fw(dev, mt792x_ram_name(dev));
+	if (err)
+		return err;
+
 	err = mt7925_load_clc(dev, mt792x_ram_name(dev));
 	if (err)
 		return err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 11f9eac13ffc..a0eb30d2570d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -137,6 +137,41 @@ enum {
 	UNI_EFUSE_BUFFER_RD,
 };
 
+/* page size and content_format layout follow the FW buffer-mode ABI */
+#define MT7925_VEFUSE_PAGE_SIZE		1024	/* FW BUFFER_BIN_PAGE_SIZE (0x400) */
+#define MT7925_VEFUSE_MAX_PAGES		7	/* content_format page fields are 3-bit */
+
+#define MT7925_VEFUSE_TOTAL_PAGE	GENMASK(7, 5)	/* FW BUFFER_BIN_TOTAL_PAGE */
+#define MT7925_VEFUSE_PAGE_INDEX	GENMASK(4, 2)	/* FW BUFFER_BIN_PAGE_INDEX */
+
+/* buffer mode content source, aligns with FW BUFFER_SOURCE_MODE_INFO_* */
+enum {
+	UNI_EFUSE_SOURCE_EFUSE = 0,
+	UNI_EFUSE_SOURCE_EEPROM = 1,
+	UNI_EFUSE_SOURCE_VEFUSE = 2,
+};
+
+struct mt7925_vefuse_cap {
+	u8 version;
+	u8 enabled;
+	__le16 size;
+	__le32 hash_addr;
+} __packed;
+
+struct mt7925_vefuse_page_cmd {
+	u8 rsv[4];		/* UNI_CMD_EFUSE_CONTROL header before TLV */
+
+	__le16 tag;		/* UNI_EFUSE_BUFFER_MODE */
+	__le16 len;
+	u8 source_mode;		/* UNI_EFUSE_SOURCE_VEFUSE */
+	u8 content_format;	/* [7:5]=total_pages [4:2]=page_idx */
+	__le16 count;		/* valid bytes in this page */
+	u8 bin_content[MT7925_VEFUSE_PAGE_SIZE];
+} __packed;
+
+int mt7925_mcu_read_vefuse(struct mt792x_dev *dev, u16 offset, u16 count,
+			   u8 *out);
+
 enum {
 	UNI_CMD_ACCESS_REG_BASIC = 0x0,
 	UNI_CMD_ACCESS_RF_REG_BASIC,
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9efc251cb745..70a74e071b17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -342,6 +342,12 @@ struct mt792x_dev {
 	struct ieee80211_vif *nan_vif;
 	const struct ieee80211_iface_combination *iface_combinations;
 	int n_iface_combinations;
+
+	struct {
+		bool enabled;	/* FW reports vefuse capability (unconditional) */
+		bool present;	/* a vefuse region was found in the FW image */
+		u16 size;
+	} vefuse_cap;
 };
 
 static inline struct mt792x_bss_conf *
-- 
2.45.2

