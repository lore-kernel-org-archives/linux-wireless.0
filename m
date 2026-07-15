Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65E541F5DB
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138947; cv=none; b=BtumUP7h7MfKBjko1HNSFE2j2TJ0R9/m+crjrmbPQHIKvX0vdBwH4zmE5vq0GXVukN4MX269tJvkoq5GE4xPSC/xdQEkf4hEgi+11IMbldajc8hNNY8AqZMZnVO5C7bF4wXv1sTSg95ylFH57SPHeuXfYMS0MutoIkVw6AAKfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138947; c=relaxed/simple;
	bh=dxQoabGN+sa6mIUBg+BizfQOYpPrVWwtmKhKsPq8UFo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HagG9f5zwUanXLiE4G83V/YDqCDStEzGXoFa2cK5ZPkLwNakqbz1nvxfow5GbwzqHOorVH71QIzrfLBq1au2TUllb8UvBv1WuoAJ28I/jaOG55kA8bY5cDyxf1o1CMz4r6szfEw/GcBSbRTEixHvcwT1MLWGRrrsxLYEn8i6dCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AWO1Zy9t; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AWO1Zy9t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784138946; x=1815674946;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dxQoabGN+sa6mIUBg+BizfQOYpPrVWwtmKhKsPq8UFo=;
  b=AWO1Zy9tAR4V5YRyr5colCYcX7nN/zIPk8N/JyxuuztZ+Mm04WnHppUS
   dTnLUHWCkB2KGM1jYsIOKcAooJdt0FLe823Gal5QEnVXak9ctFKXVvtXg
   d2OD2ABeMa/IWnvXmXaMBDan9dBDVqXoGts73tzGp02vczX9gA49D0gDU
   FZiengu5gPfphOTJR9CacNwOcXoYv5zsoIUVEgujltUAasV+Was3wH8x2
   tOqNWejO/4C7EWMc6X9D4PNF2gbqd/yt4EuUWJ5Her/pqtwVW8IKi3fvD
   4/1dfsERg1KOy23g0Vfc7AtAqJsBfOAURz6Zls0mgaycxDeGtnhSOF/Jd
   Q==;
X-CSE-ConnectionGUID: FJyXvIv5QCmZ/IoD4K1DJQ==
X-CSE-MsgGUID: aKbh4lA+SgC5UAXq3gXxsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="107586271"
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="107586271"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:09:05 -0700
X-CSE-ConnectionGUID: Z0/ROb9iTpKc0NblV9dGKQ==
X-CSE-MsgGUID: xjXreSxVTHO7KG3GZ6rBtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="252850615"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:08:55 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: use UHR operation field presence bits
Date: Wed, 15 Jul 2026 21:08:34 +0300
Message-Id: <20260715210407.3b1a79b0d002.Iaa762c55b4b6dc63d55f2d7b8b42acd47e640d50@changeid>
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

The spec originally had the idea that the fact that it's
a beacon frame determines the (non-)presence of the values,
but added presence bits in D1.4. Use those presence bits in
addition to the enable bits.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/linux/ieee80211-uhr.h | 44 +++++++++++++++++------------------
 net/mac80211/mlme.c           |  3 +--
 net/mac80211/parse.c          |  4 +---
 net/wireless/nl80211.c        |  2 +-
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 597c9e559261..665d4b3a5b41 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -17,6 +17,11 @@
 #define IEEE80211_UHR_OPER_PARAMS_PEDCA_ENA		0x0004
 #define IEEE80211_UHR_OPER_PARAMS_DBE_ENA		0x0008
 #define IEEE80211_UHR_OPER_PARAMS_DBE_BW		0x0070
+#define IEEE80211_UHR_OPER_PARAMS_DUO_PRES		0x0080
+#define IEEE80211_UHR_OPER_PARAMS_DPS_PRES		0x0100
+#define IEEE80211_UHR_OPER_PARAMS_NPCA_PRES		0x0200
+#define IEEE80211_UHR_OPER_PARAMS_PEDCA_PRES		0x0400
+#define IEEE80211_UHR_OPER_PARAMS_DBE_PRES		0x0800
 
 struct ieee80211_uhr_operation {
 	__le16 params;
@@ -265,8 +270,7 @@ struct ieee80211_uhr_p_edca_info {
 	__le16 params;
 } __packed;
 
-static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len,
-					      bool beacon)
+static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len)
 {
 	const struct ieee80211_uhr_operation *oper = (const void *)data;
 	u8 needed = sizeof(*oper);
@@ -274,19 +278,15 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len,
 	if (len < needed)
 		return false;
 
-	/* nothing else present in beacons */
-	if (beacon)
-		return true;
-
 	/* DPS Operation Parameters (fixed 4 bytes) */
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_ENA)) {
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_PRES)) {
 		needed += sizeof(struct ieee80211_uhr_dps_info);
 		if (len < needed)
 			return false;
 	}
 
 	/* NPCA Operation Parameters (fixed 4 bytes + optional 2 bytes) */
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_ENA)) {
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_PRES)) {
 		const struct ieee80211_uhr_npca_info *npca =
 			(const void *)(data + needed);
 
@@ -303,14 +303,14 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len,
 	}
 
 	/* P-EDCA Operation Parameters (fixed 3 bytes) */
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_PEDCA_ENA)) {
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_PEDCA_PRES)) {
 		needed += sizeof(struct ieee80211_uhr_p_edca_info);
 		if (len < needed)
 			return false;
 	}
 
 	/* DBE Operation Parameters (fixed 1 byte + optional 2 bytes) */
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DBE_ENA)) {
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DBE_PRES)) {
 		const struct ieee80211_uhr_dbe_info *dbe =
 			(const void *)(data + needed);
 
@@ -329,19 +329,19 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len,
 	return len >= needed;
 }
 
