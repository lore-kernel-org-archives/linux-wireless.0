Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD32F3AEF53
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141868; cv=none; b=G24wGn3tjO8JqSdKCrN3HJBQMMLzgQU5nRT+J79IQKbxKufQO7hF7YdakMXW+kmMtPZN0n6l4hBfF4s7OqNla9h0W4fbkUrZeYfwPwQL8VwJRFYItZO4HeMtc/Ltv9vULhcepbiRR5xhabkJS9AmIA5gms5v7i3/y/w3L+vuf/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141868; c=relaxed/simple;
	bh=O01cXpMJDltC1YEh1Y60QPC014RwYE20v3qji5w59no=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WpsF0tgWQoZmoaooX9KuYFqknoJJ2x8I3vBS+ALuIkpFbap+TD6wQMU5g2PMl9faCYZo0/C13ZryYLuHS3zgh0HNTtOrWPYgxxQ+VuLMHjh/mzD4rvrYTCiu8cezU0eGoKhl7rdj49vDMxz0RONogDRA0gITJtf+cTZxR/ILYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Keyu0vtX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Keyu0vtX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141864; x=1815677864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O01cXpMJDltC1YEh1Y60QPC014RwYE20v3qji5w59no=;
  b=Keyu0vtXThcSkoBygYimxN+JNSLa34i6x9F0kuJUofh+qTibN13qC5D4
   FniJ+iSERL7bTGm7uB53J59eW51TzWybrW5Gs+/fz/yWgisftHVfdFkmo
   +PiOLWtum/HiuhnCqov5IVKSMNCnDSrQWo9VKbM+GoleIKJDUSX9/QDMz
   x7Efd2t3eVIX29eE/g2kB5r2hx3h1xkAjThoY+ot8x0WWVDZEQhhW2c4Q
   ndR9+rzHT4fg7YpsWS+yf1fC6IS4xYo+fU59ZTcTBpW6YJMsrt5u4N+4x
   I5zmEfBgThjFY60JT2z8pXyrBK8MZdJ6SDPnhBJvwzrW0fTiCuAi0QK+n
   Q==;
X-CSE-ConnectionGUID: zZgLtCFWQH6xDlTUFxRmww==
X-CSE-MsgGUID: nvd/i8fhTqeA+2FLHu+ftA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160881"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160881"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:38 -0700
X-CSE-ConnectionGUID: 3I3ue9SjR5+g2oLYeW7RZA==
X-CSE-MsgGUID: 7uK+XDeDQualJ7zaNE6rKg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:37 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 01/15] wifi: iwlwifi: mld: validate txq_id in TX response handler
Date: Wed, 15 Jul 2026 21:57:01 +0300
Message-Id: <20260715215523.b938c2dcf08d.I8a88ec359e229f1c41ac9c49fd9ce28a2b62b274@changeid>
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

Validate txq_id from TX response notification before passing to
iwl_trans_reclaim(). Other reclaim paths in this file perform this
check to prevent out-of-bounds access on malformed notifications.

Assisted-by: GitHubCopilot:claude-haiku-4.5
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 2185dade95f8..2df6643a5aa8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -1120,6 +1120,10 @@ void iwl_mld_handle_tx_resp_notif(struct iwl_mld *mld,
 	ssn = le32_to_cpup((__le32 *)agg_status +
 			   tx_resp->frame_count) & 0xFFFF;
 
+	if (IWL_FW_CHECK(mld, txq_id >= ARRAY_SIZE(mld->fw_id_to_txq),
+			 "Invalid txq id %d\n", txq_id))
+		return;
+
 	__skb_queue_head_init(&skbs);
 
 	/* we can free until ssn % q.n_bd not inclusive */
-- 
2.34.1

