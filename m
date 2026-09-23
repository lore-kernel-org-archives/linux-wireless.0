Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D075218A4
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168593; cv=none; b=cQ0HhYN+Vrb7g1Ke2gtzP3cq1T5fNeCCvvzQWLP+0PnMLl0U0pERgXl1ChjNKu4GpxZTLf/Eif17cCYKEvECPrDlVTRa1sNpbBGHPjq2/zAQIhfBiLU1UE0gtMqJ8sgc+neDSExHH+HXw74oLNRLte/KhFlhvAGCuJypbsJr0Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168593; c=relaxed/simple;
	bh=8ttYht9ghgfFtCRT0xKAtNvlX2eFCkFBI671tOVcUZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pfsWpbVHIn0dzy+gblRl0FW710lPuWDueAGFOl+lQAh71s9KsWqPnQDrY80GS2nJauLjrM4OxE5YqkOsFZuuZ1gkToevYTlbs7yNT5U0EDOVlQC5wOtf1V6KbCGDvSNcZIqrfIQ+KXGz6Yp9KxDYR/V7XCILeLOcRS2TG5NmLk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=btTtl4EC; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="btTtl4EC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168591; x=1821704591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8ttYht9ghgfFtCRT0xKAtNvlX2eFCkFBI671tOVcUZo=;
  b=btTtl4ECKbCGguTbqf88T39J2Mkke9RMa8UT5Rkd9d1MT2xNzHz2bTXG
   4BtaGl8WNjCvKtHz9qROviRZNprWRs6fCHPHzTsIhi1INe+XJpyxDJmZx
   WZIZ5Lprr7H+b2+Q0HCIGtQgrbSQQCqdkCTZv6pfC9pn93nETs5kvb1C1
   ZFSFTRZaFK/frdl9q51gQCMXgmbi9YmAqXPAX5niDHNthdfCnV5awt4T1
   VfC+LtSw+bE00BkDuXM8MXDuT7NFqYQCQfiptfjGVCJQ1ohsB8xNvCb68
   ltAqnAjd9ZdBfxdlNrNvaxHOOMKUKDsQ+WkrUWxHZ67zPHMfOEQ5i2dQT
   Q==;
X-CSE-ConnectionGUID: hYhCHm6iQ4+qK0QtuaJLNg==
X-CSE-MsgGUID: lIZCvN9RQl+7byb4vJ1z4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781321"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781321"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:08 -0700
X-CSE-ConnectionGUID: ZSc9micjSiO9ywVCGGh1KA==
X-CSE-MsgGUID: fvsljsLdSyi7sgvTjGBUng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697011"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:02 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: mvm: debugfs: validate TAS response and loop bounds
Date: Wed, 23 Sep 2026 16:04:45 +0300
Message-Id: <20260923160318.f03b511b938e.Ib5069ecf15340506498a28d965c49387cab609b1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

iwl_dbgfs_tas_get_status_read() trusted the FW response layout and
iterated with rsp->in_dual_radio + 1 without capping to the
tas_status_mac array size. A malformed or inconsistent response could
lead to out-of-bounds access while printing TAS status.

Validate the GET_TAS_STATUS payload length before dereferencing rsp,
free the response on early allocation failure, and cap both TAS loops
with array size.

This keeps the existing behavior for valid responses and hardens the
debugfs path against invalid firmware data.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 99fb149b8543..4db0f29dd21a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -525,16 +525,24 @@ static ssize_t iwl_dbgfs_tas_get_status_read(struct file *file,
 	if (ret < 0)
 		return ret;
 
+	if (iwl_rx_packet_payload_len(hcmd.resp_pkt) != sizeof(*rsp)) {
+		iwl_free_resp(&hcmd);
+		return -EIO;
+	}
+
 	buff = kzalloc(bufsz, GFP_KERNEL);
-	if (!buff)
+	if (!buff) {
+		iwl_free_resp(&hcmd);
 		return -ENOMEM;
+	}
 	pos = buff;
 	endpos = pos + bufsz;
 
 	rsp = (void *)hcmd.resp_pkt->data;
 
 	pos += scnprintf(pos, endpos - pos, "TAS Conclusion:\n");
-	for (i = 0; i < rsp->in_dual_radio + 1; i++) {
+	for (i = 0; i < min_t(int, rsp->in_dual_radio + 1,
+			      ARRAY_SIZE(rsp->tas_status_mac)); i++) {
 		if (rsp->tas_status_mac[i].dynamic_status &
 		    BIT(TAS_DYNA_ACTIVE)) {
 			pos += scnprintf(pos, endpos - pos, "\tON for ");
@@ -589,7 +597,8 @@ static ssize_t iwl_dbgfs_tas_get_status_read(struct file *file,
 			 "\tDo TAS Support Dual Radio?: %s\n",
 			 rsp->in_dual_radio ? "TRUE" : "FALSE");
 
-	for (i = 0; i < rsp->in_dual_radio + 1; i++) {
+	for (i = 0; i < min_t(int, rsp->in_dual_radio + 1,
+			      ARRAY_SIZE(rsp->tas_status_mac)); i++) {
 		if (rsp->tas_status_mac[i].static_status == 0) {
 			pos += scnprintf(pos, endpos - pos,
 					 "Static status: disabled\n");
-- 
2.34.1

