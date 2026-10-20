Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464611;
	b=F9OawZPerhqecO2iAdvMGUf4E8xA8X+Jxd4qCrGapR+70QsxAjfcsO2uR7YpvmDBuWyi
	 Orf2EYoH3sS4QpfACHPmU2jlwqy3wD3wUKoE6hNe2X9+Z7uAqG7Taji9w5Lt/m4NkeZQG
	 TRvrafZAdYD6P9RuUFY/ql/FYGBoXIU5tU4aq0Q3mz6ZUnWWcvxwPHYm4Mzy104PD7f0z
	 mQmMVp3QKpy00ki+HFh8/ti0QJuQYHNiUVEQ9a1+KnS3b5ojAWhxr6r+ZcJ0Em4TvzZs5
	 hGw5EztY6iQHyw8cJYQWjMbNt6YF/99I4GHZnoOIXVVRx+bmvzQ67bRyrJrK5MNcdXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464611;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=UVKQ7US5Q7o3zuAmWEtLYwco4w3ej7rQWppkYb72eK4=;
	b=cRl4Hd+3Z6xVzgXoeFPctRWfPFlyPZ1GWVZWm5KSAi0AGaSaVj19wwV62dG4PmbSB5Bt
	 ArKYCynJJy7TD6bljDQv4f3OzZMQnSf5WjtAbvwPylqrDYA31r3QGRwgheP1r3CAv37TD
	 cr137WwnOFVOo62wDPrmu6uFTO2fm9ris8IcJ2vwVToqdytXQ0Xu4lLzzBLbGRzVeymyn
	 b/JaHCqIKqfV9RTHB/fHPhDfQ2DqF2B0P5QvNBsHqLQ+TP/uZleBU5N/nFHrCbhN5qxwG
	 /MlifrNp6q3GsrbSlylkev/FpjfKuBwhSyluIdlkgx5LYmL2A2QzfaOTid12o+sZITA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dzEnfoVg;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505BA606A33A;
	Tue, 20 Oct 2026 02:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 505BA606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=dzEnfoVg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=UV
	KQ7US5Q7o3zuAmWEtLYwco4w3ej7rQWppkYb72eK4=; b=dzEnfoVgaQJ4jbNdGk
	0zoXGowT+i8lA0vEzI68KsvHKEu/q4oDswpdcepSzpsbrp4RKnsBLtGFfRMItCNs
	eOz0d+npciqMDCKnvl0yt/SDzp4i7VR06BzWc/FijmRYgn1kxD0eF6OXZBjcft43
	xWtEFSnwiM53Cc/f2Qvhkcl+8=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S9;
	Tue, 20 Oct 2026 10:49:45 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Money Wang <Money.Wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 7/7] wifi: mt76: mt7996: validate RF register response length
Date: Tue, 20 Oct 2026 10:49:33 +0800
Message-Id: <20261020024933.3205681-8-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020024933.3205681-1-yaojiale02@163.com>
References: <20261020024933.3205681-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S9
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry7KFWkKFyfJF45CFW5GFg_yoWDtFc_uw
	1vvFnxJr18Kw4UKr42kws3urWFyay8Zas7u39xt3yFgay7JFW7urZ3Zr15Gr9293Z7ZFyU
	Grn8Ja13Aa4a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbG-e7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wk4cmrW1smTwgAA3e

The RF register query reads a fixed firmware response without checking
its length. A truncated response can cause an out-of-bounds read.

Require the complete register response before accessing its value.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index d87851c5fc1d..c248055a2c94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -5379,6 +5379,10 @@ int mt7996_mcu_rf_regval(struct mt7996_dev *dev, u32 regidx, u32 *val, bool set)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (void *)skb->data;
 	*val = le32_to_cpu(res->data);
-- 
2.34.1

