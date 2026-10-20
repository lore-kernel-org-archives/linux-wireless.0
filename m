Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464619;
	b=iDlYOoy5Oe2FsrbTvezUMLzObr06xbiSeJApFNtUCtL1QUw2GViEo0zxfYH0zQhB4FMe
	 SUoCJ386PM8RfhkTaLKOfmASfERCj0folphBXuv10vZPMRlWmHXP6+wVY+hR+FB9u++a3
	 dGdFxn3pz0oeIDqYOLd39ELee+53XTcZKUeu06cEVg1fBDCLakPYRmWCRDUsisYY54eU7
	 D8kwodfs6ufF/v+Oq0OqNlrjAlMF/vSGo62u5P0Mp97w+ra442lUrTSRdpizh4FDV3aAw
	 6q3G99fEjZuuTNPV4b16ejtwHL14PuyJ9aG/OoRtC/rgOUqf8WW+1SkXZ6JchgVn4bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464619;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=OCB8hkaX/991fKg2XUmzqmfAjRKigtw03tT5mIJiQnQ=;
	b=jgGrvDyBKCGkwaV+n+OIAmT5Tx44uSBD9kUHNroeVgPOVPZ6/qIR3JWVJvWbZ83ZFTEu
	 SgZov582a+r0xrhvI4ByliQ7yRD8gRXZBA9Pibd9frnrtctOGu8w0Cnf9zu7MbY1FpLIQ
	 B2Wvm+bc5i6AoUJb0+qZLPreCjfTpedwqsw/mVzDBTfA0SWihYFReGBntpajNBKnU4ALF
	 r6vQKT6gE7zQerDDWlrUSLQxg92lCn7BF5+O6VM82UAQuNOotKqEYIFXKEl2pe/rnQZSV
	 Lgks+rzW9spCDiVgK7aSqGjNE9Hk6V5wiKLAGe3wk0z/7YLVJVFF30vVrUOcv7x7m1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=oabHzIZ9;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D2D60A380C;
	Tue, 20 Oct 2026 02:50:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58D2D60A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=oabHzIZ9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=OC
	B8hkaX/991fKg2XUmzqmfAjRKigtw03tT5mIJiQnQ=; b=oabHzIZ9tkhQBqAxXC
	04GFdRwV0p+ieq6GUsNB2pg7F10/JH5MeEEQAmup0kxDuHPq1onu4XcUinLmEbmW
	gOTiyTj+69nBNxI11WQmxpC0gNEzxdvAarqC/qY5yMtjenze1pPsBMl2SGifAT7Y
	qRNvYFznROVsQ2fkHPkdxlbNU=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S7;
	Tue, 20 Oct 2026 10:49:43 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Money Wang <Money.Wang@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 5/7] wifi: mt76: mt7996: validate channel MIB response length
Date: Tue, 20 Oct 2026 10:49:31 +0800
Message-Id: <20261020024933.3205681-6-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S7
X-Coremail-Antispam: 1Uf129KBjvdXoW7XrWrGFyrCr1fGFWkCw13CFg_yoWkXFgE9r
	1vvFn3tr18K390vr47CwsruryFy3y8CF95urW3t3yrXay7J347urZavFnxGrZFk3Z7ZF4U
	Grs8AayUA3y3WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbG-e7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wc3cWrW1seTbAAA38

The channel survey query removes a fixed response header and reads four
MIB entries without checking that they are present. A truncated
firmware response can cause out-of-bounds reads.

Require the header and complete MIB array before pulling the skb.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index c70d7ad3148c..5391666553d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4627,6 +4627,10 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(req.hdr) + IDX_NUM * sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	skb_pull(skb, sizeof(req.hdr));
 
-- 
2.34.1

