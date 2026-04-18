Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7068C2C3248
	for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2026 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776535487; cv=none; b=VBFRds4ESxvTgJZNG5/gNbtqjTQXTDUxD7oyHqfsDtoMT0Xwv58hcONbf/UDo8Rq3sXM8WU8AuYVcPtjQoxh/0hHLWgIz4bgG6nd7vguqXzwbkqLZ9Ho2hlZX/MeVE+JVOMJ2LGiqsbeX+ZjFi1/XWHp/TwR/++L1TwwUQeqEtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776535487; c=relaxed/simple;
	bh=qwrArXkdKtSRP17F8YTE6Be+Z4mkpURZ8OCUdqmMrNw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=H9wBIP7YsIem8KXzas5eLPV9oF+5TdCo773FgRvKchNXsTSwr6WAwQ73M7DxnpbJdflvBNJh1fCpu+WvPMyHtcOazYWix1uEiBWc8uRM3ny04V206KafXiKRI2w9i5/fYU3kJ6Klbf/HAgwMFajXd/loDACnRlXNQfRz0RbzHac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPs/65VX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPs/65VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2F5C19424;
	Sat, 18 Apr 2026 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776535487;
	bh=qwrArXkdKtSRP17F8YTE6Be+Z4mkpURZ8OCUdqmMrNw=;
	h=From:Date:Subject:To:Cc:From;
	b=PPs/65VX7qqQVRib0R5OJoUhtdtF6UU/qIxhe9Gh3dvI/QiuHH1gHD5qH9YEHcx3v
	 90C4KOUYiWkCifeTJgx0eu7uDdrCn8omRwi+8eevtlMCdemrvUPDT5LNPI9+z//2s6
	 EkFPdyewqLZ7rx4NlLAuKg2sOezM1gNLVRKFzOi0zu5feVLULmDnJK4c6mBaqQwLZW
	 pb5yXhtW0osP/05lrJUc+hXzK3QOOY2kG1aeZ7s4bEYTixXkq3bUbWHt/CmNPFhmaU
	 VnXfiPT/B6ab9XIR6tjkb97Q7zMtKXvP0eSp12fHDx+IvBpvEV+8090eeKkFsnLsdl
	 c8NgjbllYUXZw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 18 Apr 2026 20:04:16 +0200
Subject: [PATCH wireless] wifi: mt76: mt7996: Fix NULL pointer dereference
 in mt7996_init_tx_queues()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260418-mt7996-dma-init-npu-fix-v1-1-6b8dcffbcb57@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MSQqAMAwAvyI5G6ilaOtXxEPRqAGt0riB+HeLx
 xmYeUAoMgnU2QORThZeQ4Iiz6CbfBgJuU8MWulSmcLislfOldgvHjnwjmE7cOAbq0FbozrjtLK
 Q6i1S0v+5gYsjzSQC7ft+jba15XMAAAA=
X-Change-ID: 20260418-mt7996-dma-init-npu-fix-7f2840c49208
To: Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>, 
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org
X-Mailer: b4 0.14.3

When MT76_NPU and CONFIG_NET_MEDIATEK_SOC_WED are enabled and
mt76 detects properly the Airoha NPU SoC, mt7996_init_tx_queues() will
dereference a NULL WED pointer.
Fix the issue by always passing the WED pointer from mt7996_dma_init().

Fixes: cd7951f242a7 ("wifi: mt76: mt7996: Integrate MT7990 dma configuration for NPU")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
index 8f5d297dafce..3d9353811a02 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
@@ -683,7 +683,7 @@ int mt7996_dma_init(struct mt7996_dev *dev)
 		ret = mt7996_init_tx_queues(&dev->phy, MT_TXQ_ID(0),
 					    MT7996_NPU_TX_RING_SIZE,
 					    MT_TXQ_RING_BASE(0) + hif1_ofs,
-					    NULL);
+					    wed);
 	else
 		ret = mt7996_init_tx_queues(&dev->phy,
 					    MT_TXQ_ID(dev->mphy.band_idx),

---
base-commit: 1f5ffc672165ff851063a5fd044b727ab2517ae3
change-id: 20260418-mt7996-dma-init-npu-fix-7f2840c49208

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

