Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=bLj3qpzWs0qUwToAcVynuRuGVbmFnS0AwZQX99RCVQRcqdgiCBJ6ZjVAYl6nsOcJ6IdT
	 yQfKeXpZQ3vxdQoqLmcMvh6QvNtTmjbP6DKdZtWXB5+1z99kOcnRA6VL5pej6k0MFGRh8
	 FepfQDbAFetfMINnokCW8a5X+FuPXEHL9p8jKxnzsEeEymbbJpWHj1O5uuvXv8KRJo+N3
	 F/w48dRFYhcwRE8ise8hN8ea7kfUFQbT32bar/jaO7xGgoXPvMCEyYli+04bwGwyxycr1
	 4HRVkQ1xt10o8nP/jh3FjY1YQ69TaL0NX/uYyeah1yQuw7zB3c6I/aCD2vEpqgYTcGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pkXInFUIrRgakF4cuaSiWowNe9Ik42vKhINwlmPaN4I=;
	b=abZZ4Z46uUbVmd031WfOtNGWhHUmVydLqlrJVG3rrivmyn4TMmBDhfogJcFpAAkXxmTB
	 zg063oGQMNddy6m1iUBt39LNlPpmbX5uOpdjcazD7gsz5l0ASSV/4e13QxVp1ZPPXmQJn
	 eRVT+g4wMQC9iE4eDQ5ZPp89dl6MRt2KrTouemcIjpOLUDxti9vm3fVQw7R6Ou7uJtBtt
	 rZ4Nz/TJf7R8a/KAKKRXBAScXJzP1zg/yZ0lfBYB6rCCri+lExJ+H//EXVNXLoeTc5Yjx
	 5CJR9cTN1EWHVOA7PUd7+QlZNPod/bjoVKlsFkue2evPh6me/X3r3TceaS9VLxTTUnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Og3LytKW;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20A6606A323
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F20A6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Og3LytKW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pkXInFUIrRgakF4cuaSiWowNe9Ik42vKhINwlmPaN4I=; b=Og3LytKWrubpmjZjOeK342u5Lj
	Mwe1YxZNyXpUqZMI9r+jifu0NWUNHGVGqaWkNpp4z3EuOCb3Nkj5xqy3s0hxVqALEuHn8OJfzVjuP
	Emu2/5UlqC5qek/t/NFH+wQJqeggsPX0Oh7VVZQrJG0YO5guuA46zYcbD8Ri5ilbwS1A=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2Q-009vQq-1e
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 09/11] wifi: mt76: connac: validate the ROM patch section table
Date: Sat, 24 Oct 2026 09:19:25 +0200
Message-ID: <20261024071927.2279668-9-nbd@nbd.name>
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

mt76_connac2_load_patch() only checks that the patch image holds the
header. The section table after the header, and the offset and length
of each section, come from the image and are not checked against its
size. A malformed image makes the driver read past the image and send
that data to the device.

Add mt76_connac2_patch_check(), which checks that the section table and
every section fit in the image, and reject an image that fails it.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 29 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 88cdc8083bae..ad53bb60d5cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -3305,6 +3305,33 @@ static u32 mt76_connac2_get_data_mode(struct mt76_dev *dev, u32 info)
 	return mode;
 }
 
+int mt76_connac2_patch_check(const struct firmware *fw)
+{
+	const struct mt76_connac2_patch_hdr *hdr;
+	const struct mt76_connac2_patch_sec *sec;
+	u32 i, n_region;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr))
+		return -EINVAL;
+
+	hdr = (const void *)fw->data;
+	n_region = be32_to_cpu(hdr->desc.n_region);
+	if (n_region > (fw->size - sizeof(*hdr)) / sizeof(*sec))
+		return -EINVAL;
+
+	sec = (const void *)(fw->data + sizeof(*hdr));
+	for (i = 0; i < n_region; i++) {
+		u32 offs = be32_to_cpu(sec[i].offs);
+		u32 len = be32_to_cpu(sec[i].info.len);
+
+		if (offs > fw->size || len > fw->size - offs)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_connac2_patch_check);
+
 int mt76_connac2_load_patch(struct mt76_dev *dev, const char *fw_name)
 {
 	int i, ret, sem, max_len = mt76_is_sdio(dev) ? 2048 : 4096;
@@ -3326,7 +3353,7 @@ int mt76_connac2_load_patch(struct mt76_dev *dev, const char *fw_name)
 	if (ret)
 		goto out;
 
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+	if (mt76_connac2_patch_check(fw)) {
 		dev_err(dev->dev, "Invalid firmware\n");
 		ret = -EINVAL;
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 755c83f95f27..88281733a3df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -2153,6 +2153,7 @@ int mt76_connac2_fw_check(const struct firmware *fw, size_t *data_len);
 int mt76_connac2_load_ram(struct mt76_dev *dev, const char *fw_wm,
 			  const char *fw_wa);
 int mt76_connac3_load_phy_ram(struct mt76_dev *dev, const char *fw_name);
+int mt76_connac2_patch_check(const struct firmware *fw);
 int mt76_connac2_load_patch(struct mt76_dev *dev, const char *fw_name);
 int mt76_connac3_load_cb_patch(struct mt76_dev *dev, const char *fw_name);
 int mt76_connac2_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
-- 
2.47.3

