Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08424417D76
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141879; cv=none; b=siPZyedhyYKwBOHIhTAZoVvL1G4uS2wzqyQ07mHd70B30AuaBHfTNdZZoH5Zj0EUwGV7gd+IW8Cc+Aj3bhCsZASQuxPnWMP1wIrArYynwd6xNruLTsm1D7vsxU+NV8V1XeCPNZFFHu/PkHYful3QE0gS6KmoxVxrBNa0d9k04Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141879; c=relaxed/simple;
	bh=gNv9btb2dYt3GNQPf3PgYAmQPlNZN8pb7RodKg/h78w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KOj37UrgPcnEkF/ShDCCcrjelTQnv4jEKAvhbeiAyK6p4u/bHBBTPTQUScwsp/w17JNQA8QiiI7AaDGsg9cnJhJTGBiIJZaEGNDOzduEK2epr+sfE2C9hju5UkR92mIp0YofOeSl0iBSE5E/RmzsMmpOyLTYpt2b6TtHQwi84lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GL4O+Zd+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GL4O+Zd+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141874; x=1815677874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gNv9btb2dYt3GNQPf3PgYAmQPlNZN8pb7RodKg/h78w=;
  b=GL4O+Zd+rV2l7qtOBTnw8clCly2ybOP90Yl8/v/zmGLQE8bWc2TiEGxN
   HzBc3/3ckTi8jPdY79+jrXjMraXdrZKT1pmnstq10ejAOwtoRjt12K4zG
   SA7vaKhTiDO/UkteqNEJ//4oaIfp5Yg+t2p57h+DJkWLoc9pxjHmMlplw
   fAA8b5uHLgmoJAsartaBirEqUuC2PtBJ/lDlX0gDXCfY5IAji71waOB0e
   IAsPLcPKLpgNp4dUKsvkGiOT4MC79gO78eHZ1V97LmgKu1oshdDua0DFc
   2v4A5t/GhjcEhXCAcwqZjfrdGvaU3dKrvqh4uyG/++si2BqfLHzQ5RAiA
   Q==;
X-CSE-ConnectionGUID: oH0PGBXkSc+BBJhgdZMV0w==
X-CSE-MsgGUID: IRG8HxywRJWR2tD7hoIzLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160900"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160900"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:46 -0700
X-CSE-ConnectionGUID: DdW5MBKhQ9S/LzX7APnYTQ==
X-CSE-MsgGUID: yaIU9SYlQpWjHlK9jpDPYw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 06/15] wifi: iwlwifi: fix pointer arithmetic in iwl_add_mcc_to_tas_block_list
Date: Wed, 15 Jul 2026 21:57:06 +0300
Message-Id: <20260715215523.d2cd92242582.Ife4140a4e27be2a1cd9f886c5a9b376ce182a019@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The expression list[*size++] increments the pointer 'size'
rather than the u8 value it points to (operator precedence: ++
binds to the pointer before the dereference). As a result the
block-list entry is written at the correct index but *size is
never incremented, so the caller's count stays at zero and
subsequent calls overwrite slot 0 every time.

Change to list[(*size)++] so that the value pointed to by size
is incremented after use as the array index.

Fixes: 5f4656610edb ("wifi: iwlwifi: extend TAS_CONFIG cmd support for v5")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 8d9ff36e30f5..1d6d38ee55b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -389,7 +389,7 @@ bool iwl_add_mcc_to_tas_block_list(u16 *list, u8 *size, u16 mcc)
 	if (*size >= IWL_WTAS_BLACK_LIST_MAX)
 		return false;
 
-	list[*size++] = mcc;
+	list[(*size)++] = mcc;
 	return true;
 }
 IWL_EXPORT_SYMBOL(iwl_add_mcc_to_tas_block_list);
-- 
2.34.1

