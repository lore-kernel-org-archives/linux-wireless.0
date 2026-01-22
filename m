Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0763E9592
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2026 10:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769078431; cv=none; b=MWJCVyq8QaiyfEK6CvSKUvY57K7vfd5yPtmoFyHR+iDtdjc/oVYLDwUdjRKrtEqVnP66mVAQ84e5ZY33on45dTgd5AazcUNBcHrsNNx8uVJOoZ05U7vvtLJfL1N4eWN17MyXAuJEnnl6FPzWqmK6qJ8e6RvEJ370GSw0Zp2CsMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769078431; c=relaxed/simple;
	bh=9Uszu60UHgFL+GPzuEEZEdDB9HFrySR5BS0wkxLs63g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XMU4oYVf/A8VzHmE0De5YpV8awKi57tS7wIrQyxnygxIWmkL24Yntn6twaD4GOffPbdKK6DJtAZpGXkkVgu3+qSF5XhDvKNXeCfZh9Su8U5g2rJNOyZwq76RbfAGpOGS86S+ZscwH1JbYnzmfs+6CtQJ80ctY4qOXFjfRqONRBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtxOgxEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtxOgxEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8EAC19423;
	Thu, 22 Jan 2026 10:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769078431;
	bh=9Uszu60UHgFL+GPzuEEZEdDB9HFrySR5BS0wkxLs63g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AtxOgxEf13UvH5JO17FbWc4vboV1YAnbMGV1p4lqLeU9KIGrTBdrYduBJiAwvg75P
	 qDwcbhQmECD2UXFbwllOzoTOR4TWkC3t3MewRHbXKaD+VHBIOQuWzQwtE15eNGab7H
	 dnG2UewapwjZKyzuBqBN4ObnMRiCbaGnenfufuBAHO9w1HHo587lbZR9ez/C+9lELM
	 yPQqYjTxwe2b7RlaLzjpX7KW/APHfj2asRZV6doJcJVPDiCd/XB+yRgi8bbwrTg91A
	 ywtAZu776/WDUysP5Res1L/+krEuWu+pKkb/g2AZLpWBVRE7x+3G2wRGQD23zT6qQ6
	 G6JMvRavpiDoA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu, 22 Jan 2026 11:39:54 +0100
Subject: [PATCH mt76 v2 10/17] wifi: mt76: mt7996: Integrate MT7990 init
 configuration for NPU
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260122-mt76-npu-eagle-offload-v2-10-2374614c0de6@kernel.org>
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

Add NPU integration in MT7996 init codebase for MT7990 chipset.
This is a preliminary patch to enable NPU offload for MT7996 (Eagle)
chipset.

Tested-by: Kang Yang <kang.yang@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 03c1ccb49ef02ebe9c2ae91db836593e680ee2c0..526a2cb298fd7f9dc8d0fcdd8de0e4071c07338f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -592,7 +592,7 @@ static void mt7996_mac_init_basic_rates(struct mt7996_dev *dev)
 void mt7996_mac_init(struct mt7996_dev *dev)
 {
 #define HIF_TXD_V2_1	0x21
-	int i;
+	int i, rx_path_type;
 
 	mt76_clear(dev, MT_MDP_DCR2, MT_MDP_DCR2_RX_TRANS_SHORT);
 
@@ -606,11 +606,16 @@ void mt7996_mac_init(struct mt7996_dev *dev)
 	}
 
 	/* rro module init */
-	if (dev->hif2)
+	if (dev->hif2) {
+		if (mt76_npu_device_active(&dev->mt76))
+			rx_path_type = is_mt7996(&dev->mt76) ? 6 : 8;
+		else
+			rx_path_type = is_mt7996(&dev->mt76) ? 2 : 7;
 		mt7996_mcu_set_rro(dev, UNI_RRO_SET_PLATFORM_TYPE,
-				   is_mt7996(&dev->mt76) ? 2 : 7);
-	else
+				   rx_path_type);
+	} else {
 		mt7996_mcu_set_rro(dev, UNI_RRO_SET_PLATFORM_TYPE, 0);
+	}
 
 	if (mt7996_has_hwrro(dev)) {
 		u16 timeout;

-- 
2.52.0

