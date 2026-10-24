Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=C20FetpEU1G5aqrF99DpGDBJJwHQm4NljBkKY37zSXUrUqt26uUQtZ/5vyjhepxRuXAm
	 x8/Ekyc4/X55ApXt4u20pSFFE6fnHesi3mEF+vXRjULe9X8Cig/PMN13q6fWjOWhx432D
	 pY24XmlkNUoaxOJoE0RRF029D9WFE1UVJ1xseSxofRgmezaRj6aLMlLTGAXk/6kWMEEj7
	 QhCdqAluAR1EQk4qMQNRaasiLlcXc8v9Qn9g5SABXACwoOCzF/jwchq7mhK3tsDPF8sEU
	 TaTuJ0QTQwQky69Vu6IJKhzdyr0LchOE9r08EDAfxLklWadDmA+AkX5WieJeihmSFaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jcTTTg5qiXG8zQ76XcS8yj97KEa+QDzRU4QnfgZWse0=;
	b=s/mTvAR8yQiJHC6tXGpPXFFw5xprdlo9qb0bmmIYh9/3y0TzqLkeNpmxj6BcoDR/J0uD
	 TyOLXa9OPeMMeOcfPjfvne+tO0pvAp706xPjyfCmGtzjQplaFVHRpX1LQM250ZqE8ATBO
	 KhEUtNA1L0SuPT6qGYWl/q1laGp5RqPVDA8zHZ6SoU5mc7G6qIhik8BhbiPfmEIMEXr06
	 3xBIjyzKoloLUx62PoxKE+O+FLiZr0FOZ6LNJ2FpQUv3e+eiq+saKH1K30Outnpe+IuJJ
	 GQUGUGuEw/E3ahQ+USd20ZJOt7ODGVxmatG3jwXpDvrMqyiXmXQuZNJQ83hOe3MJ2eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Ajta+4VR;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E661606A320
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E661606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Ajta+4VR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jcTTTg5qiXG8zQ76XcS8yj97KEa+QDzRU4QnfgZWse0=; b=Ajta+4VRMkdOTzHvFt8qdAj96F
	Xx0J7hOny2U/8a6k4AiQjtby9a/scOjyMdXJrubJGM3SbNnPFC+YQzyav8qaVONto6bYGDfCFH+ZT
	hegXCC/z8jeD3viOkjnU2Jk9FqE+RpbkmuK99C2+K0UHGY64d7SxJ9VUnaaEDC4FSMsE=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2P-009vQq-3D
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 06/11] wifi: mt76: connac: validate the RAM firmware region table
Date: Sat, 24 Oct 2026 09:19:22 +0200
Message-ID: <20261024071927.2279668-6-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024071927.2279668-1-nbd@nbd.name>
References: <20261024071927.2279668-1-nbd@nbd.name>
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

mt76_connac2_load_ram() and mt76_connac3_load_phy_ram() only check that
the firmware image holds the trailer. The region table in front of the
trailer and the region lengths come from the image and are not checked
against its size. A malformed image makes the driver read past the
image and send that data to the device.

Add mt76_connac2_fw_check(), which checks that the region table and the
sum of the region lengths fit in the image, and reject an image that
fails it.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Fixes: 4f8ded4d5f0e ("wifi: mt76: mt7925: add MT7928 FWDL support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 39 +++++++++++++++++--
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  3 ++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 9bdfff24b702..88cdc8083bae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -3042,6 +3042,39 @@ s8 mt76_connac_get_rate_power_limit(struct mt76_phy *phy,
 }
 EXPORT_SYMBOL_GPL(mt76_connac_get_rate_power_limit);
 
+int mt76_connac2_fw_check(const struct firmware *fw, size_t *data_len)
+{
+	const struct mt76_connac2_fw_region *region;
+	const struct mt76_connac2_fw_trailer *hdr;
+	size_t avail, len = 0;
+	int i;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr))
+		return -EINVAL;
+
+	hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
+	avail = fw->size - sizeof(*hdr);
+	if (hdr->n_region > avail / sizeof(*region))
+		return -EINVAL;
+
+	avail -= hdr->n_region * sizeof(*region);
+	region = (const void *)(fw->data + avail);
+	for (i = 0; i < hdr->n_region; i++) {
+		u32 region_len = le32_to_cpu(region[i].len);
+
+		if (region_len > avail - len)
+			return -EINVAL;
+
+		len += region_len;
+	}
+
+	if (data_len)
+		*data_len = len;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_connac2_fw_check);
+
 static int
 mt76_connac_mcu_send_ram_firmware(struct mt76_dev *dev,
 				  const struct mt76_connac2_fw_trailer *hdr,
@@ -3155,7 +3188,7 @@ int mt76_connac2_load_ram(struct mt76_dev *dev, const char *fw_wm,
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_fw_check(fw, NULL)) {
 		dev_err(dev->dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
@@ -3184,7 +3217,7 @@ int mt76_connac2_load_ram(struct mt76_dev *dev, const char *fw_wm,
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_fw_check(fw, NULL)) {
 		dev_err(dev->dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
@@ -3221,7 +3254,7 @@ int mt76_connac3_load_phy_ram(struct mt76_dev *dev, const char *fw_name)
 	if (ret)
 		return ret;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_fw_check(fw, NULL)) {
 		dev_err(dev->dev, "Invalid PHY firmware\n");
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 74e37d722710..755c83f95f27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -6,6 +6,8 @@
 
 #include "mt76_connac.h"
 
+struct firmware;
+
 #define FW_FEATURE_SET_ENCRYPT		BIT(0)
 #define FW_FEATURE_SET_KEY_IDX		GENMASK(2, 1)
 #define FW_FEATURE_ENCRY_MODE		BIT(4)
@@ -2147,6 +2149,7 @@ int mt76_connac_mcu_del_wtbl_all(struct mt76_dev *dev);
 int mt76_connac_mcu_rdd_cmd(struct mt76_dev *dev, int cmd, u8 index,
 			    u8 rx_sel, u8 val);
 int mt76_connac_mcu_sta_wed_update(struct mt76_dev *dev, struct sk_buff *skb);
+int mt76_connac2_fw_check(const struct firmware *fw, size_t *data_len);
 int mt76_connac2_load_ram(struct mt76_dev *dev, const char *fw_wm,
 			  const char *fw_wa);
 int mt76_connac3_load_phy_ram(struct mt76_dev *dev, const char *fw_name);
-- 
2.47.3

