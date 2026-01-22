Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A823F23A5
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2026 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078449; cv=none; b=FnbBcfpeoKuLjKn7qJgcITDDDhoO0yYM5kWOIF7lzLDerupWO0zu1aqkOPuoM1n7NKK0Uv2pSHOcbNTiekwcAireg7T60zVuANgFhxrKTNS4OTJqeHxNX0h2FPCGyEGkqQWI+UxorUOBxN4qFpcC/2nKs0A6rFo7TnpLJ2NbGdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078449; c=relaxed/simple;
	bh=MywH8r2SZSBalpNJ9OdEdz5o7Oc0QkcvnF7g3fOHIaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGpmUeyoUbGwT50xqFa3F8Y/XAlqpZmQa+G87J1m+7+jxMjDRZJwIuRs6zdskXh1MUwsgUaMgnvlZEBus0r4ass9SBHbmx61IiQanfeb9DW3eBNTrASz3nKPHLcXm/ZpH92Cug6ygCdOzETKHQ9xQ+5qVc+Bi1zQDbnhwUVQuLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TC8ohXA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TC8ohXA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9738AC19425;
	Thu, 22 Jan 2026 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769078449;
	bh=MywH8r2SZSBalpNJ9OdEdz5o7Oc0QkcvnF7g3fOHIaw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TC8ohXA6IiBnc/nKJg7Pm0o2ptWQhR6DVq0InMjbU4HQhDSmVv8HoC1xHh880V8xO
	 CiUNZoExm2UWkrdIat0/58ghctnxtKE/8A43ruqGPNdLHAWk5ZVv8mbxtpy93BwD9f
	 zOQNM/fEUl7PPsXTKtl4LwJxPrRVzAyn+rWHsio1S2s1FS7/SZid8H7d5qOVN04olR
	 0nXg2ME7CpTz5RBP/nPOa/q0/gr2dEFr/ogkkyVQJQ1sPhbbkC7SYj533vE9OHWm08
	 AXxokDpQ+iIt6WjRDibvbJOfuOaA4g/sXnVvbTlzeTP1wvbkcy9kB6Ckm/7fYtxKlK
	 40pRPifW56/9Q==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 22 Jan 2026 11:40:01 +0100
Subject: [PATCH mt76 v2 17/17] wifi: mt76: Enable NPU support for MT7996
 devices
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260122-mt76-npu-eagle-offload-v2-17-2374614c0de6@kernel.org>
References: <20260122-mt76-npu-eagle-offload-v2-0-2374614c0de6@kernel.org>
In-Reply-To: <20260122-mt76-npu-eagle-offload-v2-0-2374614c0de6@kernel.org>
To: Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>, 
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, Kang Yang <kang.yang@airoha.com>
X-Mailer: b4 0.14.2

Enable NPU offloading for MT7990 chipset.

Tested-by: Kang Yang <kang.yang@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/npu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/npu.c b/drivers/net/wireless/mediatek/mt76/npu.c
index bc8f2012be9dbe2c7fc1fc885b6135d796d8c0d6..c4c7c0af63217a7e85b2d97b37febba16899e332 100644
--- a/drivers/net/wireless/mediatek/mt76/npu.c
+++ b/drivers/net/wireless/mediatek/mt76/npu.c
@@ -450,10 +450,6 @@ int mt76_npu_init(struct mt76_dev *dev, phys_addr_t phy_addr, int type)
 	struct airoha_npu *npu;
 	int err = 0;
 
-	/* NPU offloading is only supported by MT7992 */
-	if (!is_mt7992(dev))
-		return 0;
-
 	mutex_lock(&dev->mutex);
 
 	npu = airoha_npu_get(dev->dev);
@@ -486,7 +482,7 @@ int mt76_npu_init(struct mt76_dev *dev, phys_addr_t phy_addr, int type)
 	dev->mmio.phy_addr = phy_addr;
 	dev->mmio.npu_type = type;
 	/* NPU offloading requires HW-RRO for RX packet reordering. */
-	dev->hwrro_mode = MT76_HWRRO_V3_1;
+	dev->hwrro_mode = is_mt7996(dev) ? MT76_HWRRO_V3 : MT76_HWRRO_V3_1;
 	dev->rx_token_size = 32768;
 
 	rcu_assign_pointer(dev->mmio.npu, npu);

-- 
2.52.0

