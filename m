Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E3C246BCD
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298707; cv=none; b=iXzCa9sv1HchPmxaJURXI86plkL8TQs8SEBPvC3WbW8KExI1+zZIqkMYh8lRUi8RGfKkr5VmfydQoO8H5WrTiwx/7JmeVJAYDMP3mlX2H4etYxnqlNlIkt9VIZSxfrk8Svd1i+G2LuG0rk23jN0LwN9dk/+ihE0KDFcXFmyp1+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298707; c=relaxed/simple;
	bh=qeJL6cAZe4mOf4rpqhF9puyQ0mwIzxtTqTHrZnWgI4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bqe9yssMY6pN67NzaJK34IIbej8PyQR0lLLKE/AWMgj5FGPsaC7mKodtOVEBnX8yhnBxbBxQkCk8XqXS2mPA1V2DjEoEOFVz5li3goWYrHwTgP5Xyj2n2Mp2XhX9b4KRGa8+QR5EpRBkbBXA1vNYtZ4Wu9Q+8n6OjrDeDZ1G9uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NbYf0rMY; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NbYf0rMY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298705; x=1815834705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qeJL6cAZe4mOf4rpqhF9puyQ0mwIzxtTqTHrZnWgI4Q=;
  b=NbYf0rMY5hMIimczEBOC9qofsufrEhztTMrsuO640CcUr75NZHowf7tR
   DYxvdSay2n0PLgTswHFXtXilZXiy6EFd+0Eucj2Skfl7KvodAGRmU12ms
   dPn2exEjIjphT02unzQiXt8r/0HpigH7t7BshGiI0aUOfoC+NaRQRJo0L
   393C82kKjN72ABNDc56/LMR1OuTo5vZBpzSwmEMCkLX0s5EJUKP2iXTZ3
   SEjiVAVzdK/XU7EHKVWSoxwbFJy6sLGRUMKJnqJHtIRkaG4oLwDGi8yM9
   AEmU7acu5G/1nlBMBUR7tfLPsMSdngp/et27jxtnpop5Qwfsx4d71XMSa
   A==;
X-CSE-ConnectionGUID: UP+LdUdKRrm2lRs0S6QYHw==
X-CSE-MsgGUID: xdQlcRtZSb2JtHRdl+U+iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925999"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925999"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:45 -0700
X-CSE-ConnectionGUID: lpiGmFkXSymJPaR/iYkjXg==
X-CSE-MsgGUID: GO5xr6A/Reuz4VZqlYiL/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885744"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:43 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 6/8] wifi: iwlwifi: mld: support update_mcc notification v2
Date: Fri, 17 Jul 2026 17:31:10 +0300
Message-Id: <20260717172958.9c5a940d37dc.I955800c2377b802ffb99003349552cc4036ca4bd@changeid>
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

New firmware will support version 2 of the update_mcc notification. The
extra field is used for a new feature, but we does not support it.

Keep the existing payload definition compatible with both versions and
register version 2 in the MLD notification version table so the driver
accepts the newer notification without changing the behavior.

This preserves version 1 support and adds compatibility with firmware
that sends version 2.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mld/notif.c      | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 360b626a9572..9fbdb45e88db 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -411,7 +411,10 @@ struct iwl_mcc_chub_notif {
 	__le16 mcc;
 	u8 source_id;
 	u8 reserved1;
-} __packed; /* LAR_MCC_NOTIFY_S */
+} __packed;
+/* LAR_MCC_NOTIFY_S_VER_1
+ * LAR_MCC_NOTIFY_S_VER_2
+ */
 
 enum iwl_mcc_update_status {
 	MCC_RESP_NEW_CHAN_PROFILE,
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index b3a899828db9..90733bbaf733 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -298,7 +298,8 @@ CMD_VERSIONS(channel_survey_notif,
 CMD_VERSIONS(mfuart_notif,
 	     CMD_VER_ENTRY(2, iwl_mfuart_load_notif))
 CMD_VERSIONS(update_mcc,
-	     CMD_VER_ENTRY(1, iwl_mcc_chub_notif))
+	     CMD_VER_ENTRY(1, iwl_mcc_chub_notif)
+	     CMD_VER_ENTRY(2, iwl_mcc_chub_notif))
 CMD_VERSIONS(session_prot_notif,
 	     CMD_VER_ENTRY(3, iwl_session_prot_notif))
 CMD_VERSIONS(missed_beacon_notif,
-- 
2.34.1

