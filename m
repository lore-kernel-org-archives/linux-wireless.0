Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311FC37F8AA
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897303; cv=none; b=mbd2nnbf4CzClQKFf/VDu26WUc1TE5Zqt341QJN4CKOwQlFwF7GWThQAPwAwPpTG19wUdLekuWPoHh42lXqRfORy6FYYAOunXeEwlHdDN97w10yw4V7RRYKSaXVhdluCzDOyRh/fkuf9C+QbobA+98PmPl3WRYJ+kaKnPpiw6CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897303; c=relaxed/simple;
	bh=Hpie3UupyxaFQf9wGoNbpvZFzOVu3SWDbBd1u2GAbgI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGJUGHUzhh2CwWxTNtYlScm7hsC/FwFKfoWCKzO803LGguBh4uoRvrYfV7XrLl4L5Zr6lKBOAA5wWJLRK2LZafX0ZzVO5rpJIkxmgwYu5GWCNuw0OdpeNht34pdPAvD3kGYX0FPLCv1LxTP2avxhL4cFG+5jqtbnlUe/srK/VFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=dqNWuV9F; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="dqNWuV9F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RlFNYn2Jq+461PnUZAFBdH2dr5d+bgiUS24YsA4V+yE=; b=dqNWuV9FrRJyyPx6TF4YW/Ol+e
	IH3d60WAMYlHlbqKoHLPHjDtQlTSTW9/PkTwKdto9Sf9Svw3+F7X7G+zaF/QfH67xk+ZpjgJuhGeL
	5gkDmSgBy44abISswKtES+32uBoz076wUnTOC9nMkan1LUSQN5A97GPGP08lL2tNHbMU=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK7-006LeO-03
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:19 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 20/29] wifi: mt76: fix queue reg access when building WED and NPU together
Date: Fri, 24 Jul 2026 12:48:04 +0000
Message-ID: <20260724124813.3961474-20-nbd@nbd.name>
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

Move the offload specific parts of Q_READ/Q_WRITE into
mt76_dma_handle_read/write, which return false to fall back to
readl/writel. The WED and NPU #ifdefs now live inside those helpers
instead of selecting between mutually exclusive macro definitions, so a
kernel with both enabled supports both at runtime.

Also fixes the NPU path dereferencing a hardcoded q instead of the macro
argument.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.h | 110 ++++++++++++-----------
 1 file changed, 57 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index a2cf82cfdaaa..7694764febe7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -5,6 +5,8 @@
 #ifndef __MT76_DMA_H
 #define __MT76_DMA_H
 
+#include <linux/regmap.h>
+
 #define DMA_DUMMY_DATA			((void *)~0)
 
 #define MT_RING_SIZE			0x10
@@ -46,73 +48,75 @@
 #define MT_FCE_INFO_LEN			4
 #define MT_RX_RXWI_LEN			32
 
+static inline bool
+mt76_dma_handle_read(struct mt76_queue *q, u32 offset, u32 *val)
+{
 #if IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED)
+	if (q->flags & MT_QFLAG_WED) {
+		*val = mtk_wed_device_reg_read(q->wed, q->wed_regs + offset);
+
+		return true;
+	}
+#endif
+#if IS_ENABLED(CONFIG_MT76_NPU)
+	if (q->flags & MT_QFLAG_NPU) {
+		struct airoha_npu *npu;
+
+		*val = 0;
+		rcu_read_lock();
+		npu = rcu_dereference(q->dev->mmio.npu);
+		if (npu)
+			regmap_read(npu->regmap, q->wed_regs + offset, val);
+		rcu_read_unlock();
+
+		return true;
+	}
+#endif
+
+	return false;
+}
+
+static inline bool
+mt76_dma_handle_write(struct mt76_queue *q, u32 offset, u32 val)
+{
+#if IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED)
+	if (q->flags & MT_QFLAG_WED) {
+		mtk_wed_device_reg_write(q->wed, q->wed_regs + offset, val);
+
+		return true;
+	}
+#endif
+#if IS_ENABLED(CONFIG_MT76_NPU)
+	if (q->flags & MT_QFLAG_NPU) {
+		struct airoha_npu *npu;
+
+		rcu_read_lock();
+		npu = rcu_dereference(q->dev->mmio.npu);
+		if (npu)
+			regmap_write(npu->regmap, q->wed_regs + offset, val);
+		rcu_read_unlock();
+
+		return true;
+	}
+#endif
+
+	return false;
+}
 
 #define Q_READ(_q, _field) ({						\
 	u32 _offset = offsetof(struct mt76_queue_regs, _field);		\
 	u32 _val;							\
-	if ((_q)->flags & MT_QFLAG_WED)					\
-		_val = mtk_wed_device_reg_read((_q)->wed,		\
-					       ((_q)->wed_regs +	\
-						_offset));		\
-	else								\
+	if (!mt76_dma_handle_read(_q, _offset, &_val))			\
 		_val = readl(&(_q)->regs->_field);			\
 	_val;								\
 })
 
 #define Q_WRITE(_q, _field, _val)	do {				\
 	u32 _offset = offsetof(struct mt76_queue_regs, _field);		\
-	if ((_q)->flags & MT_QFLAG_WED)					\
-		mtk_wed_device_reg_write((_q)->wed,			\
-					 ((_q)->wed_regs + _offset),	\
-					 _val);				\
-	else								\
+	if (!mt76_dma_handle_write(_q, _offset, _val))			\
 		writel(_val, &(_q)->regs->_field);			\
 } while (0)
 
-#elif IS_ENABLED(CONFIG_MT76_NPU)
-
-#define Q_READ(_q, _field) ({						\
-	u32 _offset = offsetof(struct mt76_queue_regs, _field);		\
-	u32 _val = 0;							\
-	if ((_q)->flags & MT_QFLAG_NPU) {				\
-		struct airoha_npu *npu;					\
-									\
-		rcu_read_lock();					\
-		npu = rcu_dereference(q->dev->mmio.npu);		\
-		if (npu)						\
-			regmap_read(npu->regmap,			\
-				    ((_q)->wed_regs + _offset), &_val);	\
-		rcu_read_unlock();					\
-	} else {							\
-		_val = readl(&(_q)->regs->_field);			\
-	}								\
-	_val;								\
-})
-
-#define Q_WRITE(_q, _field, _val)	do {				\
-	u32 _offset = offsetof(struct mt76_queue_regs, _field);		\
-	if ((_q)->flags & MT_QFLAG_NPU) {				\
-		struct airoha_npu *npu;					\
-									\
-		rcu_read_lock();					\
-		npu = rcu_dereference(q->dev->mmio.npu);		\
-		if (npu)						\
-			regmap_write(npu->regmap,			\
-				     ((_q)->wed_regs + _offset), _val);	\
-		rcu_read_unlock();					\
-	} else {							\
-		writel(_val, &(_q)->regs->_field);			\
-	}								\
-} while (0)
-
-#else
-
-#define Q_READ(_q, _field)		readl(&(_q)->regs->_field)
-#define Q_WRITE(_q, _field, _val)	writel(_val, &(_q)->regs->_field)
-
-#endif
-
 struct mt76_desc {
 	__le32 buf0;
 	__le32 ctrl;
-- 
2.53.0

