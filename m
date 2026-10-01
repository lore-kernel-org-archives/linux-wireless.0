Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647AD50E594
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860732; cv=none; b=R0f2NA0JZhXKsNcC1NXM1J0GQwn37VIPBZkJrR9OCxk2KnbzN+ab3kdy09jtPzqdyD/lOFdNRX4UyVGreaIk/NfUtQhBaEXmOIf/R4nD+7ITidsA9SEAGkelnJAoyUVZYZbwfqE6U4/ba5Ono/82CdSzyLdXUnT1BX9ATmLyPZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860732; c=relaxed/simple;
	bh=3zQpX4OyZfcjksLzRfJ8GDo5bsj2vsKOCzWhR+f8oMA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TV3o2NXDWXkzAVNoZveuXUYLHuBY/gWamyyJK11nhbr5ivP4gSY2hZvWniA7lkagmhN0yDd7ipbD7okwvyw6nMLaTj6eYYwKOuzODhzv1bxtnbDgH+azF3ZGBL19d7IFP28ib1mzna0lwlb4ih9OYN2WxwVdbcnggPwQ/DKZeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XxxLcgBX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XxxLcgBX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860729; x=1822396729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3zQpX4OyZfcjksLzRfJ8GDo5bsj2vsKOCzWhR+f8oMA=;
  b=XxxLcgBXexdhSrbSJwz36B4InJGEmfv+zIFbLu9SRDKXOxqSQUL709h6
   xP2/LO+M/wO/5BKaJQS9fincoNEcURwgiQUKoPBumevJ1fXInNc1j6BYe
   IjCBemo91NB8Ej6EjYzqCMqWBpjRTqKWgDoUkXdcWy3HppYvHZHUR1xBj
   ky43ex9Lahtv4KHvbyhS71d0v8gF+pDbcnxuatZgITrQ4U+G3VfQK5gxP
   6LxxlMpKZp39wLQ+nAdIb0SyTYqUnNeHD3maA8UMNDDIsp4KgoHQUoqyo
   +g6Rswxev9n2KVyQggyYtdSgFI6NfvL+aYY05phnz300MSlRupVTmMFO6
   g==;
X-CSE-ConnectionGUID: 2v+5E0P7T0iJ7xAqS9neHQ==
X-CSE-MsgGUID: 8AAzZnw5TD+9fhd6TwRKkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423639"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423639"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:48 -0700
X-CSE-ConnectionGUID: k8B5iVrBRcOOyYH9WAmkGA==
X-CSE-MsgGUID: QKY0H0SKRCe+5ASIPa3uoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485558"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:48 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: advertise UHR Co-BF support
Date: Thu,  1 Oct 2026 16:20:25 +0300
Message-Id: <20261001161715.6c5fc579f2d8.I0cdf7516e95181e31c33fde374216fb6bc8f4aa1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is supported by hardware, advertise it. We'll
have to separately work on enabling it in firmware
if the AP supports it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index ed2b094c1ad7..31badfa35f97 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -716,6 +716,7 @@ static const struct ieee80211_sband_iftype_data iwl_iftype_cap[] = {
 				      IEEE80211_UHR_MAC_CAP0_DPS_SUPP,
 				[1] = IEEE80211_UHR_MAC_CAP1_DUO_SUPP |
 				      IEEE80211_UHR_MAC_CAP1_DBE_SUPP,
+				[4] = IEEE80211_UHR_MAC_CAP4_CO_BF_SUPP,
 			},
 		},
 	},
-- 
2.34.1

