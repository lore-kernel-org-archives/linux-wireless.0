Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7967D3C6600
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077704; cv=none; b=oOJ5x7lH69Dxj2gJ+UxiIiL9B9vPWekIHuNUuauquEIhUnSdGM8SrJ0dNE3gqrAsf8+3a78SZMAWtjs+HmQSrXVXTvwcqcyYS3GccOnvw64x8LzbhfDKOsdVjwM5w1XYUMpAP/CKTr2XBWDROFRoebhISLG++47HDrq8jEshu1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077704; c=relaxed/simple;
	bh=j9yy+pca89fIKcpFRayaUb85QqM+7zDMdALARkjx7x8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nKZ4U4ZE24PGfUehM3vlx3ZdQ7frOo1u4FBOpBes7hXhOiQPJELf+A8xVpL/R9EzFJrDITNIeePnPyZlZLcZUChOgoXevG2Sf3stkqGEF6fhx9RKkxLaWR/XW1+EKr19swWol0h0IqRDWb8qZA7YXXN20KKpaJ5PLpV8Do3+fg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q/IOxaxa; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/IOxaxa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077702; x=1821613702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j9yy+pca89fIKcpFRayaUb85QqM+7zDMdALARkjx7x8=;
  b=Q/IOxaxaBR+lSn4ZAKb0MTuHUNZnTGUzEUF+IbGm8xnT4qMf9z43U5In
   iB74HQSWo+KFGFLLpjriD2tVOuMKUsJk01kCmam4ghPpElZTYgcR/lvYu
   1UNu8+4pVi5HopI1n8NlOMYca0+QzSCfJij7K76apuM0wgjTTBxV+imDT
   ++qnGWmXGm+VJTVB4QCRqLy0A1EPwy34DL3K2ZfZfcLmxP5rsW/E/yYdN
   4qa6gPATvqN8T1lyJe7QjMiADafaW1t3Ys6J6KASWGoBMiHN+obzm+EUJ
   4HxQQU1wWGUQ9JwYEgZXoHUZ6jkzfuQ90BK4qIZdl6Q97aP3vk3UTy8FL
   g==;
X-CSE-ConnectionGUID: 141LW3mUT22Lla/75w5n8Q==
X-CSE-MsgGUID: tW4+xy4oTUGMmiFw3Gv59g==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170537"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170537"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:14 -0700
X-CSE-ConnectionGUID: OQfA6M1bQ1mHEVkI1gHPyA==
X-CSE-MsgGUID: DM9IDK96Q1iOIWHbLp0WIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275387"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: iwlwifi: pcie: fix TSO page leak in iwl_pcie_prep_tso()
Date: Tue, 22 Sep 2026 14:49:54 +0300
Message-Id: <20260922144819.9f5a0b76e75e.Ic7d2303cb85a6de5158a713f57d4366c7b0d93b0@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_pcie_prep_tso() obtains a TSO header page via
iwl_pcie_get_page_hdr(), which stores the page in skb->cb
and increments its internal reference count.
If skb_to_sgvec() or dma_map_sgtable() then fails, the
function returns NULL without calling iwl_pcie_free_tso_pages()
or otherwise dropping the page reference and/or DMA mapping.

Fix this page leak.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
index fae5beed2ecb..26d1530cfa37 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
@@ -1902,18 +1902,27 @@ struct sg_table *iwl_pcie_prep_tso(struct iwl_trans *trans, struct sk_buff *skb,
 	/* Only map the data, not the header (it is copied to the TSO page) */
 	orig_nents = skb_to_sgvec(skb, sgt->sgl, offset, skb->len - offset);
 	if (WARN_ON_ONCE(orig_nents <= 0))
-		return NULL;
+		goto err_cleanup;
 
 	sgt->orig_nents = orig_nents;
 
 	/* And map the entire SKB */
 	if (dma_map_sgtable(trans->dev, sgt, DMA_TO_DEVICE, 0) < 0)
-		return NULL;
+		goto err_cleanup;
 
 	/* Store non-zero (i.e. valid) offset for unmapping */
 	cmd_meta->sg_offset = (unsigned long) sgt & ~PAGE_MASK;
 
 	return sgt;
+
+err_cleanup:
+	/*
+	 * Since cmd_meta->sg_offset is not set yet, iwl_pcie_free_tso_pages
+	 * will only free the page without unmapping the SG table (which hasn't
+	 * been successfully mapped yet anyway).
+	 */
+	iwl_pcie_free_tso_pages(trans, skb, cmd_meta);
+	return NULL;
 }
 
 static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
-- 
2.34.1

