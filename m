Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF13247DFBA
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 12:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778847016; cv=none; b=D6JMyWocinLJz7SuTRwzyhtzAbdyKVO99idX9IWO3x3hGSrPG0ya1oWJsSiBdWARYSghBycucvI2349i6hEF/Zfnt90fOduyEU4ajnyhHyXn7O9uuvL1aR3KE1Yhb4LZz3mLVf9k8PW2l0BL7xT06RD04RmaR9QP2/aPtqHMAII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778847016; c=relaxed/simple;
	bh=Wr5pX1y94a1//aXoJapahlSqY58OZNE6MPEMJqU6HTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KBRQBzQnr4wBsRtKDJB6/6J7whhLHWYUyUNIwjFj7COocHOywlcDp9yS8LznVq4epasVu5L0oXEFSR9kOB7+zZmAHjdeNnUnf0USEk1hTQlEg1hdX8VvQB7NPWGIMSdYqqzpq34YEdjRjEjvoUAGxwBI1/T3dwHo2NHhyJfrhPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UGYnx/LX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UGYnx/LX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778847015; x=1810383015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wr5pX1y94a1//aXoJapahlSqY58OZNE6MPEMJqU6HTs=;
  b=UGYnx/LXdU4vjRxehZSWpCqc0fIAffz1LziW235QpUs41ehBZLJNq/Fg
   3affnA3aORqAmQRF2PQyRO14zDGfZ2qR9AzrB/phdAdcid3QzVLVB77qC
   WzRrWB5XO+pazM1eic+rIRobFQCPnh1WJMLh4eK7MXmXoQnTiXvSFLalc
   c4zvw/V1WQOTvgwEjK0R4faboLmE0HEFP5nqXS/3PyiQb17Zc6GXBEi3N
   tlI+eQ2af/0qjd6a2tO2kMRzSdiS3QxBxFLeY38cJxQuAy87H5+Phudms
   6Yg6c6RDwiX/j6FPfTcdkbM8nk3rVSBB2ynCxHScIMnr2rfnkpE6MRYI4
   A==;
X-CSE-ConnectionGUID: uMf7QkgmRLW581am9iCALw==
X-CSE-MsgGUID: K8vIk+sRQKWzhpFi4TZM1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="91185680"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="91185680"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:14 -0700
X-CSE-ConnectionGUID: 7BaIHn1lRpiFWAWUAFxW2w==
X-CSE-MsgGUID: U8XWx0qbR8CXo82u4T95xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="243650013"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 08/15] wifi: iwlwifi: mld: Disallow using a per-STA GTK for Tx
Date: Fri, 15 May 2026 15:09:41 +0300
Message-Id: <20260515150751.b004744087cb.I25fb83f9e3dc563d122a160da150d793155513fa@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260515120948.1157329-1-miriam.rachel.korenblit@intel.com>
References: <20260515120948.1157329-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

When a GTK is configured for a station, it can only be used for Rx
and never for Tx. In such a case, set the IWL_SEC_KEY_FLAG_NO_TX
flag when the key is installed, so the FW will not use it for Tx.

Specifically, this is needed for per-station GTK installed on NAN
NDI stations associated with NAN Data interfaces.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
tested: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/key.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/key.c b/drivers/net/wireless/intel/iwlwifi/mld/key.c
index a6454d90d0e3..bf80b4770b5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/key.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/key.c
@@ -49,6 +49,12 @@ static u32 iwl_mld_get_key_flags(struct iwl_mld *mld,
 	if (key->flags & IEEE80211_KEY_FLAG_SPP_AMSDU)
 		flags |= IWL_SEC_KEY_FLAG_SPP_AMSDU;
 
+	/* When a GTK is configured for a station, it can only be
+	 * used for Rx and never for Tx. Thus, set the NO TX flag.
+	 */
+	if (!pairwise && sta)
+		flags |= IWL_SEC_KEY_FLAG_NO_TX;
+
 	return flags;
 }
 
-- 
2.34.1

