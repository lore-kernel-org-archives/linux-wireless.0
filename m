Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5F0455194
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124218; cv=none; b=D1woSKWf7l8vUOjSkzggDcaS801uy9ZthMLUNoq0p3qkA5UEAA+t8Ovk1pI/wwHX8mD1WPVeQHXz6QIRXdB7thQaCspESAEK0HtPF5DvRG1sB7nO2qJGuAnVzpVk6Dj4344dh9Sv0C7Tpy0Gf3FRv685Gk5MT9Dq9Cv1YHCszRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124218; c=relaxed/simple;
	bh=MKTRDQ71scpprDEmHfDkt0rVJHBwId3poCJj6CnqYf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adQck/nkZG8FzT79IGAP6NRBkDFt3YKCCXwtNPHQHptFElCDUXtf6LdRat03kzWF9XK7OTqKZDRszygxb677H+X8DSjKNwWgYRKP+w+Zuhx+NpsvszAyxHrWiV7urNxERz7906Zje41ncS86Z9JCeQhfyhqX4wQkZz11xOkK/9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjRXrThS; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjRXrThS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124216; x=1822660216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MKTRDQ71scpprDEmHfDkt0rVJHBwId3poCJj6CnqYf4=;
  b=fjRXrThSt1AUwfgPlqXiZV+4KUOtU99BJnC8HgkLZio3AvyeAVroKxL6
   3qhchjIEOyXn2dlKQSmOjPeumqLyhZSPaE7T4ga2sE0J5G6XmLiaOrQqq
   sQ3tEWyG8Epb2xWAU884lNjtX98Wnws44BpLQKIb4q3kpJ8SOYQo3DMq8
   44U9Qeu0AvlXUuiZq/V1mCZ1wwcJeEkNviQOhgiiLwvbnOrBluBQr0peA
   zrPxQcfcIDL1gRhFvnkPpFzki4S1+Zg8BYAlcp2hWvB2L99+IULWZKrBU
   LpdUQy1BDhFCpAMsoraBQf+0dorBDs2VY+0nSaai+R8b6R7+FSBLSo2xf
   w==;
X-CSE-ConnectionGUID: oS/QfnWtTwm8pNvexwd6/w==
X-CSE-MsgGUID: F9xTk8bASdyzbPiVMWcAQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591422"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591422"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:15 -0700
X-CSE-ConnectionGUID: RyD8jrcETzeYI09pbfy26w==
X-CSE-MsgGUID: /4bPpyqHT7KcCIzjXE9xmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576878"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:13 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v3 02/11] wifi: mac80211: nan: Update NAN configuration copy
Date: Mon,  5 Oct 2026 11:44:49 +0300
Message-ID: <20261005084458.3666739-3-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005084458.3666739-1-ilan.peer@intel.com>
References: <20261005084458.3666739-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Copy the Instant Communication flag when storing the NAN
configuration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd1a857c812d..eeab1b515e77 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -368,6 +368,7 @@ static int ieee80211_nan_conf_copy(struct cfg80211_nan_conf *dst,
 		dst->discovery_beacon_interval =
 			src->discovery_beacon_interval;
 		dst->enable_dw_notification = src->enable_dw_notification;
+		dst->instant_comm = src->instant_comm;
 		memcpy(&dst->band_cfgs, &src->band_cfgs,
 		       sizeof(dst->band_cfgs));
 
-- 
2.55.0

