Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F19431A2F
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140102; cv=none; b=TwN5XPVPRgzZ0/LT/EqivyCBD5CWnaLX8aPV8oaOxSuAEQBSjonyLKxEvCLZwnSJq2AtRQDPAXGlN8hgGag4oSkrUlhVoeCSeuedRJiqFfksK1+sPcD/GV6D6dXOz5lfphc0DQ9MnJ9RoL34ZUa/YBB1znrulkUV3T30TJykkxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140102; c=relaxed/simple;
	bh=vln2PFcCtlI5Msn1eLEkYGUfmrWnZealDVQ4x4jgZDs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=c6Nk/Y7HDw5xmh7kmV+gvgZSL4+oF+lKz9nnfd2w+0g/nYSxUlqZ/4qRBAuQPty8lozUqzVPoc+FOt9TdC/iu+mxTYEKbD+JQrOExMZ39qgLngrRQ5bjw4Dkv5i7t8BcOHHxls5exDLA3w1rKN7heQXp3rBH8PkxZjAGrVaMT8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RPWaS1n6; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RPWaS1n6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784140090; x=1815676090;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vln2PFcCtlI5Msn1eLEkYGUfmrWnZealDVQ4x4jgZDs=;
  b=RPWaS1n6JvGcNMNyQWMfhtMaYlOpwvNca70MnmGbJpv93IuqWjFaTTT0
   WFoZN77W4avtZ5k76uYgrRm2usfMwkC+ldvfU/KOeYi8oimB6f/Cx9pYh
   0Sazncf1xctUw7Rn2p+ME+TOmDwM9+V/+bZkSq0LCKAEezjpQNMf9PXj2
   NIWeTVdkBYPPEpFoioM64jhemLNKShGVjkV6naJMESgnLBT3zJjvrhRrM
   ZGisnKOi9067KM/OBU4SH/WYkOemkiruhI81YdQHo0Yl+v43ZS2/Q+KVg
   DIDLwPcUzTqnys3Px0hmW7OuQdBS3KpbgJl+oy/2bSAjCQRlBOZDe3pF+
   Q==;
X-CSE-ConnectionGUID: 2X/pBJVNSDCSgRsjbZItDQ==
X-CSE-MsgGUID: Q6qmXr1BS+uM2FZpMJ1pBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="107590188"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="107590188"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:28:07 -0700
X-CSE-ConnectionGUID: XRxXK1wxS2GkH9ZpWw0e2g==
X-CSE-MsgGUID: Gzk9ORzJTs23QZHSIkyb1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="249903310"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:28:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Wed, 15 Jul 2026 21:27:43 +0300
Message-Id: <20260715212706.db26604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The function was reading reason_code from the frame before validating
that the frame is at least IEEE80211_DEAUTH_FRAME_LEN bytes long.

Move the reason_code read to after the length check so the field is
guaranteed to be present before it is accessed.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/ibss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d0fd6054f182..9915dd5c36df 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -881,11 +881,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
 {
-	u16 reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason;
 
 	if (len < IEEE80211_DEAUTH_FRAME_LEN)
 		return;
 
+	reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	ibss_dbg(sdata, "RX DeAuth SA=%pM DA=%pM\n", mgmt->sa, mgmt->da);
 	ibss_dbg(sdata, "\tBSSID=%pM (reason: %d)\n", mgmt->bssid, reason);
 	sta_info_destroy_addr(sdata, mgmt->sa);
-- 
2.34.1

