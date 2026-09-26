Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57031D5174;
	Sat, 26 Sep 2026 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437753; cv=none; b=MjbqyS5BDliTHQtZch05Zd6dWo3VdolG2UamXjC4I2usWjcX9O7B9tiRjD6WigyzYv75RWxMgHbqmg/+ix8PGb3cK0xznva8VKbxqLhPEgsEcZOouKudWqc4hTlHFmDAU36zUs6ugOyqI0PoQ3qiJuna917NyPNSH+1ZPrD0tfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437753; c=relaxed/simple;
	bh=yL5h8B0dJjr75+FKSb0mOPrT4y3NvFXDPUVrC23Sl1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qh3kLkX3QRP4/whIwR5Tt/+ahoGwLgZ7tRo8WP5lIoniqmg4GQTSvQQRyEmktEO+8OhT6WWyQyBv4Pzh7dAfJVvF+9Eor+2eugpvg50rqel+L+CiaOpbOAdb6UI7z6VpGUWhrnovL5aTRn3+X2LRTZGPI6aVG/zU3qgU9yswdpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=GeC5v3ku; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="GeC5v3ku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=WI
	Mo/C9HBVn2XTdqyHiurAejlgPCNjRxM5+52AVZcG4=; b=GeC5v3kuycr5vyxkf6
	qfjGRAq5zfaHTQYE9NmWs0IpWgbFm43pLRzhExoVUgoqzvANiW8RZ9RVFr17U46h
	/TXgCmlqpQh+1sMlEduVuGhGcH5JDb6byd5T5wHBDb+cfVLLLCPKm3G95xFhhheV
	Kv16ul8zAQ6Et+tI34Kz13jcQ=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F4pL6bdqlpIIBA--.11355S4;
	Sat, 26 Sep 2026 23:48:30 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Shashidhar Lakkavalli <slakkavalli@datto.com>,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
	Ganesh Sesetti <gseset@codeaurora.org>,
	Miles Hu <milehu@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/5] wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
Date: Sat, 26 Sep 2026 23:48:21 +0800
Message-Id: <20260926154824.75224-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926154824.75224-1-yaojiale02@163.com>
References: <20260926154824.75224-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F4pL6bdqlpIIBA--.11355S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJr4fXw4kZw18JF1kZrb_yoW8tw4DpF
	4rW3sFyFyUAr47Xr4vyF48J3WrX3Z5Gw4DKrWrK34rJF9FqFnavFy8Aa42yrW5KFW8XFy5
	ArWUKFy5GrWDtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pK0PTAUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8A8WUGq36U+7UwAA3q

ath11k_mac_tx_mgmt_pending_free() is passed as an idr_for_each()
callback and removes the current entry from txmgmt_idr. This can
invalidate the radix-tree iterator retained by idr_for_each().

Both callers destroy the IDR immediately after the walk, so removing
each entry in the callback is unnecessary. Split skb release from IDR
removal and let the callback release the supplied skb without updating
the IDR. The following idr_destroy() tears down the IDR itself.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ae91b57c8422..696f9dd65ad4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6146,18 +6146,11 @@ static void ath11k_mgmt_over_wmi_tx_drop(struct ath11k *ar, struct sk_buff *skb)
 		wake_up(&ar->txmgmt_empty_waitq);
 }
 
-static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
+static void ath11k_mac_tx_mgmt_free_skb(struct ath11k *ar,
+					struct sk_buff *msdu)
 {
-	struct sk_buff *msdu;
 	struct ieee80211_tx_info *info;
 
-	spin_lock_bh(&ar->txmgmt_idr_lock);
-	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
-	spin_unlock_bh(&ar->txmgmt_idr_lock);
-
-	if (!msdu)
-		return;
-
 	dma_unmap_single(ar->ab->dev, ATH11K_SKB_CB(msdu)->paddr, msdu->len,
 			 DMA_TO_DEVICE);
 
@@ -6167,11 +6160,23 @@ static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
 	ath11k_mgmt_over_wmi_tx_drop(ar, msdu);
 }
 
+static void ath11k_mac_tx_mgmt_free(struct ath11k *ar, int buf_id)
+{
+	struct sk_buff *msdu;
+
+	spin_lock_bh(&ar->txmgmt_idr_lock);
+	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
+	spin_unlock_bh(&ar->txmgmt_idr_lock);
+
+	if (msdu)
+		ath11k_mac_tx_mgmt_free_skb(ar, msdu);
+}
+
 int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
 {
 	struct ath11k *ar = ctx;
 
-	ath11k_mac_tx_mgmt_free(ar, buf_id);
+	ath11k_mac_tx_mgmt_free_skb(ar, skb);
 
 	return 0;
 }
-- 
2.34.1

