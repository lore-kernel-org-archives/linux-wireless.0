Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A94A8435
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860720; cv=none; b=Kxz6dFDUsmG2ycsryqtzsSIx85KWNF/RoT64oBvu26s5Q2mSm8HwCla8Z3ubM8g8eZQ5QjgjixgUfqRJJr0oqjzjH/FGGWi8oi8rah6P/62b9eZMswLWO0cf/rh4gungJn01V88X9ElMFkv1zXDKxBu3iAUkcP5a+hqrWrftl1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860720; c=relaxed/simple;
	bh=FtbZywaYSGz8+88Y1ol7rGkKyrG6O7O/v1DHC88ig50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ID64xSUBSGwwIVkiCVyvwP4Wq6uFm9hih+Qo/0aNZ0VorUbLh/ReuoS7wL1Pxux1RQtzEeSwug4bgqRZN4mhH3RHEkkR2YyKi64UcO//U8qjkkMZhod4T4IJm9pxL8bGyb4nulGBBvx1C1iO7aLVx6QyevYhDn0/SKV+ua34NLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HdnheXwO; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HdnheXwO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860717; x=1822396717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FtbZywaYSGz8+88Y1ol7rGkKyrG6O7O/v1DHC88ig50=;
  b=HdnheXwOLDVdCczpDb31Tl2VlBchl1zNJ7+NInbiilAwRAjWVUEtKxyl
   bN0TnUNjf/EjEGiE6DVF41N6FSBHPTW5x7aq0vjN5nmIpdZKgcz8fiEA3
   bCiIoTt70LpPfYJvvDw1LIbdGPpkxxoH3zKsXuqNOrQxzbSso6uHaPPfu
   7yA8mygDBrpi52h/tvyPVn1xIosYyjJG0OtGU7BwW92mQdIAlJpMWpm/U
   1xoHQNAW2po4wGICBTTkodIqE3s52vAkaEApKCGVT4dq+L/UiJPdRVTAH
   kzormt9kB4L+T1ozcJgSsYQrCBbARz4T6joERnyc0beXxe7SsyzaTzLSe
   g==;
X-CSE-ConnectionGUID: jhd0qcnATTy3BrVsQs2cLA==
X-CSE-MsgGUID: aJXDGJPlSNyN7WgBBZ33/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423624"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423624"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:37 -0700
X-CSE-ConnectionGUID: bnKhXyO9RvCtSN7SUqJO/A==
X-CSE-MsgGUID: aQ7P4IJiT2euIsRNBS1o6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485520"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:36 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: mld: fix some radiotap field reports
Date: Thu,  1 Oct 2026 16:20:17 +0300
Message-Id: <20261001161715.1c9e8d8a9176.I4f67f80fc962187dbe488506a7d90ffaf78585c4@changeid>
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

