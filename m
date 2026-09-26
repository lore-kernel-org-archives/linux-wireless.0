Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AFB35AC3F;
	Sat, 26 Sep 2026 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437759; cv=none; b=WPaid7Xqfh7vIWj8SInoUJNaucF0fmmS6vJp6U7gi7tK4CkTf8g+d7xQxAMtAlK68nXyx7GS/MtcDB5jDcVcnaYaIMuSUBHyubharFKLp4b9C+7Lr+r2w94cpYZR+PaGmyUwAZvRC91a4QJTRQT96MorSqrouwWccZuA1O9NsUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437759; c=relaxed/simple;
	bh=mEtwdYXdZ1hXA8PhwsrGJUGxMDgCcklWFRsfZD0U/cg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ecAFrlq6tIwkzx3G8Ft2EKN4x8F+i4jMtMNvfKWW6zzxGJZdh2IecgM8+NSJvvLgR3nRH90MW9PJZ75OH2uitntw4bdMBu9TK3yLuvnhtVd1bnZq+hbVTBq2+TCE63oCC6ddA3xxMKu7vB41z64Ss0SIOqaSSXAxYdmWiO4J5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Fc+EIc6V; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Fc+EIc6V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1C
	5Kknk8OPRgaUyHr2WrphfIU+P9gaNOQznFxQmRB1s=; b=Fc+EIc6Vf8Q9nSlorW
	eZz6dnw3ruhLBX4l3qJBtUhwQ7r3/nN+mL5RTkkwMl6zM01xq/kPUZKpJqa4M8cD
	0euaztFxRpKP41oU/veNJXX9pEkSGRhL/HnezSTqUNtF/J83MSrp/De/++jGp/3s
	gXU+vWhid7XJAumQT3iFAn2Rw=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F4pL6bdqlpIIBA--.11355S6;
	Sat, 26 Sep 2026 23:48:33 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
	Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Wen Gong <quic_wgong@quicinc.com>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 4/5] wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
Date: Sat, 26 Sep 2026 23:48:23 +0800
Message-Id: <20260926154824.75224-5-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3F4pL6bdqlpIIBA--.11355S6
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1xJr4fXw4kZw18JF1kZrb_yoW8tw4fpF
	4rur9FyFy7Cw45Xr4ktF48G3WrX3Z5Ga1kKrW3Ga4rGFn8XrnagFy8ta4Iyry5KFWfJF1Y
	krWUKry8Grs8taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pijQ6AUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzREXUWq36VH7ZAAA3g

ath12k_mac_tx_mgmt_pending_free() is passed as an idr_for_each()
callback and removes the current entry from txmgmt_idr. This can
invalidate the radix-tree iterator retained by idr_for_each().

Both callers destroy the IDR immediately after the walk, so removing
each entry in the callback is unnecessary. Split skb release from IDR
removal and let the callback release the supplied skb without updating
the IDR. The following idr_destroy() tears down the IDR itself.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf79d10..7695b21149d1 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9166,18 +9166,11 @@ static void ath12k_mgmt_over_wmi_tx_drop(struct ath12k *ar, struct sk_buff *skb)
 		wake_up(&ar->txmgmt_empty_waitq);
 }
 
-static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
+static void ath12k_mac_tx_mgmt_free_skb(struct ath12k *ar,
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
 	dma_unmap_single(ar->ab->dev, ATH12K_SKB_CB(msdu)->paddr, msdu->len,
 			 DMA_TO_DEVICE);
 
@@ -9187,11 +9180,23 @@ static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
 	ath12k_mgmt_over_wmi_tx_drop(ar, msdu);
 }
 
+static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
+{
+	struct sk_buff *msdu;
+
+	spin_lock_bh(&ar->txmgmt_idr_lock);
+	msdu = idr_remove(&ar->txmgmt_idr, buf_id);
+	spin_unlock_bh(&ar->txmgmt_idr_lock);
+
+	if (msdu)
+		ath12k_mac_tx_mgmt_free_skb(ar, msdu);
+}
+
 int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
 {
 	struct ath12k *ar = ctx;
 
-	ath12k_mac_tx_mgmt_free(ar, buf_id);
+	ath12k_mac_tx_mgmt_free_skb(ar, skb);
 
 	return 0;
 }
-- 
2.34.1

