Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5B13EFD26
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2026 10:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078411; cv=none; b=Pk+SNz59wM/qs11WOkL/3J6hkTGTyCQ3/0JPOhuyvmfgyzltUcuNvdD6ed0ILq+mhn7FR39Lukqbi0NJz13OxVbmv2i4YM2OgCAQMpMtqF6QfVXEp9Sdcft39kzOnPPB58cAtrj1BAK8DQpfTDPZd4Bc88eN6B/JmeVEoucK6Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078411; c=relaxed/simple;
	bh=LGlHfWU1mnmzGexsrx0OLfKC9d+s8LQ2kvnlG0BfKX0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KN419/OXH3mEt/At1YCxnZB7LzZkhtuItxxfxEo4F38aOtnA676njrCevO91Tqzes1hWibsgFbmyu0Sw+2uHSIdVI01G/25MsBIOxqJJTebCzArypYHpliIEUV7DXChbXdTrmnDFBYDz4d7IqWXOBwnJ9ZBqzzxlrbBlvueFOI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdQPLFdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdQPLFdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914C2C19424;
	Thu, 22 Jan 2026 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769078411;
	bh=LGlHfWU1mnmzGexsrx0OLfKC9d+s8LQ2kvnlG0BfKX0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RdQPLFdzgTfEPEcBLzZ+SJKzH3s5nUPysANWagPi79h8i9NAGzdi9Tczp90v65db/
	 fkfk0t0EWGN3IaZCdhWP4q7e4tRANYHUUMBXS61fUuZnllBQ/CzFzDt1OtkFXh60eG
	 D/GzJx1vUaF+tpRFGHr1vvRmuWh1t1wp2HDZ7OBIc6Aq++n6YaTygziPx8WYH5ASg4
	 zj/xnfzLEzhNNc9Bqt2F9k1pOQn4dcXVdWBUHsEi9TG4DYhsnuPSI9ZfFrSU6m94LX
	 X+LDFHQeoelAPCaMi0YzD44P6PZ4B9LlNcxc7zrAXkHhg1gl2bWNDxuZVBVtUlqxSk
	 of3frYbsvWMUQ==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 22 Jan 2026 11:39:46 +0100
Subject: [PATCH mt76 v2 02/17] wifi: mt76: npu: Add missing rx_token_size
 initialization
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260122-mt76-npu-eagle-offload-v2-2-2374614c0de6@kernel.org>
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

Add missing rx_token_size initialization for NPU offloading.

Fixes: 7fb554b1b623 ("wifi: mt76: Introduce the NPU generic layer")
Tested-by: Kang Yang <kang.yang@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/npu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/npu.c b/drivers/net/wireless/mediatek/mt76/npu.c
index ec36975f6dc946f5dbc5ab6029b0574fbc602615..9679237f739842bd44497e0b1022a868cb3a0d6c 100644
--- a/drivers/net/wireless/mediatek/mt76/npu.c
+++ b/drivers/net/wireless/mediatek/mt76/npu.c
@@ -457,6 +457,7 @@ int mt76_npu_init(struct mt76_dev *dev, phys_addr_t phy_addr, int type)
 	dev->mmio.npu_type = type;
 	/* NPU offloading requires HW-RRO for RX packet reordering. */
 	dev->hwrro_mode = MT76_HWRRO_V3_1;
+	dev->rx_token_size = 32768;
 
 	rcu_assign_pointer(dev->mmio.npu, npu);
 	rcu_assign_pointer(dev->mmio.ppe_dev, ppe_dev);

-- 
2.52.0

