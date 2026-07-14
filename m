Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278BF367F4A
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028047; cv=none; b=WIZt9Dyb/Mz4fARVFt8/lNKqpBvtxtWE7kwTJWI+RJxLsKg55UYB5L/X8qpKw6nqFWiIVHlbIO0e77DmBhqHfGIiF7khzpmXDdjuFNh528nMdg1b1f0rF+xug9Mo8ulIeWKF0NSdsZ5kRH737VtvkNXY4GrweVAjVzzIneAooAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028047; c=relaxed/simple;
	bh=+AA4LyHkG4l9OqNLozT5XRJjqSFHiF4cAlo8zpNg9v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NScEGOEwK+r4yMwTU9tWPgwI0BECD9Tkvy01eZn/NjnkPtGmw8IclbOCRLQ5SwQ5eIK8Kd2S8Qzcp612fO6sdcEpldwl5ynwS0NxuyBHWFuEcJQJkoLuLwtPAqbdrDfiOqz21LNLQ29xqeIpOiSibpIQr0s0V/H+l33kd9nMk+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dj7ZM4Ft; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dj7ZM4Ft"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028046; x=1815564046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+AA4LyHkG4l9OqNLozT5XRJjqSFHiF4cAlo8zpNg9v4=;
  b=Dj7ZM4Ftp1U5zpwZhym21KOnBJISm27jGwtSzjpeW7ss669/ItB6XvA3
   zKRmipsf9lQ2OIr9pPajl1yVDIZlXB1lk4e20BsXQVJJTvhFfjRTwDP7p
   eXINoNR+7Agnvd8UC3TXDm+h6q1kvcFNYxjBekp297AsMQbLIM3dzJzr0
   UJ351/NnO/J1rVBE8ph2MKyYLtgNNTBO+STzLQCE/loCmAgHTAA014SfW
   +Y2LGSJ+fR4uMRzgJVO3qyOLWdNk6W9CqrucTydVgofbB0wTTz2DEIRYW
   If+wsuE5Os6TUejrL1ZY3CvIBzEKDeOD4Ktmu4mwxqTY1pWYQCBwNxVV3
   w==;
X-CSE-ConnectionGUID: lrIEwdKoTUOkdAfw5lS3EA==
X-CSE-MsgGUID: tF57rX9aQ5KXqE0Ql3VLMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102200329"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="102200329"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:46 -0700
X-CSE-ConnectionGUID: nXFZ+B+LSdObQbZJ4vIkNw==
X-CSE-MsgGUID: a0MtknCvSpOkE047vqubMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="280250207"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	GitHub Copilot <copilot@github.com>
Subject: [PATCH iwlwifi-fixes 15/15] wifi: iwlwifi: mvm: d3: validate D3 resume notification payloads
Date: Tue, 14 Jul 2026 14:20:04 +0300
Message-Id: <20260714141909.762193753434.I148991b8136cc5042fa08b5faf7b57d38aa2fb47@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
References: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

D3 resume notification handlers read firmware notification fields
before validating that the payload contains the complete fixed structure.
This causes buffer underread on malformed or truncated notifications.

Move payload length validation to occur before any field access in:
- iwl_mvm_parse_wowlan_info_notif: validate before reading num_mlo_link_keys
- iwl_mvm_wait_d3_notif D3_END handler: validate before reading flags

Assisted-by: GitHub Copilot <copilot@github.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index d7ceb385ae0b..3429d9a10e42 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2123,16 +2123,16 @@ static void iwl_mvm_parse_wowlan_info_notif(struct iwl_mvm *mvm,
 					    struct iwl_wowlan_status_data *status,
 					    u32 len)
 {
-	if (IWL_FW_CHECK(mvm, data->num_mlo_link_keys,
-			 "MLO is not supported, shouldn't receive MLO keys\n"))
-		return;
-
 	if (len < sizeof(*data)) {
 		IWL_ERR(mvm, "Invalid WoWLAN info notification!\n");
 		status = NULL;
 		return;
 	}
 
+	if (IWL_FW_CHECK(mvm, data->num_mlo_link_keys,
+			 "MLO is not supported, shouldn't receive MLO keys\n"))
+		return;
+
 	if (mvm->fast_resume)
 		return;
 
@@ -2942,6 +2942,11 @@ static bool iwl_mvm_wait_d3_notif(struct iwl_notif_wait_data *notif_wait,
 	case WIDE_ID(PROT_OFFLOAD_GROUP, D3_END_NOTIFICATION): {
 		struct iwl_d3_end_notif *notif = (void *)pkt->data;
 
+		if (len < sizeof(*notif)) {
+			IWL_ERR(mvm, "Invalid D3 end notification size\n");
+			break;
+		}
+
 		d3_data->d3_end_flags = __le32_to_cpu(notif->flags);
 		d3_data->notif_received |= IWL_D3_NOTIF_D3_END_NOTIF;
 
-- 
2.34.1

