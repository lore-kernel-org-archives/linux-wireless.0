Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4310A41BA62
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142339; cv=none; b=rs8uAmui2cxEci/hdKcui9eQLXhg7jWwcdF55Pea54OuJ6t0TqNIE9l7Q5s3Dae1V3UBtK8J/dxKSCX+ggChQyCzlAU3ZrJTUJPETVqWrR5FAQSci+f1FsHaIWUQcNfh+1FXGICNVIFAaCTxIOfolRBTIzP85ENGVeOxASTXrkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142339; c=relaxed/simple;
	bh=SnSXQrwlULFm5a8+r62EvUlWQG0tQroNXztCQP+QTYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j1ME+ih81DSmD74bNKkfUhVuLnntr4BX3cqSTP0Csc1Tk4kcLjyDahFELBI7Y9qU35wWxUa5yaSV30ZzUbizdyofbnZgiECkX9yaEtT7yJ5Xx1lp+eFkLBjy3O13dKQ6blXy1FcQzxHznyeERAHbsCkNjtqQkaJgd6svW/i2FgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNRLDeQ4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNRLDeQ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142335; x=1815678335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SnSXQrwlULFm5a8+r62EvUlWQG0tQroNXztCQP+QTYI=;
  b=iNRLDeQ4zipl13DQQ2xxrWf5RIO/Y1brXhMZpxZ18wBVHnzLP1UTvNdp
   /qkmLMKzmWjjLUfAZfiRErm0CPh0mNk31kcoB3JpNA2gP0N2NFqxc4OCl
   y4BWkslqY0+tNTTZz2UGtt+Oojyu3ldeHyUanx71+XcFpUbsK2GjIHNeK
   0ZBbfVEgpK+EO+QB0R+UHVvmIGgP5WyzYB2z/+SmEzIuEy5t0CSskkgVp
   1MhAjAuN030Q49jFWlktvRokO0/iY/jWIwDjyE+zE4XZWg1c4UM43xkPA
   0o6e7gC/63IfpObIicOOApR076Xim4VjXznTJwx90p3gHHjUwDUlxx9rx
   g==;
X-CSE-ConnectionGUID: y6jRtdIeSS2z4M1K4rntWg==
X-CSE-MsgGUID: c8+2AaEJTsS23O1LPybm7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340738"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340738"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:08 -0700
X-CSE-ConnectionGUID: R26VQLyDQzeOiPdsqQOwvw==
X-CSE-MsgGUID: S0a2m+mNRqKkfg6Ft4bOUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251852034"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: mei: check SAP message length before reading it
Date: Wed, 15 Jul 2026 22:04:27 +0300
Message-Id: <20260715220243.f0026ce26218.I00a856d3aacae1caac605c708f7362689b734234@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

Verify the SAP message size is not larger than the local buffer before
reading the message to avoid buffer overflow.

Fixes: bcd68b3dbe78 ("wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index c5ff1b1b720f..c01435859349 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2021-2024 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 
 #include <linux/etherdevice.h>
@@ -1147,6 +1148,11 @@ static void iwl_mei_handle_sap_rx_cmd(struct mei_cl_device *cldev,
 		iwl_mei_read_from_q(q_head, q_sz, &rd, wr, hdr, sizeof(*hdr));
 		valid_rx_sz -= sizeof(*hdr);
 		len = le16_to_cpu(hdr->len);
+		if (len + sizeof(*hdr) > PAGE_SIZE) {
+			dev_err(&cldev->dev,
+				"SAP message is too big: %u\n", len);
+			break;
+		}
 
 		if (valid_rx_sz < len)
 			break;
-- 
2.34.1

