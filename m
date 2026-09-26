Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B9735F5ED
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442955; cv=none; b=cVGHXtz6FWypLbMqNGX5SzRqIw6o58XTTt1AU5PbFHDjDe3ex2tOO1a/cGuBQ0P5N/sGZkuK00ijAsXNhgkKw1c7iZJYQQ0vYpU9xcRn1DTqrtTMROVFK5gVMfvDX/dA0HWht77GP9tHBs5AJuonmXpnTTXdzaW9xTLr7qzvdM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442955; c=relaxed/simple;
	bh=Y2LyYraap3PN309hyaUzYpIsei4mg24BhgZ1klPrXIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MHDL0XB5W15t4BAdJxA1M0P2H52x/2Mt0cA2nXaWYbKPvjdy3Nwh665OX2fALw6mF9vSL8oQNparV/HZzmLp8za6GfpjT3sUxZ6F686kisutQ3YPlUwhT5ioyKgMqQsnCHarYnzSAyEq7pinfGq8Ikjx86WHjs1aJMYwwVaI0zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YnIUQNdS; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YnIUQNdS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442954; x=1821978954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y2LyYraap3PN309hyaUzYpIsei4mg24BhgZ1klPrXIQ=;
  b=YnIUQNdSbHTsu9Fztb9LYcOFoL8pGAPHzA5Bs9+6FoppnEEQJSnuDsWA
   +bGvhxkRwjfcku6EJLEBrvrqO/H3CWwEdBsZXv+shkTCUdwpwhAMYms8a
   6N+DX9p7su+0Ndl1IkSi2NBrnAIxEyPOSDDkyiXbS/4FGrFwPXF0qBpUZ
   ALjzZ3xZk8KnDo/KNkzyADaAzraHCljhjvBeHe/SoaHtE9ZBehAsCIZ9K
   cDAtSfBqHBShKWXxnkLQk6bdPGjgXkvhUG2zatY5FWtet4Zsa8LgT3WTE
   4zg2h4+odmUjYgD0m8t7ydmo7PpwcUYn26YgWAjZ/xcsI4CBw+AywDO1+
   Q==;
X-CSE-ConnectionGUID: oFbyAEZRTnun/ebSOFd18A==
X-CSE-MsgGUID: 8a2M2bW1RYy5aXR1ggyfuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533299"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533299"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:54 -0700
X-CSE-ConnectionGUID: mMbDIyrUQ9WkiesfzYMpUw==
X-CSE-MsgGUID: DnxvF5BURX+bHZiSE58R8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274197018"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:53 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 12/15] wifi: iwlwifi: add support for the new MPDU descriptor
Date: Sat, 26 Sep 2026 20:17:31 +0300
Message-Id: <20260926201527.cf236c23d1aa.Ie2d919c884f7db8cd76b4cb6a9f4584eb285eea5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
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

