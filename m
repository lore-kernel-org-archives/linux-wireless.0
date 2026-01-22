Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C30F3EFD26
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2026 10:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078410; cv=none; b=Y+KPHBVAnQHMdupxJtbHs5JnaBw50WFQl+tc0j9vFwAbQO0lLRiTPNKQ7OTevWb170m0HGT5i25qKSVAdgGXrsRqt6UXCETXQJ55BnHVUodSHFtEVweMtiEbuFjM/rUpUA2mcwM+bAEqfG6yUWS0GEes7L/Cy5E/4QL32+ww0rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078410; c=relaxed/simple;
	bh=HPK1to5A18w33KTKAfPrc3VJLcOPN/LuGnXNtI40+kU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Gi1EmqINis3LGNbk98AQs8Rhm7u7sage3xpBxRFl9p/FC7ScIpqlQ9x9ty9xx/LhyQfyB3dMttrkfD5LO+abHkuH2mCAoCzinfq1zJkARU/T0w5Tics494e782yV82kToSAJ6XahbkjUH+sMIRYKy/IKoRjoNIrEUekGxBzESR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2MTWGjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2MTWGjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4D2C19423;
	Thu, 22 Jan 2026 10:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769078405;
	bh=HPK1to5A18w33KTKAfPrc3VJLcOPN/LuGnXNtI40+kU=;
	h=From:Subject:Date:To:Cc:From;
	b=t2MTWGjt1rXCrXNfXVwVI/cq2BIa30GgCX/cBH7/dIx3MYP6pmGkFSjSFO6yDRz9U
	 3geMd6d9RZh7goUDZhjLkzeTdTnsPvesM05mW0mZequan8TG3uK9ZGNs5FbnCu/dRp
	 FY89jSf6lZAm4XlAgdLWPhf76kMYnkQSCO77NcI2CPaf1VNzjvF0ljt2ysJZww26++
	 dAmR98lIfCe32WZX3L5eZk4f2iOjIAq6lkApbnWYYk86NjVqhpebL66NYFSW5yqUwf
	 6dYtxoYexYsItOtYZ3d9EgAZQ7/TizJv273J+MlsknUyPbaKxCckWa0bSYcyfCPlmQ
	 pRYJ/T27EFDaw==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH mt76 v2 00/17] wifi: mt76: mt7996: support for MT7996 NPU
 offloading
Date: Thu, 22 Jan 2026 11:39:44 +0100
Message-Id: <20260122-mt76-npu-eagle-offload-v2-0-2374614c0de6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqEMAxA0atI1hOwQTriVYZZpDbVgLbSjiKId
 7fM8i3+v6BIVikwNBdkObRoihX0amCcOU6C6quBWrKtIcL197YYtx2Fp0UwhbAk9hic8a7rmc0
 oUOMtS9DzP/587/sB46HW12gAAAA=
X-Change-ID: 20260122-mt76-npu-eagle-offload-fb1db48aa1ce
To: Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>, 
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, Kang Yang <kang.yang@airoha.com>
X-Mailer: b4 0.14.2

Introduce support for NPU offloading in MT7996 (7990-Eagle) chipset.

---
Changes in v2:
- Rebase on top of mt76 tree
- Fix NPU reset procedure
- Link to v1: https://lore.kernel.org/linux-wireless/20251204-mt76-npu-eagle-offload-v1-0-7819c52c0893@kernel.org/

---
Lorenzo Bianconi (17):
      wifi: mt76: mt7996: Fix NPU stop procedure
      wifi: mt76: npu: Add missing rx_token_size initialization
      wifi: mt76: always enable RRO queues for non-MT7992 chipset
      wifi: mt76: mt7996: Fix BAND2 tx queues initialization when NPU is enabled
      wifi: mt76: mt7996: Fix wdma_idx for MT7996 device if NPU is enabled
      wifi: mt76: mt7996: Add mt7992_npu_txrx_offload_init routine
      wifi: mt76: mt7996: Rename mt7996_npu_rxd_init() in mt7992_npu_rxd_init()
      wifi: mt76: mt7996: Add NPU support for MT7990 chipset
      wifi: mt76: mt7996: Integrate NPU in RRO session management
      wifi: mt76: mt7996: Integrate MT7990 init configuration for NPU
      wifi: mt76: mt7996: Integrate MT7990 dma configuration for NPU
      wifi: mt76: mt7996: Add __mt7996_npu_hw_init routine
      wifi: mt76: mt7996: Move RRO dma start in a dedicated routine
      wifi: mt76: Do not reset idx for NPU tx queues during reset
      wifi: mt76: mt7996: Do not schedule RRO and TxFree queues during reset for NPU
      wifi: mt76: mt7996: Store DMA mapped buffer addresses in mt7996_npu_hw_init()
      wifi: mt76: Enable NPU support for MT7996 devices

 drivers/net/wireless/mediatek/mt76/dma.c           |  20 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  20 +
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    | 204 +++++----
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  49 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   4 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  13 +
 drivers/net/wireless/mediatek/mt76/mt7996/npu.c    | 457 +++++++++++++++++----
 drivers/net/wireless/mediatek/mt76/npu.c           |  37 +-
 10 files changed, 640 insertions(+), 189 deletions(-)
---
base-commit: 3bc60b741f6a2d51b6743fd0e5639beaffc39953
change-id: 20260122-mt76-npu-eagle-offload-fb1db48aa1ce

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

