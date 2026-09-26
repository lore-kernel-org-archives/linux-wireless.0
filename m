Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAFA26461F;
	Sat, 26 Sep 2026 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437759; cv=none; b=GzFKQLyFEDPRCADWk1ZpLVT0XJsvmrFYIwX62stN4Uu+Pmwlr9oYAFoz8SylKLJFL/tNNv+5u/dZV2MOdpU5+eq+Ynv8Gp1NG+Cf4jnhyHxcYdAvDiuy6ibeO3nGWkYz/06aP+iLyqZFMGBAMnqpN/XTMMbyogh7mdMpAx7bHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437759; c=relaxed/simple;
	bh=2aQ3eTmbgFXFky3hKC4TKtnz05YviTxJoN+jaKiogcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MSBSpjOMWJt68N+hQGAbry6rny44v1ePDYEILrw0YY1C2en1zuTn7BPPqSZUUMuGcFSDxX1ioBnFTaOLCwLzzXgT6PQ6D9C7/gzeatvQsWFabFVlMDht8Qw0wyidgs9KOlNG5Ym5A7ecQ55n8i+97EqlHna1krZMKGz50+VAPlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ckfcvo9N; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ckfcvo9N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=IY
	AzUI9KJfrVAPUm+dLjsna0fsaIT2KUR47d5rbMV4Q=; b=ckfcvo9NElmrxtAsS7
	Q23rowQ5H7/VENQwE0rs7LRngh+15JdAKwsEbpkOpg2HuZtX0x4Laah/W5sQct8P
	oxRE25LyMyv3XQe7GA/sWvJbZQp9340XgqXcfJxTnhYQod0tjMNSgoMeG3BV76BZ
	iia7kRqXauULzntjBozw/WjV8=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F4pL6bdqlpIIBA--.11355S7;
	Sat, 26 Sep 2026 23:48:34 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 5/5] wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
Date: Sat, 26 Sep 2026 23:48:24 +0800
Message-Id: <20260926154824.75224-6-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3F4pL6bdqlpIIBA--.11355S7
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFyrKrWkWw4fKr1kAw13Jwb_yoW8tF15pF
	47W342yFyUuF45Xrs5Jr48A3WrJ3WDGws29r4UGas5WFnxAr1agFyFvFy7ZryrtFWrGFy2
	k3yjkr18Gw4kG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pib4SwUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xIXUWq36VK0IAAA3J

ath12k_mac_vdev_delete() walks txmgmt_idr with idr_for_each(), and its
callback removes each entry belonging to the interface. Removing the
current entry can invalidate the radix-tree iterator retained by
idr_for_each().

Move the walk into a helper that uses idr_for_each_entry(). It performs a
fresh lookup for every iteration, so each matching entry can be removed
through the locked removal helper without retaining iterator state across
the removal.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 7695b21149d1..ba41b0fa728e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9201,16 +9201,18 @@ int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
 	return 0;
 }
 
-static int ath12k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
+static void ath12k_mac_vif_txmgmt_cleanup(struct ath12k *ar,
+					  struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = ctx;
-	struct ath12k_skb_cb *skb_cb = ATH12K_SKB_CB(skb);
-	struct ath12k *ar = skb_cb->ar;
-
-	if (skb_cb->vif == vif)
-		ath12k_mac_tx_mgmt_free(ar, buf_id);
+	struct ath12k_skb_cb *skb_cb;
+	struct sk_buff *skb;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, skb, buf_id) {
+		skb_cb = ATH12K_SKB_CB(skb);
+		if (skb_cb->vif == vif)
+			ath12k_mac_tx_mgmt_free(ar, buf_id);
+	}
 }
 
 static int ath12k_mac_mgmt_tx_wmi(struct ath12k *ar, struct ath12k_link_vif *arvif,
@@ -10972,8 +10974,7 @@ static int ath12k_mac_vdev_delete(struct ath12k *ar, struct ath12k_link_vif *arv
 	ath12k_peer_cleanup(ar, arvif->vdev_id);
 	ath12k_ahvif_put_link_cache(ahvif, arvif->link_id);
 
-	idr_for_each(&ar->txmgmt_idr,
-		     ath12k_mac_vif_txmgmt_idr_remove, vif);
+	ath12k_mac_vif_txmgmt_cleanup(ar, vif);
 
 	ath12k_mac_vif_unref(ath12k_ab_to_dp(ab), vif);
 
-- 
2.34.1

