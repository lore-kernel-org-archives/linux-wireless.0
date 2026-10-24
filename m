Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=IIzbanKgfHq2VqFb9Ac86S3bXQplppB3KqPCbC5oME9RYCTBj28GHJpVFnCAMibeZrKO
	 spzBMYlfw6k93tYp+WHmd3jANLOG0cYHzpMHBPq1bhIPH9QJIV15Xy5XY6huj7wWPpOxt
	 yIf7m8Xfc518G2sgxoVm/urn9WLpjUiwlVo3HHv7Er0VuRoBokwmS2hiuMU19HNzruSbN
	 Z9e7uOq0q5RQP0q565yjN16sLVbfk3i+vxYkkQm1wKmVoFn8l55Wrm3XN1FJGidfBUvsY
	 Nf5RUAQW3xVZwX0AxYpcD1uC+YFsfgs1Ef9vFngxeLUXdMlPpp4ADo323B92kRUIVZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zVGR1cy7f+gmFHGFw8GYKzVgRuZg4fD6KA+seBBf0hM=;
	b=ulvX3TMKusWpz4If5+Acymt6FRvvrCwINvCadbUgaocD53TmFhC3kEFYQBf1t/NQG5nm
	 zkCGqWMMLzhlmOVsyFSF5O4NAG95kPDXOlztPlEjtwdCZoVofkMpZjjy9pLFxWiQOgLSd
	 42VL3mCCfZeZntN6HA0ktj3oWwBhpP7jw4ffoTF47GrG2tgckl+w0nfOPIVuc6hG0ialO
	 oyZgibqwtVGApGpuCuRaSvyxrygnicMNUWAlaBd5kNyYiP0ipi/+bG0rwnUGGDOvjwzMh
	 cHsI7074jj8pvQKdI5cQK5gR9QGjcpPU/VdxBGdfXJySsLmDudqmlqhT2s4To3X+8HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=BBdvRCSQ;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED46606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ED46606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=BBdvRCSQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zVGR1cy7f+gmFHGFw8GYKzVgRuZg4fD6KA+seBBf0hM=; b=BBdvRCSQeeTYa2YdzCYLOJX8rI
	jjk+cDZR4zpZJF3oGik3t7nr1c6aaQ7j4518/uHDOpqXENNDpG4okiwsiZpTHiylMv/ICIurB/F5A
	K8QwhOWigkf0/hPZ89YS6bjiQmReKxHC12uPsZSGthKvxyAIy7nZYGRdOR0JClj+HmAI=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2P-009vQq-1Z
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:33 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 03/11] wifi: mt76: mt7925: validate NIC capability TLV lengths
Date: Sat, 24 Oct 2026 09:19:19 +0200
Message-ID: <20261024071927.2279668-3-nbd@nbd.name>
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

mt7925_mcu_get_nic_capability() checks that each TLV fits in the
response, but not that the TLV is long enough for its own header or for
the fields read from it. A short chip capability TLV at the end of the
response causes an out-of-bounds read of its eight-byte value. A TLV
length below the header size makes the loop parse overlapping TLVs.

Stop at a TLV shorter than its header, and skip a TLV that is too short
for the fields its parser reads, like mt7921 does.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 29 +++++++++++++------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index f299a3379adb..d26b90ab5e60 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1058,7 +1058,7 @@ int mt7925_mcu_get_temperature(struct mt792x_phy *phy)
 }
 
 static void
-mt7925_mcu_parse_phy_cap(struct mt792x_dev *dev, char *data)
+mt7925_mcu_parse_phy_cap(struct mt792x_dev *dev, char *data, int len)
 {
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt76_dev *mdev = mphy->dev;
@@ -1082,6 +1082,9 @@ mt7925_mcu_parse_phy_cap(struct mt792x_dev *dev, char *data)
 		WF0_5G
 	};
 
+	if (len < offsetofend(struct mt7925_mcu_phy_cap, hw_path))
+		return;
+
 	cap = (struct mt7925_mcu_phy_cap *)data;
 
 	mdev->phy.antenna_mask = BIT(cap->nss) - 1;
@@ -1091,7 +1094,7 @@ mt7925_mcu_parse_phy_cap(struct mt792x_dev *dev, char *data)
 }
 
 static void
-mt7925_mcu_parse_eml_cap(struct mt792x_dev *dev, char *data)
+mt7925_mcu_parse_eml_cap(struct mt792x_dev *dev, char *data, int len)
 {
 	struct mt7925_mcu_eml_cap {
 		u8 rsv[4];
@@ -1099,6 +1102,9 @@ mt7925_mcu_parse_eml_cap(struct mt792x_dev *dev, char *data)
 		u8 rsv2[6];
 	} __packed * cap;
 
+	if (len < offsetofend(struct mt7925_mcu_eml_cap, eml_cap))
+		return;
+
 	cap = (struct mt7925_mcu_eml_cap *)data;
 
 	dev->phy.eml_cap = le16_to_cpu(cap->eml_cap);
@@ -1139,30 +1145,35 @@ mt7925_mcu_get_nic_capability(struct mt792x_dev *dev)
 
 	for (i = 0; i < le16_to_cpu(hdr->n_element); i++) {
 		struct tlv *tlv = (struct tlv *)skb->data;
-		int len;
+		int len, data_len;
 
 		if (skb->len < sizeof(*tlv))
 			break;
 
 		len = le16_to_cpu(tlv->len);
-		if (skb->len < len)
+		if (len < sizeof(*tlv) || skb->len < len)
 			break;
 
+		data_len = len - sizeof(*tlv);
 		switch (le16_to_cpu(tlv->tag)) {
 		case MT_NIC_CAP_6G:
-			mphy->cap.has_6ghz = !!tlv->data[0];
+			if (data_len)
+				mphy->cap.has_6ghz = !!tlv->data[0];
 			break;
 		case MT_NIC_CAP_MAC_ADDR:
-			memcpy(mphy->macaddr, (void *)tlv->data, ETH_ALEN);
+			if (data_len >= ETH_ALEN)
+				memcpy(mphy->macaddr, (void *)tlv->data, ETH_ALEN);
 			break;
 		case MT_NIC_CAP_PHY:
-			mt7925_mcu_parse_phy_cap(dev, tlv->data);
+			mt7925_mcu_parse_phy_cap(dev, tlv->data, data_len);
 			break;
 		case MT_NIC_CAP_CHIP_CAP:
-			dev->phy.chip_cap = le64_to_cpu(*(__le64 *)tlv->data);
+			if (data_len >= sizeof(__le64))
+				dev->phy.chip_cap =
+					le64_to_cpu(*(__le64 *)tlv->data);
 			break;
 		case MT_NIC_CAP_EML_CAP:
-			mt7925_mcu_parse_eml_cap(dev, tlv->data);
+			mt7925_mcu_parse_eml_cap(dev, tlv->data, data_len);
 			break;
 		default:
 			break;
-- 
2.47.3

