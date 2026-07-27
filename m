Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8198D41D137
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164691; cv=none; b=eosoDMDec6miRrOl8Tlfit3XZNlf3SJdEvUfdaEAaMQ/wrrMe6UbsOfZUNjKhsiSOjWsdNMNltl7fwasO4fOJKxkINzlbu3vaY2jOk20qnQtGRkvHcP5NzLlEE7ol6+k4+8CcVdRq58XXeMoNOof5aWUXuezmzcjvviU0cc0SJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164691; c=relaxed/simple;
	bh=bcCx1RfKPnPUXMLbHwZ5BlXO1P5gAPC4TsOZ8+hrvOs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqaAOAiH0EZrC3mwYDfNSVM/eDYGxUyuGS8rKph+Wz8j7+S3NRHxOkmLsC9KPtAJePWxmJ5zM333pb1ALTgef5PivZHmsJzkkMa+jOGX3k+kim0TGXJxOWWDt69dM2jmxGUQirRXCPt4pPla6FUwcyA3KVzar1sgVlq2UUMVw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=tsm0jW5L; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tsm0jW5L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X18bCdIiLtL03s3xj6AghB6QWzs3X67OsJrxxBWT0MM=; b=tsm0jW5LbOASikf5dWMoGeypEJ
	4jL1mToTue/pllCSkMS0Rg51Nx4fjhcC1UFT2VX+CTw2yJY+X2cXB3vF6G+uj2pa72asFwdZfesYp
	ueF8ZqNhOR+PNwxgw809Ozuq7y2CwjhZqKYslt+JpH3WJhrZYa0eDVjsFf151WH5taHs=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsk-008KN0-0Q
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 05/15] wifi: mt76: mt7996: fix reg addr remap when addr is 0
Date: Mon, 27 Jul 2026 15:04:24 +0000
Message-ID: <20260727150434.1778520-5-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

When addr is less than the hardcoded threshold in __mt7996_reg_addr,
it indicates that remapping is unnecessary.
Currently, the flow remaps address 0x0 to MT_HIF_REMAP_BASE_L2,
which is incorrect.
To address this, modify __mt7996_reg_addr to return INVALID_REG_ADDR
if the address is not below the hardcoded value or is not present in
the mt7996_reg_map array.
Additionally, update the remap condition to check if addr is equal to
INVALID_REG_ADDR.

Fixes: 3687854d3e7e ("wifi: mt76: mt7996: add locking for accessing mapped registers")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index de68e60a1e86..0d7521d06981 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -17,6 +17,8 @@
 static bool wed_enable;
 module_param(wed_enable, bool, 0644);
 
+#define INVALID_REG_ADDR	0xffffffff
+
 static const struct __base mt7996_reg_base[] = {
 	[WF_AGG_BASE]		= { { 0x820e2000, 0x820f2000, 0x830e2000 } },
 	[WF_ARB_BASE]		= { { 0x820e3000, 0x820f3000, 0x830e3000 } },
@@ -358,7 +360,7 @@ static u32 __mt7996_reg_addr(struct mt7996_dev *dev, u32 addr)
 		return dev->reg.map[i].mapped + ofs;
 	}
 
-	return 0;
+	return INVALID_REG_ADDR;
 }
 
 static u32 __mt7996_reg_remap_addr(struct mt7996_dev *dev, u32 addr)
@@ -390,7 +392,7 @@ void mt7996_memcpy_fromio(struct mt7996_dev *dev, void *buf, u32 offset,
 {
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	if (addr) {
+	if (addr != INVALID_REG_ADDR) {
 		memcpy_fromio(buf, dev->mt76.mmio.regs + addr, len);
 		return;
 	}
@@ -406,7 +408,7 @@ static u32 mt7996_rr(struct mt76_dev *mdev, u32 offset)
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset), val;
 
-	if (addr)
+	if (addr != INVALID_REG_ADDR)
 		return dev->bus_ops->rr(mdev, addr);
 
 	spin_lock_bh(&dev->reg_lock);
@@ -421,7 +423,7 @@ static void mt7996_wr(struct mt76_dev *mdev, u32 offset, u32 val)
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	if (addr) {
+	if (addr != INVALID_REG_ADDR) {
 		dev->bus_ops->wr(mdev, addr, val);
 		return;
 	}
@@ -436,7 +438,7 @@ static u32 mt7996_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
 	u32 addr = __mt7996_reg_addr(dev, offset);
 
-	if (addr)
+	if (addr != INVALID_REG_ADDR)
 		return dev->bus_ops->rmw(mdev, addr, mask, val);
 
 	spin_lock_bh(&dev->reg_lock);
-- 
2.53.0

