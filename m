Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F904D2EF6;
	Fri, 25 Sep 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350127; cv=none; b=SRVLu9ciVrd64rqm2vAWGm2muar9FmcvDSWkYkwtuSvsnRvphOHtGQWJTlHtIcu2m+LIdKuWLnoNktBww7kSXvXHhSprQjDS9u1xcjOsMWBNACQw/i2+monTp65Z3Zcr/8TChvkA2ljaw4tGzZebo0kuvq5uZbTyi3vQ8w4g7xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350127; c=relaxed/simple;
	bh=9MWlM5r1pVdYDoOWFTC7iaAE1HEVPoZwtYDCTmoo8ng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o9dw1dlixOuOsHdc48idPiQHgKwKefpLJx2/sygpD0cSNIyl13Ky7ETPaf27BLPH1ZKIG+0dXEU7xhxEVAL+2LTiTixWaoZr/mbMVWdums7CToDVRIMq1jdwm5q2YKLSAmKjVRUqGhtvW03/98JNR5jxBiMK2k08k9ccSvgOqDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VdUTcKNV; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VdUTcKNV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=HX
	/yjkeGZhu54QuTdGe2SqLBuSkENDQfw+HyBnEMbZk=; b=VdUTcKNV8FUaX58nhD
	Etv3gN4SrbpUREKihrQWUTnmp8uEH3CwRDAArfGxvtvb1LCojDR30KT1QTC0rJWq
	3Pe4vAgDO0pcBLGEMqAfvM1hpMdALgZJrmK7WrX2QxawOp5+WKk/FexDPS709IEG
	RHIGjN9rt0BjmWCFh6TGBsOjg=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3H5cAk7Zq7VoPAw--.4331S2;
	Fri, 25 Sep 2026 23:28:01 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: mt76: mt76x02: validate RX padding before use
Date: Fri, 25 Sep 2026 23:27:54 +0800
Message-Id: <20260925152754.2323624-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H5cAk7Zq7VoPAw--.4331S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF17Gw47Gw1UJF1xZFWUArb_yoW8AFy8pF
	W5K342vr45Gr48uw18Aa1kCFWrGw1fKFy5KFySg3WrZa40krn8JFyF9FyFvryFyFsYk3WS
	kF1qvanxGFyDu3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRCJPAUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgEtZ2q2kwHW6gAA33

The RX descriptor provides L2 and PN padding lengths that are used to
locate the CCMP IV and determine how many bytes to remove from the packet.
These lengths are not checked against the received skb length before the
IV is read or mt76x02_remove_hdr_pad() is called.

Reject frames whose IV does not fit within the skb or whose header padding
would extend past the end of the skb.

Fixes: 30ce7f4456ae ("mt76: validate rx CCMP PN")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 21f8b1e64101..73a42cc4edae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -809,9 +809,13 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
 	if (pn_len) {
-		int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
-		u8 *data = skb->data + offset;
+		unsigned int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
+		u8 *data;
 
+		if (offset + 8 > skb->len)
+			return -EINVAL;
+
+		data = skb->data + offset;
 		status->iv[0] = data[7];
 		status->iv[1] = data[6];
 		status->iv[2] = data[5];
@@ -831,6 +835,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
+	if (pad_len + ieee80211_get_hdrlen_from_skb(skb) > skb->len)
+		return -EINVAL;
+
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
-- 
2.34.1

