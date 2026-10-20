Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=Aa2mSAWv72dYBTte3905CcktFBsqJT8g7eFFhaHI9rK27ZrWZKB7Q2XDW0hAUWldfeKG
	 cvanPuE24Cklp+VQBokyGuSa85JSU6a12a4r6o6ZU/oGkMXOO/YHqydMzuyTPXZGhM4F/
	 N3+q/GVg5BYKlHeKiGKbAnXwaE1vdjVj7OyqPaFBGJ0zpJNGw5yDcuvR/O8h3n5sJAlHj
	 fh7gdRFRoyTqm7OH5x7qTvlxu97JQL6EwSFa4aiqmAohLXIINrXhNDi04TGRDoPsKDgZk
	 0hlb72o1L7c0VD+OHCnLwdByINoNh5rAWEvJ0zMKiP0lXuYo9fAnOQQrLdM9r/FRULg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=lONQ58hOPHjFuw/A/dJum6aO3jorcmydyDZYCpMwFoY=;
	b=uMgEsMZ0RUDqonmp8atPdLwrQI06/N6QBMAynr18FNMExJgIMN5p+S8/grx+Z2MXYtzS
	 OvAbADRMDVEU/8Jxcv/8627WJxxxghoSnakpDhAoXNcrF/Z+QuiXvyPJoEex/ObpX2MCQ
	 beRj0iWaSKjmGA7y3OSWKVBYTnoE5CXfmYuPLcS4uhy9/f3XxZxvDJnbPgIobDZpdCGqj
	 Uwso5Bz0Jp8MsbfJTOP+RdFRQe3MDws3R2oeyTbfKravl3MI4r6en3RZC75i3FM8teNvy
	 SfiItBFwLS1ezravrYKwwdtjfuRcfMGx3QfbfbPAlm0VoveFVRJjd6A+ogVzkpZo40Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=WpQT42JF;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9E7606A329;
	Tue, 20 Oct 2026 02:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C9E7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=WpQT42JF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=lO
	NQ58hOPHjFuw/A/dJum6aO3jorcmydyDZYCpMwFoY=; b=WpQT42JFDdP0Q0WVwu
	X8rGGex3p875ozA4YialWoWK9MEyBB6WFkuR+/sAQRpVkXoow2RvxRCbCuVNXgXm
	697qOzAsPhEAcmI2Tn0EM6kQk8MLucZzk4xkXO828kM1WfZBmt6GVJu7R/7FA6cB
	ixub0cz+2aiCc2ehd7fI6MbXM=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S12;
	Tue, 20 Oct 2026 10:46:00 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Allan Wang <allan.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 10/11] wifi: mt76: mt7925: validate radio status response
Date: Tue, 20 Oct 2026 10:45:42 +0800
Message-Id: <20261020024544.3101738-11-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020024544.3101738-1-yaojiale02@163.com>
References: <20261020024544.3101738-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S12
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr15Jw45uF17KrW8Ar4fZrb_yoWkCFbE9r
	1v9r97Jr18Gw1DKr42kr47GFWqk3yv9a4rurWrtrWrX3y7JrW7urs7ZrnxWr929392vFs8
	Crs8JFyxuw13WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8gJ55UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzggAOmrW1eiMbgAA3f

The radio status query removes an outer TLV header and reads the status
event without checking the response length. A truncated firmware
response can cause an out-of-bounds read.

Require both the outer TLV header and complete status event before
pulling the skb.

Fixes: e54b870212c0 ("wifi: mt76: mt7925: add rfkill_poll for hardware rfkill")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index f37d2a8eafe6..0baef78148d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -4140,6 +4140,10 @@ int mt7925_mcu_wf_rf_pin_ctrl(struct mt792x_phy *phy)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(struct tlv) + sizeof(*status)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	skb_pull(skb, sizeof(struct tlv));
 	status = (struct mt7925_radio_status_event *)skb->data;
-- 
2.34.1