For non-trigger-based UHR frames, the RU/DRU allocation is only
valid for OFDMA PPDUs, and the non-OFDMA users and interference
mitigation (IM) is only valid for non-OFDMA. Fix the reporting
accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 52 ++++++++++++---------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 5866999c2abd..cb3872cb9e56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1669,17 +1669,43 @@ static void iwl_mld_decode_uhr_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 {
 	__le32 usig_a1 = phy_data->ntfy->sigs.uhr.usig_a1;
 	__le32 usig_a2 = phy_data->ntfy->sigs.uhr.usig_a2_uhr;
+	bool ofdma;
 
 	uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_SPATIAL_REUSE |
 				  IEEE80211_RADIOTAP_UHR_KNOWN_NUMBER_OF_UHR_LTF_SYMBOLS |
-				  /* All RU allocating size/index is in TB format */
-				  IEEE80211_RADIOTAP_UHR_KNOWN_DRU_RRU_ALLOC_TB_FMT |
 				  IEEE80211_RADIOTAP_UHR_KNOWN_LDPC_EXTRA_SYMBOL_SEGMENT |
 				  IEEE80211_RADIOTAP_UHR_KNOWN_PRE_FEC_PADDING_FACTOR |
 				  IEEE80211_RADIOTAP_UHR_KNOWN_PE_DISAMBIGUITY |
-				  IEEE80211_RADIOTAP_UHR_KNOWN_PRI80_CHAN_POS |
-				  IEEE80211_RADIOTAP_UHR_KNOWN_NUMBER_OF_NON_OFDMA_USERS |
-				  IEEE80211_RADIOTAP_UHR_KNOWN_INTERFERENCE_MITIGATION);
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PRI80_CHAN_POS);
+
+	/*
+	 * TB isn't handled here, so uplink can't be OFDMA.
+	 * Downlink OFDMA is PPDU type 0.
+	 */
+	ofdma = !(usig_a1 & cpu_to_le32(OFDM_RX_FRAME_ENHANCED_WIFI_UL_FLAG)) &&
+		le32_get_bits(usig_a2, OFDM_RX_FRAME_UHR_PPDU_TYPE) == 0;
+
+	if (ofdma) {
+		/* All RU allocation size/index is in TB format */
+		uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_DRU_RRU_ALLOC_TB_FMT);
+		/* downlink is never DRU */
+		uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+					     OFDM_RX_FRAME_UHR_STA_RU_PS160,
+					     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_PS_160);
+		uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+					     OFDM_RX_FRAME_UHR_STA_RU,
+					     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B0 |
+					     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B7_B1);
+		uhr->data[8] |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_INDICATION);
+	} else {
+		uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_NUMBER_OF_NON_OFDMA_USERS |
+					  IEEE80211_RADIOTAP_UHR_KNOWN_INTERFERENCE_MITIGATION);
+		uhr->data[7] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+					     OFDM_RX_FRAME_UHR_NUM_OF_USERS,
+					     IEEE80211_RADIOTAP_UHR_DATA7_NUMBER_OF_NON_OFDMA_USERS);
+		if (!(phy_data->ntfy->sigs.uhr.b1 & cpu_to_le32(OFDM_RX_FRAME_UHR_IM_DISABLE)))
+			uhr->data[7] |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_DATA7_INTERFERENCE_MITIGATION);
+	}
 
 	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
 				     OFDM_RX_FRAME_UHR_SPATIAL_REUSE,
@@ -1687,15 +1713,6 @@ static void iwl_mld_decode_uhr_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
 				     OFDM_RX_FRAME_UHR_NUM_OF_LTF_SYM,
 				     IEEE80211_RADIOTAP_UHR_DATA0_NUMBER_OF_LTF_SYMBOLS);
-	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
-				     OFDM_RX_FRAME_UHR_STA_RU_PS160,
-				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_PS_160);
-	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
-				     OFDM_RX_FRAME_UHR_STA_RU,
-				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B0 |
-				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B7_B1);
-	/* downlink is never DRU */
-	uhr->data[8] |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_INDICATION);
 
 	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
 				     OFDM_RX_FRAME_UHR_CODING_EXTRA_SYM,
@@ -1709,13 +1726,6 @@ static void iwl_mld_decode_uhr_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 	uhr->data[1] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
 				     OFDM_RX_FRAME_UHR_STA_RU_P80,
 				     IEEE80211_RADIOTAP_UHR_DATA1_PRI80_CHAN_POS);
-	uhr->data[7] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
-				     OFDM_RX_FRAME_UHR_NUM_OF_USERS,
-				     IEEE80211_RADIOTAP_UHR_DATA7_NUMBER_OF_NON_OFDMA_USERS);
-
-	uhr->data[7] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
-				     OFDM_RX_FRAME_UHR_IM_DISABLE,
-				     IEEE80211_RADIOTAP_UHR_DATA7_INTERFERENCE_MITIGATION);
 
 	iwl_mld_uhr_decode_user_ru(phy_data, uhr);
 
-- 
2.34.1

