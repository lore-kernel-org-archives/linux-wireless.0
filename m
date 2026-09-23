Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128EF51A15A
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168601; cv=none; b=Qm5rYU9PPBZqFWWkPlb4isTJvcmy/Cs5TbgRZy7TeRUtowdTJmtUqeaLqLIsbLyPdMVL/+aRwiw4QMhOnGLFl4JWjQ9my6pFcO/xfGuTuoMXPUXLn3Nvk84GJM2rmS+9PNZ27bsS64otj0QCyFcWurS7dUczsJY4SZeraO2z/Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168601; c=relaxed/simple;
	bh=OVhkuG7/CwjXjEP0msu9WPNHNAnX8H3RS1+Brq7oBeE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YPC+plFQRtlPYG49g1glnKvt7y/l2PXc+zC5A+DvIdbOl4zpnJ57TJGoQOczEMRgbNlap8tAl1N0DxmaSRs1STPMUIeqzhF3DQSbtiiZtUKTNwgBLdIVQCjhAKE5mMwTku4DeIctiGq9vr0UaO2L6mK5A2S76mZ9Mfn+53wlADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZBPoiD/C; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZBPoiD/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168597; x=1821704597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OVhkuG7/CwjXjEP0msu9WPNHNAnX8H3RS1+Brq7oBeE=;
  b=ZBPoiD/C3D+mqQTwmMjMM5UtarLV32G/CJtDAFDjcF/DODsKx9JyxvFt
   pK02hDzseTsHJS/fbO/du/y1FpheygZWiry+26q7AjZXtM2OSwLt0ALWR
   eamH+Fz9e12rq51QMusmAqz2jWw8f3g0n8aOFHAlWBLT0pdwMGhHt/PAK
   1gfHwIUYMqpPs7ltG2CQ8c3FTKEurFVf/q0uZrAId763cQparYpqFPYC8
   kIh8tCj6Qi/eyfs7zxoa6UkVgOGAzIdvfqBMo2687BFIa9QqnlsILLW35
   r3tLJANs8OpBTK+cOscyyqnxUgcgcMU0in14LrYicR0GEfBkHkm2JlKDr
   A==;
X-CSE-ConnectionGUID: QI0yNUaFSt+Ir5ZfX5CiuA==
X-CSE-MsgGUID: 32CjY+nDRs+1YEO4s1d77w==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781342"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781342"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:13 -0700
X-CSE-ConnectionGUID: h34Xzvi5SpWfoa/5WxyelA==
X-CSE-MsgGUID: +M0x70UbQ+qftl0C7vRXTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697075"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:12 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: mvm: validate mpdu len before relying on it
Date: Wed, 23 Sep 2026 16:04:52 +0300
Message-Id: <20260923160318.fbf29ec27bc0.I4bb0dbd739ff1ddf969e51bbd68c42ca9e4e0634@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

iwl_mvm_rx_mpdu_mq path only checks that the mpdu_len fits into the pkt
len, but it doesn't validate len itself before dereferencing parts of
the mpdu: the header, the padding, and the mic_crc_len.

Check that the mpdu len covers the hdrlen, the padding (if exists) and
the mic_crc_len.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 8c4009d3a00c..c01c704929ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -99,10 +99,14 @@ static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u8 mic_crc_len = u8_get_bits(desc->mac_flags1,
 				     IWL_RX_MPDU_MFLG1_MIC_CRC_LEN_MASK) << 1;
 
-	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD) {
-		len -= 2;
-		pad_len = 2;
-	}
+	pad_len = desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD ? 2 : 0;
+
+	if (IWL_FW_CHECK(mvm, len < hdrlen + crypt_len + pad_len + mic_crc_len,
+			 "invalid len (%d): hdrlen=%u, crypt_len=%u, pad_len=%u, mic_crc_len=%u\n",
+			 len, hdrlen, crypt_len, pad_len, mic_crc_len))
+		return -EINVAL;
+
+	len -= pad_len;
 
 	/*
 	 * For non monitor interface strip the bytes the RADA might not have
@@ -110,7 +114,7 @@ static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * interface cannot exist with other interfaces, this removal is safe
 	 * and sufficient, in monitor mode there's no decryption being done.
 	 */
-	if (len > mic_crc_len && !ieee80211_hw_check(mvm->hw, RX_INCLUDES_FCS))
+	if (!ieee80211_hw_check(mvm->hw, RX_INCLUDES_FCS))
 		len -= mic_crc_len;
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
@@ -2164,7 +2168,17 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	phy_data.phy_info = le16_to_cpu(desc->phy_info);
 	phy_data.d4 = desc->phy_data4;
 
+	if (IWL_FW_CHECK(mvm, len < sizeof(hdr->frame_control),
+			 "MPDU len (%u) is smaller than frame control\n",
+			 len))
+		return;
+
 	hdr = (void *)(pkt->data + desc_size);
+	if (IWL_FW_CHECK(mvm, len < ieee80211_hdrlen(hdr->frame_control),
+			 "MPDU len (%u) is smaller than header length (%u)\n",
+			 len, ieee80211_hdrlen(hdr->frame_control)))
+		return;
+
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
 	 * ieee80211_hdr pulled.
 	 */
@@ -2285,7 +2299,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		struct iwl_fw_dbg_trigger_tlv *trig;
 		struct ieee80211_vif *vif = mvmsta->vif;
 
-		if (!mvm->tcm.paused && len >= sizeof(*hdr) &&
+		if (!mvm->tcm.paused &&
 		    !is_multicast_ether_addr(hdr->addr1) &&
 		    ieee80211_is_data(hdr->frame_control) &&
 		    time_after(jiffies, mvm->tcm.ts + MVM_TCM_PERIOD))
-- 
2.34.1

