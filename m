Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE46483823;
	Mon, 19 Oct 2026 10:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404684; cv=none; b=vD7p+QwcbP7clavdPC5coF/QE8//sgX+Q5pQZY1T4HVUB6jdLnPN7fE2QVBMUZMWyqc7Ltp+1mKP8vxMTklpR4BT0SLG7noavixNmxt9eQBxvVU2zmxjRfQIeAg+Fch0nTCmlrEwR74JOnrCUF9K96T3lfVkf9Nh46g6Ttx7RXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404684; c=relaxed/simple;
	bh=NEnjTZRjVutXJrjVRSLSlo87OcenfbYtYO0/b7iu8GM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JlvY8y8VZ7BLIKIU+mZBz7cR/TVKX/aFYdTXOq8p1LXYvHhwIusJm89VexZYsxY7KZyTSZm1i1XDBoqPj0xVDpuqrilVD6vwlwPmoZdG1K+l47mTj7NJQZmGGPUyxrRj2q8T57CSoGYTDm8arRy5qo0P7NVhZegnVO5ukD/e+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gJL0OpNc; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gJL0OpNc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2o
	S/RVUCv332oUW7rywSkFmlGKWorhtvaJVg65N7O3o=; b=gJL0OpNc92zGtVRgKk
	uvXuIi1Qsmm4ZkyANl4FrVz7EMk+vYK6EjZzfQ69pqAPNZOclIBsDZnrJiqZ2L2v
	hp/rrxb8aOTmcURAAlrmbcI7ZTTiTYcyq1cZ4Rp5o15wa6+ez/iFnkofuXG3PhRG
	z186hSrQ4gy8lXnBCLUPeeKGk=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3_8Wk7NVq1VPPBA--.45843S3;
	Mon, 19 Oct 2026 18:10:47 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 1/2] wifi: mt76: mt7996: clamp VHT/HE beamforming NSS
Date: Mon, 19 Oct 2026 18:10:41 +0800
Message-Id: <20261019101043.1922205-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019101043.1922205-1-yaojiale02@163.com>
References: <20261019101043.1922205-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_8Wk7NVq1VPPBA--.45843S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF1kAw1UXryxuF4Utw43ZFb_yoWfurgE9F
	navF1SqF48Kr10kr47Aa9xCrySyay8XrykG3y5t3ySga17A3y7uryFvryDJrsrCF17Zr1U
	GwnxXFyjkayYgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUUjg4PUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgd0rmrV7KcemgAA3j

A peer can advertise a VHT or HE MCS map with no supported
spatial streams.  In that case mt7996_mcu_get_sta_nss() decrements
zero and produces 255 for the beamforming configuration.

Return zero when the MCS map has no supported streams.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index cd7587ce5b8a..e6243dd33c31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -120,7 +120,7 @@ mt7996_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static void
-- 
2.34.1

