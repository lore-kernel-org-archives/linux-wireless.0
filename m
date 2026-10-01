Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC24AAC71
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860720; cv=none; b=BKyLQdQwJg081FUlkA8ysMyzrhOq0b8iJKJwSpCsK4x1xKZPQT1m0T+Cbq+NTDCfgbjcSn4rMxkfE+4S53AQ20yTu7l17F4UkV1jqasxttae3uh6evQcEv/B+Yu2WJl6kci+4QgqxQERCGno1v6wy1yGMmxqhyruL1otNna/NRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860720; c=relaxed/simple;
	bh=W2cdLwU2Xkyvk4ec3ywiVEogOKVhxq8tR3TD4BLNWQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oc2VO1E5jqNfHfrug122DXqJrdn2YFwNmxe4Smtfcc0VoLzExRz+bBOxkxrblEhxBIXcPGad0IPC1Q1dPdoCUEjZD1s0L8VlkM2+exkv1NclgU+TRyzl2uN24/i9s/+v3c/9cT2rmpFJuCEkAyLE+m3CvjUQ3tzkRDKoAbK8DfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1AMWRDz; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1AMWRDz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860716; x=1822396716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W2cdLwU2Xkyvk4ec3ywiVEogOKVhxq8tR3TD4BLNWQo=;
  b=V1AMWRDzl2SvLY+GbtBjWycLtDgv9N5KmCPoxgpDBWoSpmAfTkGIQgr5
   xXUvu3ZGrWmvDEyVooqX8RONFtJiVJdMAMsswSlwI5H7vPCxwYhVI+EDx
   RtnudRhBNOJDSyvgwoDu1eYkivJWn1oJi7e5rBJyvXUeT5SIeE/VAlJmU
   wHVygvHIqKJ6VvE1G/ctH8/xFDHcVkgAns2+F2SismLjublvUaqd2XjKc
   SquqKlScTdSxkv0tsVdwQRGELIelYSQ9QuQMKQ+gKSqVDtlgynemXkfrf
   f98miHyrHxG5FrpmQjn0yYyF/e/34ocKQ9if7PpGFV5tox/HC5D0BPLuk
   g==;
X-CSE-ConnectionGUID: YmJMmT15SNKpfm6yWmDFLA==
X-CSE-MsgGUID: rg/dBulNSquaLsH4G0+T0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423621"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423621"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:35 -0700
X-CSE-ConnectionGUID: TG6PwrQHRjWefMl5qPHPYg==
X-CSE-MsgGUID: XB6KI/KURPqkHG14Vg3beg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485516"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:35 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: mld: report UHR LTF symbols for non-TB PPDUs
Date: Thu,  1 Oct 2026 16:20:16 +0300
Message-Id: <20261001161715.a8228ab59708.I6c58f3e4f30bb0fb7e57a6c49782bf79d280371d@changeid>
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

For TB (trigger-based) PPDUs we were already reporting this, but
I missed it in the non-TB PPDU case. Add it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 1362e3ad97b2..5866999c2abd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1671,6 +1671,7 @@ static void iwl_mld_decode_uhr_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 	__le32 usig_a2 = phy_data->ntfy->sigs.uhr.usig_a2_uhr;
 
 	uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_SPATIAL_REUSE |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_NUMBER_OF_UHR_LTF_SYMBOLS |
 				  /* All RU allocating size/index is in TB format */
 				  IEEE80211_RADIOTAP_UHR_KNOWN_DRU_RRU_ALLOC_TB_FMT |
 				  IEEE80211_RADIOTAP_UHR_KNOWN_LDPC_EXTRA_SYMBOL_SEGMENT |
@@ -1683,6 +1684,9 @@ static void iwl_mld_decode_uhr_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
 				     OFDM_RX_FRAME_UHR_SPATIAL_REUSE,
 				     IEEE80211_RADIOTAP_UHR_DATA0_SPATIAL_REUSE);
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_NUM_OF_LTF_SYM,
+				     IEEE80211_RADIOTAP_UHR_DATA0_NUMBER_OF_LTF_SYMBOLS);
 	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
 				     OFDM_RX_FRAME_UHR_STA_RU_PS160,
 				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_PS_160);
-- 
2.34.1

