Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464429;
	b=yOtCVmXz0LU8bqzRe2MZuhfB1KMauLbEGMUA11rq0vsYzPx1GQ5owqJ0tQEOjoNc/yeo
	 lmlMPc7agrJUzDWiwz1G72JBDCLpfrAYNHvG5cKUwbNLZAAWP+7V1EVN27MrF0Xs+fTeh
	 Y5WlwulVP9/KJaUZ0TYsah+IZa0+MIBKoykDglctLkrsqRjWoLBRd7w9pRyM1EDQFeWKO
	 iI49eTkSn28A7Ur2F/5C+/vUrvWNiQV0WQAn6yhlXdh48Di/wUAJFwMqWuN/lpXUI3RpD
	 Aich5JloHStX0eRX39P/tiy0OzJ7ikYMb8HPiAQQGQ7478gXHV5wG1BwonjC/eRFoHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464429;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=2A3uGIJMkHs6ITfKSp8oe4Vb62b28JTSZYQB9mlviYk=;
	b=jws6EIIc3TEO92U5DTs/RNb4EGJzGMB4toK6wiBSF5GGo4jR46WWKkQGhT7pukD40D6i
	 iyucAOac+EqQE0GoXVHVRKDHviF2XIogGocKVabqlXTxLuvNhwnCIUUTFb5dBn4onc0pQ
	 i6A41FAT/V9Fp1XZVPzleuPDsmxlmJnOvv7Ae0kOh36CuFKhdJIBmpEgXLJLHfPSaC48A
	 Wnx16s8hr/77q6HnRmo9HNDoaz3wpzErWXzTNmtOK1xK4FxSEAv6Csg0ImKlxTWXPnmXt
	 P/H26GsMhyp6mM8rkPZrh0ZqpqB567Bi3vhicR/07mOtGZLkKBq051sS4b84hpqtbZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=JhUQZ9PJ;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD6260A260C;
	Tue, 20 Oct 2026 02:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFD6260A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=JhUQZ9PJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2A
	3uGIJMkHs6ITfKSp8oe4Vb62b28JTSZYQB9mlviYk=; b=JhUQZ9PJebh/li4Ray
	b4EKQiPN2/5cRVWBBrSc31nJXTF+5Xw1WHfO6xrhKpYEu1HUlYTF8FKmcb5S4bBC
	jo0294juKjPd8PClVyVMtbH3w2E5GXGdwHR71C1RyF8la2APAasPBtwNcIRgRFFO
	QCbbHuJXWF82JPe03mpkuJSVw=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S6;
	Tue, 20 Oct 2026 10:45:52 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 04/11] wifi: mt76: mt7921: validate testmode query response
Date: Tue, 20 Oct 2026 10:45:36 +0800
Message-Id: <20261020024544.3101738-5-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S6
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr15Zry5ZF4DJFWrCr4UArb_yoWkJwc_ur
	nY9r9rXr18G3ZYyr47Cw43ur9IyaykAr18ZrW5t3y5uFW7tr9rCF97Zr97GrZFgrZxZFW7
	Crn8ta48ZanIvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8gzVUUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgH9OGrW1eGLjAAA3F

The testmode query reads both response parameters without checking that
the firmware returned a complete event. A truncated response can cause
out-of-bounds reads.

Reject responses shorter than the testmode event structure.

Fixes: bce844584799 ("mt76: mt7921: introduce testmode support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/testmode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
index e60ee992edf8..ce95b0db1428 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
@@ -98,6 +98,10 @@ mt7921_tm_query(struct mt792x_dev *dev, struct mt7921_tm_cmd *req,
 					&cmd, sizeof(cmd), true, &skb);
 	if (ret)
 		goto out;
+	if (skb->len < sizeof(*evt)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	evt = (struct mt7921_rftest_evt *)skb->data;
 	evt_resp->param0 = le32_to_cpu(evt->param0);
-- 
2.34.1

