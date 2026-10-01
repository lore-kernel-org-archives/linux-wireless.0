Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85C54A8FED
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860730; cv=none; b=IxlAo9b2Ydvzy3/oGwwfufRb2HK755jJolrwjaTbQGPILYLmBrBq7SXz3t3s45oy0wpzLablylKP8jDc9vO1pHa/LJFCcnUjxIBz7e2m6xVBYGw2vT0WGhF/PsbQOxEThZ/GiLM9f+16jSPl4qI8nijwt0yPQzTsX7lyjGWrB9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860730; c=relaxed/simple;
	bh=mtUj/Dg9ap+p+6sIvBivLGV6pM7IgXFRf7tFg2VjrbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vDcexYpio+rflZBG6haagTpcmx7caL2ubtijtrOJ9TwYhk68kDsdCLx+aOMicXri+tSYJ/av7oyZmj6Q+rpBNGO7g0n1lj0K2HiwCBeay7Lex7HG1qi1MawzURioGDK2N6/krCRjbPgsr+Y1p2WrRBFUROd757VakbxFgVPuA4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iPlXZGKU; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iPlXZGKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860728; x=1822396728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mtUj/Dg9ap+p+6sIvBivLGV6pM7IgXFRf7tFg2VjrbY=;
  b=iPlXZGKU1flyiOGyNzjHsGyb9LrNqfP/MBG7ZCv2mrubMemHzk47d2Pi
   KaaFc9Q92p0ANF68GFvknetgTdAn2TGoDoWOCt3aYyHyUdIrD6pRG0LRs
   W/1OPuXnZP2IP82+kgFh5AZ+fuLzg8yW5RSKSSfe3NI7WRVg9mK9s5+qm
   NfiCFc6qkuOgFlCOeOSQtACW8b0LPpbqgioRzpg2HqAFFKt+WqSAW6kDl
   O6uhYAHWqNhBHmHibEMEPi2xZY/seo/9VMCvJZVx8M/G0VHliht2yZasL
   HtioKJJlORmNaRkGcYuRuWxFwdEEVdffGtEunsotCuc9Q9GxQ++o4a6UV
   A==;
X-CSE-ConnectionGUID: YYo+60L/Sr6Nlu3W+4oMOA==
X-CSE-MsgGUID: V8taSZUrQfSQWRWCp1nTiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423637"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423637"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:47 -0700
X-CSE-ConnectionGUID: 8mQRK7V9QnK3ww2+RO9lsQ==
X-CSE-MsgGUID: kl9bVANfR+qykA63bISZHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485555"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: mld: set RX_FLAG_FAILED_PLCP_CRC for bad U-SIG CRC
Date: Thu,  1 Oct 2026 16:20:24 +0300
Message-Id: <20261001161715.cda01742eff8.I824c410fefd4022973403c1cf18f47459e34c4b2@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

There are a number of places checking for the U-SIG CRC and
then reporting if it failed, but we should set the failed
PLCP CRC top-level radiotap flag for easier discarding of
such packets in users such as wireshark. Do that with a new
helper function, to avoid doing it in so many places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 9ba68564bf98..e1964e570012 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -816,6 +816,14 @@ iwl_mld_radiotap_put_tlv(struct sk_buff *skb, u16 type, u16 len)
 	(_usig)->value |= LE32_DEC_ENC(in_value, dec_bits, _enc_bits); \
 } while (0)
 
+static void
+iwl_mld_check_bad_usig_crc(struct ieee80211_rx_status *rx_status,
+			   struct ieee80211_radiotap_eht_usig *usig)
+{
+	if (usig->common & cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_BAD_USIG_CRC))
+		rx_status->flag |= RX_FLAG_FAILED_PLCP_CRC;
+}
+
 static void iwl_mld_decode_eht_usig_tb(struct iwl_mld_rx_phy_data *phy_data,
 				       struct ieee80211_radiotap_eht_usig *usig)
 {
@@ -878,6 +886,7 @@ static void iwl_mld_decode_eht_usig_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 static void iwl_mld_decode_eht_usig(struct iwl_mld_rx_phy_data *phy_data,
 				    struct sk_buff *skb)
 {
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	u32 he_type = phy_data->rate_n_flags & RATE_MCS_HE_TYPE_MSK;
 	__le32 usig_a1 = phy_data->ntfy->sigs.eht.usig_a1;
 	__le32 usig_a2 = phy_data->ntfy->sigs.eht.usig_a2_eht;
@@ -941,6 +950,8 @@ static void iwl_mld_decode_eht_usig(struct iwl_mld_rx_phy_data *phy_data,
 		iwl_mld_decode_eht_usig_tb(phy_data, usig);
 	else
 		iwl_mld_decode_eht_usig_non_tb(phy_data, usig);
+
+	iwl_mld_check_bad_usig_crc(rx_status, usig);
 }
 
 static void
@@ -1448,6 +1459,7 @@ static void iwl_mld_decode_uhr_usig_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 static void iwl_mld_decode_uhr_usig(struct iwl_mld_rx_phy_data *phy_data,
 				    struct sk_buff *skb)
 {
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	u32 he_type = phy_data->rate_n_flags & RATE_MCS_HE_TYPE_MSK;
 	struct ieee80211_radiotap_eht_usig *usig;
 	__le32 usig_a1 = phy_data->ntfy->sigs.uhr.usig_a1;
@@ -1507,6 +1519,8 @@ static void iwl_mld_decode_uhr_usig(struct iwl_mld_rx_phy_data *phy_data,
 		iwl_mld_decode_uhr_usig_non_tb(phy_data, usig);
 		break;
 	}
+
+	iwl_mld_check_bad_usig_crc(rx_status, usig);
 }
 
 static void iwl_mld_decode_uhr_tb(struct iwl_mld_rx_phy_data *phy_data,
-- 
2.34.1

