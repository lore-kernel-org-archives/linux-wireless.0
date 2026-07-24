Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04DF292B4B
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897300; cv=none; b=oKw2bfApX2+tNRj3Tlfm/WQwbE+RF1Z+gd+3lOU3gN1+p39NPbwj+EfKXu9CRdsjF5oqU3xFpj98qy01LfldhUURcY+nH4UBTpw64hXNSzSVrNhicTpE2g3ZdOCqiMFzid6VhNqZHKPjE6jUtwDSKlXEw44xTp7ftUULqce7ZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897300; c=relaxed/simple;
	bh=9GjB2/0ENZ9uq0oOK7h2SMZ9GkCNQeZwZnPO4Ckm2EA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXVhzWC7bwoOj+LPSxLYd2hdTIINEp0jvonp1bUmLMMWNsBTyz/M2vh94D8Wi2pISG2ndrwJxprWvtI/MQJxhIXUSrXbj7Nf3mjKHMcYqVAQdejswKJiO7DAdn1ICj5C9XcQd73LOSnJbp35k0rzCeEueI8s5HHGPi6TJq1g114=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=O8E7G0JX; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="O8E7G0JX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C4qoxNNqGJxeGdQ/+iZT4B2I8PitlJ2wZzo5aEmzvdk=; b=O8E7G0JXMRgakxB3K6l0ejbinC
	EQAN7fQfqlZWVmNzdKQwdoJd5Ov4ky1tlT2j/xdkF0/SyKR4mVbJX3+6Sp/JcgwsKIHglUMnpaICu
	Gwvhi6wEJS7ekI21jDw7eJWOna3bFLqbw9Sp0fUeNgmL/JzuhidEfsa813MKQs7frP4s=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK3-006LeO-2o
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 02/29] wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
Date: Fri, 24 Jul 2026 12:47:46 +0000
Message-ID: <20260724124813.3961474-2-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The response TLV loop advanced by tlv->len without a minimum, so a
theoretical firmware response containing a zero-length TLV could spin
forever, hanging the CPU during device probe.
The u32 payload was also read without bounds checking.
Reject a short fixed field, stop on a TLV whose length underruns the
header or overruns the skb.

Fixes: 5d33053be609 ("wifi: mt76: mt7996: add variants support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 01c9adbca68b..73ca92081ca0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4438,21 +4438,31 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
 		return ret;
 
 	/* fixed field */
+	if (skb->len < 4) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 	skb_pull(skb, 4);
 
 	buf = skb->data;
-	while (buf - skb->data < skb->len) {
+	while (buf - skb->data + sizeof(struct tlv) <= skb->len) {
 		struct tlv *tlv = (struct tlv *)buf;
+		u16 tlv_len = le16_to_cpu(tlv->len);
+
+		if (tlv_len < sizeof(*tlv) ||
+		    tlv_len > skb->len - (buf - skb->data))
+			break;
 
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_CHIP_CONFIG_EFUSE_VERSION:
-			*cap = le32_to_cpu(*(__le32 *)(buf + sizeof(*tlv)));
+			if (tlv_len >= sizeof(*tlv) + sizeof(__le32))
+				*cap = le32_to_cpu(*(__le32 *)(buf + sizeof(*tlv)));
 			break;
 		default:
 			break;
 		}
 
-		buf += le16_to_cpu(tlv->len);
+		buf += tlv_len;
 	}
 
 	dev_kfree_skb(skb);
-- 
2.53.0