-/*
- * Note: cannot call this on the element coming from a beacon,
- * must ensure ieee80211_uhr_oper_size_ok(..., false) first
- */
+/* Note: must ensure ieee80211_uhr_oper_size_ok(...) first */
 static inline const struct ieee80211_uhr_npca_info *
 ieee80211_uhr_npca_info(const struct ieee80211_uhr_operation *oper)
 {
 	const u8 *pos = oper->variable;
 
+	if (!(oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_PRES)))
+		return NULL;
+
 	if (!(oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_ENA)))
 		return NULL;
 
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_ENA))
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_PRES))
 		pos += sizeof(struct ieee80211_uhr_dps_info);
 
 	return (const void *)pos;
@@ -360,22 +360,22 @@ ieee80211_uhr_npca_dis_subch_bitmap(const struct ieee80211_uhr_operation *oper)
 	return npca->dis_subch_bmap;
 }
 
-/*
- * Note: cannot call this on the element coming from a beacon,
- * must ensure ieee80211_uhr_oper_size_ok(..., false) first
- */
+/* Note: must ensure ieee80211_uhr_oper_size_ok(...) first */
 static inline const struct ieee80211_uhr_dbe_info *
 ieee80211_uhr_oper_dbe_info(const struct ieee80211_uhr_operation *oper)
 {
 	const u8 *pos = oper->variable;
 
+	if (!(oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DBE_PRES)))
+		return NULL;
+
 	if (!(oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DBE_ENA)))
 		return NULL;
 
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_ENA))
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_PRES))
 		pos += sizeof(struct ieee80211_uhr_dps_info);
 
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_ENA)) {
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_PRES)) {
 		const struct ieee80211_uhr_npca_info *npca = (const void *)pos;
 
 		pos += sizeof(*npca);
@@ -383,7 +383,7 @@ ieee80211_uhr_oper_dbe_info(const struct ieee80211_uhr_operation *oper)
 			pos += sizeof(npca->dis_subch_bmap[0]);
 	}
 
-	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_PEDCA_ENA))
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_PEDCA_PRES))
 		pos += sizeof(struct ieee80211_uhr_p_edca_info);
 
 	return (const void *)pos;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9e92337bb6f9..4ad5e9497323 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1701,8 +1701,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 	if (stype != IEEE80211_STYPE_BEACON &&
 	    chanreq.oper.npca_chan && elems->uhr_operation &&
 	    ieee80211_uhr_oper_size_ok((const void *)elems->uhr_operation,
-				       elems->uhr_operation_len,
-				       false)) {
+				       elems->uhr_operation_len)) {
 		const struct ieee80211_uhr_npca_info *npca;
 		struct ieee80211_bss_npca_params params = {};
 
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index c2f2f78f2b4f..cb2be167cde7 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -209,9 +209,7 @@ ieee80211_parse_extension_element(u32 *crc,
 		if (params->mode < IEEE80211_CONN_MODE_UHR)
 			break;
 		calc_crc = true;
-		if (ieee80211_uhr_oper_size_ok(data, len,
-					       params->type == (IEEE80211_FTYPE_MGMT |
-								IEEE80211_STYPE_BEACON))) {
+		if (ieee80211_uhr_oper_size_ok(data, len)) {
 			elems->uhr_operation = data;
 			elems->uhr_operation_len = len;
 		}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 242071ad10d6..5fa70974d57c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -441,7 +441,7 @@ static int validate_uhr_operation(const struct nlattr *attr,
 	const u8 *data = nla_data(attr);
 	unsigned int len = nla_len(attr);
 
-	if (!ieee80211_uhr_oper_size_ok(data, len, false))
+	if (!ieee80211_uhr_oper_size_ok(data, len))
 		return -EINVAL;
 	return 0;
 }
-- 
2.34.1

