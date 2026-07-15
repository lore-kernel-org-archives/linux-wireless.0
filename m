Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EAF446076
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142314; cv=none; b=UcpA80BvHWEPXRxtiKYRFxonIumqQB2c9ow8Yh/73dyh67dxTU3GN76P5otN85l3hzAkkxsJ9lkKlePz9maslRyUmU/jFLqzaVuPz1i0SD93sFZ9JhqinCR6vuhKs9JLHt8+WUH1KObiun3wkrJSQ9PTZ/wzXr8G3896mODzJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142314; c=relaxed/simple;
	bh=YfEfdZXC3j4iH6bxvMw4RKOmDhVxKXDh0vEM+VV9QHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qfq/ncnMkuQQdX6Kq+80+1nxGj408eIQEq/JPT2IvRQTDatza7PUcqL9lQyCmdqCuHOoDDH7y5IFsr6nsUv7LiSLmLW3Pan2kS7soC3VnOD3Vn18E0ryAH4SFCLPHuvrCYqdc40djz5CoAmHJj93B6mMCqBCsAm11PWNfk5c+a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q01RAPnV; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q01RAPnV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142299; x=1815678299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YfEfdZXC3j4iH6bxvMw4RKOmDhVxKXDh0vEM+VV9QHY=;
  b=Q01RAPnVSR1+XMLnEyNmJaASjIuS4Hff1X4vdyh7bTUGDR+kI5qcX89W
   D9XNxBMP0gcZmlDnNCD8WSU3QNxASYicDQsAlUrAkujQ+9PJt73fvQpvq
   xKaUy9VRRQGoFiKU2UElUFQ0MSys8aNCpX8ZBJBRu4rwgNPh44tkZwM0M
   1kAy4jIgL3rsP7MUKfkdc25eRVMAltRZ75PA/YN6AdJ3B+bE4Kq33Tro0
   sXSQ/r+9kHQKu8aY1l/ES+nH/cFyoQAnMldBa5JQUT7girEgwjWZqqxuQ
   L2nKoYpIVFUFBTIpahhwTvN50+nBUy41QI4MLe1tsKYFNxWGDqB8yTVPF
   w==;
X-CSE-ConnectionGUID: mYwbGOq0TPW0LAQmMYM6eA==
X-CSE-MsgGUID: 5Xzy1F6aQcyzmlFSKPhIlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340693"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340693"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:56 -0700
X-CSE-ConnectionGUID: fw0Br5IrQwmKq3rL0LZQnA==
X-CSE-MsgGUID: LQ7CiLgqQhGac+6spy1PZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851904"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:54 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: mld: validate WoWLAN notif header
Date: Wed, 15 Jul 2026 22:04:18 +0300
Message-Id: <20260715220243.9c33c20194ad.I691d019927cc56898f2516fcf5795c8b1fae362c@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Validate fixed wowlan_info_notif header size first.
Only then read num_mlo_link_keys from pkt->data.
Apply this to v5 and v6 parsing paths.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 57 ++++++++++++++-------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index b5fed6090340..c9c0e3c729c9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -573,18 +573,42 @@ iwl_mld_convert_wowlan_notif_v5(const struct iwl_wowlan_info_notif_v5 *notif_v5,
 	}
 }
 
-static bool iwl_mld_validate_wowlan_notif_size(struct iwl_mld *mld,
-					       u32 len,
-					       u32 expected_len,
-					       u8 num_mlo_keys,
+static bool iwl_mld_validate_wowlan_notif_size(struct iwl_mld *mld, u32 len,
+					       const void *notif_data,
 					       int version)
 {
 	u32 len_with_mlo_keys;
+	u32 expected_len;
+	u8 num_mlo_keys;
 
-	if (IWL_FW_CHECK(mld, len < expected_len,
-			 "Invalid wowlan_info_notif v%d (expected=%u got=%u)\n",
-			 version, expected_len, len))
+	/* Extract num_mlo_keys from the void pointer based on version */
+	if (version == 5) {
+		const struct iwl_wowlan_info_notif_v5 *notif_v5 = notif_data;
+
+		expected_len = sizeof(*notif_v5);
+
+		if (IWL_FW_CHECK(mld, len < expected_len,
+				 "Invalid wowlan_info_notif v5 (expected=%u got=%u)\n",
+				 expected_len, len))
+			return false;
+
+		num_mlo_keys = notif_v5->num_mlo_link_keys;
+	} else if (version == 6) {
+		const struct iwl_wowlan_info_notif *notif = notif_data;
+
+		expected_len = sizeof(*notif);
+
+		if (IWL_FW_CHECK(mld, len < expected_len,
+				 "Invalid wowlan_info_notif v6 (expected=%u got=%u)\n",
+				 expected_len, len))
+			return false;
+
+		num_mlo_keys = notif->num_mlo_link_keys;
+	} else {
+		IWL_WARN(mld, "Unsupported wowlan_info_notif version %d\n",
+			 version);
 		return false;
+	}
 
 	len_with_mlo_keys = expected_len +
 		(num_mlo_keys * sizeof(struct iwl_wowlan_mlo_gtk));
@@ -616,16 +640,14 @@ iwl_mld_handle_wowlan_info_notif(struct iwl_mld *mld,
 
 	if (wowlan_info_ver == 5) {
 		/* v5 format - validate before conversion */
-		const struct iwl_wowlan_info_notif_v5 *notif_v5 = (void *)pkt->data;
+		const struct iwl_wowlan_info_notif_v5 *_notif =
+			(void *)pkt->data;
 
-		if (!iwl_mld_validate_wowlan_notif_size(mld, len,
-							sizeof(*notif_v5),
-							notif_v5->num_mlo_link_keys,
-							5))
+		if (!iwl_mld_validate_wowlan_notif_size(mld, len, _notif, 5))
 			return true;
 
 		converted_notif = kzalloc_flex(*converted_notif, mlo_gtks,
-					       notif_v5->num_mlo_link_keys,
+					       _notif->num_mlo_link_keys,
 					       GFP_ATOMIC);
 		if (!converted_notif) {
 			IWL_ERR(mld,
@@ -633,15 +655,12 @@ iwl_mld_handle_wowlan_info_notif(struct iwl_mld *mld,
 			return true;
 		}
 
-		iwl_mld_convert_wowlan_notif_v5(notif_v5,
-						converted_notif);
+		iwl_mld_convert_wowlan_notif_v5(_notif, converted_notif);
 		notif = converted_notif;
 	} else if (wowlan_info_ver == 6) {
 		notif = (void *)pkt->data;
-		if (!iwl_mld_validate_wowlan_notif_size(mld, len,
-							sizeof(*notif),
-							notif->num_mlo_link_keys,
-							6))
+
+		if (!iwl_mld_validate_wowlan_notif_size(mld, len, notif, 6))
 			return true;
 	} else {
 		/* smaller versions are not supported */
-- 
2.34.1

