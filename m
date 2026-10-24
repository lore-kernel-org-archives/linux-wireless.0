Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=gpiOAxHZoAoxez0mQI3xovTLBPJ/OWsJmnXbz/k2zgS/gcY7fhYVDeYdsqs7UZCbeid1
	 WZNJ09y49oNcdVkJAQ023gw3a0zdBetWGKg5aArJPE5fS0toB0NU2gHZCSyT4ZD0s77dv
	 YuvA4mAUmvmPfZk26Ga/QNxUdAg7x01nQQc68Nzchwic/mazlew9JrSEAuE4JS1OsFTnZ
	 JAEj1iCSMN3G5EN5ndwdQpq8Sa5JeE4l789kfnNPbc5QHm4Nmzktt19C4u4jvUx2nhysX
	 Er8EHC9zJqpnV0favJPTzYT1DJGL9D1guJjeJsaVMhXtSKpYTQxGgdpL1uDNEcJahAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mL9lPWl9X6vPSFweie7pCv5dPU/OBKofnHT0JLlGBRI=;
	b=1zkGQ9NwK0G4cB9ycIhii58AzBZGv+uQB3gcrcg9WkzJmiJZ+vYGJ0SoTGyU6ugY22em
	 ygU0iG7aBSoepQN6IDny01Df/Vg0iOAiRCWwyMYMMYWVlP/eGmc73raiS/9AfuaSc+30w
	 KcuiY2ENeFMoV7R2htNMSn3WLRhhxz2c1HLjfXvbD2yfEFHjpOyLeHx4FAm0P97r49ZI/
	 Idky0JEchshaTSblXMgZ3pxA1/Az43osleeFrQiajmhd8wL2CdbeyvPQCoD5SWcK8dHbK
	 57Zhzk3nhcE/3BE1IsfD2LQdergLpXA4j+8DlOvLHFPFxroQPIGCz7bG1bKqY8wrAXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=VGdwSWor;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF6B606A31E
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EF6B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=VGdwSWor
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mL9lPWl9X6vPSFweie7pCv5dPU/OBKofnHT0JLlGBRI=; b=VGdwSWorfa6hGHXjO4m4RxlP//
	wiqvdBf4+fjlqLASLr14VlMIHhHxpGetg1IQR7XZBsiji6Z0UI5M3KqPYZQZ6PnjRr8XraPabZWAn
	hJ6hh0yWB8CrgY7merpKpNnYVa2KhM36s+0KY+xya7Pvt9KovZpUTyaIofQSz2kX7Bw8=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2P-009vQq-28
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:33 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 04/11] wifi: mt76: mt7925: free the MCU event when linearising fails
Date: Sat, 24 Oct 2026 09:19:20 +0200
Message-ID: <20261024071927.2279668-4-nbd@nbd.name>
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

mt7925_mcu_rx_event() returns without freeing the skb when
skb_linearize() fails, which leaks the event.

Free it, like mt7921_mcu_rx_event() does.

While here, take the descriptor pointer only after linearising, since
skb_linearize() can reallocate the skb head.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d26b90ab5e60..2acb02add18f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -740,16 +740,15 @@ mt7925_mcu_uni_rx_unsolicited_event(struct mt792x_dev *dev,
 
 void mt7925_mcu_rx_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
-	struct mt7925_mcu_rxd *rxd = (struct mt7925_mcu_rxd *)skb->data;
+	struct mt7925_mcu_rxd *rxd;
 
-	if (skb_linearize(skb))
-		return;
-
-	if (skb->len < offsetofend(struct mt7925_mcu_rxd, ext_eid)) {
+	if (skb_linearize(skb) ||
+	    skb->len < offsetofend(struct mt7925_mcu_rxd, ext_eid)) {
 		dev_kfree_skb(skb);
 		return;
 	}
 
+	rxd = (struct mt7925_mcu_rxd *)skb->data;
 	if (rxd->option & MCU_UNI_CMD_UNSOLICITED_EVENT) {
 		mt7925_mcu_uni_rx_unsolicited_event(dev, skb);
 		return;
-- 
2.47.3

