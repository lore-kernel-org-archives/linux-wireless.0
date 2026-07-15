Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2EB4A2E01
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140102; cv=none; b=mOv7IpV74fTdFVjXyZdCthXtaVhs1dY97w6D98BaD+wFKDxlSdXGE3CUTt8RewWcgevL2Tlel0o2M29wogLwVludTJrhiJ0c+B65/6ePSCnohS9zLMxPz9gqGDyG1CL8wrL2CeXFfdbCRSbQmIvuXCcQ+VUAhHuRP/GzM21S4aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140102; c=relaxed/simple;
	bh=0n5d6rH8owVYTNJotomq8GtRn06QL74VEPsUpzFx/TY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oGZvQ0jHc7a2ogewfa9ZvpQbK6EhF1JgaW/IyAwMWhrz42t+qAvX+Fh8hrVU06rTLiXwCUyASCWOWVbL+gZR63NsnC+kF/gnHXq4qpGLjqVyGrQya6R5UR71hN1KkuAGqvV8jOhKmj1xPrSux0XcDOd0AyD5U2kOS4toMdox+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dVjHFPZP; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVjHFPZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784140092; x=1815676092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0n5d6rH8owVYTNJotomq8GtRn06QL74VEPsUpzFx/TY=;
  b=dVjHFPZPUUxKRdGj9Uh/Fru+8WPGPkThdCcIX3TXJoImnzr7Q9yJEPHl
   XZk/ksEikCfSLmrBrsWduiVf9YB6pn2i9iauMOBLgORfnbO8kqCMG/aPq
   eofgVNRJOZ+N1di2+GbvA4nWSjKpwWPgVatp6sBTVSwbqFw/5LlZooVZy
   NlnXWC2+PuP67Qm3dBxk+CBXnK/hD7UYrAA9M4KEqbjtzgCgfJM/y1b7y
   yVIR8P85yX4SlBAvC+EA94Mkxxik2zLLV0xfcHavIUp1pH+sZA2ieEbbv
   xv8tRSoI73km+iQWZlVB9fERzvzP7ZfQhwb9IKJia3ljGu7j4U+wSGd8K
   A==;
X-CSE-ConnectionGUID: 9USSmDJtSnqjfOQP5f6wtQ==
X-CSE-MsgGUID: kcFE2RXuTUe6WyB/1f65zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="107590195"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="107590195"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:28:08 -0700
X-CSE-ConnectionGUID: Ay8yt1vsTPm2h/J4pBZllQ==
X-CSE-MsgGUID: gCEKrX84Rc6+/fW6TJtqig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="249903315"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:28:07 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: mlme: read deauth reason_code after frame length check
Date: Wed, 15 Jul 2026 21:27:44 +0300
Message-Id: <20260715212706.c7e93bfe58b7.Ibeecb9a1feb4ae8f823d40257675deb2f6d822d1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715212706.db26604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid>
References: <20260715212706.db26604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid>
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
guaranteed to be present before it is accessed. Also replace the
open-coded 24 + 2 with the named constant IEEE80211_DEAUTH_FRAME_LEN
for clarity.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9e92337bb6f9..f180fcd477d0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5641,13 +5641,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason_code;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	if (len < 24 + 2)
+	if (len < IEEE80211_DEAUTH_FRAME_LEN)
 		return;
 
+	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
 		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
 		return;
-- 
2.34.1

