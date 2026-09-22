Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE4051D537
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790074352; cv=none; b=rq+pBYo9OtE802DhVpCn5daQaSbI1GpiqfElpdyIo+laM8Wb3KafHhthyJiyKfTvBGsDeYJ8kAa15mGvIVoAkVkH8sCBp2HC/tkCNtyqooJnDDhbN1kZdIYY+wQsxcCP718Ts2Zoz5hl42EmmEJ6eiPaV4prJJD7j99b8nc5QSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790074352; c=relaxed/simple;
	bh=pq6AVtR4ORZk5ZcSJKstVuSi7EmOFeHL+4+9G+hZ6H4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AqqTtehd94skIOsn2QIcaNRdI/VmxsLonCnZQMa5e/SNn1TTj0aOQHD8k2qXt+xmWOspm62O9Q2Lof/g0zR92iNYwJpDiONdOJY6Xlp0vJU7oY5mekxvE6v9M8P+Vqx0UwLkfyjxCpmKD8w/LAZQAAHVFm++kwSnFk5oduERe2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JWHafIWa; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JWHafIWa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790074345; x=1821610345;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pq6AVtR4ORZk5ZcSJKstVuSi7EmOFeHL+4+9G+hZ6H4=;
  b=JWHafIWad9RhX1EWLem5y65vhAtIbFqj8ZKWAdgM8vzj2FpYeyJqWIT1
   fikCRKJ+Zj27R3IuAoMgGneGEujfKwGTibx+1yesmg+eS6ljUBXoIpFWZ
   R2xriehAhNGKOka1b5Kej+pw6qkUvRdrjOaMuWc747E/ZF45ckcBb3bnA
   OQrLLb7t04j2FVEwPrV7vpkgHSNWFVBE5hZhceHE2PpWir6dYlrPmJfco
   aXl0UH52VK5KdwbXDB4Wxeq1LOM21oJPZ3g6bpaZeuxOxTHxaiYJs1aYW
   e1Icn6+Ng0l+MKUQPTVzU1w6isX1jxtcHhdQIqCXdSOEGn1l7EZYFLxQ1
   A==;
X-CSE-ConnectionGUID: Ga8p/dPaSxWN/olFOE1vRA==
X-CSE-MsgGUID: AiAmHAo9RD+doHyIE9MIOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90533696"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="90533696"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:52:20 -0700
X-CSE-ConnectionGUID: ed1l9JT1QlKZ6gCyFUcXug==
X-CSE-MsgGUID: Cva9gx48RIeON7mz7Lw6bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="4186376"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:52:19 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 wireless-next] wifi: ieee80211: update DBE capabilities to D1.5
Date: Tue, 22 Sep 2026 13:54:18 +0300
Message-Id: <20260922133732.33dcc5dd3aa3.I208b63de3b6b829b2b03918395a5b069df0344a0@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Despite asking for some of this to be changed in the spec
(the addition of the additional per-160/320 capabilities)
I forgot to include this in the D1.5 update. Fix it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/linux/ieee80211-uhr.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 665d4b3a5b41..c46cd1689f91 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -427,10 +427,21 @@ ieee80211_uhr_oper_dbe_info(const struct ieee80211_uhr_operation *oper)
 #define IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_160_PRES	0x08
 #define IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_320_PRES	0x10
 
+/* struct ieee80211_uhr_cap_dbe::bwcap[].cap */
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_NUM_SND_DIMS		0x07
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_NON_OFDMA_UL_MUMIMO	0x08
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_MU_BEAMFORMER		0x10
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_BEAMFORMEE_SS		0xe0
+
 struct ieee80211_uhr_cap_dbe {
 	u8 cap;
+	u8 max_switch_time_period;
+	u8 mode_change_intvl;
 	/* present 0, 1 or 2 times depending on _PRES bits */
-	struct ieee80211_eht_mcs_nss_supp_bw eht_mcs_map[];
+	struct {
+		struct ieee80211_eht_mcs_nss_supp_bw eht_mcs_map;
+		u8 cap;
+	} __packed bwcap[];
 } __packed;
 
 /**
@@ -520,10 +531,10 @@ static inline bool ieee80211_uhr_capa_size_ok(const u8 *data, u8 len,
 		dbe = (const void *)cap->variable;
 
 		if (dbe->cap & IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_160_PRES)
-			needed += sizeof(dbe->eht_mcs_map[0]);
+			needed += sizeof(dbe->bwcap[0]);
 
 		if (dbe->cap & IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_320_PRES)
-			needed += sizeof(dbe->eht_mcs_map[0]);
+			needed += sizeof(dbe->bwcap[0]);
 	}
 
 	return len >= needed;
-- 
2.34.1

