Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B363FC5DD
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861492; cv=none; b=g4RvihHkLoWnGBKsmjG8l87usGb8jGhVQQLl8dKY0qF+vpY8EbL4jeRgxpJRABUAZvGoGW7LvbVdritDLuFzyyXWdqC7a8+yg2mUn2vjd69G7XmzBNOep3GsBJZZN1tWit2r2HgTvpNhifdYJc+/A4NeMTUjMpMtaKXus2Vj+xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861492; c=relaxed/simple;
	bh=0b1YVKaPOaxE8IN/ykeJkOh3KlVqzUv+nOkosYRt5Yw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OD4FraOQJGoUrj7C2oMhg/JBLZ7Z/ojgGRyewA70rt+OPWBEYc/kkYqTlqLLLFvaMZjphb1AmrnqzQgkTE5Vuf+2Enc/vy4ifPqRdUnfUP7i9Ym2ZnEAy8SCpfg7D4pRSSCJ6KKQ9/Ql3I0Q9lkWqVvKrBNbvevoaKx4WN15cFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnsE2Z3N; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnsE2Z3N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861488; x=1822397488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0b1YVKaPOaxE8IN/ykeJkOh3KlVqzUv+nOkosYRt5Yw=;
  b=LnsE2Z3NeGssTRblkphQSKd/81LLCwPj7pLO4ZPlfZGcGLtty8l0u9k+
   +FJkfjMmf+LJ40HdmQv3IlLlrSM4mQQ+aCGD7JU6y5rbfYgQ+boDS5o3T
   fOf3zxHAGIudAAHi5ElH9mHGUj2nRwnIrciiSwVC4lAUaX+mSEpOFi+iJ
   F9zmOjxZenIGOEnPeORnQ0UyIaze7xgrXU+XdK3eziHMr2yLJF9nVfdhD
   wdjZcra8KO4TiKnnB/I/xRgYl+NsimOHz0taNyrO8wySwqs7ZKlxOQI2E
   6ADG6yTufBtCnX1dC0kg/oQ3OaUrzClZ0qVNnde5dBDGgEyij32wWv1CG
   g==;
X-CSE-ConnectionGUID: RmwQQsBFSbCm2ZYWKW5hWA==
X-CSE-MsgGUID: j29BMKFGR3WHYkb6LZoLeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750535"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750535"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:23 -0700
X-CSE-ConnectionGUID: u+iTQITcRVmFaMHqZHZmjQ==
X-CSE-MsgGUID: hF7Mmqm4QayOU3NylzVJSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26457"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:21 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 6/7] wifi: mac80211_hwsim: nan: use ieee80211_is_nan_beacon() helper
Date: Thu,  1 Oct 2026 16:33:10 +0300
Message-Id: <20261001162941.f926f9060f9d.Ib6dbab5e2740108a037f284b243fb456958a2f17@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

Use the new ieee80211_is_nan_beacon() helper to identify NAN beacons
instead of open-coding the cluster ID and vendor element checks.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_nan.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 2d9f6d7b9251..fab6bd9e3cfb 100644
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
2.34.1

