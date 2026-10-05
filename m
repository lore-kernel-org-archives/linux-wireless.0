Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE33905EC
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120380; cv=none; b=QiW4fJTK7bOPi6eYuAVzvnROscErQ2pCin49y7h5R0+zrKRNysny69PyJfB+/UJiOdx21G2iAofJnkmeEgfPYYq52cKWdE5VDb/yZ18OV8uKu7Xz167cyskV24lPCG5uZ4a6UyjRsGFEUAWrY3hymVxlN4KTRttFCXzQO00XCLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120380; c=relaxed/simple;
	bh=a6qJL4x4EYlgBmPyn1PTANTES4h0a8sIxtv90D8XzX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2tGRYfkgYNFO6iEJj3km6nv+NX4O1eaX9fW/KWKB3qsnREeb0g3bncSWvwABtNKTz8e+PxNZJHgeYKIIu6F1SHOgk8cPAzdZQ6aRGYjWwxwPXlH+zYP0qzC6auQpZgd86GDY2PBzirGcHkaUW82MW4KCdyWqflD5OdMmH7078s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jPqnJic1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jPqnJic1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120379; x=1822656379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a6qJL4x4EYlgBmPyn1PTANTES4h0a8sIxtv90D8XzX8=;
  b=jPqnJic1slN/MgLxutb1eNyf47SO/IGICuY+eEZ26Fp9RZp3DghF9aUm
   k7C/NG/TLAL5Uxy1uuMbnvyIZcrNNFDbHvBXv0eI5fguO1pkvacwuUQKe
   UPWcccG3QplSaa5QyRaBr1OOPTkxFlDbSGnVu3yV5mT9osscQv53zjrj8
   STk0VWckUfaW8kYBt9Ckbc08/f8VqLHl4bE2/rw8OoCtZk70Xyw4luhFJ
   339STSRGk1D1wI537HD5kBWM+J/Xae6PeHIVo6kgliWmfNoa4A9SuSlPG
   iAM4Wwrg+59+65ENbAL6k0los8WGZdBQ8pwqngEeWJWczJ6EqPa8fFQkf
   Q==;
X-CSE-ConnectionGUID: 1yQEmnt6RcmQcXUI3u8Law==
X-CSE-MsgGUID: 8p2oINlMSxSdkVYSd8MLKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328703"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328703"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:19 -0700
X-CSE-ConnectionGUID: ke8C8v/PQzWA5ytfdxnaMQ==
X-CSE-MsgGUID: L96/3f2fTwuqLdHyNf1ZEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569140"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:17 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 08/11] wifi: mac80211_hwsim: nan: use ieee80211_is_nan_beacon() helper
Date: Mon,  5 Oct 2026 10:40:33 +0300
Message-ID: <20261005074037.3506633-9-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005074037.3506633-1-ilan.peer@intel.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the new ieee80211_is_nan_beacon() helper to identify NAN beacons
instead of open-coding the cluster ID and vendor element checks.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_nan.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 7be64c45babf..f0732dd2eb79 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -230,9 +230,7 @@ void mac80211_hwsim_nan_rx(struct ieee80211_hw *hw,
 	ssize_t data_len;
 	u8 slot;
 
-	/* Need a NAN vendor element at the start */
-	if (skb->len < (offsetofend(struct ieee80211_mgmt, u.beacon) + 6) ||
-	    !ieee80211_is_beacon(mgmt->frame_control))
+	if (!ieee80211_is_nan_beacon(mgmt, skb->len))
 		return;
 
 	data_len = skb->len - offsetofend(struct ieee80211_mgmt, u.beacon);
@@ -279,17 +277,6 @@ void mac80211_hwsim_nan_rx(struct ieee80211_hw *hw,
 	if (rx_status.signal < NAN_RSSI_MIDDLE)
 		return;
 
-	/* Needs to be a valid NAN cluster ID in A3 */
-	if (get_unaligned_be32(mgmt->bssid) != ((WLAN_OUI_WFA << 8) | 0x01))
-		return;
-
-	/* We are only interested in NAN beacons */
-	if (nan_elem->id != WLAN_EID_VENDOR_SPECIFIC ||
-	    nan_elem->datalen < 4 ||
-	    get_unaligned_be32(nan_elem->data) !=
-	    (WLAN_OUI_WFA << 8 | WLAN_OUI_TYPE_WFA_NAN))
-		return;
-
 	u8 *nan_defragmented __free(kfree) = kzalloc(data_len, GFP_ATOMIC);
 	if (!nan_defragmented)
 		return;
-- 
2.55.0

