Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A76A432313
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716733; cv=none; b=OleRAMXvc7FDv++BjDOJouqsJ4p4S7x7NjkfpA3mkP5z0cXmAgTQ/IlsgBGky9IlnEBQHNRKZokW8TnHPk4Jrdg6pRZC5xTEImnjXRi7Ca8PLf81Mqw1NlbxIckEdNSv0zYVJPmA3IusZ5Jkib+xiZC9UiXdt1iHYhgkctVKWqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716733; c=relaxed/simple;
	bh=t28dlYdElkiutnN2epYvgKh/hrTVcfDuf+Q2Y9+hnIw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j5vY1RV3nupR/sSSx4p/0IDMvkeOrpXJLetfLlk38KD/WFo1P9SUNyDBw73tcDgGTmX5LZDLuTBOXsz8oXI/0WyfGxa5JiHDTfTqKc3Er9W2RLD/lS3e5iLfRJHZEHiNTh1Q7dE6fGN0gc7XgFWl0CyOlcTtFbLju0aH6gFCd7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QPrRVNzs; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPrRVNzs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716733; x=1823252733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t28dlYdElkiutnN2epYvgKh/hrTVcfDuf+Q2Y9+hnIw=;
  b=QPrRVNzsu66Pk+W+rlRVQ3oWHruNrRn4pf7dRPFyZL8XC7QE6QxfdL3D
   kw/jKyb52yvZc4Pj8Kf2FYJCezboeVc3+5pyDkm/dOCITr/7Q6Hb+cYca
   soU1+ooqUEo1QtA10tN/ly3pPuaoaHpmizDEJ4uOiQhM9VvKv+lEz3p6H
   5TUeZG51BdrCdq1yajpQsUTJnDH05iA4euEzBA6LKIBH5l8CUrSmOGCXk
   MsxcEHJFVW171kBwL/LmR80uFp7TVDIkRFD5lDyWfgK3HnPS2PChrKHpX
   9W5KmSmS+c0i4Ul4thiVjypNXTO9fkbLlah7jJIL0euOBZmaRLYjB+e+A
   g==;
X-CSE-ConnectionGUID: WIUBeipdSkKKt6R2LBZnvg==
X-CSE-MsgGUID: /8IE6U50TKGtIy6ENGUZng==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454183"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454183"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:33 -0700
X-CSE-ConnectionGUID: 5Z/p3nPuTdyuR7lqlRaSpQ==
X-CSE-MsgGUID: DHWMPnQYQ8yB+ir03qNNRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651014"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:31 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 09/13] wifi: iwlwifi: mld: fix const in iwl_mld_mu_mimo_iface_iterator
Date: Sun, 11 Oct 2026 14:07:10 +0300
Message-Id: <20261011140453.6acceb79b0ef.Ia22765206364220b115dd84eb1a16b5a979d9340@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_update_mu_groups() takes const u8 * pointers, and we
have const values, but remove the const which can lead to some
warnings with clang. Leave it const throughout.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/notif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index 570b0011fd9e..7d9416ecbf92 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -159,8 +159,8 @@ static void iwl_mld_mu_mimo_iface_iterator(void *_data, u8 *mac,
 		 * action frame, so no conversion is needed.
 		 */
 		ieee80211_update_mu_groups(vif, link_id,
-					   (u8 *)&notif->membership_status,
-					   (u8 *)&notif->user_position);
+					   (const u8 *)&notif->membership_status,
+					   (const u8 *)&notif->user_position);
 	}
 }
 
-- 
2.34.1

