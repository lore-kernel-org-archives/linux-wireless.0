Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7CF443E36
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139112; cv=none; b=nEk1PAn2bz3TCR+YvmojJVzOl4qvQPWdYv4FA3YXZcQuV0iOXErVZZh395//EyZ9hbk9K6d2pOlSQod/RBDrhf+5KNvYOeIf3Qp1UX6b+yVYnOm44Ie2thYxjIBpR6JFflGjQc4VyAhl+BxMOaVA/s9vHSkfGW4r7yHAI4Fupr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139112; c=relaxed/simple;
	bh=QJ6x+PMvXamM8JOg9pmYAJEj1g1N2cgXZKQjiTgPwdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SywsjSGonfZ3U7bBLGs35wdjXub2VEQ7artEbaAO9xIrMEEz8q42yzNPDXFrcPc2k+uH8XWJHcC3inSBz6CPrPLcvLe54Kp+j9tIZRO4pknrccnmfts1T/Behicro7bNgNQHnZD/dG4ly8waIBU3MuozbQfdgCm2FZRLoxll1r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JGfeMrJN; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JGfeMrJN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784139112; x=1815675112;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QJ6x+PMvXamM8JOg9pmYAJEj1g1N2cgXZKQjiTgPwdQ=;
  b=JGfeMrJNuB9zvxQgeL1UwYcX5yMXXlfzNx87AgAafyh0eD8y5jR7SS6c
   CozynprtbSAizGNhJOuBU1IAi6VBgHapNWMgAXOyuKtcOO0vxOkPcpaxX
   gv36ijQ+RdF8LpVg4YxQ9i0at36/TkC/2dCYCOZ2uYQrVCz9gjHfQdm8p
   uj5MAhx7TCTdsLtXkuRuc9k6iKrtf/9TkN+mf2TbAlPO0XJgumS4DRpWE
   7xLcV0agKDoaEuGY2FLkhcz124K1KUyYXMwSanGeSLW6i2o9slbSbVi0G
   vK1eiPR11B+L6ThebM90Zazt3cz79E4RMirAg3TgI6YKFmKwR17xfJv1H
   A==;
X-CSE-ConnectionGUID: 1ULqzluzRY6yGxJpt8uwKg==
X-CSE-MsgGUID: qJu20wWZQeq8azua9HOCXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84829497"
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="84829497"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:11:51 -0700
X-CSE-ConnectionGUID: 8syNYC+HRPW0Ix0TbafMSw==
X-CSE-MsgGUID: 0YMoDxULRnWRnRMmKCWFGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="259835639"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:11:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: improve multi-BSSID profile continuation parser
Date: Wed, 15 Jul 2026 21:11:25 +0300
Message-Id: <20260715211048.04877081fd0a.I48f0135ba83dcc5f0b736b61f8f9e86ecc72583f@changeid>
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

The previous change from John Walker fixed the loop iteration,
but the code is written in a bad way. Pass the pointers needed
for the iteration to the function instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/scan.c | 49 +++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 05b7dc6b766c..e62b7dd2b7c2 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2403,12 +2403,11 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	return NULL;
 }
 
-static const struct element
-*cfg80211_get_profile_continuation(const u8 *ie, size_t ielen,
-				   const struct element *mbssid_elem,
-				   const struct element *sub_elem)
+static bool cfg80211_iter_profile_continuation(const u8 *ie, size_t ielen,
+					       const struct element **mbssid,
+					       const struct element **sub_elem)
 {
-	const u8 *mbssid_end = mbssid_elem->data + mbssid_elem->datalen;
+	const u8 *mbssid_end = (*mbssid)->data + (*mbssid)->datalen;
 	const struct element *next_mbssid;
 	const struct element *next_sub;
 
@@ -2420,30 +2419,34 @@ static const struct element
 	 * If it is not the last subelement in current MBSSID IE or there isn't
 	 * a next MBSSID IE - profile is complete.
 	*/
-	if ((sub_elem->data + sub_elem->datalen < mbssid_end - 1) ||
+	if (((*sub_elem)->data + (*sub_elem)->datalen < mbssid_end - 1) ||
 	    !next_mbssid)
-		return NULL;
+		return false;
 
-	/* For any length error, just return NULL */
+	/* For any length error, just return false to stop iteration */
 
 	if (next_mbssid->datalen < 4)
-		return NULL;
+		return false;
 
 	next_sub = (void *)&next_mbssid->data[1];
 
 	if (next_mbssid->data + next_mbssid->datalen <
 	    next_sub->data + next_sub->datalen)
-		return NULL;
+		return false;
 
 	if (next_sub->id != 0 || next_sub->datalen < 2)
-		return NULL;
+		return false;
 
 	/*
 	 * Check if the first element in the next sub element is a start
 	 * of a new profile
 	 */
-	return next_sub->data[0] == WLAN_EID_NON_TX_BSSID_CAP ?
-	       NULL : next_mbssid;
+	if (next_sub->data[0] == WLAN_EID_NON_TX_BSSID_CAP)
+		return false;
+
+	*mbssid = next_mbssid;
+	*sub_elem = next_sub;
+	return true;
 }
 
 size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
@@ -2452,26 +2455,20 @@ size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
 			      u8 *merged_ie, size_t max_copy_len)
 {
 	size_t copied_len = sub_elem->datalen;
-	const struct element *next_mbssid;
 
 	if (sub_elem->datalen > max_copy_len)
 		return 0;
 
 	memcpy(merged_ie, sub_elem->data, sub_elem->datalen);
 
-	while ((next_mbssid = cfg80211_get_profile_continuation(ie, ielen,
-								mbssid_elem,
-								sub_elem))) {
-		const struct element *next_sub = (void *)&next_mbssid->data[1];
-
-		if (copied_len + next_sub->datalen > max_copy_len)
+	while (cfg80211_iter_profile_continuation(ie, ielen,
+						  &mbssid_elem,
+						  &sub_elem)) {
+		if (copied_len + sub_elem->datalen > max_copy_len)
 			break;
-		memcpy(merged_ie + copied_len, next_sub->data,
-		       next_sub->datalen);
-		copied_len += next_sub->datalen;
-
-		mbssid_elem = next_mbssid;
-		sub_elem = next_sub;
+		memcpy(merged_ie + copied_len, sub_elem->data,
+		       sub_elem->datalen);
+		copied_len += sub_elem->datalen;
 	}
 
 	return copied_len;
-- 
2.34.1

