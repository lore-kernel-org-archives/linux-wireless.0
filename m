Received: from mail.unwrap.rs (mail.unwrap.rs [172.232.15.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F107330670
	for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.232.15.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771426051; cv=none; b=GzgJtBgbfpOnU8sD4od/A+B/Q7v5/FrrE1nlFYRRGux4+PbMRzqhG6kY5CIjsRpHfd4P3U38IKD/O4M+yOZ/3ifE6eyGkvHsSaJzo234Z9vnZ1GJUB9d5Xusjy6WUWH2grDQe0bqAkSMCks753HZh3+ZtQb6lMX+mgpQh4VQtLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771426051; c=relaxed/simple;
	bh=tztahyhanQwCuE0HCTHJiqah4WenB9+Rth6KFlKsLDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUpxiPHGtis8qaDmPgjJK4YT7k8F/2MbaFyrwss4+RgsUR4zgzNFDq1E/adVbTdO2uOviwKKQ4nTxLZW85FCVhKnQ/dw2G3leuvpKANFrHWisJ4U5VduJKAPvqNQFHdeqAk7aHd3B0yM70fAS4GXEeOoCgmQAaxIJtxRO3R74ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unwrap.rs; spf=pass smtp.mailfrom=unwrap.rs; arc=none smtp.client-ip=172.232.15.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unwrap.rs
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unwrap.rs
From: Cole Leavitt <cole@unwrap.rs>
To: greearb@candelatech.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com,
	Cole Leavitt <cole@unwrap.rs>
Subject: [PATCH 1/1] wifi: iwlwifi: mld: fix TSO segmentation explosion when AMSDU is disabled
Date: Wed, 18 Feb 2026 07:47:23 -0700
Message-ID: <20260218144723.31699-2-cole@unwrap.rs>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260218144723.31699-1-cole@unwrap.rs>
References: <9edde56d-bfdc-40f6-862c-b69950cc2f25@candelatech.com>
 <20260218144723.31699-1-cole@unwrap.rs>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the TLC notification disables AMSDU for a TID, the MLD driver sets
max_tid_amsdu_len to the sentinel value 1. The TSO segmentation path in
iwl_mld_tx_tso_segment() checks for zero but not for this sentinel,
allowing it to reach the num_subframes calculation:

  num_subframes = (max_tid_amsdu_len + pad) / (subf_len + pad)
                = (1 + 2) / (1534 + 2) = 0

This zero propagates to iwl_tx_tso_segment() which sets:

  gso_size = num_subframes * mss = 0

Calling skb_gso_segment() with gso_size=0 creates over 32000 tiny
segments from a single GSO skb. This floods the TX ring with ~1024
micro-frames (the rest are purged), creating a massive burst of TX
completion events that can lead to memory corruption and a subsequent
use-after-free in TCP's retransmit queue (refcount underflow in
tcp_shifted_skb, NULL deref in tcp_rack_detect_loss).

The MVM driver is immune because it checks mvmsta->amsdu_enabled before
reaching the num_subframes calculation. The MLD driver has no equivalent
bitmap check and relies solely on max_tid_amsdu_len, which does not
catch the sentinel value.

Fix this by falling back to single-subframe TSO (num_subframes=1) when
the AMSDU length limit is too small to fit even one subframe.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Cole Leavitt <cole@unwrap.rs>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index fbb672f4d8c7..1d47254a4148 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -846,6 +846,17 @@ static int iwl_mld_tx_tso_segment(struct iwl_mld *mld, struct sk_buff *skb,
 	 */
 	num_subframes = (max_tid_amsdu_len + pad) / (subf_len + pad);
 
+	/* If the AMSDU length limit is too small to fit even a single
+	 * subframe (e.g. max_tid_amsdu_len is the sentinel value 1 set by
+	 * the TLC notification when AMSDU is disabled for this TID), fall
+	 * back to non-AMSDU TSO segmentation. Without this guard,
+	 * num_subframes=0 causes gso_size=0 in iwl_tx_tso_segment(),
+	 * which makes skb_gso_segment() produce tens of thousands of
+	 * 1-byte segments, overloading the TX ring and completion path.
+	 */
+	if (!num_subframes)
+		return iwl_tx_tso_segment(skb, 1, netdev_flags, mpdus_skbs);
+
 	if (sta->max_amsdu_subframes &&
 	    num_subframes > sta->max_amsdu_subframes)
 		num_subframes = sta->max_amsdu_subframes;
-- 
2.52.0

