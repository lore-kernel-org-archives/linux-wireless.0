Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3543B7753;
	Sat,  3 Oct 2026 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791019299; cv=none; b=pAYhgpiF4ny7tKU1BWoJmxMxEEChwo86k2y3FtYdjcAJ6MFTpFhubEzTf+fo6qmAJncC8YE5Swhp+hTmARs50lyrlC3kaTVgTchgJsFT2/+Nz6xIiM85NDwJPLZfoLzoIFRH0neFsDR2QIs7jmzKwfABsitDEvPHbB5G76YuKMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791019299; c=relaxed/simple;
	bh=8pyfJHeZrvClrGX9gUKcU8/qOmQb5eWAxSWUyR4tQrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AtuXnSGMXyFtVq9axDQ6Iatsy9k1Uwkqu6gRqbHOQUxymVBMjRQcRc7jTi6hOdsZalpypT0hYnbNY9HDAGq/542rEIpSlxXRqJt1P37fCFvqrQYC4+bAtJZ860uWvqm4lRFuH94berzUtGefYWKi1eUYK9X9ROvl7J5RHBs9A6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RR6GMvHy; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RR6GMvHy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=+M
	26q6jZ9Bjj1t5nPehKPJpfjHJapIPhP4g+LU0QHr4=; b=RR6GMvHy0CCs/kGh6N
	a3o6QW/5KJZk/3q/7oqBm6as1g1+Y882n2rmvtdwvyeJv2zWLJM/hZ+SS2n2k714
	kpVOau8WaqcuNIIkY29iH9/Zvec/OftafhSZpo3endpvLvdz1sAKj9Ejf5pzTH3d
	9QPaC7PDV8lTlwNDOY5GRRWiY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3n1YCycBqC7WjCQ--.62376S6;
	Sat, 03 Oct 2026 17:21:12 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Carl Huang <quic_cjhuang@quicinc.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Wen Gong <quic_wgong@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH v2 4/5] wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
Date: Sat,  3 Oct 2026 17:21:01 +0800
Message-Id: <20261003092104.520135-5-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261003092104.520135-1-yaojiale02@163.com>
References: <20261003092104.520135-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n1YCycBqC7WjCQ--.62376S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFyxtw47urW8KF4xtF4fKrg_yoW5KFyxpF
	W8uF9rAFyUCw4UXws5JF4xCa4rX3WDJws2kr4kCa4rWF98Xr1FqF1YqFy3Jry0yF45tFyY
	93yjyr18Gwn8t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pijQ6AUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgg-eWrAyQiiAQAA3I

The pending management TX cleanup walks txmgmt_idr with idr_for_each(),
and its callback removes the current entry. This can invalidate the
radix-tree iterator retained by idr_for_each().

Use idr_for_each_entry() so every iteration starts with a fresh lookup.
Continue to remove each entry under txmgmt_idr_lock before freeing its skb,
preventing concurrent TX completion from finding a stale skb pointer.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/ath/ath12k/core.c |  3 +--
 drivers/net/wireless/ath/ath12k/mac.c  | 12 ++++++------
 drivers/net/wireless/ath/ath12k/mac.h  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 262a2045309b..e9aa5e4e999d 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1514,8 +1514,7 @@ static void ath12k_core_pre_reconfigure_recovery(struct ath12k_base *ab)
 			complete_all(&ar->thermal.wmi_sync);
 
 			wake_up(&ar->dp.tx_empty_waitq);
-			idr_for_each(&ar->txmgmt_idr,
-				     ath12k_mac_tx_mgmt_pending_free, ar);
+			ath12k_mac_tx_mgmt_pending_free(ar);
 			idr_destroy(&ar->txmgmt_idr);
 			wake_up(&ar->txmgmt_empty_waitq);
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf79d10..c0acb92b7320 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9187,13 +9187,13 @@ static void ath12k_mac_tx_mgmt_free(struct ath12k *ar, int buf_id)
 	ath12k_mgmt_over_wmi_tx_drop(ar, msdu);
 }
 
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx)
+void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar)
 {
-	struct ath12k *ar = ctx;
-
-	ath12k_mac_tx_mgmt_free(ar, buf_id);
+	struct sk_buff *msdu;
+	int buf_id;
 
-	return 0;
+	idr_for_each_entry(&ar->txmgmt_idr, msdu, buf_id)
+		ath12k_mac_tx_mgmt_free(ar, buf_id);
 }
 
 static int ath12k_mac_vif_txmgmt_idr_remove(int buf_id, void *skb, void *ctx)
@@ -14725,7 +14725,7 @@ static struct wiphy_iftype_ext_capab ath12k_iftypes_ext_capa[] = {
 
 static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
 {
-	idr_for_each(&ar->txmgmt_idr, ath12k_mac_tx_mgmt_pending_free, ar);
+	ath12k_mac_tx_mgmt_pending_free(ar);
 	idr_destroy(&ar->txmgmt_idr);
 
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
diff --git a/drivers/net/wireless/ath/ath12k/mac.h b/drivers/net/wireless/ath/ath12k/mac.h
index aba98afd4365..ae44ebfd9bd9 100644
--- a/drivers/net/wireless/ath/ath12k/mac.h
+++ b/drivers/net/wireless/ath/ath12k/mac.h
@@ -173,7 +173,7 @@ struct ath12k *ath12k_mac_get_ar_by_pdev_id(struct ath12k_base *ab, u32 pdev_id)
 void ath12k_mac_drain_tx(struct ath12k *ar);
 void ath12k_mac_peer_cleanup_all(struct ath12k *ar);
 void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah);
-int ath12k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
+void ath12k_mac_tx_mgmt_pending_free(struct ath12k *ar);
 enum rate_info_bw ath12k_mac_bw_to_mac80211_bw(enum ath12k_supported_bw bw);
 enum ath12k_supported_bw ath12k_mac_mac80211_bw_to_ath12k_bw(enum rate_info_bw bw);
 enum hal_encrypt_type ath12k_dp_tx_get_encrypt_type(u32 cipher);
-- 
2.34.1

