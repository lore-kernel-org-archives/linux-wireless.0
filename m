Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C641A57F
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141873; cv=none; b=OxXe1zePH5OmfiTTY29b9j/9s/+iw+1LknQwmezKoaFPGz+mk3HQ9rf/84TpdYwSHvcS81y6TyivGS9Ik+6BWwPLPP01GKO2Ev2HDcH2Uvn03OoLcSnWYdskHMJnpQBcy0GFBhFCvJ/M54uo3NCZUD21ze9Ywrl+NGvzVHhKz0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141873; c=relaxed/simple;
	bh=rkWVvxYU2TKLixpj5mKOBB1eZUBuJscEP0/sSU4ShQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IS5VeTC43nDhVlS2BS+8p5trgBPSnyQyZ7IfJJI7JQWOiMnzW63krs0tELvjbfWXwZN07hyC3RoMmhFqq93f5aG0NM32w9GmHeyXZkEO2s2WGJAePst4NZNhvuLdRypZKFnPG87UjhtqytDZXsFLDfb+LwHUot02nriQsihGr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g0InTI8b; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0InTI8b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141866; x=1815677866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rkWVvxYU2TKLixpj5mKOBB1eZUBuJscEP0/sSU4ShQ4=;
  b=g0InTI8bcRyBfFfDKAQsm6BcxrEf3Vzu68joXshAp+Fkd4p5a4hvOyWo
   RTOFT0M7xKBp80BhCA//QWTQTFkl9Yj6PrRp3K4JqE8S+RHdBW96sER83
   NiEnDRYXYA/9J7h3S3r3Jpxh+ye8ZmhU3XOtnq4htGPQkDQ1khpAo/OP+
   +sX2AXjbnuykrMVbvHzSTwJi8NlTy7G3MtvP3/+Ag60j0h3ozDhmlwFW4
   RbCzqiahS8bKtiU4muCZXLjS8LihYfl5VagJQbqvWK65Ree5uBrNYZbIz
   9VKrE9HLuNf3tdGidRaos+D/ZVFs6m5Q2aqMEGVIQUjhhP6cxjwcgGdAu
   Q==;
X-CSE-ConnectionGUID: xKiSgrVlR1eIpx6ggdrHWA==
X-CSE-MsgGUID: eDX7qBGMT8KqOF17/KZ57Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160891"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160891"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:42 -0700
X-CSE-ConnectionGUID: KF1n+uyBStuGZGFuPm+mTA==
X-CSE-MsgGUID: 9WlVDBCxQISlXBsMzIxY4w==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 03/15] wifi: iwlwifi: mvm: validate TX_CMD response layout
Date: Wed, 15 Jul 2026 21:57:03 +0300
Message-Id: <20260715215523.0474ee89bab9.I84f151aabecb8921b587da092f29f78c47128f0f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

TX_CMD parsing uses frame_count to walk status entries and then
read the trailing SCD SSN. Make the minimum-length check follow
that exact runtime layout calculation before parsing the payload.

For new TX API, reject TX_CMD responses with frame_count != 1 and
warn/return in the aggregation handler to document that aggregated
accounting is expected via BA notifications.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 34 +++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index dc69c71faa76..d8b088e7c250 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1544,6 +1544,17 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
 	return val & 0xFFF;
 }
 
+static inline size_t iwl_mvm_tx_resp_min_len(struct iwl_mvm *mvm,
+					     struct iwl_tx_resp *tx_resp)
+{
+	struct agg_tx_status *agg_status =
+		iwl_mvm_get_agg_status(mvm, tx_resp);
+
+	/* The aggregate response ends with a trailing SCD SSN __le32 word. */
+	return (u8 *)(agg_status + tx_resp->frame_count) - (u8 *)tx_resp +
+		sizeof(__le32);
+}
+
 static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				     struct iwl_rx_packet *pkt)
 {
@@ -1847,6 +1858,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int queue = SEQ_TO_QUEUE(sequence);
 	struct ieee80211_sta *sta;
 
+	if (WARN_ON_ONCE(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
@@ -1881,6 +1895,26 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
+	size_t min_len;
+
+	if (IWL_FW_CHECK(mvm, !tx_resp->frame_count,
+			 "invalid TX_CMD frame_count %u\n",
+			 tx_resp->frame_count))
+		return;
+
+	if (IWL_FW_CHECK(mvm,
+			 iwl_mvm_has_new_tx_api(mvm) &&
+			 tx_resp->frame_count != 1,
+			 "invalid TX_CMD frame_count %u for new TX API\n",
+			 tx_resp->frame_count))
+		return;
+
+	min_len = iwl_mvm_tx_resp_min_len(mvm, tx_resp);
+	if (IWL_FW_CHECK(mvm, iwl_rx_packet_payload_len(pkt) < min_len,
+			 "invalid TX_CMD len %u (frame_count %u, min %zu)\n",
+			 iwl_rx_packet_payload_len(pkt), tx_resp->frame_count,
+			 min_len))
+		return;
 
 	if (tx_resp->frame_count == 1)
 		iwl_mvm_rx_tx_cmd_single(mvm, pkt);
-- 
2.34.1

