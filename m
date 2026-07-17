Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97336429CD3
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298708; cv=none; b=tkB55hhom0+djVI7+dlgFhD4n8Bu4EzHF3ZM0Kt177WBtIS3Rc9G/QOZn0PcNP6Dnc4xrxkWtp7+pMntXdBvMmB66lSPNVVJHkjdALBQOqWStBdQOiCHC34IccO1thKaKCYw4LL2V8LbLwhTbaU6f5tlLwQ1dKzhpmABmekSI3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298708; c=relaxed/simple;
	bh=C1ZqMhhpRp7vl+Bu31XgAfAx738hI8+SqdPPHGGz4bM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uK1GQPLmtsYwa3DvI9nB0Avhowu1epC5bdAMTTC6Q9nwPRJTslbngSzw5adFqXFatTXiYJbs6Z6wUFZvbsOIZ8J0LKhMhphojxP7iwJjfkdc96r+CR9JaHOZb2PUShC6YIhvZNOEdztpjmUHQxsIPC3m17MyMr/rkavrr/DtAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CCYTu8io; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CCYTu8io"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298707; x=1815834707;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C1ZqMhhpRp7vl+Bu31XgAfAx738hI8+SqdPPHGGz4bM=;
  b=CCYTu8ioUmfd0TW/Uqz2UpJU30N1jm4hF2mMGdDmk7ejuyeE4kas7kI5
   ijeYfFvBsjAhRYstLvLWiH1Th5R/150vwzqQzNU1ixyKGmmcuQU+GXMqS
   u5B05NR/nfgh4SanCmjJ//rCqGRmHwMRUnJWpZe2x5XKoQWE524Idum7E
   hQjy0Q3JW9DCfheYMGlORZsetIBVMI29F2sMQ5hZGXuJF6Mno8dpf9NKZ
   8Hqz1stIMlZcxy5dYM59HB7+UsY2aDFkieS7ohS0k78k0BFTXkXM9U8WS
   v1gon9UNGGAwXJKTRdGpbUCkQ2V6nv5ZUr3IH3gytSIeMiuM/ddVr5Ml5
   g==;
X-CSE-ConnectionGUID: j3H3qhceSSakBz/O4fScVA==
X-CSE-MsgGUID: ZKMjyjeqQlOVqxZxUL7+9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84926007"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84926007"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:46 -0700
X-CSE-ConnectionGUID: gx7RmOiLSJSa/MMBmTZoxA==
X-CSE-MsgGUID: UeLQliedQp6CDE8uXwdLEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885751"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 7/8] wifi: iwlwifi: mld: add debug log after AP type command
Date: Fri, 17 Jul 2026 17:31:11 +0300
Message-Id: <20260717172958.18e1fc5ec109.I76dd832f62d00a8f358f8e4a705f25184ac53da2@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
References: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Add a radio debug trace when MCC_ALLOWED_AP_TYPE_CMD is sent
successfully during AP type table initialization.
This improves bring-up visibility without changing runtime behavior.
Failures are still reported through the existing error log path.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/regulatory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
index 4a93ccbef495..be311f6c3d9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/regulatory.c
@@ -524,6 +524,8 @@ void iwl_mld_init_ap_type_tables(struct iwl_mld *mld)
 	if (ret)
 		IWL_ERR(mld, "failed to send MCC_ALLOWED_AP_TYPE_CMD (%d)\n",
 			ret);
+	else
+		IWL_DEBUG_RADIO(mld, "MCC_ALLOWED_AP_TYPE_CMD sent to FW\n");
 }
 
 void iwl_mld_init_tas(struct iwl_mld *mld)
-- 
2.34.1

