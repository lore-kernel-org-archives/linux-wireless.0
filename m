Received: from mail.unwrap.rs (mail.unwrap.rs [172.232.15.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1B43A758E;
	Mon, 20 Apr 2026 17:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.232.15.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707057; cv=none; b=s+ZE21ywleP/AuVb/wgCHXPAHdCiCCJkg1YiCS7TN/seqWpcxdBPKYmnRwnFFB+QP/1kSS0nMKq5yvo3xEvsQzMIfVpoL0Dc/p25QX8P0/5+fTjEq6rC12bKCYDYh0G0Du8cS+4mbQMnLWTFwhoHBq/lUt/6cH585Q0GlgEkrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707057; c=relaxed/simple;
	bh=c8t+1jbp3edPTOaZ1g1cbniG5gVIVXK1gymA2jDzYLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmbTF8itPrTyRVcltiRCKJGfDFIxIYGpBFIVmzo9Qo1oB/Nk/XhBl8FOHKtRnIgx5yo/f48AvSzj4UHkeT/f013beHQOhgSdGFfMk4Nlqkr9kll7+z4abkl2RQM1oFNFNlNZcJicL1p8JuEFzn4PmPU0+FJ/Xs+G7f4wddZ418o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unwrap.rs; spf=pass smtp.mailfrom=unwrap.rs; arc=none smtp.client-ip=172.232.15.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unwrap.rs
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unwrap.rs
From: Cole Leavitt <cole@unwrap.rs>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com,
	miriam.rachel.korenblit@intel.com,
	johannes@sipsolutions.net,
	cole@unwrap.rs,
	stable@vger.kernel.org
Subject: [PATCH v3 2/3] wifi: iwlwifi: mld: fix TSO segmentation when AMSDU is disabled
Date: Mon, 20 Apr 2026 10:44:05 -0700
Message-ID: <20260420174406.128254-3-cole@unwrap.rs>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260420174406.128254-1-cole@unwrap.rs>
References: <20260420174406.128254-1-cole@unwrap.rs>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the TLC notification disables AMSDU for a TID, mld/tlc.c (line 858)
sets link_sta->agg.max_tid_amsdu_len[TID] to the sentinel value 1.  The
TSO segmentation path in iwl_mld_tx_tso_segment() guards only against
zero, not this sentinel, so it reaches the num_subframes calculation:

  num_subframes = (max_tid_amsdu_len + pad) / (subf_len + pad)
                = (1 + 2) / (1534 + 2) = 0

and then passes num_subframes=0 to iwl_tx_tso_segment(), which sets

  gso_size = num_subframes * mss = 0

Calling skb_gso_segment() with gso_size=0 produces an unbounded number
of tiny segments from a single GSO skb.  On a BE200 we've observed the
expansion push thousands of micro-frames into the TX ring before the
rest are purged.

The MVM driver is immune because it gates on mvmsta->amsdu_enabled (see
mvm/tx.c lines 910-913) before reaching the num_subframes calculation.
MLD has no equivalent bitmap and relies solely on max_tid_amsdu_len,
which does not recognise the sentinel 1.

Fix by checking max_tid_amsdu_len == 1 at the existing guard and
falling back to non-AMSDU TSO segmentation (Suggested-by Miriam
Korenblit).  Also add WARN_ON_ONCE(!num_subframes) after the division
as defense-in-depth so any future path that produces zero through a
different mechanism is logged rather than silently creating a
pathological GSO skb.

Downstream user-visible symptoms (TCP retransmit queue corruption on
some setups, firmware MMIO-poll hang on BE200 with c102 firmware) have
been reported in connection with this bug but the causal chain between
the GSO explosion and those symptoms is being investigated separately
with Ben Greear, so they are not claimed here.

Suggested-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Cc: stable@vger.kernel.org
Signed-off-by: Cole Leavitt <cole@unwrap.rs>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index e341d12e5233..8af58aabcd68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -823,7 +823,7 @@ static int iwl_mld_tx_tso_segment(struct iwl_mld *mld, struct sk_buff *skb,
 		return -EINVAL;
 
 	max_tid_amsdu_len = sta->cur->max_tid_amsdu_len[tid];
-	if (!max_tid_amsdu_len)
+	if (!max_tid_amsdu_len || max_tid_amsdu_len == 1)
 		return iwl_tx_tso_segment(skb, 1, netdev_flags, mpdus_skbs);
 
 	/* Sub frame header + SNAP + IP header + TCP header + MSS */
@@ -835,6 +835,9 @@ static int iwl_mld_tx_tso_segment(struct iwl_mld *mld, struct sk_buff *skb,
 	 */
 	num_subframes = (max_tid_amsdu_len + pad) / (subf_len + pad);
 
+	if (WARN_ON_ONCE(!num_subframes))
+		return iwl_tx_tso_segment(skb, 1, netdev_flags, mpdus_skbs);
+
 	if (sta->max_amsdu_subframes &&
 	    num_subframes > sta->max_amsdu_subframes)
 		num_subframes = sta->max_amsdu_subframes;
-- 
2.52.0
