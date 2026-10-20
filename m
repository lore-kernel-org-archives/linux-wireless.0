Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464429;
	b=xLajVS4aK2nO+plm9ufsyyK+wnSncp20br8CaaGqiQh0pDiJ4BDt0T/qkYkwU2au4oD0
	 0kJ6DEEikIFgsGtNtP6Dtkh4vlLaRrjuKNqSgrzWtctZnBV1To82pzYNIe11oX+aKf78p
	 IedVfl2KDCHVoH12XHlqA/fOztcl8Kd8yakcDI2YdwTjtwx4DRtQfQfAoxBx6CEdLdEds
	 efBk1bVW4C5xmSxtm+75L++ywNTp8e8RdCVYMys/jd8r97bovNA6X6Q53tNCpMFpDPCgX
	 ud+4OGGKp4HtEA0RvChR0YRu5DbDYN0hk10LbTTEb7Ag5g6ocKDIMyqUZuYeH+7IxHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464429;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=rNTKqv6h3K/O8eqrjNbseAaayL6xDS0BmfNpiSU5B9c=;
	b=cQuB/s8/8U/DuKiO2NsXbpNBzeLLXwBtdI0zctjMLBxJKHJuybMPJvFqZHNYc9OXbh+K
	 3s6AU8bXe8upwAgp/NgFPbUFCLPy2CrQhEDKwbE96O7AYzxC9Rxt9VU7+n1qAXWLqodQC
	 cKu+mJC6u+d8XFe/UlGVraib9RnEYT+LdDvuvri583/UzLd2yCpEih7xRJopanKi8ovYw
	 tCdiP/2vhgaY6oh3enEQUe4U6JqTb+EIIpbmXztqausAuFw4gFSnEbXiLOvBunNvvWuD1
	 uVuEKB3Tgn9z6r9EL5jiw5cF/OUBouGqHYvM/imbxs10rqHJNDPrksQGoGimMAFcdPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="W2T3g/MP";
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361AB606A334;
	Tue, 20 Oct 2026 02:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 361AB606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=W2T3g/MP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rN
	TKqv6h3K/O8eqrjNbseAaayL6xDS0BmfNpiSU5B9c=; b=W2T3g/MPjsmCTo1wW9
	uT1Jec/l5kIUPEywG3xThrVOcLdcF4dmXo1jMMuv18FydzSmD6PeYZHk6Rk2oTzL
	AslAd+mz9Qea6MgO6YE/egVIrp+fyEr0RG+8GUpeTipUKbl496bESkU/IxTDV9wV
	As6/e5IGP3PRV1aRZpO9H+zEo=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3_9AW1tZqr10qBA--.44565S2;
	Tue, 20 Oct 2026 10:46:47 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Deren Wu <deren.wu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 11/11] wifi: mt76: mt792x: bound firmware release-info parsing
Date: Tue, 20 Oct 2026 10:46:44 +0800
Message-Id: <20261020024645.3130280-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_9AW1tZqr10qBA--.44565S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAryUtFy8KFWrur4furW3KFg_yoW5ur48pa
	y5Kay2yr43Jrn8Ww15Ar48Zan3Awn5Ka15CrZIk34Svrn3trn8uF409a40vrWayw4xtr1Y
	grsaqF1xZr1DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6mh7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRcLRWrW1heIhAAA3l

mt792x_get_offload_capability() derives region and release-info pointers
from firmware-provided counts and lengths without keeping them within
the firmware image. A malformed image can therefore cause out-of-bounds
reads while locating or walking the feature records.

Validate the region table, accumulated region lengths, release-info
range, each record, its padding, and the feature payload before reading
them.

Fixes: e8a264ccd2de ("wifi: mt76: mt7921: move init shared code in mt792x-lib module")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 44 ++++++++++++++++---
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 0ad33f74c228..feab3abcc1dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -862,9 +862,10 @@ mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
 	struct mt792x_realease_info *rel_info;
+	const u8 *data, *end, *fw_end;
 	const struct firmware *fw;
-	int ret, i, offset = 0;
-	const u8 *data, *end;
+	size_t offset = 0;
+	int ret, i;
 	u8 offload_caps = 0;
 
 	ret = request_firmware(&fw, fw_wm, dev);
@@ -872,41 +873,72 @@ mt792x_get_offload_capability(struct device *dev, const char *fw_wm)
 		return ret;
 
 	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
-		dev_err(dev, "Invalid firmware\n");
-		goto out;
+		goto invalid;
 	}
 
 	data = fw->data;
 	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
+	if (hdr->n_region > (fw->size - sizeof(*hdr)) /
+			    sizeof(struct mt76_connac2_fw_region))
+		goto invalid;
+
+	fw_end = (const u8 *)hdr -
+		 hdr->n_region * sizeof(struct mt76_connac2_fw_region);
 
 	for (i = 0; i < hdr->n_region; i++) {
 		const struct mt76_connac2_fw_region *region;
+		u32 region_len;
 
 		region = (const void *)((const u8 *)hdr -
 					(hdr->n_region - i) * sizeof(*region));
-		offset += le32_to_cpu(region->len);
+		region_len = le32_to_cpu(region->len);
+		if (region_len > fw_end - fw->data - offset)
+			goto invalid;
+
+		offset += region_len;
 	}
 
+	if (fw_end - fw->data - offset < 16 + sizeof(*rel_info))
+		goto invalid;
+
 	data += offset + 16;
 	rel_info = (struct mt792x_realease_info *)data;
 	data += sizeof(*rel_info);
+	if (le16_to_cpu(rel_info->len) > fw_end - data)
+		goto invalid;
+
 	end = data + le16_to_cpu(rel_info->len);
 
 	while (data < end) {
+		u16 len;
+
+		if (end - data < sizeof(*rel_info))
+			goto invalid;
+
 		rel_info = (struct mt792x_realease_info *)data;
 		data += sizeof(*rel_info);
+		len = le16_to_cpu(rel_info->len);
+		if (len > end - data || rel_info->pad_len > end - data - len)
+			goto invalid;
 
 		if (rel_info->tag == MT792x_FW_TAG_FEATURE) {
 			struct mt792x_fw_features *features;
 
+			if (len < sizeof(*features))
+				goto invalid;
+
 			features = (struct mt792x_fw_features *)data;
 			offload_caps = features->data;
 			break;
 		}
 
-		data += le16_to_cpu(rel_info->len) + rel_info->pad_len;
+		data += len + rel_info->pad_len;
 	}
 
+	goto out;
+
+invalid:
+	dev_err(dev, "Invalid firmware\n");
 out:
 	release_firmware(fw);
 
-- 
2.34.1

