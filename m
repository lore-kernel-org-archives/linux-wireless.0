Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=2qrbwfj4CAwA3Tgur5gera499qN+5XutG9Oyq94vqmunfs0NEmhyP+kSd2N6glRT4Fo+
	 rrQVs2Fyl+AzVfPjep67JdPISsDLJ5D3aEqBml029PDzMu3etg23FINmfiFeecDhW5HAU
	 kB8NEOdjHwyAhKe9gUwHuIJkFixpxUYs9We8qNZ+7wZjDo/GA6VaOD7PeSZGy3BdkWQa5
	 E/hIASPYkFhAjVtltR9ZeEsgIpz0R2sDUdKumclXsqlru/SUVc8tsCSurTikNI45xmQBD
	 e0pFAQrPso5VLOmSITDtDNpiKWCHH4BwgRhLCNGvUQ/x3GEQ7ISGOe072ZU6L8XG9MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=+jhv8/rTp4UvkjzdJMvn38hW1Gb1uR8cATnvLgA89dE=;
	b=yuYEpZKfXEtIRzfruC8imeR+n3wS4hXeUli41i5Hfh9mKusoayYB7FT+8BKfSgBZAkRV
	 nF5OV3eujGTHKcJT4OLNDkbHoJuqOzus2CC+WkslcEk56/DxkTxK/9inePTIeMck7SHWs
	 1DtsaF3wnbvlMsQl0MkHMoaHPqnkOJ5Gb9kESo/lLJrcj4Z2WSpFtM/31j2YN/46SH9Fv
	 WZ2mINYmFGwG8twJVX7ZD9WGtnaGa03kWRWwBq29KzmUoEK+xZFjN/6as/q+CwEruGLkZ
	 958b5eApprKqf9feT2Q75VxieMbFDsRL6ZhPl4MEUe1YICbAcwdHetfniAhkjeD7WLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mpm4fxb4;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6252606A324;
	Tue, 20 Oct 2026 02:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6252606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mpm4fxb4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=+j
	hv8/rTp4UvkjzdJMvn38hW1Gb1uR8cATnvLgA89dE=; b=mpm4fxb4Tk5sW8/z80
	jz/pj3mbDrnxQQeJd261MHATcgw0XoQp2eq+PA/xvqCUHEvrYH2OtkL/IPjMnBSD
	NAt/jwoeDO5uhmpq5h1HTYWzDOiLJzu3H6orkfzlINitUR8ECunN4kRcgzYPMleK
	D1Ix0uRHN9cSYn7TEoDl3UuOA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S9;
	Tue, 20 Oct 2026 10:45:56 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 07/11] wifi: mt76: mt7925: validate EEPROM response length
Date: Tue, 20 Oct 2026 10:45:39 +0800
Message-Id: <20261020024544.3101738-8-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S9
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr1rAr15ZryDKFy8Jr4Dtwb_yoWkXFg_ur
	1v9rn7Jr18Gw1UKr42yF1furZFy3ykZ3WkCrWrtrWSg3y7JrW7urZavrs5GrZF9ws2vFW5
	Cr9xJa45ZasxujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbW8BUUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQT+OWrW1eSC4QAA3g

The EEPROM reader indexes the response data array without checking that
the complete firmware event is present. A truncated response can cause
an out-of-bounds read.

Require the complete EEPROM event before indexing its data.

Fixes: f2027ef3f733 ("wifi: mt76: mt7925: load the appropriate CLC data based on hardware type")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index ce860e63a108..e5cacb12d367 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -887,6 +887,10 @@ static int mt7925_mcu_read_eeprom(struct mt792x_dev *dev, u32 offset, u8 *val)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (struct evt *)skb->data;
 	*val = res->data[offset % MT7925_EEPROM_BLOCK_SIZE];
-- 
2.34.1

