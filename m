Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19642903D
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298846; cv=none; b=HKE96yDdQ79n3viC8J7gF+tSuhX+8qDUAkMlUnHAaSrRtuztYmqDBNAGuk8lf2fkk5FvWSN2wgmngo4kDtGeEfzlP0CBPsf24HSC1kRHVeyphBCnkbi5mTgtEE4fP3rrdJQ+xQ5QazQz4RTeN/9Te39zVMTcHhn6ylaWjmnA5eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298846; c=relaxed/simple;
	bh=AfaBYPrCZUlGUSeVo4WwQSEKyUlhOo/nLX5r3DFjoqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X2Dxc/DtQah44vVt82lCCfm3D9Bsd7nPg8qQbPLtiA2Q7z/7F2FcGdRdC8r6rbWEAZk3irPAqc+/A8WnDPESczdSgsgni9f/B+fWc9OcvAeDApNAOvN1IIVdTSYr8dCj50INNB1y6Ekx8irjjYNLE1cZcOzsoxUnAyceg3z9eAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YGpXeg3A; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YGpXeg3A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298845; x=1815834845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AfaBYPrCZUlGUSeVo4WwQSEKyUlhOo/nLX5r3DFjoqk=;
  b=YGpXeg3AJSyY3lTbvxIshjDbW9XD0H0X1iE8I47IobOO4jl18hyBzVNh
   7wMUTDzIUrAdEWDrqb02dvQbvglDdH6sCIWiD/FQqGP6mr5qHEG/wYULX
   yTPJrX2uAs/pJa/SiMvNnO5CjFWlk3l0K8WmT6SxdLE8Nsr2Zan1JGEQB
   dVDGgdOh1jhLSzhG3pORluafcWOJ80h3sVQE0j/fUHR9KK+azAKKZGKoi
   fWxrwJm/vyPLiBwHPuZIg0lZa2Gtq+yD5sajTQSGqTUmGOGQKSiK6O1Ut
   rco1vRSnWpDb5wVqP8tb8945sV2lHMzrWmCkt58a9ZotdtKB6Eqzm+kdH
   w==;
X-CSE-ConnectionGUID: BhoUCwzZTiGDLvNFqH1S4A==
X-CSE-MsgGUID: pdQ0PBOuTU+rzRpH+1bSxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95571403"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95571403"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:04 -0700
X-CSE-ConnectionGUID: ZA0nAGdQRuyZzgXNubmloA==
X-CSE-MsgGUID: tV7a4Aj2TXKCHevZ+CgA0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="255035083"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:03 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 1/5] wifi: iwlwifi: bound aligned TLV advance in FW parser
Date: Fri, 17 Jul 2026 17:33:36 +0300
Message-Id: <20260717173215.393c286488f9.Ia39144dc3ca334325ee4eacb7420901e2446fc23@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
References: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Validate ALIGN(tlv_len, 4) against remaining parser length before
consuming bytes from the firmware image.

This avoids length underflow on malformed TLVs.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 842586d4fc5c..001895f4f4bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -804,6 +804,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	u32 build, paging_mem_size;
 	int num_of_cpus;
 	bool usniffer_req = false;
+	size_t aligned_tlv_len;
 
 	if (len < sizeof(*ucode)) {
 		IWL_ERR(drv, "uCode has invalid length: %zd\n", len);
@@ -852,8 +853,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				len, tlv_len);
 			return -EINVAL;
 		}
-		len -= ALIGN(tlv_len, 4);
-		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
+
+		aligned_tlv_len = ALIGN(tlv_len, 4);
+		if (len < aligned_tlv_len) {
+			IWL_ERR(drv, "invalid aligned TLV len: %zd/%zu\n",
+				len, aligned_tlv_len);
+			return -EINVAL;
+		}
+
+		len -= aligned_tlv_len;
+		data += sizeof(*tlv) + aligned_tlv_len;
 
 		switch (tlv_type) {
 		case IWL_UCODE_TLV_INST:
-- 
2.34.1

