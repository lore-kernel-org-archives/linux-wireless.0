Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D3455601
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124224; cv=none; b=Ak9367OGi0D7XNeh6Dt54poALKQRQTKSbWfxILrbXtaE2s4LargbNskXsfQuySZebjDeKNsELRXN1Y9ZfQm2h5TBoaDh/02SiFjyK6O7NLQB6MDejuNSUV7MIZZzcKKv0IzkhnUJam4hrKsy76VakLOSly4gWfpLAbBFleYDQok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124224; c=relaxed/simple;
	bh=mOgBICNgpTUljn4oqy8MHXnmaPwZWeGCdfBhI2BY/u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iblOT3GRo1TMW61aqyC5DiZf5+pErfBrSAkLwnKeV23dtgLRTo3Qdvr6K9VOdqHWPv9TXkfhuivb3FWz7JxWJPc17uuKbmW7rfUvTS26QNoyrERqRLGrAeY/2eSbKGQ5xb1IOgqcNFtAmkdJi27qOn3L6/eEwJfwxTM2InWbzEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D0J2cxnp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D0J2cxnp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124224; x=1822660224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mOgBICNgpTUljn4oqy8MHXnmaPwZWeGCdfBhI2BY/u8=;
  b=D0J2cxnpZh0sXWAFrvPEnbdz+nOhHVf6qsDQ9G0/QFFnfQxzjCX8Rfsn
   U6KNdUuJ+1GT7mkc6qerqIZG3j6WRruLpjujctxAVC4FuJHDbd6ec3zcX
   ead4cL+vsXZJ0kaJPrvyEb4zGjTCl2nLNV3wMOHKT33klidQZQKGEm9In
   8gKv1urQfaIG/XHlrEvFEZcZWMtqbmBQiKwpRim/9FKeiGHnzoZN+QqYC
   ogxaC8TDYWHyobKooui7rjI1G2KE1ZE32fGrr4V06UH/9Nal02qLK2xq6
   WQsF3iPxQrCHsREW+Fh6DGnv2MHTcApwCYIbVk+eJzTEuM/jrMG4cQkzh
   A==;
X-CSE-ConnectionGUID: CDXX/SJxTtCTiwHoKO7psQ==
X-CSE-MsgGUID: hakzWoMtQDSPX3IWtE6vpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591436"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591436"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:24 -0700
X-CSE-ConnectionGUID: +5Wn+Q7hQye/f3tqNnCobQ==
X-CSE-MsgGUID: q5ujxwi9TI6oSfl6YeQYYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576909"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:22 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v3 08/11] wifi: mac80211_hwsim: nan: use ieee80211_is_nan_beacon() helper
Date: Mon,  5 Oct 2026 11:44:55 +0300
Message-ID: <20261005084458.3666739-9-ilan.peer@intel.com>
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
2.55.0

