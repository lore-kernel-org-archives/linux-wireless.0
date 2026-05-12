Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599AC35CB6E
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614505; cv=none; b=UJWjOWHX8uESu7JiyJ+aE1VQTSYTVT3I8WRF/GTnNqO2vScgpUbMr3ODohK+Ehi1j4jZCkctmhwOUuqPQVj3Zzj1Kef3uYx44gQMe1CxE6/ItehRZqBhSBPt7HYWyiY6QuBo/oPzPTaH4UrfVjBX/9MZB1Tk8CO0XZIyI7Q+jj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614505; c=relaxed/simple;
	bh=rseA4VrTKVm6JOzpfBa2KAveYjN2XKTDyc7AchY8wD4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DUzOBPvegPxto8wJES+fTUh+oBKYa1wa0ySgjILoAzDpacSmUjfBoFvIhtQtfTsmDB5wJaFKb94TMYbv5wIUcf8p6K92wqlRWxdglvW8lFVxUkoUB0ZuJhbjJsp/uMLAVDGyHovunzKm81v8OoUlPKdEM+hmA2yqtj+ao+2oh7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QHuRXm2k; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QHuRXm2k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778614504; x=1810150504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rseA4VrTKVm6JOzpfBa2KAveYjN2XKTDyc7AchY8wD4=;
  b=QHuRXm2kjHzHaVxRxC/HQFGfRU5A8BpaE6Du+PPhzjr3afZShDGXIQMz
   z54tZDD1rKGMKAbnhPj9CzI9MlHCrQnMKREIP6wCCPwcFCamOFVaXLz7f
   3eTxz2Pg3CyjntXPb5ZaviG476FguePh+oPdXH7PIPROspNmT8gVbeIM3
   cH46SvHlTR7WKSQiJpOAF3Px5jlrCdTFIpjVmPOlI9nsxkyCKktlHLBjZ
   s89FVaSN9MdIUl5kn7dlC6XYm3+ciAOGO8IzFrrffqSRScgI0J7QiCtVn
   0yEkS32CvJN8cCM02x+P8eq3ZWzn2gqAdIJZar4Sl04zjo+0KbNjl2ckg
   A==;
X-CSE-ConnectionGUID: 3wicFzPTRwOXMcl/K1NBjg==
X-CSE-MsgGUID: bWGddiiFQZyMuvI9CXPZqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83148789"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="83148789"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:35:04 -0700
X-CSE-ConnectionGUID: N0AV7+SjR1uuWLJF5YjDAQ==
X-CSE-MsgGUID: tc6+5371RECFsPxY3Ms+Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="231471764"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:35:03 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: mld: add NULL check for channel in DW end handler
Date: Tue, 12 May 2026 22:34:34 +0300
Message-Id: <20260512222731.a250203cd1c6.I1d807aab415da30a55dd89a974c3226adc547ebb@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512193441.2352467-1-miriam.rachel.korenblit@intel.com>
References: <20260512193441.2352467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

ieee80211_get_channel() can return NULL if the frequency is not
registered in the wiphy (e.g. due to regulatory domain restrictions).
The returned channel pointer is passed directly to
cfg80211_next_nan_dw_notif() which dereferences it unconditionally
in both the tracepoint and the netlink message, causing a NULL
pointer dereference.

Add a NULL check before using the channel pointer.

Fixes: 600941464991 ("wifi: iwlwifi: mld: Declare support for NAN capabilities")
Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/nan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/nan.c b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
index 264ea7a9a896..deb72e401e3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/nan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
@@ -305,6 +305,9 @@ void iwl_mld_handle_nan_dw_end_notif(struct iwl_mld *mld,
 		return;
 	}
 
+	if (WARN_ON_ONCE(!chan))
+		return;
+
 	wdev = ieee80211_vif_to_wdev(mld->nan_device_vif);
 	cfg80211_next_nan_dw_notif(wdev, chan, GFP_KERNEL);
 }
-- 
2.34.1

