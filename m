Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0F32931C0
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897300; cv=none; b=SzE7RbNzBzwDRdgp1c0IauaUlzzsjZ+eg8j4NXHc/BjsSey5VV+6vi/6z124dGIFSgp0Teb3KQDu22nwnMQLk4XFbcmj1bIXBijoVxKqHM5FH2qHPqF6/lx+qH9R3uT6uA5dUAOgukYZwHOkzmyYSBJqc61kvFXczWahBrrVH5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897300; c=relaxed/simple;
	bh=YnogvCwMhKBA8Zr1NyRsF8Y6k2YSbG0plY6pMC5ohZI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aV6g6wto9u1rDB/0BaWMnmeg+7e7z9G/qwE3JlH6pCPPpQMzpgJbsHJCXnRUB5LMa57cPAZ55U323Ol3cEm4rog975K9OIgfHZGfSIEKlxgtmYrXVZO+15GaYCSa5IpCP/Xx/aDNTaWLLFxsR1fBKa9KSbe6b8dsR9ykKqpssFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EM2Z0vMk; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EM2Z0vMk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FmXOTOUAawSTLqPB+msi7+2SvOYV0YR7gkkdIoLnXsc=; b=EM2Z0vMklMxNMILXooOzm5lamX
	/GMhxjdhLODa1VDLQlzc+boqjuj7/wKCYWnMrR5Pq3JaCQ+0OdYeRADB8j2K8uPZhyDd3y7pikznk
	zihcISloYEl4s28o6PTXroMLnOGnY/h3FFrlM0YeeJz5+wzgSVFIchVOyDsZIHCEPRYI=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK4-006LeO-07
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 03/29] wifi: mt76: fix out-of-bounds access in mmio copy helpers
Date: Fri, 24 Jul 2026 12:47:47 +0000
Message-ID: <20260724124813.3961474-3-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_mmio_write_copy() and mt76_mmio_read_copy() iterate up to
ALIGN(len, 4), so a length that is not a multiple of four reads past the
source buffer (write_copy) or writes past the destination (read_copy).
Copy the aligned body in the loop and handle the remaining tail through a
4-byte bounce buffer, keeping the register access width unchanged.

Fixes: 2df00805f7db ("wifi: mt76: mmio_*_copy fix byte order and alignment")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mmio.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 05d74cd7248e..73d47608bf42 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -35,9 +35,16 @@ static void mt76_mmio_write_copy(struct mt76_dev *dev, u32 offset,
 {
 	int i;
 
-	for (i = 0; i < ALIGN(len, 4); i += 4)
+	for (i = 0; i + 4 <= len; i += 4)
 		writel(get_unaligned_le32(data + i),
 		       dev->mmio.regs + offset + i);
+
+	if (i < len) {
+		u8 tmp[4] = {};
+
+		memcpy(tmp, data + i, len - i);
+		writel(get_unaligned_le32(tmp), dev->mmio.regs + offset + i);
+	}
 }
 
 static void mt76_mmio_read_copy(struct mt76_dev *dev, u32 offset,
@@ -45,9 +52,16 @@ static void mt76_mmio_read_copy(struct mt76_dev *dev, u32 offset,
 {
 	int i;
 
-	for (i = 0; i < ALIGN(len, 4); i += 4)
+	for (i = 0; i + 4 <= len; i += 4)
 		put_unaligned_le32(readl(dev->mmio.regs + offset + i),
 				   data + i);
+
+	if (i < len) {
+		u8 tmp[4];
+
+		put_unaligned_le32(readl(dev->mmio.regs + offset + i), tmp);
+		memcpy(data + i, tmp, len - i);
+	}
 }
 
 static int mt76_mmio_wr_rp(struct mt76_dev *dev, u32 base,
-- 
2.53.0

