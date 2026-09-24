Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E22474252
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246393; cv=none; b=csNygFXAlSSXX8ateL12nxTcJ9kZL1PQFFHu5jXRUa8vLvtUNvlQunwvuxMEEptHHV1Iq2RUix6UXdGRone/6i4aR1/B46QZriXI3vV/TR0/ZRBumsjynPEbqpYjqCWOy1ZdhVA8xbPz4rnnYK9JkClTFvWMMLUnZi34gsUCqzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246393; c=relaxed/simple;
	bh=Y2LyYraap3PN309hyaUzYpIsei4mg24BhgZ1klPrXIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O5c2w39sbGExZNSwOT0lCU9GyBD/rYUCT2LofXBmo/UO70mhwqw+g33r720L7ISadPkA0SZr3yeW5aOgODIChUdpI5nWacKPJKs+bufjcA7/BSQKmAtYVIxMF5jPrsXX/6/CJptTh/kwHYi+hDN+WCyNou100f1rNJn1Fv4lE+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=StpiQOBH; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="StpiQOBH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246390; x=1821782390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y2LyYraap3PN309hyaUzYpIsei4mg24BhgZ1klPrXIQ=;
  b=StpiQOBHS/oLODVWkMf0a+1X03lFob6ipSkdFA79OxE60eqLIcS9sWij
   UpzJNiEntdG6UPd3l/lSpIHYwcOdIg2D8VZrVkJFyHKOWFs5AUMCaXN2a
   lwyXZpD/qfdmU9GYtSe7HlvrmfIikrZcrndKaGyE77RGaKFNv+m5On8hj
   hFrmBPEibYrgI/uiyI+0Tfde6HLzGmUpYSQtbGJeuB014EczY6tpvnlKQ
   yOHzlu4da9/+boqRD7YW4SAnHnTIzkvqGXewF10YQzazG12eBoEvE8xKB
   7zpCg7k1ZyRptAuCDOypogtGdOdEI19LSDvWfQdEIhvAscJ9riKF6dvWL
   Q==;
X-CSE-ConnectionGUID: yxKEMcMLRxCMyjYIoFPFqA==
X-CSE-MsgGUID: Hhn9zi2rSPydfVwVhZ13sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134902"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134902"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:49 -0700
X-CSE-ConnectionGUID: slpIjmuCSiqhse5VNkkgog==
X-CSE-MsgGUID: WvBvfTYzTgiKtR1NIuSKUw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:48 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: add support for the new MPDU descriptor
Date: Thu, 24 Sep 2026 13:41:26 +0300
Message-Id: <20260924133942.5b524d5e8146.Ie2d919c884f7db8cd76b4cb6a9f4584eb285eea5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware now reports in DW-12 bits 31:24 the RU/MRU/DRU that was
used for the received frame, in trigger-like format.

The MAC context byte moved to bits 31:24 of DW-10.
It isn't used by the driver, so just follow the new layout.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index a8f1edf19bbe..20460534fc99 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -583,7 +583,11 @@ struct iwl_rx_mpdu_desc_v3 {
 	/**
 	 * @reserved_xsum: reserved high bits in the raw checksum
 	 */
-	__le16 reserved_xsum;
+	u8 reserved_xsum;
+	/**
+	 * @mac_context: MAC context mask, in this DW only from API version 10
+	 */
+	u8 mac_context;
 	/* DW11 */
 	/**
 	 * @rate_n_flags: RX rate/flags encoding
@@ -603,9 +607,10 @@ struct iwl_rx_mpdu_desc_v3 {
 	 */
 	u8 channel;
 	/**
-	 * @mac_context: MAC context mask
+	 * @ru: RU/MRU/DRU used for the frame, in trigger-like format;
+	 *	only from API version 10, this byte held @mac_context before
 	 */
-	u8 mac_context;
+	u8 ru;
 	/* DW13 */
 	/**
 	 * @gp2_on_air_rise: GP2 timer value on air rise (INA)
@@ -647,7 +652,11 @@ struct iwl_rx_mpdu_desc_v3 {
 	__le32 reserved[1];
 } __packed; /* RX_MPDU_RES_START_API_S_VER_3,
 	     * RX_MPDU_RES_START_API_S_VER_5,
-	     * RX_MPDU_RES_START_API_S_VER_6
+	     * RX_MPDU_RES_START_API_S_VER_6,
+	     * RX_MPDU_RES_START_API_S_VER_7,
+	     * RX_MPDU_RES_START_API_S_VER_8,
+	     * RX_MPDU_RES_START_API_S_VER_9,
+	     * RX_MPDU_RES_START_API_S_VER_10
 	     */
 
 /**
@@ -737,6 +746,8 @@ struct iwl_rx_mpdu_desc {
 	     * RX_MPDU_RES_START_API_S_VER_6
 	     * RX_MPDU_RES_START_API_S_VER_7
 	     * RX_MPDU_RES_START_API_S_VER_8
+	     * RX_MPDU_RES_START_API_S_VER_9
+	     * RX_MPDU_RES_START_API_S_VER_10
 	     */
 
 #define IWL_RX_DESC_SIZE_V1 offsetofend(struct iwl_rx_mpdu_desc, v1)
-- 
2.34.1

