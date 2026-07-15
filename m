Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB173EC680
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142322; cv=none; b=CGxil0JstDantxFatxf1huSiyjLwNJRtBzklEB8gvP4Ps9r/4AzcXIphqbTrZOYEKOnW+U6AnsjS16xQQ7xK+qlBGlTaQu6RuqT1qu5ycrvRIIfLsoEBtVFP6aPac4AJ0MVem1rc5bKuwbTTnYJ8EVfJFNpYHtfUTsI6MfSGMpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142322; c=relaxed/simple;
	bh=Rs72pyUZG3MRsdN1fVdWyNx9wCkIvQZmyNEkqHbdWQI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZaVDfT1qqXg2ZVuPmMJRLWM+Us0sugkPGUZ3YYj1NhYM34jMilpfgEb+9FWmGCvgQUt9sDUq9X6tx3h1d+58l5Pf3e2K5U5XldaAPkAmcOi62Y7Up+2lfQmkCQclnZz6rYSQIQ0n3tZoAIJOSIcoYsG++sKgoolfNE4+0XAimOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oGog+SI7; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oGog+SI7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142311; x=1815678311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rs72pyUZG3MRsdN1fVdWyNx9wCkIvQZmyNEkqHbdWQI=;
  b=oGog+SI78bol06YE1nZvsUm0gLr5gq4wn7Ot4GS6O098/iZST+rHnBkA
   uQbvO5gnTmruBBbypDdfDibhcuUtbDMTgqJd//GN0uyY1sVJbz1fXP93m
   7nrHBxaf6OSAnO6jvBALowV10Tn+qzh2TPzVXOH4CNAk0cJg9Z3HBx8To
   SZp3ikKaiqwaCRAwXf0hh/6qJczc2CDfvR9tVFwI8mj95Kzj9gOI6P628
   ZfsP9SGhRREfGts/FWIE6lLk7Rwu/1tRzXwEDFDCv7DLnA7QTebeF9r78
   4AjJ7L6E7USVR3i5Eam/ww2yVC2ijx7GEcRuM7QFZ4qf/h2yhc73FBbQ9
   w==;
X-CSE-ConnectionGUID: J8kuWeVCRhGBBaC19W+YZw==
X-CSE-MsgGUID: x1mJkMsURsCjtw4uLOQnVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340711"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340711"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:00 -0700
X-CSE-ConnectionGUID: A6Qy809ISviXp3hG7FANNQ==
X-CSE-MsgGUID: hO2xjD/TSImrpJHFg27cwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851919"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: fix validation fallback in iwl_mld_notif_is_valid
Date: Wed, 15 Jul 2026 22:04:21 +0300
Message-Id: <20260715220243.e0b91efe689d.I7d7604be6819da263e9091370892e6b6f4c57913@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When a firmware notification version is not in the handler's
size table, iwl_mld_notif_is_valid() falls back to comparing
against the last known structure size but the comparison is
wrong: 'return size < last_known_size' returns true (accept)
for undersized payloads and false (reject) for payloads that
are large enough.

Instead of trying to accept notifications that are large enough,
just refuse the notification. We shouldn't ever get a
notification that is longer than what we expect.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/notif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index 7574689e4088..b3a899828db9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -517,7 +517,7 @@ iwl_mld_notif_is_valid(struct iwl_mld *mld, struct iwl_rx_packet *pkt,
 			    handler->cmd_id, notif_ver,
 			    handler->sizes[handler->n_sizes - 1].ver);
 
-	return size < handler->sizes[handler->n_sizes - 1].size;
+	return false;
 }
 
 struct iwl_async_handler_entry {
-- 
2.34.1

